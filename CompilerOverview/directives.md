```c
#define __DATE__ #exe{StreamPrint("\"%D\"",Now);}
#define __TIME__ #exe{StreamPrint("\"%T\"",Now);}
#define __LINE__ #exe{StreamPrint("%d",Fs->last_cc->lex_include_stk->line_num);}
#define __CMD_LINE__ #exe{StreamPrint("%d",Fs->last_cc->flags&CCF_CMD_LINE && Fs->last_cc->lex_include_stk->depth<1);}
#define __FILE__ #exe{StreamPrint("\"%s\"",Fs->last_cc->lex_include_stk->full_name);}
#define __DIR__  #exe{StreamDir;}
```
See ![Directives.HC](https://github.com/SpaciousCoder78/holyc-docs/blob/main/HC/Directives.HC)
