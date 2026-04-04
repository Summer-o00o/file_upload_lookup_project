import json
import os
import boto3

sns = boto3.client("sns")
TOPIC_ARN = os.environ["TOPIC_ARN"]

def lambda_handler(event, context):
    for record in event["Records"]:
        if record["eventName"] == "INSERT":
            new_image = record["dynamodb"].get("NewImage", {})

            message = {
                "event": "NEW_FILE_UPLOADED",
                "fileMetadata": new_image
            }

            sns.publish(
                TopicArn=TOPIC_ARN,
                Subject="New File Uploaded",
                Message=json.dumps(message, indent=2)
            )

    return {
        "statusCode": 200,
        "body": json.dumps("Stream processed successfully")
    }