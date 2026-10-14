/* Pinned Lean 4.28.0 frontend API driver. Uses unmodified Lean runtime, elaborator
 * and kernel. Explicit sysroot; no executable/process-path introspection.
 * This helper is optional; normal installations should use lake build. */
#include <lean/lean.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern void lean_initialize_runtime_module(void);
extern void lean_initialize(void);
extern void lean_enable_initializer_execution(void);
extern lean_object *initialize_Lean(uint8_t, lean_object*);
extern lean_object *l_Lean_initSearchPath(lean_object*,lean_object*,lean_object*);
extern lean_object *l_String_toName(lean_object*);
extern lean_object *lean_options_get_empty(lean_object*);
static lean_object *l_Lean_Options_empty;
extern lean_object *l_Lean_Elab_runFrontend(lean_object*,lean_object*,lean_object*,lean_object*,uint32_t,lean_object*,lean_object*,uint8_t,lean_object*,lean_object*,uint8_t,lean_object*,lean_object*);
extern lean_object *lean_run_main(lean_object*,lean_object*,lean_object*,lean_object*);
static void ck(lean_object *r) { if(lean_io_result_is_error(r)){lean_io_result_show_error(r);exit(1);} }
static lean_object *some(const char *s){lean_object*r=lean_alloc_ctor(1,1,0);lean_ctor_set(r,0,lean_mk_string(s));return r;}
int main(int argc,char**argv){
 if(argc<4){fprintf(stderr,"Usage: frontend SYSROOT INPUT MODULE [OUTPUT|--run ARGS...]\n");return 2;}
 lean_initialize_runtime_module();lean_initialize();
 lean_object*r=initialize_Lean(1,lean_io_mk_world());ck(r);lean_dec(r);
 lean_io_mark_end_initialization();lean_init_task_manager();lean_enable_initializer_execution();
 r=l_Lean_initSearchPath(lean_mk_string(argv[1]),lean_box(0),lean_io_mk_world());ck(r);lean_dec(r);
 FILE*f=fopen(argv[2],"rb");if(!f){perror(argv[2]);return 2;}fseek(f,0,SEEK_END);long n=ftell(f);rewind(f);char*b=malloc(n+1);if(fread(b,1,n,f)!=(size_t)n){fprintf(stderr,"Incomplete input read\n");return 2;}b[n]=0;fclose(f);
 int run=argc>4&&!strcmp(argv[4],"--run");
 l_Lean_Options_empty=lean_options_get_empty(lean_box(0));
 r=l_Lean_Elab_runFrontend(lean_mk_string(b),l_Lean_Options_empty,lean_mk_string(argv[2]),l_String_toName(lean_mk_string(argv[3])),0,argc>4&&!run?some(argv[4]):lean_box(0),lean_box(0),0,lean_mk_empty_array(),lean_mk_empty_array(),0,lean_box(0),lean_io_mk_world());
 ck(r);lean_object*opt=lean_io_result_get_value(r);if(lean_is_scalar(opt)){return 1;}
 if(run){lean_object*args=lean_box(0);for(int i=argc-1;i>=5;i--){lean_object*cons=lean_alloc_ctor(1,2,0);lean_ctor_set(cons,0,lean_mk_string(argv[i]));lean_ctor_set(cons,1,args);args=cons;}lean_object*s=lean_run_main(lean_ctor_get(opt,0),l_Lean_Options_empty,args,lean_io_mk_world());ck(s);return lean_unbox(lean_io_result_get_value(s));}
 return 0;
}
