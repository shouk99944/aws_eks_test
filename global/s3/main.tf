provider "aws" {
  region  = "ap-northeast-2"
  profile = "eks-admin"
}

# AWS S3 Bucket 생성 (테라폼 상태 파일 저장용)
resource "aws_s3_bucket" "terraform_state" {
  bucket = "myterraform-bucket-state-choi-t"
  tags = {
    Name = "terraform_state"
  }
  force_destroy = true
}

# KMS 키 생성
resource "aws_kms_key" "terraform_state_kms" {
  description             = "terraform_state_kms"
  deletion_window_in_days = 7
}

# S3 버킷 서버 측 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_sec" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_state_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# S3 버킷 버전 관리 설정
resource "aws_s3_bucket_versioning" "terraform_state_ver" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB 테이블 생성 (상태 잠금용)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "myTerraform-bucket-lock-choi-t"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}