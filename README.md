
## idris http client

This is a very limited httpclient implementation based on libcurl for idris.
It is still littered with debug output and currently just supports a minimal subset
of HTTP features. It is probably not threadsafe, is leaking memory, the API is far from stable and not documented etc.

### Example

Below are some examples of the usage for some request kinds:

```idris
module Main

import HttpClient

Show Reply where
  show (MkReply statusCode header body) = concat $ intersperse "\n"
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

    example "DELETE request" $ httpClient $ delete "" .
                              withHeaders [
                                (User_Agent, "idris-httpclient"),
                                (X_ "Some-Header", "my-data")
                                ]
                            $ url "http://httpbin.org/delete"

    example "Follow request" $ httpClient $ get
                             $ follow
                             $ url "http://httpbin.org/redirect/1"
```

Compile this with
```bash
idris -p httpclient Main.idr -o main
```


### Installation

Installation is only tested on Mac OS X. You will need libcurl (and idris 0.10.2):

```bash
brew install curl
```

You will also need the lightyear parser library available from
[LightYear](https://github.com/ziman/lightyear). Follow the build instructions to put it into your Idris distribution.

The Makefile in `/src` assumes a standard location. If that is not ok, adopt to your needs.
If you have the prerequisites, just do:

```bash
make install
```

You will see a warning about a missing main file - that is ok, as long everything typechecks.

### Issues

This is pretty much a learning project for me. If you find this project useful, and would like to have features, I am happy to learn in areas which help you. If you have suggestions to make the code better - please let me know.


### memstream

Memstream implementation taken from http://piumarta.com/software/memstream/
