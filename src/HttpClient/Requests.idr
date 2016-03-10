module HttpClient.Requests

import HttpClient.Methods
import HttpClient.Headers

%access export
%default total

public export
record Request where
  constructor MkRequest
  method: Method
  url: String
  headers: Headers

%name Request request

public export
record Reply where
  constructor MkReply
  statusCode: Int
  header: Headers
  body: String

%name Reply reply

||| Type to signify that responses we get from the API are ok
public export
data Ok =
  MkOk

||| Error type
public export
data NotOk =
  MkNotOk Int |
  MkError String

||| Shortcut for Either NotOk x
public export
Response: (x: Type) -> Type
Response x = Either NotOk x

-- Request Builder

url: (url: String) -> Request
url url = MkRequest GET url []

withHeader: Header -> Request -> Request
withHeader header request = record { headers = header :: (headers request)} request

withHeaders: Headers -> Request -> Request
withHeaders hs request =   record { headers = hs ++ (headers request)} request

withMethod: Method -> Request -> Request
withMethod method request = record { method = method } request

get: Request -> Request
get request = withMethod (GET) request

post: String -> Request -> Request
post body request = withMethod (POST body) request

put: String -> Request -> Request
put body request = withMethod (PUT body) request

delete: String -> Request -> Request
delete body request = withMethod (DELETE body) request

-- Instances

Show Ok where
  show s = "OK"

Show NotOk where
  show (MkError s) = s
  show (MkNotOk resp) = concat ["Not Ok ", show resp]
