import boto3


def handle(event, context):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('ActiveRunner')

    response = table.get_item(
        Key={
            'RunnerId': int(event['params']['path']['id'])  # 1
        }
    )

    return response['Item']
