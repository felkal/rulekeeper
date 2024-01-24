import requests as req
from time import sleep

def login(server, user, password):
    user = { 'username': user, 'password': password }
    response = req.post(server + "api/v4/user/auth/local/login", json=user, verify=False)
    return response.json()


operation = "api/v4/tasks/user"
url = 'http://localhost:3000/' + operation

for i in range(1,65):
    token = login('http://localhost:3000/', f'client{i}', "password")
    headers = {'x-api-key': token['data']['apiToken'], 'x-api-user': token['data']['id']}

    task = { 'challenge': {},
                 'group': {
                    'approval': {
                        'required': 'false',
                        'approved': 'false',
                        'requested': 'false' },
                    'assignedUsers':[],
                    'sharedCompletion': 'singleCompletion' },
                 'up': 'true',
                 'down': 'true',
                 'counterUp': '0',
                 'counterDown': '0',
                 'frequency': 'daily',
                 'type': 'habit',
                 'notes': 'Notes',
                 'tags': [],
                 'value': '0',
                 'priority': '1',
                 'attribute': 'str',
                 'byHabitica': 'false',
                 'text': 'Task Description',
                 'reminders': [],
                 'createdAt': '2021-12-31T08:56:56.309Z',
                 'updatedAt': '2021-12-31T08:56:56.309Z',
                 'userId': '{{token[\'data\'][\'id\']}}',
                 }
    sleep(0.1)
    response = req.post(url, headers=headers, json=task)
    print(response)
