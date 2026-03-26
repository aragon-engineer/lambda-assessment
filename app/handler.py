import json


def lambda_handler(event, context):
    """
    Simple Lambda function that returns a greeting.
    Supports both Lambda Function URL and API Gateway invocations.
    """
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
        },
        "body": json.dumps({
            "message": "Hello from José Miguel Aragón",
            "status": "ok"
        }),
    }

