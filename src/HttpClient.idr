||| HttpClient provides a module to issue Http requests
module HttpClient

import HttpClient.Base
import HttpClient.ForeignTypes
import public HttpClient.Methods
import public HttpClient.Requests
import public HttpClient.Headers

import public Data.SortedMap

%access export
%default total


||| make a client request
||| @ request the request record
httpClient: (request: Request) -> IO (Response Reply)
httpClient (MkRequest method url headers options) = do
    -- initialize the curl system
    Right ptr  <- http_init |
      Left error => pure (Left (MkError "error initialising curl"))
    -- set the request url
    Right _    <- http_setopt_url url ptr |
      Left error => pure (Left (MkError "error setting url option"))
    -- append all extra headers
    for headers (\h => http_header_append h ptr)
    -- and other options (e.g. follow) which are treated differently by curl
    for options (\o => http_setopt_option o ptr)
    -- set the request method and if required the body
    Right _    <- http_setopt_method method ptr |
      Left error => pure (Left (MkError "error setting request method"))
    -- perform the request
    Right reply <- http_perform_high ptr |
      Left error => pure (Left (MkError "error performing final request"))
    pure $ Right $ reply
