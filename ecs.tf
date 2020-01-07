###############################################################################
# 
# ECS CLUSTER
#
###############################################################################

resource "aws_ecs_cluster" "word-press-cluster" {
    name = "word-press-cluster"
}

resource "aws_launch_configuration" "ecs-cluster-launchconfig" {
  name_prefix          = "ecs-launchconfig"
  image_id             = var.aws_ECS_Opt_Linux_2
  instance_type        = var.aws_instance_type
  key_name             = "use1kp"
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-profile-role.id
  security_groups      = [aws_security_group.sg-ecs-cluster.id]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=word-press-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle              { create_before_destroy = true }
}

resource "aws_autoscaling_group" "ecs-cluster-autoscaling" {
  name                 = "ecs-cluster-autoscaling"
  vpc_zone_identifier  = aws_subnet.subnet-main[*].id
  launch_configuration = aws_launch_configuration.ecs-cluster-launchconfig.name
  min_size             = 1
  max_size             = 1

  tag {
      key = "Name"
      value = "ecs-ec2-container"
      propagate_at_launch = true
  }
}


resource "aws_security_group" "sg-ecs-cluster" {
  vpc_id = aws_vpc.main.id
  name = "ecs-cluster"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = [aws_security_group.sg-alb-ecs-web.id]
  } 
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 
}