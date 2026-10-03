static void *xmalloc(size_t n){void*p=malloc(n);if(!p)abort();return p;}
static int startswith(const char*s,const char*p){return strncmp(s,p,strlen(p))==0;}
