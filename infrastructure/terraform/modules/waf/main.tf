resource "aws_wafv2_web_acl" "example" {
  name        = "jenkins-access"
  scope       = "REGIONAL" # для ALB
  description = "WAF для ограничения доступа к Jenkins"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "jenkinsWAF"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AllowMyIP"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.my_ip.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowMyIP"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "BlockAllOthers"
    priority = 2

    action {
      block {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockAllOthers"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_ip_set" "my_ip" {
  name        = "my-admin-ip"
  scope       = "REGIONAL"
  description = "Разрешить доступ только с моего IP"
  ip_address_version = "IPV4"
  addresses   = ["91.123.151.244/32"]
}

resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = var.alb
  web_acl_arn  = aws_wafv2_web_acl.example.arn
}
