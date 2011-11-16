//+------------------------------------------------------------------+
//|                                                      wininet.mqh |
//|                                      Copyright 2011, Investeo.pl |
//|                                           http://www.investeo.pl |
//+------------------------------------------------------------------+

#import "wininet.dll"
int InternetAttemptConnect(int x);
int InternetOpenW(string &sAgent,int lAccessType,string &sProxyName,string &sProxyBypass,int lFlags);
int InternetConnectW(int hInternet,string &lpszServerName,int nServerPort,string &lpszUsername,string &lpszPassword,int dwService,int dwFlags,int dwContext);
int HttpOpenRequestW(int hConnect,string &lpszVerb,string &lpszObjectName,string &lpszVersion,string &lpszReferer,int lplpszAcceptTypes,uint dwFlags,int dwContext);
int HttpSendRequestW(int hRequest,string &lpszHeaders,int dwHeadersLength,uchar &lpOptional[],int dwOptionalLength);
int HttpQueryInfoW(int hRequest,int dwInfoLevel,uchar &lpvBuffer[],int &lpdwBufferLength,int &lpdwIndex);
int HttpAddRequestHeadersW(int hRequest, string &lpszHeaders, int dwHeadersLength, uint dwModifiers);
int InternetOpenUrlW(int hInternet,string &lpszUrl,string &lpszHeaders,int dwHeadersLength,int dwFlags,int dwContext);
int InternetReadFile(int hFile,uchar &sBuffer[],int lNumBytesToRead,int &lNumberOfBytesRead);
int InternetCloseHandle(int hInet);
#import

#define OPEN_TYPE_PRECONFIG           0  // use confuguration by default
#define FLAG_KEEP_CONNECTION 0x00400000  // keep connection
#define FLAG_PRAGMA_NOCACHE  0x00000100  // no cache
#define FLAG_RELOAD          0x80000000  // reload page when request
#define SERVICE_HTTP                  3  // Http service
#define HTTP_QUERY_CONTENT_LENGTH     5
#define HTTP_ADDREQ_FLAG_ADD      0x20000000
#define HTTP_ADDREQ_FLAG_REPLACE  0x80000000
