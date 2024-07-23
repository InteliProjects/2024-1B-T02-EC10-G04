resource "aws_ecr_repository" "conductor_ecr" {
  name = "conductor"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    name     = "backend"
    menageBy = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "conductor_ecr_policy" {
  repository = aws_ecr_repository.conductor_ecr.name

  policy = <<POLICY
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only the last 2 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
POLICY
}

resource "aws_ecr_repository" "server_ecr" {
  name = "server"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    name     = "backend"
    menageBy = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "server_ecr_policy" {
  repository = aws_ecr_repository.server_ecr.name

  policy = <<POLICY
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only the last 2 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
POLICY
}

resource "aws_ecr_repository" "dashboard_ecr" {
  name = "dashboard"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    name     = "dashboard"
    menageBy = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "dashboard_ecr_policy" {
  repository = aws_ecr_repository.dashboard_ecr.name

  policy = <<POLICY
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only the last 2 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
POLICY
}