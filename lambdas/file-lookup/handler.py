import json
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("file_metadata")

def lambda_handler(event, context):
    #scan the table for all items
    response = table.scan()

    items = response.get("Items", [])

    #return the items in the response, hardcoding 200 status code, will use try catch later to handle errors
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(items)
    }