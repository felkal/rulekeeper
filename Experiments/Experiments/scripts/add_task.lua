mongo = require 'mongo'
counter = 1
client_ids = {}
client_task = {}
client_token = {}

client = mongo.Client('...')
tasks = client:getCollection('habitica-dev', 'tasks')
tasks = client:getCollection('habitica-dev', 'tasks')
users = client:getCollection('habitica-dev', 'users')
x = tasks:drop()
users:updateMany({}, '{ "$set": { "tasksOrder.habits" : [] } }' )

request = function()
   wrk.method = "POST"
   wrk.body = '{ "challenge": {}, "group": { "approval": { "required": "false", "approved": "false", "requested": "false" }, "assignedUsers":[], "sharedCompletion": "singleCompletion" }, "up": "true", "down": "true", "counterUp": "0", "counterDown": "0", "frequency": "daily", "type": "habit", "notes": "Notes", "tags": [], "value": "0", "priority": "1", "attribute": "str", "byHabitica": "false", "text": "Task Description", "reminders": [], "createdAt": "2021-05-28T08:56:56.309Z", "updatedAt": "2021-05-28T08:56:56.309Z", "userId":"'..client_ids[counter]..'", "id":"'..client_task[counter]..'" }'
   wrk.headers["Content-Type"] = "application/json"
   wrk.headers["x-api-key"] = client_token[counter]
   wrk.headers["x-api-user"] = client_ids[counter]
   path = "/api/v4/tasks/user"
   counter = counter + 1
   if (counter == 63) then
      tasks:removeMany({})
      users:updateMany({}, '{"$set": { "tasksOrder.habits" : [] }}')
   end
   if (counter == 63) then counter = 1 end
   return wrk.format(nil, path)
end
