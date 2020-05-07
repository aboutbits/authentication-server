provider "aws" {
  version = "~> 2.0"
  region = "eu-west-1"
}

resource "aws_lb_target_group_attachment" "target-i-0445fdff327ef4ef8" {
  target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:755952719952:targetgroup/prod-keycloak-servers/608f83d5b592f368"
  target_id = "i-0445fdff327ef4ef8"
  port = 8080
}
