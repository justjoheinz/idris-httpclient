module HttpClient

import HttpClient.Base
import HttpClient.ForeignTypes
import public HttpClient.Methods
import public HttpClient.Requests
import public HttpClient.Headers

%access export
%default total

||| make a client request
||| @ request the request record
httpClient: (request: Request) -> IO (Response Reply)
httpClient (MkRequest method url headers options) = do
    Right ptr  <- http_init | Left error => pure (Left (MkError "error initialising curl"))
    Right _    <- http_setopt_url url ptr | Left error => pure (Left (MkError "error setting url option"))
    for headers (\h => http_header_append h ptr)
    for options (\o => http_setopt_option o ptr)
    Right _    <- http_setopt_method method ptr | Left error => pure (Left (MkError "error setting request method"))
    Right reply <- http_perform_high ptr | Left error => pure (Left (MkError "error performing final request"))
    pure $ Right $ reply
