import requests as req

def auth_leb(server, user, password):
    response = req.post(server + "authenticate", auth=(user, password))
    cookie = { 'rulekeeper' : response.headers["Set-Cookie"].split("=",1)[1].split(";", 1)[0] }
    return response.json()["token"], cookie

def auth_habitica(server, user, password):
    user = { 'username': user, 'password': password }
    response = req.post(server + "api/v4/user/auth/local/login", json=user, verify=False)
    cookie = { 'rulekeeper' : response.headers["Set-Cookie"].split("=",1)[1].split(";", 1)[0] }
    return response.json(), cookie

def auth_amazona(server, user, password):
    user = { 'email': user, 'password': password }
    response = req.post(server + "api/users/signin", json=user)
    cookie = { 'rulekeeper' : response.headers["Set-Cookie"].split("=",1)[1].split(";", 1)[0] }
    return response.json()["token"], cookie

def auth_blog(server, user, password):
    user = { 'user': { 'email': user, 'password': password } }
    response = req.post(server + "api/users/login", json=user)
    cookie = { 'rulekeeper' : response.headers["Set-Cookie"].split("=",1)[1].split(";", 1)[0] }
    return response.json()["user"]["token"], cookie
