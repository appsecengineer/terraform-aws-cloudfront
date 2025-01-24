resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled             = var.enabled
  is_ipv6_enabled    = var.is_ipv6_enabled
  default_root_object = var.default_root_object
  web_acl_id         = var.web_acl_id
  
  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id

    origin_access_control_id = var.origin_access_control_id

    dynamic "custom_origin_config" {
      for_each = var.origin_access_control_id == null ? [var.custom_origin_config] : []
      content {
        http_port                = custom_origin_config.value.http_port
        https_port               = custom_origin_config.value.https_port
        origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
        origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
        origin_read_timeout      = custom_origin_config.value.origin_read_timeout
        origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior
    content {
      path_pattern     = ordered_cache_behavior.value.path_pattern
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id

      forwarded_values {
        query_string = ordered_cache_behavior.value.query_string
        headers      = ordered_cache_behavior.value.headers

        cookies {
          forward = ordered_cache_behavior.value.cookies_forward
        }
      }

      viewer_protocol_policy = var.viewer_protocol_policy
      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
    }
  }

  default_cache_behavior {
    target_origin_id       = var.default_cache_behavior.target_origin_id
    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods
    compress              = var.default_cache_behavior.compress
    
    forwarded_values {
      query_string = var.default_cache_behavior.query_string
      headers      = var.default_cache_behavior.headers

      cookies {
        forward = var.default_cache_behavior.cookies_forward
      }
    }

    min_ttl     = var.default_cache_behavior.min_ttl
    default_ttl = var.default_cache_behavior.default_ttl
    max_ttl     = var.default_cache_behavior.max_ttl
    response_headers_policy_id = var.response_headers_policy_id
  }

  # Create a separate response headers policy
  dynamic "custom_error_response" {
    for_each = var.security_headers_config.content_security_policy != "" ? [1] : []
    content {
      error_code            = 403
      response_code        = 403
      response_page_path   = "/custom_403.html"
      error_caching_min_ttl = 10
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations       = var.restricted_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_default_certificate
  }

  tags = var.tags
} 