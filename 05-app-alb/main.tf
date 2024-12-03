resource "aws_lb" "app-alb" {
  name               = "${local.name}-${var.tags.Component}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_ids.value)

  tags = merge(
    var.common_tags,
    var.tags
  )
}


resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi, This reponse is from APP ALB"
      status_code  = "200"
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "*.app-$(var.environment)"
      type    = "A"
      alias   = {
        name    = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
    },
  ]
}