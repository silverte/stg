#!/bin/bash
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
# --set replicas=1
#   --set controller.resources.requests.cpu=1 \
#   --set controller.resources.requests.memory=1Gi \
#   --set controller.resources.limits.cpu=1 \
#   --set controller.resources.limits.memory=1Gi \

#####################################################################################
# Kyverno
# https://kyverno.io/
#####################################################################################
# kyverno 레포지토리 추가
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

#Kyverno 설치
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace \
        --set tolerations[0].key=CriticalAddonsOnly \
        --set tolerations[0].operator=Exists \
        --set tolerations[0].effect=NoSchedule
        # --set admissionController.replicas=3 \
        # --set backgroundController.replicas=2 \
        # --set cleanupController.replicas=2 \
        # --set reportsController.replicas=2

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