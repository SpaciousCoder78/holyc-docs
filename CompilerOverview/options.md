Use `Option()`.  You might need to do `#exe {Option();}`.

`OPTf_GLBLS_ON_DATA_HEAP` without this option, global vars are placed in the code 
heap which is limited to 2Gig.  In AOT modules, global vars take-up room in the 
`.BIN` file, so you might want to use this option, instead.  You might wish to 
turn it on and off around specific vars.  A disadvantage of data heap global 
vars in AOT modules is they can't be initialized.

`OPTf_EXTERNS_TO_IMPORTS` and `OPTf_KEEP_PRIVATE` are strange options, you'll never 
need.  They're to allow the same header file for Kernel to act as externs when 
compiling itself and imports when compiled by AOT modules.

`OPTf_WARN_UNUSED_VAR`    warning if unused var.  It is applied to functions.

`OPTf_WARN_PAREN `        warning if parenthesis are not needed.

`OPTf_WARN_DUP_TYPES`     warning if dup local var type stmts.

`OPTf_WARN_HEADER_MISMATCH` warning if fun header does not match.

`OPTf_NO_REG_VAR` forces all function local vars to the stk not regs.  Applied to 
functions.

`OPTf_NO_BUILTIN_CONST` Disable 10-byte float consts for pi, log2_10, log10_2, 
loge_2.  Applied to functions.
