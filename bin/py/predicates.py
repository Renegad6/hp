connection = True
file_transfer = True

def disconnect():
    global connection
    connection = False
def connected():
    global connection
    return connection
