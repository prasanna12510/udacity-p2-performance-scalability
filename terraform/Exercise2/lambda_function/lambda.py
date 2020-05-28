import os

def lambda_handler(event, context):
    print("Testing Lambda!")
    return "{} from Lambda!".format(os.environ['greeting'])
