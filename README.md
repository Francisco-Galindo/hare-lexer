# Lexer

<div align="center">
  <img src="https://cloudfront-us-east-1.images.arcpublishing.com/infobae/QLXAPU64VVD7DMR5ZF7VIEH4HQ.jpg" alt="Logo UNAM" width="200"/>
  <h1> Universidad Nacional Autónoma de México </h1>
  <h2> Ingeniería en Computación </h2>
  <h2> Compiladores </h2>
  <h1> Lexer - Lexical Analysis </h1>
  <h2> Alumnos: </h2>
  <h3>320198388</h3>
  <h3>320051665</h3>
  <h3>320298608</h3>
  <h3>320244612</h3>
  <h3>320054336</h3>
  <h2> Grupo 5 </h2>
  <h2> Semestre 2025-2 </h2>
  <h4> México, CDMX. Marzo 2025 </h4>
</div>





## Table of contents   
1. [Introduction](#introduction)
2. [Theorical Background](#theoricalbackground)
3. [Development](#development)
   1. [Lexer construction](#lexerconstruction)
   2. [Context-Free Grammar](#context-freegrammar)  
4. [Results](#results)
5.  [Conclusion](#conclusion)
6.   [Sources](#sources)



## Introduction  


## Theorical Background 
The first phase of a compiler is known as lexical analisys. In this phase, the source program is read character by character from left to right, organizing each part of the code into tokens.
Tokens are meaningful sequences of characters, than can be divided into six different categories depending on the characteristic of the token and the programming language, being the categories of the tokens the next ones:
* Keywords: the strings asigned to this group are the the ones that belong to strings that are reserved as special words for the language An example for this in Hare is the word let, to declare variables.
* Identifiers: these strings are asigned to this group when they are used to name a variable, function, etc.
* Punctuators: these strings are used to delimit a block of code or to indicate the end of a section. This could be "()", "{}" or "[]" to indicate where the block starts and ends, "," to separate strings or ";" to indicate the end of the line.
* Literals: these are strings that will never change, such as code inside of quotation marks.
* Operators: these characters are asigned to this group when their purpose is to indicate a type of operation that is going to be realized, such as "+", "-", etc.
Constants: these are strings that, once the code is executed their value will never change, such as numbers or strings asigned to variables.

To create our lexical analyzer we decided to use a language called Hare. Hare is a language designed to be simple, stable, and robust, using a static type system, manual memory managment and minimal runtime. This language was specially designed to be used on operating systems, compilers and other low level, high performance tasks

## Development

### Lexer construction

### Context-Free Grammar


## Results

## Conclusion

## Sources
https://www.geeksforgeeks.org/introduction-of-lexical-analysis/
https://harelang.org/
