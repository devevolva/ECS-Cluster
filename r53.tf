###############################################################################
# 
# R53
#
###############################################################################

resource "aws_route53_record" "www" {
  zone_id                  = "${var.r53_zone_id}"
  name                     = "${var.r53_domain_name}"
  type                     = "A"
  alias {
    name                   = aws_alb.alb-ecs-web.dns_name
    zone_id                = aws_alb.alb-ecs-web.zone_id
    evaluate_target_health = "false"
  }
}