typedef uint64_t bfd_vma;
typedef unsigned char bfd_byte;
typedef int (*fprintf_ftype)(void*, const char*, ...);
struct disassemble_info;
typedef struct disassemble_info {
  fprintf_ftype fprintf_func;
  void *stream;
  int (*read_memory_func)(bfd_vma, bfd_byte*, unsigned int, struct disassemble_info*);
  void (*memory_error_func)(int, bfd_vma, struct disassemble_info*);
  void (*print_address_func)(bfd_vma, struct disassemble_info*);
} disassemble_info;
#define OPCODES_ASSERT(x) do{ if(!(x)) { fprintf(stderr,"assert %s\n",#x); abort(); } }while(0)
int print_insn_h8300s (bfd_vma addr, disassemble_info *info);
