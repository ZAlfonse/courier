import boto3


def handle(event, context):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('ActiveRunner')

    item = {
        'RunnerId': int(event['params']['path']['id']),  # 1
        'Location': event['body-json']['location'],  # '42.51776,-70.8892885'
        'LastUpdated': event['body-json']['last_updated']  # 1:24:00 PM
    }

    table.put_item(Item=item)

    return item
