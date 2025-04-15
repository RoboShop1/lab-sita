import requests
import json

def lambda_handler(event,context):
    x = requests.get('https://jsonplaceholder.typicode.com/posts/1')

    print(x)