


//Press F5 in the editor to compile and run.

--------Hello.HC.Z---------
"Hello World\n";


--------Hello.HC.Z---------
U0 Main()
{
  "Hello World\n";
}
Main;


--------Hello.HC.Z---------
U0 MyPrint(U8 *st)
{
  "%s",st;
}
MyPrint("Hello World\n");


--------Hello.HC.Z---------
U0 MyPrint2(U8 *st1,U8 *st2) //Any number of args.
{
  "%s %s\n",st1,st2; //Any number of args.
}
MyPrint2("Hello","World");


--------Hello.HC.Z---------
U0 MyPrint(U8 *st)
{
  "" st; //Empty with no comma means first is fmt str.
}
MyPrint("Hello World\n");


--------Hello.HC.Z---------
asm {
MSG:    DU8 "Hello World\n",0;

//The convention is underscore on C callable.
//Two colons means exported symbol.
_HELLO_WORLD::
//You can only clobber RAX,RBX,RCX,RDX
        PUSH    RSI
        MOV     RSI,MSG
        CALL    PUT_STR
        POP     RSI
        RET
}
Call(_HELLO_WORLD);


--------Hello.HC.Z---------
asm {
_HELLO_WORLD::
//You can only clobber RAX,RBX,RCX,RDX
        MOV     RAX,'Hello '
        CALL    PUT_CHARS //Up to 8 chars packed into one 64-bit int.
        MOV     RAX,'World\n'
        CALL    PUT_CHARS
        RET
}
Call(_HELLO_WORLD);


--------Hello.HC.Z---------
asm {
_MY_PRINT::
//You can only clobber RAX,RBX,RCX,RDX
        PUSH    RBP
        MOV     RBP,RSP
        PUSH    RSI
        MOV     RSI,U64 SF_ARG1[RBP]
        CALL    PUT_STR
        POP     RSI
        POP     RBP
        RET1    8       //Callee pops the stack to clear args.
}
_extern _MY_PRINT U0 MyPrint(U8 *st);
MyPrint("Hello World\n");


--------Hello.HC.Z---------
asm {
_MY_PRINT::
//You can only clobber RAX,RBX,RCX,RDX
        PUSH    RBP
        MOV     RBP,RSP
        PUSH    U64 SF_ARG1[RBP]
        CALL    &PutS   //Callee pops the stack to clear args.
        POP     RBP
        RET1    8
}
_extern _MY_PRINT U0 MyPrint(U8 *st);
MyPrint("Hello World\n");
