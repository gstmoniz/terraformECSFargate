resource "aws_ecr_repository" "sphfs-repository" {
  name = "sphfs"
  force_delete = true
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "ecr-lifecycle-rule" {
  depends_on = [
    aws_ecr_repository.sphfs-repository
  ]
  repository = aws_ecr_repository.sphfs-repository.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 5,
        "description": "remove older images",
        "selection": {
          "tagStatus": "untagged",
          "countType": "imageCountMoreThan",
          "countNumber": 2
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}