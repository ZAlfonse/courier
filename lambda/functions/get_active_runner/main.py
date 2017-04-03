import boto3
import json
import decimal


class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if o % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)


def handle(event, context):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('ActiveRunner')

    response = table.get_item(
        Key={
            'RunnerId': int(event['params']['path']['id'])  # 1
        }
    )

    return json.dumps(response['Item'], cls=DecimalEncoder)
