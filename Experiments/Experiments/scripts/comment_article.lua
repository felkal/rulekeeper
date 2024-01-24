mongo = require 'mongo'
counter = 0

client = mongo.Client('...')
comments = client:getCollection('blog', 'comments')
articles = client:getCollection('blog', 'articles')

request = function()
   wrk.method = "POST"
   wrk.body = '{ "comment": { "body": "This is my comment to this article." } }'
   wrk.headers["Content-Type"] = "application/json"
   path = "/api/articles/article-1-9uqud5/comments"
   counter = counter + 1
   print(counter)
   if (counter == 25) then
      print("remove")
      comments:remove({})
      articles:update('{ "title": "Article 1"}', '{"$set": { "comments" : [] }}')
      counter = 0
   end
   return wrk.format(nil, path)
end
