module HttpClient.Headers

%default total
%access export

public export
Header: Type
Header = (String, String)

%name Header header

public export
Headers: Type
Headers = List Header

%name Headers headers

private
parseHeader: String -> Header
parseHeader h = let keyValue = break (\c => c == ':') h
                    key = trim $ fst keyValue
                    valueColon = snd keyValue
                    value = trim $ substr 1 (length valueColon) valueColon
                in (key, value)

||| parse a string of response headers into a Headers
parseHeaders: String -> Headers
parseHeaders h = parseHeader <$> lines h

||| Taken from https://en.wikipedia.org/wiki/List_of_HTTP_header_fields
public export
data HeaderFields =
  Accept |
  Accept_CharSet |
  Accept_Encoding |
  Accept_Language |
  Accept_Datetime |
  Authorization |
  Cache_Control |
  Connection |
  Cookie |
  Content_Length |
  Content_MD5 |
  Content_Type |
  Date |
  Expect |
  Forwarded |
  From |
  If_Match |
  If_Modified_Since |
  If_None_Match |
  If_Range |
  Link |
  Max_Forwards |
  Origin |
  Pragma |
  Proxy_Authorization |
  Range |
  Referer |
  User_Agent |
  Upgrade |
  Via |
  Warning |
  ||| An arbitrary HTTP header in the form of
  ||| "X-Foo"
  X_ String

%name HeaderFields hf, hf1, hf2

Show HeaderFields where
  show Accept = "Accept"
  show Accept_CharSet = "Accept-CharSet"
  show Accept_Encoding = "Accept-Encoding"
  show Accept_Language = "Accept-Language"
  show Accept_Datetime = "Accept-Datetime"
  show Authorization = "Authorization"
  show Cache_Control = "Cache-Control"
  show Connection = "Connection"
  show Cookie = "Cookie"
  show Content_Length = "Content-Length"
  show Content_MD5 = "Content-MD5"
  show Content_Type = "Content-Type"
  show Date = "Date"
  show Expect = "Expect"
  show Forwarded = "Forwarded"
  show From = "From"
  show If_Match = "If-Match"
  show If_Modified_Since = "If-Modified-Since"
  show If_None_Match = "If-None-Match"
  show If_Range = "If-Range"
  show Link = "Link"
  show Max_Forwards = "Max-Forwards"
  show Origin = "Origin"
  show Pragma = "Pragma"
  show Proxy_Authorization = "Proxy-Authorization"
  show Range = "Range"
  show Referer = "Referer"
  show User_Agent = "User-Agent"
  show Upgrade = "Upgrade"
  show Via = "Via"
  show Warning = "Warning"
  show (X_ x) = "X-" ++ x

implicit headerFieldsToString: HeaderFields -> String
headerFieldsToString hf = show hf

showHeader: Header -> String
showHeader header = (fst header) ++ ": " ++ (snd header)
