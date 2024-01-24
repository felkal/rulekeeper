counter = 1

client_ids = {}
client_task = {}
client_token = {}

request = function()
   wrk.method = "POST"
   wrk.body = '{ "challenge": {}, "group": { "approval": { "required": "false", "approved": "false", "requested": "false" }, "assignedUsers":[], "sharedCompletion":"singleCompletion" }, "up": "true", "down": "true", "counterUp":"0", "counterDown": 0, "frequency":"daily", "type":"habit", "notes":"Notes", "tags":[], "value":0, "priority":1, "attribute":"str", "byHabitica":false, "text":"Task Description", "reminders":[], "createdAt":"2021-12-31T08:56:56.309Z", "updatedAt":"2021-12-31T13:13:56.309Z", "userId":"'..client_ids[counter]..'", "id":"'..client_task[counter]..'" }'
   wrk.headers["Content-Type"] = "application/json"
   wrk.headers["x-api-key"] = client_token[counter]
   wrk.headers["x-api-user"] = client_ids[counter]
   path = '/api/v4/tasks/'..client_task[counter]..'/score/up'
   counter = counter + 1
   if (counter == 63) then counter = 1 end
   return wrk.format(nil, path)
end
