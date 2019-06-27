##### Note:
the info in the **You Don't Know JS** sections are shortened notes.  Those are very long and so I've taken what I feel are the best parts and included them in here.  Good for brushing up or preparing for interviews as well.

# You Don't Know JS: Up & Going
## Definitions
#### Statements
- *a group of words, numbers, and operators that performs a specific task*: `a = b * 2`
- a and b are called variables
- 2 is just a value itself, called a literal value, because it stands alone without being stored in a variable
- The = and * characters are operators

- Statements are made up of one or more expressions
- An expression is any reference to a variable or value, or a set of variable(s) and value(s) combined with operators: `a = b * 2;`
    - This statement has four expressions in it:
        - 2 is a literal value expression
        - b is a variable expression, which means to retrieve its current value
        - b * 2 is an arithmetic expression, which means to do the multiplication
        - a = b * 2 is an assignment expression, which means to assign the result of the b * 2 expression to the variable a (more on assignments later)
#### Expressions

#### Types
- JavaScript has built-in types for each of these so called primitive values:
    - When you need to do math, you want a number
    - When you need to print a value on the screen, you need a string (one or more characters, words, sentences)
    - When you need to make a decision in your program, you need a boolean (true or false)
#### Literals
- Values that are included directly in the source code
- string literals are surrounded by double quotes "..." or single quotes ('...') -- the only difference is stylistic preference
- number and boolean literals are just presented as is (i.e., 42, true, etc.)
#### Converting Between Types
- JavaScript calls converting types "coercion" (converting one type to another)
- there is "explicit" and "implicit" coercion
- **JS implicit coercion is controversial**:
    - a controversial topic is what happens when you try to compare two values that are not already of the same type, which would require implicit coercion
        - When comparing the string "99.99" to the number 99.99, most people would agree they are equivalent
            - But they're not exactly the same, are they? It's the same value in two different representations, two different types. You could say they're "loosely equal," couldn't you?
            - **To help you out in these common situations, JavaScript will sometimes kick in and implicitly coerce values to the matching types**
                - if you use the == loose equals operator to make the comparison "99.99" == 99.99, JavaScript will convert the left-hand side "99.99" to its number equivalent 99.99
                - The comparison then becomes 99.99 == 99.99, which is of course true
            - While designed to help you, implicit coercion can create confusion if you haven't taken the time to learn the rules that govern its behavior
            - Most JS developers never have, so the common feeling is that implicit coercion is confusing and harms programs with unexpected bugs, and should thus be avoided. It's even sometimes called a flaw in the design of the language
            - However, implicit coercion is a mechanism that can be learned, and moreover should be learned by anyone wishing to take JavaScript programming seriously
            - Not only is it not confusing once you learn the rules, it can actually make your programs better! The effort is well worth it
    - **explicit** examples:
        - Using Number(..) (a built-in function)
    - **implicit** examples:
- JavaScript provides several different facilities for forcibly coercing between types
    - Using Number(..) (a built-in function)

#### Typing and Variables
- **Static typing**, otherwise known as **type enforcement**, is typically cited as a benefit for program correctness by preventing unintended value conversions
- **Weak Typing** - Other languages emphasize types for values instead of variables
    - Weak typing, otherwise known as dynamic typing, allows a variable to hold any type of value at any time
    - It's typically cited as a benefit for program flexibility by allowing a single variable to represent a value no matter what type form that value may take at any given moment in the program's logic flow
- **JavaScript uses dynamic/weak typing**, meaning *variables can hold values of any type without any type enforcement*
#### Constants
- The newest version of JavaScript at the time of this writing (commonly called "ES6") includes a new way to declare constants, by using const instead of var: `const TAX_RATE = 0.08;`
- Constants are just like variables except constants also prevent accidentally changing value somewhere else after the initial setting
- If you tried to assign any different value to TAX_RATE after, your program would reject the change (and in strict mode, fail with an error -- see "Strict Mode" in Chapter 2)
####  Blocks
- in code we often need to group a series of statements together, which we often call a *block*
- In JavaScript, a block is defined by wrapping one or more statements inside a curly-brace pair { .. }

### Scope
(aka ***lexical scope***)
- In JS, each function gets its own scope
- Scope is a collection of variables and the rules for how those variables are accessed by name
- Only code inside that function can access that function's scoped variables
- A variable name has to be unique within the same scope
- a scope can be nested inside another scope
    - **If one scope is nested inside another, code inside the innermost scope can access variables from either scope**
        ```js
        function outer() {
            var a = 1;
        
            function inner() {
                var b = 2;
        
                // we can access both `a` and `b` here
                console.log( a + b );   // 3
            }
        
            inner();
        
            // we can only access `a` here
            console.log( a );   // 1
        }
        
        outer();
        ```
        - **Lexical scope** rules say that *code in one scope can access variables of either that scope or any scope outside of it*
            - code inside the inner() function has access to both variables a and b, but code in outer() has access only to a -- it cannot access b because that variable is only inside inner()
        ```js
        const TAX_RATE = 0.08;
        
        function calculateFinalPurchaseAmount(amt) {
            // calculate the new amount with the tax
            amt = amt + (amt * TAX_RATE);
        
            // return the new amount
            return amt;
        }
        ```
        - The TAX_RATE constant (variable) is accessible from inside the calculateFinalPurchaseAmount(..) function, even though we didn't pass it in, because of lexical scope

#### Loops
- while loop & do..while loop illustrate repeating a block of statements until a condition no longer evaluates to true:
    ```js
    while (numOfCustomers > 0) {
        console.log( "How may I help you?" );
    
            // help the customer...
    
            numOfCustomers = numOfCustomers - 1;
    }
    
    // versus:
    
    do {
        console.log( "How may I help you?" );
    
        // help the customer...
    
        numOfCustomers = numOfCustomers - 1;
    } while (numOfCustomers > 0);
    ```
    - The only difference between these loops is whether the conditional is tested before the first iteration (while) or after the first iteration (do..while)
    - In either form, if the conditional tests as false, the next iteration will not run
        - That means if the condition is initially false, a while loop will never run, but a do..while loop will run just the first time

# You Don't Know JS: Scope & Closures

# What is Scope?
- One of the most fundamental paradigms of nearly all programming languages is the ability to store values in variables, and later retrieve or modify those values
    - the ability to store values and pull values out of variables is what gives a program state
    - But where do those variables live? where are they stored? how does our program find them when it needs them?
    - there's a well-defined set of rules for storing variables in some location, and for finding those variables at a later time. **We'll call that set of rules: *Scope***
    - ***Where and how do these Scope rules get set***
- despite the fact that JavaScript falls under the general category of "dynamic" or "interpreted" languages, it is in fact a compiled language
    - It is not compiled well in advance, as are many traditionally-compiled languages, nor are the results of compilation portable among various distributed systems
    - The JavaScript engine performs many of the same steps, albeit in more sophisticated ways than we may commonly be aware, of any traditional language-compiler

- In traditional ***compiled-language process*** source code, your program will undergo three steps before it's executed, called "compilation":
1. **Tokenizing/Lexing**
    - breaking up a string of characters into meaningful (to the language) chunks, called tokens
    - For instance, consider the program: var a = 2;
    - This program would likely be broken up into the following tokens: var, a, =, 2, and ;
    - Whitespace may or may not be persisted as a token, depending on whether it's meaningful or not.

        **Note:** The difference between tokenizing and lexing is subtle and academic, but it centers on whether or not these tokens are identified in a stateless or stateful way. Put simply, if the tokenizer were to invoke stateful parsing rules to figure out whether a should be considered a distinct token or just part of another token, that would be lexing.
2. **Parsing**
    - taking a stream (array) of tokens and turning it into a tree of nested elements, which collectively represent the grammatical structure of the program
    - This tree is called an "AST" (Abstract Syntax Tree)
    - The tree for var a = 2; might start with a top-level node called VariableDeclaration, with a child node called Identifier (whose value is a), and another child called AssignmentExpression which itself has a child called NumericLiteral (whose value is 2).
3. **Code-Generation**
    - the process of taking an AST and turning it into executable code
    - This part varies greatly depending on the language, the platform it's targeting, etc.
    - there's a way to take our above described AST for var a = 2; and turn it into a set of machine instructions to actually create a variable called a (including reserving memory, etc.), and then store a value into a

- The **JavaScript engine** *is vastly more complex than just those three steps*, as are most other language compilers
    - in the process of parsing and code-generation, there are certainly steps to optimize the performance of the execution, including collapsing redundant elements, etc.
    - JavaScript engines don't get the luxury (like other language compilers) of having plenty of time to optimize, because JavaScript compilation doesn't happen in a build step ahead of time, as with other languages
    - the compilation that occurs happens, in many cases, mere microseconds (or less!) before the code is executed
    - To ensure the fastest performance, JS engines use all kinds of tricks (like JITs, which lazy compile and even hot re-compile, etc.) which are well beyond the "scope" of our discussion here
    - Let's just say, for simplicity's sake, that any snippet of JavaScript has to be compiled before (usually right before!) it's executed
        - So, the JS compiler will take the program var a = 2; and compile it first, and then be ready to execute it, usually right away
### Understanding Scope
this section is extensive so read about it [here](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20%26%20closures/ch1.md)
### Nested Scope
- Scope is a set of rules for looking up variables by their identifier name
    - There's usually more than one Scope to consider
- Scope is the set of rules that determines where and how a variable (identifier) can be looked-up
- Just as a block or function is nested inside another block or function, scopes are nested inside other scopes
    - So, if a variable cannot be found in the immediate scope, Engine consults the next outer containing scope, continuing until found or until the outermost (aka, global) scope has been reached
        ```js
        function foo(a) {
            console.log( a + b );
        }
        
        var b = 2;
        
        foo( 2 ); // 4
        ```
    - The RHS reference for b cannot be resolved inside the function foo, but it can be resolved in the Scope surrounding it (in this case, the global)
    - The **simple rules for traversing nested Scope**:
        - Engine starts at the currently executing Scope, looks for the variable there, then if not found, keeps going up one level, and so on
        - If the outermost global scope is reached, the search stops, whether it finds the variable or not

            *picture here*
        - You resolve LHS and RHS references by looking on your current scope, and if you don't find it, it goes up to look at the next scope, looking there, then the next, and so on. Once you get to the top scope (the global Scope), you either find what you're looking for, or you don't. But you have to stop regardless
### Lexical Scope
- we defined "scope" as the set of rules that govern how the Engine can look up a variable by its identifier name and find it, either in the current Scope, or in any of the Nested Scopes it's contained within
- There are two predominant models for how scope works:
    - **Lexical Scope** - is by far the most common, used by the vast majority of programming languages and is the scope JavaScript applies
    - **Dynamic Scope**
#### lexing
- scope that is defined at lexing time
    - is based on where variables and blocks of scope are authored, by you, at write time, and thus is (mostly) set in stone by the time the lexer processes your code
- the first traditional phase of a standard language compiler is called lexing (aka, tokenizing)
- the lexing process examines a string of source code characters and assigns semantic meaning to the tokens as a result of some stateful parsing
- It is this concept which provides the foundation to understand what lexical scope is and where the name comes from
- there are some ways to cheat lexical scope, thereby modifying it after the lexer has passed by, but these are frowned upon
    - It is considered best practice to treat lexical scope as, in fact, lexical-only, and thus entirely author-time in nature

**Example**
```js
function foo(a) {

    var b = a * 2;

    function bar(c) {
        console.log( a, b, c );
    }

    bar(b * 3);
}

foo( 2 ); // 2 4 12
```
- There are three nested scopes inherent in this code example
    *picture here*
    - Bubble 1 encompasses the global scope, and has just one identifier in it: foo
    - Bubble 2 encompasses the scope of foo, which includes the three identifiers: a, bar and b
    - Bubble 3 encompasses the scope of bar, and it includes just one identifier: c
- Scope bubbles are defined by where the blocks of scope are written, which one is nested inside the other, etc

#### Look-ups
- scope bubbles fully explains to the Engine all the places it needs to look to find an identifier
- In the above code snippet, the Engine executes the console.log(..) statement and goes looking for the three referenced variables a, b, and c
    - It first starts with the innermost scope bubble, the scope of the bar(..) function
    - It won't find a there, so it goes up one level, out to the next nearest scope bubble, the scope of foo(..)
    - It finds a there, and so it uses that a
    - Same thing for b. But c, it does find inside of bar(..)
    - Had there been a c both inside of bar(..) and inside of foo(..), the console.log(..) statement would have found and used the one in bar(..), never getting to the one in foo(..)
- **Scope look-up stops once it finds the first match**
    - The same identifier name can be specified at multiple layers of nested scope, which is called "shadowing" (the inner identifier "shadows" the outer identifier)
    - Regardless of shadowing, scope look-up always starts at the innermost scope being executed at the time, and works its way outward/upward until the first match, and stops

    ***Note:*** Global variables are also automatically properties of the global object (window in browsers, etc.), so it is possible to reference a global variable not directly by its lexical name, but instead indirectly as a property reference of the global object
- No matter where a function is invoked from, or even how it is invoked, its lexical scope is only defined by where the function was declared
- The lexical scope look-up process only applies to first-class identifiers, such as the a, b, and c
- If you had a reference to foo.bar.baz in a piece of code, the lexical scope look-up would apply to finding the foo identifier, but once it locates that variable, object property-access rules take over to resolve the bar and baz properties, respectively
#### Cheating Lexical
- If lexical scope is defined only by where a function is declared, which is entirely an author-time decision, how could there possibly be a way to "modify" (aka, cheat) lexical scope at run-time?
    - JavaScript has two such mechanisms
        - Both of them are equally frowned-upon in the wider community as bad practices to use in your code
        - But the typical arguments against them are often missing the most important point: **cheating lexical scope leads to poorer performance**
##### eval
- The eval(..) function in JavaScript takes a string as an argument, and treats the contents of the string as if it had actually been authored code at that point in the program
    - In other words, you can programmatically generate code inside of your authored code, and run the generated code as if it had been there at author time
- eval(..) allows you to modify the lexical scope environment by cheating and pretending that author-time (aka, lexical) code was there all along
- On subsequent lines of code after an eval(..) has executed, the Engine will not "know" or "care" that the previous code in question was dynamically interpreted and thus modified the lexical scope environment
    - The Engine will simply perform its lexical scope look-ups as it always does
        ```js
        function foo(str, a) {
            eval( str ); // cheating!
            console.log( a, b );
        }
        
        var b = 2;
        
        foo( "var b = 3;", 1 ); // 1 3
        ```
    - The string "var b = 3;" is treated, at the point of the eval(..) call, as code that was there all along
    - Because that code happens to declare a new variable b, it modifies the existing lexical scope of foo(..)
        - In fact, as mentioned above, this code actually creates variable b inside of foo(..) that shadows the b that was declared in the outer (global) scope
    - When the console.log(..) call occurs, it finds both a and b in the scope of foo(..), and never finds the outer b
    - Thus, we print out "1 3" instead of "1 2" as would have normally been the case
- By default, if a string of code that eval(..) executes contains one or more declarations (either variables or functions), this action modifies the existing lexical scope in which the eval(..) resides
    - eval(..) can be invoked "indirectly", through various tricks (beyond our discussion here), which causes it to instead execute in the context of the global scope, thus modifying it
    - But in either case, ***eval(..) can at runtime modify an author-time lexical scope***

    **Note:** eval(..) when used in a strict-mode program operates in its own lexical scope, which means declarations made inside of the eval() do not actually modify the enclosing scope.
    ```js
    function foo(str) {
       "use strict";
       eval( str );
       console.log( a ); // ReferenceError: a is not defined
    }
    
    foo( "var a = 2" );
    ```
    - There are other facilities in JavaScript which amount to a very similar effect to eval(..):
        - setTimeout(..)
        - setInterval(..)
        - both can take a string for their respective first argument, the contents of which are evaluated as the code of a dynamically-generated function. This is old, legacy behavior and long-since deprecated. Don't do it!
    - The new Function(..) function constructor similarly takes a string of code in its last argument to turn into a dynamically-generated function (the first argument(s), if any, are the named parameters for the new function)
        - This function-constructor syntax is slightly safer than eval(..), but it should still be avoided in your code
### Function vs. Block Scope
- scope consists of a series of "bubbles" that each act as a container or bucket, in which identifiers (variables, functions) are declared
    - These bubbles nest neatly inside each other, and this nesting is defined at author-time
#### Scope From Functions
- **what exactly makes a new bubble?** Is it only the function? Can other structures in JavaScript create bubbles of scope?
- The most common answer to those questions is that JavaScript has function-based scope
    - That is, **each function you declare creates a bubble for itself, but no other structures create their own scope bubbles **
        ```js
        function foo(a) {
            var b = 2;
        
            // some code
        
            function bar() {
                // ...
            }
        
            // more code
        
            var c = 3;
        }
        ```
- the scope bubble for foo(..) includes a, b, c and bar
- **It doesn't matter *where*** in the scope a declaration appears, the variable or function belongs to the containing scope bubble, regardless
- bar(..) has its own scope bubble. So does the global scope, which has just one identifier attached to it: foo
- Because a, b, c, and bar all belong to the scope bubble of foo(..), they are not accessible outside of foo(..)
- so the following code would all result in ReferenceError errors, as the identifiers are not available to the global scope:
    ```js
    bar(); // fails
    console.log( a, b, c ); // all 3 fail
    ```
- However, all these identifiers (a, b, c, foo, and bar) are accessible inside of foo(..), and indeed also available inside of bar(..) (assuming there are no shadow identifier declarations inside bar(..))
- Function scope encourages the idea that all variables belong to the function, and can be used and reused throughout the entirety of the function (and indeed, accessible even to nested scopes)
    - On the other hand, if you don't take careful precautions, variables existing across the entirety of a scope can lead to some unexpected pitfalls
#### Hiding In Plain Scope
- The traditional way of thinking about functions is that you declare a function, and then add code inside it. But the inverse thinking is equally powerful and useful: take any arbitrary section of code you've written, and wrap a function declaration around it, which in effect "hides" the code
- The practical result is to create a **scope bubble** around the code in question
    - means that any declarations (variable or function) in that code will now be tied to the scope of the new wrapping function, rather than the previously enclosing scope
    - so in other words, you can "hide" variables and functions by enclosing them in the scope of a function
- Why would "hiding" variables and functions be a useful technique?
    - There's a variety of reasons motivating this scope-based hiding
    - If all variables and functions were in the global scope, they would of course be accessible to any nested scope. But this would violate the "Least..." principle in that you are (likely) exposing many variables or functions which you should otherwise keep private, as proper use of the code would discourage access to those variables/functions:
        ```js
        function doSomething(a) {
            b = a + doSomethingElse( a * 2 );
        
            console.log( b * 3 );
        }
        
        function doSomethingElse(a) {
            return a - 1;
        }
        
        var b;
        
        doSomething( 2 ); // 15
        ```
        - the b variable and the doSomethingElse(..) function are "private" details of how doSomething(..) does its job
        - Giving the enclosing scope "access" to b and doSomethingElse(..) is not only unnecessary but also possibly "dangerous", in that they may be used in unexpected ways
        - A more "proper" design would hide these private details inside the scope of doSomething(..), such as:
        ```js
        function doSomething(a) {
            function doSomethingElse(a) {
                return a - 1;
            }
        
            var b;
        
            b = a + doSomethingElse( a * 2 );
        
            console.log( b * 3 );
        }
        
        doSomething( 2 ); // 15
        ```
        - Now, b and doSomethingElse(..) are not accessible to any outside influence, instead controlled only by doSomething(..)
        - The functionality and end-result has not been affected, but the design keeps private details private, which is usually considered better software
 #### Collision Avoidance
        - Another benefit of "hiding" variables and functions inside a scope is to avoid unintended collision between two different identifiers with the same name but different intended usages
        - Collision results often in unexpected overwriting of values:
        ```js
        function foo() {
            function bar(a) {
                i = 3; // changing the `i` in the enclosing scope's for-loop
                console.log( a + i );
            }
        
            for (var i=0; i<10; i++) {
                bar( i * 2 ); // oops, infinite loop ahead!
            }
        }
        
        foo();
        ```
        - The i = 3 assignment inside of bar(..) overwrites, unexpectedly, the i that was declared in foo(..) at the for-loop
        - In this case, it will result in an infinite loop, because i is set to a fixed value of 3 and that will forever remain < 10
        - The assignment inside bar(..) needs to declare a local variable to use, regardless of what identifier name is chosen
        - var i = 3; would fix the problem (and would create the previously mentioned "shadowed variable" declaration for i)
        - An additional, not alternate, option is to pick another identifier name entirely, such as var j = 3;
        - But your software design may naturally call for the same identifier name, so utilizing scope to "hide" your inner declaration is your best/only option in that case

  #### Global "Namespaces"
  - A particularly strong example of (likely) variable collision occurs in the global scope
  - Multiple libraries loaded into your program can quite easily collide with each other if they don't properly hide their internal/private functions and variables
  - Such libraries typically will create a single variable declaration, often an object, with a sufficiently unique name, in the global scope
  - This object is then used as a "namespace" for that library, where all specific exposures of functionality are made as properties of that object (namespace), rather than as top-level lexically scoped identifiers themselves
        ```js
        var MyReallyCoolLibrary = {
            awesome: "stuff",
            doSomething: function() {
                // ...
            },
            doAnotherThing: function() {
                // ...
            }
        };
        ```
#### Module Management
- Another option for collision avoidance is the more modern "module" approach, using any of various dependency managers
- Using these tools, no libraries ever add any identifiers to the global scope, but are instead required to have their identifier(s) be explicitly imported into another specific scope through usage of the dependency manager's various mechanisms
- It should be observed that these tools do not possess "magic" functionality that is exempt from lexical scoping rules
- They simply use the rules of scoping as explained here to enforce that no identifiers are injected into any shared scope, and are instead kept in private, non-collision-susceptible scopes, which prevents any accidental scope collisions
- As such, you can code defensively and achieve the same results as the dependency managers do without actually needing to use them, if you so choose. See the Chapter 5 for more information about the module pattern

## Functions As Scopes
- remember that we can take any snippet of code and wrap a function around it, and that effectively "hides" any enclosed variable or function declarations from the outside scope inside that function's inner scope:
    ```js
    var a = 2;
    
    function foo() { // <-- insert this
    
        var a = 3;
        console.log( a ); // 3
    
    } // <-- and this
    foo(); // <-- and this
    
    console.log( a ); // 2
    ```
    - **While this technique "works", it is not necessarily very ideal**
    - There are a few problems it introduces:
        - first we have to declare a named-function foo(), but now the identifier name foo itself "pollutes" the enclosing scope (global, in this case)
        - we also have to explicitly call the function by name (foo()) so that the wrapped code actually executes
        - It would be more ideal if the function didn't need a name (or, rather, the name didn't pollute the enclosing scope), and if the function could automatically be executed
        - JavaScript offers a solution to both problems:
            ```js
            var a = 2;
            
            (function foo(){ // <-- insert this
            
                var a = 3;
                console.log( a ); // 3
            
            })(); // <-- and this
            
            console.log( a ); // 2
            ```
            - First, notice that the wrapping function statement starts with (function... as opposed to just function.... While this may seem like a minor detail, it's actually a major change
            - Instead of treating the function as a standard declaration, the function is treated as a function-expression
            - The easiest way to distinguish declaration vs. expression is the position of the word "function" in the statement (not just a line, but a distinct statement). If "function" is the very first thing in the statement, then it's a function declaration. Otherwise, it's a function expression.
            - The key difference we can observe here between a function declaration and a function expression relates to where its name is bound as an identifier
            - Compare the previous two snippets. In the first snippet, the name foo is bound in the enclosing scope, and we call it directly with foo(). In the second snippet, the name foo is not bound in the enclosing scope, but instead is bound only inside of its own function
            - In other words, (function foo(){ .. }) as an expression means the identifier foo is found only in the scope where the .. indicates, not in the outer scope. Hiding the name foo inside itself means it does not pollute the enclosing scope unnecessarily
### Anonymous vs. Named
Anonymous functions are quick and easy to type, and many libraries and tools tend to encourage this idiomatic style of code. However, they have several draw-backs to consider:
1. Anonymous functions have no useful name to display in stack traces, which can make debugging more difficult.

2. Without a name, if the function needs to refer to itself, for recursion, etc., the deprecated arguments.callee reference is unfortunately required. Another example of needing to self-reference is when an event handler function wants to unbind itself after it fires.

3. Anonymous functions omit a name that is often helpful in providing more readable/understandable code. A descriptive name helps self-document the code in question

- Providing a name for your function expression quite effectively addresses all these draw-backs, but has no tangible downsides. The best practice is to always name your function expressions:
    ```js
    setTimeout( function timeoutHandler(){ // <-- Look, I have a name!
        console.log( "I waited 1 second!" );
    }, 1000 );
    ```
- IIFE's don't need names, necessarily -- the most common form of IIFE is to use an anonymous function expression. While certainly less common, naming an IIFE has all the aforementioned benefits over anonymous function expressions, so it's a good practice to adopt
    ```js
    var a = 2;
    
    (function IIFE(){
        var a = 3;
        console.log( a ); // 3
    
    })();
    
    console.log( a ); // 2
    ```
- There's a slight variation on the traditional IIFE form, which some prefer: (function(){ .. }()):
    - In the first form above, the function expression is wrapped in ( ), and then the invoking () pair is on the outside right after it
    - In the second form, the invoking () pair is moved to the inside of the outer ( ) wrapping pair
    - It's purely a stylistic choice which you prefer
- Another variation on IIFE's which is quite common is to use the fact that they are, in fact, just function calls, and pass in argument(s)
    ```js
    var a = 2;
    
    (function IIFE( global ){
        var a = 3;
        console.log( a ); // 3
        console.log( global.a ); // 2
    
    })( window );
    
    console.log( a ); // 2
    ```
    - We pass in the window object reference, but we name the parameter global, so that we have a clear stylistic delineation for global vs. non-global references
- Another application of this pattern addresses the (minor niche) concern that the default undefined identifier might have its value incorrectly overwritten, causing unexpected results
    - By naming a parameter undefined, but not passing any value for that argument, we can guarantee that the undefined identifier is in fact the undefined value in a block of code:
        ```js
        undefined = true; // setting a land-mine for other code! avoid!
        
        (function IIFE( undefined ){
        
            var a;
            if (a === undefined) {
                console.log( "Undefined is safe here!" );
            }
        
        })();
        ```
- another variation of the IIFE inverts the order of things, where the function to execute is given second, after the invocation and parameters to pass to it
    - This pattern is used in the UMD (Universal Module Definition) project. Some people find it a little cleaner to understand, though it is slightly more verbose:
        ```js
        var a = 2;
        
        (function IIFE( def ){
            def( window );
        })(function def( global ){
        
            var a = 3;
            console.log( a ); // 3
            console.log( global.a ); // 2
        
        });
        ```
        - The def function expression is defined in the second-half of the snippet, and then passed as a parameter (also called def) to the IIFE function defined in the first half of the snippet
        - Finally, the parameter def (the function) is invoked, passing window in as the global parameter
# You Don't Know JS: this & Object Prototypes
# You Don't Know JS: Types & Grammar
# immediately invoked function expression (IIFE)
- the fundamental unit of variable scoping in JavaScript has always been the function. If you needed to create a block of scope, the most prevalent way to do so other than a regular function declaration was the immediately invoked function expression (IIFE)
    ```js
    var a = 2;
    
    (function IIFE(){
        var a = 3;
        console.log( a )  // 3
    })();
    
    console.log( a );
    ```
- **However, we can now create declarations that are bound to any block, called (unsurprisingly) block scoping**
    - This means all we need is a pair of { .. } to create a scope. Instead of using var, which always declares variables attached to the enclosing function (or global, if top level) scope, use let:
        ```js
        var a = 2;
        
        {
            let a = 3;
            console.log( a ); // 3
        }
        
        console.log( a ); // 2
        ```
## Blocks As Scopes
- While functions are the most common, other units of scope are possible, and the usage of these other scope units can lead to even better, cleaner to maintain code

**Block Scope Example 1**
```js
for (var i=0; i<10; i++) {
    console.log( i );
}
```
- We declare the variable i directly inside the for-loop head, most likely because our intent is to use i only within the context of that for-loop, and essentially ignore the fact that the variable actually scopes itself to the enclosing scope (function or global)
- That's what block-scoping is all about. Declaring variables as close as possible, as local as possible, to where they will be used

**Block Scope Example 2**
```js
var foo = true;

if (foo) {
    var bar = foo * 2;
    bar = something( bar );
    console.log( bar );
}
```
- We are using a bar variable only in the context of the if-statement, so it makes a kind of sense that we would declare it inside the if-block
    - However, where we declare variables is not relevant when using var, because they will always belong to the enclosing scope
    - This snippet is essentially "fake" block-scoping, for stylistic reasons, and relying on self-enforcement not to accidentally use bar in another place in that scope
    - Block scope is a tool to extend information hiding via functions to hiding information further in blocks of our code

**Example 3**
```js
for (var i=0; i<10; i++) {
  console.log( i );
}
```
- Why pollute the entire scope of a function with the i variable that is only going to be (or only should be, at least) used for the for-loop?
- Block-scoping (if it were possible) for the i variable would make i available only for the for-loop, causing an error if i is accessed elsewhere in the function
- This helps ensure variables are not re-used in confusing or hard-to-maintain ways
### try/catch
- variable declaration in the catch clause of a try/catch to be block-scoped to the catch block
    ```js
    try {
        undefined(); // illegal operation to force an exception!
    }
    catch (err) {
        console.log( err ); // works!
    }
    
    console.log( err ); // ReferenceError: `err` not found
    ```
- err exists only in the catch clause, and throws an error when you try to reference it elsewhere

### let
- Thus far, we've seen that JavaScript only has some strange niche behaviors which expose block scope functionality. If that were all we had, and it was for many, many years, then block scoping would not be terribly useful to the JavaScript developer
- ES6 changes that, and introduces a new keyword let which sits alongside var as another way to declare variables
- let keyword attaches the variable declaration to the scope of whatever block (commonly a { .. } pair) it's contained in
    - In other words, let implicitly hijacks any block's scope for its variable declaration:
        ```js
        var foo = true;
        
        if (foo) {
            let bar = foo * 2;
            bar = something( bar );
            console.log( bar );
        }
        
        console.log( bar ); // ReferenceError
        ```
        - Using let to attach a variable to an existing block is somewhat implicit. It can confuse you if you're not paying close attention to which blocks have variables scoped to them, and are in the habit of moving blocks around, wrapping them in other blocks, etc., as you develop and evolve code
        - Creating explicit blocks for block-scoping can address some of these concerns, making it more obvious where variables are attached and not. Usually, explicit code is preferable over implicit or subtle code. This explicit block-scoping style is easy to achieve, and fits more naturally with how block-scoping works in other languages:
            ```js
            var foo = true;
            
            if (foo) {
                { // <-- explicit block
                    let bar = foo * 2;
                    bar = something( bar );
                    console.log( bar );
                }
            }
            
            console.log( bar ); // ReferenceError
            ```
            - We can create an arbitrary block for let to bind to by simply including a { .. } pair anywhere a statement is valid grammar
            - In this case, we've made an explicit block inside the if-statement, which may be easier as a whole block to move around later in refactoring, without affecting the position and semantics of the enclosing if-statement
- declarations made with let will not hoist to the entire scope of the block they appear in. Such declarations will not observably "exist" in the block until the declaration statement:
    ```js
    {
       console.log( bar ); // ReferenceError!
       let bar = 2;
    }
    ```
### Garbage Collection
- block-scoping is useful as it relates to closures and garbage collection to reclaim memory
    ```js
    function process(data) {
        // do something interesting
    }
    
    var someReallyBigData = { .. };
    
    process( someReallyBigData );
    
    var btn = document.getElementById( "my_button" );
    
    btn.addEventListener( "click", function click(evt){
        console.log("button clicked");
    }, /*capturingPhase=*/false );
    ```
- The click function click handler callback doesn't need the someReallyBigData variable at all
    - That means, theoretically, after process(..) runs, the big memory-heavy data structure could be garbage collected
    - However, it's quite likely (though implementation dependent) that the JS engine will still have to keep the structure around, since the click function has a closure over the entire scope
    - Block-scoping can address this concern, making it clearer to the engine that it does not need to keep someReallyBigData around:
        ```js
        function process(data) {
            // do something interesting
        }

        // anything declared inside this block can go away after!
        {
            let someReallyBigData = { .. };
        
            process( someReallyBigData );
        }
        
        var btn = document.getElementById( "my_button" );
        
        btn.addEventListener( "click", function click(evt){
        	console.log("button clicked");
        }, /*capturingPhase=*/false );
        ```
- Declaring explicit blocks for variables to locally bind to is a powerful tool that you can add to your code toolbox
#### let Loops
- A particular case where let shines is in the for-loop case
    ```js
    for (let i=0; i<10; i++) {
        console.log( i );
    }
    
    console.log( i ); // ReferenceError
    ```
- Not only does let in the for-loop header bind the i to the for-loop body, but in fact, it **re-binds** it to each iteration of the loop, making sure to re-assign it the value from the end of the previous loop iteration
- Here's another way of illustrating the per-iteration binding behavior that occurs:
    ```js
    {
        let j;
        for (j=0; j<10; j++) {
            let i = j; // re-bound for each iteration!
            console.log( i );
        }
    }
    ```
- let declarations attach to arbitrary blocks rather than to the enclosing function's scope (or global), there can be gotchas where existing code has a hidden reliance on function-scoped var declarations, and replacing the var with let may require additional care when refactoring code:
    ```js
    var foo = true, baz = 10;
    
    if (foo) {
        var bar = 3;
    
        if (baz > bar) {
            console.log( baz );
        }
    
        // ...
    }
    ```
- This code is fairly easily re-factored as:
    ```js
    var foo = true, baz = 10;
    
    if (foo) {
        var bar = 3;
    
        // ...
    }
    
    if (baz > bar) {
        console.log( baz );
    }
    ```
    - be careful of such changes when using block-scoped variables:
        ```js
        var foo = true, baz = 10;
        
        if (foo) {
            let bar = 3;
        
            if (baz > bar) { // <-- don't forget `bar` when moving!
                console.log( baz );
            }
        }
        ```
### const
- also creates a block-scoped variable, but whose value is fixed (constant)
    - Any attempt to change that value at a later time results in an error
        ```js
        var foo = true;
        
        if (foo) {
            var a = 2;
            const b = 3; // block-scoped to the containing `if`
        
            a = 3; // just fine!
            b = 4; // error!
        }
        
        console.log( a ); // 3
        console.log( b ); // ReferenceError!
        ```

# Hoisting
### Chicken Or The Egg?
- There's a temptation to think that all of the code you see in a JavaScript program is interpreted line-by-line, top-down in order, as the program executes
    - While that is substantially true, there's one part of that assumption which can lead to incorrect thinking about your program:
        ```js
        a = 2;
        var a;
        console.log( a );
        ```
        - Many developers would expect undefined to be printed, since the var a statement comes after the a = 2, and it would seem natural to assume that the variable is re-defined, and thus assigned the default undefined. However, the output will be 2
            ```js
            console.log( a );
            var a = 2;
            ```
        - You might be tempted to assume that, since the previous snippet exhibited some less-than-top-down looking behavior, perhaps in this snippet, 2 will also be printed
        - Others may think that since the a variable is used before it is declared, this must result in a ReferenceError being thrown
        - Unfortunately, both guesses are incorrect. undefined is the output
- It would appear we have a chicken-and-the-egg question. Which comes first, the declaration ("egg"), or the assignment ("chicken")?
    - To answer this question, we need to refer back to Chapter 1, and our discussion of compilers. Recall that the Engine actually will compile your JavaScript code before it interprets it
    - Part of the compilation phase was to find and associate all declarations with their appropriate scopes
    - **the best way to think about things is that all declarations, both variables and functions, are processed first, before any part of your code is executed**
    - When you see var a = 2;, you probably think of that as one statement. But JavaScript actually thinks of it as two statements: var a; and a = 2;
        - The first statement, the declaration, is processed during the compilation phase
        - The second statement, the assignment, is left in place for the execution phase
        - Our first snippet then should be thought of as being handled like this:
            ```js
            var a;
            ```
            ```js
            a = 2;
            console.log( a );
            ```
            - the first part is the compilation and the second part is the execution
        - our second snippet is actually processed as:
            ```js
            var a;
            ```
            ```js
            console.log( a );
            a = 2;
            ```
- one way of thinking, sort of metaphorically, about this process, is that **variable and function declarations are "moved" from where they appear in the flow of the code to the top of the code. This gives rise to the name "Hoisting"**
    - In other words, the egg (declaration) comes before the chicken (assignment)
- **Only the declarations themselves are hoisted, while any assignments or other executable logic are left *in place***
    - If hoisting were to re-arrange the executable logic of our code, that could wreak havoc
        ```js
        foo();
        
        function foo() {
            console.log( a ); // undefined
        
            var a = 2;
        }
        ```
    - function foo's declaration (which in this case includes the implied value of it as an actual function) is hoisted, such that the call on the first line is able to execute
- hoisting is per-scope
    - while our previous snippets were simplified in that they only included global scope, the foo(..) function we are now examining itself exhibits that var a is hoisted to the top of foo(..) (not, obviously, to the top of the program)
        - So the program can perhaps be more accurately interpreted like this:
            ```js
            function foo() {
                var a;
            
                console.log( a ); // undefined
            
                a = 2;
            }
            
            foo();
            ```
            - The variable identifier foo is hoisted and attached to the enclosing scope (global) of this program, so foo() doesn't fail as a ReferenceError
            - But foo has no value yet (as it would if it had been a true function declaration instead of expression)
            - So, foo() is attempting to invoke the undefined value, which is a TypeError illegal operation
- **Function *declarations* are hoisted, as we just saw. But function *expressions* are not**
    - even if it's a named function expression, the name identifier is not available in the enclosing scope:
        ```js
        foo(); // TypeError
        bar(); // ReferenceError
        
        var foo = function bar() {
            // ...
        };
        ```
    - This snippet is more accurately interpreted (with hoisting) as:
        ```js
        var foo;
        
        foo(); // TypeError
        bar(); // ReferenceError
        
        foo = function() {
            var bar = ...self...
            // ...
        }
        ```

### Functions First
- **Both function declarations and variable declarations are hoisted**
    - **functions are hoisted first**, and then variables
        ```js
        foo(); // 1
        
        var foo;
        
        function foo() {
            console.log( 1 );
        }
        
        foo = function() {
            console.log( 2 );
        };
        ```
- 1 is printed instead of 2! This snippet is interpreted by the Engine as:
    ```js
    function foo() {
        console.log( 1 );
    }
    
    foo(); // 1
    
    foo = function() {
        console.log( 2 );
    };
    ```
- Notice that var foo was the duplicate (and thus ignored) declaration, even though it came before the function foo()... declaration, because function declarations are hoisted before normal variables
- While multiple/duplicate var declarations are effectively ignored, subsequent function declarations do override previous ones
    ```js
    foo(); // 3
    
    function foo() {
        console.log( 1 );
    }
    
    var foo = function() {
        console.log( 2 );
    };
    
    function foo() {
        console.log( 3 );
    }
    ```
    - it highlights the fact that duplicate definitions in the same scope are a really bad idea and will often lead to confusing results
- **Function declarations that appear inside of normal blocks typically hoist to the enclosing scope, rather than being conditional**
    ```js
    foo(); // "b"
    
    var a = true;
    if (a) {
       function foo() { console.log( "a" ); }
    }
    else {
       function foo() { console.log( "b" ); }
    }
    ```
    - this behavior is not reliable and is subject to change in future versions of JavaScript, so it's probably best to avoid declaring functions in blocks

# Scope Closure
- For those who are somewhat experienced in JavaScript, but have perhaps never fully grasped the concept of closures, understanding closure can seem like a special nirvana that one must strive and sacrifice to attain
    *Closure* is when **a function is able to remember and access its lexical scope even when that function is executing outside its lexical scope**
    ```js
    function foo() {
        var a = 2;
    
        function bar() {
            console.log( a ); // 2
        }
    
        bar();
    }
    
    foo();
    ```
- Is this "closure"?
    - Well, technically... perhaps. But by our what-you-need-to-know definition above... not exactly. I think the most accurate way to explain bar() referencing a is via lexical scope look-up rules, and those rules are only (an important!) part of what closure is
    - the **function bar() has a *closure* over the *scope* of foo()** (and indeed, even over the rest of the scopes it has access to, such as the global scope in our case)
    - Put slightly differently, it's said that **bar() *closes over *the *scope of foo()*((. Why? Because bar() appears nested inside of foo(). Plain and simple
    - closure defined in this way is not directly observable, nor do we see closure exercised in that snippet. We clearly see lexical scope, but closure remains sort of a mysterious shifting shadow behind the code
    - Let us then consider code which brings closure into full light:
        ```js
        function foo() {
            var a = 2;
        
            function bar() {
                console.log( a );
            }
        
            return bar;
        }
        
        var baz = foo();
        
        baz(); // 2 -- Whoa, closure was just observed, man.
        ```
        - function **bar() has *lexical scope access* to the *inner scope of foo()***
        - But then, we take bar(), the function itself, and pass it as a value
        - we return the function object itself that bar references
        - After we execute foo(), we assign the value it returned (our inner bar() function) to a variable called baz
        - then we actually invoke baz(), which of course is invoking our inner function bar(), just by a different identifier reference
        - **bar() is executed**, for sure. But in this case, it's executed ***outside of its declared lexical scope***
        - After foo() executed, normally we would expect that the entirety of the inner scope of foo() would go away, because we know that the Engine employs a Garbage Collector that comes along and frees up memory once it's no longer in use
        - Since it would appear that the contents of foo() are no longer in use, it would seem natural that they should be considered gone
        - **But the "magic" of closures does not let this happen. That inner scope is in fact still "in use", and thus does not go away**
            - Who's using it? The function bar() itself
                - By virtue of where it was declared, bar() has a lexical scope closure over that inner scope of foo(), which keeps that scope alive for bar() to reference at any later time
                - **bar() still has a reference to that scope, and *that reference is called closure***
            - a few microseconds later, when the variable baz is invoked (invoking the inner function we initially labeled bar), it duly has access to author-time lexical scope, so it can access the variable a just as we'd expect
        - The **function is being invoked well *outside* of its *author-time lexical scope***
        - ***Closure lets the function continue to access the lexical scope it was defined in at author-time***
- any of the various ways that functions can be passed around as values, and indeed invoked in other locations, are all examples of observing/exercising closure
    ```js
    function foo() {
        var a = 2;
    
        function baz() {
            console.log( a ); // 2
        }
    
        bar( baz );
    }
    
    function bar(fn) {
    	fn(); // look ma, I saw closure!
    }
    ```
    - We pass the inner function baz over to bar, and call that inner function (labeled fn now), and when we do, its closure over the inner scope of foo() is observed, by accessing a
    - These passings-around of functions can be indirect, too
        ```js
        var fn;
        
        function foo() {
            var a = 2;
        
            function baz() {
                console.log( a );
            }
        
            fn = baz; // assign `baz` to global variable
        }
        
        function bar() {
            fn(); // look ma, I saw closure!
        }
        
        foo();
        
        bar(); // 2
        ```
        - **Whatever facility we use to *transport an inner function outside of its lexical scope*, it *will maintain a scope reference to where it was originally declared*, and *wherever we execute it, that closure will be exercised***
 ## Now I Can See
- The previous code snippets are somewhat academic and artificially constructed to illustrate using closure. But I promised you something more than just a cool new toy. I promised that closure was something all around you in your existing code. Let us now see that truth
    ```js
    function wait(message) {
    
        setTimeout( function timer(){
            console.log( message );
        }, 1000 );
    
    }
    
    wait( "Hello, closure!" );
    ```
- We take an inner function (named timer) and pass it to setTimeout(..)
- But timer has a scope closure over the scope of wait(..), indeed keeping and using a reference to the variable message
- A thousand milliseconds after we have executed wait(..), and its inner scope should otherwise be long gone, that inner function timer still has closure over that scope
- Deep down in the guts of the Engine, the built-in utility setTimeout(..) has reference to some parameter, probably called fn or func or something like that. Engine goes to invoke that function, which is invoking our inner timer function, and the lexical scope reference is still intact
- whenever and wherever you treat functions (which access their own respective lexical scopes) as first-class values and pass them around, you are likely to see those functions exercising closure
    - Be that timers, event handlers, Ajax requests, cross-window messaging, web workers, or any of the other asynchronous (or synchronous!) tasks, when you pass in a callback function, get ready to sling some closure around!
- While it is often said that IIFE (alone) is an example of observed closure, I would somewhat disagree
    ```js
    var a = 2;

    (function IIFE(){
        console.log( a );
    })();
    ```
    - This code "works", but it's not strictly an observation of closure
        - Because the function (which we named "IIFE" here) is not executed outside its lexical scope. It's still invoked right there in the same scope as it was declared (the enclosing/global scope that also holds a). a is found via normal lexical scope look-up, not really via closure
        - While closure might technically be happening at declaration time, it is not strictly observable, and so, as they say, it's a tree falling in the forest with no one around to hear it
        - an IIFE is not itself an example of closure, it absolutely creates scope, and it's one of the most common tools we use to create scope which can be closed over
        - So IIFEs are indeed heavily related to closure, even if not exercising closure themselves
 ### Loops + Closure
- The most common canonical example used to illustrate closure involves the humble for-loop.
    ```js
    for (var i=1; i<=5; i++) {
        setTimeout( function timer(){
            console.log( i );
        }, i*1000 );
    }
    ```
    - Linters often complain when you put functions inside of loops, because the mistakes of not understanding closure are so common among developers. We explain how to do so properly here, leveraging the full power of closure. But that subtlety is often lost on linters and they will complain regardless, assuming you don't actually know what you're doing
    - we would normally expect for the behavior to be that the numbers "1", "2", .. "5" would be printed out, one at a time, one per second, respectively
    - if you run this code, you get "6" printed out 5 times, at the one-second intervals
        - Weird right?
            - Firstly, let's explain where 6 comes from
            - The terminating condition of the loop is when i is not <=5
            - The first time that's the case is when i is 6. So, the output is reflecting the final value of the i after the loop terminates
                - This actually seems obvious on second glance
                    - The timeout function callbacks are all running well after the completion of the loop. In fact, as timers go, even if it was setTimeout(.., 0) on each iteration, all those function callbacks would still run strictly after the completion of the loop, and thus print 6 each time
                    - But there's a deeper question at play here. What's missing from our code to actually have it behave as we semantically have implied?
                    - What's missing is that we are trying to imply that each iteration of the loop "captures" its own copy of i, at the time of the iteration
                    - But, the way scope works, all 5 of those functions, though they are defined separately in each loop iteration, all **are closed over the same shared global scope**, which has, in fact, only one i in it
                        - Put that way, of course all functions share a reference to the same i
                        - Something about the loop structure tends to confuse us into thinking there's something else more sophisticated at work. There is not. There's no difference than if each of the 5 timeout callbacks were just declared one right after the other, with no loop at all
                    - What's missing? We need more cowbell closured scope. Specifically, we need a new closured scope for each iteration of the loop
                        - We learned in Chapter 3 that the IIFE creates scope by declaring a function and immediately executing it
                            ```js
                            for (var i=1; i<=5; i++) {
                                (function(){
                                    setTimeout( function timer(){
                                    console.log( i );
                                    }, i*1000 );
                                })();
                            }
                            ```
                            - Does that work? **Nope**. But why?
                                - We now obviously have more lexical scope
                                - Each timeout function callback is indeed closing over its own per-iteration scope created respectively by each IIFE
                                - **It's not enough to have a scope to close over if that scope is empty**
                                    - Look closely. Our IIFE is just an empty do-nothing scope. It needs *something* in it to be useful to us
                                    - It needs its own variable, with a copy of the i value at each iteration:
                                        ```js
                                        for (var i=1; i<=5; i++) {
                                            (function(){
                                                var j = i;
                                                setTimeout( function timer(){
                                                    console.log( j );
                                                }, j*1000 );
                                            })();
                                        }
                                        ```
                                        - Eureka! It works!
                                        - A slight variation some prefer is:
                                            ```js
                                            for (var i=1; i<=5; i++) {
                                                (function(j){
                                                    setTimeout( function timer(){
                                                        console.log( j );
                                                    }, j*1000 );
                                                })( i );
                                            }
                                            ```
                                            - since these IIFEs are just functions, we can pass in i, and we can call it j if we prefer, or we can even call it i again
                                            - The use of an IIFE inside each iteration created a new scope for each iteration, which gave our timeout function callbacks the opportunity to close over a new scope for each iteration, one which had a variable with the right per-iteration value in it for us to access
                                            - Problem solved!
### Block Scoping Revisited
- Look carefully at our analysis of the previous solution. We used an IIFE to create new scope per-iteration. In other words, we actually needed a per-iteration block scope. Chapter 3 showed us the let declaration, which hijacks a block and declares a variable right there in the block
- **It essentially turns a block into a scope that we can close over**. So, the following awesome code "just works":
    ```js
    for (var i=1; i<=5; i++) {
        let j = i; // yay, block-scope for closure!
        setTimeout( function timer(){
            console.log( j );
        }, j*1000 );
    }
    ```
- *But, that's not all*!
    - There's a special behavior defined for let declarations used in the head of a for-loop
    - This behavior says that the variable will be declared not just once for the loop, **but each iteration**
    - And, it will, helpfully, be initialized at each subsequent iteration with the value from the end of the previous iteration
        ```js
        for (let i=1; i<=5; i++) {
            setTimeout( function timer(){
                console.log( i );
            }, i*1000 );
        }
        ```
        - How cool is that? Block scoping and closure working hand-in-hand, solving all the world's problems
 ### Modules
        - other code patterns which leverage the power of closure but which do not on the surface appear to be about callbacks
            - Let's examine the most powerful of them:the the ***module***:
                ```js
                function foo() {
                    var something = "cool";
                    var another = [1, 2, 3];
                
                    function doSomething() {
                        console.log( something );
                    }
                
                    function doAnother() {
                        console.log( another.join( " ! " ) );
                    }
                }
                ```
                - there's no observable closure going on
                We simply have some private data variables something and another, and a couple of inner functions doSomething() and doAnother(), which both have lexical scope (and thus closure!) over the inner scope of foo()
                - now consider:
                    ```js
                    function CoolModule() {
                        var something = "cool";
                        var another = [1, 2, 3];
                    
                        function doSomething() {
                            console.log( something );
                        }
                    
                        function doAnother() {
                            console.log( another.join( " ! " ) );
                        }
                    
                        return {
                            doSomething: doSomething,
                            doAnother: doAnother
                        };
                    }
                    
                    var foo = CoolModule();
                    
                    foo.doSomething(); // cool
                    foo.doAnother(); // 1 ! 2 ! 3
                    ```
                    - This is the pattern in JavaScript we call ***module***
                    - CoolModule() is just a function, but it *has to be invoked* for there to be a module instance created
                        - Without the execution of the outer function, the creation of the inner scope and the closures would not occur
                    - Secondly, the CoolModule() function returns an object, denoted by the object-literal syntax { key: value, ... }
                        - The object we return has references on it to our inner functions, but not to our inner data variables
                        - We keep those hidden and private
                        - It's appropriate to think of this object return value as essentially a **public API for our module**
                            - This object return value is ultimately assigned to the outer variable foo, and then we can access those property methods on the API, like foo.doSomething()
                                - Note: It is not required that we return an actual object (literal) from our module. We could just return back an inner function directly. jQuery is actually a good example of this. The jQuery and $ identifiers are the public API for the jQuery "module", but they are, themselves, just a function (which can itself have properties, since all functions are objects)
                    - The doSomething() and doAnother() functions have closure over the inner scope of the module "instance" (arrived at by actually invoking CoolModule())
                        - When we transport those functions outside of the lexical scope, by way of property references on the object we return, we have now set up a condition by which closure can be observed and exercised
- To state it more simply, there are two "requirements" for the module pattern to be exercised:
1. There must be an outer enclosing function, and it must be invoked at least once (each time creates a new module instance).

2. The enclosing function must return back at least one inner function, so that this inner function has closure over the private scope, and can access and/or modify that private state
- An object with a function property on it alone is not really a module
    - An object which is returned from a function invocation which only has data properties on it and no closured functions is not really a module, in the observable sense
    - A slight variation on this pattern is when you only care to have one instance, a "singleton" of sorts
        ```js
        var foo = (function CoolModule() {
            var something = "cool";
            var another = [1, 2, 3];
        
            function doSomething() {
                console.log( something );
            }
        
            function doAnother() {
                console.log( another.join( " ! " ) );
            }
        
            return {
                doSomething: doSomething,
                doAnother: doAnother
            };
        })();
        
        foo.doSomething(); // cool
        foo.doAnother(); // 1 ! 2 ! 3
        ```
        - Here, we turned our module function into an IIFE (see Chapter 3), and we immediately invoked it and assigned its return value directly to our single module instance identifier foo
- Modules are just functions, so they can receive parameters:
    ```js
    function CoolModule(id) {
        function identify() {
            console.log( id );
        }
    
        return {
            identify: identify
        };
    }
    
    var foo1 = CoolModule( "foo 1" );
    var foo2 = CoolModule( "foo 2" );
    
    foo1.identify(); // "foo 1"
    foo2.identify(); // "foo 2"
    ```
- Another slight but powerful variation on the module pattern is to name the object you are returning as your public API:
    ```js
    var foo = (function CoolModule(id) {
        function change() {
            // modifying the public API
            publicAPI.identify = identify2;
        }
    
        function identify1() {
            console.log( id );
        }
    
        function identify2() {
            console.log( id.toUpperCase() );
        }
    
        var publicAPI = {
            change: change,
            identify: identify1
        };
    
        return publicAPI;
    })( "foo module" );
    
    foo.identify(); // foo module
    foo.change();
    foo.identify(); // FOO MODULE
    ```
    - By retaining an inner reference to the public API object inside your module instance, you can modify that module instance from the inside, including adding and removing methods, properties, and changing their values
### Modern Modules
- Various module dependency loaders/managers essentially wrap up this pattern of module definition into a friendly API
    ```js
    var MyModules = (function Manager() {
        var modules = {};
    
        function define(name, deps, impl) {
            for (var i=0; i<deps.length; i++) {
                deps[i] = modules[deps[i]];
            }
            modules[name] = impl.apply( impl, deps );
        }
    
        function get(name) {
            return modules[name];
        }
    
        return {
            define: define,
    	        get: get
        };
    })();
    ```
    - The key part of this code is modules[name] = impl.apply(impl, deps)
        - This is invoking the definition wrapper function for a module (passing in any dependencies), and storing the  return value, the module's API, into an internal list of modules tracked by name
    - here's how I might use it to define some modules:
        ```js
        MyModules.define( "bar", [], function(){
            function hello(who) {
                return "Let me introduce: " + who;
            }
        
            return {
                hello: hello
            };
        } );
        
        MyModules.define( "foo", ["bar"], function(bar){
            var hungry = "hippo";
        
            function awesome() {
                console.log( bar.hello( hungry ).toUpperCase() );
            }
        
            return {
                awesome: awesome
            };
        } );
        
        var bar = MyModules.get( "bar" );
        var foo = MyModules.get( "foo" );
        
        console.log(
            bar.hello( "hippo" )
        ); // Let me introduce: hippo
        
        foo.awesome(); // LET ME INTRODUCE: HIPPO
        ```
        - Both the "foo" and "bar" modules are defined with a function that returns a public API
        - "foo" even receives the instance of "bar" as a dependency parameter, and can use it accordingly

- Spend some time examining these code snippets to fully understand the power of closures put to use for our own good purposes. The key take-away is that there's not really any particular "magic" to module managers. They fulfill both characteristics of the module pattern I listed above: invoking a function definition wrapper, and keeping its return value as the API for that module
### Future Modules
- ES6 adds first-class syntax support for the concept of modules
    - Each module can both import other modules or specific API members, as well export their own public API members
    - Note: Function-based modules aren't a statically recognized pattern (something the compiler knows about), so their API semantics aren't considered until run-time. That is, you can actually modify a module's API during the run-time (see earlier publicAPI discussion)You theoretically could
- By contrast, ES6 Module APIs are static (the APIs don't change at run-time)
    - Since the compiler knows that, it can (and does!) check during (file loading and) compilation that a reference to a member of an imported module's API actually exists
    - If the API reference doesn't exist, the compiler throws an "early" error at compile-time, rather than waiting for traditional dynamic run-time resolution (and errors, if any)
# Into JavaScript
You should expect to spend quite a bit of time reviewing the concepts and code examples here multiple times. Any good foundation is laid brick by brick, so don't expect that you'll immediately understand it all the first pass through.

Your journey to deeply learn JavaScript starts here.

**Note:** As I said in Chapter 1, you should definitely try all this code yourself as you read and work through this chapter. Be aware that some of the code here assumes capabilities introduced in the newest version of JavaScript at the time of this writing (commonly referred to as "ES6" for the 6th edition of ECMAScript -- the official name of the JS specification). If you happen to be using an older, pre-ES6 browser, the code may not work. A recent update of a modern browser (like Chrome, Firefox, or IE) should be used.

## Values & Types

As we asserted in Chapter 1, JavaScript has typed values, not typed variables. The following built-in types are available:

* `string`
* `number`
* `boolean`
* `null` and `undefined`
* `object`
* `symbol` (new to ES6)

JavaScript provides a `typeof` operator that can examine a value and tell you what type it is:

```js
var a;
typeof a;  // "undefined"

a = "hello world";
typeof a;  // "string"

a = 42;
typeof a;  // "number"

a = true;
typeof a;  // "boolean"

a = null;
typeof a;  // "object" -- weird, bug

a = undefined;
typeof a;  // "undefined"

a = { b: "c" };
typeof a;  // "object"
```

The return value from the **`typeof` operator is always one of six** (seven as of ES6! - the "symbol" type) ***string* values**. That is, **`typeof "abc"` returns `"string"`, not `string`**.

Notice how in this snippet the `a` variable holds every different type of value, and that despite appearances, `typeof a` is not asking for the "type of `a`", but rather for the "type of the value currently in `a`."
- Only values have types in JavaScript; variables are just simple containers for those values

`typeof null` is an interesting case, because it errantly returns `"object"`, when you'd expect it to return `"null"`.

**Warning:** This is a long-standing bug in JS, but one that is likely never going to be fixed. Too much code on the Web relies on the bug and thus fixing it would cause a lot more bugs!

Also, note `a = undefined`. We're explicitly setting `a` to the `undefined` value, but that is behaviorally no different from a variable that has no value set yet, like with the `var a;` line at the top of the snippet
- A variable can get to this "undefined" value state in several different ways, including functions that return no values and usage of the `void` operator

### Objects

The `object` type refers to a compound value where you can set properties (named locations) that each hold their own values of any type. This is perhaps one of the most useful value types in all of JavaScript.

```js
var obj = {
    a: "hello world",
    b: 42,
    c: true
};

obj.a;  // "hello world"
obj.b;  // 42
obj.c;  // true

obj["a"];  // "hello world"
obj["b"];  // 42
obj["c"];  // true
```

It may be helpful to think of this `obj` value visually:

<img src="fig4.png">

Properties can either be accessed with *dot notation* (i.e., `obj.a`) or *bracket notation* (i.e., `obj["a"]`)
- Dot notation is shorter and generally easier to read, and is thus preferred when possible

Bracket notation is useful if you have a property name that has special characters in it, like `obj["hello world!"]` -- such properties are often referred to as *keys* when accessed via bracket notation
- The `[ ]` notation requires either a variable (explained next) or a `string` *literal* (which needs to be wrapped in `" .. "` or `' .. '`)

Of course, bracket notation is also useful if you want to access a property/key but the name is stored in another variable, such as:

```js
var obj = {
    a: "hello world",
    b: 42
};

var b = "a";

obj[b];   // "hello world"
obj["b"];  // 42
```

**Note:** For more information on JavaScript `object`s, see the *this & Object Prototypes* title of this series, specifically Chapter 3.

There are a couple of other value types that you will commonly interact with in JavaScript programs: *array* and *function*
- But rather than being proper built-in types, these should be thought of more like subtypes -- specialized versions of the `object` type

#### Arrays

An array is an `object` that holds values (of any type) not particularly in named properties/keys, but rather in numerically indexed positions. For example:

```js
var arr = [
    "hello world",
    42,
    true
];

arr[0];  // "hello world"
arr[1];  // 42
arr[2];  // true
arr.length;  // 3

typeof arr;  // "object"
```

**Note:** Languages that start counting at zero, like JS does, use `0` as the index of the first element in the array.

It may be helpful to think of `arr` visually:

<img src="fig5.png">

Because arrays are special objects (as `typeof` implies), they can also have properties, including the automatically updated `length` property.

You theoretically could use an array as a normal object with your own named properties, or you could use an `object` but only give it numeric properties (`0`, `1`, etc.) similar to an array
    - However, this would generally be considered improper usage of the respective types
    - The best and most natural approach is to use arrays for numerically positioned values and use `object`s for named properties

#### Functions

The other `object` subtype you'll use all over your JS programs is a function:

```js
function foo() {
    return 42;
}

foo.bar = "hello world";

typeof foo;  // "function"
typeof foo();  // "number"
typeof foo.bar;  // "string"
```

Again, functions are a subtype of `objects` -- `typeof` returns `"function"`, which implies that a `function` is a main type -- and can thus have properties, but you typically will only use function object properties (like `foo.bar`) in limited cases.

**Note:** For more information on JS values and their types, see the first two chapters of the *Types & Grammar* title of this series.

### Built-In Type Methods

The built-in types and subtypes we've just discussed have behaviors exposed as properties and methods that are quite powerful and useful.

For example:

```js
var a = "hello world";
var b = 3.14159;

a.length;  // 11
a.toUpperCase();  // "HELLO WORLD"
b.toFixed(4);  // "3.1416"
```

The "how" behind being able to call `a.toUpperCase()` is more complicated than just that method existing on the value.

Briefly, there is a `String` (capital `S`) object wrapper form, typically called a "native," that pairs with the primitive `string` type; it's this object wrapper that defines the `toUpperCase()` method on its prototype.

When you use a primitive value like `"hello world"` as an `object` by referencing a property or method (e.g., `a.toUpperCase()` in the previous snippet), JS automatically "boxes" the value to its object wrapper counterpart (hidden under the covers).

A `string` value can be wrapped by a `String` object, a `number` can be wrapped by a `Number` object, and a `boolean` can be wrapped by a `Boolean` object
- For the most part, you don't need to worry about or directly use these object wrapper forms of the values -- prefer the primitive value forms in practically all cases and JavaScript will take care of the rest for you

**Note:** For more information on JS natives and "boxing," see Chapter 3 of the *Types & Grammar* title of this series
- To better understand the prototype of an object, see Chapter 5 of the *this & Object Prototypes* title of this series.

### Comparing Values

There are two main types of value comparison that you will need to make in your JS programs: *equality* and *inequality*
- The result of any comparison is a strictly `boolean` value (`true` or `false`), regardless of what value types are compared

#### Coercion

We talked briefly about coercion in Chapter 1, but let's revisit it here.

Coercion comes in two forms in JavaScript: *explicit* and *implicit*. Explicit coercion is simply that you can see obviously from the code that a conversion from one type to another will occur, whereas implicit coercion is when the type conversion can happen as more of a non-obvious side effect of some other operation.

You've probably heard sentiments like "coercion is evil" drawn from the fact that there are clearly places where coercion can produce some surprising results
- Perhaps nothing evokes frustration from developers more than when the language surprises them

Coercion is not evil, nor does it have to be surprising
- In fact, the majority of cases you can construct with type coercion are quite sensible and understandable, and can even be used to *improve* the readability of your code
- But we won't go much further into that debate -- Chapter 4 of the *Types & Grammar* title of this series covers all sides.

Here's an example of *explicit* coercion:
```js
var a = "42";

var b = Number( a );

a;  // "42"
b;  // 42 -- the number!
```

And here's an example of *implicit* coercion:
```js
var a = "42";

var b = a * 1;	// "42" implicitly coerced to 42 here

a;  // "42"
b;  // 42 -- the number!
```

#### Truthy & Falsy

In Chapter 1, we briefly mentioned the "truthy" and "falsy" nature of values: when a non-`boolean` value is coerced to a `boolean`, does it become `true` or `false`, respectively?

The specific list of "falsy" values in JavaScript is as follows:

* `""` (empty string)
* `0`, `-0`, `NaN` (invalid `number`)
* `null`, `undefined`
* `false`

Any value that's not on this "falsy" list is "truthy." Here are some examples of those:

* `"hello"`
* `42`
* `true`
* `[ ]`, `[ 1, "2", 3 ]` (arrays)
* `{ }`, `{ a: 42 }` (objects)
* `function foo() { .. }` (functions)

It's important to remember that a non-`boolean` value only follows this "truthy"/"falsy" coercion if it's actually coerced to a `boolean
- It's not all that difficult to confuse yourself with a situation that seems like it's coercing a value to a `boolean` when it's not.

#### Equality

There are four equality operators: `==`, `===`, `!=`, and `!==`. The `!` forms are of course the symmetric "not equal" versions of their counterparts; *non-equality* should not be confused with *inequality*

The difference between `==` and `===` is usually characterized that `==` checks for value equality and `===` checks for both value and type equality. However, this is inaccurate
- The proper way to characterize them is that `==` checks for value equality with coercion allowed, and `===` checks for value equality without allowing coercion; `===` is often called "strict equality" for this reason

Consider the implicit coercion that's allowed by the `==` loose-equality comparison and not allowed with the `===` strict-equality:

```js
var a = "42";
var b = 42;

a == b;  // true
a === b;  // false
```

In the `a == b` comparison, JS notices that the types do not match, so it goes through an ordered series of steps to coerce one or both values to a different type until the types match, where then a simple value equality can be checked.

If you think about it, there's two possible ways `a == b` could give `true` via coercion
- Either the comparison could end up as `42 == 42` or it could be `"42" == "42"`. So which is it?

The answer: `"42"` becomes `42`, to make the comparison `42 == 42`
- In such a simple example, it doesn't really seem to matter which way that process goes, as the end result is the same
- There are more complex cases where it matters not just what the end result of the comparison is, but *how* you get there

The `a === b` produces `false`, because the coercion is not allowed, so the simple value comparison obviously fails
- Many developers feel that `===` is more predictable, so they advocate always using that form and staying away from `==`. I think this view is very shortsighted
- I believe `==` is a powerful tool that helps your program, *if you take the time to learn how it works*

We're not going to cover all the nitty-gritty details of how the coercion in `==` comparisons works here
- Much of it is pretty sensible, but there are some important corner cases to be careful of
- You can read section 11.9.3 of the ES5 specification (http://www.ecma-international.org/ecma-262/5.1/) to see the exact rules, and you'll be surprised at just how straightforward this mechanism is, compared to all the negative hype surrounding it

To boil down a whole lot of details to a few simple takeaways, and help you know whether to use `==` or `===` in various situations, here are my simple rules:

* If either value (aka side) in a comparison could be the `true` or `false` value, avoid `==` and use `===`
* If either value in a comparison could be of these specific values (`0`, `""`, or `[]` -- empty array), avoid `==` and use `===`
* In *all* other cases, you're safe to use `==`. Not only is it safe, but in many cases it simplifies your code in a way that improves readability

What these rules boil down to is requiring you to think critically about your code and about what kinds of values can come through variables that get compared for equality
- If you can be certain about the values, and `==` is safe, use it! If you can't be certain about the values, use `===`. It's that simple

The `!=` non-equality form pairs with `==`, and the `!==` form pairs with `===`
- All the rules and observations we just discussed hold symmetrically for these non-equality comparisons.

You should take special note of the `==` and `===` comparison rules if you're comparing two non-primitive values, like `object`s (including `function` and `array`)
- Because those values are actually held by reference, both `==` and `===` comparisons will simply check whether the references match, not anything about the underlying values

For example, `array`s are by default coerced to `string`s by simply joining all the values with commas (`,`) in between
- You might think that two `array`s with the same contents would be `==` equal, but they're not:
    ```js
    var a = [1,2,3];
    var b = [1,2,3];
    var c = "1,2,3";
    
    a == c;  // true
    b == c;  // true
    a == b;  // false
    ```

**Note:** For more information about the `==` equality comparison rules, see the ES5 specification (section 11.9.3) and also consult Chapter 4 of the *Types & Grammar* title of this series; see Chapter 2 for more information about values versus references.

#### Inequality

The `<`, `>`, `<=`, and `>=` operators are used for inequality, referred to in the specification as "relational comparison." Typically they will be used with ordinally comparable values like `number`s
- It's easy to understand that `3 < 4`

But JavaScript `string` values can also be compared for inequality, using typical alphabetic rules (`"bar" < "foo"`).

What about coercion? Similar rules as `==` comparison (though not exactly identical!) apply to the inequality operators
- Notably, there are no "strict inequality" operators that would disallow coercion the same way `===` "strict equality" does

Consider:

```js
var a = 41;
var b = "42";
var c = "43";

a < b;  // true
b < c;  // true
```

What happens here? In section 11.8.5 of the ES5 specification, it says that if both values in the `<` comparison are `string`s, as it is with `b < c`, the comparison is made lexicographically (aka alphabetically like a dictionary)
- But if one or both is not a `string`, as it is with `a < b`, then both values are coerced to be `number`s, and a typical numeric comparison occurs

The biggest gotcha you may run into here with comparisons between potentially different value types -- remember, there are no "strict inequality" forms to use -- is when one of the values cannot be made into a valid number, such as:

```js
var a = 42;
var b = "foo";

a < b;  // false
a > b;  // false
a == b;  // false
```

Wait, how can all three of those comparisons be `false`? Because the `b` value is being coerced to the "invalid number value" `NaN` in the `<` and `>` comparisons, and the specification says that `NaN` is neither greater-than nor less-than any other value.

The `==` comparison fails for a different reason. `a == b` could fail if it's interpreted either as `42 == NaN` or `"42" == "foo"` -- as we explained earlier, the former is the case.

**Note:** For more information about the inequality comparison rules, see section 11.8.5 of the ES5 specification and also consult Chapter 4 of the *Types & Grammar* title of this series.

## Variables
In JavaScript, variable names (including function names) must be valid *identifiers*
- The strict and complete rules for valid characters in identifiers are a little complex when you consider nontraditional characters such as Unicode
- If you only consider typical ASCII alphanumeric characters, though, the rules are simple

An identifier must start with `a`-`z`, `A`-`Z`, `$`, or `_`. It can then contain any of those characters plus the numerals `0`-`9`.

Generally, the same rules apply to a property name as to a variable identifier
- However, certain words cannot be used as variables, but are OK as property names
- These words are called "reserved words," and include the JS keywords (`for`, `in`, `if`, etc.) as well as `null`, `true`, and `false`

**Note:** For more information about reserved words, see Appendix A of the *Types & Grammar* title of this series.

### Function Scopes

You use the `var` keyword to declare a variable that will belong to the current function scope, or the global scope if at the top level outside of any function.

#### Hoisting

Wherever a `var` appears inside a scope, that declaration is taken to belong to the entire scope and accessible everywhere throughout.

Metaphorically, this behavior is called *hoisting*, when a `var` declaration is conceptually "moved" to the top of its enclosing scope
- Technically, this process is more accurately explained by how code is compiled, but we can skip over those details for now

Consider:

```js
var a = 2;

foo();  // works because `foo()`
           // declaration is "hoisted"

function foo() {
    a = 3;

    console.log( a );  // 3

    var a;  // declaration is "hoisted"
               // to the top of `foo()`
}

console.log( a ); // 2
```

**Warning:** It's not common or a good idea to rely on variable *hoisting* to use a variable earlier in its scope than its `var` declaration appears; it can be quite confusing
- It's much more common and accepted to use *hoisted* function declarations, as we do with the `foo()` call appearing before its formal declaration

#### Nested Scopes

When you declare a variable, it is available anywhere in that scope, as well as any lower/inner scopes. For example:

```js
function foo() {
    var a = 1;

    function bar() {
        var b = 2;

        function baz() {
            var c = 3;

            console.log( a, b, c ); // 1 2 3
        }

        baz();
        console.log( a, b );  // 1 2
    }

    bar();
    console.log( a );  // 1
}

foo();
```

Notice that `c` is not available inside of `bar()`, because it's declared only inside the inner `baz()` scope, and that `b` is not available to `foo()` for the same reason.

If you try to access a variable's value in a scope where it's not available, you'll get a `ReferenceError` thrown
- If you try to set a variable that hasn't been declared, you'll either end up creating a variable in the top-level global scope (bad!) or getting an error, depending on "strict mode" (see "Strict Mode"). Let's take a look:
    ```js
    function foo() {
        a = 1;  // `a` not formally declared
    }
    
    foo();
    a;  // 1 -- oops, auto global variable :(
    ```

This is a very bad practice. Don't do it! Always formally declare your variables.

In addition to creating declarations for variables at the function level, ES6 *lets* you declare variables to belong to individual blocks (pairs of `{ .. }`), using the `let` keyword. Besides some nuanced details, the scoping rules will behave roughly the same as we just saw with functions:

```js
function foo() {
    var a = 1;

    if (a >= 1) {
        let b = 2;

        while (b < 5) {
            let c = b * 2;
            b++;

            console.log( a + c );
        }
    }
}

foo();  // 5 7 9
```

Because of using `let` instead of `var`, `b` will belong only to the `if` statement and thus not to the whole `foo()` function's scope. Similarly, `c` belongs only to the `while` loop
- Block scoping is very useful for managing your variable scopes in a more fine-grained fashion, which can make your code much easier to maintain over time

**Note:** For more information about scope, see the *Scope & Closures* title of this series
- See the *ES6 & Beyond* title of this series for more information about `let` block scoping

## Conditionals
In addition to the `if` statement we introduced briefly in Chapter 1, JavaScript provides a few other conditionals mechanisms that we should take a look at.

Sometimes you may find yourself writing a series of `if..else..if` statements like this:

```js
if (a == 2) {
  // do something
}
else if (a == 10) {
  // do another thing
}
else if (a == 42) {
  // do yet another thing
}
else {
  // fallback to here
}
```

This structure works, but it's a little verbose because you need to specify the `a` test for each case. Here's another option, the `switch` statement:

```js
switch (a) {
    case 2:
        // do something
        break;
    case 10:
        // do another thing
        break;
    case 42:
        // do yet another thing
        break;
    default:
        // fallback to here
}
```

The `break` is important if you want only the statement(s) in one `case` to run
- If you omit `break` from a `case`, and that `case` matches or runs, execution will continue with the next `case`'s statements regardless of that `case` matching. This so called "fall through" is sometimes useful/desired:
    ```js
    switch (a) {
        case 2:
        case 10:
            // some cool stuff
            break;
        case 42:
            // other stuff
            break;
        default:
            // fallback
    }
    ```

Here, if `a` is either `2` or `10`, it will execute the "some cool stuff" code statements.

Another form of conditional in JavaScript is the "conditional operator," often called the "ternary operator."
- It's like a more concise form of a single `if..else` statement, such as:
    ```js
    var a = 42;
    
    var b = (a > 41) ? "hello" : "world";
    
    // similar to:
    
    // if (a > 41) {
    //    b = "hello";
    // }
    // else {
    //    b = "world";
    // }
    ```

If the test expression (`a > 41` here) evaluates as `true`, the first clause (`"hello"`) results, otherwise the second clause (`"world"`) results, and whatever the result is then gets assigned to `b`.

The conditional operator doesn't have to be used in an assignment, but that's definitely the most common usage.

**Note:** For more information about testing conditions and other patterns for `switch` and `? :`, see the *Types & Grammar* title of this series.

## Strict Mode

ES5 added a "strict mode" to the language, which tightens the rules for certain behaviors
- Generally, these restrictions are seen as keeping the code to a safer and more appropriate set of guidelines
- Also, adhering to strict mode makes your code generally more optimizable by the engine
- Strict mode is a big win for code, and you should use it for all your programs

You can opt in to strict mode for an individual function, or an entire file, depending on where you put the strict mode pragma:

```js
function foo() {
    "use strict";

    // this code is strict mode

    function bar() {
        // this code is strict mode
    }
}

// this code is not strict mode
```

Compare that to:

```js
"use strict";

function foo() {
    // this code is strict mode

    function bar() {
        // this code is strict mode
    }
}

// this code is strict mode
```

One key difference (improvement!) with strict mode is disallowing the implicit auto-global variable declaration from omitting the `var`:

```js
function foo() {
    "use strict";  // turn on strict mode
    a = 1;  // `var` missing, ReferenceError
}

foo();
```

If you turn on strict mode in your code, and you get errors, or code starts behaving buggy, your temptation might be to avoid strict mode
- But that instinct would be a bad idea to indulge
- If strict mode causes issues in your program, almost certainly it's a sign that you have things in your program you should fix

Not only will strict mode keep your code to a safer path, and not only will it make your code more optimizable, but it also represents the future direction of the language
- It'd be easier on you to get used to strict mode now than to keep putting it off -- it'll only get harder to convert later!

**Note:** For more information about strict mode, see the Chapter 5 of the *Types & Grammar* title of this series.

## Functions As Values

So far, we've discussed functions as the primary mechanism of *scope* in JavaScript
- You recall typical `function` declaration syntax as follows:
    ```js
    function foo() {
        // ..
    }
    ```

Though it may not seem obvious from that syntax, `foo` is basically just a variable in the outer enclosing scope that's given a reference to the `function` being declared
    - That is, the `function` itself is a value, just like `42` or `[1,2,3]` would be

This may sound like a strange concept at first, so take a moment to ponder it
    - Not only can you pass a value (argument) *to* a function, but *a function itself can be a value* that's assigned to variables, or passed to or returned from other functions

As such, a function value should be thought of as an expression, much like any other value or expression.

Consider:

```js
var foo = function() {
    // ..
};

var x = function bar(){
    // ..
};
```

The first function expression assigned to the `foo` variable is called *anonymous* because it has no `name`.

The second function expression is *named* (`bar`), even as a reference to it is also assigned to the `x` variable
- *Named function expressions* are generally more preferable, though *anonymous function expressions* are still extremely common

For more information, see the *Scope & Closures* title of this series.

### Immediately Invoked Function Expressions (IIFEs)

In the previous snippet, neither of the function expressions are executed -- we could if we had included `foo()` or `x()`, for instance.

There's another way to execute a function expression, which is typically referred to as an *immediately invoked function expression* (IIFE):

```js
(function IIFE(){
    console.log( "Hello!" );
})();
// "Hello!"
```

The outer `( .. )` that surrounds the `(function IIFE(){ .. })` function expression is just a nuance of JS grammar needed to prevent it from being treated as a normal function declaration.

The final `()` on the end of the expression -- the `})();` line -- is what actually executes the function expression referenced immediately before it.

That may seem strange, but it's not as foreign as first glance. Consider the similarities between `foo` and `IIFE` here:

```js
function foo() { .. }

// `foo` function reference expression,
// then `()` executes it
foo();

// `IIFE` function expression,
// then `()` executes it
(function IIFE(){ .. })();
```

As you can see, listing the `(function IIFE(){ .. })` before its executing `()` is essentially the same as including `foo` before its executing `()`; in both cases, the function reference is executed with `()` immediately after it.

Because an IIFE is just a function, and functions create variable *scope*, using an IIFE in this fashion is often used to declare variables that won't affect the surrounding code outside the IIFE:

```js
var a = 42;

(function IIFE(){
    var a = 10;
    console.log( a ); // 10
})();

console.log( a ); // 42
```

IIFEs can also have return values:

```js
var x = (function IIFE(){
    return 42;
})();

x;  // 42
```

The `42` value gets `return`ed from the `IIFE`-named function being executed, and is then assigned to `x`.

### Closure
*Closure* is one of the most important, and often least understood, concepts in JavaScript
- I won't cover it in deep detail here, and instead refer you to the *Scope & Closures* title of this series
- But I want to say a few things about it so you understand the general concept
- It will be one of the most important techniques in your JS skillset

You can think of closure as a way to "remember" and continue to access a function's scope (its variables) even once the function has finished running.

Consider:

```js
function makeAdder(x) {
    // parameter `x` is an inner variable

    // inner function `add()` uses `x`, so
    // it has a "closure" over it
    function add(y) {
      return y + x;
    };

    return add;
}
```

The reference to the inner `add(..)` function that gets returned with each call to the outer `makeAdder(..)` is able to remember whatever `x` value was passed in to `makeAdder(..)`. Now, let's use `makeAdder(..)`:

```js
// `plusOne` gets a reference to the inner `add(..)`
// function with closure over the `x` parameter of
// the outer `makeAdder(..)`
var plusOne = makeAdder( 1 );

// `plusTen` gets a reference to the inner `add(..)`
// function with closure over the `x` parameter of
// the outer `makeAdder(..)`
var plusTen = makeAdder( 10 );

plusOne( 3 ); // 4  <-- 1 + 3
plusOne( 41 );  // 42 <-- 1 + 41

plusTen( 13 );  // 23 <-- 10 + 13
```

More on how this code works:

1. When we call `makeAdder(1)`, we get back a reference to its inner `add(..)` that remembers `x` as `1`. We call this function reference `plusOne(..)`.
2. When we call `makeAdder(10)`, we get back another reference to its inner `add(..)` that remembers `x` as `10`. We call this function reference `plusTen(..)`.
3. When we call `plusOne(3)`, it adds `3` (its inner `y`) to the `1` (remembered by `x`), and we get `4` as the result.
4. When we call `plusTen(13)`, it adds `13` (its inner `y`) to the `10` (remembered by `x`), and we get `23` as the result.

Don't worry if this seems strange and confusing at first -- it can be! It'll take lots of practice to understand it fully.

But trust me, once you do, it's one of the most powerful and useful techniques in all of programming
- It's definitely worth the effort to let your brain simmer on closures for a bit. In the next section, we'll get a little more practice with closure

#### Modules

The most common usage of closure in JavaScript is the module pattern
- Modules let you define private implementation details (variables, functions) that are hidden from the outside world, as well as a public API that *is* accessible from the outside

Consider:

```js
function User(){
    var username, password;

    function doLogin(user,pw) {
        username = user;
        password = pw;

        // do the rest of the login work
    }

    var publicAPI = {
        login: doLogin
    };

    return publicAPI;
}

// create a `User` module instance
var fred = User();

fred.login( "fred", "12Battery34!" );
```

The `User()` function serves as an outer scope that holds the variables `username` and `password`, as well as the inner `doLogin()` function; these are all private inner details of this `User` module that cannot be accessed from the outside world.

**Warning:** We are not calling `new User()` here, on purpose, despite the fact that probably seems more common to most readers
- `User()` is just a function, not a class to be instantiated, so it's just called normally. Using `new` would be inappropriate and actually waste resources

Executing `User()` creates an *instance* of the `User` module -- a whole new scope is created, and thus a whole new copy of each of these inner variables/functions
    - We assign this instance to `fred`. If we run `User()` again, we'd get a new instance entirely separate from `fred`

The inner `doLogin()` function has a closure over `username` and `password`, meaning it will retain its access to them even after the `User()` function finishes running.

`publicAPI` is an object with one property/method on it, `login`, which is a reference to the inner `doLogin()` function. When we return `publicAPI` from `User()`, it becomes the instance we call `fred`

At this point, the outer `User()` function has finished executing
- Normally, you'd think the inner variables like `username` and `password` have gone away. But here they have not, because there's a closure in the `login()` function keeping them alive

That's why we can call `fred.login(..)` -- the same as calling the inner `doLogin(..)` -- and it can still access `username` and `password` inner variables.

There's a good chance that with just this brief glimpse at closure and the module pattern, some of it is still a bit confusing
- That's OK! It takes some work to wrap your brain around it

From here, go read the *Scope & Closures* title of this series for a much more in-depth exploration.

## `this` Identifier

Another very commonly misunderstood concept in JavaScript is the `this` identifier
- Again, there's a couple of chapters on it in the *this & Object Prototypes* title of this series, so here we'll just briefly introduce the concept

While it may often seem that `this` is related to "object-oriented patterns," in JS `this` is a different mechanism.

If a function has a `this` reference inside it, that `this` reference usually points to an `object`
- But which `object` it points to depends on how the function was called

It's important to realize that `this` *does not* refer to the function itself, as is the most common misconception.

Here's a quick illustration:

```js
function foo() {
    console.log( this.bar );
}

var bar = "global";

var obj1 = {
    bar: "obj1",
    foo: foo
};

var obj2 = {
    bar: "obj2"
};

// --------

foo();  // "global"
obj1.foo();  // "obj1"
foo.call( obj2 );  // "obj2"
new foo();  // undefined
```

There are four rules for how `this` gets set, and they're shown in those last four lines of that snippet.

1. `foo()` ends up setting `this` to the global object in non-strict mode -- in strict mode, `this` would be `undefined` and you'd get an error in accessing the `bar` property -- so `"global"` is the value found for `this.bar`.
2. `obj1.foo()` sets `this` to the `obj1` object.
3. `foo.call(obj2)` sets `this` to the `obj2` object.
4. `new foo()` sets `this` to a brand new empty object.

Bottom line: to understand what `this` points to, you have to examine how the function in question was called
- It will be one of those four ways just shown, and that will then answer what `this` is

**Note:** For more information about `this`, see Chapters 1 and 2 of the *this & Object Prototypes* title of this series.

## Prototypes

The prototype mechanism in JavaScript is quite complicated. We will only glance at it here
- You will want to spend plenty of time reviewing Chapters 4-6 of the *this & Object Prototypes* title of this series for all the details

When you reference a property on an object, if that property doesn't exist, JavaScript will automatically use that object's internal prototype reference to find another object to look for the property on
    - You could think of this almost as a fallback if the property is missing

The internal prototype reference linkage from one object to its fallback happens at the time the object is created
    - The simplest way to illustrate it is with a built-in utility called `Object.create(..)`

Consider:

```js
var foo = {
    a: 42
};

// create `bar` and link it to `foo`
var bar = Object.create( foo );

bar.b = "hello world";

bar.b;  // "hello world"
bar.a;  // 42 <-- delegated to `foo`
```

It may help to visualize the `foo` and `bar` objects and their relationship:

<img src="fig6.png">

The `a` property doesn't actually exist on the `bar` object, but because `bar` is prototype-linked to `foo`, JavaScript automatically falls back to looking for `a` on the `foo` object, where it's found.

This linkage may seem like a strange feature of the language
- The most common way this feature is used -- and I would argue, abused -- is to try to emulate/fake a "class" mechanism with "inheritance"

But a more natural way of applying prototypes is a pattern called "behavior delegation," where you intentionally design your linked objects to be able to *delegate* from one to the other for parts of the needed behavior.

**Note:** For more information about prototypes and behavior delegation, see Chapters 4-6 of the *this & Object Prototypes* title of this series.

## Old & New

Some of the JS features we've already covered, and certainly many of the features covered in the rest of this series, are newer additions and will not necessarily be available in older browsers
- In fact, some of the newest features in the specification aren't even implemented in any stable browsers yet

So, what do you do with the new stuff? Do you just have to wait around for years or decades for all the old browsers to fade into obscurity?

That's how many people think about the situation, but it's really not a healthy approach to JS.

There are two main techniques you can use to "bring" the newer JavaScript stuff to the older browsers: polyfilling and transpiling.

### Polyfilling

The word "polyfill" is an invented term (by Remy Sharp) (https://remysharp.com/2010/10/08/what-is-a-polyfill) used to refer to taking the definition of a newer feature and producing a piece of code that's equivalent to the behavior, but is able to run in older JS environments.

For example, ES6 defines a utility called `Number.isNaN(..)` to provide an accurate non-buggy check for `NaN` values, deprecating the original `isNaN(..)` utility
- But it's easy to polyfill that utility so that you can start using it in your code regardless of whether the end user is in an ES6 browser or not

Consider:

```js
if (!Number.isNaN) {
    Number.isNaN = function isNaN(x) {
        return x !== x;
    };
}
```

The `if` statement guards against applying the polyfill definition in ES6 browsers where it will already exist. If it's not already present, we define `Number.isNaN(..)`.

**Note:** The check we do here takes advantage of a quirk with `NaN` values, which is that they're the only value in the whole language that is not equal to itself
- So the `NaN` value is the only one that would make `x !== x` be `true`

Not all new features are fully polyfillable. Sometimes most of the behavior can be polyfilled, but there are still small deviations
- You should be really, really careful in implementing a polyfill yourself, to make sure you are adhering to the specification as strictly as possible

Or better yet, use an already vetted set of polyfills that you can trust, such as those provided by ES5-Shim (https://github.com/es-shims/es5-shim) and ES6-Shim (https://github.com/es-shims/es6-shim).

### Transpiling

There's no way to polyfill new syntax that has been added to the language
- The new syntax would throw an error in the old JS engine as unrecognized/invalid

So the better option is to use a tool that converts your newer code into older code equivalents
- This process is commonly called "transpiling," a term for transforming + compiling

Essentially, your source code is authored in the new syntax form, but what you deploy to the browser is the transpiled code in old syntax form
- You typically insert the transpiler into your build process, similar to your code linter or your minifier

You might wonder why you'd go to the trouble to write new syntax only to have it transpiled away to older code -- why not just write the older code directly?

There are several important reasons you should care about transpiling:

* The new syntax added to the language is designed to make your code more readable and maintainable
- The older equivalents are often much more convoluted. You should prefer writing newer and cleaner syntax, not only for yourself but for all other members of the development team
* If you transpile only for older browsers, but serve the new syntax to the newest browsers, you get to take advantage of browser performance optimizations with the new syntax - This also lets browser makers have more real-world code to test their implementations and optimizations on
* Using the new syntax earlier allows it to be tested more robustly in the real world, which provides earlier feedback to the JavaScript committee (TC39)
- If issues are found early enough, they can be changed/fixed before those language design mistakes become permanent

Here's a quick example of transpiling. ES6 adds a feature called "default parameter values." It looks like this:

```js
function foo(a = 2) {
    console.log( a );
}

foo();  // 2
foo( 42 );  // 42
```

Simple, right? Helpful, too! But it's new syntax that's invalid in pre-ES6 engines

So what will a transpiler do with that code to make it run in older environments?

```js
function foo() {
    var a = arguments[0] !== (void 0) ? arguments[0] : 2;
    console.log( a );
}
```

As you can see, it checks to see if the `arguments[0]` value is `void 0` (aka `undefined`), and if so provides the `2` default value; otherwise, it assigns whatever was passed.

In addition to being able to now use the nicer syntax even in older browsers, looking at the transpiled code actually explains the intended behavior more clearly.

You may not have realized just from looking at the ES6 version that `undefined` is the only value that can't get explicitly passed in for a default-value parameter, but the transpiled code makes that much more clear.

The last important detail to emphasize about transpilers is that they should now be thought of as a standard part of the JS development ecosystem and process
- JS is going to continue to evolve, much more quickly than before, so every few months new syntax and new features will be added

If you use a transpiler by default, you'll always be able to make that switch to newer syntax whenever you find it useful, rather than always waiting for years for today's browsers to phase out.

There are quite a few great transpilers for you to choose from. Here are some good options at the time of this writing:

* Babel (https://babeljs.io) (formerly 6to5): Transpiles ES6+ into ES5
* Traceur (https://github.com/google/traceur-compiler): Transpiles ES6, ES7, and beyond into ES5

## Non-JavaScript

So far, the only things we've covered are in the JS language itself
- The reality is that most JS is written to run in and interact with environments like browsers. A good chunk of the stuff that you write in your code is, strictly speaking, not directly controlled by JavaScript. That probably sounds a little strange

The most common non-JavaScript JavaScript you'll encounter is the DOM API. For example:

```js
var el = document.getElementById( "foo" );
```

The `document` variable exists as a global variable when your code is running in a browser
- It's not provided by the JS engine, nor is it particularly controlled by the JavaScript specification
- It takes the form of something that looks an awful lot like a normal JS `object`, but it's not really exactly that
- It's a special `object,` often called a "host object"

Moreover, the `getElementById(..)` method on `document` looks like a normal JS function, but it's just a thinly exposed interface to a built-in method provided by the DOM from your browser
- In some (newer-generation) browsers, this layer may also be in JS, but traditionally the DOM and its behavior is implemented in something more like C/C++

Another example is with input/output (I/O).

Everyone's favorite `alert(..)` pops up a message box in the user's browser window. `alert(..)` is provided to your JS program by the browser, not by the JS engine itself
- The call you make sends the message to the browser internals and it handles drawing and displaying the message box

The same goes with `console.log(..)`; your browser provides such mechanisms and hooks them up to the developer tools.

This book, and this whole series, focuses on JavaScript the language
- That's why you don't see any substantial coverage of these non-JavaScript JavaScript mechanisms. Nevertheless, you need to be aware of them, as they'll be in every JS program you write!

## Review

The first step to learning JavaScript's flavor of programming is to get a basic understanding of its core mechanisms like values, types, function closures, `this`, and prototypes.

Of course, each of these topics deserves much greater coverage than you've seen here, but that's why they have chapters and books dedicated to them throughout the rest of this series. After you feel pretty comfortable with the concepts and code samples in this chapter, the rest of the series awaits you to really dig in and get to know the language deeply.

The final chapter of this book will briefly summarize each of the other titles in the series and the other concepts they cover besides what we've already explored.

# References
- [You Don't Know JS: Up & Going](https://github.com/getify/You-Dont-Know-JS/blob/master/up%20&%20going/README.md#you-dont-know-js-up--going)
- [You Don't Know JS: Scope & Closures](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20&%20closures/README.md#you-dont-know-js-scope--closures)

