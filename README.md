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

Tokens are the inputs for syntax analysis and interpret the meaning of these tokens. Syntax analysis checks if the tokens are arranged according to the language’s grammar. A context-free grammar define the syntax rules of a programming language. A grammar is said to be the context-free grammar (CFG) if every production is in the form of:

G -> (V&cup;T)*, where G &isin; V 

This equation states that every production which contains any combination of the 'V' variable or 'T' terminal is said to be a context-free grammar. 

A context-free grammar is defined by:
1. Nonterminal symbols (variables).
2. Terminal symbols (alphabet).
3. Production rules.
4. Start symbol.

Context-free grammars have some problems and limitations, including ambiguity and left recursion. Ambiguity generates multiple parse trees for the same input, and left recursion can cause an infinite loop. To create an optimal syntax analyzer, we need to ensure that the CFG is deterministic, right-recursive (eliminating left recursion), and reduces or eliminates ambiguity.

A grammar has direct left recursion if there is a derivation: S -> S𝛼|β, where 𝛼 is a string that can contain terminals or non-terminals, and β is a terminal . The algorithm to convert it to right recursion begins by introducing a new nonterminal and writing it at the end of every production: S -> β S' 

The newly produced nonterminal S' can either produce S' or it can produce a new production where the terminals or non-terminals that follow S will be replaced by the new nonterminal S' at the end of the term: S' -> 𝛼S'|ε

After conversion, the new equivalent production is:

S -> β S' 

S' -> 𝛼S'|ε

This process can be repeated for all the introduced nonterminal if they still have left recursion. Additionally, it can be combined with left factoring.

Left factoring removes the common left factor that appears in two or more productions of the same nonterminal, introducing a new nonterminal. For the production:

A -> 𝛼β1|𝛼β2|𝛼β3

After applying left factoring, the grammar becomes:

A -> 𝛼A'

A' -> β1|β2|β3

In compiler design, BNF stands for Backus-Naur Form notation. It is a formal method for describing the syntax of programming languages, which is understood as the Backus-Naur Form introduced by John Backus and Peter Naur in 1960. The symbol '::=' means "may expand into" or "may be replaced with." Every name is surrounded by angle brackets (< >), whether it appears on the left- or right-hand side of the rule. Simply juxtaposing expressions indicates sequencing, and a vertical bar (|) indicates choice.

To create our lexical analyzer we decided to use a language called Hare. Hare is a language designed to be simple, stable, and robust, using a static type system, manual memory managment and minimal runtime. This language was specially designed to be used on operating systems, compilers and other low level, high performance tasks

## Development

### Lexer construction
To create the lexer, first we needed to know what keywords formed part of the hare language so as to make clear to the lexer, if those words appeared, that they are not identifiers. For this, we created a document called tokens.ha where you can see the list of keywords found in the hare language.

### Context-Free Grammar


## Results

## Conclusion

## Sources
https://www.geeksforgeeks.org/introduction-of-lexical-analysis/
https://harelang.org/
