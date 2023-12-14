# A Way to Practice Assembly Language In WinXP system

> This text takes aim at showing a user-friendly method to create a 32-bit environment in your laptop.

## Installation

For  this curriculum, do some practice after class may be a better way to obtain what you have just learnt. In before lessons, a microprocessor called Pentium was introduced, and it's a **32-bit** system. So, the problem is how to create such a environment where 32-bit instruction is supported.

A solution based on **virtual machine** is proposed in this short guide. WinXP is 32-bit system launched by Inter Inc. in 2001, and that's exactly what we need. Actually, the installation packages of the system is not supported in Microsoft official website, but we can find them in below: **<https://msdn.itellyou.cn>**

The next question is: where to run this system? Using virtual machine may be a good solver. For example, **VMware** is a wonderful option for us. Find the package which is free to use should not be a hard-takling problem for the smart you!

After installing environment, another question is how to compile your code file.  Assembler is a program that will compile your code and transfer to machine language, which is executable for your computer. For most of users, **DOSbox** or **MASM** both are easy to use, and my choice is MASM (just for habit).

Now we can write a code file end with suffix **.asm**, then build and link it, and the program is going to run!

For better understanding, here is a short line that put them in order.
1. write
2. build by MASM.exe
3. link by link.exe
4. debug

## Practice by yourself

source code here:

```assembly
assume cs:codesg

codesg segment
    mov ax,2000H
    mov ss,ax
    mov sp,0
    add sp,10
    pop ax
    pop bx
    push ax
    push bx
    pop ax
    pop bx

    mov ax,4c00H
    int 21H

codesg ends

end
```

By running in single step, it should be noticed that values of some registers are changed. 
> Warnings can be ignored, such as ``Warning L4021: no stack segment``

## Problems that I had met

### Using debug program in comand line, do not just click debug.exe

When I firstly tried to watch what had happened after running my code, so I build, link and run the program, then I clicked debug.exe, but nothing was changed which should not be like that.

I questioned in internet, and found a different way: **run debug program in comand line**, and it really worked!

Here is a short guide of debugging:

Firstly, open cmd, and switch to your destination file package, and write down ``debug test.exe``. Secondly, by using command ``-t`` if we want to watch the changes that should be caused by your command, then your program will be executed **in single step mode**.
