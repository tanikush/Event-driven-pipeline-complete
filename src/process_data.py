import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ProcessedData')

def lambda_handler(event, context):
    # Get data from S3 event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # Store in DynamoDB
    table.put_item(
        Item={
            'id': key,
            'timestamp': str(datetime.now()),
            'status': 'processed'
        }
    )
    
    return {'statusCode': 200, 'body': 'Data processed'}
 