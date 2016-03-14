module HttpClient.Requests

import HttpClient.Methods
import HttpClient.Headers

%access export
%default total

public export
data Option =
  FOLLOW

%name Option option

public export
record Request where
  constructor MkRequest
  method: Method
  url: String
  headers: Headers
  options: List Option

%name Request request

public export
record Reply where
  constructor MkReply
  statusCode: Int
  header: Headers
  body: String

%name Reply reply

||| Type to signify that responses we get from the API are ok,
||| e.g. they represent CURLE_OK values
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

||| constructs a standard request towards an URL
||| and GET method
url: (url: String) -> Request
url url = MkRequest GET url [] []

||| adds a header to the request
withHeader: Header -> Request -> Request
withHeader header request = record { headers = header :: (headers request)} request

||| adds headers to the request
withHeaders: Headers -> Request -> Request
withHeaders hs request = record { headers = hs ++ (headers request)} request

private
withMethod: Method -> Request -> Request
withMethod method request = record { method = method } request

private
withOption: Option -> Request -> Request
withOption option request = record { options = option :: (options request)} request

||| sets the GET request method
get: Request -> Request
get request = withMethod (GET) request

||| sets the POST request method together with the appropriate body
||| by default this is interpreted as urlenconded form data.
post: Writeable a => a -> Request -> Request
post body request = withMethod (POST $ writeBody body) request

put: Writeable a => a -> Request -> Request
put body request= withMethod (PUT $ writeBody body) request

delete: Writeable a => a  -> Request -> Request
delete body = withMethod (DELETE $ writeBody body)

||| option to follow redirects
follow: Request -> Request
follow = withOption FOLLOW

-- Instances

Show Ok where
  show s = "OK"

Show NotOk where
  show (MkError s) = s
  show (MkNotOk resp) = concat ["Not Ok ", show resp]
