# lambda function in Python
import json

def handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps(f'Hello from Lambda!')
    }
