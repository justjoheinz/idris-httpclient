module HttpClient.Requests

import HttpClient.Methods

%access export
%default total

public export
Header: Type
Header = (String, String)

%name Header header

public export
Headers: Type
Headers = List Header

%name Headers headers

private
parseHeader: String -> Header
parseHeader h = let keyValue = break (\c => c == ':') h
                    key = trim $ fst keyValue
                    valueColon = snd keyValue
                    value = trim $ substr 1 (length valueColon) valueColon
                in (key, value)

parseHeaders: String -> List Header
parseHeaders h = parseHeader <$> lines h

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

mkReq: (url: String) -> Request
mkReq url = MkRequest GET url []

withHeader: Header -> Request -> Request
withHeader header request = record { headers = header :: (headers request)} request

withHeaders: Headers -> Request -> Request
withHeaders hs request =   record { headers = hs ++ (headers request)} request

withMethod: Method -> Request -> Request
withMethod method request = record { method = method } request

post: String -> Request -> Request
post d request = withMethod (POST d) request

-- Instances

Show Ok where
  show s = "OK"

Show NotOk where
  show (MkError s) = s
  show (MkNotOk resp) = concat ["Not Ok ", show resp]
