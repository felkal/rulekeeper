import os
import sys
from auth import auth_leb, auth_habitica, auth_amazona, auth_blog

# Experiment 1: As a patient, access own patient data.
def experiment_1(server, threads, number_clients, duration, path):
    url = server + "patients/12340001"
    token, cookie = auth_leb(server, "charles", "password")
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency  -H\'{headers}\' -H\'{cookies}\' {url}'
    os.system(command + '>>' + path)

# Experiment 2: As a patient, update own patient data.
def experiment_2(server, threads, number_clients, duration, path):
    url = server + "patients/12340001"
    token, cookie = auth_leb(server, "charles", "password")
    script = 'scripts/update_patient.lua'
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{headers}\' -H\'{cookies}\' -s{script} {url}'
    os.system(command + '>>' + path)

# Experiment 3: As a receptionist, access a patient's data.
def experiment_3(server, threads, number_clients, duration, path):
    url = server + "patients/12340001"
    token, cookie = auth_leb(server, "alice", "password")
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{headers}\' -H\'{cookies}\' {url}'
    os.system(command + '>>' + path)

# Experiment 4: As a receptionist, access several patient data.
def experiment_4(server, threads, number_clients, duration, path):
    url = server + "patients/available"
    token, cookie = auth_leb(server, "alice", "password")
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration}  --latency -H\'{headers}\' -H\'{cookies}\' {url}'
    os.system(command + '>>' + path)

# Experiment 5: As a receptionist, update a patient's data.
def experiment_5(server, threads, number_clients, duration, path):
    url = server + "patients/12340001"
    token, cookie = auth_leb(server, "alice", "password")
    script = 'scripts/update_patient.lua'
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{headers}\' -H\'{cookies}\' -s{script} {url}'
    os.system(command + '>>' + path)

def experiment_6(server, threads, number_clients, duration, path):
    url = server + "api/v4/user"
    token, cookie = auth_habitica(server, "bob", "bob_password")
    header_token = token['data']['apiToken']
    token_header = f'x-api-key: {header_token}'
    user_header = 'x-api-user: ae15f83e-cfdf-4731-b362-6bce96d90baa'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration}  --latency -H\'{token_header}\' -H\'{user_header}\' -H\'{cookies}\' {url} '
    os.system(command + '>>' + path)

def experiment_7(server, threads, number_clients, duration, path):
    url = server + "api/v4/tasks/user"
    token, cookie = auth_habitica(server, "bob", "bob_password")
    script = 'scripts/add_task.lua'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{cookies}\' -s{script} {url}'
    os.system(command + '>>' + path)

def experiment_8(server, threads, number_clients, duration, path):
    url = server
    token, cookie = auth_habitica(server, "bob", "bob_password")
    script = 'scripts/score_task.lua'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{cookies}\' -s{script} {url}'
    os.system(command + '>>' + path)

## AMAZONA

# Experiment 1: As an unauthenticated user, access product reviews.
def experiment_9(server, threads, number_clients, duration, path):
    url = server + "api/products"
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency {url}'
    os.system(command + '>>' + path)

# Experiment 2: As a user, order a product.
def experiment_10(server, threads, number_clients, duration, path):
    url = server + "api/orders"
    token, cookie = auth_amazona(server, "user3@amazona.com", "password")
    script = 'scripts/order_product_amazona.lua'
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{headers}\' -H\'{cookies}\' -s{script} {url}'
    os.system(command + '>>' + path)

# Experiment 3: As a user, see my orders.
def experiment_11(server, threads, number_clients, duration, path):
    url = server + "api/orders/mine"
    token, cookie = auth_amazona(server, "user2@amazona.com", "password")
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration}  --latency -H\'{headers}\' -H\'{cookies}\' {url}'
    os.system(command + '>>' + path)


## BLOG


# Experiment 1: As a user, get articles.
def experiment_12(server, threads, number_clients, duration, path):
    url = server + "api/articles"
    token, cookie = auth_blog(server, "user1@blog.com", "password")
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{headers}\' -H\'{cookies}\'  {url}'
    os.system(command + '>>' + path)

# Experiment 2: As a user, get my profile.
def experiment_13(server, threads, number_clients, duration, path):
    url = server + "api/profiles/user1"
    token, cookie = auth_blog(server, "user1@blog.com", "password")
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{headers}\' -H\'{cookies}\'  {url}'
    os.system(command + '>>' + path)

# Experiment 2: As a user, comment an article
def experiment_14(server, threads, number_clients, duration, path):
    url = server + "api/articles/article-1-9uqud5/comments"
    token, cookie = auth_blog(server, "user1@blog.com", "password")
    script = 'scripts/comment_article.lua'
    headers = f'Authorization: Bearer {token}'
    rulekeeper_cookie = cookie['rulekeeper']
    cookies = f'Cookie: rulekeeper={rulekeeper_cookie}'
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency -H\'{headers}\' -H\'{cookies}\' -s{script} {url}'
    os.system(command + '>>' + path)

### WEBUS

# Experiment 1: As a nobody, see schedules
def experiment_15(server, threads, number_clients, duration, path):
    url = server + "tickets/schedules"
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency  {url}'
    os.system(command + '>>' + path)

# Experiment 2: As a nobody, buy ticket
def experiment_16(server, threads, number_clients, duration, path):
    url = server + "tickets/schedules"
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency  {url}'
    os.system(command + '>>' + path)

# Experiment 3: As a nobody, subscribe newsletter
def experiment_17(server, threads, number_clients, duration, path):
    url = server + "tickets/schedules"
    command = f'wrk -t{threads} -c{number_clients} -d{duration} --latency  {url}'
    os.system(command + '>>' + path)


