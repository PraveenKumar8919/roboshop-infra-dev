resource "aws_lb" "web-alb" {
  name               = "${local.name}-${var.tags.Component}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  tags = merge(
    var.common_tags,
    var.tags
  )
}