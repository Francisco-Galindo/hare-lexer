# Lexer

<div align="center">
  <img src="https://cloudfront-us-east-1.images.arcpublishing.com/infobae/QLXAPU64VVD7DMR5ZF7VIEH4HQ.jpg" alt="Logo UNAM" width="200"/>
  <p> Universidad Nacional Autónoma de México </p>
  <p> Ingeniería en Computación </p>
  <p> Compiladores </p>
  <p> Lexer - Lexical Analysis </p>
  <p> Alumnos: </p>
  <p>320198388</p>
  <p>320051665</p>
  <p>320298608</p>
  <p>320244612</p>
  <p>320054336</p>
  <p> Grupo 5 </p>
  <p> Semestre 2025-2 </p>
  <p> México, CDMX. Marzo 2025 </p>
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
In this project, our team will develope a lexer using the Hare programming language, both for implementing the lexical analyzer and for the language it will process. The lexer is one of the first stages on a compiler or interpreter, its main function is to take a sequence of characters from the input and transform it into a string of tokens, that represent meaningful sintactic units of the language.
Using Hare as the development language will allow us to take advantage of its minimalist and efficient approach, ensuring a fast and reliable lexer. Throughout the development process, we will implement lexical rules that will define the structure of the target language, including identifiers, operators, keywords and other essential sintactic elements.
This project will not only allow us to explore the construction of lexical analyzers but also deepen our understanding of Hare ans its applicability in developing tools for programming languages.

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
To create the lexer, first we needed to know what keywords formed part of the hare language so as to make clear to the lexer, if those words appeared, that they are not identifiers. Hare already has a document that has all of hare's keywords, called tokens.ha, which we used to cover all the keywords of hare language.

As for the lexer code, the first thing you'll find in lex.ha is the structure of the lexer. After that, in the function called lex is where the magic starts to happen. First it advances to the next character, guaranteeing this way that it gets to the end of the document one way or another. Then, it checks if the character the code is on is a space or a newline, in which case it ccalls itself to continue. In is_word_rune, the function verifies if the token it is over is a valid start of an identifier, and, if it is, it calls the function lex_word_rune. after that, the next part verifies if the part you're on is a number, in which case it calls lex_number function. After that, it verifies if it's a puntctuation sign returning the value of the sign if it's one or, in case it is an operator character it calls the function lex_troll.

The function lex_word_rune verifies if the word that is analizing is valid as an identifier, validating character by character if it is valid as a part of an identifier.

The lex_number function validates if the number that hs been send is valid, validating numbers in base 10, hexadecimal and binary. After that, it goes through the number checking if it's a valid number or, in case it finds a non numerical character in the number it returns an error.

The lex_troll function checks what kind of operator is on the code. If the operstor is longer than one character, it goes through the next symbols until it finds the end of the operator, validating with this all the cases of operators such as <= for example.

The lex_literal function works as a validator for Strings inside of quotation Marks, and for this, in lex, if the symbol found is one quotation mark, it calls the function lex_literal and goes through all the string until it finds the second quotation mark.

All of the lexer functions are called through the lex function which is called in the main function in another document. The main function recieves the name of the document to analyze through the terminal, and reads the document with the lexer function until it finishes everything.


### Context-Free Grammar


## Results

## Conclusion

## Sources
https://www.geeksforgeeks.org/introduction-of-lexical-analysis/
https://harelang.org/
