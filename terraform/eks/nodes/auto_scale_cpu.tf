resource "aws_autoscaling_policy" "cpu_up" {
  name            = "${var.name}-cpu-scale-up"
  adjustment_type = "ChangeInCapacity"

  cooldown           = lookup(var.auto_scale_cpu, "scale_up_cooldown")
  scaling_adjustment = lookup(var.auto_scale_cpu, "scale_up_add")

  autoscaling_group_name = aws_eks_node_group.cluster.resources[0].autoscaling_groups[0].name
}

resource "aws_cloudwatch_metric_alarm" "cpu_up" {

  alarm_name = "${var.name}-nodes-cpu-high"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"

  evaluation_periods = lookup(var.auto_scale_cpu, "scale_up_evaluation")
  period             = lookup(var.auto_scale_cpu, "scale_up_period")
  threshold          = lookup(var.auto_scale_cpu, "scale_up_threshold")

  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.cluster.resources[0].autoscaling_groups[0].name
  }

  alarm_actions = [aws_autoscaling_policy.cpu_up.arn]

}

resource "aws_autoscaling_policy" "cpu_down" {
  name            = "${var.name}-nodes-cpu-scale-down"
  adjustment_type = "ChangeInCapacity"

  cooldown           = lookup(var.auto_scale_cpu, "scale_down_cooldown")
  scaling_adjustment = lookup(var.auto_scale_cpu, "scale_down_remove")

  autoscaling_group_name = aws_eks_node_group.cluster.resources[0].autoscaling_groups[0].name
}

resource "aws_cloudwatch_metric_alarm" "cpu_down" {

  alarm_name = "${var.name}-nodes-cpu-low"

  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"

  evaluation_periods = lookup(var.auto_scale_cpu, "scale_down_evaluation")
  period             = lookup(var.auto_scale_cpu, "scale_down_period")
  threshold          = lookup(var.auto_scale_cpu, "scale_down_threshold")

  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.cluster.resources[0].autoscaling_groups[0].name
  }

  alarm_actions = [aws_autoscaling_policy.cpu_down.arn]

}