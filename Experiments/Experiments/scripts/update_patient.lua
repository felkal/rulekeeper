counter = 0

request = function()
   wrk.method = "POST"
   wrk.body = '{"authenticated": "true", "contact_info": {"e_mail": "charles'..counter..'@gmail.com"}}'
   wrk.headers["Content-Type"] = "application/json"
   wrk.path = "/patients/12340001"
   counter = counter + 1
   return wrk.format(nil, path)
end
