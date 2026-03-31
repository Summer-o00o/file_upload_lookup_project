import json

def lambda_handler(event, context):
    for record in event["Records"]:
        if record["eventName"] == "INSERT":
            new_image = record["dynamodb"].get("NewImage", {})
            print("New file uploaded:", json.dumps(new_image))

    return {
        "statusCode": 200,
        "body": json.dumps("Stream processed successfully")
    }