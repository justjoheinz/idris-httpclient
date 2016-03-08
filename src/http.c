#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include "memstream.h"


struct Response {
  long response_code;
  char *header;
  char *body;
  size_t body_size;
  size_t header_size;
};

static struct Response response;

long response_code(struct Response *r) {
  return ((struct Response *) r)->response_code;
}

char *response_body(struct Response *r) {
  return ((struct Response *) r)->body;
}

char *response_header(struct Response *r) {
  #ifdef _HTTPCLIENT_DEBUG
  fprintf(stderr, "header in response_header: %s\n", ((struct Response *)r)->header);
  #endif
  return ((struct Response *) r)->header;
}

size_t response_body_size(struct Response *r) {
  return ((struct Response *) r)->body_size;
}

size_t response_header_size(struct Response *r) {
  return ((struct Response *) r)->header_size;
}

void* http_easy_init(void) {
  CURL *curl = curl_easy_init();
  return (void *) curl;
}

void http_easy_cleanup(void *curl) {
  return curl_easy_cleanup((CURL *) curl);
}

int http_easy_setopt_url(void *curl, char *url) {
  return (int) curl_easy_setopt((CURL *) curl, CURLOPT_URL, url);
}

int http_easy_setopt_method(void *curl, int method) {
  CURL *c = (CURL *) curl;
  switch (method) {
    case 1: // POST ;
      #ifdef _HTTPCLIENT_DEBUG
      fprintf(stderr, "setup post request");
      #endif
      return curl_easy_setopt(curl, CURLOPT_POST, 1L);
      break;
    default: //GET ;
      #ifdef _HTTPCLIENT_DEBUG
      fprintf(stderr, "setup get request");
      #endif
      return curl_easy_setopt(c, CURLOPT_HTTPGET,  1L);
      break;
  }
}

int http_easy_setopt_postfields(void *curl, char* data) {
  CURL *c = (CURL *) curl;
  return curl_easy_setopt(c, CURLOPT_POSTFIELDS, data);
}

void *http_easy_perform(void *curl) {
  long response_code;
  CURLcode res;
  char *bodyBuffer;
  char *headerBuffer;
  size_t bodySize;
  size_t headerSize;
  FILE *bodyFile;
  FILE *headerFile;

  bodyFile = open_memstream (&bodyBuffer, &bodySize);
  headerFile = open_memstream (&headerBuffer, &headerSize);

  curl_easy_setopt((CURL *) curl, CURLOPT_WRITEDATA, (void *)bodyFile);
  curl_easy_setopt((CURL *) curl, CURLOPT_HEADERDATA, (void *)headerFile);

  res = curl_easy_perform((CURL *) curl);
  fclose(bodyFile);
  fclose(headerFile);

  if (res != CURLE_OK) {
    fprintf(stderr, "curl_easy_perform() failed: %s\n--- %s, line %d\n",
      curl_easy_strerror(res),
      __FILE__,
      __LINE__);
    return NULL;
  }
  else {
    res = curl_easy_getinfo((CURL *) curl, CURLINFO_RESPONSE_CODE, &response_code);
    response.response_code = response_code;
    response.header_size = headerSize;
    response.header = headerBuffer;
    response.body_size = bodySize;
    response.body = bodyBuffer;
    #ifdef _HTTPCLIENT_DEBUG
    fprintf(stderr, "header in http_easy_perform: %s\n", headerBuffer);
    fprintf(stderr, "body in http_easy_perform: %s\n", bodyBuffer);
    #endif

    return &response;
  }
}
