variable "enabled" {
  type    = bool
  default = true
}

variable "is_ipv6_enabled" {
  type    = bool
  default = true
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "origin_domain_name" {
  type = string
}

variable "origin_id" {
  type = string
}

variable "origin_access_control_id" {
  description = "The ID of the Origin Access Control"
  type        = string
  default     = null
}

variable "origin_access_identity" {
  type    = string
  default = null
}

variable "custom_origin_config" {
  type = object({
    http_port                = number
    https_port               = number
    origin_protocol_policy   = string
    origin_ssl_protocols     = list(string)
    origin_read_timeout      = number
    origin_keepalive_timeout = number
  })
  default = {
    http_port                = 80
    https_port               = 443
    origin_protocol_policy   = "http-only"
    origin_ssl_protocols     = ["TLSv1.2"]
    origin_read_timeout      = 60
    origin_keepalive_timeout = 60
  }
}

variable "s3_origin_config" {
  type = object({
    origin_access_identity = string
  })
  default = null
}

variable "ordered_cache_behavior" {
  type = list(object({
    path_pattern     = string
    allowed_methods  = list(string)
    cached_methods   = list(string)
    target_origin_id = string
    headers          = list(string)
    cookies_forward  = string
    query_string     = bool
    min_ttl         = number
    default_ttl     = number
    max_ttl         = number
  }))
  default = []
}

variable "default_cache_behavior" {
  type = object({
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress              = bool
    query_string          = bool
    headers               = list(string)
    cookies_forward       = string
    min_ttl               = number
    default_ttl           = number
    max_ttl               = number
  })
  default = {
    target_origin_id       = null  # Required - no default
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress              = true
    query_string          = false
    headers               = []
    cookies_forward       = "none"
    min_ttl               = 0
    default_ttl           = 3600
    max_ttl               = 86400
  }
}

variable "viewer_protocol_policy" {
  type    = string
  default = "redirect-to-https"
}

variable "web_acl_id" {
  type    = string
  default = null
}

variable "response_headers_policy_id" {
  description = "The ID of the Response Headers Policy"
  type        = string
  default     = null
}

variable "restriction_type" {
  type    = string
  default = "none"
}

variable "restricted_locations" {
  type    = list(string)
  default = []
}

variable "cloudfront_default_certificate" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "query_string" {
  type    = bool
  default = false
}

variable "cookies_forward" {
  type    = string
  default = "none"
}

variable "min_ttl" {
  type    = number
  default = 30
}

variable "default_ttl" {
  type    = number
  default = 60
}

variable "max_ttl" {
  type    = number
  default = 90
}

variable "headers" {
  type    = list(string)
  default = ["*"]
}

variable "security_headers_config" {
  type = object({
    content_security_policy = string
    strict_transport_security = object({
      include_subdomains         = bool
      preload                    = bool
      access_control_max_age_sec = number
    })
  })
  default = {
    content_security_policy = ""
    strict_transport_security = {
      include_subdomains         = true
      preload                    = true
      access_control_max_age_sec = 31536000
    }
  }
}

variable "compress" {
  type    = bool
  default = true
}

variable "ordered_cache_behaviors" {
  type = list(object({
    path_pattern           = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    target_origin_id       = string
    viewer_protocol_policy = string
    query_string          = bool
    cookies_forward       = string
    compress              = bool
    min_ttl               = number
    default_ttl           = number
    max_ttl               = number
    trusted_key_groups    = optional(list(string))
  }))
  default = []
}
