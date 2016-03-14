module HttpClient.Foreign

import HttpClient.Requests
import public HttpClient.ForeignTypes

%include C "http.h"
%include C "curl/curl.h"
%link C "http.o"
%link C "memstream.o"
%lib C "curl"

%access export
%default total

||| extract the primitive Ptr from a RESPONSEPTR
getResponsePtr: RESPONSEPTR -> Ptr
getResponsePtr (MkResponse ptr) = ptr

||| map a C interface response to a Response
responseTy: Int -> Response Ok
responseTy resp =
  if (resp == 0)
    then Right MkOk
    else Left (MkNotOk resp)

responsePtr: Ptr -> IO (Response CURLPTR)
responsePtr ptr = if !(Strings.nullPtr ptr)
                  then pure $ Left (MkError "ptr is null")
                  else pure $(Right $ MkHttp ptr)

-- PROJECTIONS

||| projection for the C Response struct
response_body: RESPONSEPTR -> IO String
response_body (MkResponse ptr) =
  foreign FFI_C "response_body" (Ptr -> IO String) ptr

||| projection for the C Response struct
response_header: RESPONSEPTR -> IO String
response_header (MkResponse ptr) =
  foreign FFI_C "response_header" (Ptr -> IO String) ptr

||| projection for the C Response struct
response_code: RESPONSEPTR -> IO Int
response_code (MkResponse ptr) =
  foreign FFI_C "response_code" (Ptr -> IO Int) ptr

-- PRIMITIVE IO OPERATIONS

-- Setter

||| set the method for the request
do_http_setopt_method: Int -> Ptr -> IO (Response Ok)
do_http_setopt_method m ptr =
  responseTy <$> foreign FFI_C "http_easy_setopt_method" (Ptr -> Int -> IO Int) ptr m

||| set POST data
do_http_setopt_postfields: String -> Ptr -> IO (Response Ok)
do_http_setopt_postfields d ptr =
  responseTy <$> foreign FFI_C "http_easy_setopt_postfields" (Ptr -> String -> IO Int) ptr d

||| set the url for the request
||| * url the url
do_http_setopt_url: (url: String) -> Ptr -> IO Int
do_http_setopt_url url ptr =
  foreign FFI_C "http_easy_setopt_url" (Ptr -> String -> IO Int) ptr url

do_http_header_append: (header: String) -> Ptr -> IO Ptr
do_http_header_append header ptr =
  foreign FFI_C "http_header_append" (Ptr -> String -> IO Ptr) ptr header

do_http_setopt_follow: Ptr -> IO (Response Ok)
do_http_setopt_follow ptr =
  responseTy <$> foreign FFI_C "http_easy_setopt_follow" (Ptr -> IO Int) ptr

-- Lifecycle

||| initialze the curl subsystem
do_http_init: IO (Ptr)
do_http_init =
  foreign FFI_C "http_easy_init" (IO Ptr)

||| low level perform of the request
do_http_perform: CURLPTR -> IO (RESPONSEPTR)
do_http_perform (MkHttp ptr) =
  MkResponse <$> foreign FFI_C "http_easy_perform" (Ptr -> IO Ptr) ptr

||| cleanup the curl subsystem
do_http_cleanup: CURLPTR -> IO ()
do_http_cleanup (MkHttp ptr) =
  foreign FFI_C "http_easy_cleanup" (Ptr -> IO ()) ptr
