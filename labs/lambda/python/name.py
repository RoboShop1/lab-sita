import requests
import json

from jinja2 import Template

def lambda_handler(event, context):
    #name = event["name"]
    print(type(event))
    print(event)

#     template = Template("Hello, {{ name }}!")
#     message = template.render(name=name)
#     print(message)

    return {
        "statusCode": 200,
        "body": message
    }
