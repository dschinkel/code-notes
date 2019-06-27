# Currying
**Note**: a good amount of this is from Chet Harrison's Course [ChetHarrison/A-Gentle-Introduction-to-Functional-JavaScript](https://github.com/ChetHarrison/A-Gentle-Introduction-to-Functional-JavaScript)

Currying is a fundamental tool in functional programming, a programming pattern that tries to minimize the number of changes to a program’s state (known as side effects) by using immutable data and pure (no side effects) functions.


### Functional Programing Definitions

**First-Class Functions** - languages where functions are first-class objects. Functions can be stored in variables, objects or arrays, passed as arguments to other functions or returned from functions

**Higher-Order Functions** - Functions that can take and return functions

**Side Effects** - When a function mutates state outside it's scope

**Referential Transparency** an input of a will always return an output of b. One of the many benefits of referential transparency is that it can be cached. Caching is good test of referential transparency; If a function can be cached, it satisfies Referential Transparency

**Purity** - A referentialy transparent function with no side effects that is passed all the resources it needs to do it's job

**Partial Application** - A function with an incomplete set of parameters

**Imperative vs. Declarative** - A for loop is a very specific solution to looping. We call this "imperative" because we are explaining how to do the loop. With Array.prototype.map we are declaring what we want. If I discover a more optimal way to map I can refactor my map function with out breaking all the code that calls it. We call this "declarative". So if you want to know if you are writing declarative code ask your self if you can refactor it with out breaking the code that calls it

**Point Free** - A style where we strive to pipe data from the output of one function to the input of the next avoiding named parameters. It is more concise, easier to read, and lends itself to composition
```
const inc = x => x + 1; // x is a point
const add3 = compose( inc, inc, inc ); // no points here
const val = add3( 1 ); // val === 4

// Note composition reads from left to right!
// compose will return something like this
x => inc( inc( inc( x ) ) );
```

**Currying** - the process of taking a function with multiple arguments and returning a series of functions that take one argument and eventually resolve to a value
-  A curried function that is passed fewer parameters than it's arity will return a partially applied function that will delay execution until it has been passed all of the required parameters. see this [post by Hugh Jackson](https://web.archive.org/web/20140714014530/http://hughfdjackson.com/javascript/why-curry-helps)

**Arity** - refers to the number of parameters each function expects

**Composition** - Chaining functions together by piping the output of one function to the input of the next in the composition. Composing pure functions will respect the law of associativity. This will allow us to safely apply some optimizations to our code

**Associativity** - A binary operation in which the order of evaluation is not important. Addition of whole numbers is associative

**Container** - an object that you can place a value in with a function that takes a function and applies it to the value as input and returning a new container of the same type with the result as output

##### Example 1: Currying

[example from JSBin by Chet Harrison](https://jsbin.com/qufoka/edit?js,console)). Note JSBin can be a bit fussy so if it does not run at first try a refresh

```
const add = ( a, b ) => a + b; // has an arity of 2
const addC = curry( add ); // returns a curried add function
add3 = addC( 3 ); // add was partially applied

// the addC( 3 ) call will return a new function that looks like this
b => 3 + b;
console.log( add3( 1 ) ); // logs 4
```

##### Example 1: A Curried Function from Lodash:

```
function volume(l, w, h) {
  return l * w * h;
}

const curried = _.curry(volume);

volume(2, 3, 4); // 24
curried(2)(3)(4); // 24
```
The original function volume takes three arguments, but once curried we can instead pass in each argument to three nested functions.  In other words, currying has effectively done this:

```
function volume1(length) { 
  return function(width) {
    return function(height) {
      return height * width * length;
    }
  }
}

volume1(2)(3)(4); // 24
```

The *innermost function has access to the variables in outer functions* via JS **Closures** & **Scoping**


##### Example 2 - Writing your own curried function
We can use ES6's spread operator to help us.

Curry accepts a function as well as a variable number of parameters:

```
var curry = (fn, ...args) => ...
```

Next we need to know how many arguments (the “arity”) our function expects. If the number of arguments we already have equals the number expected, we call the function. Otherwise, we return a new function.  We can obtain both values using the length property of a function:
```
var curry = (fn, ...args) =>
  (fn.length <= args.length) ...
  ```

  Now the final step. If the value of arguments equals the value expected, we simply call the function fn(...args). But to return a new function and add it to our nested list, we store a series of functions which we can call `...more`:

  ```
  var curry = (fn, ...args) =>
    (fn.length <= args.length) ?
      fn(...args) :
      (...more) => curry(fn, ...args, ...more);
  ```


# Resources
- [Closures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)
- [You Don't Know JS: Scope & Closures](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20%26%20closures/ch5.md)
- [Currying in JavaScript](https://wsvincent.com/javascript-currying)
- [Professor Frisby’s Mostly Adequate Guide to Functional Programming](https://drboolean.gitbooks.io/mostly-adequate-guide-old/content)
- [MostlyAdequate/mostly-adequate-guide](https://github.com/MostlyAdequate/mostly-adequate-guide)
- [A Gentle Introduction to Functional JavaScript](https://www.youtube.com/watch?v=myISHtMMeyU)
- [ChetHarrison/A-Gentle-Introduction-to-Functional-JavaScript](https://github.com/ChetHarrison/A-Gentle-Introduction-to-Functional-JavaScript)
- [Discover Functional Programming in JavaScript with this thorough introduction](https://medium.freecodecamp.org/discover-functional-programming-in-javascript-with-this-thorough-introduction-a2ad9af2d645)
