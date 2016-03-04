module HttpClient.Requests

import HttpClient.Methods

%access export
%default total

public export
record Request where
  constructor MkRequest
  method: Method
  url: String

public export
record Reply where
  constructor MkReply
  statusCode: Int
  header: String
  body: String

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

-- Instances

Show Ok where
  show s = "OK"

Show NotOk where
  show (MkError s) = s
  show (MkNotOk resp) = concat ["Not Ok ", show resp]
