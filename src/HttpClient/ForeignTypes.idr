module HttpClient.ForeignTypes

%access export
%default total

-- Data Types

||| A handle for curl
public export
data CURLPTR =
  ||| constructor
  MkHttp Ptr

||| A handle for the curl response struct
public export
data RESPONSEPTR =
  ||| constructor
  MkResponse Ptr
