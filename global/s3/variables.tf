variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "EKS 쿠버네티스 버전"
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "EKS 클러스터가 배치될 VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "EKS 워커 노드가 생성될 서브넷 ID 목록"
  type        = list(string)
}

variable "instance_types" {
  description = "워커 노드 EC2 인스턴스 타입"
  type        = list(string)
  default     = ["t3.medium"]
}