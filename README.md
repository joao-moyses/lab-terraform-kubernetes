# lab-terraform-kubernetes
It is a Lab showing how to create a kubernetes cluster via terraform and aws load balancer controller to expose ingress to internet controler.


**First part is to deploy the infrastructure on AWS using terraform files**

To do that you just need to change the variables NAME and CIDR inside file variables.tf in the main folder and apply all ther resources. It is going to create all infrastructure inside AWS. Deploy the files from ./main folder.


**Second Part is to Create an IAM OIDC provider for your cluster in order to authenticate your AWS user/role to connect with resources inside kubernetes cluster. As this Lab doesn't have CI/CD implemented yet the deployment part of this Lab will be made via Kubectl, eksctl and AWS cli.**


**Creating an IAM OIDC provider for your cluster**


**1:**

Determine whether you have an existing IAM OIDC provider for your cluster.

Retrieve your cluster's OIDC provider ID and store it in a variable. type this command in your terminal:

oidc_id=$(aws eks describe-cluster --name my-cluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)


**2:**

Determine whether an IAM OIDC provider with your cluster's ID is already in your account. type this command in your terminal:

aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4

If output is returned, then you already have an IAM OIDC provider for your cluster and you can skip the next step. If no output is returned, then you must create an IAM OIDC provider for your cluster.

if not follow the third step.


**3:**

Create an IAM OIDC identity provider for your cluster with the following command. Replace my-cluster with your own value. type this command in your terminal:

eksctl utils associate-iam-oidc-provider --cluster my-cluster --approve


**Then you managed to create an IAM OIDC provider**


**After that you need to create an AWL Load Balancer Controller to manage to expose your ingress via Application Load Balancer**


**1**

Download an IAM policy for the AWS Load Balancer Controller that allows it to make calls to AWS APIs on your behalf. type this command in your terminal:

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy_us-gov.json

And after download type:

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json


**2:**

Create an IAM role. Create a Kubernetes service account named aws-load-balancer-controller in the kube-system namespace for the AWS Load Balancer Controller and annotate the Kubernetes service account with the name of the IAM role. type this command in your terminal:

eksctl create iamserviceaccount \
  --cluster=my-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::111122223333:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
  
  **OBS.: For this command works you will nedd to install eksctl. You can follow this link: https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html**
  
  
**3:**
  
- Install cert-manager using one of the following methods to inject certificate configuration into the webhooks. type this command in your terminal:

  kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml


**4:**

- Install the aws load balancer controller. type this command in your terminal:

curl -Lo v2_4_7_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.7/v2_4_7_full.yaml


**OBS.:If you downloaded the v2_4_7_full.yaml file, run the following command to remove the ServiceAccount section in the manifest. Type the following**

sed -i.bak -e '561,569d' ./v2_4_7_full.yaml


- Replace your-cluster-name in the Deployment spec section of the file with the name of your cluster by replacing my-cluster with the name of your cluster. type this command in your terminal:

sed -i.bak -e 's|your-cluster-name|my-cluster|' ./v2_4_7_full.yaml


- Apply the file. type this command in your terminal:

kubectl apply -f v2_4_7_full.yaml


- Download the IngressClass and IngressClassParams manifest to your cluster. type this command in your terminal:

curl -Lo v2_4_7_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.7/v2_4_7_ingclass.yaml


- Apply the manifest to your cluster. type this command in your terminal:

kubectl apply -f v2_4_7_ingclass.yaml


- Verify that the controller is installed. type this command in your terminal:

kubectl get deployment -n kube-system aws-load-balancer-controller


**In Order to test if everything was set properly you can create a deployment which you expose a game called _2048_ via application load balance which you can just copy the DNS from ALB and use in you browser to access it.**


**1**

To create this _2048_ game you just need to download the deployment and apply. 

- Download. type this command in your terminal:

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/examples/2048/2048_full.yaml


- Apply into kubernetes cluster. type this command in your terminal:

kubectl apply -f 2048_full.yaml


- To verify the instalation is correct you type:

kubectl get ingress/ingress-2048 -n game-2048


And it should output:

NAME           CLASS    HOSTS   ADDRESS                                                                   PORTS   AGE
ingress-2048   <none>   *       k8s-game2048-ingress2-xxxxxxxxxx-yyyyyyyyyy.region-code.elb.amazonaws.com   80      2m32s


If Something went wrong you can try to look at the log and figure out what happend using the command:

kubectl logs -f -n kube-system -l app.kubernetes.io/instance=aws-load-balancer-controller


**It All set**


