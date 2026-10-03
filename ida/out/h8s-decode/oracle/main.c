#include "sysdep.h"
#include <stdarg.h>
#include "disassemble.h"
/* usage: h8dis <bin> then lines of hex addresses on stdin; prints addr\tlen\ttext */
static unsigned char *img; static long imglen;
static char buf[512]; static int bl;
static int pf(void*s,const char*f,...){va_list a;va_start(a,f);bl+=vsnprintf(buf+bl,sizeof(buf)-bl,f,a);va_end(a);return 0;}
static int rd(bfd_vma a,bfd_byte*d,unsigned n,disassemble_info*i){ if(a+n>(bfd_vma)imglen) return -1; memcpy(d,img+a,n); return 0;}
static void me(int s,bfd_vma a,disassemble_info*i){pf(0,"<memerr>");}
static void pa(bfd_vma a,disassemble_info*i){pf(0,"0x%lx",(unsigned long)a);}
int main(int c,char**v){FILE*f=fopen(v[1],"rb");fseek(f,0,2);imglen=ftell(f);fseek(f,0,0);img=malloc(imglen);fread(img,1,imglen,f);fclose(f);
 disassemble_info di={pf,0,rd,me,pa}; char line[64];
 while(fgets(line,64,stdin)){unsigned long a=strtoul(line,0,16); bl=0; buf[0]=0; int n=print_insn_h8300s(a,&di); printf("%06lx\t%d\t%s\n",a,n,buf);} return 0;}
