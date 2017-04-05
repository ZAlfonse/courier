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
    "application/json" = <<REQUEST_TEMPLATE
##  See http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
##  This template will pass through all parameters including path, querystring, header, stage variables, and context through to the integration endpoint via the body/payload
#set($allParams = $input.params())
{
"body-json" : $input.json('$'),
"params" : {
#foreach($type in $allParams.keySet())
    #set($params = $allParams.get($type))
"$type" : {
    #foreach($paramName in $params.keySet())
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
        #if($foreach.hasNext),#end
    #end
}
    #if($foreach.hasNext),#end
#end
},
"stage-variables" : {
#foreach($key in $stageVariables.keySet())
"$key" : "$util.escapeJavaScript($stageVariables.get($key))"
    #if($foreach.hasNext),#end
#end
},
"context" : {
    "account-id" : "$context.identity.accountId",
    "api-id" : "$context.apiId",
    "api-key" : "$context.identity.apiKey",
    "authorizer-principal-id" : "$context.authorizer.principalId",
    "caller" : "$context.identity.caller",
    "cognito-authentication-provider" : "$context.identity.cognitoAuthenticationProvider",
    "cognito-authentication-type" : "$context.identity.cognitoAuthenticationType",
    "cognito-identity-id" : "$context.identity.cognitoIdentityId",
    "cognito-identity-pool-id" : "$context.identity.cognitoIdentityPoolId",
    "http-method" : "$context.httpMethod",
    "stage" : "$context.stage",
    "source-ip" : "$context.identity.sourceIp",
    "user" : "$context.identity.user",
    "user-agent" : "$context.identity.userAgent",
    "user-arn" : "$context.identity.userArn",
    "request-id" : "$context.requestId",
    "resource-id" : "$context.resourceId",
    "resource-path" : "$context.resourcePath"
    }
}
REQUEST_TEMPLATE
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
