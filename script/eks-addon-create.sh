#!/bin/bash

set -e

export CLUSTER_NAME=$(kubectl config view --minify --output 'jsonpath={.clusters[0].name}'| awk -F'/' '{print $2}')
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export NAMESPACE="kube-system"
export REGION="ap-northeast-2"
export ENVIRONMENT="stg"

#####################################################################################
# Metrics Server
# https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server
#####################################################################################
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm upgrade --install metrics-server metrics-server/metrics-server \
                             --namespace ${NAMESPACE} \
                             --set tolerations[0].key=CriticalAddonsOnly \
                             --set tolerations[0].operator=Exists \
                             --set tolerations[0].effect=NoSchedule

#####################################################################################
# AWS Load Balancer Controller
# https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/lbc-helm.html#lbc-helm-install
#####################################################################################
# Check if the IAM policy already exists
ALBC_POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
existing_policy_arn=$(aws iam list-policies --query "Policies[?PolicyName=='${POLICY_NAME}'].Arn" --output text)
if [ -z "$existing_policy_arn" ]; then
    # IAM Policy for AWS Load Balancer Controller
    curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json

    # Create IAM Policy for AWS Load Balancer Controller
    aws iam create-policy \
        --policy-name $ALBC_POLICY_NAME \
        --policy-document file://iam_policy.json
    echo "Policy ${ALBC_POLICY_NAME} has been created."
else
    echo "Policy ${ALBC_POLICY_NAME} already exists. Skipping creation."
fi

# Create Service Account for AWS Load Balancer Controller
eksctl create iamserviceaccount \
  --cluster=${CLUSTER_NAME} \
  --namespace=${NAMESPACE} \
  --name=aws-load-balancer-controller \
  --role-name "role-esp-${ENVIRONMENT}-albc" \
  --attach-policy-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

# Install AWS Load Balancer Controller
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
                             --namespace ${NAMESPACE} \
                             --set clusterName=${CLUSTER_NAME} \
                             --set serviceAccount.create=false \
                             --set serviceAccount.name=aws-load-balancer-controller \
                             --set tolerations[0].key=CriticalAddonsOnly \
                             --set tolerations[0].operator=Exists \
                             --set tolerations[0].effect=NoSchedule \
                             --set region=$REGION \
                             --set vpcId=$(aws eks describe-cluster --name $CLUSTER_NAME --query 'cluster.resourcesVpcConfig.vpcId' --output text)                      
                            #  --set replicaCount=1

#####################################################################################
# Karpenter
# https://karpenter.sh/docs/getting-started/getting-started-with-karpenter/
# https://github.com/aws/karpenter-provider-aws/blob/main/charts/karpenter/values.yaml
#####################################################################################
KARPENTER_VERSION="1.2.1"
TEMPOUT="$(mktemp)"

# To create the AWSServiceRoleForEC2Spot service-linked role for EC2 Spot Instances in your AWS account
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com

curl -fsSL https://raw.githubusercontent.com/aws/karpenter-provider-aws/v"${KARPENTER_VERSION}"/website/content/en/preview/getting-started/getting-started-with-karpenter/cloudformation.yaml  > "${TEMPOUT}" \
&& aws cloudformation deploy \
  --stack-name "Karpenter-${CLUSTER_NAME}" \
  --template-file "${TEMPOUT}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "ClusterName=${CLUSTER_NAME}"

eksctl create iamidentitymapping \
  --username system:node:{{EC2PrivateDNSName}} \
  --cluster ${CLUSTER_NAME} \
  --arn "arn:aws:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}" \
  --group system:bootstrappers \
  --group system:nodes

eksctl create iamserviceaccount \
  --cluster "${CLUSTER_NAME}" --name karpenter --namespace $NAMESPACE \
  --role-name "${CLUSTER_NAME}-karpenter" \
  --attach-policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerPolicy-${CLUSTER_NAME}" \
  --override-existing-serviceaccounts \
  --approve

# Logout of helm registry to perform an unauthenticated pull against the public ECR
helm registry logout public.ecr.aws
helm repo update
helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter --version "${KARPENTER_VERSION}" --namespace "${NAMESPACE}" \
  --set "settings.clusterName=${CLUSTER_NAME}" \
  --set "settings.interruptionQueue=${CLUSTER_NAME}" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=karpenter \
  --set tolerations[0].key=CriticalAddonsOnly \
  --set tolerations[0].operator=Exists \
  --set tolerations[0].effect=NoSchedule
  # --set controller.resources.requests.cpu=1 \
  # --set controller.resources.requests.memory=1Gi \
  # --set controller.resources.limits.cpu=1 \
  # --set controller.resources.limits.memory=1Gi

#####################################################################################
# Kyverno
# https://kyverno.io/
#####################################################################################
NODEGROUP="eksng-esp-${ENVIRONMENT}-mgmt"
# kyverno 레포지토리 추가
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

#Kyverno 설치
helm upgrade --install kyverno kyverno/kyverno \
  --namespace kyverno \
  --create-namespace \
  --set admissionController.nodeSelector."eks\.amazonaws\.com/nodegroup"="$NODEGROUP" \
  --set admissionController.tolerations[0].key="CriticalAddonsOnly" \
  --set admissionController.tolerations[0].operator="Exists" \
  --set admissionController.tolerations[0].effect="NoSchedule" \
  --set admissionController.replicas=3 \
  --set backgroundController.nodeSelector."eks\.amazonaws\.com/nodegroup"="$NODEGROUP" \
  --set backgroundController.tolerations[0].key="CriticalAddonsOnly" \
  --set backgroundController.tolerations[0].operator="Exists" \
  --set backgroundController.tolerations[0].effect="NoSchedule" \
  --set backgroundController.replicas=2 \
  --set cleanupController.nodeSelector."eks\.amazonaws\.com/nodegroup"="$NODEGROUP" \
  --set cleanupController.tolerations[0].key="CriticalAddonsOnly" \
  --set cleanupController.tolerations[0].operator="Exists" \
  --set cleanupController.tolerations[0].effect="NoSchedule" \
  --set cleanupController.replicas=2 \
  --set reportsController.nodeSelector."eks\.amazonaws\.com/nodegroup"="$NODEGROUP" \
  --set reportsController.tolerations[0].key="CriticalAddonsOnly" \
  --set reportsController.tolerations[0].operator="Exists" \
  --set reportsController.tolerations[0].effect="NoSchedule" \
  --set reportsController.replicas=2

#####################################################################################
# KEDA
# https://keda.sh/
#####################################################################################

helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda --namespace kube-system \
              --set tolerations[0].key=CriticalAddonsOnly \
              --set tolerations[0].operator=Exists \
              --set tolerations[0].effect=NoSchedule

NAMESPACES=(
  esp-fo-stg
  esp-hims-stg
  esp-if-stg
  esp-hcas-stg
  esp-hpas-stg
)

for ns in "${NAMESPACES[@]}"; do
  echo "Processing namespace: $ns"
  deployments=$(kubectl get deploy -n "$ns" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

  for deploy in $deployments; do
    filename="${deploy}-${ns}-scaledobject.yaml"
    echo "Generating: $filename"

    cat <<EOF > "$filename"
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: ${deploy}-cron-scaler
  namespace: ${ns}
spec:
  scaleTargetRef:
    name: ${deploy}
  minReplicaCount: 0
  maxReplicaCount: 1
  triggers:
    - type: cron
      metadata:
        timezone: Asia/Seoul
        start: 00 08 * * *
        end: 00 23 * * *
        desiredReplicas: "1"
EOF

  done
done              

#####################################################################################
# AWS for Fluent Bit IRSA
# https://github.com/aws/aws-for-fluent-bit
#####################################################################################
SERVICE_ACCOUNT_NAME="fluent-bit"
SERVICE_ACCOUNT_NAMESPACE="logging"
FLUENT_BIT_POLICY_NAME="policy-esp-prd-fluent-bit"
FLUENT_BIT_ROLE_NAME="role-esp-prd-aws-for-fluent-bit"
S3_BUCKET="s3-esp-prd-app-logs"
FLUENT_BIT_POLICY_FILE="policy-esp-prd-fluent-bit.json"

cat > $FLUENT_BIT_POLICY_FILE <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": [
        "arn:aws:s3:::$S3_BUCKET",
        "arn:aws:s3:::$S3_BUCKET/*"
      ]
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name $FLUENT_BIT_POLICY_NAME \
  --policy-document file://$FLUENT_BIT_POLICY_FILE

eksctl create iamserviceaccount \
  --name $SERVICE_ACCOUNT_NAME \
  --namespace $SERVICE_ACCOUNT_NAMESPACE \
  --override-existing-serviceaccounts \
  --role-name $FLUENT_BIT_ROLE_NAME \
  --cluster $CLUSTER_NAME \
  --attach-policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/$FLUENT_BIT_POLICY_NAME \
  --approve \
  --region $REGION


#####################################################################################
# Secret for Private ECR
# apim, whatap
#####################################################################################
kubectl create secret docker-registry esp-apim-stg-ecr-secret \
  --docker-server=026090541481.dkr.ecr.ap-northeast-2.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region ap-northeast-2) \
  --namespace esp-apim-stg

kubectl create secret docker-registry whatap-monitoring-ecr-secret \
  --docker-server=026090541481.dkr.ecr.ap-northeast-2.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region ap-northeast-2) \
  --namespace whatap-monitoring

#####################################################################################
# Namespace
#####################################################################################
kubectl create ns esp-apim-stg 
kubectl create ns esp-fo-stg  
kubectl create ns esp-hcas-stg
kubectl create ns esp-hims-stg
kubectl create ns esp-hpas-stg
kubectl create ns esp-if-stg     

#####################################################################################
# create pod identity association
#####################################################################################
ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/role-esp-${ENVIRONMENT}-container-app-default"

# esp-core 네임스페이스
eksctl create podidentityassociation \
    --cluster ${CLUSTER_NAME} \
    --namespace "esp-core" \
    --service-account-name esp-common-api-config-reader-${ENVIRONMENT} \
    --region ${REGION} \
    --role-arn ${ROLE_ARN}

# esp-fo-stg 네임스페이스
for SA in hezo-fo-customer-api-config-reader hezo-fo-customer-config-reader hezo-fo-lodgement-api-config-reader hezo-fo-order-api-config-reader hezo-fo-product-api-config-reader hezo-fo-promotion-api-config-reader; do
eksctl create podidentityassociation \
    --cluster ${CLUSTER_NAME} \
    --namespace "esp-fo-${ENVIRONMENT}" \
    --service-account-name ${SA}-${ENVIRONMENT} \
    --region ${REGION} \
    --role-arn ${ROLE_ARN}
done

# esp-hcas-stg 네임스페이스
eksctl create podidentityassociation \
    --cluster ${CLUSTER_NAME} \
    --namespace "esp-hcas-${ENVIRONMENT}" \
    --service-account-name hcas-bo-ui-config-reader-${ENVIRONMENT} \
    --region ${REGION} \
    --role-arn ${ROLE_ARN}

# esp-hims-stg 네임스페이스
for SA in hims-bo-analyze-api-config-reader hims-bo-calculate-api-config-reader hims-bo-common-api-config-reader hims-bo-cooperation-api-config-reader hims-bo-counsel-api-config-reader hims-bo-customer-api-config-reader hims-bo-display-api-config-reader hims-bo-order-api-config-reader hims-bo-product-api-config-reader hims-bo-promotion-api-config-reader hims-bo-pub-ui-config-reader hims-bo-ui-config-reader hims-bo-websquare-api-config-reader hims-bo-welfare-api-config-reader; do
eksctl create podidentityassociation \
    --cluster ${CLUSTER_NAME} \
    --namespace "esp-hims-${ENVIRONMENT}" \
    --service-account-name ${SA}-${ENVIRONMENT} \
    --region ${REGION} \
    --role-arn ${ROLE_ARN}
done

# esp-hpas-stg 네임스페이스
eksctl create podidentityassociation \
    --cluster ${CLUSTER_NAME} \
    --namespace "esp-hpas-${ENVIRONMENT}" \
    --service-account-name hpas-bo-ui-config-reader-${ENVIRONMENT} \
    --region ${REGION} \
    --role-arn ${ROLE_ARN}

# esp-if-stg 네임스페이스
for SA in external-customer-api-config-reader external-order-api-config-reader external-product-api-config-reader; do
eksctl create podidentityassociation \
    --cluster ${CLUSTER_NAME} \
    --namespace "esp-if-${ENVIRONMENT}" \
    --service-account-name ${SA}-${ENVIRONMENT} \
    --region ${REGION} \
    --role-arn ${ROLE_ARN}
done