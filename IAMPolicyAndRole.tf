resource "aws_iam_role" "ec2stopstart-role" {
  name = "ec2stopstart-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
    }
  )
}

resource "aws_iam_role_policy" "ec2stopstart-policy" {
  name = "ec2stopstart-policy"
  role = aws_iam_role.ec2stopstart-role.id


  # This policy is exclusively available by my-role.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        "Resource" : "arn:aws:ec2:*:*:instance/*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "ec2:DescribeInstanceStatus"
        ],
        "Resource" : "*"
      }
    ]
    }
  )
}