# Scoping and Linkage

JIT Compile Mode makes use of the current task's hash sym table and its parent 
tasks' tables.  It fetches syms from parent tasks' tables if not found locally 
in the current task's table and it places new syms in the current task's table.  
Conceptually, syms are at the scope of environment vars in other operating 
systems.

When a sym is placed into a table, older syms with ident names will be 
overshadowed if they exist.  Duplicates are not allowed in many cases, 
especially in asm blks.  Dupicates are allowed, by design in other cases, so 
that you can repeatedly `#include` the same file from the cmd line while 
developing it.  Or, so you can repeatedly declare a function with a standard 
name, like `DrawIt()`.  This case might occur when the Adam Task is starting-up 
loading-in many little utilities.

`extern` binds a new `HTT_FUN` or `HTT_GLBL_VAR` sym to an existing sym of the same 
name if it exists in the sym table (just in just-in-time code).  It also can be 
used to generate a fwd reference.

`import` binds a new `HTT_FUN` or `HTT_GLBL_VAR` sym to a sym of the same name 
imported from the task's sym table at `Load()` time.  If no sym exists to bind to 
at `Load()` time, the code using this sym will be left incomplete until the sym is 
defined.


`_extern` binds a new `HTT_FUN` or `HTT_GLBL_VAR` sym to an existing sym, of a differe
nt name.  It must exists in the sym table.  Basically, this binds C to asm.

`_import` binds a new `HTT_FUN` or `HTT_GLBL_VAR` sym to a sym, of a different name 
imported from the task's sym table at `Load()` time.  If no sym exists to bind to 
at `Load()` time, the code using this sym will be left incomplete until the sym is 
defined.  Basically, this binds C to asm from elsewhere.

```
Ahead of Time Compilation
                    GlobalScope/FunctionScope
                    | CodeHeap/DataHeap/Stack/Register
                    | | TaskHashEntry:ExportSysSym/Define/Function/Class
                    | | | UsageScope: Module/AsmLocal/AsmBlk/TaskAndChildren/Function
                    | | | |UsageScope: Glbl/AsmLocal/Remainder/glblThisBlkAndRemainder
                    | | | || StaticVarInit/DynamicVarInitAllowed/NoInitAllowed
                    | | | || | Are dups allowed within the namespace? A dup overshadows the original.
                    | | | || | DupsAllowed/NoDups/NoDupsButPad/WarningUnlessClosedOut
```
```c
asm export label::  G C S MG   N
asm        label:   G C   MG   N
asm local  @@label: G C   AL   N
asm IMPORT label;   G C   MR   N
asm export label::  F C S BG   N
asm        label:   F C   BG   N
asm local  @@label: F C   AL   N
asm IMPORT label;   F C   BR   N
C   goto   label:   F C   FG   N

           #define  x     MR   D
           function G C S MR   D
           var      F R   FR   N
           var      F S   FR   N
static     var      F C   FR D N
           var      G C S MR D D
           var      G D   MR N D
           class    G     MR   D
class      member   G     MR   P
extern     class    G     MR   D
extern     function G C   MR   W
import     function G C   MR   D
import     var      G C   MR   D
_extern    function G C   MR   D
_extern    var      G C   MR   D
_import    function G C   MR   D
_import    var      G C   MR   D
```
```
Just in Time Compilation
                    GlobalScope/FunctionScope
                    | CodeHeap/DataHeap/Stack/Register
                    | | TaskHashEntry:ExportSysSym/Define/Function/Class
                    | | | UsageScope: Module/AsmLocal/AsmBlk/TaskAndChildren/Function
                    | | | |UsageScope: Glbl/AsmLocal/Remainder/glblThisBlkAndRemainder
                    | | | || StaticVarInit/DynamicVarInitAllowed/NoInitAllowed
                    | | | || | Are dups allowed within the namespace? A dup overshadows the original.
                    | | | || | DupsAllowed/NoDups/NoDupsButPad/WarningUnlessClosedOut
```
```c
asm export label::  G C S Tg   N
asm        label:   G C   BG   N
asm local  @@label: G C   AL   N
asm IMPORT label;   G C   TR   N
asm export label::  F C   BG   N
asm        label:   F C   BG   N
asm local  @@label: F C   AL   N
asm IMPORT label;   F C   BR   N
C   goto   label:   F C   FG   N

           #define  x   D TR   D
           function G C F TR   D
           var      F R   FR   N
           var      F S   FR   N
static     var      F C   FR D N
           var      G C G TR D D
           var      G D G TR S D
           class    G   C TR   D
class      member   G     TR   P
extern     class    G   C TR   D
extern     function G C F TR   W
extern     var      G C G TR   D
extern     var      G D G TR   D
_extern    function G C F TR   D
_extern    var      G C G TR   D
```

* Goto labels must not have the same name as global scope objects.  GoTo's are 
rare and I don't want to slow the compiler and add code to fix this.  You will 
get errors if a collision happens, so it's not very dangerous, but the error 
message is baffling.

* The member names `pad` and `reserved` are special because multiple instances with 
the same name are allowed in a class.

* Use `reg` or `noreg` in front of local var names to override automatic reg var 
allocation.  You can, optionally, specify a `reg` after the reg keyword.
 
* Local non-reg function vars can be accessed in asm blks with `&i[RBP]` for 
example.

* Glbl vars and functions can be accessed in asm with and & as in

 ```asm
        MOV     RAX,I64 [&glbl_var]
        CALL    I32 &Fun
        CALL    I32 &SYS_SYM
```
* In JIT asm code, `&SYS_SYM` and `&Fun` don't need `IMPORT`.

* All offspring tasks of a task inherit syms.

* The `sizeof()` and HolyC structure members can be used in asm blks.

* Using `&i` in HolyC or `i.u8[2]` on a local var, `i`, will force it to noreg.

* Using try/catch in a function will force all local vars to noreg.

* An unused gap on the stk is left for reg vars.

* Note: static function vars do not go on the data heap, no matter the setting 
of the `OPTf_GLBLS_ON_DATA_HEAP`.  They may in the future.

* `OPTf_EXTERNS_TO_IMPORTS` will treat `_extern` as `_import` and `extern` as `import`.  
This allows a header to be used either as a JIT compiled or AOT compiled header.
