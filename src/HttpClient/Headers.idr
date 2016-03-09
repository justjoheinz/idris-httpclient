module HttpClient.Headers

%default total
%access export

public export
data HeaderFields =
  Accept |
  Accept_CharSet |
  X_ String

%name HeaderFields hf, hf1, hf2

implicit headerFieldsToString: HeaderFields -> String
headerFieldsToString Accept = "Accept"
headerFieldsToString Accept_CharSet = "Accept-CharSet"
headerFieldsToString (X_ str) = "X-" ++ str
