# Project: Compiler Design for the Lambda Programming Language

This project is part of the *Computational Theory* course and aims to deepen the understanding and application of theoretical tools, such as regular expressions and context-free grammars,
to the problem of compiling programming languages.

Specifically, this project focuses on the design and implementation of the initial stages of a compiler for the fictional programming language Lambda, described in detail below.

## Project Overview

In this project, we will develop a source-to-source compiler (also known as a trans-compiler or transpiler).
This type of compiler takes as input the source code of a program written in one programming language and produces equivalent source code in another programming language.
In our case, the input source code will be written in the fictional Lambda programming language, and the output code will be in the familiar programming language C.

For this project, we will use the tools flex and bison, which are freely available software packages, and the programming language C for implementation.

The project consists of two main parts:

1. Implementation of the Lexical Analyzer for the Lambda language using flex
2. Implementation of the Syntax Analyzer for the Lambda language using bison
