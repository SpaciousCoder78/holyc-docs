# Assembler
See ::/Compiler/OpCodes.DD for opcodes.  They're not standard.  Some invalid 
insts are not flagged and some valid insts are not implemented. 16-bit asm 
support is limited.

Here are example inst formats:
        ADD     RAX,I64 FS:DISP[RSI+RDI*8]
        ADD     RAX,I64 [DISP]

$ Current compiler output pos (inst ptr).  Even works in HolyC expressions.

$ works in classes.
  class MyFun
  {
    $=-16;
    I64 local1;
    I64 local2;
    $=$+256;
    I64 crazy;
  };

LABEL::
  Defines an exported glbl label.

LABEL:
  Defines an non-exported glbl label.

`@@LABEL`:
  Defines a local label with scope valid between two global labels.

`DU8`, `DU16`, `DU32`, `DU64`
  Define BYTE, WORD, DWORD or QWORD. Can be used with DUP() and ASCII strings.  
For your convenience, the ASCII strings do not have terminating zeros.  Define 
cmds must end with a semicolon.

`USE16`, `USE32`, `USE64`

```c IMPORT sym1name, sym2name;    ```

`LIST`, `NOLIST`

```c ALIGN num```, ```c fill_byte```
  Align to num boundary and fill with `fill_byte`.

```c ORG num```
  Set code addr for JIT or set module `Load()` addr -- has 16-byte `CBinFile` header 
and patch table trailing.

```c BINFILE "FileName.BIN";```

See Assembly Language, `::/Demo/Asm/AsmAndC1.HC`, `::/Demo/Asm/AsmAndC2.HC` and 
`::/Demo/Asm/AsmAndC3.HC.`
