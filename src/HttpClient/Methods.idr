module HttpClient.Methods

import Data.Fin

%access export
%default total

Body: Type
Body = String

bodyToString: Body -> String
bodyToString b = (the String b)

||| Interface to transform arbitrary types
||| into a Body of a request
public export
interface Writeable a where
  writeBody: a -> Body

public export
Writeable String where
  writeBody = id

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
