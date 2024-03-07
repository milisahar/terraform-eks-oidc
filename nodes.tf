resource "aws_iam_role" "preProd_nodes" {
  name = "eks-cluster-preProd-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "preProd_nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.preProd_nodes.name
}

resource "aws_iam_role_policy_attachment" "preProd_nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
  role       = aws_iam_role.preProd_nodes.name
}

resource "aws_iam_role_policy_attachment" "preProd_nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.preProd_nodes.name
}

resource "aws_eks_node_group" "preProd-private-nodes" {
  cluster_name    = aws_eks_cluster.preProd.name
  node_group_name = "preProd-private-nodes"
  node_role_arn   = aws_iam_role.preProd_nodes.arn

  subnet_ids = [
    aws_subnet.private-eu-west-1a.id,
    aws_subnet.private-eu-west-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["m7a.large"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.preProd_nodes-AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.preProd_nodes-AmazonEKSCNIPolicy,
    aws_iam_role_policy_attachment.preProd_nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}
resource "aws_eks_node_group" "preProd-private-nodes-2" {
  cluster_name    = aws_eks_cluster.preProd.name
  node_group_name = "preProd-private-nodes-2"
  node_role_arn   = aws_iam_role.preProd_nodes.arn

  subnet_ids = [
    aws_subnet.private-eu-west-1a.id,
    aws_subnet.private-eu-west-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["m7a.large"]  # Use m7a.large instance type for this node group

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.preProd_nodes-AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.preProd_nodes-AmazonEKSCNIPolicy,
    aws_iam_role_policy_attachment.preProd_nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}
