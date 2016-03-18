module HttpClient.Methods

import Data.Fin
import HttpClient.Json

%access export
%default partial

total
Body: Type
Body = String

total
bodyToString: Body -> String
bodyToString b = b

||| Interface to transform arbitrary types
||| into a Body of a request
public export
interface Writeable a where
  writeBody: a -> Body

public export
Writeable String where
  writeBody = id

public export
Writeable JsonValue where
  writeBody jsValue = show jsValue

||| the Http Method
public export
data Method: Type where
  ||| GET request without a body
  GET: Method
  ||| POST request with a body
  POST: Body -> Method
  ||| PUT request with a body
  PUT: Body -> Method
  ||| DELETE rquest with a body
  DELETE: Body -> Method

%name Method method
