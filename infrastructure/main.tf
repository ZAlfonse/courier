variable "aws_region" {
  type = "string"
}

resource "aws_api_gateway_rest_api" "CourierAPI" {
  name        = "CourierAPI"
  description = "Courier API endpoints"
}
