module HttpClient.Methods

import Data.Fin

%access export
%default total

public export
data Method: Type where
  GET: Method
  POST: String -> Method
