resource "aws_api_gateway_model" "RunnerModel" {
  rest_api_id  = "${aws_api_gateway_rest_api.CourierAPI.id}"
  name         = "runner"
  description  = "Runner model"
  content_type = "application/json"

  schema = <<EOF
{
	"title": "runner",
	"type": "object",
	"properties": {
		"RunnerId": {
			"type": "number"
		},
		"Location": {
			"type": "string"
		},
		"LastUpdated": {
		    "type": "string"
		}
	},
	"required": ["RunnerId", "Location", "LastUpdated"]
}EOF
}
