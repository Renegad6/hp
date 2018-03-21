connection = False
standing = False
progress = False
aborted = False

def connect():
    global connection
    connection = True
def disconnect():
    global connection
    connection = False
def connected():
    global connection
    return connection
def request_ft():
    global standing
    standing = True
def ft_standing():
    global standing
    return standing
def begin_transfer():
    global progress
    global standing 
    global aborted
    print 'begin transfer'
    progress = True
    standing = False
    aborted = False
def ft_inprogress():
    global progress
    return progress
def resume_transfer():
    global progress 
    global aborted
    print 'resume transfer'
    progress = True
    aborted = False
def abort_transfer():
    global progress 
    global aborted
    print 'abort transfer'
    progress = False
    aborted = True
def ft_aborted():
    global aborted
    return aborted
