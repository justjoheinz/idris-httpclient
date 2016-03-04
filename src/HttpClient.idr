module HttpClient

import HttpClient.Base
import public HttpClient.Methods
import public HttpClient.Requests

%access export

||| make a get request
httpClient: Request -> IO (Response Reply)
httpClient (MkRequest method url) = do
    Right ptr  <- http_init | Left error => pure (Left (MkError "error initialising curl"))
    Right _    <- http_setopt_url url ptr | Left error => pure (Left (MkError "error setting url option"))
    Right _    <- http_setopt_method method ptr | Left error => pure (Left (MkError "error setting request method"))
    Right reply <- http_perform_high ptr | Left error => pure (Left (MkError "error performing final request"))
    pure $ Right $ reply
