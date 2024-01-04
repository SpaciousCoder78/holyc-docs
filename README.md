# holyc-docs
Documentation of HolyC 

![HolyC_Logo svg(1)](https://github.com/SpaciousCoder78/holyc-docs/assets/88923986/496e343e-c6ec-4672-9150-e614ba799b2d)





## Preface

This documentation is being hosted to preserve HolyC, which is a creation of legendary programmer, Terry Davis.

The documentation is an archive of https://templeos.holyc.xyz/Wb/Doc/HolyC.html#l1

Terry Davis(1969-2018)

![122981344-50e0bb00-d3a2-11eb-9132-2c0b4733457f](https://github.com/SpaciousCoder78/holyc-docs/assets/88923986/954a4b93-84db-42e0-86bd-3bd4c773eb83)


Our aim is to preserve HolyC for the future generation. As of now, there's no solid documentation online for HolyC. The ones that existed went offline so there's a need for a new documentation to preserve HolyC and the legacy of Terry Davis.

## HolyC

* Built-in types include `I0`,`I8`,`I16`,`I32`,`I64` for signed 0-8 byte ints and `U0`,`U8`,`U1
6`,`U32`,`U64` for unsigned 0-8 byte ints and `F64` for 8 byte floats.
```c
        U0      void, but ZERO size!
        I8      char
        U8      unsigned char
        I16     short
        U16     unsigned short
        I32     int
        U32     unsigned int
        I64     long (64-bit)
        U64     unsigned long (64-bit)
        F64     double
        no F32 float.
```
* Function with no args, or just default args can be called without parentheses. 
```c
  >Dir("*");
  >Dir();
  >Dir;
```

* Default args don't have to be on the end.  This code is valid:

```c
  U0 Test(I64 i=4,I64 j,I64 k=5)
  {
    Print("%X %X %X\n",i,j,k);
  }
  
  Test(,3);
```
* A char const all alone is sent to `PutChars()`.  A string with or without args 
is sent to `Print()`.  An empty string literal signals a variable fmt_str follows.
```c
  void DemoC(char drv,char *fmt,char *name,int age)
  {
    printf("Hello World!\n");
    printf("%s age %d\n",name,age);
    printf(fmt,name,age);
    putchar(drv);
    putchar('*');
  }
  
  U0 DemoHolyC(U8 drv,U8 *fmt,U8 *name,I64 age)
  {
    "Hello World!\n";
    "%s age %d\n",name,age;
    "" fmt,name,age;
    '' drv;
    '*';
  }
```
* When dealing with function addresses such as for callbacks, precede the name 
with "&".

* Type casting is postfix.  To typecast int or F64, use `ToI64()`, `ToBool()` or 
`ToF64()`. (TempleOS follows normal C float<-->int conversion, but sometimes you 
want to override.  These functions are better than multiplying by "1.0" to 
convert to float.) 

* There is no `main()` function.  Any code outside of functions gets executed upon 
start-up, in order.

* There are no bit fields, but there are bit access routines and you can access 
bytes or words within any int.  See `I64` declaration.  A class can be accessed as 
a whole are subints, if you put a type in front of the class declaration.
```c  
  public I64i union I64         //"I64i" is intrinsic.  We are defining "I64".
  {
    I8i i8[8];
    U8i u8[8];
    I16 i16[4];
    U16 u16[4];
    I32 i32[2];
    U32 u32[2];
  };
  
  I64 i=0x123456780000DEF0;
  i.u16[1]=0x9ABC;
```

* Variable arg count functions (...) can access their args with built-in 
variables similar to 'this' in C++.  They are 'I64 argc' and 'I64 argv[]'.  
```c
  I64 AddNums(...)
  {
    I64 i,res=0;
    for (i=0;i<argc;i++)
      res+=argv[i];
    return res;
  }
  
  >AddNums(1,2,3);
  ans=6
  
  
  public U0 GrPrint(CDC *dc,I64 x,I64 y,U8 *fmt,...)
  {
    U8 *buf=StrPrintJoin(NULL,fmt,argc,argv);//SPrintF() with MAlloc()ed string.
    GrPutS(dc,x,y,buf); //Plot string at x,y pixels. GrPutS is not public.
    Free(buf);
  }
  
    ...
  
    GrPrint(gr.dc,(GR_WIDTH-10*FONT_WIDTH)>>1,(GR_HEIGHT-FONT_HEIGHT)>>1,
        "Score:%4d",score);  //Print score in the center of the scrn.
    ...
  ```

* Allows "5<i<j+1<20" instead of "5<i && i<j+1 && j+1<20".
```c
  if (13<=age<20)
    "Teen-ager";
```
* if you know a switch stmt will not exceed the lowest or highest case values.  
`switch []` is a little faster because it doesn't check.

* `switch` stmts always use a jump table.  Don't use them with cases with really 
big, sparse ranges.

* Allows ranges like "case 4...7:" in `switch` stmts.

* A no case number causes next higher int case in switch stmts.  See 
::/Demo/NullCase.HC.
```c
  I64 i;
  for (i=0;i<20;i++) 
    switch (i) {
      case: "Zero\n";   break; //Starts at zero
      case: "One\n";    break; //One plus prev case.
      case: "Two\n";    break;
      case: "Three\n";  break;
      case 10: "Ten\n"; break;
      case: "Eleven\n"; break; //One plus prev case.
  }
```
* Switch statements can be nestled with a single switch expression!  This is 
known as a "sub_switch" statement.  start/end are used to group cases.  Don't 
goto out of, throw an exception out of, or return out of the start front porch 
area.  See ::/Demo/SubSwitch.HC.
```c
  I64 i;
  for (i=0;i<10;i++)
    switch (i) {
      case 0: "Zero ";  break;
      case 2: "Two ";   break;
      case 4: "Four ";  break;
      start:
        "[";
        case 1: "One";  break;
        case 3: "Three";break;
        case 5: "Five"; break;
      end:
        "] ";
        break;
    }
```
  OutPut:
  ```
  >Zero [One] Two [Three] Four [Five]
```
* A `no_warn` stmt will suppress an unused var warning.

* You can have multiple member vars of a class named "pad" or "reserved", and it 
won't issue warnings. 

* `noreg` or `reg` can be placed before a function local var name.  You can, 
optionally, specify a reg after the reg keyword.
```c
  U0 Main()
  {
    //Only use REGG_LOCAL_VARS or REGG_LOCAL_NON_PTR_VARS for reg vars or else 
  clobbered.
    I64 reg R15 i=5, noreg j=4;
    no_warn i;
    asm {
        MOV     RAX,R15
        CALL    &PUT_HEX_U64
        MOV     RAX,'\n'
        CALL    &PUT_CHARS
        MOV     RAX,U64 &j[RBP]
        CALL    &PUT_HEX_U64
        MOV     RAX,'\n'
        CALL    &PUT_CHARS
    }
  }
```
* `interrupt`, `haserrcode`, `public`, `argpop` or `noargpop` are function flags. See 
IRQKbd().

* A single quote can encompass multiple characters.  'ABC' is equ to 0x434241.  
`PutChars()` takes multiple characters.

```c
  asm {
  HELLO_WORLD::
        PUSH    RBP
        MOV     RBP,RSP
        MOV     RAX,'Hello '
        CALL    &PUT_CHARS
        MOV     RAX,'World\n'
        CALL    &PUT_CHARS
        LEAVE
        RET
  }
  Call(HELLO_WORLD);
  PutChars('Hello ');
  PutChars('World\n');
```
* The "`" operator raises a base to a power.

* There is no question-colon operator.

* TempleOS operator precedence
  `,>>,<<
  *,/,%
  &
  ^
  |
  +,-
  <,>,<=,>=
  ==,!=
  &&
  ^^
  ||
  =,<<=,>>=,*=,/=,&=,|=,^=,+=,-=

* You can use `Option(OPTf_WARN_PAREN,ON)` to find unnecessary parentheses in 
code.

* You can use `Option(OPTf_WARN_DUP_TYPES,ON)` to find dup local var type stmts.

* With the `#exe{}` feature in your src code, you can place programs that insert 
text into the stream of code being compiled.  See `#exe {}` for an example where 
the date/time and compile-time prompting for cfguration data is placed into a 
program.  `StreamPrint()` places text into a src program stream following the 
conclusion of the `#exe{}` blk.

* No `#define` functions exist (I'm not a fan)

* No `typedef`, use `class`.

* No type-checking

* Can't use `<>` with `#include`, use `""`.

* "$" is an escape character.  Two dollar signs signify an ordinary $.  See 
DolDoc.  In asm or HolyC code, it also refers to the inst's address or the 
offset in a class definition. 

* `union` is more like a class, so you don't reference it with a `union` label after 
you define it.  Some common unions are declared in KernelA.HH for 1,2,4 and 8 
byte objects.  If you place a type in front of a union declaration, that is the 
type when used by itself.  See ::/Demo/SubIntAccess.HC. 

* `class` member vars can have meta data. format and data are two meta data types 
now used.  All compiler structures are saved and you can access the compiler's 
info about classes and vars.  See ::/Demo/ClassMeta.HC and  DocForm().

* There is a keyword `lastclass` you use as a dft arg.  It is set to the class 
name of the prev arg.  See ::/Demo/LastClass.HC, ClassRep(), DocForm()  and 
::/Demo/Dsk/BlkDevRep.HC.

* See ::/Demo/Exceptions.HC. ` try{}` `catch{}` and throw are different from C++. `th
row` is a function with an 8-byte or less char arg.  The char string passed in `th
row()` can be accessed from within a `catch{}` using the Fs->except_ch.  Within a `c
atch {}` blk, set the var Fs->catch_except to TRUE if you want to terminate the 
search for a hndlr.  Use PutExcept() as a hndlr, if you like.

* A function is available similar to sizeof which provides the offset of a 
member of a class.  It's called `offset`.  You place the class name and member 
inside as in `offset(classname.membername)`.  It has nothing to do with 16-bit 
code.  Both `sizeof` and `offset` only accept one level of member vars.  That is, 
you can't do `sizeof(classname.membername.submembername)`.

* There is no `continue` stmt.  Use `goto`.

* `lock{}` can be used to apply asm LOCK prefixes to code for safe multicore 
read-modify-write accesses.  The code bracked with have LOCK asm prefix's 
applied to relevant insts within.  It's a little shoddy.  See 
::/Demo/MultiCore/Lock.HC.

* There is a function called `MSize()` which gives the size of an object alloced 
off the heap.  For larger size allocations, the system rounds-up to a power of 
two, so `MSize()` lets you know the real size and you can take full advantage of 
it.

* You CAN `Free()` a NULL ptr.  Useful variants of `MAlloc()` can be found Here.  
Each task has a heap and you can `MAlloc` and Free off-of other task's heaps, or 
make an independent heap with `HeapCtrlInit()`.  See `HeapLog()` for an example.

* The stk does not grow because virtual mem is not used.  I recommend allocating 
large local vars from the heap.  You can change `MEM_DFT_STK` and recompile Kernel 
or request more when doing a `Spawn()`.  You can use `CallStkGrow()`, but it's odd.  
See ::/Demo/StkGrow.HC. 

* Only one base class is allowed.

* `printf()` has new codes.  See `Print("")` Fmt Strings.

* All values are extended to 64-bit when accessed.  Intermediate calculations 
are done with 64-bit values.
```c
  U0 Main()
  {
    I16 i1;
    I32 j1;
    j1=i1=0x12345678;           //Resulting i1 is 0x5678 but j1 is 0x12345678
  
    I64 i2=0x8000000000000000;
    Print("%X\n",i2>>1);        //Res is 0xC000000000000000 as expected
  
    U64 u3=0x8000000000000000;
    Print("%X\n",u3>>1);        //Res is 0x4000000000000000 as expected
  
    I32 i4=0x80000000;          //const is loaded into a 64-bit reg var.
    Print("%X\n",i4>>1);        //Res is 0x40000000
  
    I32 i5=-0x80000000;
    Print("%X\n",i5>>1);        //Res is 0xFFFFFFFFC0000000
  }
```
