#ifndef __HTTP_H
#define __HTTP_H

//
// CURL_EXTERN CURL *curl_easy_init(void);
// CURL_EXTERN CURLcode curl_easy_setopt(CURL *curl, CURLoption option, ...);
// CURL_EXTERN CURLcode curl_easy_perform(CURL *curl);
// CURL_EXTERN void curl_easy_cleanup(CURL *curl);

long response_code(void *r);

char *response_body(void *r);
char *response_header(void *r);

size_t response_body_size(void *r);
size_t response_header_size(void *r);


int http_easy_setopt_url(void *curl, char *url);
int http_easy_setopt_method(void *curl, int method);
int http_easy_setopt_postfields(void *curl, char* data);
int http_easy_setopt_follow(void *curl);

void *http_header_append(void *curl, char *header );

void *http_easy_init(void);
void *http_easy_perform(void *curl);
void http_easy_cleanup(void *curl);


#endif
