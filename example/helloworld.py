import pyfiglet

def handler(event, context):
    print(pyfiglet.figlet_format("Hello world!"))
    return {"status": True}