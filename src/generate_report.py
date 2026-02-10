import boto3
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

def lambda_handler(event, context):
    table = dynamodb.Table('ProcessedData')
    
    # Get all records
    response = table.scan()
    count = response['Count']
    
    # Send report via SNS
    message = f"Daily Report - {datetime.now().date()}\nTotal records: {count}"
    
    topic_arn = os.environ.get('SNS_TOPIC_ARN', 'arn:aws:sns:us-east-1:969744961845:daily-report')
    
    sns.publish(
        TopicArn=topic_arn,
        Subject='Daily Data Report',
        Message=message
    )
    
    return {'statusCode': 200}
