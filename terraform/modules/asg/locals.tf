locals {
  region_short_name = lookup(var.region-short-name-map, data.aws_region.current.name, "awsx")
  region_direction_name = substr(data.aws_region.current.name, 3, 4)
  server_base_name  = "${var.environment}-${local.region_short_name}-${var.context}"
}

