module HttpClient.Base

import HttpClient.Requests
import HttpClient.Methods
import Data.Fin

%include C "http.h"
%include C "curl/curl.h"
%link C "http.o"
%link C "memstream.o"
%lib C "curl"

%access export
%default total

-- Data Types

||| A handle for curl
data CURLPTR = MkHttp Ptr

||| A handle for the curl response struct
data RESPONSEPTR = MkResponse Ptr

getResponsePtr: RESPONSEPTR -> Ptr
getResponsePtr (MkResponse ptr) = ptr


-- API

responseTy: Int -> Response Ok
responseTy resp =
  if (resp == 0)
    then Right MkOk
    else Left (MkNotOk resp)

response_body: RESPONSEPTR -> IO String
response_body (MkResponse ptr) = (foreign FFI_C "response_body" (Ptr -> IO String)) ptr

response_header: RESPONSEPTR -> IO String
response_header (MkResponse ptr) = (foreign FFI_C "response_header" (Ptr -> IO String)) ptr

response_code: RESPONSEPTR -> IO Int
response_code (MkResponse ptr) = (foreign FFI_C "response_code" (Ptr -> IO Int)) ptr

http_init: IO (Response CURLPTR)
http_init =
  do ptr <- do_http_init
     if !(nullPtr $ ptr)
      then pure $ Left  $ MkError "Could not obtain handle for curl"
      else pure $ Right $ MkHttp ptr
  where
    do_http_init = foreign FFI_C "http_easy_init" (IO Ptr)

||| set the url for the request
||| * url the url
http_setopt_url: (url: String) -> CURLPTR -> IO (Response Ok)
http_setopt_url url (MkHttp ptr) =
  responseTy <$> (foreign FFI_C "http_easy_setopt_url" (Ptr -> String -> (IO Int)) ptr url)


do_http_setopt_method: Int -> Ptr -> IO (Response Ok)
do_http_setopt_method m ptr = responseTy <$> (foreign FFI_C "http_easy_setopt_method" (Ptr -> Int -> (IO Int)) ptr m)

do_http_setopt_postfields: String -> Ptr -> IO (Response Ok)
do_http_setopt_postfields d ptr = responseTy <$> (foreign FFI_C "http_easy_setopt_postfields" (Ptr -> String -> (IO Int)) ptr d)

http_setopt_method: Method -> CURLPTR -> IO (Response Ok)
http_setopt_method (GET) (MkHttp ptr)  = do_http_setopt_method 0 ptr
http_setopt_method (POST d) (MkHttp ptr)  = do
                                              r1 <- do_http_setopt_method 1 ptr
                                              r2 <- do_http_setopt_postfields d ptr
                                              pure $  r2



||| low level perform of the request
http_perform: CURLPTR -> IO (RESPONSEPTR)
http_perform (MkHttp ptr) =
  MkResponse <$> (foreign FFI_C "http_easy_perform" (Ptr -> IO Ptr) ptr)

||| higher level perform of the request, which
||| transforms the request into a reply
http_perform_high: CURLPTR -> IO (Response Reply)
http_perform_high curlPtr = do
    responsePtr <- http_perform curlPtr
    if !(nullPtr $ getResponsePtr responsePtr)
      then pure $ Left $ MkError ("Error in curl subsystem")
      else
        do
        body <- response_body responsePtr
        header <- response_header responsePtr
        statusCode <- response_code responsePtr
        pure $ Right $ MkReply statusCode header body



http_cleanup: CURLPTR -> IO ()
http_cleanup (MkHttp ptr) =
  foreign FFI_C "http_easy_cleanup" (Ptr -> IO ()) ptr
