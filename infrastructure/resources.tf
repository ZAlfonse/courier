resource "aws_api_gateway_resource" "ActiveRunner" {
  rest_api_id = "${aws_api_gateway_rest_api.CourierAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.CourierAPI.root_resource_id}"
  path_part   = "activerunner"
}

resource "aws_api_gateway_resource" "ActiveRunnerID" {
  rest_api_id = "${aws_api_gateway_rest_api.CourierAPI.id}"
  parent_id   = "${aws_api_gateway_resource.ActiveRunner.id}"
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "ActiveRunnerGet" {
  rest_api_id   = "${aws_api_gateway_rest_api.CourierAPI.id}"
  resource_id   = "${aws_api_gateway_resource.ActiveRunnerID.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "ActiveRunnerPost" {
  rest_api_id   = "${aws_api_gateway_rest_api.CourierAPI.id}"
  resource_id   = "${aws_api_gateway_resource.ActiveRunnerID.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ActiveRunnerGetIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.CourierAPI.id}"
  resource_id             = "${aws_api_gateway_resource.ActiveRunnerID.id}"
  http_method             = "${aws_api_gateway_method.ActiveRunnerGet.http_method}"
  credentials             = "${aws_iam_role.gateway_invoke_lambda.arn}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.apex_function_get_active_runner}:current"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"

  request_templates = {
    "application/json" = "${file("request_templates/request_to_event")}"
  }
}

resource "aws_api_gateway_integration_response" "ActiveRunnerGetIntegrationResponse" {
  rest_api_id       = "${aws_api_gateway_rest_api.CourierAPI.id}"
  resource_id       = "${aws_api_gateway_resource.ActiveRunnerID.id}"
  http_method       = "${aws_api_gateway_method.ActiveRunnerGet.http_method}"
  status_code       = "200"
}

resource "aws_api_gateway_method_response" "ActiveRunnerGetResponse200" {
  rest_api_id       = "${aws_api_gateway_rest_api.CourierAPI.id}"
  resource_id       = "${aws_api_gateway_resource.ActiveRunnerID.id}"
  http_method       = "${aws_api_gateway_method.ActiveRunnerGet.http_method}"
  status_code       = "200"
  response_models   = {
    "application/json" = "${aws_api_gateway_model.RunnerModel.name}"
  }
}
