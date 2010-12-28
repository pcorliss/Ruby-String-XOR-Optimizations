#include <ruby.h>
#include <stdio.h>
#include <stdlib.h>

static VALUE rb_mXor;

static VALUE xor_multi(VALUE class, VALUE rb_blocks, VALUE buffer) {
  unsigned int numBlocks = RARRAY_LEN(rb_blocks);
  unsigned long i;
  unsigned long j;
  VALUE *element = RARRAY_PTR(rb_blocks);
  unsigned long length = NUM2INT(buffer);
  unsigned char *outbuf = calloc(length,sizeof(*outbuf));
  unsigned char *data_str;
  VALUE ruby_return_str;
  
  if(outbuf == NULL){
    printf("Unable to allocate memory\n");
    exit;
  }
  
  for(i=0;i<numBlocks;i++){
    data_str = RSTRING_PTR(*element);
    for(j=0;j<length;j++){
      //printf("%i ^= %i ==",outbuf[j],data_str[j]);
      outbuf[j] ^= data_str[j];
      //printf("%i\n",outbuf[j]);
    }
    element++;
  }
  ruby_return_str = rb_str_new2(outbuf);
  free(outbuf);
  
  return ruby_return_str;
}

void Init_xor() {
  rb_mXor = rb_define_module("XOR");

  rb_cClass = rb_define_class_under(rb_mXor, "Class", rb_cObject);
  
  rb_define_method(rb_cClass, "xor_multi", xor_multi, 2);
}
