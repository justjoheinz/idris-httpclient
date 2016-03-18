module Main

import HttpClient
import HttpClient.Json

Show Reply where
  show (MkReply statusCode header body) = concat $ Prelude.List.intersperse "\n"
                                          ["\nstatusCode: " ,
                                            show statusCode ,
                                          "header:" ,
                                            show header,
                                          "body:",
                                            body]

example: String -> IO (Response Reply) -> IO ()
example intro resp= do
  putStrLn intro
  putStrLn $ show !resp
  putStrLn "\n\n\n"

main: IO ()
main = do
    example "GET request" $ httpClient
                          $ get
                          $ url "http://httpbin.org/get"

    example "POST request" $ httpClient
                           $ post "language=idris&http=libcurl" .
                             withHeader (Link, "up") .
                             withHeader (Accept, "*/*")
                           $ url "http://httpbin.org/post"

    example "POST json"   $ httpClient
                          $ post (JsonObject ( (insert "foo" (JsonString "bar")) . (insert "bar" (JsonString "foo" ))) empty) .
                             withHeader (Content_Type, "application/json")
                          $ url "http://httpbin.org/post"

    example "PUT request" $ httpClient
                          $ put "language=idris&http=libcurl" .
                            withHeader (Link, "up") .
                            withHeader (Accept, "*/*")
                          $ url "http://httpbin.org/put"

    example "DELETE request" $ httpClient $ delete "" .
                              withHeaders [
                                (User_Agent, "idris-httpclient"),
                                (X_ "Some-Header", "my-data")
                                ]
                            $ url "http://httpbin.org/delete"

    example "Follow request" $ httpClient $ get
                             $ follow
                             $ url "http://httpbin.org/redirect/1"
