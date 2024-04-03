# Create the kubernetes cluster - Control Plane

STEP 01:
--> Give a cluster name (ex: eks-cluster-01)
--> Select k8's version 
--> Select a cluster service role (create new)

    * Create a new role from IAM consle
    * Select Trusted entity type - "AWS service"
    * Select use case for other AWS services- "EKS-Cluster"
    * Add permisssion by selecting policy - "AmazonEKSClusterPolicy"
    * Give role name - (ex: eks-cluster-role)

STEP 02:
--> Select VPC as default or any custom
--> Select subnets (ex: give 3 subnets)
--> Give the security group (create a new one)
--> Keep cluster IP adress family as - "IPv4"
--> Keep cluster endpoint access as - "Public" 

STEP 03: Review and Create the cluster

# Create Node Group - Data plane

STEP 01:
--> Create a new IAM role through IAM console for this node group

    * Create a new role from IAM consle
    * Select Trusted entity type - "AWS service"
    * Select common use case as "EC2"
    * Next Add permisssion by selecting policy - here 3 policies are required - "AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly"
    * Give a role name (ex: node-grp-01)

--> Go to EKS console > click on compute > add node group
--> Give node group name (ex: eks-node-grp-01)
--> Select the Node IAM role previously created in STEP 01

STEP 02:
--> Select AMI type (ex: Amazon Linux 2)
--> Keep capacity type as "On-Demand"
--> Select Instance type "t3.medium"
--> Configure Node group scaling configuration - Desired, Minimun, Maximum size, Maximum unavailaible.

# Create kubeconfig file to Authenticate to this cluster

STEP 01:
--> Login to the EC2 instance
--> Run $aws configure to add aws access key id and secet key id
--> Update the ~/.kube/config file 

    $ aws eks update-kubeconfig --region us-east-1 --name eks-cluster-01
