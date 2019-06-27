# Table Of Contents
- [Values & Types](#values-and-types)
- [Objects](#objects)
- [Object Contents](#object-contents)
- [Functions](#functions)
- [Converting Between Types](#converting-between-types)
- [Typing and Variables](#typing-and-variables)
- [Scope](#scope)
- [JS Compilation](#js-compilation)
- [Hoisting](#hoisting)
- [Scope Closure](#scope-closure)
- [this](#this)
- [this and Call-site](#this-and-call-site)
- [Lexical this with Arrow Functions](#lexical-this-with-arrow-functions)
- [Prototpyes](#prototypes)
- [Using Object.create instead of Prototypes](#using-objectcreate-instead-of-prototypes)
- [Polyfilling](#polyfilling)
- [Asynchrony: Now & Later](#asynchrony-now--later)
- [ES6](#es6)
- [Resources](#resources)

**NOTE**: Believe it or not the **Scope** and **Closure** sections are trimmed down extensively as compared to what's in [js-basics-notes-1](js-basics-notes.md) but still fairly long in here because it's so critical to understand in order to bre a serious and effective JS developer.  You'd be wise to read this entire md file over and over till you get this ingrained into your head.

# *Values* and *Types*

As we asserted in Chapter 1, JavaScript has typed values, not typed variables. The following built-in types are available:

* `string`
* `number`
* `boolean`
* `null` and `undefined`
* `object`
* `symbol` (new to ES6)

There are a couple of other value types that you will commonly interact with in JavaScript programs: *array* and *function*
    - But rather than being proper built-in types, these should be thought of more like **subtypes** -- specialized versions of the `object` type
    - An array is an `object` that holds values (of any type) not particularly in
     named properties/keys, but rather in numerically indexed positions
     - You theoretically could use an array as a normal object with your own named properties, or you could use an `object` but only give it numeric properties (`0`, `1`, etc.) similar to an array
         - However, this would generally be considered improper usage of the respective types
         - The best and most natural approach is to use arrays for numerically positioned values and use `object`s for named properties

- functions are a subtype of `objects`
    - typeof` returns `"function"`, which implies that a `function` is a main type -- and can thus have properties, but you typically will only use function object properties (like `foo.bar`) in limited cases

- Only values have types in JavaScript; variables are just simple containers for those values

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

- The return value from the **`typeof` operator is always one of six** (seven as of ES6! - the "symbol" type) ***string* values**. That is, **`typeof "abc"` returns `"string"`, not `string`**
- `typeof null` is an interesting case, because it errantly returns `"object"`, when you'd expect it to return `"null"`
    - **Warning:** This is a long-standing bug in JS, but one that is likely never going to be fixed. Too much code on the Web relies on the bug and thus fixing it would cause a lot more bugs!
- `typeof a` is not asking for the "type of `a`", but rather for the "type of the value currently in `a`."
- `a = undefined`. We're explicitly setting `a` to the `undefined` value, but that is behaviorally no different from a variable that has no value set yet, like with the `var a;` line at the top of the snippet
    - A variable can get to this "undefined" value state in several different ways, including functions that return no values and usage of the `void` operator

### Functions As Values

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

 **functional expressions**
 - when you assign a function to a variable
    ```js
       // assigning an anonymous function (function without a name) to a variable
       var foo = function() {
           // ..
       };
       // assigning a named function to a variable
       var x = function bar(){
           // ..
       };
    ```

#### NaN

Any mathematic operation you perform without both operands being `number`s (or values that can be interpreted as regular `number`s in base 10 or base 16) will result in the operation failing to produce a valid `number`, in which case you will get the `NaN` value.

`NaN` literally stands for "not a `number`", though this label/description is very poor and misleading, as we'll see shortly
- It would be much more accurate to think of `NaN` as being "invalid number," "failed number," or even "bad number," than to think of it as "not a number"

For example:

```js
var a = 2 / "foo";  // NaN

typeof a === "number";	// true
```

In other words: "the type of not-a-number is 'number'!" Hooray for confusing names and semantics.

`NaN` is a kind of "sentinel value" (an otherwise normal value that's assigned a special meaning) that represents a special kind of error condition within the `number` set
- The error condition is, in essence: "I tried to perform a mathematic operation but failed, so here's the failed `number` result instead"

So, if you have a value in some variable and want to test to see if it's this special failed-number `NaN`, you might think you could directly compare to `NaN` itself, as you can with any other value, like `null` or `undefined`. Nope.

```js
var a = 2 / "foo";

a == NaN;  // false
a === NaN;  // false
```

`NaN` is a very special value in that it's never equal to another `NaN` value (i.e., it's never equal to itself)
- It's the only value, in fact, that is not reflexive (without the Identity characteristic `x === x`)
- So, `NaN !== NaN`. A bit strange, huh?

So how *do* we test for it, if we can't compare to `NaN` (since that comparison would always fail)?

```js
var a = 2 / "foo";

isNaN( a ); // true
```

Easy enough, right? We use the built-in global utility called `isNaN(..)` and it tells us if the value is `NaN` or not. Problem solved!

Not so fast.

The `isNaN(..)` utility has a fatal flaw. It appears it tried to take the meaning of `NaN` ("Not a Number") too literally -- that its job is basically: "test if the thing passed in is either not a `number` or is a `number`"
- But that's not quite accurate.

```js
var a = 2 / "foo";
var b = "foo";

a; // NaN
b; // "foo"

window.isNaN( a ); // true
window.isNaN( b ); // true -- ouch!
```

Clearly, `"foo"` is literally *not a `number`*, but it's definitely not the `NaN` value either! This bug has been in JS since the very beginning (over 19 years of *ouch*).

As of ES6, finally a replacement utility has been provided: `Number.isNaN(..)`
- A simple polyfill for it so that you can safely check `NaN` values *now* even in pre-ES6 browsers is:

```js
if (!Number.isNaN) {
    Number.isNaN = function(n) {
        return (
            typeof n === "number" &&
            window.isNaN( n )
        );
    };
}

var a = 2 / "foo";
var b = "foo";

Number.isNaN( a ); // true
Number.isNaN( b ); // false -- phew!
```

Actually, we can implement a `Number.isNaN(..)` polyfill even easier, by taking advantage of that peculiar fact that `NaN` isn't equal to itself. `NaN` is the *only* value in the whole language where that's true; every other value is always **equal to itself**.

So:

```js
if (!Number.isNaN) {
    Number.isNaN = function(n) {
    return n !== n;
    };
}
```

Weird, huh? But it works!

`NaN`s are probably a reality in a lot of real-world JS programs, either on purpose or by accident
- It's a really good idea to use a reliable test, like `Number.isNaN(..)` as provided (or polyfilled), to recognize them properly

If you're currently using just `isNaN(..)` in a program, the sad reality is your program *has a bug*, even if you haven't been bitten by it yet!

# Comparisons
#### False-y Comparisons

The most common complaint against *implicit* coercion in `==` comparisons comes from how falsy values behave surprisingly when compared to each other.

To illustrate, let's look at a list of the corner-cases around falsy value comparisons, to see which ones are reasonable and which are troublesome:

```js
"0" == null;      // false
"0" == undefined; // false
"0" == false;     // true -- UH OH!
"0" == NaN;       // false
"0" == 0;         // true
"0" == "";        // false

false == null;    // false
false == undefined; // false
false == NaN;     // false
false == 0;       // true -- UH OH!
false == "";      // true -- UH OH!
false == [];      // true -- UH OH!
false == {};      // false

"" == null;       // false
"" == undefined;  // false
"" == NaN;        // false
"" == 0;          // true -- UH OH!
"" == [];         // true -- UH OH!
"" == {};         // false

0 == null;        // false
0 == undefined;   // false
0 == NaN;         // false
0 == [];          // true -- UH OH!
0 == {};          // false
```

In this list of 24 comparisons, 17 of them are quite reasonable and predictable. For example, we know that `""` and `NaN` are not at all equatable values, and indeed they don't coerce to be loose equals, whereas `"0"` and `0` are reasonably equatable and *do* coerce as loose equals.

However, seven of the comparisons are marked with "UH OH!" because as false positives, they are much more likely gotchas that could trip you up. `""` and `0` are definitely distinctly different values, and it's rare you'd want to treat them as equatable, so their mutual coercion is troublesome. Note that there aren't any false negatives here.

#### The Crazy Ones

We don't have to stop there, though. We can keep looking for even more troublesome coercions:

```js
[] == ![];  // true
```

Oooo, that seems at a higher level of crazy, right!?
- Your brain may likely trick you that you're comparing a truthy to a falsy value, so the `true` result is surprising, as we *know* a value can never be truthy and falsy at the same time!

But that's not what's actually happening
- Let's break it down. What do we know about the `!` unary operator? It explicitly coerces to a `boolean` using the `ToBoolean` rules (and it also flips the parity)
- So before `[] == ![]` is even processed, it's actually already translated to `[] == false`. We already saw that form in our above list (`false == []`), so its surprise result is *not new* to us

How about other corner cases?

```js
2 == [2];  // true
"" == [null];  // true
```

As we said earlier in our `ToNumber` discussion, the right-hand side `[2]` and `[null]` values will go through a `ToPrimitive` coercion so they can be more readily compared to the simple primitives (`2` and `""`, respectively) on the left-hand side
- Since the `valueOf()` for `array` values just returns the `array` itself, coercion falls to stringifying the `array`

`[2]` will become `"2"`, which then is `ToNumber` coerced to `2` for the right-hand side value in the first comparison. `[null]` just straight becomes `""`.

So, `2 == 2` and `"" == ""` are completely understandable.

If your instinct is to still dislike these results, your frustration is not actually with coercion like you probably think it is
- It's actually a complaint against the default `array` values' `ToPrimitive` behavior of coercing to a `string` value. More likely, you'd just wish that `[2].toString()` didn't return `"2"`, or that `[null].toString()` didn't return `""`

But what exactly *should* these `string` coercions result in?
- I can't really think of any other appropriate `string` coercion of `[2]` than `"2"`, except perhaps `"[2]"` -- but that could be very strange in other contexts!

You could rightly make the case that since `String(null)` becomes `"null"`, then `String([null])` should also become `"null"`
- That's a reasonable assertion. So, that's the real culprit

*Implicit* coercion itself isn't the evil here. Even an *explicit* coercion of `[null]` to a `string` results in `""`
- What's at odds is whether it's sensible at all for `array` values to stringify to the equivalent of their contents, and exactly how that happens
- So, direct your frustration at the rules for `String( [..] )`, because that's where the craziness stems from
- Perhaps there should be no stringification coercion of `array`s at all? But that would have lots of other downsides in other parts of the language

Another famously cited gotcha:

```js
0 == "\n";  // true
```

As we discussed earlier with empty `""`, `"\n"` (or `" "` or any other whitespace combination) is coerced via `ToNumber`, and the result is `0`. What other `number` value would you expect whitespace to coerce to?
- Does it bother you that *explicit* `Number(" ")` yields `0`?

Really the only other reasonable `number` value that empty strings or whitespace strings could coerce to is the `NaN`
- But would that *really* be better?
- The comparison `" " == NaN` would of course fail, but it's unclear that we'd have really *fixed* any of the underlying concerns

The chances that a real-world JS program fails because `0 == "\n"` are awfully rare, and such corner cases are easy to avoid.

Type conversions **always** have corner cases, in any language -- nothing specific to coercion
- The issues here are about second-guessing a certain set of corner cases (and perhaps rightly so!?), but that's not a salient argument against the overall coercion mechanism

Bottom line: almost any crazy coercion between *normal values* that you're likely to run into (aside from intentionally tricky `valueOf()` or `toString()` hacks as earlier) will boil down to the short seven-item list of gotcha coercions we've identified above.

To contrast against these 24 likely suspects for coercion gotchas, consider another list like this:

```js
42 == "43";  // false
"foo" == 42;  // false
"true" == true; // false

42 == "42";  // true
"foo" == [ "foo" ];  // true
```

In these nonfalsy, noncorner cases (and there are literally an infinite number of comparisons we could put on this list), the coercion results are totally safe, reasonable, and explainable

#### Safely Using Implicit Coercion

The most important advice I can give you: examine your program and reason about what values can show up on either side of an `==` comparison. To effectively avoid issues with such comparisons, here's some heuristic rules to follow:

1. If either side of the comparison can have `true` or `false` values, don't ever, EVER use `==`.
2. If either side of the comparison can have `[]`, `""`, or `0` values, seriously consider not using `==`.

In these scenarios, it's almost certainly better to use `===` instead of `==`, to avoid unwanted coercion
- Follow those two simple rules and pretty much all the coercion gotchas that could reasonably hurt you will effectively be avoided

**Being more explicit/verbose in these cases will save you from a lot of headaches.**

The question of `==` vs. `===` is really appropriately framed as: should you allow coercion for a comparison or not?

There's lots of cases where such coercion can be helpful, allowing you to more tersely express some comparison logic (like with `null` and `undefined`, for example).

In the overall scheme of things, there's relatively few cases where *implicit* coercion is truly dangerous
- But in those places, for safety sake, definitely use `===`

**Tip:** Another place where coercion is guaranteed *not* to bite you is with the `typeof` operator
- `typeof` is always going to return you one of seven strings (see Chapter 1), and none of them are the empty `""` string
- As such, there's no case where checking the type of some value is going to run afoul of *implicit* coercion
- `typeof x == "function"` is 100% as safe and reliable as `typeof x === "function"`
- Literally, the spec says the algorithm will be identical in this situation
- So, don't just blindly use `===` everywhere simply because that's what your code tools tell you to do, or (worst of all) because you've been told in some book to **not think about it**. You own the quality of your code.

Is *implicit* coercion evil and dangerous? In a few cases, yes, but overwhelmingly, no.

# Objects
- **Objects** are the general **building block upon which much of JS is built**. They are *one of the 6 primary types*
    - *simple primitives* (`string`, `number`, `boolean`, `null`, and `undefined`) are **not** themselves `objects`
    - A primitive (primitive value, primitive data type) is data that is not an object and has no methods
    - `null` is *sometimes referred to as an object type*, but **this misconception stems from a bug in the language which causes `typeof null` to return the string `"object"` incorrectly**.  **`null` is its own primitive type**
    - `function` is a sub-type of object (technically, a "callable object")
    - **Functions in JS are said to be "first class"** in that they **are basically just normal objects** (with callable behavior semantics bolted on), and **so they can be handled like any other plain object**
    - **Arrays** are also a form of **objects, *with extra behavior***
- **It's a common mis-statement that "everything in JavaScript is an object". This is clearly not true.**
    - because there *are* a few **special object *****sub-types***, which we can refer to as ***complex** primitives*

- There are several **other** object **sub-types**, usually referred to as **built-in** objects

    - For some of them, their names seem to imply they are directly related to their simple primitives counter-parts, but in fact, their relationship is more complicated, which we'll explore shortly

    * `String`
    * `Number`
    * `Boolean`
    * `Object`
    * `Function`
    * `Array`
    * `Date`
    * `RegExp`
    * `Error`

    - These built-ins **have the appearance of being actual types**, even classes, if you rely on the similarity to other languages such as Java's `String` class

    - **But** in JS, **these are actually just built-in *functions***
        - Each of these built-in functions can be used as a constructor (that is, a function call with the `new` operator -- see Chapter 2), with the result being a newly *constructed* object of the sub-type in question. For instance:

        ```js
        var strPrimitive = "I am a string";
        typeof strPrimitive;							// "string"
        strPrimitive instanceof String;					// false
        
        var strObject = new String( "I am a string" );
        typeof strObject; 								// "object"
        strObject instanceof String;					// true
        
        // inspect the object sub-type
        Object.prototype.toString.call( strObject );	// [object String]
        ```
- The `object` type refers to a compound value where you can set properties (named locations) that each hold their own values of any type.]
- Objects come in two forms:
    - **declarative** (*literal*) form:
        ```js
        var myObj = {
            key: value
            // ...
        };
        ```
    - **constructed** form:
        ```js
        var myObj = new Object();
        myObj.key = value;
        ```
- The **constructed** form and the **literal** form ***result in exactly the same sort of object***
    - The **only difference really is that you can add one or more key/value pairs to the literal declaration**, whereas with **constructed-form objects**, you **must add the properties one-by-one**
    - **It's extremely uncommon to use the "constructed form" for creating objects as just shown**.  ***pretty much always want to use the literal syntax form***
- Properties on an object can either be accessed with *dot notation* (i.e., `obj.a`) or *bracket notation* (i.e., `obj["a"]`)
    - Bracket notation is useful if you have a property name that has special characters in it, like `obj["hello world!"]`
        - such properties are often referred to as *keys* when accessed via bracket notation
    - The `[ ]` notation requires either a variable (explained next) or a `string` *literal* (which needs to be wrapped in `" .. "` or `' .. '`)
    - bracket notation is also useful if you want to access a property/key but the name is stored in another variable
        ```js
        var obj = {
            a: "hello world",
            b: 42
        };
        
        var b = "a";
        
        obj[b];   // "hello world"
        obj["b"];  // 42
        ```
- When you use a primitive value like `"hello world"` as an `object` by referencing a property or method (e.g., `a.toUpperCase()` in the previous snippet), JS automatically "boxes" the value to its object wrapper counterpart (hidden under the covers)
    - A `string` value can be wrapped by a `String` object, a `number` can be wrapped by a `Number` object, and a `boolean` can be wrapped by a `Boolean` object
    - For the most part, you don't need to worry about or directly use these object wrapper forms of the values -- prefer the primitive value forms in practically all cases and JavaScript will take care of the rest for you

#### Duplicating Objects
     - A *shallow copy* would end up with `a` on the new object as a copy of the value `2`, but `b`, `c`, and `d` properties as just references to the same places as the references in the original object
     - A *deep copy* would duplicate not only `myObject`, but `anotherObject` and `anotherArray`
        - But then we have issues that `anotherArray` has references to `anotherObject` and `myObject` in it, so *those* should also be duplicated rather than reference-preserved
        - Now we have an infinite circular duplication problem because of the circular reference

###### Ways to Duplication an Object
**Deep Copy**
- Parsing a JSON object to a JS Object
    - One subset solution is that **objects which are JSON-safe** (that is, can be serialized to a JSON string and then re-parsed to an object with the same structure and values) **can easily be *duplicated* with:**
        ```js
        var newObj = JSON.parse( JSON.stringify( someObj ) );
        ```
**Shallow Copy**
- a **shallow copy** is fairly understandable and **has far less issues**, so **ES6 has now defined `Object.assign(..)` for this task. `Object.assign(..)`**
    - takes a *target* object as its first parameter, and one or more *source* objects as its subsequent parameters
    - It **iterates over all the *enumerable*** (see below), ***owned keys*** (**immediately present**) on the ***source* object(s)** and **copies them (via `=` assignment only) to *target***. It also, helpfully, **returns *target***, as you can see below:
        ```js
        var newObj = Object.assign( {}, myObject );
        
        newObj.a; // 2
        newObj.b === anotherObject; // true
        newObj.c === anotherArray;  // true
        newObj.d === anotherFunction; // true
        ```

#### Summary
- Objects are one of the 6 (or 7, depending on your perspective) primitive types. Objects have sub-types, including `function`, and also can be behavior-specialized, like `[object Array]` as the internal label representing the array object sub-type
- Objects are collections of key/value pairs
  - The values can be accessed as properties, via `.propName` or `["propName"]` syntax. Whenever a property is accessed, the engine actually invokes the internal default `[[Get]]` operation (and `[[Put]]` for setting values), which not only looks for the property directly on the object, but which will traverse the `[[Prototype]]` chain (see Chapter 5) if not found
- Properties have certain characteristics that can be controlled through property descriptors, such as `writable` and `configurable`
  - In addition, objects can have their mutability (and that of their properties) controlled to various levels of immutability using `Object.preventExtensions(..)`, `Object.seal(..)`, and `Object.freeze(..)`
- Properties don't have to contain values -- they can be "accessor properties" as well, with getters/setters
  - They can also be either *enumerable* or not, which controls if they show up in `for..in` loop iterations, for instance

# Object Contents
As mentioned earlier, the **contents of an object consist of values** (any type) **stored at specifically named *locations*, which we call *properties***

*It's important to note that while we say "contents" which implies that these values are *actually* stored inside the object, that's merely an appearance*. The **engine stores values in implementation-dependent ways**, and **may very well not store them *in* some object container**
- What **is* stored in the container* are these **property names**, which ***act as pointers*** (technically, *references*) *to where the values are stored*

    ```js
    var myObject = {
        a: 2
    };
    
    myObject.a;		// 2
    myObject["a"];	// 2
    ```

    - To access the value at the *location* `a` in `myObject`, we need to use either the `.` operator or the `[ ]` operator.
        - The `.a` syntax is usually referred to as "property" access, whereas the `["a"]` syntax is usually referred to as "key" access
        - In reality, they both access the same *location*, and will pull out the same value, `2`, so the terms can be used interchangeably
        - We will use the most common term, "property access" from here on
    - The `myObject[..]` property access syntax we just described is useful if you need to use a computed expression value *as* the key name, like `myObject[prefix + name]`
- a property access like `myObject.a` may result in an `undefined` value if either the explicit `undefined` is stored there or the `a` property doesn't exist at all. So, if the value is the same in both cases, how else do we distinguish them?
    - We can ask an object if it has a certain property *without* asking to get that property's value:
        ```js
        var myObject = {
            a: 2
        };
        
        ("a" in myObject);				// true
        ("b" in myObject);				// false
        
        myObject.hasOwnProperty( "a" );	// true
        myObject.hasOwnProperty( "b" );	// false
        ```

        The `in` operator will check to see if the property is *in* the object, or if it exists at any higher level of the `[[Prototype]]` chain object traversal (see Chapter 5)
         - By contrast, `hasOwnProperty(..)` checks to see if *only* `myObject` has the property or not, and will *not* consult the `[[Prototype]]` chain
         - We'll come back to the important differences between these two operations in Chapter 5 when we explore `[[Prototype]]`s in detail
         - `hasOwnProperty(..)` is accessible for all normal objects via delegation to `Object.prototype` (see Chapter 5)
         - But be aware that it's possible to create an object that does not link to `Object.prototype` (via `Object.create(null)`
         - `Object.keys(..)` returns an array of all enumerable properties
            - `in` vs. `hasOwnProperty(..)` differ in whether they consult the `[[Prototype]]` chain or not, `Object.keys(..)` and `Object.getOwnPropertyNames(..)` both inspect *only* the direct object specified
        - There's (currently) no built-in way to get a list of **all properties** which is equivalent to what the `in` operator test would consult (traversing all properties on the entire `[[Prototype]]` chain)

# Functions

**functions never "belong" to objects**, so **saying that a function that just happens to be accessed on an object reference is automatically a "method" seems a bit of a stretch of semantics**.

- It *is* true that **some functions have `this` references in them**, and that ***sometimes* these `this` references refer to the object reference at the call-site**
    - But this usage really does not make that function any more a "method" than any other function, as `this` is dynamically bound at run-time, at the call-site, and thus its relationship to the object is indirect, at best
- Every time you access a property on an object, that is a **property access**, regardless of the type of value you get back
    - If you *happen* to get a function from that property access, it's not magically a "method" at that point. There's nothing special (outside of possible implicit `this` binding as explained earlier) about a function that comes from a property access
        ```js
        function foo() {
            console.log( "foo" );
        }
        
        var someFoo = foo;	// variable reference to `foo`
        
        var myObject = {
            someFoo: foo
        };
        
        foo;				// function foo(){..}
        someFoo;			// function foo(){..}
        myObject.someFoo;	// function foo(){..}
        ```

        - `someFoo` and `myObject.someFoo` are just two separate references to the same function, and neither implies anything about the function being special or "owned" by any other object
            - If `foo()` above was defined to have a `this` reference inside it, that `myObject.someFoo` *implicit binding* would be the **only** observable difference between the two references. Neither reference really makes sense to be called a "method"
- **Even when you declare a function expression as part of the object-literal**, **that function doesn't magically *belong* more to the object** -- still **just multiple references to the same function object**:
    ```js
    var myObject = {
        foo: function foo() {
            console.log( "foo" );
        }
    };
    
    var someFoo = myObject.foo;
    someFoo;		// function foo(){..}
    myObject.foo;	// function foo(){..}
    ```

- **"function" and "method" are interchangeable in JavaScript**

# Converting Between Types
- Having a proper understanding of each *type* and its intrinsic behavior is absolutely essential to understanding how to properly and accurately convert values to different types
- JavaScript defines seven built-in types
- **JS implicit coercion**
- there is "explicit" and "implicit" coercion
- JS implicit coercion is controversial
    - a controversial topic is what happens when you try to compare two values that are not already of the same type, which would require implicit coercion
    - When comparing the string "99.99" to the number 99.99, most people would agree they are equivalent
    - But in JS they're not; the same value in two different representations, two different types
    - **To help you out in these common situations, JavaScript will sometimes kick in and implicitly coerce values to the matching types**
    - if you use the == loose equals operator to make the comparison "99.99" == 99.99, JavaScript will convert the left-hand side "99.99" to its number equivalent 99.99
    - The comparison then becomes 99.99 == 99.99, which is of course true
    - While designed to help you, implicit coercion can create confusion if you haven't taken the time to learn the rules that govern its behavior
    - Most JS developers never have, so the common feeling is that implicit coercion is confusing and harms programs with unexpected bugs, and should thus be avoided. It's even sometimes called a flaw in the design of the language
    - However, implicit coercion is a mechanism that can be learned, and moreover should be learned by anyone wishing to take JavaScript programming seriously
        - Not only is it not confusing once you learn the rules, it can actually make your programs better! The effort is well worth it
- **JS explicit coercion**
    - JavaScript provides several different facilities for forcibly coercing between types

### Null
The **`typeof` operator** inspects the type of the given value, and **always returns one of seven string values** -- surprisingly, ***there's not an exact 1-to-1 match with the seven built-in types we just listed***.

```js
typeof undefined     === "undefined"; // true
typeof true          === "boolean";   // true
typeof 42            === "number";    // true
typeof "42"          === "string";    // true
typeof { life: 42 }  === "object";    // true

// added in ES6!
typeof Symbol() === "symbol"; // true
```

These six listed types have values of the corresponding type and return a string value of the same name, as shown
- `Symbol` is a new data type as of ES6, and will be covered in Chapter 3

As you may have noticed, I excluded `null` from the above listing
- It's *special* -- special in the sense that it's buggy when combined with the `typeof` operator:

```js
typeof null === "object"; // true
```

It would have been nice (and correct!) if it returned `"null"`, but this original bug in JS has persisted for nearly two decades, and will likely never be fixed because there's too much existing web content that relies on its buggy behavior that "fixing" the bug would *create* more "bugs" and break a lot of web software.

If you want to test for a `null` value using its type, you need a compound condition:

```js
var a = null;
(!a && typeof a === "object"); // true
```

`null` is the only primitive value that is "falsy" (aka false-like; see Chapter 4) but that also returns `"object"` from the `typeof` check.

### Equality: == vs ===
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

- Much of the == coercion is pretty sensible, but there are some important corner cases to be careful of
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

### Inequality

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
    - It's not all that difficult to confuse yourself with a situation that seems like it's coercing a value to a `boolean` when it's not

**Examples**
###### Explicit Conversions
Example 1: Using **Number(..)** (a built-in function)

Example 2:
 ```js
   var a = "42";
   
   var b = Number( a );
   
   a;  // "42"
   b;  // 42 -- the number!
   ```
###### Implicit Conversions
Example 1: comparing two different types with ==
    - "99.99" == 99.99

Example 2:
```js
var a = "42";

var b = a * 1;	// "42" implicitly coerced to 42 here

a;  // "42"
b;  // 42 -- the number!
```

# Typing and Variables
- **Static typing**, otherwise known as **type enforcement**, is typically cited as a benefit for program correctness by preventing unintended value conversions
- **Weak Typing** - Other languages emphasize types for values instead of variables
    - Weak typing, otherwise known as dynamic typing, allows a variable to hold any type of value at any time
    - **JavaScript uses dynamic/weak typing**, meaning *variables can hold values of any type without any type enforcement*
- Now, if you're a fan of strongly typed (statically typed) languages, you may object to this usage of the word "type." **In those languages, "type" means a whole lot *more* than it does here in JS**.

# Classes
### Class Theory

```js
class Vehicle {
    engines = 1

    ignition() {
        output( "Turning on my engine." )
    }

    drive() {
        ignition()
        output( "Steering and moving forward!" )
    }
}

class Car inherits Vehicle {
    wheels = 4

    drive() {
        inherited:drive()
        output( "Rolling on all ", wheels, " wheels!" )
    }
}

class SpeedBoat inherits Vehicle {
    engines = 2

    ignition() {
        output( "Turning on my ", engines, " engines." )
    }

    pilot() {
        inherited:drive()
        output( "Speeding through the water with ease!" )
    }
}
```

- "Class/Inheritance" describes a certain form of code organization and architecture -- a way of modeling real world problem domains in our software
- Classes also imply a **way of *classifying* a certain data structure**
    - The way we do this is to think about any given structure as a specific variation of a more general base definition
- A *car* can be described as a specific implementation of a more general "class" of thing, called a *vehicle*
    - We model this relationship in software with classes by defining a `Vehicle` class and a `Car` class
    - The definition of `Vehicle` might include things like *propulsion* (engines, etc.), the *ability to carry people*, etc., which would all be the **behaviors**
    - What we define in `Vehicle` is all the stuff that is common to all (or most of) the different types of vehicles (the "planes, trains, and automobiles")
    - It might not make sense in our software to re-define the basic essence of "ability to carry people" over and over again for each different type of vehicle. Instead, we define that capability once in `Vehicle`, and then when we define `Car`, we simply indicate that it "inherits" (or "extends") the base definition from `Vehicle`. The definition of `Car` is said to ***specialize* the general `Vehicle` definition**
    - While `Vehicle` and `Car` collectively define the behavior by way of methods, the data in an instance would be things like the unique VIN of a specific car, etc
    - **And thus, classes, inheritance, and instantiation emerge.**
    - Another key concept with classes is **"polymorphism"**, which describes the idea that a **general behavior from a parent class can be overridden in a child class to give it more specifics**
- Class theory strongly suggests that a parent class and a child class share the same method name for a certain behavior, so that the child overrides the parent (differentially)
    - but **doing so in your JavaScript code is opting into frustration and code brittleness**
We define the `Vehicle` class to assume an engine, a way to turn on the ignition, and a way to drive around. But you wouldn't ever manufacture just a generic "vehicle", so it's really just an abstract concept at this point.

So then we define two specific kinds of vehicle: `Car` and `SpeedBoat`
- They each inherit the general characteristics of `Vehicle`, but then they specialize the characteristics appropriately for each kind
- A car needs 4 wheels, and a speed boat needs 2 engines, which means it needs extra attention to turn on the ignition of both engines

### JavaScript "Classes"
- if you have experience with **"functional programming"** (**Monads**, etc.), *you know very well that classes are just one of several common design patterns*. But *for others, this may be the first time you've asked yourself if classes really are a fundamental foundation for code, or if they are an optional abstraction on top of code*
    - Some languages (like Java) don't give you the choice, so it's not very *optional* at all -- everything's a class. Other languages like **C/C++** or **PHP** *give you both procedural and class-oriented syntaxes*, and it's left more to the developer's choice which style or mixture of styles is appropriate
- Where does JavaScript fall in this regard?
    - JS has had *some* class-like syntactic elements (like `new` and `instanceof`) for quite awhile, and more recently in ES6, some additions, like the `class` keyword
    - **But does that mean JavaScript actually *has* classes? Plain and simple: **No.****
    - Since classes are a design pattern, you *can*, with quite a bit of effort (as we'll see throughout the rest of this chapter), implement approximations for much of classical class functionality. JS tries to satisfy the extremely pervasive *desire* to design with classes by providing seemingly class-like syntax**
    - While we may have a syntax that looks like classes,** it's as if JavaScript mechanics are fighting against you using the *class design pattern*, because behind the curtain, the mechanisms that you build on are operating quite differently**
    - **JS "Class" libraries go a long way toward hiding this reality from you**, but **sooner or later you will face the fact that the *classes* you have in other languages are not like the "classes" you're faking in JS
    - What this boils down to is that **classes are an optional pattern in software design**, and you have the choice to use them in JavaScript or not
    - Since many developers have a strong affinity to class oriented software design, we'll spend the rest of this chapter exploring what it takes to maintain the illusion of **classes with what JS provides**, and the **pain points** we experience

**Note:** Another thing that traditional class-oriented languages give you via `super` is a direct way for the constructor of a child class to reference the constructor of its parent class
- This is largely true because with real classes, the constructor belongs to the class. However, in JS, it's the reverse -- it's actually more appropriate to think of the "class" belonging to the constructor (the `Foo.prototype...` type references)
- Since in JS the relationship between child and parent exists only between the two `.prototype` objects of the respective constructors, the constructors themselves are not directly related, and thus there's no simple way to relatively reference one from the other
- JavaScript is simpler: it does not provide a native mechanism for "multiple inheritance"
    - Many see this is a good thing, because the complexity savings more than make up for the "reduced" functionality
    - But this doesn't stop developers from trying to fake it in various ways, as we'll see next

In class-oriented languages, which have relative polymorphism, the linkage between `Car` and `Vehicle` is established once, at the top of the class definition, which makes for only one place to maintain such relationships.

But because of JavaScript's peculiarities, explicit pseudo-polymorphism (because of shadowing!) creates brittle manual/explicit linkage **in every single function where you need such a (pseudo-)polymorphic reference**
    - This can significantly increase the maintenance cost
    - Moreover, while explicit pseudo-polymorphism can emulate the behavior of "multiple inheritance", it only increases the complexity and brittleness
    The result of such approaches is usually more complex, harder-to-read, *and* harder-to-maintain code. **Explicit pseudo-polymorphism should be avoided wherever possible**, because the cost outweighs the benefit in most respects

### Class Mechanics
- In many **class-oriented languages**, the "standard library" provides a **"stack"** data structure (push, pop, etc.) as a `Stack` class. This class would have an internal set of variables that stores the data, and it would have a set of publicly accessible behaviors ("methods") provided by the class, which gives your code the ability to interact with the (hidden) data (adding & removing data, etc.)
    - But in such languages, **you don't really operate directly on `Stack`** (unless making a **Static** class member reference, which is outside the scope of our discussion). The **`Stack` class is merely an abstract explanation of what *any* "stack" should do, but it's not itself *a* "stack"**. You must **instantiate** the `Stack` class before you have a concrete data structure *thing* to operate against
    - A class is a blue-print. To actually *get* an object we can interact with, we must build (aka, "instantiate") something from the class
        - The end result of such "construction" is an object, typically called an "instance", which we can directly call methods on and access any public data properties from, as necessary
        - **This object is a *copy*** of all the characteristics described by the class

### Review
Classes are a design pattern. Many languages provide syntax which enables natural class-oriented software design. JS also has a similar syntax, but it behaves **very differently** from what you're used to with classes in those other languages.

**Classes mean copies.**

When traditional classes are instantiated, a copy of behavior from class to instance occurs. When classes are inherited, a copy of behavior from parent to child also occurs.

Polymorphism (having different functions at multiple levels of an inheritance chain with the same name) may seem like it implies a referential relative link from child back to parent, but it's still just a result of copy behavior.

JavaScript **does not automatically** create copies (as classes imply) between objects

# Scope
(aka ***lexical scope***)
- One of the most fundamental paradigms of nearly all programming languages is the ability to store values in variables, and later retrieve or modify those values
- there's a well-defined set of rules for storing variables in some location, and for finding those variables at a later time. **We'll call that set of rules: *Scope***
- Scope is a set of rules for looking up variables by their identifier name
    - There's usually more than one Scope to consider
- scope consists of a series of "bubbles" that each act as a container or bucket, in which identifiers (variables, functions) are declared
    - These bubbles nest neatly inside each other, and this nesting is defined at author-time
- we defined "scope" as the set of rules that govern how the Engine can look up a variable by its identifier name and find it, either in the current Scope, or in any of the Nested Scopes it's contained within
    - if a variable cannot be found in the immediate scope, Engine consults the next outer containing scope, continuing until found or until the outermost (aka, global) scope has been reached
- JavaScript has function-based scope
    - **each function you declare creates a bubble for itself, but no other structures create their own scope bubbles**
    - Function scope encourages the idea that all variables belong to the function, and can be used and reused throughout the entirety of the function (and indeed, accessible even to nested scopes)
    - however be aware that if you don't take careful precautions, variables existing across the entirety of a scope can lead to some unexpected pitfalls
 - **Lexical Scope** (as opposed to Dynamic Scope) - is by far the most common, used by the vast majority of programming languages and is the scope JavaScript applies
    - In JS, each function gets its own scope
    - Only code inside that function can access that function's scoped variables
    - a scope can be nested inside another scope
        - **If one scope is nested inside another, code inside the innermost scope can access variables from either scope**
    - No matter where a function is invoked from, or even how it is invoked, its lexical scope is only defined by where the function was declared
** Dynamic Scope **
- You examine what happens while executing the program (“at runtime”)
- **Global variables** are also **automatically properties of the global object** (window in browsers, etc.)

#### lexing
- scope that is defined at lexing time
    - is based on where variables and blocks of scope are authored, by you, at write time, and thus is (mostly) set in stone by the time the lexer processes your code
- the first traditional phase of a standard language compiler is called lexing (aka, tokenizing)
- It is this concept which provides the foundation to understand what lexical scope is and where the name comes from
- there are some ways to cheat lexical scope, thereby modifying it after the lexer has passed by, but these are frowned upon (e.g. using eval)
    - It is considered best practice to treat lexical scope as, in fact, lexical-only, and thus entirely author-time in nature

#### Look-ups
- scope bubbles fully explains to the Engine all the places it needs to look to find an identifier
- It first starts with the innermost scope bubble
- if it doesn't find what it's looking for there, so it goes up one level, out to the next nearest scope
- if it eventually finds it while walking from innermost scope to outer, then it'll use it at whichever scope it was found in
- Scope look-up stops once it finds the first match
- The same identifier name (e.g. a variable with the same name found in multiple scopes) can be specified at multiple layers of nested scope, which is called "shadowing"
    - Regardless of shadowing, scope look-up always starts at the innermost scope being executed at the time, and works its way outward/upward until the first match, and stops

#### Scope Hiding
- taking any arbitrary section of code you've written, and wrap a function declaration around it, which in effect "hides" the code
    - The result is that this creates a **scope bubble** around the code in question
          - means that any declarations (variable or function) in that code will now be tied to the scope of the new wrapping function, rather than the previously enclosing scope
          - so in other words, you can "hide" variables and functions by enclosing them in the scope of a function

#### Functions As Scopes
 - remember that we can take any snippet of code and wrap a function around it, and that effectively "hides" any enclosed variable or function declarations from the outside scope inside that function's inner scope
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
         - The easiest way to distinguish declaration vs. expression is the position of the word "function" in the statement (not just a line, but a distinct statement). If "function" is the very first thing in the statement, then it's a function declaration. Otherwise, it's a function expression

#### immediately invoked function expression (IIFE)
###### What It Is
  - if you recall a function value should be thought of as an expression, much like any other value or expression.  A function value (functional expression) is when you assign a function to a variable
  - There are a couple ways to execute an functional expression:
    - on the variable: foo()
    - via an IIFE
        ```js
        (function IIFE(){
            console.log( "Hello!" );
        })();
        // "Hello!"
        ```
        - The outer `( .. )` that surrounds the `(function IIFE(){ .. })` function expression is just a nuance of JS grammar needed to prevent it from being treated as a normal function declaration
        - The final `()` on the end of the expression -- the `})();` line -- is what actually executes the function expression referenced immediately before it
        - That may seem strange, but it's not as foreign as first glance. Consider the similarities between `foo` and `IIFE` here:
          ```js
          function foo() { .. }
          
          // `foo` function reference expression,
          // then `()` executes it
          foo();
          
          // `IIFE` function expression,
          // then `()` executes it
          (function IIFE(){ .. })();
          ```
          - As you can see, listing the `(function IIFE(){ .. })` before its executing `()` is essentially the same as including `foo` before its executing `()`

###### IIFE and Scope
  - the fundamental unit of variable scoping in JavaScript has always been the function
  - If you **needed to create a block of scope**, the most prevalent way to do so other than a regular function declaration was the immediately invoked function expression (IIFE)
    - Because an IIFE is just a function, and functions create variable *scope*, using an IIFE in this fashion is often used to declare variables that won't affect the surrounding code outside:
      ```js
      var a = 2;
      
      (function IIFE(){
          var a = 3;
          console.log( a )  // 3
      })();
      
      console.log( a );
      ```
#### Block Scopes
- While functions are the most common, other units of scope are possible, and the usage of these other scope units can lead to even better, cleaner to maintain code

**Examples**
###### 1
```js
for (var i=0; i<10; i++) {
    console.log( i );
}
```
- We declare the variable i directly inside the for-loop head, most likely because our intent is to use i only within the context of that for-loop, and essentially ignore the fact that the variable actually scopes itself to the enclosing scope (function or global)
- That's what block-scoping is all about. Declaring variables as close as possible, as local as possible, to where they will be used
###### 2
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
###### 3
```js
for (var i=0; i<10; i++) {
    console.log( i );
}
```
- Why pollute the entire scope of a function with the i variable that is only going to be (or only should be, at least) used for the for-loop?
- Block-scoping (if it were possible) for the i variable would make i available only for the for-loop, causing an error if i is accessed elsewhere in the function
- This helps ensure variables are not re-used in confusing or hard-to-maintain ways

#### try/catch
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

#### let
- Thus far, we've seen that JavaScript only has some strange niche behaviors which expose block scope functionality. If that were all we had, and it was for many, many years, then block scoping would not be terribly useful to the JavaScript developer
- ES6 changes that, and introduces a new keyword let which sits alongside var as another way to declare variables
- let allows you to declare variables that are limited in scope to the block, statement, or expression on which it is used
- The main difference vs var is that the scope of a var variable is the entire enclosing function and variables declared by let have as their scope the block in which they are defined
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

#### Garbage Collection
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

**Use Cases**
 - If all variables and functions were in the global scope, they would of course be accessible to any nested scope. But this would violate the "Least..." principle in that you are (likely) exposing many variables or functions which you should otherwise keep private, as proper use of the code would discourage access to those variables/functions
 - Collision Avoidance
    - avoid unintended collision between two different identifiers with the same name but different intended usages
    - Collision results often in unexpected overwriting of values
    - A particularly strong example of (likely) variable collision occurs in the global scope
        - Multiple libraries loaded into your program can quite easily collide with each other if they don't properly hide their internal/private functions and variables
    - Another option for collision avoidance is the more modern "module" approach, using any of various dependency managers
        - Using these tools, no libraries ever add any identifiers to the global scope, but are instead required to have their identifier(s) be explicitly imported into another specific scope through usage of the dependency manager's various mechanisms
        - enforce that no identifiers are injected into any shared scope, and are instead kept in private, non-collision-susceptible scopes, which prevents any accidental scope collisions
        - The key difference we can observe here between a function declaration and a function expression relates to where its name is bound as an identifier
                      - Compare the previous two snippets. In the first snippet, the name foo is bound in the enclosing scope, and we call it directly with foo(). In the second snippet, the name foo is not bound in the enclosing scope, but instead is bound only inside of its own function
                      - In other words, (function foo(){ .. }) as an expression means the identifier foo is found only in the scope where the .. indicates, not in the outer scope. Hiding the name foo inside itself means it does not pollute the enclosing scope unnecessarily

**Examples**
###### Scope Bubbles
```js
// global scope

function foo(a) {

  // scope of foo
  var b = a * 2;

  function bar(c) {
  
    // scope of bar
    console.log( a, b, c );
  }

  bar(b * 3);
}

foo( 2 ); // 2 4 12
```
  - There are three nested scopes inherent in this code example
      - global scope has just one identifier in it: foo
      - the scope of foo, which includes the three identifiers: a, bar and b
      - the scope of bar, and it includes just one identifier: c
  - Scope bubbles are defined by where the blocks of scope are written, which one is nested inside the other, etc

###### Function Scope Bubble
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
- bar(..) has its own scope bubble. So does the global scope, which has just one identifier attached to it: foo
- Because a, b, c, and bar all belong to the scope bubble of foo(..), they are not accessible outside of foo(..) and also available inside of bar(..)
- (a, b, c, foo, and bar) are accessible inside of foo(..)
- **It doesn't matter *where*** in the scope a declaration appears, the variable or function belongs to the containing scope bubble, regardless

###### Nested Scope
- code inside the inner() function has access to both variables a and b, but code in outer() has access only to a
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

###### Hiding Scope
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
###### Collision Avoidance
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

##### [eval - details here](js-basics-notes.md)

# JS Compilation
- despite the fact that JavaScript falls under the general category of "dynamic" or "interpreted" languages, it is in fact a compiled language
- JavaScript engines don't get the luxury (like other language compilers) of having plenty of time to optimize, because JavaScript compilation doesn't happen in a build step ahead of time, as with other languages
    - the compilation that occurs happens, in many cases, mere microseconds (or less!) before the code is executed
    - To ensure the fastest performance, JS engines use all kinds of tricks (like JITs, which lazy compile and even hot re-compile, etc.) which are well beyond the "scope" of our discussion here
    - Let's just say, for simplicity's sake, that any snippet of JavaScript has to be compiled before (usually right before!) it's executed
    - So, the JS compiler will take the program var a = 2; and compile it first, and then be ready to execute it, usually right away

# Hoisting
- There's a temptation to think that all of the code you see in a JavaScript program is interpreted line-by-line, top-down in order, as the program executes
- **the best way to think about things is that all declarations, both variables and functions, are processed first, before any part of your code is executed**
- one way of thinking, sort of metaphorically, about this process, is that **variable and function declarations are "moved" from where they appear in the flow of the code to the top of the code. This gives rise to the name "Hoisting"**
- (declaration) comes before (assignment)
- **Only the declarations themselves are hoisted, while any assignments or other executable logic are left *in place***
- hoisting is per-scope
- **Function *declarations* are hoisted, as we just saw. But function *expressions* are not**
- **Both function declarations and variable declarations are hoisted**
    - **functions are hoisted first**, and then variables

**Examples**
###### Hosting Example 1
```js
foo();

function foo() {
    console.log( a ); // undefined

    var a = 2;
}
```
- function foo's declaration (which in this case includes the implied value of it as an actual function) is hoisted, such that the call on the first line is able to execute
###### Per Scope Hosting
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

###### Function Declarations are Hosted, Functional Expressions are not
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
###### Functions are Hoisted First, then Variables
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

# Scope Closure
- You can think of closure as a **way to "remember" and continue to access a function's scope** (its variables) **even once the function has finished running**
- *Closure* is when **a function is able to remember and access its lexical scope even when that function is executing outside its lexical scope**
- ***Closure lets the function continue to access the lexical scope it was defined in at author-time***
- closure is something all around you in your code
- **Whatever facility we use to *transport an inner function outside of its lexical scope*, it *will maintain a scope reference to where it was originally declared*, and *wherever we execute it, that closure will be exercised***
- whenever and wherever you treat functions (which access their own respective lexical scopes) as first-class values and pass them around, you are likely to see those functions exercising closure

**Examples**
###### Basic Closure 1
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
- he reference to the inner `add(..)` function that gets returned with each call to the outer `makeAdder(..)` is able to remember whatever `x` value was passed in to `makeAdder(..)`
    ```js
    // `plusOne` gets a reference to the inner `add(..)`
    // function with closure over the `x` parameter of
    // the outer `makeAdder(..)`
    var plusOne = makeAdder( 1 );
    
    // `plusTen` gets a reference to the inner `add(..)`
    // function with closure over the `x` parameter of
    // the outer `makeAdder(..)`
    var plusTen = makeAdder( 10 );
    
    plusOne( 3 );		// 4  <-- 1 + 3
    plusOne( 41 );		// 42 <-- 1 + 41
    
    plusTen( 13 );		// 23 <-- 10 + 13
    ```

More on how this code works:

1. When we call `makeAdder(1)`, we get back a reference to its inner `add(..)` that remembers `x` as `1`. We call this function reference `plusOne(..)`.
2. When we call `makeAdder(10)`, we get back another reference to its inner `add(..)` that remembers `x` as `10`. We call this function reference `plusTen(..)`.
3. When we call `plusOne(3)`, it adds `3` (its inner `y`) to the `1` (remembered by `x`), and we get `4` as the result.
4. When we call `plusTen(13)`, it adds `13` (its inner `y`) to the `10` (remembered by `x`), and we get `23` as the result.
###### Basic Closure 2
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

###### Passing Functions Around Exercises Closure
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
###### Asynchronous Tasks
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
    - Be that timers, event handlers, Ajax requests, cross-window messaging, web workers, or any of the other asynchronous (or synchronous!) tasks, **when you pass in a callback function, get ready to sling some closure around!**
###### For Loop Closure
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
                        - We learned that the IIFE creates scope by declaring a function and immediately executing it
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
                                        - It works!
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

###### Module Closures
The most common usage of closure in JavaScript is the module pattern

- Modules **let you define private implementation details** (*variables*, *functions*) that are hidden from the outside world, as well as a **public API that *is* accessible from the outside**
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

  1. There **must be an outer enclosing function**, and it **must be invoked at least once** (each time creates a new module instance).

  1. The **enclosing function must return back at least one inner function**, so that this inner function has closure over the private scope, and can access and/or modify that private state

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
            console.log( id.toUpperCase() );any of the various ways
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

**Examples**
###### Basic Module Closure
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

- The `User()` function serves as an outer scope that holds the variables `username` and `password`, as well as the inner `doLogin()` function; these are all private inner details of this `User` module that cannot be accessed from the outside world
- Executing `User()` creates an *instance* of the `User` module -- a whole new scope is created, and thus a whole new copy of each of these inner variables/functions
    - We assign this instance to `fred`. If we run `User()` again, we'd get a new instance entirely separate from `fred`'
    - We are not calling `new User()` here, on purpose, despite the fact that probably seems more common to most readers
    - `User()` is just a function, not a class to be instantiated, so it's just called normally. Using `new` would be inappropriate and actually waste resources
- The inner `doLogin()` function has a closure over `username` and `password`, meaning it will retain its access to them even after the `User()` function finishes running
- `publicAPI` is an object with one property/method on it, `login`, which is a reference to the inner `doLogin()` function. When we return `publicAPI` from `User()`, it becomes the instance we call `fred`
- At this point, the outer `User()` function has finished executing
    - Normally, you'd think the inner variables like `username` and `password` have gone away. But here they have not, because there's a closure in the `login()` function keeping them alive
    - That's why we can call `fred.login(..)` -- the same as calling the inner `doLogin(..)` -- and it can still access `username` and `password` inner variables

###### Modern Module Closures
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

# this
- this is a special identifier keyword that's automatically defined in the scope of every function
- While it may often seem that `this` is related to "object-oriented patterns," in JS `this` is a different mechanism
- `this` does **not** refer to
    -  the **function itself**
        - To reference a function object from inside itself, `this` by itself will typically be insufficient
            - You generally need a reference to the function object via a lexical identifier (variable) that points at it
    - the **function's scope**
        - a reference to the **function's *lexical scope***
    - **where** a **function is declared**
- **what this *is***:
    - It is contextual based on the conditions of the function's invocation
    - has everything to do with the manner in which the function is called (*call-site*)
    - If a function has a `this` reference inside it, that `this` reference usually points to an `object`
        - But which `object` it points to **depends on how the function was called**
    - **When a function is invoked**, an activation record, otherwise known as **an *execution context*, is created**
        -  This record contains information about where the function was called from (the call-stack), *how* the function was invoked, what parameters were passed, etc
        - One of the properties of this record is the `this` **reference** which will be *used for the duration of that function's execution*
    - it's a **binding** that is **made when a function is invoked**, and *what* **it references** is **determined entirely by the *call-site* where the function is called**

**Examples**
###### Basic
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
- There are four rules for how `this` gets set, and they're shown in those last four lines of that snippet

    1. `foo()` ends up setting `this` to the global object in non-strict mode -- in strict mode, `this` would be `undefined` and you'd get an error in accessing the `bar` property -- so `"global"` is the value found for `this.bar`
    2. `obj1.foo()` sets `this` to the `obj1` object
    3. `foo.call(obj2)` sets `this` to the `obj2` object
    4. `new foo()` sets `this` to a brand new empty object

Bottom line: to understand what `this` points to, you have to examine how the function in question was called
    - It will be one of those four ways just shown, and that will then answer what `this` is

**Use Cases**
- allow functions to be re-used against multiple *context* (`me` and `you`) objects, rather than needing a separate version of the function for each object
    - Instead of relying on `this`, you could have explicitly passed in a context object to both

# this and Call-site
- To understand `this` binding, we have to understand the **call-*site***: the ***location* in code where a function is *called*** (**not where it's declared**)
- We must inspect the call-site to answer the question: what's *this* `this` a reference to?
    - but it's not always that easy; certain coding patterns can obscure the *true* call-site
- **call-*stack*** is the **stack of functions that have been called to get us to the current moment in execution**
    - The call-site we care about is *in* the invocation *before* the currently executing function
- *how* the call-*site* **determines where `this` will point during the execution of a function**
    - You must **inspect the call-site and determine which of 4 rules applies**
- 4 Rules for inspecting the call-site:

**Default Binding**
- default catch-all rule when none of the other rules apply

**Implicit Binding**
- does the call-site have a *context object***, also referred to as an **owning** or **containing** object

**Implicitly Lost**
- One of the most common frustrations that `this` binding creates is when an ***implicitly bound* function loses that binding**, which usually means **it falls back to the *default binding* of either the global object or `undefined`**, depending on `strict mode`
    ```js
    function foo() {
        console.log( this.a );
    }
    
    var obj = {
        a: 2,
        foo: foo
    };
    
    var bar = obj.foo; // function reference/alias!
    var a = "oops, global"; // `a` also property on global object
    bar(); // "oops, global"
    ```

    - Even though `bar` appears to be a reference to `obj.foo`, in fact, it's really just another reference to `foo` itself
    - Moreover, the call-site is what matters, and the call-site is `bar()`, which is a plain, un-decorated call and thus the *default binding* applies

- The more subtle, more common, and more unexpected way this occurs is when we consider passing a callback function:
    ```js
    function foo() {
        console.log( this.a );
    }

    function doFoo(fn) {
        // `fn` is just another reference to `foo`
        fn(); // <-- call-site!
    }
    
    var obj = {
        a: 2,
        foo: foo
    };
    
    var a = "oops, global"; // `a` also property on global object
    
    doFoo( obj.foo ); // "oops, global"
    ```
    - **Parameter passing** is **just an implicit assignment**, and **since we're passing a function, it's an implicit reference assignment**, so the **end result is the same as the previous snippet**

- **function commonly lose their callbacks *lose* their `this` binding**, as we've just seen
- another way that `this` can surprise us is when the **function we've passed our callback to intentionally changes the `this` for the call**
    - **Event handlers** in popular JavaScript libraries are quite fond of forcing your callback to have a `this` which points to, for instance, the DOM element that triggered the event
        - While that may sometimes be useful, other times it can be downright infuriating. Unfortunately, these tools rarely let you choose
        - Either way the `this` is changed unexpectedly, you are not really in control of how your callback function reference will be executed, so you have no way (yet) of controlling the call-site to give your intended binding
        - We'll see shortly a way of "fixing" that problem by *fixing* the `this`

**Explicit Binding**
- allows us to force its `this` to reference a certain object using the **call()** or **apply** method
    - respect to `this` binding, **`call(..)` and `apply(..)` are identical**
        - they execute a function in the context, or scope, of the first argument that you pass to them

    - They take as their first parameter, an object to use for the `this`, and then invoke the function with that `this` specified
    - In **call()** the subsequent arguments are passed in to the function as they are, while in **apply()** expects the list of values to be an **array** that it unpacks as **arguments** for the called function
        - **function.call(thisArg, arg1, arg2, ...)**

            `say.call(person1, 'Hello');`

            `update.call(person1, 'Slarty', 200, '1xM');`

            ```js
            function Product(name, price) {
              this.name = name;
              this.price = price;
            }
            
            function Food(name, price) {
              Product.call(this, name, price);
              this.category = 'food';
            }
            
            console.log(new Food('cheese', 5).name);
            // expected output: "cheese"
            ```
        - **func.apply(thisArg, [argsArray])**

            `dispatch(person1, say, ['Hello']);`

            `dispatch(person2, update, ['Slarty', 200, '1xM']);`

            `Math.max.apply(null,[1,2,3]);`

            ```js
            var array = ['a', 'b'];
            var elements = [0, 1, 2];
            array.push.apply(array, elements);
            ```

    - so they different in how you seed this call with a set of arguments (how you seed the parameters you want to pass to the function you're calling
    - They *do* behave differently with their additional parameters
        ```js
        function foo() {
              console.log( this.a );
        }
        
        var obj = {
            a: 2
        };
        
        foo.call( obj ); // 2
        ```
        - Invoking `foo` with *explicit binding* by `foo.call(..)` allows us to force its `this` to be `obj`

**Hard Binding**
- using a hard-bound function produced by using the **bind()** method
- **creates a *pass-thru* of any arguments passed** and **any return value received**

**API Call "Contexts"**
- Many libraries' functions, and indeed many new built-in functions in the JavaScript language and host environment, provide an optional parameter, usually called "context", which is designed as a work-around for you not having to use `bind(..)` to ensure your callback function uses a particular `this`
    ```js
    function foo(el) {
        console.log( el, this.id );
    }
    
    var obj = {
        id: "awesome"
    };
    
    // use `obj` as `this` for `foo(..)` calls
    [1, 2, 3].forEach( foo, obj ); // 1 awesome  2 awesome  3 awesome
    ```
    - Internally, these various functions almost certainly use *explicit binding* via `call(..)` or `apply(..)`, saving you the trouble

**`new` Binding**
- The fourth and final rule for `this` binding **requires us to re-think a very common misconception about functions and objects** in JavaScript
    - In traditional class-oriented languages, "constructors" are special methods attached to classes, that when the class is instantiated with a `new` operator, the constructor of that class is called. This usually looks something like:
        ```js
        something = new MyClass(..);
        ```
    - JavaScript has a `new` operator, and the code pattern to use it looks basically identical to what we see in those class-oriented languages;
    - most developers assume that JavaScript's mechanism is doing something similar. However, ***there really is *no connection* to class-oriented functionality implied by `new` usage in JS***
    - let's re-define what a "constructor" in JavaScript is. In JS
        - constructors are **just functions** that happen to be called with the `new` operator in front of them
        - They are not attached to classes, nor are they instantiating a class
        - They are not even special types of functions
        - They're just regular functions that are, in essence, hijacked by the use of `new` in their invocation
        - So, pretty much any function, including the built-in object functions like `Number(..)` can be called with `new` in front of it
        - that makes that function call a *constructor call*
        - This is an important but subtle distinction: there's really no such thing as "constructor functions", but rather construction calls *of* functions
        - When a function is invoked with `new` in front of it, otherwise known as a constructor call, the following things are done automatically:

          1. a brand new object is created (aka, constructed) out of thin air
          2. *the newly constructed object is `[[Prototype]]`-linked*
          3. the newly constructed object is set as the `this` binding for that function call
          4. unless the function returns its own alternate **object**, the `new`-invoked function call will *automatically* return the newly constructed object
              ```js
              function foo(a) {
                  this.a = a;
              }
              
              var bar = new foo( 2 );
              console.log( bar.a ); // 2
              ```
              - By calling `foo(..)` with `new` in front of it, we've constructed a new object and set that new object as the `this` for the call of `foo(..)`
              - **So `new` is the final way that a function call's `this` can be bound
        - **Note:** `**new` and `call`/`apply` cannot be used together**, so `new foo.call(obj1)` is not allowed

##### Order of Precedence for Rules on Binding
- **default binding** is the lowest priority rule of the 4
- **explicit binding** takes precedence over **implicit binding**
    - which means you should ask **first** if *explicit binding* applies before checking for *implicit binding*
- **new binding** is more precedent than **implicit binding**
- **new binding** can override **hard binding**

#### We can summarize the rules for determining `this` from a **function call's call-site**, in their **order of precedence**

**Ask these questions in this order, and stop when the first rule applies**:

1. **Is the function called with `new`** (**new binding**)? If so, `this` is the newly constructed object.

    `var bar = new foo()`

2. **Is the function called with `call` or `apply`** (**explicit binding**), even hidden inside a `bind` *hard binding*? If so, `this` is the explicitly specified object.

    `var bar = foo.call( obj2 )`

3. **Is the function called with a *context*** (**implicit binding**), otherwise known as an owning or containing object? If so, `this` is *that* context object so use that context

    `var bar = obj1.foo()`

4. Otherwise, **default the `this`** (**default binding**). If in `strict mode`, pick `undefined`, otherwise the context object is the `global` object

    `var bar = foo()`

**That's it.** **That's *all it takes* to understand the rules of `this` binding for normal function calls**. Well... almost

# Lexical this with Arrow Functions
Normal functions abide by the 4 rules we just covered. But **ES6 introduces a special kind of function that does not use these rules: *arrow-function***.

- Arrow-functions are signified not by the `function` keyword, but by the `=>` so called "fat arrow" operator
- **Instead of using the four standard `this` rules**, **arrow-functions adopt the `this` binding from its enclosing** (function or global) **scope**

Let's illustrate arrow-function lexical scope:

```js
function foo() {
    // return an arrow function
    return (a) => {
        // `this` here is lexically adopted from `foo()`
        console.log( this.a );
    };
}

var obj1 = {
    a: 2
};

var obj2 = {
    a: 3
};

var bar = foo.call( obj1 );
bar.call( obj2 ); // 2, not 3!
```
- The arrow-function created in `foo()` lexically captures whatever `foo()`s `this` is at its call-time
- Since `foo()` was `this`-bound to `obj1`, `bar` (a reference to the returned arrow-function) will also be `this`-bound to `obj1`
- The lexical binding of an arrow-function cannot be overridden (even with `new`!).

The **most common use-case** will likely be in the **use of callbacks**, such as **event handlers** or **timers**:

```js
function foo() {
    setTimeout(() => {
        // `this` here is lexically adopted from `foo()`
        console.log( this.a );
    },100);
}

var obj = {
    a: 2
};

foo.call( obj ); // 2
```
- While arrow-functions provide an alternative to using `bind(..)` on a function to ensure its `this`, which can seem attractive, it's important to note that they essentially are disabling the traditional `this` mechanism in favor of more widely-understood lexical scoping
- Pre-ES6, we already have a fairly common pattern for doing so, which is basically almost indistinguishable from the spirit of ES6 arrow-functions:

```js
function foo() {
    var self = this; // lexical capture of `this`
    setTimeout( function(){
        console.log( self.a );
    }, 100 );
}

var obj = {
    a: 2
};

foo.call( obj ); // 2
```

-** *While `self = this` and arrow-functions both seem like good "solutions" to not wanting to use `bind(..)`, they are essentially fleeing from `this` instead of understanding and embracing it***
    - If you find yourself writing `this`-style code, but most or all the time, you defeat the `this` mechanism with lexical `self = this` or arrow-function "tricks", perhaps you should either:

1. Use only **lexical scope** and **forget the false pretense of `this`-style code**

2. **Embrace `this`-style mechanisms completely**, **including using `bind(..)` where necessary**, and try to **avoid `self = this` and arrow-function "lexical this" tricks**

A program can effectively use both styles of code (lexical and `this`), but inside of the same function, and indeed for the same sorts of look-ups, mixing the two mechanisms is usually asking for harder-to-maintain code, and probably working too hard to be clever.

# Prototypes
- When you reference a property on an object, if that property doesn't exist, JavaScript will automatically use that object's internal prototype reference to find another object to look for the property on
- **Objects** in JavaScript **have an internal property**, denoted in the specification as `[[Prototype]]`, which is **simply a reference to another object**
    - Almost all objects are given a non-`null` value for this property, at the time of their creation
- the `[[Get]]` operation that is invoked when you reference a property on an object such as `myObject.a`
    - For that default `[[Get]]` operation, the **first step is to check if the object itself has a property `a` on it, and if so, it's used**
    - ***`[[Get]]` operation proceeds to follow the `[[Prototype]]` **link** of the object if it cannot find the requested property on the object directly***`[[Prototype]]` linked to `anotherObject`
    - **This process continues until either a matching property name is found**, *or* **the `[[Prototype]]` chain ends**. **If no matching property is *ever* found by the end of the chain**, the return **result** from the `[[Get]]` operation is **`undefined`**
    - You could think of this almost as a fallback if the property is missing
- the [[Prototype]] mechanism is an internal link that exists on one object which references another object
- This linkage is exercised when a property/method reference is made against the first object, and no such property/method exists. In that case, the [[Prototype]] linkage tells the engine to look for the property/method on the linked-to object. In turn, if that object cannot fulfill the look-up, its [[Prototype]] is followed, and so on. This series of links between objects forms what is called the "prototype chain"
    - **JavaScript, is all about objects being linked to other objects**
- The internal prototype reference linkage from one object to its fallback happens at the time the object is created
    - The simplest way to illustrate it is with a built-in utility called `Object.create(..)`
- if you use a `for..in` loop to iterate over an object, any property that can be reached via its chain (and is also `enumerable` -- see Chapter 3) will be enumerated
- if a property is not found on the prototype chain, it'll add the property to the object.  For example `myObject.a`, if a is not found, it'll add an `a` prop to `myObject`
- a more natural way of applying prototypes is a pattern called "behavior delegation," where you intentionally design your linked objects to be able to *delegate* from one to the other for parts of the needed behavior

But it's **what happens if `a` **isn't** present on `myObject`** that brings our attention now to the **`[[Prototype]]` link** of the **object**

### "Class" Functions

There's a peculiar kind of behavior in JavaScript that has been shamelessly abused for years to *hack* something that *looks* like "classes". We'll examine this approach in detail.

The peculiar "sort-of class" behavior hinges on a strange characteristic of functions: all functions by default get a public, non-enumerable (see Chapter 3) property on them called `prototype`, which points at an otherwise arbitrary object.

```js
function Foo() {
    // ...
}

Foo.prototype; // { }
```

This object is often called "Foo's prototype", because we access it via an unfortunately-named `Foo.prototype` property reference. However, that terminology is hopelessly destined to lead us into confusion, as we'll see shortly. Instead, I will call it "the object formerly known as Foo's prototype". Just kidding. How about: "object arbitrarily labeled 'Foo dot prototype'"?

Whatever we call it, what exactly is this object?

The most direct way to explain it is that each object created from calling `new Foo()` (see Chapter 2) will end up (somewhat arbitrarily) `[[Prototype]]`-linked to this "Foo dot prototype" object.

Let's illustrate:

```js
function Foo() {
    // ...
}

var a = new Foo();

Object.getPrototypeOf( a ) === Foo.prototype; // true
```

When `a` is created by calling `new Foo()`, one of the things (see Chapter 2 for all *four* steps) that happens is that `a` gets an internal `[[Prototype]]` link to the object that `Foo.prototype` is pointing at.

Stop for a moment and ponder the implications of that statement.

In class-oriented languages, multiple **copies** (aka, "instances") of a class can be made, like stamping something out from a mold
- As we saw in Chapter 4, this happens because the process of instantiating (or inheriting from) a class means, "copy the behavior plan from that class into a physical object", and this is done again for each new instance.

But in JavaScript, there are no such copy-actions performed
- You don't create multiple instances of a class. You can create multiple objects that `[[Prototype]]` *link* to a common object
- But by default, no copying occurs, and thus these objects don't end up totally separate and disconnected from each other, but rather, quite ***linked***

**`new Foo()` results in a new object** (we called it `a`), and ****that** new object `a` is internally `[[Prototype]]` linked to the `Foo.prototype` object**

**We end up with two objects, linked to each other.** That's *it*
- We didn't instantiate a class. We certainly didn't do any copying of behavior from a "class" into a concrete object. We just caused two objects to be linked to each other

In fact, the secret, which eludes most JS developers, is that the `new Foo()` function calling had really almost nothing *direct* to do with the process of creating the link
- **It was sort of an accidental side-effect.** `new Foo()` is an indirect, round-about way to end up with what we want: **a new object linked to another object**

Can we get what we want in a more *direct* way? **Yes!** The hero is `Object.create(..)`. But we'll get to that in a little bit

**Examples**
###### Basic Example 1
```js
var anotherObject = {
    a: 2
};

// create an object linked to `anotherObject`
var myObject = Object.create( anotherObject );

myObject.a; // 2
```
- **`myObject` is now `[[Prototype]]` linked to `anotherObject`**
    - Clearly `myObject.a` doesn't actually exist, but nevertheless, the property access succeeds (being found on `anotherObject` instead) and indeed finds the value `2`
    - But, if `a` weren't found on `anotherObject` either, its `[[Prototype]]` chain, if non-empty, is again consulted and followed

###### Basic Example 2
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
- The `a` property doesn't actually exist on the `bar` object, but because `bar` is prototype-linked to `foo`, JavaScript automatically falls back to looking for `a` on the `foo` object, where it's found

###### Loops
```js
var anotherObject = {
    a: 2
};

// create an object linked to `anotherObject`
var myObject = Object.create( anotherObject );

for (var k in myObject) {
    console.log("found: " + k);
}
// found: a

("a" in myObject); // true
```
- So, **the `[[Prototype]]` chain is consulted, one link at a time, when you perform property look-ups in various fashions**. The **look-up stops once the property is found or the chain ends**

# Using Object.create instead of Prototypes

We've thoroughly debunked why JavaScript's `[[Prototype]]` mechanism is **not** like *classes*, and we've seen how it instead creates **links** between proper objects.

What's the point of the `[[Prototype]]` mechanism? Why is it so common for JS developers to go to so much effort (emulating classes) in their code to wire up these linkages?

Remember we said much earlier in this chapter that `Object.create(..)` would be a hero? Now, we're ready to see how.

```js
var foo = {
    something: function() {
        console.log( "Tell me something good..." );
    }
};

var bar = Object.create( foo );

bar.something(); // Tell me something good...
```

`Object.create(..)` creates a new object (`bar`) linked to the object we specified (`foo`), which gives us all the power (delegation) of the `[[Prototype]]` mechanism, but without any of the unnecessary complication of `new` functions acting as classes and constructor calls, confusing `.prototype` and `.constructor` references, or any of that extra stuff.

**Note:** `Object.create(null)` creates an object that has an empty (aka, `null`) `[[Prototype]]` linkage, and thus the object can't delegate anywhere
- Since such an object has no prototype chain, the `instanceof` operator (explained earlier) has nothing to check, so it will always return `false`
- These special empty-`[[Prototype]]` objects are often called "dictionaries" as they are typically used purely for storing data in properties, mostly because they have no possible surprise effects from any delegated properties/functions on the `[[Prototype]]` chain, and are thus purely flat data storage.

We don't *need* classes to create meaningful relationships between two objects
- The only thing we should **really care about** is objects linked together for delegation, and `Object.create(..)` gives us that linkage without all the class cruft.

#### `Object.create()` Polyfilled

`Object.create(..)` was added in ES5. You may need to support pre-ES5 environments (like older IE's), so let's take a look at a simple **partial** polyfill for `Object.create(..)` that gives us the capability that we need even in those older JS environments:

```js
if (!Object.create) {
    Object.create = function(o) {
        function F(){}
        F.prototype = o;
        return new F();
    };
}
```

This polyfill works by using a throw-away `F` function and overriding its `.prototype` property to point to the object we want to link to
- Then we use `new F()` construction to make a new object that will be linked as we specified.

This usage of `Object.create(..)` is by far the most common usage, because it's the part that *can be* polyfilled
- There's an additional set of functionality that the standard ES5 built-in `Object.create(..)` provides, which is **not polyfillable** for pre-ES5
- As such, this capability is far-less commonly used. For completeness sake, let's look at that additional functionality:

```js
var anotherObject = {
    a: 2
};

var myObject = Object.create( anotherObject, {
    b: {
        enumerable: false,
        writable: true,
        configurable: false,
        value: 3
    },
    c: {
        enumerable: true,
        writable: false,
        configurable: false,
        value: 4
    }
} );

myObject.hasOwnProperty( "a" ); // false
myObject.hasOwnProperty( "b" ); // true
myObject.hasOwnProperty( "c" ); // true

myObject.a; // 2
myObject.b; // 3
myObject.c; // 4
```

The second argument to `Object.create(..)` specifies property names to add to the newly created object, via declaring each new property's *property descriptor* (see Chapter 3)
- Because polyfilling property descriptors into pre-ES5 is not possible, this additional functionality on `Object.create(..)` also cannot be polyfilled

The vast majority of usage of `Object.create(..)` uses the polyfill-safe subset of functionality, so most developers are fine with using the **partial polyfill** in pre-ES5 environments.

Some developers take a much stricter view, which is that no function should be polyfilled unless it can be *fully* polyfilled
- Since `Object.create(..)` is one of those partial-polyfill'able utilities, this narrower perspective says that if you need to use any of the functionality of `Object.create(..)` in a pre-ES5 environment, instead of polyfilling, you should use a custom utility, and stay away from using the name `Object.create` entirely
- You could instead define your own utility, like:

```js
function createAndLinkObject(o) {
    function F(){}
    F.prototype = o;
    return new F();
}

var anotherObject = {
    a: 2
};

var myObject = createAndLinkObject( anotherObject );

myObject.a; // 2
```

I do not share this strict opinion
- I fully endorse the common partial-polyfill of `Object.create(..)` as shown above, and using it in your code even in pre-ES5. I'll leave it to you to make your own decision

### Links As Fallbacks?

It may be tempting to think that these links between objects *primarily* provide a sort of fallback for "missing" properties or methods
- While that may be an observed outcome, I don't think it represents the right way of thinking about `[[Prototype]]`

Consider:

```js
var anotherObject = {
    cool: function() {
        console.log( "cool!" );
    }
};

var myObject = Object.create( anotherObject );

myObject.cool(); // "cool!"
```

That code will work by virtue of `[[Prototype]]`, but if you wrote it that way so that `anotherObject` was acting as a fallback **just in case** `myObject` couldn't handle some property/method that some developer may try to call, odds are that your software is going to be a bit more "magical" and harder to understand and maintain.

That's not to say there aren't cases where fallbacks are an appropriate design pattern, but it's not very common or idiomatic in JS, so if you find yourself doing so, you might want to take a step back and reconsider if that's really appropriate and sensible design.

**Note:** In ES6, an advanced functionality called `Proxy` is introduced which can provide something of a "method not found" type of behavior. `Proxy` is beyond the scope of this book, but will be covered in detail in a later book in the *"You Don't Know JS"* series.

**Don't miss an important but nuanced point here.**

Designing software where you intend for a developer to, for instance, call `myObject.cool()` and have that work even though there is no `cool()` method on `myObject` introduces some "magic" into your API design that can be surprising for future developers who maintain your software.

You can however design your API with less "magic" to it, but still take advantage of the power of `[[Prototype]]` linkage.

```js
var anotherObject = {
    cool: function() {
        console.log( "cool!" );
    }
};

var myObject = Object.create( anotherObject );

myObject.doCool = function() {
    this.cool(); // internal delegation!
};

myObject.doCool(); // "cool!"
```

Here, we call `myObject.doCool()`, which is a method that *actually exists* on `myObject`, making our API design more explicit (less "magical"). *Internally*, our implementation follows the **delegation design pattern** (see Chapter 6), taking advantage of `[[Prototype]]` delegation to `anotherObject.cool()`.

In other words, delegation will tend to be less surprising/confusing if it's an internal implementation detail rather than plainly exposed in your API design. We will expound on **delegation** in great detail in the next chapter.


# Polyfilling

- The word "polyfill" is an invented term (by Remy Sharp) (https://remysharp.com/2010/10/08/what-is-a-polyfill) used to refer to taking the definition of a newer feature and producing a piece of code that's equivalent to the behavior, but is able to run in older JS environments

# Asynchrony: Now & Later

The simplest (but definitely not only, or necessarily even best!) way of "waiting" from *now* until *later* is to use a function, commonly called a callback function:

```js
// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", function myCallbackFunction(data){
    console.log( data ); // Yay, I gots me some `data`!
} );
```

**Warning:** You may have heard that it's possible to make synchronous Ajax requests. While that's technically true, you should never, ever do it, under any circumstances, because it locks the browser UI (buttons, menus, scrolling, etc.) and prevents any user interaction whatsoever. This is a terrible idea, and should always be avoided.

Before you protest in disagreement, no, your desire to avoid the mess of callbacks is *not* justification for blocking, synchronous Ajax.

For example, consider this code:

```js
function now() {
    return 21;
}

function later() {
    answer = answer * 2;
    console.log( "Meaning of life:", answer );
}

var answer = now();

setTimeout( later, 1000 ); // Meaning of life: 42
```

There are two chunks to this program: the stuff that will run *now*, and the stuff that will run *later*
- It should be fairly obvious what those two chunks are, but let's be super explicit:

Now:
```js
function now() {
    return 21;
}

function later() { .. }

var answer = now();

setTimeout( later, 1000 );
```

Later:
```js
answer = answer * 2;
console.log( "Meaning of life:", answer );
```

The *now* chunk runs right away, as soon as you execute your program. But `setTimeout(..)` also sets up an event (a timeout) to happen *later*, so the contents of the `later()` function will be executed at a later time (1,000 milliseconds from now).

Any time you wrap a portion of code into a `function` and specify that it should be executed in response to some event (timer, mouse click, Ajax response, etc.), you are creating a *later* chunk of your code, and thus introducing asynchrony to your program.

### Async Console

There is no specification or set of requirements around how the `console.*` methods work -- they are not officially part of JavaScript, but are instead added to JS by the *hosting environment* (see the *Types & Grammar* title of this book series).

So, different browsers and JS environments do as they please, which can sometimes lead to confusing behavior.

In particular, there are some browsers and some conditions that `console.log(..)` does not actually immediately output what it's given
- The main reason this may happen is because I/O is a very slow and blocking part of many programs (not just JS)
- So, it may perform better (from the page/UI perspective) for a browser to handle `console` I/O asynchronously in the background, without you perhaps even knowing that occurred

A not terribly common, but possible, scenario where this could be *observable* (not from code itself but from the outside):

```js
var a = {
    index: 1
};

// later
console.log( a ); // ??

// even later
a.index++;
```

We'd normally expect to see the `a` object be snapshotted at the exact moment of the `console.log(..)` statement, printing something like `{ index: 1 }`, such that in the next statement when `a.index++` happens, it's modifying something different than, or just strictly after, the output of `a`.

Most of the time, the preceding code will probably produce an object representation in your developer tools' console that's what you'd expect
- But it's possible this same code could run in a situation where the browser felt it needed to defer the console I/O to the background, in which case it's *possible* that by the time the object is represented in the browser console, the `a.index++` has already happened, and it shows `{ index: 2 }`

It's a moving target under what conditions exactly `console` I/O will be deferred, or even whether it will be observable
- Just be aware of this possible asynchronicity in I/O in case you ever run into issues in debugging where objects have been modified *after* a `console.log(..)` statement and yet you see the unexpected modifications show up

## Event Loop

Let's make a (perhaps shocking) claim: despite clearly allowing asynchronous JS code (like the timeout we just looked at), up until recently (ES6), JavaScript itself has actually never had any direct notion of asynchrony built into it.

**What!?** That seems like a crazy claim, right? In fact, it's quite true
- The JS engine itself has never done anything more than execute a single chunk of your program at any given moment, when asked to

"Asked to." By whom? That's the important part!

The JS engine doesn't run in isolation. It runs inside a *hosting environment*, which is for most developers the typical web browser
- Over the last several years (but by no means exclusively), JS has expanded beyond the browser into other environments, such as servers, via things like Node.js
- In fact, JavaScript gets embedded into all kinds of devices these days, from robots to lightbulbs

But the one common "thread" (that's a not-so-subtle asynchronous joke, for what it's worth) of all these environments is that they have a mechanism in them that handles executing multiple chunks of your program *over time*, at each moment invoking the JS engine, called the "event loop."

In other words, the JS engine has had no innate sense of *time*, but has instead been an on-demand execution environment for any arbitrary snippet of JS
- It's the surrounding environment that has always *scheduled* "events" (JS code executions)

So, for example, when your JS program makes an Ajax request to fetch some data from a server, you set up the "response" code in a function (commonly called a "callback"), and the JS engine tells the hosting environment, "Hey, I'm going to suspend execution for now, but whenever you finish with that network request, and you have some data, please *call* this function *back*."

The browser is then set up to listen for the response from the network, and when it has something to give you, it schedules the callback function to be executed by inserting it into the *event loop*.

So what is the *event loop*?

Let's conceptualize it first through some fake-ish code:

```js
// `eventLoop` is an array that acts as a queue (first-in, first-out)
var eventLoop = [ ];
var event;

// keep going "forever"
while (true) {
    // perform a "tick"
    if (eventLoop.length > 0) {
        // get the next event in the queue
        event = eventLoop.shift();

        // now, execute the next event
        try {
            event();
        }
        catch (err) {
            reportError(err);
        }
    }
}
```

This is, of course, vastly simplified pseudocode to illustrate the concepts
- But it should be enough to help get a better understanding

As you can see, there's a continuously running loop represented by the `while` loop, and each iteration of this loop is called a "tick."
- For each tick, if an event is waiting on the queue, it's taken off and executed. These events are your function callbacks

It's important to note that `setTimeout(..)` doesn't put your callback on the event loop queue
- What it does is set up a timer; when the timer expires, the environment places your callback into the event loop, such that some future tick will pick it up and execute it

What if there are already 20 items in the event loop at that moment? Your callback waits
- It gets in line behind the others -- there's not normally a path for preempting the queue and skipping ahead in line
- This explains why `setTimeout(..)` timers may not fire with perfect temporal accuracy
- You're guaranteed (roughly speaking) that your callback won't fire *before* the time interval you specify, but it can happen at or after that time, depending on the state of the event queue

So, in other words, your program is generally broken up into lots of small chunks, which happen one after the other in the event loop queue. And technically, other events not related directly to your program can be interleaved within the queue as well.

**Note:** We mentioned "up until recently" in relation to ES6 changing the nature of where the event loop queue is managed
- It's mostly a formal technicality, but ES6 now specifies how the event loop works, which means technically it's within the purview of the JS engine, rather than just the *hosting environment*
- One main reason for this change is the introduction of ES6 Promises, which we'll discuss in Chapter 3, because they require the ability to have direct, fine-grained control over scheduling operations on the event loop queue (see the discussion of `setTimeout(..0)` in the "Cooperation" section)

## Parallel Threading

It's very common to conflate the terms "async" and "parallel," but they are actually quite different. Remember, async is about the gap between *now* and *later*
- But parallel is about things being able to occur simultaneously

The most common tools for parallel computing are processes and threads
- Processes and threads execute independently and may execute simultaneously: on separate processors, or even separate computers, but multiple threads can share the memory of a single process

An event loop, by contrast, breaks its work into tasks and executes them in serial, disallowing parallel access and changes to shared memory
- Parallelism and "serialism" can coexist in the form of cooperating event loops in separate threads

The interleaving of parallel threads of execution and the interleaving of asynchronous events occur at very different levels of granularity.

For example:

```js
function later() {
    answer = answer * 2;
    console.log( "Meaning of life:", answer );
}
```

While the entire contents of `later()` would be regarded as a single event loop queue entry, when thinking about a thread this code would run on, there's actually perhaps a dozen different low-level operations
- For example, `answer = answer * 2` requires first loading the current value of `answer`, then putting `2` somewhere, then performing the multiplication, then taking the result and storing it back into `answer`

In a single-threaded environment, it really doesn't matter that the items in the thread queue are low-level operations, because nothing can interrupt the thread
- But if you have a parallel system, where two different threads are operating in the same program, you could very likely have unpredictable behavior

Consider:

```js
var a = 20;

function foo() {
    a = a + 1;
}

function bar() {
    a = a * 2;
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", foo );
ajax( "http://some.url.2", bar );
```

In JavaScript's single-threaded behavior, if `foo()` runs before `bar()`, the result is that `a` has `42`, but if `bar()` runs before `foo()` the result in `a` will be `41`.

If JS events sharing the same data executed in parallel, though, the problems would be much more subtle
- Consider these two lists of pseudocode tasks as the threads that could respectively run the code in `foo()` and `bar()`, and consider what happens if they are running at exactly the same time:

Thread 1 (`X` and `Y` are temporary memory locations):
```
foo():
  a. load value of `a` in `X`
  b. store `1` in `Y`
  c. add `X` and `Y`, store result in `X`
  d. store value of `X` in `a`
```

Thread 2 (`X` and `Y` are temporary memory locations):
```
bar():
  a. load value of `a` in `X`
  b. store `2` in `Y`
  c. multiply `X` and `Y`, store result in `X`
  d. store value of `X` in `a`
```

Now, let's say that the two threads are running truly in parallel. You can probably spot the problem, right?
- They use shared memory locations `X` and `Y` for their temporary steps

What's the end result in `a` if the steps happen like this?

```
1a  (load value of `a` in `X`   ==> `20`)
2a  (load value of `a` in `X`   ==> `20`)
1b  (store `1` in `Y`   ==> `1`)
2b  (store `2` in `Y`   ==> `2`)
1c  (add `X` and `Y`, store result in `X`   ==> `22`)
1d  (store value of `X` in `a`   ==> `22`)
2c  (multiply `X` and `Y`, store result in `X`   ==> `44`)
2d  (store value of `X` in `a`   ==> `44`)
```

The result in `a` will be `44`. But what about this ordering?

```
1a  (load value of `a` in `X`   ==> `20`)
2a  (load value of `a` in `X`   ==> `20`)
2b  (store `2` in `Y`   ==> `2`)
1b  (store `1` in `Y`   ==> `1`)
2c  (multiply `X` and `Y`, store result in `X`   ==> `20`)
1c  (add `X` and `Y`, store result in `X`   ==> `21`)
1d  (store value of `X` in `a`   ==> `21`)
2d  (store value of `X` in `a`   ==> `21`)
```

The result in `a` will be `21`.

So, threaded programming is very tricky, because if you don't take special steps to prevent this kind of interruption/interleaving from happening, you can get very surprising, nondeterministic behavior that frequently leads to headaches.

JavaScript never shares data across threads, which means *that* level of nondeterminism isn't a concern
- But that doesn't mean JS is always deterministic. Remember earlier, where the relative ordering of `foo()` and `bar()` produces two different results (`41` or `42`)?

**Note:** It may not be obvious yet, but not all nondeterminism is bad
- Sometimes it's irrelevant, and sometimes it's intentional. We'll see more examples of that throughout this and the next few chapters

### Run-to-Completion

Because of JavaScript's single-threading, the code inside of `foo()` (and `bar()`) is atomic, which means that once `foo()` starts running, the entirety of its code will finish before any of the code in `bar()` can run, or vice versa
- This is called "run-to-completion" behavior

In fact, the run-to-completion semantics are more obvious when `foo()` and `bar()` have more code in them, such as:

```js
var a = 1;
var b = 2;

function foo() {
    a++;
    b = b * a;
    a = b + 3;
}

function bar() {
    b--;
    a = 8 + b;
    b = a * 2;
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", foo );
ajax( "http://some.url.2", bar );
```

Because `foo()` can't be interrupted by `bar()`, and `bar()` can't be interrupted by `foo()`, this program only has two possible outcomes depending on which starts running first -- if threading were present, and the individual statements in `foo()` and `bar()` could be interleaved, the number of possible outcomes would be greatly increased!

Chunk 1 is synchronous (happens *now*), but chunks 2 and 3 are asynchronous (happen *later*), which means their execution will be separated by a gap of time.

Chunk 1:
```js
var a = 1;
var b = 2;
```

Chunk 2 (`foo()`):
```js
a++;
b = b * a;
a = b + 3;
```

Chunk 3 (`bar()`):
```js
b--;
a = 8 + b;
b = a * 2;
```

Chunks 2 and 3 may happen in either-first order, so there are two possible outcomes for this program, as illustrated here:

Outcome 1:
```js
var a = 1;
var b = 2;

// foo()
a++;
b = b * a;
a = b + 3;

// bar()
b--;
a = 8 + b;
b = a * 2;

a; // 11
b; // 22
```

Outcome 2:
```js
var a = 1;
var b = 2;

// bar()
b--;
a = 8 + b;
b = a * 2;

// foo()
a++;
b = b * a;
a = b + 3;

a; // 183
b; // 180
```

Two outcomes from the same code means we still have nondeterminism!
- But it's at the function (event) ordering level, rather than at the statement ordering level (or, in fact, the expression operation ordering level) as it is with threads. In other words, it's *more deterministic* than threads would have been

As applied to JavaScript's behavior, this function-ordering nondeterminism is the common term "race condition," as `foo()` and `bar()` are racing against each other to see which runs first
- Specifically, it's a "race condition" because you cannot predict reliably how `a` and `b` will turn out

**Note:** If there was a function in JS that somehow did not have run-to-completion behavior, we could have many more possible outcomes, right? It turns out ES6 introduces just such a thing (see Chapter 4 "Generators"), but don't worry right now, we'll come back to that!

## Concurrency

Let's imagine a site that displays a list of status updates (like a social network news feed) that progressively loads as the user scrolls down the list
- To make such a feature work correctly, (at least) two separate "processes" will need to be executing *simultaneously* (i.e., during the same window of time, but not necessarily at the same instant)

**Note:** We're using "process" in quotes here because they aren't true operating system–level processes in the computer science sense. They're virtual processes, or tasks, that represent a logically connected, sequential series of operations
- We'll simply prefer "process" over "task" because terminology-wise, it will match the definitions of the concepts we're exploring

The first "process" will respond to `onscroll` events (making Ajax requests for new content) as they fire when the user has scrolled the page further down. The second "process" will receive Ajax responses back (to render content onto the page).

Obviously, if a user scrolls fast enough, you may see two or more `onscroll` events fired during the time it takes to get the first response back and process, and thus you're going to have `onscroll` events and Ajax response events firing rapidly, interleaved with each other.

Concurrency is when two or more "processes" are executing simultaneously over the same period, regardless of whether their individual constituent operations happen *in parallel* (at the same instant on separate processors or cores) or not
- You can think of concurrency then as "process"-level (or task-level) parallelism, as opposed to operation-level parallelism (separate-processor threads)

**Note:** Concurrency also introduces an optional notion of these "processes" interacting with each other. We'll come back to that later.

For a given window of time (a few seconds worth of a user scrolling), let's visualize each independent "process" as a series of events/operations:

"Process" 1 (`onscroll` events):
```
onscroll, request 1
onscroll, request 2
onscroll, request 3
onscroll, request 4
onscroll, request 5
onscroll, request 6
onscroll, request 7
```

"Process" 2 (Ajax response events):
```
response 1
response 2
response 3
response 4
response 5
response 6
response 7
```

It's quite possible that an `onscroll` event and an Ajax response event could be ready to be processed at exactly the same *moment*. For example, let's visualize these events in a timeline:

```
onscroll, request 1
onscroll, request 2          response 1
onscroll, request 3          response 2
response 3
onscroll, request 4
onscroll, request 5
onscroll, request 6          response 4
onscroll, request 7
response 6
response 5
response 7
```

But, going back to our notion of the event loop from earlier in the chapter, JS is only going to be able to handle one event at a time, so either `onscroll, request 2` is going to happen first or `response 1` is going to happen first, but they cannot happen at literally the same moment
- Just like kids at a school cafeteria, no matter what crowd they form outside the doors, they'll have to merge into a single line to get their lunch!

Let's visualize the interleaving of all these events onto the event loop queue.

Event Loop Queue:
```
onscroll, request 1   <--- Process 1 starts
onscroll, request 2
response 1            <--- Process 2 starts
onscroll, request 3
response 2
response 3
onscroll, request 4
onscroll, request 5
onscroll, request 6
response 4
onscroll, request 7   <--- Process 1 finishes
response 6
response 5
response 7            <--- Process 2 finishes
```

"Process 1" and "Process 2" run concurrently (task-level parallel), but their individual events run sequentially on the event loop queue.

By the way, notice how `response 6` and `response 5` came back out of expected order?

The single-threaded event loop is one expression of concurrency (there are certainly others, which we'll come back to later).

### Noninteracting

As two or more "processes" are interleaving their steps/events concurrently within the same program, they don't necessarily need to interact with each other if the tasks are unrelated. **If they don't interact, nondeterminism is perfectly acceptable.**

For example:

```js
var res = {};

function foo(results) {
    res.foo = results;
}

function bar(results) {
    res.bar = results;
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", foo );
ajax( "http://some.url.2", bar );
```

`foo()` and `bar()` are two concurrent "processes," and it's nondeterminate which order they will be fired in
- But we've constructed the program so it doesn't matter what order they fire in, because they act independently and as such don't need to interact

This is not a "race condition" bug, as the code will always work correctly, regardless of the ordering.

### Interaction

More commonly, concurrent "processes" will by necessity interact, indirectly through scope and/or the DOM. When such interaction will occur, you need to coordinate these interactions to prevent "race conditions," as described earlier.

Here's a simple example of two concurrent "processes" that interact because of implied ordering, which is only *sometimes broken*:

```js
var res = [];

function response(data) {
    res.push( data );
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", response );
ajax( "http://some.url.2", response );
```

The concurrent "processes" are the two `response()` calls that will be made to handle the Ajax responses. They can happen in either-first order.

Let's assume the expected behavior is that `res[0]` has the results of the `"http://some.url.1"` call, and `res[1]` has the results of the `"http://some.url.2"` call
- Sometimes that will be the case, but sometimes they'll be flipped, depending on which call finishes first. There's a pretty good likelihood that this nondeterminism is a "race condition" bug

**Note:** Be extremely wary of assumptions you might tend to make in these situations. For example, it's not uncommon for a developer to observe that `"http://some.url.2"` is "always" much slower to respond than `"http://some.url.1"`, perhaps by virtue of what tasks they're doing (e.g., one performing a database task and the other just fetching a static file), so the observed ordering seems to always be as expected
- Even if both requests go to the same server, and *it* intentionally responds in a certain order, there's no *real* guarantee of what order the responses will arrive back in the browser

So, to address such a race condition, you can coordinate ordering interaction:

```js
var res = [];

function response(data) {
    if (data.url == "http://some.url.1") {
        res[0] = data;
    }
    else if (data.url == "http://some.url.2") {
        res[1] = data;
    }
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", response );
ajax( "http://some.url.2", response );
```

Regardless of which Ajax response comes back first, we inspect the `data.url` (assuming one is returned from the server, of course!) to figure out which position the response data should occupy in the `res` array. `res[0]` will always hold the `"http://some.url.1"` results and `res[1]` will always hold the `"http://some.url.2"` results
 - Through simple coordination, we eliminated the "race condition" nondeterminism

The same reasoning from this scenario would apply if multiple concurrent function calls were interacting with each other through the shared DOM, like one updating the contents of a `<div>` and the other updating the style or attributes of the `<div>` (e.g., to make the DOM element visible once it has content)
- You probably wouldn't want to show the DOM element before it had content, so the coordination must ensure proper ordering interaction

Some concurrency scenarios are *always broken* (not just *sometimes*) without coordinated interaction. Consider:

```js
var a, b;

function foo(x) {
    a = x * 2;
    baz();
}

function bar(y) {
    b = y * 2;
    baz();
}

function baz() {
    console.log(a + b);
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", foo );
ajax( "http://some.url.2", bar );
```

In this example, whether `foo()` or `bar()` fires first, it will always cause `baz()` to run too early (either `a` or `b` will still be `undefined`), but the second invocation of `baz()` will work, as both `a` and `b` will be available.

There are different ways to address such a condition. Here's one simple way:

```js
var a, b;

function foo(x) {
    a = x * 2;
    if (a && b) {
        baz();
    }
}

function bar(y) {
    b = y * 2;
    if (a && b) {
        baz();
    }
}

function baz() {
    console.log( a + b );
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", foo );
ajax( "http://some.url.2", bar );
```

The `if (a && b)` conditional around the `baz()` call is traditionally called a "gate," because we're not sure what order `a` and `b` will arrive, but we wait for both of them to get there before we proceed to open the gate (call `baz()`).

Another concurrency interaction condition you may run into is sometimes called a "race," but more correctly called a "latch." It's characterized by "only the first one wins" behavior
- Here, nondeterminism is acceptable, in that you are explicitly saying it's OK for the "race" to the finish line to have only one winner

Consider this broken code:

```js
var a;

function foo(x) {
    a = x * 2;
    baz();
}

function bar(x) {
    a = x / 2;
    baz();
}

function baz() {
    console.log( a );
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", foo );
ajax( "http://some.url.2", bar );
```

Whichever one (`foo()` or `bar()`) fires last will not only overwrite the assigned `a` value from the other, but it will also duplicate the call to `baz()` (likely undesired).

So, we can coordinate the interaction with a simple latch, to let only the first one through:

```js
var a;

function foo(x) {
    if (a == undefined) {
        a = x * 2;
        baz();
    }
}

function bar(x) {
    if (a == undefined) {
        a = x / 2;
        baz();
    }
}

function baz() {
    console.log( a );
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", foo );
ajax( "http://some.url.2", bar );
```

The `if (a == undefined)` conditional allows only the first of `foo()` or `bar()` through, and the second (and indeed any subsequent) calls would just be ignored. There's just no virtue in coming in second place!

**Note:** In all these scenarios, we've been using global variables for simplistic illustration purposes, but there's nothing about our reasoning here that requires it
- As long as the functions in question can access the variables (via scope), they'll work as intended
- Relying on lexically scoped variables (see the *Scope & Closures* title of this book series), and in fact global variables as in these examples, is one obvious downside to these forms of concurrency coordination
- As we go through the next few chapters, we'll see other ways of coordination that are much cleaner in that respect

### Cooperation

Another expression of concurrency coordination is called "cooperative concurrency"
- Here, the focus isn't so much on interacting via value sharing in scopes (though that's obviously still allowed!)
- The goal is to take a long-running "process" and break it up into steps or batches so that other concurrent "processes" have a chance to interleave their operations into the event loop queue

For example, consider an Ajax response handler that needs to run through a long list of results to transform the values
- We'll use `Array#map(..)` to keep the code shorter:

```js
var res = [];

// `response(..)` receives array of results from the Ajax call
function response(data) {
    // add onto existing `res` array
    res = res.concat(
        // make a new transformed array with all `data` values doubled
        data.map( function(val){
            return val * 2;
        } )
    );
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", response );
ajax( "http://some.url.2", response );
```

If `"http://some.url.1"` gets its results back first, the entire list will be mapped into `res` all at once
- If it's a few thousand or less records, this is not generally a big deal. But if it's say 10 million records, that can take a while to run (several seconds on a powerful laptop, much longer on a mobile device, etc.)

While such a "process" is running, nothing else in the page can happen, including no other `response(..)` calls, no UI updates, not even user events like scrolling, typing, button clicking, and the like. That's pretty painful.

So, to make a more cooperatively concurrent system, one that's friendlier and doesn't hog the event loop queue, you can process these results in asynchronous batches, after each one "yielding" back to the event loop to let other waiting events happen.

Here's a very simple approach:

```js
var res = [];

// `response(..)` receives array of results from the Ajax call
function response(data) {
    // let's just do 1000 at a time
    var chunk = data.splice( 0, 1000 );

    // add onto existing `res` array
    res = res.concat(
        // make a new transformed array with all `chunk` values doubled
        chunk.map( function(val){
            return val * 2;
        } )
    );

    // anything left to process?
    if (data.length > 0) {
        // async schedule next batch
        setTimeout( function(){
            response( data );
        }, 0 );
    }
}

// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", response );
ajax( "http://some.url.2", response );
```

We process the data set in maximum-sized chunks of 1,000 items. By doing so, we ensure a short-running "process," even if that means many more subsequent "processes," as the interleaving onto the event loop queue will give us a much more responsive (performant) site/app.

Of course, we're not interaction-coordinating the ordering of any of these "processes," so the order of results in `res` won't be predictable
- If ordering was required, you'd need to use interaction techniques like those we discussed earlier, or ones we will cover in later chapters of this book

We use the `setTimeout(..0)` (hack) for async scheduling, which basically just means "stick this function at the end of the current event loop queue."

**Note:** `setTimeout(..0)` is not technically inserting an item directly onto the event loop queue
- The timer will insert the event at its next opportunity
- For example, two subsequent `setTimeout(..0)` calls would not be strictly guaranteed to be processed in call order, so it *is* possible to see various conditions like timer drift where the ordering of such events isn't predictable
- In Node.js, a similar approach is `process.nextTick(..)`
- Despite how convenient (and usually more performant) it would be, there's not a single direct way (at least yet) across all environments to ensure async event ordering
- We cover this topic in more detail in the next section

## Jobs

As of ES6, there's a new concept layered on top of the event loop queue, called the "Job queue"
- - The most likely exposure you'll have to it is with the asynchronous behavior of Promises (see Chapter 3)

Unfortunately, at the moment it's a mechanism without an exposed API, and thus demonstrating it is a bit more convoluted
- So we're going to have to just describe it conceptually, such that when we discuss async behavior with Promises in Chapter 3, you'll understand how those actions are being scheduled and processed

So, the best way to think about this that I've found is that the "Job queue" is a queue hanging off the end of every tick in the event loop queue
- Certain async-implied actions that may occur during a tick of the event loop will not cause a whole new event to be added to the event loop queue, but will instead add an item (aka Job) to the end of the current tick's Job queue

It's kinda like saying, "oh, here's this other thing I need to do *later*, but make sure it happens right away before anything else can happen."

Or, to use a metaphor: the event loop queue is like an amusement park ride, where once you finish the ride, you have to go to the back of the line to ride again. But the Job queue is like finishing the ride, but then cutting in line and getting right back on.

A Job can also cause more Jobs to be added to the end of the same queue. So, it's theoretically possible that a Job "loop" (a Job that keeps adding another Job, etc.) could spin indefinitely, thus starving the program of the ability to move on to the next event loop tick
- This would conceptually be almost the same as just expressing a long-running or infinite loop (like `while (true) ..`) in your code

Jobs are kind of like the spirit of the `setTimeout(..0)` hack, but implemented in such a way as to have a much more well-defined and guaranteed ordering: **later, but as soon as possible**.

Let's imagine an API for scheduling Jobs (directly, without hacks), and call it `schedule(..)`. Consider:

```js
console.log( "A" );

setTimeout( function(){
    console.log( "B" );
}, 0 );

// theoretical "Job API"
schedule( function(){
    console.log( "C" );

    schedule( function(){
        console.log( "D" );
    } );
} );
```

You might expect this to print out `A B C D`, but instead it would print out `A C D B`, because the Jobs happen at the end of the current event loop tick, and the timer fires to schedule for the *next* event loop tick (if available!).

In Chapter 3, we'll see that the asynchronous behavior of Promises is based on Jobs, so it's important to keep clear how that relates to event loop behavior.

## Statement Ordering

The order in which we express statements in our code is not necessarily the same order as the JS engine will execute them
- That may seem like quite a strange assertion to make, so we'll just briefly explore it

But before we do, we should be crystal clear on something: the rules/grammar of the language (see the *Types & Grammar* title of this book series) dictate a very predictable and reliable behavior for statement ordering from the program point of view
- So what we're about to discuss are **not things you should ever be able to observe** in your JS program

**Warning:** If you are ever able to *observe* compiler statement reordering like we're about to illustrate, that'd be a clear violation of the specification, and it would unquestionably be due to a bug in the JS engine in question -- one which should promptly be reported and fixed!
- But it's vastly more common that you *suspect* something crazy is happening in the JS engine, when in fact it's just a bug (probably a "race condition"!) in your own code -- so look there first, and again and again
- The JS debugger, using breakpoints and stepping through code line by line, will be your most powerful tool for sniffing out such bugs in *your code*

Consider:

```js
var a, b;

a = 10;
b = 30;

a = a + 1;
b = b + 1;

console.log( a + b ); // 42
```

This code has no expressed asynchrony to it (other than the rare `console` async I/O discussed earlier!), so the most likely assumption is that it would process line by line in top-down fashion.

But it's *possible* that the JS engine, after compiling this code (yes, JS is compiled -- see the *Scope & Closures* title of this book series!) might find opportunities to run your code faster by rearranging (safely) the order of these statements
- Essentially, as long as you can't observe the reordering, anything's fair game

For example, the engine might find it's faster to actually execute the code like this:

```js
var a, b;

a = 10;
a++;

b = 30;
b++;

console.log( a + b ); // 42
```

Or this:

```js
var a, b;

a = 11;
b = 31;

console.log( a + b ); // 42
```

Or even:

```js
// because `a` and `b` aren't used anymore, we can
// inline and don't even need them!
console.log( 42 ); // 42
```

In all these cases, the JS engine is performing safe optimizations during its compilation, as the end *observable* result will be the same.

But here's a scenario where these specific optimizations would be unsafe and thus couldn't be allowed (of course, not to say that it's not optimized at all):

```js
var a, b;

a = 10;
b = 30;

// we need `a` and `b` in their preincremented state!
console.log( a * b ); // 300

a = a + 1;
b = b + 1;

console.log( a + b ); // 42
```

Other examples where the compiler reordering could create observable side effects (and thus must be disallowed) would include things like any function call with side effects (even and especially getter functions), or ES6 Proxy objects (see the *ES6 & Beyond* title of this book series).

Consider:

```js
function foo() {
    console.log( b );
    return 1;
}

var a, b, c;

// ES5.1 getter literal syntax
c = {
    get bar() {
        console.log( a );
        return 1;
    }
};

a = 10;
b = 30;

a += foo(); // 30
b += c.bar; // 11

console.log( a + b ); // 42
```

If it weren't for the `console.log(..)` statements in this snippet (just used as a convenient form of observable side effect for the illustration), the JS engine would likely have been free, if it wanted to (who knows if it would!?), to reorder the code to:

```js
// ...

a = 10 + foo();
b = 30 + c.bar;

// ...
```

While JS semantics thankfully protect us from the *observable* nightmares that compiler statement reordering would seem to be in danger of, it's still important to understand just how tenuous a link there is between the way source code is authored (in top-down fashion) and the way it runs after compilation.

Compiler statement reordering is almost a micro-metaphor for concurrency and interaction
- As a general concept, such awareness can help you understand async JS code flow issues better

## Review

A JavaScript program is (practically) always broken up into two or more chunks, where the first chunk runs *now* and the next chunk runs *later*, in response to an event
- Even though the program is executed chunk-by-chunk, all of them share the same access to the program scope and state, so each modification to state is made on top of the previous state

Whenever there are events to run, the *event loop* runs until the queue is empty. Each iteration of the event loop is a "tick"
- User interaction, IO, and timers enqueue events on the event queue

At any given moment, only one event can be processed from the queue at a time
- While an event is executing, it can directly or indirectly cause one or more subsequent events

Concurrency is when two or more chains of events interleave over time, such that from a high-level perspective, they appear to be running *simultaneously* (even though at any given moment only one event is being processed).

It's often necessary to do some form of interaction coordination between these concurrent "processes" (as distinct from operating system processes), for instance to ensure ordering or to prevent "race conditions"
- These "processes" can also *cooperate* by breaking themselves into smaller chunks and to allow other "process" interleaving
# Callbacks

In Chapter 1, we explored the terminology and concepts around asynchronous programming in JavaScript.
- Our focus is on understanding the single-threaded (one-at-a-time) event loop queue that drives all "events" (async function invocations)
- We also explored various ways that concurrency patterns explain the relationships (if any!) between *simultaneously* running chains of events, or "processes" (tasks, function calls, etc.)

All our examples in Chapter 1 used the function as the individual, indivisible unit of operations, whereby inside the function, statements run in predictable order (above the compiler level!), but at the function-ordering level, events (aka async function invocations) can happen in a variety of orders.

In all these cases, the function is acting as a "callback," because it serves as the target for the event loop to "call back into" the program, whenever that item in the queue is processed.

As you no doubt have observed, callbacks are by far the most common way that asynchrony in JS programs is expressed and managed. Indeed, the callback is the most fundamental async pattern in the language.

Countless JS programs, even very sophisticated and complex ones, have been written upon no other async foundation than the callback (with of course the concurrency interaction patterns we explored in Chapter 1)
- The callback function is the async work horse for JavaScript, and it does its job respectably

Except... callbacks are not without their shortcomings. Many developers are excited by the *promise* (pun intended!) of better async patterns
- But it's impossible to effectively use any abstraction if you don't understand what it's abstracting, and why

In this chapter, we will explore a couple of those in depth, as motivation for why more sophisticated async patterns (explored in subsequent chapters of this book) are necessary and desired.

## Continuations

Let's go back to the async callback example we started with in Chapter 1, but let me slightly modify it to illustrate a point:

```js
// A
ajax( "..", function(..){
    // C
} );
// B
```

`// A` and `// B` represent the first half of the program (aka the *now*), and `// C` marks the second half of the program (aka the *later*)
- The first half executes right away, and then there's a "pause" of indeterminate length
- At some future moment, if the Ajax call completes, then the program will pick up where it left off, and *continue* with the second half

In other words, the callback function wraps or encapsulates the *continuation* of the program.

Let's make the code even simpler:

```js
// A
setTimeout( function(){
    // C
}, 1000 );
// B
```

Stop for a moment and ask yourself how you'd describe (to someone else less informed about how JS works) the way that program behaves
- Go ahead, try it out loud. It's a good exercise that will help my next points make more sense

Most readers just now probably thought or said something to the effect of: "Do A, then set up a timeout to wait 1,000 milliseconds, then once that fires, do C." How close was your rendition?

You might have caught yourself and self-edited to: "Do A, setup the timeout for 1,000 milliseconds, then do B, then after the timeout fires, do C."
- That's more accurate than the first version. Can you spot the difference?

Even though the second version is more accurate, both versions are deficient in explaining this code in a way that matches our brains to the code, and the code to the JS engine
- The disconnect is both subtle and monumental, and is at the very heart of understanding the shortcomings of callbacks as async expression and management

As soon as we introduce a single continuation (or several dozen as many programs do!) in the form of a callback function, we have allowed a divergence to form between how our brains work and the way the code will operate
- Any time these two diverge (and this is by far not the only place that happens, as I'm sure you know!), we run into the inevitable fact that our code becomes harder to understand, reason about, debug, and maintain

## Sequential Brain

I'm pretty sure most of you readers have heard someone say (even made the claim yourself), "I'm a multitasker."
- The effects of trying to act as a multitasker range from humorous (e.g., the silly patting-head-rubbing-stomach kids' game) to mundane (chewing gum while walking) to downright dangerous (texting while driving)

But are we multitaskers?
- Can we really do two conscious, intentional actions at once and think/reason about both of them at exactly the same moment? Does our highest level of brain functionality have parallel multithreading going on?

The answer may surprise you: **probably not.**

That's just not really how our brains appear to be set up. We're much more single taskers than many of us (especially A-type personalities!) would like to admit. We can really only think about one thing at any given instant.

I'm not talking about all our involuntary, subconscious, automatic brain functions, such as heart beating, breathing, and eyelid blinking
- Those are all vital tasks to our sustained life, but we don't intentionally allocate any brain power to them. Thankfully, while we obsess about checking social network feeds for the 15th time in three minutes, our brain carries on in the background (threads!) with all those important tasks

We're instead talking about whatever task is at the forefront of our minds at the moment
- For me, it's writing the text in this book right now
- Am I doing any other higher level brain function at exactly this same moment? Nope, not really
- I get distracted quickly and easily -- a few dozen times in these last couple of paragraphs!

When we *fake* multitasking, such as trying to type something at the same time we're talking to a friend or family member on the phone, what we're actually most likely doing is acting as fast context switchers
- In other words, we switch back and forth between two or more tasks in rapid succession, *simultaneously* progressing on each task in tiny, fast little chunks
- We do it so fast that to the outside world it appears as if we're doing these things *in parallel*

Does that sound suspiciously like async evented concurrency (like the sort that happens in JS) to you?!
- If not, go back and read Chapter 1 again!

In fact, one way of simplifying (i.e., abusing) the massively complex world of neurology into something I can remotely hope to discuss here is that our brains work kinda like the event loop queue.

If you think about every single letter (or word) I type as a single async event, in just this sentence alone there are several dozen opportunities for my brain to be interrupted by some other event, such as from my senses, or even just my random thoughts.

I don't get interrupted and pulled to another "process" at every opportunity that I could be (thankfully -- or this book would never be written!)
- But it happens often enough that I feel my own brain is nearly constantly switching to various different contexts (aka "processes"
- And that's an awful lot like how the JS engine would probably feel

### Doing Versus Planning

OK, so our brains can be thought of as operating in single-threaded event loop queue like ways, as can the JS engine. That sounds like a good match.

But we need to be more nuanced than that in our analysis
- There's a big, observable difference between how we plan various tasks, and how our brains actually operate those tasks

Again, back to the writing of this text as my metaphor
- My rough mental outline plan here is to keep writing and writing, going sequentially through a set of points I have ordered in my thoughts
- I don't plan to have any interruptions or nonlinear activity in this writing. But yet, my brain is nevertheless switching around all the time

Even though at an operational level our brains are async evented, we seem to plan out tasks in a sequential, synchronous way
- "I need to go to the store, then buy some milk, then drop off my dry cleaning"

You'll notice that this higher level thinking (planning) doesn't seem very async evented in its formulation
- In fact, it's kind of rare for us to deliberately think solely in terms of events
- Instead, we plan things out carefully, sequentially (A then B then C), and we assume to an extent a sort of temporal blocking that forces B to wait on A, and C to wait on B

When a developer writes code, they are planning out a set of actions to occur
- If they're any good at being a developer, they're **carefully planning** it out
- "I need to set `z` to the value of `x`, and then `x` to the value of `y`," and so forth

When we write out synchronous code, statement by statement, it works a lot like our errands to-do list:

```js
// swap `x` and `y` (via temp variable `z`)
z = x;
x = y;
y = z;
```

These three assignment statements are synchronous, so `x = y` waits for `z = x` to finish, and `y = z` in turn waits for `x = y` to finish
- Another way of saying it is that these three statements are temporally bound to execute in a certain order, one right after the other
- Thankfully, we don't need to be bothered with any async evented details here. If we did, the code gets a lot more complex, quickly

So if synchronous brain planning maps well to synchronous code statements, how well do our brains do at planning out asynchronous code?

It turns out that how we express asynchrony (with callbacks) in our code doesn't map very well at all to that synchronous brain planning behavior.

Can you actually imagine having a line of thinking that plans out your to-do errands like this?

> "I need to go to the store, but on the way I'm sure I'll get a phone call, so 'Hi, Mom', and while she starts talking, I'll be looking up the store address on GPS, but that'll take a second to load, so I'll turn down the radio so I can hear Mom better, then I'll realize I forgot to put on a jacket and it's cold outside, but no matter, keep driving and talking to Mom, and then the seatbelt ding reminds me to buckle up, so 'Yes, Mom, I am wearing my seatbelt, I always do!'
- Ah, finally the GPS got the directions, now..."

As ridiculous as that sounds as a formulation for how we plan our day out and think about what to do and in what order, nonetheless it's exactly how our brains operate at a functional level
- Remember, that's not multitasking, it's just fast context switching

The reason it's difficult for us as developers to write async evented code, especially when all we have is the callback to do it, is that stream of consciousness thinking/planning is unnatural for most of us.

We think in step-by-step terms, but the tools (callbacks) available to us in code are not expressed in a step-by-step fashion once we move from synchronous to asynchronous.

And **that** is why it's so hard to accurately author and reason about async JS code with callbacks: because it's not how our brain planning works.

**Note:** The only thing worse than not knowing why some code breaks is not knowing why it worked in the first place!
- It's the classic "house of cards" mentality: "it works, but not sure why, so nobody touch it!"
- You may have heard, "Hell is other people" (Sartre), and the programmer meme twist, "Hell is other people's code"
- I believe truly: "Hell is not understanding my own code." And callbacks are one main culprit

### Nested/Chained Callbacks

Consider:

```js
listen( "click", function handler(evt){
    setTimeout( function request(){
        ajax( "http://some.url.1", function response(text){
            if (text == "hello") {
                handler();
            }
            else if (text == "world") {
                request();
            }
        } );
    }, 500) ;
} );
```

There's a good chance code like that is recognizable to you
- We've got a chain of three functions nested together, each one representing a step in an asynchronous series (task, "process")

This kind of code is often called "callback hell," and sometimes also referred to as the "pyramid of doom" (for its sideways-facing triangular shape due to the nested indentation).

But "callback hell" actually has almost nothing to do with the nesting/indentation
- It's a far deeper problem than that. We'll see how and why as we continue through the rest of this chapter

First, we're waiting for the "click" event, then we're waiting for the timer to fire, then we're waiting for the Ajax response to come back, at which point it might do it all again.

At first glance, this code may seem to map its asynchrony naturally to sequential brain planning.

First (*now*), we:

```js
listen( "..", function handler(..){
    // ..
} );
```

Then *later*, we:

```js
setTimeout( function request(..){
    // ..
}, 500) ;
```

Then still *later*, we:

```js
ajax( "..", function response(..){
    // ..
} );
```

And finally (most *later*), we:

```js
if ( .. ) {
    // ..
}
else ..
```

But there's several problems with reasoning about this code linearly in such a fashion.

First, it's an accident of the example that our steps are on subsequent lines (1, 2, 3, and 4...)
- In real async JS programs, there's often a lot more noise cluttering things up, noise that we have to deftly maneuver past in our brains as we jump from one function to the next
- Understanding the async flow in such callback-laden code is not impossible, but it's certainly not natural or easy, even with lots of practice

But also, there's something deeper wrong, which isn't evident just in that code example. Let me make up another scenario (pseudocode-ish) to illustrate it:

```js
doA( function(){
    doB();

    doC( function(){
        doD();
    } )

    doE();
} );

doF();
```

While the experienced among you will correctly identify the true order of operations here, I'm betting it is more than a little confusing at first glance, and takes some concerted mental cycles to arrive at. The operations will happen in this order:

* `doA()`
* `doF()`
* `doB()`
* `doC()`
* `doE()`
* `doD()`

Did you get that right the very first time you glanced at the code?

OK, some of you are thinking I was unfair in my function naming, to intentionally lead you astray
- I swear I was just naming in top-down appearance order. But let me try again:

```js
doA( function(){
    doC();

    doD( function(){
        doF();
    } )

    doE();
} );

doB();
```

Now, I've named them alphabetically in order of actual execution
- But I still bet, even with experience now in this scenario, tracing through the `A -> B -> C -> D -> E -> F` order doesn't come natural to many if any of you readers. Certainly, your eyes do an awful lot of jumping up and down the code snippet, right?

But even if that all comes natural to you, there's still one more hazard that could wreak havoc. Can you spot what it is?

What if `doA(..)` or `doD(..)` aren't actually async, the way we obviously assumed them to be? Uh oh, now the order is different
- If they're both sync (and maybe only sometimes, depending on the conditions of the program at the time), the order is now `A -> C -> D -> F -> E -> B`

That sound you just heard faintly in the background is the sighs of thousands of JS developers who just had a face-in-hands moment.

Is nesting the problem? Is that what makes it so hard to trace the async flow? That's part of it, certainly.

But let me rewrite the previous nested event/timeout/Ajax example without using nesting:

```js
listen( "click", handler );

function handler() {
    setTimeout( request, 500 );
}

function request(){
    ajax( "http://some.url.1", response );
}

function response(text){
    if (text == "hello") {
        handler();
    }
    else if (text == "world") {
        request();
    }
}
```

This formulation of the code is not hardly as recognizable as having the nesting/indentation woes of its previous form, and yet it's every bit as susceptible to "callback hell." Why?

As we go to linearly (sequentially) reason about this code, we have to skip from one function, to the next, to the next, and bounce all around the code base to "see" the sequence flow
- And remember, this is simplified code in sort of best-case fashion. We all know that real async JS program code bases are often fantastically more jumbled, which makes such reasoning orders of magnitude more difficult

Another thing to notice: to get steps 2, 3, and 4 linked together so they happen in succession, the only affordance callbacks alone gives us is to hardcode step 2 into step 1, step 3 into step 2, step 4 into step 3, and so on
- The hardcoding isn't necessarily a bad thing, if it really is a fixed condition that step 2 should always lead to step 3

But the hardcoding definitely makes the code a bit more brittle, as it doesn't account for anything going wrong that might cause a deviation in the progression of steps
- For example, if step 2 fails, step 3 never gets reached, nor does step 2 retry, or move to an alternate error handling flow, and so on

All of these issues are things you *can* manually hardcode into each step, but that code is often very repetitive and not reusable in other steps or in other async flows in your program.

Even though our brains might plan out a series of tasks in a sequential type of way (this, then this, then this), the evented nature of our brain operation makes recovery/retry/forking of flow control almost effortless
- If you're out running errands, and you realize you left a shopping list at home, it doesn't end the day because you didn't plan that ahead of time
- Your brain routes around this hiccup easily: you go home, get the list, then head right back out to the store

But the brittle nature of manually hardcoded callbacks (even with hardcoded error handling) is often far less graceful
- Once you end up specifying (aka pre-planning) all the various eventualities/paths, the code becomes so convoluted that it's hard to ever maintain or update it

**That** is what "callback hell" is all about! The nesting/indentation are basically a side show, a red herring.

And as if all that's not enough, we haven't even touched what happens when two or more chains of these callback continuations are happening *simultaneously*, or when the third step branches out into "parallel" callbacks with gates or latches, or... OMG, my brain hurts, how about yours!?

Are you catching the notion here that our sequential, blocking brain planning behaviors just don't map well onto callback-oriented async code?
- That's the first major deficiency to articulate about callbacks: they express asynchrony in code in ways our brains have to fight just to keep in sync with (pun intended!)

## Trust Issues

The mismatch between sequential brain planning and callback-driven async JS code is only part of the problem with callbacks
- There's something much deeper to be concerned about

Let's once again revisit the notion of a callback function as the continuation (aka the second half) of our program:

```js
// A
ajax( "..", function(..){
    // C
} );
// B
```

`// A` and `// B` happen *now*, under the direct control of the main JS program. But `// C` gets deferred to happen *later*, and under the control of another party -- in this case, the `ajax(..)` function
- In a basic sense, that sort of hand-off of control doesn't regularly cause lots of problems for programs

But don't be fooled by its infrequency that this control switch isn't a big deal
- In fact, it's one of the worst (and yet most subtle) problems about callback-driven design
- It revolves around the idea that sometimes `ajax(..)` (i.e., the "party" you hand your callback continuation to) is not a function that you wrote, or that you directly control. Many times, it's a utility provided by some third party

We call this "inversion of control," when you take part of your program and give over control of its execution to another third party
- There's an unspoken "contract" that exists between your code and the third-party utility -- a set of things you expect to be maintained

### Tale of Five Callbacks

It might not be terribly obvious why this is such a big deal
- Let me construct an exaggerated scenario to illustrate the hazards of trust at play

Imagine you're a developer tasked with building out an ecommerce checkout system for a site that sells expensive TVs
- You already have all the various pages of the checkout system built out just fine. On the last page, when the user clicks "confirm" to buy the TV, you need to call a third-party function (provided say by some analytics tracking company) so that the sale can be tracked

You notice that they've provided what looks like an async tracking utility, probably for the sake of performance best practices, which means you need to pass in a callback function
- In this continuation that you pass in, you will have the final code that charges the customer's credit card and displays the thank you page

This code might look like:

```js
analytics.trackPurchase( purchaseData, function(){
    chargeCreditCard();
    displayThankyouPage();
} );
```

Easy enough, right? You write the code, test it, everything works, and you deploy to production. Everyone's happy!

Six months go by and no issues
- You've almost forgotten you even wrote that code. One morning, you're at a coffee shop before work, casually enjoying your latte, when you get a panicked call from your boss insisting you drop the coffee and rush into work right away

When you arrive, you find out that a high-profile customer has had his credit card charged five times for the same TV, and he's understandably upset
- Customer service has already issued an apology and processed a refund. But your boss demands to know how this could possibly have happened. "Don't we have tests for stuff like this!?"

You don't even remember the code you wrote. But you dig back in and start trying to find out what could have gone awry.

After digging through some logs, you come to the conclusion that the only explanation is that the analytics utility somehow, for some reason, called your callback five times instead of once. Nothing in their documentation mentions anything about this.

Frustrated, you contact customer support, who of course is as astonished as you are
- They agree to escalate it to their developers, and promise to get back to you
- The next day, you receive a lengthy email explaining what they found, which you promptly forward to your boss

Apparently, the developers at the analytics company had been working on some experimental code that, under certain conditions, would retry the provided callback once per second, for five seconds, before failing with a timeout
- They had never intended to push that into production, but somehow they did, and they're totally embarrassed and apologetic
- They go into plenty of detail about how they've identified the breakdown and what they'll do to ensure it never happens again. Yadda, yadda

What's next?

You talk it over with your boss, but he's not feeling particularly comfortable with the state of things
- He insists, and you reluctantly agree, that you can't trust *them* anymore (that's what bit you), and that you'll need to figure out how to protect the checkout code from such a vulnerability again

After some tinkering, you implement some simple ad hoc code like the following, which the team seems happy with:

```js
var tracked = false;

analytics.trackPurchase( purchaseData, function(){
    if (!tracked) {
        tracked = true;
        chargeCreditCard();
        displayThankyouPage();
    }
} );
```

**Note:** This should look familiar to you from Chapter 1, because we're essentially creating a latch to handle if there happen to be multiple concurrent invocations of our callback.

But then one of your QA engineers asks, "what happens if they never call the callback?" Oops. Neither of you had thought about that.

You begin to chase down the rabbit hole, and think of all the possible things that could go wrong with them calling your callback
- Here's roughly the list you come up with of ways the analytics utility could misbehave:

* Call the callback too early (before it's been tracked)
* Call the callback too late (or never)
* Call the callback too few or too many times (like the problem you encountered!)
* Fail to pass along any necessary environment/parameters to your callback
* Swallow any errors/exceptions that may happen
* ...

That should feel like a troubling list, because it is
- You're probably slowly starting to realize that you're going to have to invent an awful lot of ad hoc logic **in each and every single callback** that's passed to a utility you're not positive you can trust

Now you realize a bit more completely just how hellish "callback hell" is.

### Not Just Others' Code

Some of you may be skeptical at this point whether this is as big a deal as I'm making it out to be. Perhaps you don't interact with truly third-party utilities much if at all
- Perhaps you use versioned APIs or self-host such libraries, so that its behavior can't be changed out from underneath you

So, contemplate this: can you even *really* trust utilities that you do theoretically control (in your own code base)?

Think of it this way: most of us agree that at least to some extent we should build our own internal functions with some defensive checks on the input parameters, to reduce/prevent unexpected issues.

Overly trusting of input:
```js
function addNumbers(x,y) {
    // + is overloaded with coercion to also be
    // string concatenation, so this operation
    // isn't strictly safe depending on what's
    // passed in.
    return x + y;
}

addNumbers( 21, 21 ); // 42
addNumbers( 21, "21" );	// "2121"
```

Defensive against untrusted input:
```js
function addNumbers(x,y) {
    // ensure numerical input
    if (typeof x != "number" || typeof y != "number") {
        throw Error( "Bad parameters" );
    }

    // if we get here, + will safely do numeric addition
    return x + y;
}

addNumbers( 21, 21 ); // 42
addNumbers( 21, "21" );	// Error: "Bad parameters"
```

Or perhaps still safe but friendlier:
```js
function addNumbers(x,y) {
    // ensure numerical input
    x = Number( x );
    y = Number( y );

    // + will safely do numeric addition
    return x + y;
}

addNumbers( 21, 21 ); // 42
addNumbers( 21, "21" );	// 42
```

However you go about it, these sorts of checks/normalizations are fairly common on function inputs, even with code we theoretically entirely trust
- In a crude sort of way, it's like the programming equivalent of the geopolitical principle of "Trust But Verify"

So, doesn't it stand to reason that we should do the same thing about composition of async function callbacks, not just with truly external code but even with code we know is generally "under our own control"? **Of course we should.**

But callbacks don't really offer anything to assist us. We have to construct all that machinery ourselves, and it often ends up being a lot of boilerplate/overhead that we repeat for every single async callback.

The most troublesome problem with callbacks is *inversion of control* leading to a complete breakdown along all those trust lines.

If you have code that uses callbacks, especially but not exclusively with third-party utilities, and you're not already applying some sort of mitigation logic for all these *inversion of control* trust issues, your code *has* bugs in it right now even though they may not have bitten you yet. Latent bugs are still bugs.

Hell indeed.

## Trying to Save Callbacks

There are several variations of callback design that have attempted to address some (not all!) of the trust issues we've just looked at
- It's a valiant, but doomed, effort to save the callback pattern from imploding on itself

For example, regarding more graceful error handling, some API designs provide for split callbacks (one for the success notification, one for the error notification):

```js
function success(data) {
    console.log( data );
}

function failure(err) {
    console.error( err );
}

ajax( "http://some.url.1", success, failure );
```

In APIs of this design, often the `failure()` error handler is optional, and if not provided it will be assumed you want the errors swallowed. Ugh.

**Note:** This split-callback design is what the ES6 Promise API uses
- We'll cover ES6 Promises in much more detail in the next chapter

Another common callback pattern is called "error-first style" (sometimes called "Node style," as it's also the convention used across nearly all Node.js APIs), where the first argument of a single callback is reserved for an error object (if any)
- If success, this argument will be empty/falsy (and any subsequent arguments will be the success data), but if an error result is being signaled, the first argument is set/truthy (and usually nothing else is passed):

```js
function response(err,data) {
    // error?
    if (err) {
        console.error( err );
    }
    // otherwise, assume success
    else {
        console.log( data );
    }
}

ajax( "http://some.url.1", response );
```

In both of these cases, several things should be observed.

First, it has not really resolved the majority of trust issues like it may appear
- There's nothing about either callback that prevents or filters unwanted repeated invocations
- Moreover, things are worse now, because you may get both success and error signals, or neither, and you still have to code around either of those conditions

Also, don't miss the fact that while it's a standard pattern you can employ, it's definitely more verbose and boilerplate-ish without much reuse, so you're going to get weary of typing all that out for every single callback in your application.

What about the trust issue of never being called?
- If this is a concern (and it probably should be!), you likely will need to set up a timeout that cancels the event. You could make a utility (proof-of-concept only shown) to help you with that:

```js
function timeoutify(fn,delay) {
    var intv = setTimeout( function(){
            intv = null;
            fn( new Error( "Timeout!" ) );
        }, delay )
    ;

    return function() {
        // timeout hasn't happened yet?
        if (intv) {
            clearTimeout( intv );
            fn.apply( this, [ null ].concat( [].slice.call( arguments ) ) );
        }
    };
}
```

Here's how you use it:

```js
// using "error-first style" callback design
function foo(err,data) {
    if (err) {
        console.error( err );
    }
    else {
        console.log( data );
    }
}

ajax( "http://some.url.1", timeoutify( foo, 500 ) );
```

Another trust issue is being called "too early"
- In application-specific terms, this may actually involve being called before some critical task is complete
- But more generally, the problem is evident in utilities that can either invoke the callback you provide *now* (synchronously), or *later* (asynchronously)

This nondeterminism around the sync-or-async behavior is almost always going to lead to very difficult to track down bugs
- In some circles, the fictional insanity-inducing monster named Zalgo is used to describe the sync/async nightmares
- "Don't release Zalgo!" is a common cry, and it leads to very sound advice: always invoke callbacks asynchronously, even if that's "right away" on the next turn of the event loop, so that all callbacks are predictably async

**Note:** For more information on Zalgo, see Oren Golan's "Don't Release Zalgo!" (https://github.com/oren/oren.github.io/blob/master/posts/zalgo.md) and Isaac Z. Schlueter's "Designing APIs for Asynchrony" (http://blog.izs.me/post/59142742143/designing-apis-for-asynchrony).

Consider:

```js
function result(data) {
    console.log( a );
}

var a = 0;

ajax( "..pre-cached-url..", result );
a++;
```

Will this code print `0` (sync callback invocation) or `1` (async callback invocation)? Depends... on the conditions.

You can see just how quickly the unpredictability of Zalgo can threaten any JS program
- So the silly-sounding "never release Zalgo" is actually incredibly common and solid advice. Always be asyncing

What if you don't know whether the API in question will always execute async?
- You could invent a utility like this `asyncify(..)` proof-of-concept:

```js
function asyncify(fn) {
    var orig_fn = fn,
        intv = setTimeout( function(){
            intv = null;
            if (fn) fn();
        }, 0 )
    ;

    fn = null;

    return function() {
        // firing too quickly, before `intv` timer has fired to
        // indicate async turn has passed?
        if (intv) {
            fn = orig_fn.bind.apply(
                orig_fn,
                // add the wrapper's `this` to the `bind(..)`
                // call parameters, as well as currying any
                // passed in parameters
                [this].concat( [].slice.call( arguments ) )
            );
        }
        // already async
        else {
            // invoke original function
            orig_fn.apply( this, arguments );
        }
    };
}
```

You use `asyncify(..)` like this:

```js
function result(data) {
    console.log( a );
}

var a = 0;

ajax( "..pre-cached-url..", asyncify( result ) );
a++;
```

Whether the Ajax request is in the cache and resolves to try to call the callback right away, or must be fetched over the wire and thus complete later asynchronously, this code will always output `1` instead of `0` -- `result(..)` cannot help but be invoked asynchronously, which means the `a++` has a chance to run before `result(..)` does.

Yay, another trust issued "solved"! But it's inefficient, and yet again more bloated boilerplate to weigh your project down.

That's just the story, over and over again, with callbacks
- They can do pretty much anything you want, but you have to be willing to work hard to get it, and oftentimes this effort is much more than you can or should spend on such code reasoning

You might find yourself wishing for built-in APIs or other language mechanics to address these issues
- Finally ES6 has arrived on the scene with some great answers, so keep reading!

## Review

Callbacks are the fundamental unit of asynchrony in JS
- But they're not enough for the evolving landscape of async programming as JS matures

First, our brains plan things out in sequential, blocking, single-threaded semantic ways, but callbacks express asynchronous flow in a rather nonlinear, nonsequential way, which makes reasoning properly about such code much harder
- Bad to reason about code is bad code that leads to bad bugs

We need a way to express asynchrony in a more synchronous, sequential, blocking manner, just like our brains do.

Second, and more importantly, callbacks suffer from *inversion of control* in that they implicitly give control over to another party (often a third-party utility not in your control!) to invoke the *continuation* of your program
- This control transfer leads us to a troubling list of trust issues, such as whether the callback is called more times than we expect

# Promises

In Chapter 2, we identified two major categories of deficiencies with using callbacks to express program asynchrony and manage concurrency:
- lack of sequentiality and lack of trustability
- Now that we understand the problems more intimately, it's time we turn our attention to patterns that can address them

The issue we want to address first is the *inversion of control*, the trust that is so fragilely held and so easily lost.

Recall that we wrap up the *continuation* of our program in a callback function, and hand that callback over to another party (potentially even external code) and just cross our fingers that it will do the right thing with the invocation of the callback.

We do this because we want to say, "here's what happens *later*, after the current step finishes."

But what if we could uninvert that *inversion of control*?
- What if instead of handing the continuation of our program to another party, we could expect it to return us a capability to know when its task finishes, and then our code could decide what to do next?

This paradigm is called **Promises**.

Promises are starting to take the JS world by storm, as developers and specification writers alike desperately seek to untangle the insanity of callback hell in their code/design
- In fact, most new async APIs being added to JS/DOM platform are being built on Promises. So it's probably a good idea to dig in and learn them, don't you think!?

**Note:** The word "immediately" will be used frequently in this chapter, generally to refer to some Promise resolution action
- However, in essentially all cases, "immediately" means in terms of the Job queue behavior (see Chapter 1), not in the strictly synchronous *now* sense

## What Is a Promise?

When developers decide to learn a new technology or pattern, usually their first step is "Show me the code!"
- It's quite natural for us to just jump in feet first and learn as we go

But it turns out that some abstractions get lost on the APIs alone
- Promises are one of those tools where it can be painfully obvious from how someone uses it whether they understand what it's for and about versus just learning and using the API

So before I show the Promise code, I want to fully explain what a Promise really is conceptually
- I hope this will then guide you better as you explore integrating Promise theory into your own async flow

With that in mind, let's look at two different analogies for what a Promise *is*.

### Future Value

Imagine this scenario: I walk up to the counter at a fast-food restaurant, and place an order for a cheeseburger
- I hand the cashier $1.47. By placing my order and paying for it, I've made a request for a *value* back (the cheeseburger)
- I've started a transaction

But often, the cheeseburger is not immediately available for me. The cashier hands me something in place of my cheeseburger: a receipt with an order number on it
- This order number is an IOU ("I owe you") *promise* that ensures that eventually, I should receive my cheeseburger

So I hold onto my receipt and order number. I know it represents my *future cheeseburger*, so I don't need to worry about it anymore -- aside from being hungry!

While I wait, I can do other things, like send a text message to a friend that says, "Hey, can you come join me for lunch? I'm going to eat a cheeseburger."

I am reasoning about my *future cheeseburger* already, even though I don't have it in my hands yet
- My brain is able to do this because it's treating the order number as a placeholder for the cheeseburger
- The placeholder essentially makes the value *time independent*. It's a **future value**

Eventually, I hear, "Order 113!" and I gleefully walk back up to the counter with receipt in hand
I hand my receipt to the cashier, and I take my cheeseburger in return

In other words, once my *future value* was ready, I exchanged my value-promise for the value itself.

But there's another possible outcome
- They call my order number, but when I go to retrieve my cheeseburger, the cashier regretfully informs me, "I'm sorry, but we appear to be all out of cheeseburgers"
- Setting aside the customer frustration of this scenario for a moment, we can see an important characteristic of *future values*: they can either indicate a success or failure

Every time I order a cheeseburger, I know that I'll either get a cheeseburger eventually, or I'll get the sad news of the cheeseburger shortage, and I'll have to figure out something else to eat for lunch.

**Note:** In code, things are not quite as simple, because metaphorically the order number may never be called, in which case we're left indefinitely in an unresolved state. We'll come back to dealing with that case later.

#### Values Now and Later

This all might sound too mentally abstract to apply to your code. So let's be more concrete.

However, before we can introduce how Promises work in this fashion, we're going to derive in code that we already understand -- callbacks! -- how to handle these *future values*.

When you write code to reason about a value, such as performing math on a `number`, whether you realize it or not, you've been assuming something very fundamental about that value, which is that it's a concrete *now* value already:

```js
var x, y = 2;
console.log( x + y ); // NaN  <-- because `x` isn't set yet
```

The `x + y` operation assumes both `x` and `y` are already set. In terms we'll expound on shortly, we assume the `x` and `y` values are already *resolved*.

It would be nonsense to expect that the `+` operator by itself would somehow be magically capable of detecting and waiting around until both `x` and `y` are resolved (aka ready), only then to do the operation
- That would cause chaos in the program if different statements finished *now* and others finished *later*, right?

How could you possibly reason about the relationships between two statements if either one (or both) of them might not be finished yet?
- If statement 2 relies on statement 1 being finished, there are just two outcomes: either statement 1 finished right *now* and everything proceeds fine, or statement 1 didn't finish yet, and thus statement 2 is going to fail

If this sort of thing sounds familiar from Chapter 1, good!

Let's go back to our `x + y` math operation
- Imagine if there was a way to say, "Add `x` and `y`, but if either of them isn't ready yet, just wait until they are. Add them as soon as you can"

Your brain might have just jumped to callbacks. OK, so...

```js
function add(getX,getY,cb) {
    var x, y;
    getX( function(xVal){
        x = xVal;
        // both are ready?
        if (y != undefined) {
            cb( x + y );  // send along sum
        }
    } );
    getY( function(yVal){
        y = yVal;
        // both are ready?
        if (x != undefined) {
            cb( x + y );	// send along sum
        }
    } );
}

// `fetchX()` and `fetchY()` are sync or async
// functions
add( fetchX, fetchY, function(sum){
    console.log( sum ); // that was easy, huh?
} );
```

Take just a moment to let the beauty (or lack thereof) of that snippet sink in (whistles patiently).

While the ugliness is undeniable, there's something very important to notice about this async pattern.

In that snippet, we treated `x` and `y` as future values, and we express an operation `add(..)` that (from the outside) does not care whether `x` or `y` or both are available right away or not
- In other words, it normalizes the *now* and *later*, such that we can rely on a predictable outcome of the `add(..)` operation

By using an `add(..)` that is temporally consistent -- it behaves the same across *now* and *later* times -- the async code is much easier to reason about.

To put it more plainly: to consistently handle both *now* and *later*, we make both of them *later*: all operations become async.

Of course, this rough callbacks-based approach leaves much to be desired
- It's just a first tiny step toward realizing the benefits of reasoning about *future values* without worrying about the time aspect of when it's available or not

#### Promise Value

We'll definitely go into a lot more detail about Promises later in the chapter -- so don't worry if some of this is confusing -- but let's just briefly glimpse at how we can express the `x + y` example via `Promise`s:

```js
function add(xPromise,yPromise) {
    // `Promise.all([ .. ])` takes an array of promises,
    // and returns a new promise that waits on them
    // all to finish
    return Promise.all( [xPromise, yPromise] )

    // when that promise is resolved, let's take the
    // received `X` and `Y` values and add them together.
    .then( function(values){
        // `values` is an array of the messages from the
        // previously resolved promises
        return values[0] + values[1];
    } );
}

// `fetchX()` and `fetchY()` return promises for
// their respective values, which may be ready
// *now* or *later*.
add( fetchX(), fetchY() )

// we get a promise back for the sum of those
// two numbers.
// now we chain-call `then(..)` to wait for the
// resolution of that returned promise.
.then( function(sum){
    console.log( sum ); // that was easier!
} );
```

There are two layers of Promises in this snippet.

`fetchX()` and `fetchY()` are called directly, and the values they return (promises!) are passed into `add(..)`
- The underlying values those promises represent may be ready *now* or *later*, but each promise normalizes the behavior to be the same regardless
- We reason about `X` and `Y` values in a time-independent way. They are *future values*

The second layer is the promise that `add(..)` creates (via `Promise.all([ .. ])`) and returns, which we wait on by calling `then(..)`
- When the `add(..)` operation completes, our `sum` *future value* is ready and we can print it out
- We hide inside of `add(..)` the logic for waiting on the `X` and `Y` *future values*

**Note:** Inside `add(..)`, the `Promise.all([ .. ])` call creates a promise (which is waiting on `promiseX` and `promiseY` to resolve)
- The chained call to `.then(..)` creates another promise, which the `return values[0] + values[1]` line immediately resolves (with the result of the addition)
- Thus, the `then(..)` call we chain off the end of the `add(..)` call -- at the end of the snippet -- is actually operating on that second promise returned, rather than the first one created by `Promise.all([ .. ])`
- Also, though we are not chaining off the end of that second `then(..)`, it too has created another promise, had we chosen to observe/use it. This Promise chaining stuff will be explained in much greater detail later in this chapter

Just like with cheeseburger orders, it's possible that the resolution of a Promise is rejection instead of fulfillment
- Unlike a fulfilled Promise, where the value is always programmatic, a rejection value -- commonly called a "rejection reason" -- can either be set directly by the program logic, or it can result implicitly from a runtime exception

With Promises, the `then(..)` call can actually take two functions, the first for fulfillment (as shown earlier), and the second for rejection:

```js
add( fetchX(), fetchY() )
.then(
    // fullfillment handler
    function(sum) {
        console.log( sum );
    },
    // rejection handler
    function(err) {
        console.error( err ); // bummer!
    }
);
```

If something went wrong getting `X` or `Y`, or something somehow failed during the addition, the promise that `add(..)` returns is rejected, and the second callback error handler passed to `then(..)` will receive the rejection value from the promise.

Because Promises encapsulate the time-dependent state -- waiting on the fulfillment or rejection of the underlying value -- from the outside, the Promise itself is time-independent, and thus Promises can be composed (combined) in predictable ways regardless of the timing or outcome underneath.

Moreover, once a Promise is resolved, it stays that way forever -- it becomes an *immutable value* at that point -- and can then be *observed* as many times as necessary.

**Note:** Because a Promise is externally immutable once resolved, it's now safe to pass that value around to any party and know that it cannot be modified accidentally or maliciously
- This is especially true in relation to multiple parties observing the resolution of a Promise
- It is not possible for one party to affect another party's ability to observe Promise resolution
- Immutability may sound like an academic topic, but it's actually one of the most fundamental and important aspects of Promise design, and shouldn't be casually passed over

That's one of the most powerful and important concepts to understand about Promises
- With a fair amount of work, you could ad hoc create the same effects with nothing but ugly callback composition, but that's not really an effective strategy, especially because you have to do it over and over again

Promises are an easily repeatable mechanism for encapsulating and composing *future values*.

### Completion Event

As we just saw, an individual Promise behaves as a *future value*
- But there's another way to think of the resolution of a Promise: as a flow-control mechanism -- a temporal this-then-that -- for two or more steps in an asynchronous task

Let's imagine calling a function `foo(..)` to perform some task. We don't know about any of its details, nor do we care. It may complete the task right away, or it may take a while.

We just simply need to know when `foo(..)` finishes so that we can move on to our next task. In other words, we'd like a way to be notified of `foo(..)`'s completion so that we can *continue*.

In typical JavaScript fashion, if you need to listen for a notification, you'd likely think of that in terms of events
- So we could reframe our need for notification as a need to listen for a *completion* (or *continuation*) event emitted by `foo(..)`

**Note:** Whether you call it a "completion event" or a "continuation event" depends on your perspective
- Is the focus more on what happens with `foo(..)`, or what happens *after* `foo(..)` finishes?
- Both perspectives are accurate and useful
- The event notification tells us that `foo(..)` has *completed*, but also that it's OK to *continue* with the next step
- Indeed, the callback you pass to be called for the event notification is itself what we've previously called a *continuation*
- Because *completion event* is a bit more focused on the `foo(..)`, which more has our attention at present, we slightly favor *completion event* for the rest of this text

With callbacks, the "notification" would be our callback invoked by the task (`foo(..)`)
- But with Promises, we turn the relationship around, and expect that we can listen for an event from `foo(..)`, and when notified, proceed accordingly

First, consider some pseudocode:

```js
foo(x) {
    // start doing something that could take a while
}

foo( 42 )

on (foo "completion") {
    // now we can do the next step!
}

on (foo "error") {
    // oops, something went wrong in `foo(..)`
}
```

We call `foo(..)` and then we set up two event listeners, one for `"completion"` and one for `"error"` -- the two possible *final* outcomes of the `foo(..)` call
- In essence, `foo(..)` doesn't even appear to be aware that the calling code has subscribed to these events, which makes for a very nice *separation of concerns*

Unfortunately, such code would require some "magic" of the JS environment that doesn't exist (and would likely be a bit impractical). Here's the more natural way we could express that in JS:

```js
function foo(x) {
    // start doing something that could take a while

    // make a `listener` event notification
    // capability to return

    return listener;
}

var evt = foo( 42 );

evt.on( "completion", function(){
    // now we can do the next step!
} );

evt.on( "failure", function(err){
    // oops, something went wrong in `foo(..)`
} );
```

`foo(..)` expressly creates an event subscription capability to return back, and the calling code receives and registers the two event handlers against it.

The inversion from normal callback-oriented code should be obvious, and it's intentional
- Instead of passing the callbacks to `foo(..)`, it returns an event capability we call `evt`, which receives the callbacks

But if you recall from Chapter 2, callbacks themselves represent an *inversion of control*
- So inverting the callback pattern is actually an *inversion of inversion*, or an *uninversion of control* -- restoring control back to the calling code where we wanted it to be in the first place

One important benefit is that multiple separate parts of the code can be given the event listening capability, and they can all independently be notified of when `foo(..)` completes to perform subsequent steps after its completion:

```js
var evt = foo( 42 );

// let `bar(..)` listen to `foo(..)`'s completion
bar( evt );

// also, let `baz(..)` listen to `foo(..)`'s completion
baz( evt );
```

*Uninversion of control* enables a nicer *separation of concerns*, where `bar(..)` and `baz(..)` don't need to be involved in how `foo(..)` is called
- Similarly, `foo(..)` doesn't need to know or care that `bar(..)` and `baz(..)` exist or are waiting to be notified when `foo(..)` completes

Essentially, this `evt` object is a neutral third-party negotiation between the separate concerns.

#### Promise "Events"

As you may have guessed by now, the `evt` event listening capability is an analogy for a Promise.

In a Promise-based approach, the previous snippet would have `foo(..)` creating and returning a `Promise` instance, and that promise would then be passed to `bar(..)` and `baz(..)`.

**Note:** The Promise resolution "events" we listen for aren't strictly events (though they certainly behave like events for these purposes), and they're not typically called `"completion"` or `"error"`. Instead, we use `then(..)` to register a `"then"` event
- Or perhaps more precisely, `then(..)` registers `"fulfillment"` and/or `"rejection"` event(s), though we don't see those terms used explicitly in the code

Consider:

```js
function foo(x) {
    // start doing something that could take a while

    // construct and return a promise
    return new Promise( function(resolve,reject){
        // eventually, call `resolve(..)` or `reject(..)`,
        // which are the resolution callbacks for
        // the promise.
    } );
}

var p = foo( 42 );

bar( p );
baz( p );
```

**Note:** The pattern shown with `new Promise( function(..){ .. } )` is generally called the ["revealing constructor"](http://domenic.me/2014/02/13/the-revealing-constructor-pattern/)
- The function passed in is executed immediately (not async deferred, as callbacks to `then(..)` are), and it's provided two parameters, which in this case we've named `resolve` and `reject`
- These are the resolution functions for the promise. `resolve(..)` generally signals fulfillment, and `reject(..)` signals rejection

You can probably guess what the internals of `bar(..)` and `baz(..)` might look like:

```js
function bar(fooPromise) {
    // listen for `foo(..)` to complete
    fooPromise.then(
        function(){
            // `foo(..)` has now finished, so
            // do `bar(..)`'s task
        },
        function(){
            // oops, something went wrong in `foo(..)`
        }
    );
}

// ditto for `baz(..)`
```

Promise resolution doesn't necessarily need to involve sending along a message, as it did when we were examining Promises as *future values*
- It can just be a flow-control signal, as used in the previous snippet

Another way to approach this is:

```js
function bar() {
    // `foo(..)` has definitely finished, so
    // do `bar(..)`'s task
}

function oopsBar() {
    // oops, something went wrong in `foo(..)`,
    // so `bar(..)` didn't run
}

// ditto for `baz()` and `oopsBaz()`

var p = foo( 42 );

p.then( bar, oopsBar );
p.then( baz, oopsBaz );
```

**Note:** If you've seen Promise-based coding before, you might be tempted to believe that the last two lines of that code could be written as `p.then( .. ).then( .. )`, using chaining, rather than `p.then(..); p.then(..)`
- That would have an entirely different behavior, so be careful!
- The difference might not be clear right now, but it's actually a different async pattern than we've seen thus far: splitting/forking. Don't worry! We'll come back to this point later in this chapter

Instead of passing the `p` promise to `bar(..)` and `baz(..)`, we use the promise to control when `bar(..)` and `baz(..)` will get executed, if ever
- The primary difference is in the error handling

In the first snippet's approach, `bar(..)` is called regardless of whether `foo(..)` succeeds or fails, and it handles its own fallback logic if it's notified that `foo(..)` failed
- The same is true for `baz(..)`, obviously

In the second snippet, `bar(..)` only gets called if `foo(..)` succeeds, and otherwise `oopsBar(..)` gets called. Ditto for `baz(..)`.

Neither approach is *correct* per se. There will be cases where one is preferred over the other.

In either case, the promise `p` that comes back from `foo(..)` is used to control what happens next.

Moreover, the fact that both snippets end up calling `then(..)` twice against the same promise `p` illustrates the point made earlier, which is that Promises (once resolved) retain their same resolution (fulfillment or rejection) forever, and can subsequently be observed as many times as necessary.

Whenever `p` is resolved, the next step will always be the same, both *now* and *later*.

## Thenable Duck Typing

In Promises-land, an important detail is how to know for sure if some value is a genuine Promise or not. Or more directly, is it a value that will behave like a Promise?

Given that Promises are constructed by the `new Promise(..)` syntax, you might think that `p instanceof Promise` would be an acceptable check
- But unfortunately, there are a number of reasons that's not totally sufficient

Mainly, you can receive a Promise value from another browser window (iframe, etc.), which would have its own Promise different from the one in the current window/frame, and that check would fail to identify the Promise instance.

Moreover, a library or framework may choose to vend its own Promises and not use the native ES6 `Promise` implementation to do so
- In fact, you may very well be using Promises with libraries in older browsers that have no Promise at all

When we discuss Promise resolution processes later in this chapter, it will become more obvious why a non-genuine-but-Promise-like value would still be very important to be able to recognize and assimilate
- But for now, just take my word for it that it's a critical piece of the puzzle

As such, it was decided that the way to recognize a Promise (or something that behaves like a Promise) would be to define something called a "thenable" as any object or function which has a `then(..)` method on it
- It is assumed that any such value is a Promise-conforming thenable

The general term for "type checks" that make assumptions about a value's "type" based on its shape (what properties are present) is called "duck typing" -- "If it looks like a duck, and quacks like a duck, it must be a duck" (see the *Types & Grammar* title of this book series)
- So the duck typing check for a thenable would roughly be:

```js
if (
    p !== null &&
    (
        typeof p === "object" ||
        typeof p === "function"
    ) &&
    typeof p.then === "function"
) {
    // assume it's a thenable!
}
else {
    // not a thenable
}
```

Yuck! Setting aside the fact that this logic is a bit ugly to implement in various places, there's something deeper and more troubling going on.

If you try to fulfill a Promise with any object/function value that happens to have a `then(..)` function on it, but you weren't intending it to be treated as a Promise/thenable, you're out of luck, because it will automatically be recognized as thenable and treated with special rules (see later in the chapter).

This is even true if you didn't realize the value has a `then(..)` on it. For example:

```js
var o = { then: function(){} };

// make `v` be `[[Prototype]]`-linked to `o`
var v = Object.create( o );

v.someStuff = "cool";
v.otherStuff = "not so cool";

v.hasOwnProperty( "then" );		// false
```

`v` doesn't look like a Promise or thenable at all. It's just a plain object with some properties on it
- You're probably just intending to send that value around like any other object

But unknown to you, `v` is also `[[Prototype]]`-linked (see the *this & Object Prototypes* title of this book series) to another object `o`, which happens to have a `then(..)` on it
- So the thenable duck typing checks will think and assume `v` is a thenable. Uh oh

It doesn't even need to be something as directly intentional as that:

```js
Object.prototype.then = function(){};
Array.prototype.then = function(){};

var v1 = { hello: "world" };
var v2 = [ "Hello", "World" ];
```

Both `v1` and `v2` will be assumed to be thenables
- You can't control or predict if any other code accidentally or maliciously adds `then(..)` to `Object.prototype`, `Array.prototype`, or any of the other native prototypes. And if what's specified is a function that doesn't call either of its parameters as callbacks, then any Promise resolved with such a value will just silently hang forever! Crazy

Sound implausible or unlikely? Perhaps.

But keep in mind that there were several well-known non-Promise libraries preexisting in the community prior to ES6 that happened to already have a method on them called `then(..)`
- Some of those libraries chose to rename their own methods to avoid collision (that sucks!). Others have simply been relegated to the unfortunate status of "incompatible with Promise-based coding" in reward for their inability to change to get out of the way

The standards decision to hijack the previously nonreserved -- and completely general-purpose sounding -- `then` property name means that no value (or any of its delegates), either past, present, or future, can have a `then(..)` function present, either on purpose or by accident, or that value will be confused for a thenable in Promises systems, which will probably create bugs that are really hard to track down.

**Warning:** I do not like how we ended up with duck typing of thenables for Promise recognition
- There were other options, such as "branding" or even "anti-branding"; what we got seems like a worst-case compromise. But it's not all doom and gloom
- Thenable duck typing can be helpful, as we'll see later. Just beware that thenable duck typing can be hazardous if it incorrectly identifies something as a Promise that isn't

## Promise Trust

We've now seen two strong analogies that explain different aspects of what Promises can do for our async code
- But if we stop there, we've missed perhaps the single most important characteristic that the Promise pattern establishes: trust

Whereas the *future values* and *completion events* analogies play out explicitly in the code patterns we've explored, it won't be entirely obvious why or how Promises are designed to solve all of the *inversion of control* trust issues we laid out in the "Trust Issues" section of Chapter 2. But with a little digging, we can uncover some important guarantees that restore the confidence in async coding that Chapter 2 tore down!

Let's start by reviewing the trust issues with callbacks-only coding. When you pass a callback to a utility `foo(..)`, it might:

* Call the callback too early
* Call the callback too late (or never)
* Call the callback too few or too many times
* Fail to pass along any necessary environment/parameters
* Swallow any errors/exceptions that may happen

The characteristics of Promises are intentionally designed to provide useful, repeatable answers to all these concerns.

### Calling Too Early

Primarily, this is a concern of whether code can introduce Zalgo-like effects (see Chapter 2), where sometimes a task finishes synchronously and sometimes asynchronously, which can lead to race conditions.

Promises by definition cannot be susceptible to this concern, because even an immediately fulfilled Promise (like `new Promise(function(resolve){ resolve(42); })`) cannot be *observed* synchronously.

That is, when you call `then(..)` on a Promise, even if that Promise was already resolved, the callback you provide to `then(..)` will **always** be called asynchronously (for more on this, refer back to "Jobs" in Chapter 1).

No more need to insert your own `setTimeout(..,0)` hacks. Promises prevent Zalgo automatically.

### Calling Too Late

Similar to the previous point, a Promise's `then(..)` registered observation callbacks are automatically scheduled when either `resolve(..)` or `reject(..)` are called by the Promise creation capability
- Those scheduled callbacks will predictably be fired at the next asynchronous moment (see "Jobs" in Chapter 1)

It's not possible for synchronous observation, so it's not possible for a synchronous chain of tasks to run in such a way to in effect "delay" another callback from happening as expected
- That is, when a Promise is resolved, all `then(..)` registered callbacks on it will be called, in order, immediately at the next asynchronous opportunity (again, see "Jobs" in Chapter 1), and nothing that happens inside of one of those callbacks can affect/delay the calling of the other callbacks

For example:

```js
p.then( function(){
    p.then( function(){
        console.log( "C" );
    } );
    console.log( "A" );
} );
p.then( function(){
    console.log( "B" );
} );
// A B C
```

Here, `"C"` cannot interrupt and precede `"B"`, by virtue of how Promises are defined to operate.

#### Promise Scheduling Quirks

It's important to note, though, that there are lots of nuances of scheduling where the relative ordering between callbacks chained off two separate Promises is not reliably predictable.

If two promises `p1` and `p2` are both already resolved, it should be true that `p1.then(..); p2.then(..)` would end up calling the callback(s) for `p1` before the ones for `p2`. But there are subtle cases where that might not be true, such as the following:

```js
var p3 = new Promise( function(resolve,reject){
    resolve( "B" );
} );

var p1 = new Promise( function(resolve,reject){
    resolve( p3 );
} );

var p2 = new Promise( function(resolve,reject){
    resolve( "A" );
} );

p1.then( function(v){
    console.log( v );
} );

p2.then( function(v){
    console.log( v );
} );

// A B  <-- not  B A  as you might expect
```

We'll cover this more later, but as you can see, `p1` is resolved not with an immediate value, but with another promise `p3` which is itself resolved with the value `"B"`
- The specified behavior is to *unwrap* `p3` into `p1`, but asynchronously, so `p1`'s callback(s) are *behind* `p2`'s callback(s) in the asynchronous Job queue (see Chapter 1)

To avoid such nuanced nightmares, you should never rely on anything about the ordering/scheduling of callbacks across Promises
- In fact, a good practice is not to code in such a way where the ordering of multiple callbacks matters at all. Avoid that if you can

### Never Calling the Callback

This is a very common concern. It's addressable in several ways with Promises.

First, nothing (not even a JS error) can prevent a Promise from notifying you of its resolution (if it's resolved)
- If you register both fulfillment and rejection callbacks for a Promise, and the Promise gets resolved, one of the two callbacks will always be called

Of course, if your callbacks themselves have JS errors, you may not see the outcome you expect, but the callback will in fact have been called. We'll cover later how to be notified of an error in your callback, because even those don't get swallowed.

But what if the Promise itself never gets resolved either way? Even that is a condition that Promises provide an answer for, using a higher level abstraction called a "race":

```js
// a utility for timing out a Promise
function timeoutPromise(delay) {
    return new Promise( function(resolve,reject){
        setTimeout( function(){
            reject( "Timeout!" );
        }, delay );
    } );
}

// setup a timeout for `foo()`
Promise.race( [
    foo(),  // attempt `foo()`
    timeoutPromise( 3000 )	// give it 3 seconds
] )
.then(
    function(){
        // `foo(..)` fulfilled in time!
    },
    function(err){
        // either `foo()` rejected, or it just
        // didn't finish in time, so inspect
        // `err` to know which
    }
);
```

There are more details to consider with this Promise timeout pattern, but we'll come back to it later.

Importantly, we can ensure a signal as to the outcome of `foo()`, to prevent it from hanging our program indefinitely.

### Calling Too Few or Too Many Times

By definition, *one* is the appropriate number of times for the callback to be called
- The "too few" case would be zero calls, which is the same as the "never" case we just examined

The "too many" case is easy to explain. Promises are defined so that they can only be resolved once
- If for some reason the Promise creation code tries to call `resolve(..)` or `reject(..)` multiple times, or tries to call both, the Promise will accept only the first resolution, and will silently ignore any subsequent attempts

Because a Promise can only be resolved once, any `then(..)` registered callbacks will only ever be called once (each).

Of course, if you register the same callback more than once, (e.g., `p.then(f); p.then(f);`), it'll be called as many times as it was registered
- The guarantee that a response function is called only once does not prevent you from shooting yourself in the foot

### Failing to Pass Along Any Parameters/Environment

Promises can have, at most, one resolution value (fulfillment or rejection).

If you don't explicitly resolve with a value either way, the value is `undefined`, as is typical in JS. But whatever the value, it will always be passed to all registered (and appropriate: fulfillment or rejection) callbacks, either *now* or in the future.

Something to be aware of: If you call `resolve(..)` or `reject(..)` with multiple parameters, all subsequent parameters beyond the first will be silently ignored
- Although that might seem a violation of the guarantee we just described, it's not exactly, because it constitutes an invalid usage of the Promise mechanism
- Other invalid usages of the API (such as calling `resolve(..)` multiple times) are similarly *protected*, so the Promise behavior here is consistent (if not a tiny bit frustrating)

If you want to pass along multiple values, you must wrap them in another single value that you pass, such as an `array` or an `object`.

As for environment, functions in JS always retain their closure of the scope in which they're defined (see the *Scope & Closures* title of this series), so they of course would continue to have access to whatever surrounding state you provide
- Of course, the same is true of callbacks-only design, so this isn't a specific augmentation of benefit from Promises -- but it's a guarantee we can rely on nonetheless

### Swallowing Any Errors/Exceptions

In the base sense, this is a restatement of the previous point. If you reject a Promise with a *reason* (aka error message), that value is passed to the rejection callback(s).

But there's something much bigger at play here. If at any point in the creation of a Promise, or in the observation of its resolution, a JS exception error occurs, such as a `TypeError` or `ReferenceError`, that exception will be caught, and it will force the Promise in question to become rejected.

For example:

```js
var p = new Promise( function(resolve,reject){
    foo.bar();	// `foo` is not defined, so error!
    resolve( 42 );	// never gets here :(
} );

p.then(
    function fulfilled(){
        // never gets here :(
    },
    function rejected(err){
        // `err` will be a `TypeError` exception object
        // from the `foo.bar()` line.
    }
);
```

The JS exception that occurs from `foo.bar()` becomes a Promise rejection that you can catch and respond to.

This is an important detail, because it effectively solves another potential Zalgo moment, which is that errors could create a synchronous reaction whereas nonerrors would be asynchronous
- Promises turn even JS exceptions into asynchronous behavior, thereby reducing the race condition chances greatly

But what happens if a Promise is fulfilled, but there's a JS exception error during the observation (in a `then(..)` registered callback)? Even those aren't lost, but you may find how they're handled a bit surprising, until you dig in a little deeper:

```js
var p = new Promise( function(resolve,reject){
    resolve( 42 );
} );

p.then(
    function fulfilled(msg){
        foo.bar();
        console.log( msg );	// never gets here :(
    },
    function rejected(err){
        // never gets here either :(
    }
);
```

Wait, that makes it seem like the exception from `foo.bar()` really did get swallowed
- Never fear, it didn't
- But something deeper is wrong, which is that we've failed to listen for it
- The `p.then(..)` call itself returns another promise, and it's *that* promise that will be rejected with the `TypeError` exception
- Why couldn't it just call the error handler we have defined there? Seems like a logical behavior on the surface
- But it would violate the fundamental principle that Promises are **immutable** once resolved
- `p` was already fulfilled to the value `42`, so it can't later be changed to a rejection just because there's an error in observing `p`'s resolution

Besides the principle violation, such behavior could wreak havoc, if say there were multiple `then(..)` registered callbacks on the promise `p`, because some would get called and others wouldn't, and it would be very opaque as to why.

### Trustable Promise?

There's one last detail to examine to establish trust based on the Promise pattern.

You've no doubt noticed that Promises don't get rid of callbacks at all
- They just change where the callback is passed to. Instead of passing a callback to `foo(..)`, we get *something* (ostensibly a genuine Promise) back from `foo(..)`, and we pass the callback to that *something* instead

But why would this be any more trustable than just callbacks alone? How can we be sure the *something* we get back is in fact a trustable Promise?
- Isn't it basically all just a house of cards where we can trust only because we already trusted?

One of the most important, but often overlooked, details of Promises is that they have a solution to this issue as well
- Included with the native ES6 `Promise` implementation is `Promise.resolve(..)`

If you pass an immediate, non-Promise, non-thenable value to `Promise.resolve(..)`, you get a promise that's fulfilled with that value
- In other words, these two promises `p1` and `p2` will behave basically identically:

```js
var p1 = new Promise( function(resolve,reject){
    resolve( 42 );
} );

var p2 = Promise.resolve( 42 );
```

But if you pass a genuine Promise to `Promise.resolve(..)`, you just get the same promise back:

```js
var p1 = Promise.resolve( 42 );
var p2 = Promise.resolve( p1 );

p1 === p2; // true
```

Even more importantly, if you pass a non-Promise thenable value to `Promise.resolve(..)`, it will attempt to unwrap that value, and the unwrapping will keep going until a concrete final non-Promise-like value is extracted.

Recall our previous discussion of thenables?

Consider:

```js
var p = {
    then: function(cb) {
        cb( 42 );
    }
};

// this works OK, but only by good fortune
p
.then(
    function fulfilled(val){
        console.log( val ); // 42
    },
    function rejected(err){
        // never gets here
    }
);
```

This `p` is a thenable, but it's not a genuine Promise. Luckily, it's reasonable, as most will be
- But what if you got back instead something that looked like:

```js
var p = {
    then: function(cb,errcb) {
        cb( 42 );
        errcb( "evil laugh" );
    }
};

p
.then(
    function fulfilled(val){
        console.log( val ); // 42
    },
    function rejected(err){
        // oops, shouldn't have run
        console.log( err ); // evil laugh
    }
);
```

This `p` is a thenable but it's not so well behaved of a promise
- Is it malicious? Or is it just ignorant of how Promises should work? It doesn't really matter, to be honest
- In either case, it's not trustable as is

Nonetheless, we can pass either of these versions of `p` to `Promise.resolve(..)`, and we'll get the normalized, safe result we'd expect:

```js
Promise.resolve( p )
.then(
    function fulfilled(val){
        console.log( val ); // 42
    },
    function rejected(err){
        // never gets here
    }
);
```

`Promise.resolve(..)` will accept any thenable, and will unwrap it to its non-thenable value
- But you get back from `Promise.resolve(..)` a real, genuine Promise in its place, **one that you can trust**
- If what you passed in is already a genuine Promise, you just get it right back, so there's no downside at all to filtering through `Promise.resolve(..)` to gain trust

So let's say we're calling a `foo(..)` utility and we're not sure we can trust its return value to be a well-behaving Promise, but we know it's at least a thenable
- `Promise.resolve(..)` will give us a trustable Promise wrapper to chain off of:

```js
// don't just do this:
foo( 42 )
.then( function(v){
    console.log( v );
} );

// instead, do this:
Promise.resolve( foo( 42 ) )
.then( function(v){
    console.log( v );
} );
```

**Note:** Another beneficial side effect of wrapping `Promise.resolve(..)` around any function's return value (thenable or not) is that it's an easy way to normalize that function call into a well-behaving async task
- If `foo(42)` returns an immediate value sometimes, or a Promise other times, `Promise.resolve( foo(42) )` makes sure it's always a Promise result. And avoiding Zalgo makes for much better code

### Trust Built

Hopefully the previous discussion now fully "resolves" (pun intended) in your mind why the Promise is trustable, and more importantly, why that trust is so critical in building robust, maintainable software.

Can you write async code in JS without trust? Of course you can
- We JS developers have been coding async with nothing but callbacks for nearly two decades

But once you start questioning just how much you can trust the mechanisms you build upon to actually be predictable and reliable, you start to realize callbacks have a pretty shaky trust foundation.

Promises are a pattern that augments callbacks with trustable semantics, so that the behavior is more reason-able and more reliable
- By uninverting the *inversion of control* of callbacks, we place the control with a trustable system (Promises) that was designed specifically to bring sanity to our async

## Chain Flow

We've hinted at this a couple of times already, but Promises are not just a mechanism for a single-step *this-then-that* sort of operation
- That's the building block, of course, but it turns out we can string multiple Promises together to represent a sequence of async steps

The key to making this work is built on two behaviors intrinsic to Promises:

* Every time you call `then(..)` on a Promise, it creates and returns a new Promise, which we can *chain* with.
* Whatever value you return from the `then(..)` call's fulfillment callback (the first parameter) is automatically set as the fulfillment of the *chained* Promise (from the first point).

Let's first illustrate what that means, and *then* we'll derive how that helps us create async sequences of flow control. Consider the following:

```js
var p = Promise.resolve( 21 );
var p2 = p.then( function(v){
    console.log( v );	// 21

    // fulfill `p2` with value `42`
    return v * 2;
} );

// chain off `p2`
p2.then( function(v){
    console.log( v );	// 42
} );
```

By returning `v * 2` (i.e., `42`), we fulfill the `p2` promise that the first `then(..)` call created and returned
- When `p2`'s `then(..)` call runs, it's receiving the fulfillment from the `return v * 2` statement. Of course, `p2.then(..)` creates yet another promise, which we could have stored in a `p3` variable

But it's a little annoying to have to create an intermediate variable `p2` (or `p3`, etc.)
- Thankfully, we can easily just chain these together:

```js
var p = Promise.resolve( 21 );

p.then( function(v){
    console.log( v ); // 21

    // fulfill the chained promise with value `42`
    return v * 2;
} )
// here's the chained promise
.then( function(v){
    console.log( v );	// 42
} );
```

So now the first `then(..)` is the first step in an async sequence, and the second `then(..)` is the second step
- This could keep going for as long as you needed it to extend. Just keep chaining off a previous `then(..)` with each automatically created Promise

But there's something missing here. What if we want step 2 to wait for step 1 to do something asynchronous?
- We're using an immediate `return` statement, which immediately fulfills the chained promise

The key to making a Promise sequence truly async capable at every step is to recall how `Promise.resolve(..)` operates when what you pass to it is a Promise or thenable instead of a final value
- `Promise.resolve(..)` directly returns a received genuine Promise, or it unwraps the value of a received thenable -- and keeps going recursively while it keeps unwrapping thenables

The same sort of unwrapping happens if you `return` a thenable or Promise from the fulfillment (or rejection) handler. Consider:

```js
var p = Promise.resolve( 21 );

p.then( function(v){
    console.log( v ); // 21

    // create a promise and return it
    return new Promise( function(resolve,reject){
        // fulfill with value `42`
        resolve( v * 2 );
    } );
} )
.then( function(v){
    console.log( v ); // 42
} );
```

Even though we wrapped `42` up in a promise that we returned, it still got unwrapped and ended up as the resolution of the chained promise, such that the second `then(..)` still received `42`
- If we introduce asynchrony to that wrapping promise, everything still nicely works the same:

```js
var p = Promise.resolve( 21 );

p.then( function(v){
    console.log( v ); // 21

    // create a promise to return
    return new Promise( function(resolve,reject){
        // introduce asynchrony!
        setTimeout( function(){
            // fulfill with value `42`
            resolve( v * 2 );
        }, 100 );
    } );
} )
.then( function(v){
    // runs after the 100ms delay in the previous step
    console.log( v );	// 42
} );
```

That's incredibly powerful! Now we can construct a sequence of however many async steps we want, and each step can delay the next step (or not!), as necessary.

Of course, the value passing from step to step in these examples is optional
- If you don't return an explicit value, an implicit `undefined` is assumed, and the promises still chain together the same way
- Each Promise resolution is thus just a signal to proceed to the next step

To further the chain illustration, let's generalize a delay-Promise creation (without resolution messages) into a utility we can reuse for multiple steps:

```js
function delay(time) {
    return new Promise( function(resolve,reject){
        setTimeout( resolve, time );
    } );
}

delay( 100 ) // step 1
.then( function STEP2(){
    console.log( "step 2 (after 100ms)" );
    return delay( 200 );
} )
.then( function STEP3(){
    console.log( "step 3 (after another 200ms)" );
} )
.then( function STEP4(){
    console.log( "step 4 (next Job)" );
    return delay( 50 );
} )
.then( function STEP5(){
    console.log( "step 5 (after another 50ms)" );
} )
...
```

Calling `delay(200)` creates a promise that will fulfill in 200ms, and then we return that from the first `then(..)` fulfillment callback, which causes the second `then(..)`'s promise to wait on that 200ms promise.

**Note:** As described, technically there are two promises in that interchange: the 200ms-delay promise and the chained promise that the second `then(..)` chains from
- But you may find it easier to mentally combine these two promises together, because the Promise mechanism automatically merges their states for you. In that respect, you could think of `return delay(200)` as creating a promise that replaces the earlier-returned chained promise

To be honest, though, sequences of delays with no message passing isn't a terribly useful example of Promise flow control
- Let's look at a scenario that's a little more practical

Instead of timers, let's consider making Ajax requests:

```js
// assume an `ajax( {url}, {callback} )` utility

// Promise-aware ajax
function request(url) {
    return new Promise( function(resolve,reject){
        // the `ajax(..)` callback should be our
        // promise's `resolve(..)` function
        ajax( url, resolve );
    } );
}
```

We first define a `request(..)` utility that constructs a promise to represent the completion of the `ajax(..)` call:

```js
request( "http://some.url.1/" )
.then( function(response1){
    return request( "http://some.url.2/?v=" + response1 );
} )
.then( function(response2){
    console.log( response2 );
} );
```

**Note:** Developers commonly encounter situations in which they want to do Promise-aware async flow control with utilities that are not themselves Promise-enabled (like `ajax(..)` here, which expects a callback)
- Although the native ES6 `Promise` mechanism doesn't automatically solve this pattern for us, practically all Promise libraries *do*
- They usually call this process "lifting" or "promisifying" or some variation thereof. We'll come back to this technique later

Using the Promise-returning `request(..)`, we create the first step in our chain implicitly by calling it with the first URL, and chain off that returned promise with the first `then(..)`.

Once `response1` comes back, we use that value to construct a second URL, and make a second `request(..)` call
- That second `request(..)` promise is `return`ed so that the third step in our async flow control waits for that Ajax call to complete. Finally, we print `response2` once it returns

The Promise chain we construct is not only a flow control that expresses a multistep async sequence, but it also acts as a message channel to propagate messages from step to step.

What if something went wrong in one of the steps of the Promise chain? An error/exception is on a per-Promise basis, which means it's possible to catch such an error at any point in the chain, and that catching acts to sort of "reset" the chain back to normal operation at that point:

```js
// step 1:
request( "http://some.url.1/" )

// step 2:
.then( function(response1){
    foo.bar(); // undefined, error!

    // never gets here
    return request( "http://some.url.2/?v=" + response1 );
} )

// step 3:
.then(
    function fulfilled(response2){
        // never gets here
    },
    // rejection handler to catch the error
    function rejected(err){
        console.log( err );	// `TypeError` from `foo.bar()` error
        return 42;
    }
)

// step 4:
.then( function(msg){
    console.log( msg ); // 42
} );
```

When the error occurs in step 2, the rejection handler in step 3 catches it
- The return value (`42` in this snippet), if any, from that rejection handler fulfills the promise for the next step (4), such that the chain is now back in a fulfillment state

**Note:** As we discussed earlier, when returning a promise from a fulfillment handler, it's unwrapped and can delay the next step
- That's also true for returning promises from rejection handlers, such that if the `return 42` in step 3 instead returned a promise, that promise could delay step 4
- A thrown exception inside either the fulfillment or rejection handler of a `then(..)` call causes the next (chained) promise to be immediately rejected with that exception

If you call `then(..)` on a promise, and you only pass a fulfillment handler to it, an assumed rejection handler is substituted:

```js
var p = new Promise( function(resolve,reject){
    reject( "Oops" );
} );

var p2 = p.then(
    function fulfilled(){
        // never gets here
    }
    // assumed rejection handler, if omitted or
    // any other non-function value passed
    // function(err) {
    //     throw err;
    // }
);
```

As you can see, the assumed rejection handler simply rethrows the error, which ends up forcing `p2` (the chained promise) to reject with the same error reason
- In essence, this allows the error to continue propagating along a Promise chain until an explicitly defined rejection handler is encountered

**Note:** We'll cover more details of error handling with Promises a little later, because there are other nuanced details to be concerned about.

If a proper valid function is not passed as the fulfillment handler parameter to `then(..)`, there's also a default handler substituted:

```js
var p = Promise.resolve( 42 );

p.then(
    // assumed fulfillment handler, if omitted or
    // any other non-function value passed
    // function(v) {
    //     return v;
    // }
    null,
    function rejected(err){
        // never gets here
    }
);
```

As you can see, the default fulfillment handler simply passes whatever value it receives along to the next step (Promise).

**Note:** The `then(null,function(err){ .. })` pattern -- only handling rejections (if any) but letting fulfillments pass through -- has a shortcut in the API: `catch(function(err){ .. })`. We'll cover `catch(..)` more fully in the next section.

Let's review briefly the intrinsic behaviors of Promises that enable chaining flow control:

* A `then(..)` call against one Promise automatically produces a new Promise to return from the call.
* Inside the fulfillment/rejection handlers, if you return a value or an exception is thrown, the new returned (chainable) Promise is resolved accordingly.
* If the fulfillment or rejection handler returns a Promise, it is unwrapped, so that whatever its resolution is will become the resolution of the chained Promise returned from the current `then(..)`.

While chaining flow control is helpful, it's probably most accurate to think of it as a side benefit of how Promises compose (combine) together, rather than the main intent
- As we've discussed in detail several times already, Promises normalize asynchrony and encapsulate time-dependent value state, and *that* is what lets us chain them together in this useful way

Certainly, the sequential expressiveness of the chain (this-then-this-then-this...) is a big improvement over the tangled mess of callbacks as we identified in Chapter 2
- But there's still a fair amount of boilerplate (`then(..)` and `function(){ .. }`) to wade through. In the next chapter, we'll see a significantly nicer pattern for sequential flow control expressivity, with generators

### Terminology: Resolve, Fulfill, and Reject

There's some slight confusion around the terms "resolve," "fulfill," and "reject" that we need to clear up, before you get too much deeper into learning about Promises. Let's first consider the `Promise(..)` constructor:

```js
var p = new Promise( function(X,Y){
    // X() for fulfillment
    // Y() for rejection
} );
```

As you can see, two callbacks (here labeled `X` and `Y`) are provided
- The first is *usually* used to mark the Promise as fulfilled, and the second *always* marks the Promise as rejected. But what's the "usually" about, and what does that imply about accurately naming those parameters?

Ultimately, it's just your user code and the identifier names aren't interpreted by the engine to mean anything, so it doesn't *technically* matter; `foo(..)` and `bar(..)` are equally functional
- But the words you use can affect not only how you are thinking about the code, but how other developers on your team will think about it
- Thinking wrongly about carefully orchestrated async code is almost surely going to be worse than the spaghetti-callback alternatives

So it actually does kind of matter what you call them.

The second parameter is easy to decide. Almost all literature uses `reject(..)` as its name, and because that's exactly (and only!) what it does, that's a very good choice for the name. I'd strongly recommend you always use `reject(..)`.

But there's a little more ambiguity around the first parameter, which in Promise literature is often labeled `resolve(..)`
- That word is obviously related to "resolution," which is what's used across the literature (including this book) to describe setting a final value/state to a Promise
- We've already used "resolve the Promise" several times to mean either fulfilling or rejecting the Promise

But if this parameter seems to be used to specifically fulfill the Promise, why shouldn't we call it `fulfill(..)` instead of `resolve(..)` to be more accurate? To answer that question, let's also take a look at two of the `Promise` API methods:

```js
var fulfilledPr = Promise.resolve( 42 );
var rejectedPr = Promise.reject( "Oops" );
```

`Promise.resolve(..)` creates a Promise that's resolved to the value given to it
- In this example, `42` is a normal, non-Promise, non-thenable value, so the fulfilled promise `fulfilledPr` is created for the value `42`
- `Promise.reject("Oops")` creates the rejected promise `rejectedPr` for the reason `"Oops"`

Let's now illustrate why the word "resolve" (such as in `Promise.resolve(..)`) is unambiguous and indeed more accurate, if used explicitly in a context that could result in either fulfillment or rejection:

```js
var rejectedTh = {
    then: function(resolved,rejected) {
        rejected( "Oops" );
    }
};

var rejectedPr = Promise.resolve( rejectedTh );
```

As we discussed earlier in this chapter, `Promise.resolve(..)` will return a received genuine Promise directly, or unwrap a received thenable
- If that thenable unwrapping reveals a rejected state, the Promise returned from `Promise.resolve(..)` is in fact in that same rejected state

So `Promise.resolve(..)` is a good, accurate name for the API method, because it can actually result in either fulfillment or rejection.

The first callback parameter of the `Promise(..)` constructor will unwrap either a thenable (identically to `Promise.resolve(..)`) or a genuine Promise:

```js
var rejectedPr = new Promise( function(resolve,reject){
    // resolve this promise with a rejected promise
    resolve( Promise.reject( "Oops" ) );
} );

rejectedPr.then(
    function fulfilled(){
        // never gets here
    },
    function rejected(err){
        console.log( err );	// "Oops"
    }
);
```

It should be clear now that `resolve(..)` is the appropriate name for the first callback parameter of the `Promise(..)` constructor.

**Warning:** The previously mentioned `reject(..)` does **not** do the unwrapping that `resolve(..)` does
- If you pass a Promise/thenable value to `reject(..)`, that untouched value will be set as the rejection reason
- A subsequent rejection handler would receive the actual Promise/thenable you passed to `reject(..)`, not its underlying immediate value

But now let's turn our attention to the callbacks provided to `then(..)`. What should they be called (both in literature and in code)? I would suggest `fulfilled(..)` and `rejected(..)`:

```js
function fulfilled(msg) {
    console.log( msg );
}

function rejected(err) {
    console.error( err );
}

p.then(
    fulfilled,
    rejected
);
```

In the case of the first parameter to `then(..)`, it's unambiguously always the fulfillment case, so there's no need for the duality of "resolve" terminology
- As a side note, the ES6 specification uses `onFulfilled(..)` and `onRejected(..)` to label these two callbacks, so they are accurate terms

## Error Handling

We've already seen several examples of how Promise rejection -- either intentional through calling `reject(..)` or accidental through JS exceptions -- allows saner error handling in asynchronous programming
- Let's circle back though and be explicit about some of the details that we glossed over

The most natural form of error handling for most developers is the synchronous `try..catch` construct
- Unfortunately, it's synchronous-only, so it fails to help in async code patterns:

```js
function foo() {
    setTimeout( function(){
        baz.bar();
    }, 100 );
}

try {
    foo();
    // later throws global error from `baz.bar()`
}
catch (err) {
    // never gets here
}
```

`try..catch` would certainly be nice to have, but it doesn't work across async operations
- That is, unless there's some additional environmental support, which we'll come back to with generators in Chapter 4

In callbacks, some standards have emerged for patterned error handling, most notably the "error-first callback" style:

```js
function foo(cb) {
    setTimeout( function(){
        try {
            var x = baz.bar();
            cb( null, x ); // success!
        }
        catch (err) {
            cb( err );
        }
    }, 100 );
}

foo( function(err,val){
    if (err) {
        console.error( err ); // bummer :(
    }
    else {
        console.log( val );
    }
} );
```

**Note:** The `try..catch` here works only from the perspective that the `baz.bar()` call will either succeed or fail immediately, synchronously
- If `baz.bar()` was itself its own async completing function, any async errors inside it would not be catchable

The callback we pass to `foo(..)` expects to receive a signal of an error by the reserved first parameter `err`
- If present, error is assumed. If not, success is assumed

This sort of error handling is technically *async capable*, but it doesn't compose well at all. Multiple levels of error-first callbacks woven together with these ubiquitous `if` statement checks inevitably will lead you to the perils of callback hell (see Chapter 2).

So we come back to error handling in Promises, with the rejection handler passed to `then(..)`. Promises don't use the popular "error-first callback" design style, but instead use "split callbacks" style; there's one callback for fulfillment and one for rejection:

```js
var p = Promise.reject( "Oops" );

p.then(
    function fulfilled(){
        // never gets here
    },
    function rejected(err){
        console.log( err ); // "Oops"
    }
);
```

While this pattern of error handling makes fine sense on the surface, the nuances of Promise error handling are often a fair bit more difficult to fully grasp.

Consider:

```js
var p = Promise.resolve( 42 );

p.then(
    function fulfilled(msg){
        // numbers don't have string functions,
        // so will throw an error
        console.log( msg.toLowerCase() );
    },
    function rejected(err){
        // never gets here
    }
);
```

If the `msg.toLowerCase()` legitimately throws an error (it does!), why doesn't our error handler get notified? As we explained earlier, it's because *that* error handler is for the `p` promise, which has already been fulfilled with value `42`
- The `p` promise is immutable, so the only promise that can be notified of the error is the one returned from `p.then(..)`, which in this case we don't capture

That should paint a clear picture of why error handling with Promises is error-prone (pun intended)
- It's far too easy to have errors swallowed, as this is very rarely what you'd intend

**Warning:** If you use the Promise API in an invalid way and an error occurs that prevents proper Promise construction, the result will be an immediately thrown exception, **not a rejected Promise**
- Some examples of incorrect usage that fail Promise construction: `new Promise(null)`, `Promise.all()`, `Promise.race(42)`, and so on. You can't get a rejected Promise if you don't use the Promise API validly enough to actually construct a Promise in the first place!

### Pit of Despair

Jeff Atwood noted years ago: programming languages are often set up in such a way that by default, developers fall into the "pit of despair" (http://blog.codinghorror.com/falling-into-the-pit-of-success/) -- where accidents are punished -- and that you have to try harder to get it right
- He implored us to instead create a "pit of success," where by default you fall into expected (successful) action, and thus would have to try hard to fail

Promise error handling is unquestionably "pit of despair" design. By default, it assumes that you want any error to be swallowed by the Promise state, and if you forget to observe that state, the error silently languishes/dies in obscurity -- usually despair.

To avoid losing an error to the silence of a forgotten/discarded Promise, some developers have claimed that a "best practice" for Promise chains is to always end your chain with a final `catch(..)`, like:

```js
var p = Promise.resolve( 42 );

p.then(
    function fulfilled(msg){
        // numbers don't have string functions,
        // so will throw an error
        console.log( msg.toLowerCase() );
    }
)
.catch( handleErrors );
```

Because we didn't pass a rejection handler to the `then(..)`, the default handler was substituted, which simply propagates the error to the next promise in the chain
- As such, both errors that come into `p`, and errors that come *after* `p` in its resolution (like the `msg.toLowerCase()` one) will filter down to the final `handleErrors(..)`

Problem solved, right? Not so fast!

What happens if `handleErrors(..)` itself also has an error in it?
- Who catches that? There's still yet another unattended promise: the one `catch(..)` returns, which we don't capture and don't register a rejection handler for

You can't just stick another `catch(..)` on the end of that chain, because it too could fail
- The last step in any Promise chain, whatever it is, always has the possibility, even decreasingly so, of dangling with an uncaught error stuck inside an unobserved Promise

Sound like an impossible conundrum yet?

### Uncaught Handling

It's not exactly an easy problem to solve completely. There are other ways to approach it which many would say are *better*.

Some Promise libraries have added methods for registering something like a "global unhandled rejection" handler, which would be called instead of a globally thrown error
- But their solution for how to identify an error as "uncaught" is to have an arbitrary-length timer, say 3 seconds, running from time of rejection
- If a Promise is rejected but no error handler is registered before the timer fires, then it's assumed that you won't ever be registering a handler, so it's "uncaught"

In practice, this has worked well for many libraries, as most usage patterns don't typically call for significant delay between Promise rejection and observation of that rejection
- But this pattern is troublesome because 3 seconds is so arbitrary (even if empirical), and also because there are indeed some cases where you want a Promise to hold on to its rejectedness for some indefinite period of time, and you don't really want to have your "uncaught" handler called for all those false positives (not-yet-handled "uncaught errors")

Another more common suggestion is that Promises should have a `done(..)` added to them, which essentially marks the Promise chain as "done"
- `done(..)` doesn't create and return a Promise, so the callbacks passed to `done(..)` are obviously not wired up to report problems to a chained Promise that doesn't exist

So what happens instead? It's treated as you might usually expect in uncaught error conditions: any exception inside a `done(..)` rejection handler would be thrown as a global uncaught error (in the developer console, basically):

```js
var p = Promise.resolve( 42 );

p.then(
    function fulfilled(msg){
        // numbers don't have string functions,
        // so will throw an error
        console.log( msg.toLowerCase() );
    }
)
.done( null, handleErrors );

// if `handleErrors(..)` caused its own exception, it would
// be thrown globally here
```

This might sound more attractive than the never-ending chain or the arbitrary timeouts
- But the biggest problem is that it's not part of the ES6 standard, so no matter how good it sounds, at best it's a lot longer way off from being a reliable and ubiquitous solution

Are we just stuck, then? Not entirely.

Browsers have a unique capability that our code does not have: they can track and know for sure when any object gets thrown away and garbage collected
- So, browsers can track Promise objects, and whenever they get garbage collected, if they have a rejection in them, the browser knows for sure this was a legitimate "uncaught error," and can thus confidently know it should report it to the developer console.

**Note:** At the time of this writing, both Chrome and Firefox have early attempts at that sort of "uncaught rejection" capability, though support is incomplete at best.

However, if a Promise doesn't get garbage collected -- it's exceedingly easy for that to accidentally happen through lots of different coding patterns -- the browser's garbage collection sniffing won't help you know and diagnose that you have a silently rejected Promise laying around.

Is there any other alternative? Yes.

### Pit of Success

The following is just theoretical, how Promises *could* be someday changed to behave
- I believe it would be far superior to what we currently have
- And I think this change would be possible even post-ES6 because I don't think it would break web compatibility with ES6 Promises
- Moreover, it can be polyfilled/prollyfilled in, if you're careful. Let's take a look:

* Promises could default to reporting (to the developer console) any rejection, on the next Job or event loop tick, if at that exact moment no error handler has been registered for the Promise.
* For the cases where you want a rejected Promise to hold onto its rejected state for an indefinite amount of time before observing, you could call `defer()`, which suppresses automatic error reporting on that Promise.

If a Promise is rejected, it defaults to noisily reporting that fact to the developer console (instead of defaulting to silence). You can opt out of that reporting either implicitly (by registering an error handler before rejection), or explicitly (with `defer()`). In either case, *you* control the false positives.

Consider:

```js
var p = Promise.reject( "Oops" ).defer();

// `foo(..)` is Promise-aware
foo( 42 )
.then(
    function fulfilled(){
      return p;
    },
    function rejected(err){
        // handle `foo(..)` error
    }
);
...
```

When we create `p`, we know we're going to wait a while to use/observe its rejection, so we call `defer()` -- thus no global reporting
- `defer()` simply returns the same promise, for chaining purposes

The promise returned from `foo(..)` gets an error handler attached *right away*, so it's implicitly opted out and no global reporting for it occurs either.

But the promise returned from the `then(..)` call has no `defer()` or error handler attached, so if it rejects (from inside either resolution handler), then *it* will be reported to the developer console as an uncaught error.

**This design is a pit of success.** By default, all errors are either handled or reported -- what almost all developers in almost all cases would expect
- You either have to register a handler or you have to intentionally opt out, and indicate you intend to defer error handling until *later*; you're opting for the extra responsibility in just that specific case

The only real danger in this approach is if you `defer()` a Promise but then fail to actually ever observe/handle its rejection.

But you had to intentionally call `defer()` to opt into that pit of despair -- the default was the pit of success -- so there's not much else we could do to save you from your own mistakes.

I think there's still hope for Promise error handling (post-ES6)
- I hope the powers that be will rethink the situation and consider this alternative
- In the meantime, you can implement this yourself (a challenging exercise for the reader!), or use a *smarter* Promise library that does so for you!

**Note:** This exact model for error handling/reporting is implemented in my *asynquence* Promise abstraction library, which will be discussed in Appendix A of this book.

## Promise Patterns

We've already implicitly seen the sequence pattern with Promise chains (this-then-this-then-that flow control) but there are lots of variations on asynchronous patterns that we can build as abstractions on top of Promises
- These patterns serve to simplify the expression of async flow control -- which helps make our code more reason-able and more maintainable -- even in the most complex parts of our programs

Two such patterns are codified directly into the native ES6 `Promise` implementation, so we get them for free, to use as building blocks for other patterns.

### Promise.all([ .. ])

In an async sequence (Promise chain), only one async task is being coordinated at any given moment -- step 2 strictly follows step 1, and step 3 strictly follows step 2. But what about doing two or more steps concurrently (aka "in parallel")?

In classic programming terminology, a "gate" is a mechanism that waits on two or more parallel/concurrent tasks to complete before continuing
- It doesn't matter what order they finish in, just that all of them have to complete for the gate to open and let the flow control through

In the Promise API, we call this pattern `all([ .. ])`.

Say you wanted to make two Ajax requests at the same time, and wait for both to finish, regardless of their order, before making a third Ajax request. Consider:

```js
// `request(..)` is a Promise-aware Ajax utility,
// like we defined earlier in the chapter

var p1 = request( "http://some.url.1/" );
var p2 = request( "http://some.url.2/" );

Promise.all( [p1,p2] )
.then( function(msgs){
    // both `p1` and `p2` fulfill and pass in
    // their messages here
    return request(
        "http://some.url.3/?v=" + msgs.join(",")
    );
} )
.then( function(msg){
    console.log( msg );
} );
```

`Promise.all([ .. ])` expects a single argument, an `array`, consisting generally of Promise instances
- The promise returned from the `Promise.all([ .. ])` call will receive a fulfillment message (`msgs` in this snippet) that is an `array` of all the fulfillment messages from the passed in promises, in the same order as specified (regardless of fulfillment order)

**Note:** Technically, the `array` of values passed into `Promise.all([ .. ])` can include Promises, thenables, or even immediate values
- Each value in the list is essentially passed through `Promise.resolve(..)` to make sure it's a genuine Promise to be waited on, so an immediate value will just be normalized into a Promise for that value
- If the `array` is empty, the main Promise is immediately fulfilled

The main promise returned from `Promise.all([ .. ])` will only be fulfilled if and when all its constituent promises are fulfilled. If any one of those promises instead is rejected, the main `Promise.all([ .. ])` promise is immediately rejected, discarding all results from any other promises.

Remember to always attach a rejection/error handler to every promise, even and especially the one that comes back from `Promise.all([ .. ])`.

### Promise.race([ .. ])

While `Promise.all([ .. ])` coordinates multiple Promises concurrently and assumes all are needed for fulfillment, sometimes you only want to respond to the "first Promise to cross the finish line," letting the other Promises fall away.

This pattern is classically called a "latch," but in Promises it's called a "race."

**Warning:** While the metaphor of "only the first across the finish line wins" fits the behavior well, unfortunately "race" is kind of a loaded term, because "race conditions" are generally taken as bugs in programs (see Chapter 1)
- Don't confuse `Promise.race([ .. ])` with "race condition"

`Promise.race([ .. ])` also expects a single `array` argument, containing one or more Promises, thenables, or immediate values. It doesn't make much practical sense to have a race with immediate values, because the first one listed will obviously win -- like a foot race where one runner starts at the finish line!

Similar to `Promise.all([ .. ])`, `Promise.race([ .. ])` will fulfill if and when any Promise resolution is a fulfillment, and it will reject if and when any Promise resolution is a rejection.

**Warning:** A "race" requires at least one "runner," so if you pass an empty `array`, instead of immediately resolving, the main `race([..])` Promise will never resolve
- This is a footgun! ES6 should have specified that it either fulfills, rejects, or just throws some sort of synchronous error. Unfortunately, because of precedence in Promise libraries predating ES6 `Promise`, they had to leave this gotcha in there, so be careful never to send in an empty `array`

Let's revisit our previous concurrent Ajax example, but in the context of a race between `p1` and `p2`:

```js
// `request(..)` is a Promise-aware Ajax utility,
// like we defined earlier in the chapter

var p1 = request( "http://some.url.1/" );
var p2 = request( "http://some.url.2/" );

Promise.race( [p1,p2] )
.then( function(msg){
    // either `p1` or `p2` will win the race
    return request(
        "http://some.url.3/?v=" + msg
    );
} )
.then( function(msg){
    console.log( msg );
} );
```

Because only one promise wins, the fulfillment value is a single message, not an `array` as it was for `Promise.all([ .. ])`.

#### Timeout Race

We saw this example earlier, illustrating how `Promise.race([ .. ])` can be used to express the "promise timeout" pattern:

```js
// `foo()` is a Promise-aware function

// `timeoutPromise(..)`, defined ealier, returns
// a Promise that rejects after a specified delay

// setup a timeout for `foo()`
Promise.race( [
    foo(),  // attempt `foo()`
    timeoutPromise( 3000 )  // give it 3 seconds
] )
.then(
    function(){
      // `foo(..)` fulfilled in time!
    },
    function(err){
        // either `foo()` rejected, or it just
        // didn't finish in time, so inspect
        // `err` to know which
    }
);
```

This timeout pattern works well in most cases
- But there are some nuances to consider, and frankly they apply to both `Promise.race([ .. ])` and `Promise.all([ .. ])` equally

#### "Finally"

The key question to ask is, "What happens to the promises that get discarded/ignored?"
- We're not asking that question from the performance perspective -- they would typically end up garbage collection eligible -- but from the behavioral perspective (side effects, etc.)
- Promises cannot be canceled -- and shouldn't be as that would destroy the external immutability trust discussed in the "Promise Uncancelable" section later in this chapter -- so they can only be silently ignored

But what if `foo()` in the previous example is reserving some sort of resource for usage, but the timeout fires first and causes that promise to be ignored?
- Is there anything in this pattern that proactively frees the reserved resource after the timeout, or otherwise cancels any side effects it may have had? What if all you wanted was to log the fact that `foo()` timed out?

Some developers have proposed that Promises need a `finally(..)` callback registration, which is always called when a Promise resolves, and allows you to specify any cleanup that may be necessary
- This doesn't exist in the specification at the moment, but it may come in ES7+. We'll have to wait and see

It might look like:

```js
var p = Promise.resolve( 42 );

p.then( something )
.finally( cleanup )
.then( another )
.finally( cleanup );
```

**Note:** In various Promise libraries, `finally(..)` still creates and returns a new Promise (to keep the chain going)
- If the `cleanup(..)` function were to return a Promise, it would be linked into the chain, which means you could still have the unhandled rejection issues we discussed earlier

In the meantime, we could make a static helper utility that lets us observe (without interfering) the resolution of a Promise:

```js
// polyfill-safe guard check
if (!Promise.observe) {
    Promise.observe = function(pr,cb) {
        // side-observe `pr`'s resolution
        pr.then(
            function fulfilled(msg){
                // schedule callback async (as Job)
                Promise.resolve( msg ).then( cb );
            },
            function rejected(err){
                // schedule callback async (as Job)
                Promise.resolve( err ).then( cb );
            }
        );

        // return original promise
        return pr;
    };
}
```

Here's how we'd use it in the timeout example from before:

```js
Promise.race( [
    Promise.observe(
        foo(),  // attempt `foo()`
        function cleanup(msg){
            // clean up after `foo()`, even if it
            // didn't finish before the timeout
        }
    ),
    timeoutPromise( 3000 )	// give it 3 seconds
] )
```

This `Promise.observe(..)` helper is just an illustration of how you could observe the completions of Promises without interfering with them. Other Promise libraries have their own solutions
- Regardless of how you do it, you'll likely have places where you want to make sure your Promises aren't *just* silently ignored by accident

### Variations on all([ .. ]) and race([ .. ])

While native ES6 Promises come with built-in `Promise.all([ .. ])` and `Promise.race([ .. ])`, there are several other commonly used patterns with variations on those semantics:

* `none([ .. ])` is like `all([ .. ])`, but fulfillments and rejections are transposed. All Promises need to be rejected -- rejections become the fulfillment values and vice versa.
* `any([ .. ])` is like `all([ .. ])`, but it ignores any rejections, so only one needs to fulfill instead of *all* of them.
* `first([ .. ])` is like a race with `any([ .. ])`, which is that it ignores any rejections and fulfills as soon as the first Promise fulfills.
* `last([ .. ])` is like `first([ .. ])`, but only the latest fulfillment wins.

Some Promise abstraction libraries provide these, but you could also define them yourself using the mechanics of Promises, `race([ .. ])` and `all([ .. ])`.

For example, here's how we could define `first([ .. ])`:

```js
// polyfill-safe guard check
if (!Promise.first) {
    Promise.first = function(prs) {
        return new Promise( function(resolve,reject){
            // loop through all promises
            prs.forEach( function(pr){
                // normalize the value
                Promise.resolve( pr )
                // whichever one fulfills first wins, and
                // gets to resolve the main promise
                .then( resolve );
            } );
        } );
    };
}
```

**Note:** This implementation of `first(..)` does not reject if all its promises reject; it simply hangs, much like a `Promise.race([])` does
- If desired, you could add additional logic to track each promise rejection and if all reject, call `reject()` on the main promise. We'll leave that as an exercise for the reader

### Concurrent Iterations

Sometimes you want to iterate over a list of Promises and perform some task against all of them, much like you can do with synchronous `array`s (e.g., `forEach(..)`, `map(..)`, `some(..)`, and `every(..)`)
- If the task to perform against each Promise is fundamentally synchronous, these work fine, just as we used `forEach(..)` in the previous snippet

But if the tasks are fundamentally asynchronous, or can/should otherwise be performed concurrently, you can use async versions of these utilities as provided by many libraries.

For example, let's consider an asynchronous `map(..)` utility that takes an `array` of values (could be Promises or anything else), plus a function (task) to perform against each
- `map(..)` itself returns a promise whose fulfillment value is an `array` that holds (in the same mapping order) the async fulfillment value from each task:

```js
if (!Promise.map) {
    Promise.map = function(vals,cb) {
        // new promise that waits for all mapped promises
        return Promise.all(
            // note: regular array `map(..)`, turns
            // the array of values into an array of
            // promises
            vals.map( function(val){
                // replace `val` with a new promise that
                // resolves after `val` is async mapped
                return new Promise( function(resolve){
                    cb( val, resolve );
                } );
            } )
        );
    };
}
```

**Note:** In this implementation of `map(..)`, you can't signal async rejection, but if a synchronous exception/error occurs inside of the mapping callback (`cb(..)`), the main `Promise.map(..)` returned promise would reject.

Let's illustrate using `map(..)` with a list of Promises (instead of simple values):

```js
var p1 = Promise.resolve( 21 );
var p2 = Promise.resolve( 42 );
var p3 = Promise.reject( "Oops" );

// double values in list even if they're in
// Promises
Promise.map( [p1,p2,p3], function(pr,done){
    // make sure the item itself is a Promise
    Promise.resolve( pr )
    .then(
        // extract value as `v`
        function(v){
            // map fulfillment `v` to new value
            done( v * 2 );
        },
        // or, map to promise rejection message
        done
    );
} )
.then( function(vals){
    console.log( vals );  // [42,84,"Oops"]
} );
```

## Promise API Recap

Let's review the ES6 `Promise` API that we've already seen unfold in bits and pieces throughout this chapter.

**Note:** The following API is native only as of ES6, but there are specification-compliant polyfills (not just extended Promise libraries) which can define `Promise` and all its associated behavior so that you can use native Promises even in pre-ES6 browsers
- One such polyfill is "Native Promise Only" (http://github.com/getify/native-promise-only), which I wrote!

### new Promise(..) Constructor

The *revealing constructor* `Promise(..)` must be used with `new`, and must be provided a function callback that is synchronously/immediately called
- This function is passed two function callbacks that act as resolution capabilities for the promise. We commonly label these `resolve(..)` and `reject(..)`:

```js
var p = new Promise( function(resolve,reject){
    // `resolve(..)` to resolve/fulfill the promise
    // `reject(..)` to reject the promise
} );
```

`reject(..)` simply rejects the promise, but `resolve(..)` can either fulfill the promise or reject it, depending on what it's passed
- If `resolve(..)` is passed an immediate, non-Promise, non-thenable value, then the promise is fulfilled with that value

But if `resolve(..)` is passed a genuine Promise or thenable value, that value is unwrapped recursively, and whatever its final resolution/state is will be adopted by the promise.

### Promise.resolve(..) and Promise.reject(..)

A shortcut for creating an already-rejected Promise is `Promise.reject(..)`, so these two promises are equivalent:

```js
var p1 = new Promise( function(resolve,reject){
    reject( "Oops" );
} );

var p2 = Promise.reject( "Oops" );
```

`Promise.resolve(..)` is usually used to create an already-fulfilled Promise in a similar way to `Promise.reject(..)`
- However, `Promise.resolve(..)` also unwraps thenable values (as discussed several times already)
- In that case, the Promise returned adopts the final resolution of the thenable you passed in, which could either be fulfillment or rejection:

```js
var fulfilledTh = {
    then: function(cb) { cb( 42 ); }
};
var rejectedTh = {
    then: function(cb,errCb) {
        errCb( "Oops" );
    }
};

var p1 = Promise.resolve( fulfilledTh );
var p2 = Promise.resolve( rejectedTh );

// `p1` will be a fulfilled promise
// `p2` will be a rejected promise
```

And remember, `Promise.resolve(..)` doesn't do anything if what you pass is already a genuine Promise; it just returns the value directly
- So there's no overhead to calling `Promise.resolve(..)` on values that you don't know the nature of, if one happens to already be a genuine Promise

### then(..) and catch(..)

Each Promise instance (**not** the `Promise` API namespace) has `then(..)` and `catch(..)` methods, which allow registering of fulfillment and rejection handlers for the Promise
- Once the Promise is resolved, one or the other of these handlers will be called, but not both, and it will always be called asynchronously (see "Jobs" in Chapter 1)

`then(..)` takes one or two parameters, the first for the fulfillment callback, and the second for the rejection callback
- If either is omitted or is otherwise passed as a non-function value, a default callback is substituted respectively
- The default fulfillment callback simply passes the message along, while the default rejection callback simply rethrows (propagates) the error reason it receives

`catch(..)` takes only the rejection callback as a parameter, and automatically substitutes the default fulfillment callback, as just discussed. In other words, it's equivalent to `then(null,..)`:

```js
p.then( fulfilled );
p.then( fulfilled, rejected );
p.catch( rejected ); // or `p.then( null, rejected )`
```

`then(..)` and `catch(..)` also create and return a new promise, which can be used to express Promise chain flow control
- If the fulfillment or rejection callbacks have an exception thrown, the returned promise is rejected
- If either callback returns an immediate, non-Promise, non-thenable value, that value is set as the fulfillment for the returned promise
- If the fulfillment handler specifically returns a promise or thenable value, that value is unwrapped and becomes the resolution of the returned promise

### Promise.all([ .. ]) and Promise.race([ .. ])

The static helpers `Promise.all([ .. ])` and `Promise.race([ .. ])` on the ES6 `Promise` API both create a Promise as their return value
- The resolution of that promise is controlled entirely by the array of promises that you pass in

For `Promise.all([ .. ])`, all the promises you pass in must fulfill for the returned promise to fulfill
- If any promise is rejected, the main returned promise is immediately rejected, too (discarding the results of any of the other promises)
- For fulfillment, you receive an `array` of all the passed in promises' fulfillment values. For rejection, you receive just the first promise rejection reason value
- This pattern is classically called a "gate": all must arrive before the gate opens

For `Promise.race([ .. ])`, only the first promise to resolve (fulfillment or rejection) "wins," and whatever that resolution is becomes the resolution of the returned promise
- This pattern is classically called a "latch": first one to open the latch gets through. Consider:

```js
var p1 = Promise.resolve( 42 );
var p2 = Promise.resolve( "Hello World" );
var p3 = Promise.reject( "Oops" );

Promise.race( [p1,p2,p3] )
.then( function(msg){
    console.log( msg ); // 42
} );

Promise.all( [p1,p2,p3] )
.catch( function(err){
    console.error( err ); // "Oops"
} );

Promise.all( [p1,p2] )
.then( function(msgs){
    console.log( msgs );  // [42,"Hello World"]
} );
```

**Warning:** Be careful! If an empty `array` is passed to `Promise.all([ .. ])`, it will fulfill immediately, but `Promise.race([ .. ])` will hang forever and never resolve.

The ES6 `Promise` API is pretty simple and straightforward
- It's at least good enough to serve the most basic of async cases, and is a good place to start when rearranging your code from callback hell to something better

But there's a whole lot of async sophistication that apps often demand which Promises themselves will be limited in addressing
- In the next section, we'll dive into those limitations as motivations for the benefit of Promise libraries

## Promise Limitations

Many of the details we'll discuss in this section have already been alluded to in this chapter, but we'll just make sure to review these limitations specifically.

### Sequence Error Handling

We covered Promise-flavored error handling in detail earlier in this chapter
- The limitations of how Promises are designed -- how they chain, specifically -- creates a very easy pitfall where an error in a Promise chain can be silently ignored accidentally

But there's something else to consider with Promise errors
- Because a Promise chain is nothing more than its constituent Promises wired together, there's no entity to refer to the entire chain as a single *thing*, which means there's no external way to observe any errors that may occur

If you construct a Promise chain that has no error handling in it, any error anywhere in the chain will propagate indefinitely down the chain, until observed (by registering a rejection handler at some step)
- So, in that specific case, having a reference to the *last* promise in the chain is enough (`p` in the following snippet), because you can register a rejection handler there, and it will be notified of any propagated errors:

```js
// `foo(..)`, `STEP2(..)` and `STEP3(..)` are
// all promise-aware utilities

var p = foo( 42 )
.then( STEP2 )
.then( STEP3 );
```

Although it may seem sneakily confusing, `p` here doesn't point to the first promise in the chain (the one from the `foo(42)` call), but instead from the last promise, the one that comes from the `then(STEP3)` call.

Also, no step in the promise chain is observably doing its own error handling
- That means that you could then register a rejection error handler on `p`, and it would be notified if any errors occur anywhere in the chain:

```
p.catch( handleErrors );
```

But if any step of the chain in fact does its own error handling (perhaps hidden/abstracted away from what you can see), your `handleErrors(..)` won't be notified
- This may be what you want -- it was, after all, a "handled rejection" -- but it also may *not* be what you want
- The complete lack of ability to be notified (of "already handled" rejection errors) is a limitation that restricts capabilities in some use cases

It's basically the same limitation that exists with a `try..catch` that can catch an exception and simply swallow it
- So this isn't a limitation **unique to Promises**, but it *is* something we might wish to have a workaround for

Unfortunately, many times there is no reference kept for the intermediate steps in a Promise-chain sequence, so without such references, you cannot attach error handlers to reliably observe the errors.

### Single Value

Promises by definition only have a single fulfillment value or a single rejection reason. In simple examples, this isn't that big of a deal, but in more sophisticated scenarios, you may find this limiting.

The typical advice is to construct a values wrapper (such as an `object` or `array`) to contain these multiple messages
- This solution works, but it can be quite awkward and tedious to wrap and unwrap your messages with every single step of your Promise chain

#### Splitting Values

Sometimes you can take this as a signal that you could/should decompose the problem into two or more Promises.

# Chapter 4: Generators

In Chapter 2, we identified two key drawbacks to expressing async flow control with callbacks:

* Callback-based async doesn't fit how our brain plans out steps of a task.
* Callbacks aren't trustable or composable because of *inversion of control*.

In Chapter 3, we detailed how Promises uninvert the *inversion of control* of callbacks, restoring trustability/composability.

Now we turn our attention to expressing async flow control in a sequential, synchronous-looking fashion
- The "magic" that makes it possible is ES6 **generators**

## Breaking Run-to-Completion

In Chapter 1, we explained an expectation that JS developers almost universally rely on in their code: once a function starts executing, it runs until it completes, and no other code can interrupt and run in between.

As bizarre as it may seem, ES6 introduces a new type of function that does not behave with the run-to-completion behavior
- This new type of function is called a "generator"

To understand the implications, let's consider this example:

```js
var x = 1;

function foo() {
    x++;
    bar();  // <-- what about this line?
	console.log( "x:", x );
}

function bar() {
    x++;
}

foo();					// x: 3
```

In this example, we know for sure that `bar()` runs in between `x++` and `console.log(x)`
- But what if `bar()` wasn't there? Obviously, the result would be `2` instead of `3

Now let's twist your brain. What if `bar()` wasn't present, but it could still somehow run between the `x++` and `console.log(x)` statements? How would that be possible?

In **preemptive** multithreaded languages, it would essentially be possible for `bar()` to "interrupt" and run at exactly the right moment between those two statements
- But JS is not preemptive, nor is it (currently) multithreaded. And yet, a **cooperative** form of this "interruption" (concurrency) is possible, if `foo()` itself could somehow indicate a "pause" at that part in the code

**Note:** I use the word "cooperative" not only because of the connection to classical concurrency terminology (see Chapter 1), but because as you'll see in the next snippet, the ES6 syntax for indicating a pause point in code is `yield` -- suggesting a politely *cooperative* yielding of control.

Here's the ES6 code to accomplish such cooperative concurrency:

```js
var x = 1;

function *foo() {
    x++;
    yield; // pause!
    console.log( "x:", x );
}

function bar() {
    x++;
}
```

**Note:** You will likely see most other JS documentation/code that will format a generator declaration as `function* foo() { .. }` instead of as I've done here with `function *foo() { .. }` -- the only difference being the stylistic positioning of the `*`
- The two forms are functionally/syntactically identical, as is a third `function*foo() { .. }` (no space) form
- There are arguments for both styles, but I basically prefer `function *foo..` because it then matches when I reference a generator in writing with `*foo()`
- If I said only `foo()`, you wouldn't know as clearly if I was talking about a generator or a regular function
- It's purely a stylistic preference

Now, how can we run the code in that previous snippet such that `bar()` executes at the point of the `yield` inside of `*foo()`?

```js
// construct an iterator `it` to control the generator
var it = foo();

// start `foo()` here!
it.next();
x;  // 2
bar();
x;  // 3
it.next();  // x: 3
```

OK, there's quite a bit of new and potentially confusing stuff in those two code snippets, so we've got plenty to wade through
- But before we explain the different mechanics/syntax with ES6 generators, let's walk through the behavior flow:

1. The `it = foo()` operation does *not* execute the `*foo()` generator yet, but it merely constructs an *iterator* that will control its execution. More on *iterators* in a bit.
2. The first `it.next()` starts the `*foo()` generator, and runs the `x++` on the first line of `*foo()`.
3. `*foo()` pauses at the `yield` statement, at which point that first `it.next()` call finishes. At the moment, `*foo()` is still running and active, but it's in a paused state.
4. We inspect the value of `x`, and it's now `2`.
5. We call `bar()`, which increments `x` again with `x++`.
6. We inspect the value of `x` again, and it's now `3`.
7. The final `it.next()` call resumes the `*foo()` generator from where it was paused, and runs the `console.log(..)` statement, which uses the current value of `x` of `3`.

Clearly, `*foo()` started, but did *not* run-to-completion -- it paused at the `yield`. We resumed `*foo()` later, and let it finish, but that wasn't even required.

So, a generator is a special kind of function that can start and stop one or more times, and doesn't necessarily ever have to finish
- While it won't be terribly obvious yet why that's so powerful, as we go throughout the rest of this chapter, that will be one of the fundamental building blocks we use to construct generators-as-async-flow-control as a pattern for our code

### Input and Output

A generator function is a special function with the new processing model we just alluded to
- But it's still a function, which means it still has some basic tenets that haven't changed -- namely, that it still accepts arguments (aka "input"), and that it can still return a value (aka "output"):

```js
function *foo(x,y) {
    return x * y;
}

var it = foo( 6, 7 );
var res = it.next();

res.value;  // 42
```

We pass in the arguments `6` and `7` to `*foo(..)` as the parameters `x` and `y`, respectively
- And `*foo(..)` returns the value `42` back to the calling code

We now see a difference with how the generator is invoked compared to a normal function. `foo(6,7)` obviously looks familiar
- But subtly, the `*foo(..)` generator hasn't actually run yet as it would have with a function

Instead, we're just creating an *iterator* object, which we assign to the variable `it`, to control the `*foo(..)` generator
- Then we call `it.next()`, which instructs the `*foo(..)` generator to advance from its current location, stopping either at the next `yield` or end of the generator

The result of that `next(..)` call is an object with a `value` property on it holding whatever value (if anything) was returned from `*foo(..)`
- In other words, `yield` caused a value to be sent out from the generator during the middle of its execution, kind of like an intermediate `return`

Again, it won't be obvious yet why we need this whole indirect *iterator* object to control the generator. We'll get there, I *promise*.

#### Iteration Messaging

In addition to generators accepting arguments and having return values, there's even more powerful and compelling input/output messaging capability built into them, via `yield` and `next(..)`.

Consider:

```js
function *foo(x) {
    var y = x * (yield);
    return y;
}

var it = foo( 6 );

// start `foo(..)`
it.next();

var res = it.next( 7 );

res.value;  // 42
```

First, we pass in `6` as the parameter `x`. Then we call `it.next()`, and it starts up `*foo(..)`.

Inside `*foo(..)`, the `var y = x ..` statement starts to be processed, but then it runs across a `yield` expression
- At that point, it pauses `*foo(..)` (in the middle of the assignment statement!), and essentially requests the calling code to provide a result value for the `yield` expression
- Next, we call `it.next( 7 )`, which is passing the `7` value back in to *be* that result of the paused `yield` expression

So, at this point, the assignment statement is essentially `var y = 6 * 7`
- Now, `return y` returns that `42` value back as the result of the `it.next( 7 )` call

Notice something very important but also easily confusing, even to seasoned JS developers: depending on your perspective, there's a mismatch between the `yield` and the `next(..)` call
- In general, you're going to have one more `next(..)` call than you have `yield` statements -- the preceding snippet has one `yield` and two `next(..)` calls

Why the mismatch?

Because the first `next(..)` always starts a generator, and runs to the first `yield`. But it's the second `next(..)` call that fulfills the first paused `yield` expression, and the third `next(..)` would fulfill the second `yield`, and so on.

##### Tale of Two Questions

Actually, which code you're thinking about primarily will affect whether there's a perceived mismatch or not.

Consider only the generator code:

```js
var y = x * (yield);
return y;
```

This **first** `yield` is basically *asking a question*: "What value should I insert here?"

Who's going to answer that question? Well, the **first** `next()` has already run to get the generator up to this point, so obviously *it* can't answer the question
- So, the **second** `next(..)` call must answer the question *posed* by the **first** `yield`

See the mismatch -- second-to-first?

But let's flip our perspective. Let's look at it not from the generator's point of view, but from the iterator's point of view.

To properly illustrate this perspective, we also need to explain that messages can go in both directions -- `yield ..` as an expression can send out messages in response to `next(..)` calls, and `next(..)` can send values to a paused `yield` expression. Consider this slightly adjusted code:

```js
function *foo(x) {
    var y = x * (yield "Hello");  // <-- yield a value!
    return y;
}

var it = foo( 6 );

var res = it.next();  // first `next()`, don't pass anything
res.value;  // "Hello"

res = it.next( 7 ); // pass `7` to waiting `yield`
res.value;  // 42
```

`yield ..` and `next(..)` pair together as a two-way message passing system **during the execution of the generator**.

So, looking only at the *iterator* code:

```js
var res = it.next();  // first `next()`, don't pass anything
res.value;  // "Hello"

res = it.next( 7 ); // pass `7` to waiting `yield`
res.value;  // 42
```

**Note:** We don't pass a value to the first `next()` call, and that's on purpose
- Only a paused `yield` could accept such a value passed by a `next(..)`, and at the beginning of the generator when we call the first `next()`, there **is no paused `yield`** to accept such a value
- The specification and all compliant browsers just silently **discard** anything passed to the first `next()`
- It's still a bad idea to pass a value, as you're just creating silently "failing" code that's confusing
- So, always start a generator with an argument-free `next()`

The first `next()` call (with nothing passed to it) is basically *asking a question*: "What *next* value does the `*foo(..)` generator have to give me?" And who answers this question? The first `yield "hello"` expression.

See? No mismatch there.

Depending on *who* you think about asking the question, there is either a mismatch between the `yield` and `next(..)` calls, or not.

But wait! There's still an extra `next()` compared to the number of `yield` statements
- So, that final `it.next(7)` call is again asking the question about what *next* value the generator will produce
- But there's no more `yield` statements left to answer, is there? So who answers?

The `return` statement answers the question!

And if there **is no `return`** in your generator -- `return` is certainly not any more required in generators than in regular functions -- there's always an assumed/implicit `return;` (aka `return undefined;`), which serves the purpose of default answering the question *posed* by the final `it.next(7)` call.

These questions and answers -- the two-way message passing with `yield` and `next(..)` -- are quite powerful, but it's not obvious at all how these mechanisms are connected to async flow control. We're getting there!

### Multiple Iterators

It may appear from the syntactic usage that when you use an *iterator* to control a generator, you're controlling the declared generator function itself
- But there's a subtlety that's easy to miss: each time you construct an *iterator*, you are implicitly constructing an instance of the generator which that *iterator* will control

You can have multiple instances of the same generator running at the same time, and they can even interact:

```js
function *foo() {
    var x = yield 2;
    z++;
    var y = yield (x * z);
    console.log( x, y, z );
}

var z = 1;

var it1 = foo();
var it2 = foo();

var val1 = it1.next().value;  // 2 <-- yield 2
var val2 = it2.next().value;  // 2 <-- yield 2

val1 = it1.next( val2 * 10 ).value; // 40  <-- x:20,  z:2
val2 = it2.next( val1 * 5 ).value;  // 600 <-- x:200, z:3

it1.next( val2 / 2 ); // y:300
				      // 20 300 3
it2.next( val1 / 4 ); // y:10
					  // 200 10 3
```

**Warning:** The most common usage of multiple instances of the same generator running concurrently is not such interactions, but when the generator is producing its own values without input, perhaps from some independently connected resource
- We'll talk more about value production in the next section

Let's briefly walk through the processing:

1. Both instances of `*foo()` are started at the same time, and both `next()` calls reveal a `value` of `2` from the `yield 2` statements, respectively.
2. `val2 * 10` is `2 * 10`, which is sent into the first generator instance `it1`, so that `x` gets value `20`. `z` is incremented from `1` to `2`, and then `20 * 2` is `yield`ed out, setting `val1` to `40`.
3. `val1 * 5` is `40 * 5`, which is sent into the second generator instance `it2`, so that `x` gets value `200`. `z` is incremented again, from `2` to `3`, and then `200 * 3` is `yield`ed out, setting `val2` to `600`.
4. `val2 / 2` is `600 / 2`, which is sent into the first generator instance `it1`, so that `y` gets value `300`, then printing out `20 300 3` for its `x y z` values, respectively.
5. `val1 / 4` is `40 / 4`, which is sent into the second generator instance `it2`, so that `y` gets value `10`, then printing out `200 10 3` for its `x y z` values, respectively.

That's a "fun" example to run through in your mind. Did you keep it straight?

#### Interleaving

Recall this scenario from the "Run-to-completion" section of Chapter 1:

```js
var a = 1;
var b = 2;

function foo() {
    a++;
    b = b * a;
    a = b + 3;
}

function bar() {
    b--;
    a = 8 + b;
    b = a * 2;
}
```

With normal JS functions, of course either `foo()` can run completely first, or `bar()` can run completely first, but `foo()` cannot interleave its individual statements with `bar()`
-So, there are only two possible outcomes to the preceding program

However, with generators, clearly interleaving (even in the middle of statements!) is possible:

```js
var a = 1;
var b = 2;

function *foo() {
    a++;
    yield;
    b = b * a;
    a = (yield b) + 3;
}

function *bar() {
    b--;
    yield;
    a = (yield 8) + b;
    b = a * (yield 2);
}
```

Depending on what respective order the *iterators* controlling `*foo()` and `*bar()` are called, the preceding program could produce several different results
- In other words, we can actually illustrate (in a sort of fake-ish way) the theoretical "threaded race conditions" circumstances discussed in Chapter 1, by interleaving the two generator iterations over the same shared variables

First, let's make a helper called `step(..)` that controls an *iterator*:

```js
function step(gen) {
    var it = gen();
    var last;

    return function() {
        // whatever is `yield`ed out, just
        // send it right back in the next time!
        last = it.next( last ).value;
    };
}
```

`step(..)` initializes a generator to create its `it` *iterator*, then returns a function which, when called, advances the *iterator* by one step
- Additionally, the previously `yield`ed out value is sent right back in at the *next* step
- So, `yield 8` will just become `8` and `yield b` will just be `b` (whatever it was at the time of `yield`)

Now, just for fun, let's experiment to see the effects of interleaving these different chunks of `*foo()` and `*bar()`
- We'll start with the boring base case, making sure `*foo()` totally finishes before `*bar()` (just like we did in Chapter 1):

```js
// make sure to reset `a` and `b`
a = 1;
b = 2;

var s1 = step( foo );
var s2 = step( bar );

// run `*foo()` completely first
s1();
s1();
s1();

// now run `*bar()`
s2();
s2();
s2();
s2();

console.log( a, b );  // 11 22
```

The end result is `11` and `22`, just as it was in the Chapter 1 version
- Now let's mix up the interleaving ordering and see how it changes the final values of `a` and `b`:

```js
// make sure to reset `a` and `b`
a = 1;
b = 2;

var s1 = step( foo );
var s2 = step( bar );

s2(); // b--;
s2(); // yield 8
s1(); // a++;
s2(); // a = 8 + b;
      // yield 2
s1(); // b = b * a;
      // yield b
s1(); // a = b + 3;
s2(); // b = a * 2;
```

Before I tell you the results, can you figure out what `a` and `b` are after the preceding program? No cheating!

```js
console.log( a, b );  // 12 18
```

**Note:** As an exercise for the reader, try to see how many other combinations of results you can get back rearranging the order of the `s1()` and `s2()` calls. Don't forget you'll always need three `s1()` calls and four `s2()` calls
- Recall the discussion earlier about matching `next()` with `yield` for the reasons why

You almost certainly won't want to intentionally create *this* level of interleaving confusion, as it creates incredibly difficult to understand code
-But the exercise is interesting and instructive to understand more about how multiple generators can run concurrently in the same shared scope, because there will be places where this capability is quite useful

We'll discuss generator concurrency in more detail at the end of this chapter.

## Generator'ing Values

In the previous section, we mentioned an interesting use for generators, as a way to produce values
- This is **not** the main focus in this chapter, but we'd be remiss if we didn't cover the basics, especially because this use case is essentially the origin of the name: generators

We're going to take a slight diversion into the topic of *iterators* for a bit, but we'll circle back to how they relate to generators and using a generator to *generate* values.

### Producers and Iterators

Imagine you're producing a series of values where each value has a definable relationship to the previous value
- To do this, you're going to need a stateful producer that remembers the last value it gave out

You can implement something like that straightforwardly using a function closure (see the *Scope & Closures* title of this series):

```js
var gimmeSomething = (function(){
    var nextVal;

    return function(){
        if (nextVal === undefined) {
        nextVal = 1;
        }
        else {
            nextVal = (3 * nextVal) + 6;
        }

        return nextVal;
    };
})();

gimmeSomething(); // 1
gimmeSomething(); // 9
gimmeSomething(); // 33
gimmeSomething(); // 105
```

**Note:** The `nextVal` computation logic here could have been simplified, but conceptually, we don't want to calculate the *next value* (aka `nextVal`) until the *next* `gimmeSomething()` call happens, because in general that could be a resource-leaky design for producers of more persistent or resource-limited values than simple `number`s.

Generating an arbitrary number series isn't a terribly realistic example
- But what if you were generating records from a data source? You could imagine much the same code

In fact, this task is a very common design pattern, usually solved by iterators
- An *iterator* is a well-defined interface for stepping through a series of values from a producer
- The JS interface for iterators, as it is in most languages, is to call `next()` each time you want the next value from the producer

We could implement the standard *iterator* interface for our number series producer:

```js
var something = (function(){
    var nextVal;

    return {
        // needed for `for..of` loops
        [Symbol.iterator]: function(){ return this; },

        // standard iterator interface method
        next: function(){
            if (nextVal === undefined) {
                nextVal = 1;
            }
            else {
                nextVal = (3 * nextVal) + 6;
			}

            return { done:false, value:nextVal };
        }
    };
})();

something.next().value; // 1
something.next().value; // 9
something.next().value; // 33
something.next().value; // 105
```

**Note:** We'll explain why we need the `[Symbol.iterator]: ..` part of this code snippet in the "Iterables" section. Syntactically though, two ES6 features are at play
- First, the `[ .. ]` syntax is called a *computed property name* (see the *this & Object Prototypes* title of this series)
- It's a way in an object literal definition to specify an expression and use the result of that expression as the name for the property
- Next, `Symbol.iterator` is one of ES6's predefined special `Symbol` values (see the *ES6 & Beyond* title of this book series)

The `next()` call returns an object with two properties: `done` is a `boolean` value signaling the *iterator's* complete status; `value` holds the iteration value.

ES6 also adds the `for..of` loop, which means that a standard *iterator* can automatically be consumed with native loop syntax:

```js
for (var v of something) {
    console.log( v );

    // don't let the loop run forever!
    if (v > 500) {
        break;
    }
}
// 1 9 33 105 321 969
```

**Note:** Because our `something` *iterator* always returns `done:false`, this `for..of` loop would run forever, which is why we put the `break` conditional in
- It's totally OK for iterators to be never-ending, but there are also cases where the *iterator* will run over a finite set of values and eventually return a `done:true`

The `for..of` loop automatically calls `next()` for each iteration -- it doesn't pass any values in to the `next()` -- and it will automatically terminate on receiving a `done:true`
- It's quite handy for looping over a set of data

Of course, you could manually loop over iterators, calling `next()` and checking for the `done:true` condition to know when to stop:

```js
for (
    var ret;
    (ret = something.next()) && !ret.done;
) {
    console.log( ret.value );

    // don't let the loop run forever!
    if (ret.value > 500) {
        break;
    }
}
// 1 9 33 105 321 969
```

**Note:** This manual `for` approach is certainly uglier than the ES6 `for..of` loop syntax, but its advantage is that it affords you the opportunity to pass in values to the `next(..)` calls if necessary.

In addition to making your own *iterators*, many built-in data structures in JS (as of ES6), like `array`s, also have default *iterators*:

```js
var a = [1,3,5,7,9];

for (var v of a) {
    console.log( v );
}
// 1 3 5 7 9
```

The `for..of` loop asks `a` for its *iterator*, and automatically uses it to iterate over `a`'s values.

**Note:** It may seem a strange omission by ES6, but regular `object`s intentionally do not come with a default *iterator* the way `array`s do
- The reasons go deeper than we will cover here
- If all you want is to iterate over the properties of an object (with no particular guarantee of ordering), `Object.keys(..)` returns an `array`, which can then be used like `for (var k of Object.keys(obj)) { ..`
- Such a `for..of` loop over an object's keys would be similar to a `for..in` loop, except that `Object.keys(..)` does not include properties from the `[[Prototype]]` chain while `for..in` does (see the *this & Object Prototypes* title of this series)

### Iterables

The `something` object in our running example is called an *iterator*, as it has the `next()` method on its interface
- But a closely related term is *iterable*, which is an `object` that **contains** an *iterator* that can iterate over its values

As of ES6, the way to retrieve an *iterator* from an *iterable* is that the *iterable* must have a function on it, with the name being the special ES6 symbol value `Symbol.iterator`
- When this function is called, it returns an *iterator*. Though not required, generally each call should return a fresh new *iterator*

`a` in the previous snippet is an *iterable*
- The `for..of` loop automatically calls its `Symbol.iterator` function to construct an *iterator*
- But we could of course call the function manually, and use the *iterator* it returns:

```js
var a = [1,3,5,7,9];

var it = a[Symbol.iterator]();

it.next().value;  // 1
it.next().value;  // 3
it.next().value;  // 5
..
```

In the previous code listing that defined `something`, you may have noticed this line:

```js
[Symbol.iterator]: function(){ return this; }
```

That little bit of confusing code is making the `something` value -- the interface of the `something` *iterator* -- also an *iterable*; it's now both an *iterable* and an *iterator*
- Then, we pass `something` to the `for..of` loop:

```js
for (var v of something) {
    ..
}
```

The `for..of` loop expects `something` to be an *iterable*, so it looks for and calls its `Symbol.iterator` function
- We defined that function to simply `return this`, so it just gives itself back, and the `for..of` loop is none the wiser

### Generator Iterator

Let's turn our attention back to generators, in the context of *iterators*
- A generator can be treated as a producer of values that we extract one at a time through an *iterator* interface's `next() calls

So, a generator itself is not technically an *iterable*, though it's very similar -- when you execute the generator, you get an *iterator* back:

```js
function *foo(){ .. }
var it = foo();
```

We can implement the `something` infinite number series producer from earlier with a generator, like this:

```js
function *something() {
    var nextVal;

    while (true) {
        if (nextVal === undefined) {
            nextVal = 1;
        }
        else {
            nextVal = (3 * nextVal) + 6;
        }

        yield nextVal;
    }
}
```

**Note:** A `while..true` loop would normally be a very bad thing to include in a real JS program, at least if it doesn't have a `break` or `return` in it, as it would likely run forever, synchronously, and block/lock-up the browser UI.
- However, in a generator, such a loop is generally totally OK if it has a `yield` in it, as the generator will pause at each iteration, `yield`ing back to the main program and/or to the event loop queue
- To put it glibly, "generators put the `while..true` back in JS programming!"

That's a fair bit cleaner and simpler, right?
- Because the generator pauses at each `yield`, the state (scope) of the function `*something()` is kept around, meaning there's no need for the closure boilerplate to preserve variable state across calls

Not only is it simpler code -- we don't have to make our own *iterator* interface -- it actually is more reason-able code, because it more clearly expresses the intent
- For example, the `while..true` loop tells us the generator is intended to run forever -- to keep *generating* values as long as we keep asking for them

And now we can use our shiny new `*something()` generator with a `for..of` loop, and you'll see it works basically identically:

```js
for (var v of something()) {
    console.log( v );

    // don't let the loop run forever!
    if (v > 500) {
        break;
    }
}
// 1 9 33 105 321 969
```

But don't skip over `for (var v of something()) ..`!
- We didn't just reference `something` as a value like in earlier examples, but instead called the `*something()` generator to get its *iterator* for the `for..of` loop to use

If you're paying close attention, two questions may arise from this interaction between the generator and the loop:

* Why couldn't we say `for (var v of something) ..`? Because `something` here is a generator, which is not an *iterable*. We have to call `something()` to construct a producer for the `for..of` loop to iterate over.
* The `something()` call produces an *iterator*, but the `for..of` loop wants an *iterable*, right? Yep. The generator's *iterator* also has a `Symbol.iterator` function on it, which basically does a `return this`, just like the `something` *iterable* we defined earlier. In other words, a generator's *iterator* is also an *iterable*!

#### Stopping the Generator

In the previous example, it would appear the *iterator* instance for the `*something()` generator was basically left in a suspended state forever after the `break` in the loop was called.

But there's a hidden behavior that takes care of that for you. "Abnormal completion" (i.e., "early termination") of the `for..of` loop -- generally caused by a `break`, `return`, or an uncaught exception -- sends a signal to the generator's *iterator* for it to terminate.

**Note:** Technically, the `for..of` loop also sends this signal to the *iterator* at the normal completion of the loop
- For a generator, that's essentially a moot operation, as the generator's *iterator* had to complete first so the `for..of` loop completed
- However, custom *iterators* might desire to receive this additional signal from `for..of` loop consumers

While a `for..of` loop will automatically send this signal, you may wish to send the signal manually to an *iterator*; you do this by calling `return(..)`.

If you specify a `try..finally` clause inside the generator, it will always be run even when the generator is externally completed
- This is useful if you need to clean up resources (database connections, etc.):

```js
function *something() {
    try {
        var nextVal;

        while (true) {
            if (nextVal === undefined) {
                nextVal = 1;
            }
            else {
                nextVal = (3 * nextVal) + 6;
            }

            yield nextVal;
        }
    }
    // cleanup clause
    finally {
        console.log( "cleaning up!" );
    }
}
```

The earlier example with `break` in the `for..of` loop will trigger the `finally` clause
- But you could instead manually terminate the generator's *iterator* instance from the outside with `return(..)`:

```js
var it = something();
for (var v of it) {
    console.log( v );

    // don't let the loop run forever!
    if (v > 500) {
        console.log(
            // complete the generator's iterator
            it.return( "Hello World" ).value
        );
        // no `break` needed here
    }
}
// 1 9 33 105 321 969
// cleaning up!
// Hello World
```

When we call `it.return(..)`, it immediately terminates the generator, which of course runs the `finally` clause
- Also, it sets the returned `value` to whatever you passed in to `return(..)`, which is how `"Hello World"` comes right back out
- We also don't need to include a `break` now because the generator's *iterator* is set to `done:true`, so the `for..of` loop will terminate on its next iteration

Generators owe their namesake mostly to this *consuming produced values* use. But again, that's just one of the uses for generators, and frankly not even the main one we're concerned with in the context of this book.

But now that we more fully understand some of the mechanics of how they work, we can *next* turn our attention to how generators apply to async concurrency.

## Iterating Generators Asynchronously

What do generators have to do with async coding patterns, fixing problems with callbacks, and the like? Let's get to answering that important question.

We should revisit one of our scenarios from Chapter 3. Let's recall the callback approach:

```js
function foo(x,y,cb) {
    ajax(
        "http://some.url.1/?x=" + x + "&y=" + y,
        cb
    );
}

foo( 11, 31, function(err,text) {
    if (err) {
        console.error( err );
    }
    else {
        console.log( text );
    }
} );
```

If we wanted to express this same task flow control with a generator, we could do:

```js
function foo(x,y) {
    ajax(
        "http://some.url.1/?x=" + x + "&y=" + y,
        function(err,data){
            if (err) {
                // throw an error into `*main()`
                it.throw( err );
            }
            else {
                // resume `*main()` with received `data`
                it.next( data );
            }
        }
    );
}

function *main() {
    try {
        var text = yield foo( 11, 31 );
        console.log( text );
    }
    catch (err) {
        console.error( err );
    }
}

var it = main();

// start it all up!
it.next();
```

At first glance, this snippet is longer, and perhaps a little more complex looking, than the callback snippet before it
- But don't let that impression get you off track. The generator snippet is actually **much** better!
- But there's a lot going on for us to explain

First, let's look at this part of the code, which is the most important:

```js
var text = yield foo( 11, 31 );
console.log( text );
```

Think about how that code works for a moment. We're calling a normal function `foo(..)` and we're apparently able to get back the `text` from the Ajax call, even though it's asynchronous.

How is that possible? If you recall the beginning of Chapter 1, we had almost identical code:

```js
var data = ajax( "..url 1.." );
console.log( data );
```

And that code didn't work! Can you spot the difference? It's the `yield` used in a generator.

That's the magic! That's what allows us to have what appears to be blocking, synchronous code, but it doesn't actually block the whole program; it only pauses/blocks the code in the generator itself.

In `yield foo(11,31)`, first the `foo(11,31)` call is made, which returns nothing (aka `undefined`), so we're making a call to request data, but we're actually then doing `yield undefined`
- That's OK, because the code is not currently relying on a `yield`ed value to do anything interesting. We'll revisit this point later in the chapter

We're not using `yield` in a message passing sense here, only in a flow control sense to pause/block
- Actually, it will have message passing, but only in one direction, after the generator is resumed

So, the generator pauses at the `yield`, essentially asking the question, "what value should I return to assign to the variable `text`?" Who's going to answer that question?

Look at `foo(..)`. If the Ajax request is successful, we call:

```js
it.next( data );
```

That's resuming the generator with the response data, which means that our paused `yield` expression receives that value directly, and then as it restarts the generator code, that value gets assigned to the local variable `text`.

Pretty cool, huh?

Take a step back and consider the implications
- We have totally synchronous-looking code inside the generator (other than the `yield` keyword itself), but hidden behind the scenes, inside of `foo(..)`, the operations can complete asynchronously

**That's huge!** That's a nearly perfect solution to our previously stated problem with callbacks not being able to express asynchrony in a sequential, synchronous fashion that our brains can relate to.

In essence, we are abstracting the asynchrony away as an implementation detail, so that we can reason synchronously/sequentially about our flow control: "Make an Ajax request, and when it finishes print out the response."
- And of course, we just expressed two steps in the flow control, but this same capability extends without bounds, to let us express however many steps we need to

**Tip:** This is such an important realization, just go back and read the last three paragraphs again to let it sink in!

### Synchronous Error Handling

But the preceding generator code has even more goodness to *yield* to us. Let's turn our attention to the `try..catch` inside the generator:

```js
try {
    var text = yield foo( 11, 31 );
    console.log( text );
}
catch (err) {
    console.error( err );
}
```

How does this work? The `foo(..)` call is asynchronously completing, and doesn't `try..catch` fail to catch asynchronous errors, as we looked at in Chapter 3?

We already saw how the `yield` lets the assignment statement pause to wait for `foo(..)` to finish, so that the completed response can be assigned to `text`
- The awesome part is that this `yield` pausing *also* allows the generator to `catch` an error
- We throw that error into the generator with this part of the earlier code listing:

```js
if (err) {
    // throw an error into `*main()`
    it.throw( err );
}
```

The `yield`-pause nature of generators means that not only do we get synchronous-looking `return` values from async function calls, but we can also synchronously `catch` errors from those async function calls!

So we've seen we can throw errors *into* a generator, but what about throwing errors *out of* a generator? Exactly as you'd expect:

```js
function *main() {
    var x = yield "Hello World";
    yield x.toLowerCase();	// cause an exception!
}

var it = main();

it.next().value;  // Hello World

try {
    it.next( 42 );
}
catch (err) {
    console.error( err ); // TypeError
}
```

Of course, we could have manually thrown an error with `throw ..` instead of causing an exception.

We can even `catch` the same error that we `throw(..)` into the generator, essentially giving the generator a chance to handle it but if it doesn't, the *iterator* code must handle it:

```js
function *main() {
    var x = yield "Hello World";

    // never gets here
    console.log( x );
}

var it = main();

it.next();

try {
    // will `*main()` handle this error? we'll see!
    it.throw( "Oops" );
}
catch (err) {
    // nope, didn't handle it!
    console.error( err ); // Oops
}
```

Synchronous-looking error handling (via `try..catch`) with async code is a huge win for readability and reason-ability.

## Generators + Promises

In our previous discussion, we showed how generators can be iterated asynchronously, which is a huge step forward in sequential reason-ability over the spaghetti mess of callbacks
- But we lost something very important: the trustability and composability of Promises (see Chapter 3)!

Don't worry -- we can get that back. The best of all worlds in ES6 is to combine generators (synchronous-looking async code) with Promises (trustable and composable).

But how?

Recall from Chapter 3 the Promise-based approach to our running Ajax example:

```js
function foo(x,y) {
    return request(
        "http://some.url.1/?x=" + x + "&y=" + y
    );
}

foo( 11, 31 )
.then(
    function(text){
        console.log( text );
    },
    function(err){
        console.error( err );
    }
);
```

In our earlier generator code for the running Ajax example, `foo(..)` returned nothing (`undefined`), and our *iterator* control code didn't care about that `yield`ed value.

But here the Promise-aware `foo(..)` returns a promise after making the Ajax call
- That suggests that we could construct a promise with `foo(..)` and then `yield` it from the generator, and then the *iterator* control code would receive that promise

But what should the *iterator* do with the promise?

It should listen for the promise to resolve (fulfillment or rejection), and then either resume the generator with the fulfillment message or throw an error into the generator with the rejection reason.

Let me repeat that, because it's so important
- The natural way to get the most out of Promises and generators is **to `yield` a Promise**, and wire that Promise to control the generator's *iterator*

Let's give it a try! First, we'll put the Promise-aware `foo(..)` together with the generator `*main()`:

```js
function foo(x,y) {
    return request(
        "http://some.url.1/?x=" + x + "&y=" + y
    );
}

function *main() {
    try {
        var text = yield foo( 11, 31 );
        console.log( text );
    }
    catch (err) {
        console.error( err );
    }
}
```

The most powerful revelation in this refactor is that the code inside `*main()` **did not have to change at all!**
- Inside the generator, whatever values are `yield`ed out is just an opaque implementation detail, so we're not even aware it's happening, nor do we need to worry about it

But how are we going to run `*main()` now?
- We still have some of the implementation plumbing work to do, to receive and wire up the `yield`ed promise so that it resumes the generator upon resolution. We'll start by trying that manually:

```js
var it = main();

var p = it.next().value;

// wait for the `p` promise to resolve
p.then(
    function(text){
        it.next( text );
    },
    function(err){
        it.throw( err );
    }
);
```

Actually, that wasn't so painful at all, was it?

This snippet should look very similar to what we did earlier with the manually wired generator controlled by the error-first callback
- Instead of an `if (err) { it.throw..`, the promise already splits fulfillment (success) and rejection (failure) for us, but otherwise the *iterator* control is identical

Now, we've glossed over some important details.

Most importantly, we took advantage of the fact that we knew that `*main()` only had one Promise-aware step in it
- What if we wanted to be able to Promise-drive a generator no matter how many steps it has?
- We certainly don't want to manually write out the Promise chain differently for each generator!
- What would be much nicer is if there was a way to repeat (aka "loop" over) the iteration control, and each time a Promise comes out, wait on its resolution before continuing

Also, what if the generator throws out an error (intentionally or accidentally) during the `it.next(..)` call? Should we quit, or should we `catch` it and send it right back in?
- Similarly, what if we `it.throw(..)` a Promise rejection into the generator, but it's not handled, and comes right back out?

### Promise-Aware Generator Runner

The more you start to explore this path, the more you realize, "wow, it'd be great if there was just some utility to do it for me"
- And you're absolutely correct
- This is such an important pattern, and you don't want to get it wrong (or exhaust yourself repeating it over and over), so your best bet is to use a utility that is specifically designed to *run* Promise-`yield`ing generators in the manner we've illustrated

Several Promise abstraction libraries provide just such a utility, including my *asynquence* library and its `runner(..)`, which will be discussed in Appendix A of this book.

But for the sake of learning and illustration, let's just define our own standalone utility that we'll call `run(..)`:

```js
// thanks to Benjamin Gruenbaum (@benjamingr on GitHub) for
// big improvements here!
function run(gen) {
    var args = [].slice.call( arguments, 1), it;

    // initialize the generator in the current context
    it = gen.apply( this, args );

    // return a promise for the generator completing
    return Promise.resolve()
        .then( function handleNext(value){
            // run to the next yielded value
            var next = it.next( value );

            return (function handleResult(next){
                // generator has completed running?
                if (next.done) {
                    return next.value;
                }
                // otherwise keep going
                else {
                    return Promise.resolve( next.value )
                        .then(
                            // resume the async loop on
                            // success, sending the resolved
                            // value back into the generator
                            handleNext,

                            // if `value` is a rejected
                            // promise, propagate error back
                            // into the generator for its own
                            // error handling
                            function handleErr(err) {
                                return Promise.resolve(
                                    it.throw( err )
                                )
                                .then( handleResult );
                            }
                        );
                }
            })(next);
        } );
}
```

As you can see, it's a quite a bit more complex than you'd probably want to author yourself, and you especially wouldn't want to repeat this code for each generator you use
- So, a utility/library helper is definitely the way to go
- Nevertheless, I encourage you to spend a few minutes studying that code listing to get a better sense of how to manage the generator+Promise negotiation

How would you use `run(..)` with `*main()` in our *running* Ajax example?

```js
function *main() {
    // ..
}

run( main );
```

That's it! The way we wired `run(..)`, it will automatically advance the generator you pass to it, asynchronously until completion.

**Note:** The `run(..)` we defined returns a promise which is wired to resolve once the generator is complete, or receive an uncaught exception if the generator doesn't handle it
- We don't show that capability here, but we'll come back to it later in the chapter

#### ES7: `async` and `await`?

The preceding pattern -- generators yielding Promises that then control the generator's *iterator* to advance it to completion -- is such a powerful and useful approach, it would be nicer if we could do it without the clutter of the library utility helper (aka `run(..)`).

There's probably good news on that front. At the time of this writing, there's early but strong support for a proposal for more syntactic addition in this realm for the post-ES6, ES7-ish timeframe
- Obviously, it's too early to guarantee the details, but there's a pretty decent chance it will shake out similar to the following:

```js
function foo(x,y) {
    return request(
        "http://some.url.1/?x=" + x + "&y=" + y
    );
}

async function main() {
    try {
        var text = await foo( 11, 31 );
        console.log( text );
    }
    catch (err) {
        console.error( err );
    }
}

main();
```

As you can see, there's no `run(..)` call (meaning no need for a library utility!) to invoke and drive `main()` -- it's just called as a normal function
- Also, `main()` isn't declared as a generator function anymore; it's a new kind of function: `async function`
- And finally, instead of `yield`ing a Promise, we `await` for it to resolve

The `async function` automatically knows what to do if you `await` a Promise -- it will pause the function (just like with generators) until the Promise resolves
- We didn't illustrate it in this snippet, but calling an async function like `main()` automatically returns a promise that's resolved whenever the function finishes completely

**Tip:** The `async` / `await` syntax should look very familiar to readers with  experience in C#, because it's basically identical.

The proposal essentially codifies support for the pattern we've already derived, into a syntactic mechanism: combining Promises with sync-looking flow control code
- That's the best of both worlds combined, to effectively address practically all of the major concerns we outlined with callbacks

The mere fact that such a ES7-ish proposal already exists and has early support and enthusiasm is a major vote of confidence in the future importance of this async pattern.

### Promise Concurrency in Generators

So far, all we've demonstrated is a single-step async flow with Promises+generators
0 But real-world code will often have many async steps

If you're not careful, the sync-looking style of generators may lull you into complacency with how you structure your async concurrency, leading to suboptimal performance patterns
- So we want to spend a little time exploring the options

Imagine a scenario where you need to fetch data from two different sources, then combine those responses to make a third request, and finally print out the last response
- We explored a similar scenario with Promises in Chapter 3, but let's reconsider it in the context of generators

Your first instinct might be something like:

```js
function *foo() {
    var r1 = yield request( "http://some.url.1" );
    var r2 = yield request( "http://some.url.2" );

    var r3 = yield request(
        "http://some.url.3/?v=" + r1 + "," + r2
    );

    console.log( r3 );
}

// use previously defined `run(..)` utility
run( foo );
```

This code will work, but in the specifics of our scenario, it's not optimal. Can you spot why?

Because the `r1` and `r2` requests can -- and for performance reasons, *should* -- run concurrently, but in this code they will run sequentially; the `"http://some.url.2"` URL isn't Ajax fetched until after the `"http://some.url.1"` request is finished
- These two requests are independent, so the better performance approach would likely be to have them run at the same time

But how exactly would you do that with a generator and `yield`? We know that `yield` is only a single pause point in the code, so you can't really do two pauses at the same time.

The most natural and effective answer is to base the async flow on Promises, specifically on their capability to manage state in a time-independent fashion (see "Future Value" in Chapter 3).

The simplest approach:

```js
function *foo() {
    // make both requests "in parallel"
    var p1 = request( "http://some.url.1" );
    var p2 = request( "http://some.url.2" );

    // wait until both promises resolve
    var r1 = yield p1;
    var r2 = yield p2;

    var r3 = yield request(
        "http://some.url.3/?v=" + r1 + "," + r2
    );

    console.log( r3 );
}

// use previously defined `run(..)` utility
run( foo );
```

Why is this different from the previous snippet? Look at where the `yield` is and is not. `p1` and `p2` are promises for Ajax requests made concurrently (aka "in parallel")
- It doesn't matter which one finishes first, because promises will hold onto their resolved state for as long as necessary

Then we use two subsequent `yield` statements to wait for and retrieve the resolutions from the promises (into `r1` and `r2`, respectively)
- If `p1` resolves first, the `yield p1` resumes first then waits on the `yield p2` to resume
- If `p2` resolves first, it will just patiently hold onto that resolution value until asked, but the `yield p1` will hold on first, until `p1` resolves

Either way, both `p1` and `p2` will run concurrently, and both have to finish, in either order, before the `r3 = yield request..` Ajax request will be made.

If that flow control processing model sounds familiar, it's basically the same as what we identified in Chapter 3 as the "gate" pattern, enabled by the `Promise.all([ .. ])` utility. So, we could also express the flow control like this:

```js
function *foo() {
    // make both requests "in parallel," and
    // wait until both promises resolve
    var results = yield Promise.all( [
        request( "http://some.url.1" ),
        request( "http://some.url.2" )
    ] );

    var r1 = results[0];
    var r2 = results[1];

    var r3 = yield request(
        "http://some.url.3/?v=" + r1 + "," + r2
    );

    console.log( r3 );
}

// use previously defined `run(..)` utility
run( foo );
```

**Note:** As we discussed in Chapter 3, we can even use ES6 destructuring assignment to simplify the `var r1 = .. var r2 = ..` assignments, with `var [r1,r2] = results`.

In other words, all of the concurrency capabilities of Promises are available to us in the generator+Promise approach
- So in any place where you need more than sequential this-then-that async flow control steps, Promises are likely your best bet

#### Promises, Hidden

As a word of stylistic caution, be careful about how much Promise logic you include **inside your generators**
- The whole point of using generators for asynchrony in the way we've described is to create simple, sequential, sync-looking code, and to hide as much of the details of asynchrony away from that code as possible

For example, this might be a cleaner approach:

```js
// note: normal function, not generator
function bar(url1,url2) {
    return Promise.all( [
        request( url1 ),
        request( url2 )
    ] );
}

function *foo() {
    // hide the Promise-based concurrency details
    // inside `bar(..)`
    var results = yield bar(
        "http://some.url.1",
        "http://some.url.2"
    );

    var r1 = results[0];
    var r2 = results[1];

    var r3 = yield request(
        "http://some.url.3/?v=" + r1 + "," + r2
    );

    console.log( r3 );
}

// use previously defined `run(..)` utility
run( foo );
```

Inside `*foo()`, it's cleaner and clearer that all we're doing is just asking `bar(..)` to get us some `results`, and we'll `yield`-wait on that to happen
- We don't have to care that under the covers a `Promise.all([ .. ])` Promise composition will be used to make that happen

**We treat asynchrony, and indeed Promises, as an implementation detail.**

Hiding your Promise logic inside a function that you merely call from your generator is especially useful if you're going to do a sophisticated series flow-control. For example:

```js
function bar() {
    return	Promise.all( [
        baz( .. )
        .then( .. ),
            Promise.race( [ .. ] )
        ] )
        .then( .. )
}
```

That kind of logic is sometimes required, and if you dump it directly inside your generator(s), you've defeated most of the reason why you would want to use generators in the first place. We *should* intentionally abstract such details away from our generator code so that they don't clutter up the higher level task expression.

Beyond creating code that is both functional and performant, you should also strive to make code that is as reason-able and maintainable as possible.

**Note:** Abstraction is not *always* a healthy thing for programming -- many times it can increase complexity in exchange for terseness
- But in this case, I believe it's much healthier for your generator+Promise async code than the alternatives
- As with all such advice, though, pay attention to your specific situations and make proper decisions for you and your team

## Generator Delegation

In the previous section, we showed calling regular functions from inside a generator, and how that remains a useful technique for abstracting away implementation details (like async Promise flow)
- But the main drawback of using a normal function for this task is that it has to behave by the normal function rules, which means it cannot pause itself with `yield` like a generator can

It may then occur to you that you might try to call one generator from another generator, using our `run(..)` helper, such as:

```js
function *foo() {
    var r2 = yield request( "http://some.url.2" );
    var r3 = yield request( "http://some.url.3/?v=" + r2 );

    return r3;
}

function *bar() {
    var r1 = yield request( "http://some.url.1" );

    // "delegating" to `*foo()` via `run(..)`
    var r3 = yield run( foo );

    console.log( r3 );
}

run( bar );
```

We run `*foo()` inside of `*bar()` by using our `run(..)` utility again
- We take advantage here of the fact that the `run(..)` we defined earlier returns a promise which is resolved when its generator is run to completion (or errors out), so if we `yield` out to a `run(..)` instance the promise from another `run(..)` call, it automatically pauses `*bar()` until `*foo()` finishes

But there's an even better way to integrate calling `*foo()` into `*bar()`, and it's called `yield`-delegation
- The special syntax for `yield`-delegation is: `yield * __` (notice the extra `*`)
- Before we see it work in our previous example, let's look at a simpler scenario:

```js
function *foo() {
    console.log( "`*foo()` starting" );
    yield 3;
    yield 4;
    console.log( "`*foo()` finished" );
}

function *bar() {
    yield 1;
    yield 2;
    yield *foo();	// `yield`-delegation!
    yield 5;
}

var it = bar();

it.next().value;  // 1
it.next().value;  // 2
it.next().value;  // `*foo()` starting
it.next().value;  // 4
                  // 3
it.next().value;  // `*foo()` finished
                  // 5
```

**Note:** Similar to a note earlier in the chapter where I explained why I prefer `function *foo() ..` instead of `function* foo() ..`,
- I also prefer -- differing from most other documentation on the topic -- to say `yield *foo()` instead of `yield* foo()`
- The placement of the `*` is purely stylistic and up to your best judgment. But I find the consistency of styling attractive

How does the `yield *foo()` delegation work?

First, calling `foo()` creates an *iterator* exactly as we've already seen
- Then, `yield *` delegates/transfers the *iterator* instance control (of the present `*bar()` generator) over to this other `*foo()` *iterator*

So, the first two `it.next()` calls are controlling `*bar()`, but when we make the third `it.next()` call, now `*foo()` starts up, and now we're controlling `*foo()` instead of `*bar()`
- That's why it's called delegation -- `*bar()` delegated its iteration control to `*foo()`

As soon as the `it` *iterator* control exhausts the entire `*foo()` *iterator*, it automatically returns to controlling `*bar()`.

So now back to the previous example with the three sequential Ajax requests:

```js
function *foo() {
    var r2 = yield request( "http://some.url.2" );
    var r3 = yield request( "http://some.url.3/?v=" + r2 );

    return r3;
}

function *bar() {
    var r1 = yield request( "http://some.url.1" );

    // "delegating" to `*foo()` via `yield*`
    var r3 = yield *foo();

    console.log( r3 );
}

run( bar );
```

The only difference between this snippet and the version used earlier is the use of `yield *foo()` instead of the previous `yield run(foo)`.

**Note:** `yield *` yields iteration control, not generator control; when you invoke the `*foo()` generator, you're now `yield`-delegating to its *iterator*
- But you can actually `yield`-delegate to any *iterable*; `yield *[1,2,3]` would consume the default *iterator* for the `[1,2,3]` array value

### Why Delegation?

The purpose of `yield`-delegation is mostly code organization, and in that way is symmetrical with normal function calling.

Imagine two modules that respectively provide methods `foo()` and `bar()`, where `bar()` calls `foo()`
- The reason the two are separate is generally because the proper organization of code for the program calls for them to be in separate functions
- For example, there may be cases where `foo()` is called standalone, and other places where `bar()` calls `foo()`

For all these exact same reasons, keeping generators separate aids in program readability, maintenance, and debuggability
- In that respect, `yield *` is a syntactic shortcut for manually iterating over the steps of `*foo()` while inside of `*bar()`

Such manual approach would be especially complex if the steps in `*foo()` were asynchronous, which is why you'd probably need to use that `run(..)` utility to do it
- And as we've shown, `yield *foo()` eliminates the need for a sub-instance of the `run(..)` utility (like `run(foo)`)

### Delegating Messages

You may wonder how this `yield`-delegation works not just with *iterator* control but with the two-way message passing. Carefully follow the flow of messages in and out, through the `yield`-delegation:

```js
function *foo() {
    console.log( "inside `*foo()`:", yield "B" );
    console.log( "inside `*foo()`:", yield "C" );

	return "D";
}

function *bar() {
    console.log( "inside `*bar()`:", yield "A" );

    // `yield`-delegation!
    console.log( "inside `*bar()`:", yield *foo() );

    console.log( "inside `*bar()`:", yield "E" );

    return "F";
}

var it = bar();

console.log( "outside:", it.next().value );
// outside: A

console.log( "outside:", it.next( 1 ).value );
// inside `*bar()`: 1
// outside: B

console.log( "outside:", it.next( 2 ).value );
// inside `*foo()`: 2
// outside: C

console.log( "outside:", it.next( 3 ).value );
// inside `*foo()`: 3
// inside `*bar()`: D
// outside: E

console.log( "outside:", it.next( 4 ).value );
// inside `*bar()`: 4
// outside: F
```

Pay particular attention to the processing steps after the `it.next(3)` call:

1. The `3` value is passed (through the `yield`-delegation in `*bar()`) into the waiting `yield "C"` expression inside of `*foo()`.
2. `*foo()` then calls `return "D"`, but this value doesn't get returned all the way back to the outside `it.next(3)` call.
3. Instead, the `"D"` value is sent as the result of the waiting `yield *foo()` expression inside of `*bar()` -- this `yield`-delegation expression has essentially been paused while all of `*foo()` was exhausted. So `"D"` ends up inside of `*bar()` for it to print out.
4. `yield "E"` is called inside of `*bar()`, and the `"E"` value is yielded to the outside as the result of the `it.next(3)` call.

From the perspective of the external *iterator* (`it`), it doesn't appear any differently between controlling the initial generator or a delegated one.

In fact, `yield`-delegation doesn't even have to be directed to another generator; it can just be directed to a non-generator, general *iterable*. For example:

```js
function *bar() {
    console.log( "inside `*bar()`:", yield "A" );

    // `yield`-delegation to a non-generator!
    console.log( "inside `*bar()`:", yield *[ "B", "C", "D" ] );

    console.log( "inside `*bar()`:", yield "E" );

    return "F";
}

var it = bar();

console.log( "outside:", it.next().value );
// outside: A

console.log( "outside:", it.next( 1 ).value );
// inside `*bar()`: 1
// outside: B

console.log( "outside:", it.next( 2 ).value );
// outside: C

console.log( "outside:", it.next( 3 ).value );
// outside: D

console.log( "outside:", it.next( 4 ).value );
// inside `*bar()`: undefined
// outside: E

console.log( "outside:", it.next( 5 ).value );
// inside `*bar()`: 5
// outside: F
```

Notice the differences in where the messages were received/reported between this example and the one previous.

Most strikingly, the default `array` *iterator* doesn't care about any messages sent in via `next(..)` calls, so the values `2`, `3`, and `4` are essentially ignored
- Also, because that *iterator* has no explicit `return` value (unlike the previously used `*foo()`), the `yield *` expression gets an `undefined` when it finishes

#### Exceptions Delegated, Too!

In the same way that `yield`-delegation transparently passes messages through in both directions, errors/exceptions also pass in both directions:

```js
function *foo() {
    try {
        yield "B";
    }
    catch (err) {
        console.log( "error caught inside `*foo()`:", err );
    }

    yield "C";

    throw "D";
}

function *bar() {
    yield "A";

    try {
        yield *foo();
    }
    catch (err) {
        console.log( "error caught inside `*bar()`:", err );
    }

    yield "E";

    yield *baz();

    // note: can't get here!
    yield "G";
}

function *baz() {
    throw "F";
}

var it = bar();

console.log( "outside:", it.next().value );
// outside: A

console.log( "outside:", it.next( 1 ).value );
// outside: B

console.log( "outside:", it.throw( 2 ).value );
// error caught inside `*foo()`: 2
// outside: C

console.log( "outside:", it.next( 3 ).value );
// error caught inside `*bar()`: D
// outside: E

try {
    console.log( "outside:", it.next( 4 ).value );
}
catch (err) {
    console.log( "error caught outside:", err );
}
// error caught outside: F
```

Some things to note from this snippet:

1. When we call `it.throw(2)`, it sends the error message `2` into `*bar()`, which delegates that to `*foo()`, which then `catch`es it and handles it gracefully. Then, the `yield "C"` sends `"C"` back out as the return `value` from the `it.throw(2)` call.
2. The `"D"` value that's next `throw`n from inside `*foo()` propagates out to `*bar()`, which `catch`es it and handles it gracefully. Then the `yield "E"` sends `"E"` back out as the return `value` from the `it.next(3)` call.
3. Next, the exception `throw`n from `*baz()` isn't caught in `*bar()` -- though we did `catch` it outside -- so both `*baz()` and `*bar()` are set to a completed state. After this snippet, you would not be able to get the `"G"` value out with any subsequent `next(..)` call(s) -- they will just return `undefined` for `value`.

### Delegating Asynchrony

Let's finally get back to our earlier `yield`-delegation example with the multiple sequential Ajax requests:

```js
function *foo() {
    var r2 = yield request( "http://some.url.2" );
    var r3 = yield request( "http://some.url.3/?v=" + r2 );

    return r3;
}

function *bar() {
    var r1 = yield request( "http://some.url.1" );

    var r3 = yield *foo();

    console.log( r3 );
}

run( bar );
```

Instead of calling `yield run(foo)` inside of `*bar()`, we just call `yield *foo()`.

In the previous version of this example, the Promise mechanism (controlled by `run(..)`) was used to transport the value from `return r3` in `*foo()` to the local variable `r3` inside `*bar()`
- Now, that value is just returned back directly via the `yield *` mechanics

Otherwise, the behavior is pretty much identical.

### Delegating "Recursion"

Of course, `yield`-delegation can keep following as many delegation steps as you wire up
- You could even use `yield`-delegation for async-capable generator "recursion" -- a generator `yield`-delegating to itself:

```js
function *foo(val) {
    if (val > 1) {
        // generator recursion
        val = yield *foo( val - 1 );
    }

    return yield request( "http://some.url/?v=" + val );
}

function *bar() {
    var r1 = yield *foo( 3 );
    console.log( r1 );
}

run( bar );
```

**Note:** Our `run(..)` utility could have been called with `run( foo, 3 )`, because it supports additional parameters being passed along to the initialization of the generator
- - However, we used a parameter-free `*bar()` here to highlight the flexibility of `yield *`

What processing steps follow from that code? Hang on, this is going to be quite intricate to describe in detail:

1. `run(bar)` starts up the `*bar()` generator.
2. `foo(3)` creates an *iterator* for `*foo(..)` and passes `3` as its `val` parameter.
3. Because `3 > 1`, `foo(2)` creates another *iterator* and passes in `2` as its `val` parameter.
4. Because `2 > 1`, `foo(1)` creates yet another *iterator* and passes in `1` as its `val` parameter.
5. `1 > 1` is `false`, so we next call `request(..)` with the `1` value, and get a promise back for that first Ajax call.
6. That promise is `yield`ed out, which comes back to the `*foo(2)` generator instance.
7. The `yield *` passes that promise back out to the `*foo(3)` generator instance. Another `yield *` passes the promise out to the `*bar()` generator instance. And yet again another `yield *` passes the promise out to the `run(..)` utility, which will wait on that promise (for the first Ajax request) to proceed.
8. When the promise resolves, its fulfillment message is sent to resume `*bar()`, which passes through the `yield *` into the `*foo(3)` instance, which then passes through the `yield *` to the `*foo(2)` generator instance, which then passes through the `yield *` to the normal `yield` that's waiting in the `*foo(3)` generator instance.
9. That first call's Ajax response is now immediately `return`ed from the `*foo(3)` generator instance, which sends that value back as the result of the `yield *` expression in the `*foo(2)` instance, and assigned to its local `val` variable.
10. Inside `*foo(2)`, a second Ajax request is made with `request(..)`, whose promise is `yield`ed back to the `*foo(1)` instance, and then `yield *` propagates all the way out to `run(..)` (step 7 again). When the promise resolves, the second Ajax response propagates all the way back into the `*foo(2)` generator instance, and is assigned to its local `val` variable.
11. Finally, the third Ajax request is made with `request(..)`, its promise goes out to `run(..)`, and then its resolution value comes all the way back, which is then `return`ed so that it comes back to the waiting `yield *` expression in `*bar()`.

Phew! A lot of crazy mental juggling, huh? You might want to read through that a few more times, and then go grab a snack to clear your head!

## Generator Concurrency

As we discussed in both Chapter 1 and earlier in this chapter, two simultaneously running "processes" can cooperatively interleave their operations, and many times this can *yield* (pun intended) very powerful asynchrony expressions.

Frankly, our earlier examples of concurrency interleaving of multiple generators showed how to make it really confusing. But we hinted that there's places where this capability is quite useful.

Recall a scenario we looked at in Chapter 1, where two different simultaneous Ajax response handlers needed to coordinate with each other to make sure that the data communication was not a race condition. We slotted the responses into the `res` array like this:

```js
function response(data) {
    if (data.url == "http://some.url.1") {
        res[0] = data;
    }
    else if (data.url == "http://some.url.2") {
        res[1] = data;
    }
}
```

But how can we use multiple generators concurrently for this scenario?

```js
// `request(..)` is a Promise-aware Ajax utility

var res = [];

function *reqData(url) {
    res.push(
        yield request( url )
    );
}
```

**Note:** We're going to use two instances of the `*reqData(..)` generator here, but there's no difference to running a single instance of two different generators; both approaches are reasoned about identically
- We'll see two different generators coordinating in just a bit

Instead of having to manually sort out `res[0]` and `res[1]` assignments, we'll use coordinated ordering so that `res.push(..)` properly slots the values in the expected and predictable order
- The expressed logic thus should feel a bit cleaner

But how will we actually orchestrate this interaction? First, let's just do it manually, with Promises:

```js
var it1 = reqData( "http://some.url.1" );
var it2 = reqData( "http://some.url.2" );

var p1 = it1.next().value;
var p2 = it2.next().value;

p1
.then( function(data){
    it1.next( data );
    return p2;
} )
.then( function(data){
    it2.next( data );
} );
```

`*reqData(..)`'s two instances are both started to make their Ajax requests, then paused with `yield`
- Then we choose to resume the first instance when `p1` resolves, and then `p2`'s resolution will restart the second instance
- In this way, we use Promise orchestration to ensure that `res[0]` will have the first response and `res[1]` will have the second response

But frankly, this is awfully manual, and it doesn't really let the generators orchestrate themselves, which is where the true power can lie. Let's try it a different way:

```js
// `request(..)` is a Promise-aware Ajax utility

var res = [];

function *reqData(url) {
    var data = yield request( url );

    // transfer control
    yield;

    res.push( data );
}

var it1 = reqData( "http://some.url.1" );
var it2 = reqData( "http://some.url.2" );

var p1 = it1.next().value;
var p2 = it2.next().value;

p1.then( function(data){
    it1.next( data );
} );

p2.then( function(data){
    it2.next( data );
} );

Promise.all( [p1,p2] )
.then( function(){
    it1.next();
    it2.next();
} );
```

OK, this is a bit better (though still manual!), because now the two instances of `*reqData(..)` run truly concurrently, and (at least for the first part) independently.

In the previous snippet, the second instance was not given its data until after the first instance was totally finished
- But here, both instances receive their data as soon as their respective responses come back, and then each instance does another `yield` for control transfer purposes
- We then choose what order to resume them in the `Promise.all([ .. ])` handler

What may not be as obvious is that this approach hints at an easier form for a reusable utility, because of the symmetry
- We can do even better. Let's imagine using a utility called `runAll(..)`:

```js
// `request(..)` is a Promise-aware Ajax utility

var res = [];

runAll(
    function*(){
        var p1 = request( "http://some.url.1" );

        // transfer control
        yield;

        res.push( yield p1 );
    },
    function*(){
        var p2 = request( "http://some.url.2" );

        // transfer control
        yield;

        res.push( yield p2 );
    }
);
```

**Note:** We're not including a code listing for `runAll(..)` as it is not only long enough to bog down the text, but is an extension of the logic we've already implemented in `run(..)` earlier
\- So, as a good supplementary exercise for the reader, try your hand at evolving the code from `run(..)` to work like the imagined `runAll(..)`
- Also, my *asynquence* library provides a previously mentioned `runner(..)` utility with this kind of capability already built in, and will be discussed in Appendix A of this book

Here's how the processing inside `runAll(..)` would operate:

1. The first generator gets a promise for the first Ajax response from `"http://some.url.1"`, then `yield`s control back to the `runAll(..)` utility.
2. The second generator runs and does the same for `"http://some.url.2"`, `yield`ing control back to the `runAll(..)` utility.
3. The first generator resumes, and then `yield`s out its promise `p1`. The `runAll(..)` utility does the same in this case as our previous `run(..)`, in that it waits on that promise to resolve, then resumes the same generator (no control transfer!). When `p1` resolves, `runAll(..)` resumes the first generator again with that resolution value, and then `res[0]` is given its value. When the first generator then finishes, that's an implicit transfer of control.
4. The second generator resumes, `yield`s out its promise `p2`, and waits for it to resolve. Once it does, `runAll(..)` resumes the second generator with that value, and `res[1]` is set.

In this running example, we use an outer variable called `res` to store the results of the two different Ajax responses -- that's our concurrency coordination making that possible.

But it might be quite helpful to further extend `runAll(..)` to provide an inner variable space for the multiple generator instances to *share*, such as an empty object we'll call `data` below
- Also, it could take non-Promise values that are `yield`ed and hand them off to the next generator

Consider:

```js
// `request(..)` is a Promise-aware Ajax utility

runAll(
    function*(data){
        data.res = [];

        // transfer control (and message pass)
        var url1 = yield "http://some.url.2";

        var p1 = request( url1 ); // "http://some.url.1"

        // transfer control
        yield;

        data.res.push( yield p1 );
	},
	function*(data){
        // transfer control (and message pass)
        var url2 = yield "http://some.url.1";

        var p2 = request( url2 ); // "http://some.url.2"

        // transfer control
        yield;

        data.res.push( yield p2 );
	}
);
```

In this formulation, the two generators are not just coordinating control transfer, but actually communicating with each other, both through `data.res` and the `yield`ed messages that trade `url1` and `url2` values
- That's incredibly powerful!

Such realization also serves as a conceptual base for a more sophisticated asynchrony technique called CSP (Communicating Sequential Processes), which we will cover in Appendix B of this book.

## Thunks

So far, we've made the assumption that `yield`ing a Promise from a generator -- and having that Promise resume the generator via a helper utility like `run(..)` -- was the best possible way to manage asynchrony with generators
- To be clear, it is

But we skipped over another pattern that has some mildly widespread adoption, so in the interest of completeness we'll take a brief look at it.

In general computer science, there's an old pre-JS concept called a "thunk." Without getting bogged down in the historical nature, a narrow expression of a thunk in JS is a function that -- without any parameters -- is wired to call another function.

In other words, you wrap a function definition around function call -- with any parameters it needs -- to *defer* the execution of that call, and that wrapping function is a thunk
- When you later execute the thunk, you end up calling the original function

For example:

```js
function foo(x,y) {
    return x + y;
}

function fooThunk() {
    return foo( 3, 4 );
}

// later

console.log( fooThunk() );	// 7
```

So, a synchronous thunk is pretty straightforward. But what about an async thunk? We can essentially extend the narrow thunk definition to include it receiving a callback.

Consider:

```js
function foo(x,y,cb) {
    setTimeout( function(){
        cb( x + y );
    }, 1000 );
}

function fooThunk(cb) {
    foo( 3, 4, cb );
}

// later

fooThunk( function(sum){
    console.log( sum ); // 7
} );
```

As you can see, `fooThunk(..)` only expects a `cb(..)` parameter, as it already has values `3` and `4` (for `x` and `y`, respectively) pre-specified and ready to pass to `foo(..)`
- A thunk is just waiting around patiently for the last piece it needs to do its job: the callback

You don't want to make thunks manually, though. So, let's invent a utility that does this wrapping for us.

Consider:

```js
function thunkify(fn) {
    var args = [].slice.call( arguments, 1 );
    return function(cb) {
        args.push( cb );
        return fn.apply( null, args );
    };
}

var fooThunk = thunkify( foo, 3, 4 );

// later

fooThunk( function(sum) {
    console.log( sum ); // 7
} );
```

**Tip:** Here we assume that the original (`foo(..)`) function signature expects its callback in the last position, with any other parameters coming before it
- This is a pretty ubiquitous "standard" for async JS function standards. You might call it "callback-last style."
- If for some reason you had a need to handle "callback-first style" signatures, you would just make a utility that used `args.unshift(..)` instead of `args.push(..)`

The preceding formulation of `thunkify(..)` takes both the `foo(..)` function reference, and any parameters it needs, and returns back the thunk itself (`fooThunk(..)`)
- However, that's not the typical approach you'll find to thunks in JS

Instead of `thunkify(..)` making the thunk itself, typically -- if not perplexingly -- the `thunkify(..)` utility would produce a function that produces thunks.

Uhhhh... yeah.

Consider:

```js
function thunkify(fn) {
    return function() {
        var args = [].slice.call( arguments );
        return function(cb) {
            args.push( cb );
            return fn.apply( null, args );
        };
    };
}
```

The main difference here is the extra `return function() { .. }` layer. Here's how its usage differs:

```js
var whatIsThis = thunkify( foo );
var fooThunk = whatIsThis( 3, 4 );

// later

fooThunk( function(sum) {
    console.log( sum ); // 7
} );
```

Obviously, the big question this snippet implies is what is `whatIsThis` properly called? It's not the thunk, it's the thing that will produce thunks from `foo(..)` calls. It's kind of like a "factory" for "thunks."
- There doesn't seem to be any kind of standard agreement for naming such a thing

So, my proposal is "thunkory" ("thunk" + "factory").  So, `thunkify(..)` produces a thunkory, and a thunkory produces thunks. That reasoning is symmetric to my proposal for "promisory" in Chapter 3:

```js
var fooThunkory = thunkify( foo );

var fooThunk1 = fooThunkory( 3, 4 );
var fooThunk2 = fooThunkory( 5, 6 );

// later

fooThunk1( function(sum) {
    console.log( sum ); // 7
} );

fooThunk2( function(sum) {
	console.log( sum ); // 11
} );
```

**Note:** The running `foo(..)` example expects a style of callback that's not "error-first style." Of course, "error-first style" is much more common. If `foo(..)` had some sort of legitimate error-producing expectation, we could change it to expect and use an error-first callback
- None of the subsequent `thunkify(..)` machinery cares what style of callback is assumed. The only difference in usage would be `fooThunk1(function(err,sum){..`

Exposing the thunkory method -- instead of how the earlier `thunkify(..)` hides this intermediary step -- may seem like unnecessary complication
- But in general, it's quite useful to make thunkories at the beginning of your program to wrap existing API methods, and then be able to pass around and call those thunkories when you need thunks
- The two distinct steps preserve a cleaner separation of capability

To illustrate:

```js
// cleaner:
var fooThunkory = thunkify( foo );

var fooThunk1 = fooThunkory( 3, 4 );
var fooThunk2 = fooThunkory( 5, 6 );

// instead of:
var fooThunk1 = thunkify( foo, 3, 4 );
var fooThunk2 = thunkify( foo, 5, 6 );
```

Regardless of whether you like to deal with the thunkories explicitly or not, the usage of thunks `fooThunk1(..)` and `fooThunk2(..)` remains the same.

### s/promise/thunk/

So what's all this thunk stuff have to do with generators?

Comparing thunks to promises generally: they're not directly interchangable as they're not equivalent in behavior
- Promises are vastly more capable and trustable than bare thunks

But in another sense, they both can be seen as a request for a value, which may be async in its answering.

Recall from Chapter 3 we defined a utility for promisifying a function, which we called `Promise.wrap(..)` -- we could have called it `promisify(..)`, too!
- This Promise-wrapping utility doesn't produce Promises; it produces promisories that in turn produce Promises
- This is completely symmetric to the thunkories and thunks presently being discussed

To illustrate the symmetry, let's first alter the running `foo(..)` example from earlier to assume an "error-first style" callback:

```js
function foo(x,y,cb) {
    setTimeout( function(){
        // assume `cb(..)` as "error-first style"
        cb( null, x + y );
    }, 1000 );
}
```

Now, we'll compare using `thunkify(..)` and `promisify(..)` (aka `Promise.wrap(..)` from Chapter 3):

```js
// symmetrical: constructing the question asker
var fooThunkory = thunkify( foo );
var fooPromisory = promisify( foo );

// symmetrical: asking the question
var fooThunk = fooThunkory( 3, 4 );
var fooPromise = fooPromisory( 3, 4 );

// get the thunk answer
fooThunk( function(err,sum){
    if (err) {
        console.error( err );
    }
    else {
        console.log( sum ); // 7
    }
} );

// get the promise answer
fooPromise
.then(
    function(sum){
        console.log( sum ); // 7
    },
    function(err){
        console.error( err );
    }
);
```

Both the thunkory and the promisory are essentially asking a question (for a value), and respectively the thunk `fooThunk` and promise `fooPromise` represent the future answers to that question
- Presented in that light, the symmetry is clear

With that perspective in mind, we can see that generators which `yield` Promises for asynchrony could instead `yield` thunks for asynchrony
- All we'd need is a smarter `run(..)` utility (like from before) that can not only look for and wire up to a `yield`ed Promise but also to provide a callback to a `yield`ed thunk

Consider:

```js
function *foo() {
    var val = yield request( "http://some.url.1" );
    console.log( val );
}

run( foo );
```

In this example, `request(..)` could either be a promisory that returns a promise, or a thunkory that returns a thunk
- From the perspective of what's going on inside the generator code logic, we don't care about that implementation detail, which is quite powerful!

So, `request(..)` could be either:

```js
// promisory `request(..)` (see Chapter 3)
var request = Promise.wrap( ajax );

// vs.

// thunkory `request(..)`
var request = thunkify( ajax );
```

Finally, as a thunk-aware patch to our earlier `run(..)` utility, we would need logic like this:

```js
// ..
// did we receive a thunk back?
else if (typeof next.value == "function") {
    return new Promise( function(resolve,reject){
        // call the thunk with an error-first callback
        next.value( function(err,msg) {
            if (err) {
                reject( err );
            }
            else {
                resolve( msg );
            }
        } );
    } )
    .then(
        handleNext,
        function handleErr(err) {
            return Promise.resolve(
                it.throw( err )
            )
            .then( handleResult );
        }
    );
}
```

Now, our generators can either call promisories to `yield` Promises, or call thunkories to `yield` thunks, and in either case, `run(..)` would handle that value and use it to wait for the completion to resume the generator.

Symmetry wise, these two approaches look identical
- However, we should point out that's true only from the perspective of Promises or thunks representing the future value continuation of a generator

From the larger perspective, thunks do not in and of themselves have hardly any of the trustability or composability guarantees that Promises are designed with
- Using a thunk as a stand-in for a Promise in this particular generator asynchrony pattern is workable but should be seen as less than ideal when compared to all the benefits that Promises offer (see Chapter 3)

If you have the option, prefer `yield pr` rather than `yield th`. But there's nothing wrong with having a `run(..)` utility which can handle both value types.

**Note:** The `runner(..)` utility in my *asynquence* library, which will be discussed in Appendix A, handles `yield`s of Promises, thunks and *asynquence* sequences.

## Pre-ES6 Generators

You're hopefully convinced now that generators are a very important addition to the async programming toolbox.
- But it's a new syntax in ES6, which means you can't just polyfill generators like you can Promises (which are just a new API)
- So what can we do to bring generators to our browser JS if we don't have the luxury of ignoring pre-ES6 browsers?

For all new syntax extensions in ES6, there are tools -- the most common term for them is transpilers, for trans-compilers -- which can take your ES6 syntax and transform it into equivalent (but obviously uglier!) pre-ES6 code.
- So, generators can be transpiled into code that will have the same behavior but work in ES5 and below

But how? The "magic" of `yield` doesn't obviously sound like code that's easy to transpile
- We actually hinted at a solution in our earlier discussion of closure-based *iterators*

### Manual Transformation

Before we discuss the transpilers, let's derive how manual transpilation would work in the case of generators
- This isn't just an academic exercise, because doing so will actually help further reinforce how they work

Consider:

```js
// `request(..)` is a Promise-aware Ajax utility

function *foo(url) {
    try {
        console.log( "requesting:", url );
        var val = yield request( url );
        console.log( val );
    }
    catch (err) {
        console.log( "Oops:", err );
        return false;
    }
}

var it = foo( "http://some.url.1" );
```

The first thing to observe is that we'll still need a normal `foo()` function that can be called, and it will still need to return an *iterator*
- So, let's sketch out the non-generator transformation:

```js
function foo(url) {

    // ..

    // make and return an iterator
    return {
        next: function(v) {
            // ..
        },
        throw: function(e) {
            // ..
        }
    };
}

var it = foo( "http://some.url.1" );
```

The next thing to observe is that a generator does its "magic" by suspending its scope/state, but we can emulate that with function closure (see the *Scope & Closures* title of this series)
- To understand how to write such code, we'll first annotate different parts of our generator with state values:

```js
// `request(..)` is a Promise-aware Ajax utility

function *foo(url) {
    // STATE *1*

    try {
        console.log( "requesting:", url );
        var TMP1 = request( url );

        // STATE *2*
        var val = yield TMP1;
        console.log( val );
    }
    catch (err) {
        // STATE *3*
        console.log( "Oops:", err );
        return false;
    }
}
```

**Note:** For more accurate illustration, we split up the `val = yield request..` statement into two parts, using the temporary `TMP1` variable. `request(..)` happens in state `*1*`, and the assignment of its completion value to `val` happens in state `*2*`
- We'll get rid of that intermediate `TMP1` when we convert the code to its non-generator equivalent

In other words, `*1*` is the beginning state, `*2*` is the state if the `request(..)` succeeds, and `*3*` is the state if the `request(..)` fails
- You can probably imagine how any extra `yield` steps would just be encoded as extra states

Back to our transpiled generator, let's define a variable `state` in the closure we can use to keep track of the state:

```js
function foo(url) {
    // manage generator state
    var state;

    // ..
}
```

Now, let's define an inner function called `process(..)` inside the closure which handles each state, using a `switch` statement:

```js
// `request(..)` is a Promise-aware Ajax utility

function foo(url) {
    // manage generator state
    var state;

    // generator-wide variable declarations
    var val;

    function process(v) {
        switch (state) {
            case 1:
                console.log( "requesting:", url );
                return request( url );
            case 2:
                val = v;
                console.log( val );
                return;
            case 3:
                var err = v;
                console.log( "Oops:", err );
                return false;
        }
    }

    // ..
}
```

Each state in our generator is represented by its own `case` in the `switch` statement. `process(..)` will be called each time we need to process a new state
- We'll come back to how that works in just a moment

For any generator-wide variable declarations (`val`), we move those to a `var` declaration outside of `process(..)` so they can survive multiple calls to `process(..)`
- But the "block scoped" `err` variable is only needed for the `*3*` state, so we leave it in place

In state `*1*`, instead of `yield request(..)`, we did `return request(..)`
- In terminal state `*2*`, there was no explicit `return`, so we just do a `return;` which is the same as `return undefined`
- In terminal state `*3*`, there was a `return false`, so we preserve that

Now we need to define the code in the *iterator* functions so they call `process(..)` appropriately:

```js
function foo(url) {
    // manage generator state
    var state;

    // generator-wide variable declarations
    var val;

    function process(v) {
        switch (state) {
            case 1:
                console.log( "requesting:", url );
                return request( url );
            case 2:
                val = v;
                console.log( val );
                return;
            case 3:
                var err = v;
                console.log( "Oops:", err );
                return false;
        }
    }

    // make and return an iterator
    return {
        next: function(v) {
            // initial state
            if (!state) {
                state = 1;
                return {
                    done: false,
                    value: process()
                };
            }
            // yield resumed successfully
            else if (state == 1) {
                state = 2;
                return {
                    done: true,
                    value: process( v )
                };
            }
            // generator already completed
            else {
                return {
                    done: true,
                    value: undefined
                };
            }
        },
        "throw": function(e) {
            // the only explicit error handling is in
            // state *1*
            if (state == 1) {
                state = 3;
                return {
                    done: true,
                    value: process( e )
                };
            }
            // otherwise, an error won't be handled,
            // so just throw it right back out
            else {
                throw e;
            }
        }
    };
}
```

How does this code work?

1. The first call to the *iterator*'s `next()` call would move the generator from the uninitialized state to state `1`, and then call `process()` to handle that state. The return value from `request(..)`, which is the promise for the Ajax response, is returned back as the `value` property from the `next()` call.
2. If the Ajax request succeeds, the second call to `next(..)` should send in the Ajax response value, which moves our state to `2`. `process(..)` is again called (this time with the passed in Ajax response value), and the `value` property returned from `next(..)` will be `undefined`.
3. However, if the Ajax request fails, `throw(..)` should be called with the error, which would move the state from `1` to `3` (instead of `2`). Again `process(..)` is called, this time with the error value. That `case` returns `false`, which is set as the `value` property returned from the `throw(..)` call.

From the outside -- that is, interacting only with the *iterator* -- this `foo(..)` normal function works pretty much the same as the `*foo(..)` generator would have worked
- So we've effectively "transpiled" our ES6 generator to pre-ES6 compatibility!

We could then manually instantiate our generator and control its iterator -- calling `var it = foo("..")` and `it.next(..)` and such -- or better, we could pass it to our previously defined `run(..)` utility as `run(foo,"..")`.

### Automatic Transpilation

The preceding exercise of manually deriving a transformation of our ES6 generator to pre-ES6 equivalent teaches us how generators work conceptually
- But that transformation was really intricate and very non-portable to other generators in our code
- It would be quite impractical to do this work by hand, and would completely obviate all the benefit of generators

But luckily, several tools already exist that can automatically convert ES6 generators to things like what we derived in the previous section
- Not only do they do the heavy lifting work for us, but they also handle several complications that we glossed over

One such tool is regenerator (https://facebook.github.io/regenerator/), from the smart folks at Facebook.

If we use regenerator to transpile our previous generator, here's the code produced (at the time of this writing):

```js
// `request(..)` is a Promise-aware Ajax utility

var foo = regeneratorRuntime.mark(function foo(url) {
    var val;

    return regeneratorRuntime.wrap(function foo$(context$1$0) {
        while (1) switch (context$1$0.prev = context$1$0.next) {
        case 0:
            context$1$0.prev = 0;
            console.log( "requesting:", url );
            context$1$0.next = 4;
            return request( url );
        case 4:
            val = context$1$0.sent;
            console.log( val );
            context$1$0.next = 12;
            break;
        case 8:
            context$1$0.prev = 8;
            context$1$0.t0 = context$1$0.catch(0);
            console.log("Oops:", context$1$0.t0);
            return context$1$0.abrupt("return", false);
        case 12:
        case "end":
            return context$1$0.stop();
        }
    }, foo, this, [[0, 8]]);
});
```

There's some obvious similarities here to our manual derivation, such as the `switch` / `case` statements, and we even see `val` pulled out of the closure just as we did.

Of course, one trade-off is that regenerator's transpilation requires a helper library `regeneratorRuntime` that holds all the reusable logic for managing a general generator / *iterator*
- A lot of that boilerplate looks different than our version, but even then, the concepts can be seen, like with `context$1$0.next = 4` keeping track of the next state for the generator

The main takeaway is that generators are not restricted to only being useful in ES6+ environments
- Once you understand the concepts, you can employ them throughout your code, and use tools to transform the code to be compatible with older environments

This is more work than just using a `Promise` API polyfill for pre-ES6 Promises, but the effort is totally worth it, because generators are so much better at expressing async flow control in a reason-able, sensible, synchronous-looking, sequential fashion.

Once you get hooked on generators, you'll never want to go back to the hell of async spaghetti callbacks!

## Review

Generators are a new ES6 function type that does not run-to-completion like normal functions
- Instead, the generator can be paused in mid-completion (entirely preserving its state), and it can later be resumed from where it left off

This pause/resume interchange is cooperative rather than preemptive, which means that the generator has the sole capability to pause itself, using the `yield` keyword, and yet the *iterator* that controls the generator has the sole capability (via `next(..)`) to resume the generator.

The `yield` / `next(..)` duality is not just a control mechanism, it's actually a two-way message passing mechanism
- A `yield ..` expression essentially pauses waiting for a value, and the next `next(..)` call passes a value (or implicit `undefined`) back to that paused `yield` expression

The key benefit of generators related to async flow control is that the code inside a generator expresses a sequence of steps for the task in a naturally sync/sequential fashion
- The trick is that we essentially hide potential asynchrony behind the `yield` keyword -- moving the asynchrony to the code where the generator's *iterator* is controlled

In other words, generators preserve a sequential, synchronous, blocking code pattern for async code, which lets our brains reason about the code much more naturally, addressing one of the two key drawbacks of callback-based async.












# Chapter 5: Program Performance

This book so far has been all about how to leverage asynchrony patterns more effectively
- But we haven't directly addressed why asynchrony really matters to JS. The most obvious explicit reason is **performance**

For example, if you have two Ajax requests to make, and they're independent, but you need to wait on them both to finish before doing the next task, you have two options for modeling that interaction: serial and concurrent.

You could make the first request and wait to start the second request until the first finishes
- Or, as we've seen both with promises and generators, you could make both requests "in parallel," and express the "gate" to wait on both of them before moving on

Clearly, the latter is usually going to be more performant than the former. And better performance generally leads to better user experience.

It's even possible that asynchrony (interleaved concurrency) can improve just the perception of performance, even if the overall program still takes the same amount of time to complete
- User perception of performance is every bit -- if not more! -- as important as actual measurable performance

We want to now move beyond localized asynchrony patterns to talk about some bigger picture performance details at the program level.

**Note:** You may be wondering about micro-performance issues like if `a++` or `++a` is faster. We'll look at those sorts of performance details in the next chapter on "Benchmarking & Tuning."

## Web Workers

If you have processing-intensive tasks but you don't want them to run on the main thread (which may slow down the browser/UI), you might have wished that JavaScript could operate in a multithreaded manner.

In Chapter 1, we talked in detail about how JavaScript is single threaded
- And that's still true
- But a single thread isn't the only way to organize the execution of your program

Imagine splitting your program into two pieces, and running one of those pieces on the main UI thread, and running the other piece on an entirely separate thread.

What kinds of concerns would such an architecture bring up?

For one, you'd want to know if running on a separate thread meant that it ran in parallel (on systems with multiple CPUs/cores) such that a long-running process on that second thread would **not** block the main program thread
- Otherwise, "virtual threading" wouldn't be of much benefit over what we already have in JS with async concurrency

And you'd want to know if these two pieces of the program have access to the same shared scope/resources
- If they do, then you have all the questions that multithreaded languages (Java, C++, etc.) deal with, such as needing cooperative or preemptive locking (mutexes, etc.). That's a lot of extra work, and shouldn't be undertaken lightly

Alternatively, you'd want to know how these two pieces could "communicate" if they couldn't share scope/resources.

All these are great questions to consider as we explore a feature added to the web platform circa HTML5 called "Web Workers
- This is a feature of the browser (aka host environment) and actually has almost nothing to do with the JS language itself
- That is, JavaScript does not *currently* have any features that support threaded execution

But an environment like your browser can easily provide multiple instances of the JavaScript engine, each on its own thread, and let you run a different program in each thread
- Each of those separate threaded pieces of your program is called a "(Web) Worker." This type of parallelism is called "task parallelism," as the emphasis is on splitting up chunks of your program to run in parallel

From your main JS program (or another Worker), you instantiate a Worker like so:

```js
var w1 = new Worker( "http://some.url.1/mycoolworker.js" );
```

The URL should point to the location of a JS file (not an HTML page!) which is intended to be loaded into a Worker
- The browser will then spin up a separate thread and let that file run as an independent program in that thread

**Note:** The kind of Worker created with such a URL is called a "Dedicated Worker"
- But instead of providing a URL to an external file, you can also create an "Inline Worker" by providing a Blob URL (another HTML5 feature); essentially it's an inline file stored in a single (binary) value
- However, Blobs are beyond the scope of what we'll discuss here

Workers do not share any scope or resources with each other or the main program -- that would bring all the nightmares of threaded programming to the forefront -- but instead have a basic event messaging mechanism connecting them.

The `w1` Worker object is an event listener and trigger, which lets you subscribe to events sent by the Worker as well as send events to the Worker.

Here's how to listen for events (actually, the fixed `"message"` event):

```js
w1.addEventListener( "message", function(evt){
    // evt.data
} );
```

And you can send the `"message"` event to the Worker:

```js
w1.postMessage( "something cool to say" );
```

Inside the Worker, the messaging is totally symmetrical:

```js
// "mycoolworker.js"

addEventListener( "message", function(evt){
    // evt.data
} );

postMessage( "a really cool reply" );
```

Notice that a dedicated Worker is in a one-to-one relationship with the program that created it
- That is, the `"message"` event doesn't need any disambiguation here, because we're sure that it could only have come from this one-to-one relationship -- either it came from the Worker or the main page

Usually the main page application creates the Workers, but a Worker can instantiate its own child Worker(s) -- known as subworkers -- as necessary
- Sometimes this is useful to delegate such details to a sort of "master" Worker that spawns other Workers to process parts of a task. Unfortunately, at the time of this writing, Chrome still does not support subworkers, while Firefox does

To kill a Worker immediately from the program that created it, call `terminate()` on the Worker object (like `w1` in the previous snippets)
- Abruptly terminating a Worker thread does not give it any chance to finish up its work or clean up any resources
- It's akin to you closing a browser tab to kill a page

If you have two or more pages (or multiple tabs with the same page!) in the browser that try to create a Worker from the same file URL, those will actually end up as completely separate Workers
- Shortly, we'll discuss a way to "share" a Worker

**Note:** It may seem like a malicious or ignorant JS program could easily perform a denial-of-service attack on a system by spawning hundreds of Workers, seemingly each with their own thread
- While it's true that it's somewhat of a guarantee that a Worker will end up on a separate thread, this guarantee is not unlimited
- The system is free to decide how many actual threads/CPUs/cores it really wants to create. There's no way to predict or guarantee how many you'll have access to, though many people assume it's at least as many as the number of CPUs/cores available
- I think the safest assumption is that there's at least one other thread besides the main UI thread, but that's about it

### Worker Environment

Inside the Worker, you do not have access to any of the main program's resources
- That means you cannot access any of its global variables, nor can you access the page's DOM or other resources
- Remember: it's a totally separate thread

You can, however, perform network operations (Ajax, WebSockets) and set timers
- Also, the Worker has access to its own copy of several important global variables/features, including `navigator`, `location`, `JSON`, and `applicationCache`

You can also load extra JS scripts into your Worker, using `importScripts(..)`:

```js
// inside the Worker
importScripts( "foo.js", "bar.js" );
```

These scripts are loaded synchronously, which means the `importScripts(..)` call will block the rest of the Worker's execution until the file(s) are finished loading and executing.

**Note:** There have also been some discussions about exposing the `<canvas>` API to Workers, which combined with having canvases be Transferables (see the "Data Transfer" section), would allow Workers to perform more sophisticated off-thread graphics processing, which can be useful for high-performance gaming (WebGL) and other similar applications
- Although this doesn't exist yet in any browsers, it's likely to happen in the near future

What are some common uses for Web Workers?

* Processing intensive math calculations
* Sorting large data sets
* Data operations (compression, audio analysis, image pixel manipulations, etc.)
* High-traffic network communications

# ES6

# ES? Now & Future

Before you dive into this book, you should have a solid working proficiency over JavaScript up to the most recent standard (at the time of this writing), which is commonly called *ES5* (technically ES 5.1)
- Here, we plan to talk squarely about the upcoming *ES6*, as well as cast our vision beyond to understand how JS will evolve moving forward

Unlike ES5, ES6 is not just a modest set of new APIs added to the language
- It incorporates a whole slew of new syntactic forms, some of which may take quite a bit of getting used to
- There's also a variety of new organization forms and new API helpers for various data types

ES6 is a radical jump forward for the language
- Even if you think you know JS in ES5, ES6 is full of new stuff you *don't know yet*, so get ready!
- This book explores all the major themes of ES6 that you need to get up to speed on, and even gives you a glimpse of future features coming down the track that you should be aware of

**Warning:** All code in this book assumes an ES6+ environment. At the time of this writing, ES6 support varies quite a bit in browsers and JS environments (like Node.js), so your mileage may vary.

## Versioning

The JavaScript standard is referred to officially as "ECMAScript" (abbreviated "ES"), and up until just recently has been versioned entirely by ordinal number (i.e., "5" for "5th edition").

The earliest versions, ES1 and ES2, were not widely known or implemented. ES3 was the first widespread baseline for JavaScript, and constitutes the JavaScript standard for browsers like IE6-8 and older Android 2.x mobile browsers
- For political reasons beyond what we'll cover here, the ill-fated ES4 never came about

In 2009, ES5 was officially finalized (later ES5.1 in 2011), and settled as the widespread standard for JS for the modern revolution and explosion of browsers, such as Firefox, Chrome, Opera, Safari, and many others.

Leading up to the expected *next* version of JS (slipped from 2013 to 2014 and then 2015), the obvious and common label in discourse has been ES6.

However, late into the ES6 specification timeline, suggestions have surfaced that versioning may in the future switch to a year-based schema, such as ES2016 (aka ES7) to refer to whatever version of the specification is finalized before the end of 2016
- Some disagree, but ES6 will likely maintain its dominant mindshare over the late-change substitute ES2015
- However, ES2016 may in fact signal the new year-based schema

It has also been observed that the pace of JS evolution is much faster even than single-year versioning
- As soon as an idea begins to progress through standards discussions, browsers start prototyping the feature, and early adopters start experimenting with the code

Usually well before there's an official stamp of approval, a feature is de facto standardized by virtue of this early engine/tooling prototyping
- So it's also valid to consider the future of JS versioning to be per-feature rather than per-arbitrary-collection-of-major-features (as it is now) or even per-year (as it may become)

The takeaway is that the version labels stop being as important, and JavaScript starts to be seen more as an evergreen, living standard
- The best way to cope with this is to stop thinking about your code base as being "ES6-based," for instance, and instead consider it feature by feature for support

## Transpiling

Made even worse by the rapid evolution of features, a problem arises for JS developers who at once may both strongly desire to use new features while at the same time being slapped with the reality that their sites/apps may need to support older browsers without such support.

The way ES5 appears to have played out in the broader industry, the typical mindset was that code bases waited to adopt ES5 until most if not all pre-ES5 environments had fallen out of their support spectrum
- As a result, many are just recently (at the time of this writing) starting to adopt things like `strict` mode, which landed in ES5 over five years ago

It's widely considered to be a harmful approach for the future of the JS ecosystem to wait around and trail the specification by so many years
- All those responsible for evolving the language desire for developers to begin basing their code on the new features and patterns as soon as they stabilize in specification form and browsers have a chance to implement them

So how do we resolve this seeming contradiction? The answer is tooling, specifically a technique called *transpiling* (transformation + compiling)
- Roughly, the idea is to use a special tool to transform your ES6 code into equivalent (or close!) matches that work in ES5 environments

For example, consider shorthand property definitions (see "Object Literal Extensions" in Chapter 2)
- Here's the ES6 form:

```js
var foo = [1,2,3];

var obj = {
    foo // means `foo: foo`
};

obj.foo;  // [1,2,3]
```

But (roughly) here's how that transpiles:

```js
var foo = [1,2,3];

var obj = {
    foo: foo
};

obj.foo;  // [1,2,3]
```

This is a minor but pleasant transformation that lets us shorten the `foo: foo` in an object literal declaration to just `foo`, if the names are the same.

Transpilers perform these transformations for you, usually in a build workflow step similar to how you perform linting, minification, and other similar operations.

### Shims/Polyfills

Not all new ES6 features need a transpiler. Polyfills (aka shims) are a pattern for defining equivalent behavior from a newer environment into an older environment, when possible. Syntax cannot be polyfilled, but APIs often can be.

For example, `Object.is(..)` is a new utility for checking strict equality of two values but without the nuanced exceptions that `===` has for `NaN` and `-0` values. The polyfill for `Object.is(..)` is pretty easy:

```js
if (!Object.is) {
    Object.is = function(v1, v2) {
        // test for `-0`
        if (v1 === 0 && v2 === 0) {
            return 1 / v1 === 1 / v2;
        }
        // test for `NaN`
        if (v1 !== v1) {
            return v2 !== v2;
        }
        // everything else
        return v1 === v2;
    };
}
```

**Tip:** Pay attention to the outer `if` statement guard wrapped around the polyfill
- This is an important detail, which means the snippet only defines its fallback behavior for older environments where the API in question isn't already defined; it would be very rare that you'd want to overwrite an existing API

There's a great collection of ES6 shims called "ES6 Shim" (https://github.com/paulmillr/es6-shim/) that you should definitely adopt as a standard part of any new JS project!

It is assumed that JS will continue to evolve constantly, with browsers rolling out support for features continually rather than in large chunks
- So the best strategy for keeping updated as it evolves is to just introduce polyfill shims into your code base, and a transpiler step into your build workflow, right now and get used to that new reality

If you decide to keep the status quo and just wait around for all browsers without a feature supported to go away before you start using the feature, you're always going to be way behind
- You'll sadly be missing out on all the innovations designed to make writing JavaScript more effective, efficient, and robust

## Review

ES6 (some may try to call it ES2015) is just landing as of the time of this writing, and it has lots of new stuff you need to learn!

But it's even more important to shift your mindset to align with the new way that JavaScript is going to evolve
- It's not just waiting around for years for some official document to get a vote of approval, as many have done in the past

Now, JavaScript features land in browsers as they become ready, and it's up to you whether you'll get on the train early or whether you'll be playing costly catch-up games years from now.

Whatever labels that future JavaScript adopts, it's going to move a lot quicker than it ever has before
- Transpilers and shims/polyfills are important tools to keep you on the forefront of where the language is headed

If there's any narrative important to understand about the new reality for JavaScript, it's that all JS developers are strongly implored to move from the trailing edge of the curve to the leading edge
- And learning ES6 is where that all

## Block-Scoped Declarations

You're probably aware that the fundamental unit of variable scoping in JavaScript has always been the `function`
- If you needed to create a block of scope, the most prevalent way to do so other than a regular function declaration was the immediately invoked function expression (IIFE). For example:

```js
var a = 2;

(function IIFE(){
    var a = 3;
    console.log( a ); // 3
})();

console.log( a ); // 2
```

### `let` Declarations

However, we can now create declarations that are bound to any block, called (unsurprisingly) *block scoping*
- This means all we need is a pair of `{ .. }` to create a scope. Instead of using `var`, which always declares variables attached to the enclosing function (or global, if top level) scope, use `let`:

```js
var a = 2;

{
    let a = 3;
    console.log( a ); // 3
}

console.log( a ); // 2
```

It's not very common or idiomatic thus far in JS to use a standalone `{ .. }` block, but it's always been valid
- And developers from other languages that have *block scoping* will readily recognize that pattern

I believe this is the best way to create block-scoped variables, with a dedicated `{ .. }` block
- Moreover, you should always put the `let` declaration(s) at the very top of that block
- If you have more than one to declare, I'd recommend using just one `let`

Stylistically, I even prefer to put the `let` on the same line as the opening `{`, to make it clearer that this block is only for the purpose of declaring the scope for those variables.

```js
{	let a = 2, b, c;
    // ..
}
```

Now, that's going to look strange and it's not likely going to match the recommendations given in most other ES6 literature. But I have reasons for my madness.

There's another experimental (not standardized) form of the `let` declaration called the `let`-block, which looks like:

```js
let (a = 2, b, c) {
    // ..
}
```

That form is what I call *explicit* block scoping, whereas the `let ..` declaration form that mirrors `var` is more *implicit*, as it kind of hijacks whatever `{ .. }` pair it's found in
- Generally developers find *explicit* mechanisms a bit more preferable than *implicit* mechanisms, and I claim this is one of those cases

If you compare the previous two snippet forms, they're very similar, and in my opinion both qualify stylistically as *explicit* block scoping
- Unfortunately, the `let (..) { .. }` form, the most *explicit* of the options, was not adopted in ES6
- That may be revisited post-ES6, but for now the former option is our best bet, I think

To reinforce the *implicit* nature of `let ..` declarations, consider these usages:

```js
let a = 2;

if (a > 1) {
    let b = a * 3;
    console.log( b ); // 6

    for (let i = a; i <= b; i++) {
        let j = i + 10;
        console.log( j );
    }
	// 12 13 14 15 16

    let c = a + b;
    console.log( c ); // 8
}
```

Quick quiz without looking back at that snippet: which variable(s) exist only inside the `if` statement, and which variable(s) exist only inside the `for` loop?

The answers: the `if` statement contains `b` and `c` block-scoped variables, and the `for` loop contains `i` and `j` block-scoped variables.

Did you have to think about it for a moment?
- Does it surprise you that `i` isn't added to the enclosing `if` statement scope? That mental pause and questioning -- I call it a "mental tax" -- comes from the fact that this `let` mechanism is not only new to us, but it's also *implicit*

There's also hazard in the `let c = ..` declaration appearing so far down in the scope. Unlike traditional `var`-declared variables, which are attached to the entire enclosing function scope regardless of where they appear, `let` declarations attach to the block scope but are not initialized until they appear in the block.

Accessing a `let`-declared variable earlier than its `let ..` declaration/initialization causes an error, whereas with `var` declarations the ordering doesn't matter (except stylistically).

Consider:

```js
{
    console.log( a ); // undefined
    console.log( b ); // ReferenceError!

    var a;
    let b;
}
```

**Warning:** This `ReferenceError` from accessing too-early `let`-declared references is technically called a *Temporal Dead Zone (TDZ)* error -- you're accessing a variable that's been declared but not yet initialized
- This will not be the only time we see TDZ errors -- they crop up in several places in ES6
- Also, note that "initialized" doesn't require explicitly assigning a value in your code, as `let b;` is totally valid
- A variable that's not given an assignment at declaration time is assumed to have been assigned the `undefined` value, so `let b;` is the same as `let b = undefined;`
- Explicit assignment or not, you cannot access `b` until the `let b` statement is run

One last gotcha: `typeof` behaves differently with TDZ variables than it does with undeclared (or declared!) variables. For example:

```js
{
    // `a` is not declared
    if (typeof a === "undefined") {
        console.log( "cool" );
    }

    // `b` is declared, but in its TDZ
    if (typeof b === "undefined") { // ReferenceError!
        // ..
	}

    // ..

    let b;
}
```

The `a` is not declared, so `typeof` is the only safe way to check for its existence or not
- But `typeof b` throws the TDZ error because farther down in the code there happens to be a `let b` declaration. Oops

Now it should be clearer why I insist that `let` declarations should all be at the top of their scope
- That totally avoids the accidental errors of accessing too early. It also makes it more *explicit* when you look at the start of a block, any block, what variables it contains

Your blocks (`if` statements, `while` loops, etc.) don't have to share their original behavior with scoping behavior.

This explicitness on your part, which is up to you to maintain with discipline, will save you lots of refactor headaches and footguns down the line.

**Note:** For more information on `let` and block scoping, see Chapter 3 of the *Scope & Closures* title of this series.

#### `let` + `for`

The only exception I'd make to the preference for the *explicit* form of `let` declaration blocking is a `let` that appears in the header of a `for` loop
- The reason may seem nuanced, but I believe it to be one of the more important ES6 features

Consider:

```js
var funcs = [];

for (let i = 0; i < 5; i++) {
    funcs.push( function(){
        console.log( i );
    } );
}

funcs[3](); // 3
```

The `let i` in the `for` header declares an `i` not just for the `for` loop itself, but it redeclares a new `i` for each iteration of the loop
- That means that closures created inside the loop iteration close over those per-iteration variables the way you'd expect

If you tried that same snippet but with `var i` in the `for` loop header, you'd get `5` instead of `3`, because there'd only be one `i` in the outer scope that was closed over, instead of a new `i` for each iteration's function to close over.

You could also have accomplished the same thing slightly more verbosely:

```js
var funcs = [];

for (var i = 0; i < 5; i++) {
    let j = i;
    funcs.push( function(){
        console.log( j );
    } );
}

funcs[3](); // 3
```

Here, we forcibly create a new `j` for each iteration, and then the closure works the same way
- I prefer the former approach; that extra special capability is why I endorse the `for (let .. ) ..` form
- It could be argued it's somewhat more *implicit*, but it's *explicit* enough, and useful enough, for my tastes

`let` also works the same way with `for..in` and `for..of` loops (see "`for..of` Loops").

### `const` Declarations

There's one other form of block-scoped declaration to consider: the `const`, which creates *constants*.

What exactly is a constant? It's a variable that's read-only after its initial value is set. Consider:

```js
{
    const a = 2;
    console.log( a ); // 2

    a = 3;  // TypeError!
}
```

You are not allowed to change the value the variable holds once it's been set, at declaration time
- A `const` declaration must have an explicit initialization
- If you wanted a *constant* with the `undefined` value, you'd have to declare `const a = undefined` to get it

Constants are not a restriction on the value itself, but on the variable's assignment of that value
- In other words, the value is not frozen or immutable because of `const`, just the assignment of it
- If the value is complex, such as an object or array, the contents of the value can still be modified:

```js
{
    const a = [1,2,3];
    a.push( 4 );
    console.log( a ); // [1,2,3,4]

    a = 42; // TypeError!
}
```

The `a` variable doesn't actually hold a constant array; rather, it holds a constant reference to the array
- The array itself is freely mutable

**Warning:** Assigning an object or array as a constant means that value will not be able to be garbage collected until that constant's lexical scope goes away, as the reference to the value can never be unset
- That may be desirable, but be careful if it's not your intent!

Essentially, `const` declarations enforce what we've stylistically signaled with our code for years, where we declared a variable name of all uppercase letters and assigned it some literal value that we took care never to change
- There's no enforcement on a `var` assignment, but there is now with a `const` assignment, which can help you catch unintended changes

`const` *can* be used with variable declarations of `for`, `for..in`, and `for..of` loops (see "`for..of` Loops")
- However, an error will be thrown if there's any attempt to reassign, such as the typical `i++` clause of a `for` loop

#### `const` Or Not

There's some rumored assumptions that a `const` could be more optimizable by the JS engine in certain scenarios than a `let` or `var` would be
- Theoretically, the engine more easily knows the variable's value/type will never change, so it can eliminate some possible tracking

Whether `const` really helps here or this is just our own fantasies and intuitions, the much more important decision to make is if you intend constant behavior or not
- Remember: one of the most important roles for source code is to communicate clearly, not only to you, but your future self and other code collaborators, what your intent is

Some developers prefer to start out every variable declaration as a `const` and then relax a declaration back to a `let` if it becomes necessary for its value to change in the code
- This is an interesting perspective, but it's not clear that it genuinely improves the readability or reason-ability of code

It's not really a *protection*, as many believe, because any later developer who wants to change a value of a `const` can just blindly change `const` to `let` on the declaration
- At best, it protects accidental change. But again, other than our intuitions and sensibilities, there doesn't appear to be objective and clear measure of what constitutes "accidents" or prevention thereof
- Similar mindsets exist around type enforcement

My advice: to avoid potentially confusing code, only use `const` for variables that you're intentionally and obviously signaling will not change
- In other words, don't *rely on* `const` for code behavior, but instead use it as a tool for signaling intent, when intent can be signaled clearly

### Block-scoped Functions

Starting with ES6, function declarations that occur inside of blocks are now specified to be scoped to that block. Prior to ES6, the specification did not call for this, but many implementations did it anyway
- So now the specification meets reality

Consider:

```js
{
    foo();  // works!

    function foo() {
        // ..
    }
}

foo();  // ReferenceError
```

The `foo()` function is declared inside the `{ .. }` block, and as of ES6 is block-scoped there
- So it's not available outside that block
- But also note that it is "hoisted" within the block, as opposed to `let` declarations, which suffer the TDZ error trap mentioned earlier

Block-scoping of function declarations could be a problem if you've ever written code like this before, and relied on the old legacy non-block-scoped behavior:

```js
if (something) {
    function foo() {
        console.log( "1" );
    }
}
else {
    function foo() {
        console.log( "2" );
    }
}

foo();		// ??
```

In pre-ES6 environments, `foo()` would print `"2"` regardless of the value of `something`, because both function declarations were hoisted out of the blocks, and the second one always wins.

In ES6, that last line throws a `ReferenceError`.

## Spread/Rest

ES6 introduces a new `...` operator that's typically referred to as the *spread* or *rest* operator, depending on where/how it's used. Let's take a look:

```js
function foo(x,y,z) {
    console.log( x, y, z );
}

foo( ...[1,2,3] );  // 1 2 3
```

When `...` is used in front of an array (actually, any *iterable*, which we cover in Chapter 3), it acts to "spread" it out into its individual values.

You'll typically see that usage as is shown in that previous snippet, when spreading out an array as a set of arguments to a function call
- In this usage, `...` acts to give us a simpler syntactic replacement for the `apply(..)` method, which we would typically have used pre-ES6 as:

```js
foo.apply( null, [1,2,3] ); // 1 2 3
```

But `...` can be used to spread out/expand a value in other contexts as well, such as inside another array declaration:

```js
var a = [2,3,4];
var b = [ 1, ...a, 5 ];

console.log( b ); // [1,2,3,4,5]
```

In this usage, `...` is basically replacing `concat(..)`, as it behaves like `[1].concat( a, [5] )` here.

The other common usage of `...` can be seen as essentially the opposite; instead of spreading a value out, the `...` *gathers* a set of values together into an array. Consider:

```js
function foo(x, y, ...z) {
    console.log( x, y, z );
}

foo( 1, 2, 3, 4, 5 ); // 1 2 [3,4,5]
```

The `...z` in this snippet is essentially saying: "gather the *rest* of the arguments (if any) into an array called `z`." Because `x` was assigned `1`, and `y` was assigned `2`, the rest of the arguments `3`, `4`, and `5` were gathered into `z`.

Of course, if you don't have any named parameters, the `...` gathers all arguments:

```js
function foo(...args) {
    console.log( args );
}

foo( 1, 2, 3, 4, 5);  // [1,2,3,4,5]
```

**Note:** The `...args` in the `foo(..)` function declaration is usually called "rest parameters," because you're collecting the rest of the parameters
- I prefer "gather," because it's more descriptive of what it does rather than what it contains

The best part about this usage is that it provides a very solid alternative to using the long-since-deprecated `arguments` array -- actually, it's not really an array, but an array-like object
- Because `args` (or whatever you call it -- a lot of people prefer `r` or `rest`) is a real array, we can get rid of lots of silly pre-ES6 tricks we jumped through to make `arguments` into something we can treat as an array

Consider:

```js
// doing things the new ES6 way
function foo(...args) {
    // `args` is already a real array

    // discard first element in `args`
    args.shift();

    // pass along all of `args` as arguments
    // to `console.log(..)`
    console.log( ...args );
}

// doing things the old-school pre-ES6 way
function bar() {
    // turn `arguments` into a real array
    var args = Array.prototype.slice.call( arguments );

    // add some elements on the end
    args.push( 4, 5 );

    // filter out odd numbers
    args = args.filter( function(v){
        return v % 2 == 0;
    } );

    // pass along all of `args` as arguments
    // to `foo(..)`
    foo.apply( null, args );
}

bar( 0, 1, 2, 3 );  // 2 4
```

The `...args` in the `foo(..)` function declaration gathers arguments, and the `...args` in the `console.log(..)` call spreads them out
- That's a good illustration of the symmetric but opposite uses of the `...` operator

Besides the `...` usage in a function declaration, there's another case where `...` is used for gathering values, and we'll look at it in the "Too Many, Too Few, Just Enough" section later in this chapter.

## Default Parameter Values

Perhaps one of the most common idioms in JavaScript relates to setting a default value for a function parameter
- The way we've done this for years should look quite familiar:

```js
function foo(x,y) {
    x = x || 11;
    y = y || 31;

    console.log( x + y );
}

foo();  // 42
foo( 5, 6 );  // 11
foo( 5 ); // 36
foo( null, 6 ); // 17
```

Of course, if you've used this pattern before, you know that it's both helpful and a little bit dangerous, if for example you need to be able to pass in what would otherwise be considered a falsy value for one of the parameters. Consider:

```js
foo( 0, 42 ); // 53 <-- Oops, not 42
```

Why? Because the `0` is falsy, and so the `x || 11` results in `11`, not the directly passed in `0`.

To fix this gotcha, some people will instead write the check more verbosely like this:

```js
function foo(x,y) {
    x = (x !== undefined) ? x : 11;
    y = (y !== undefined) ? y : 31;

    console.log( x + y );
}

foo( 0, 42 ); // 42
foo( undefined, 6 );  // 17
```

Of course, that means that any value except `undefined` can be directly passed in. However, `undefined` will be assumed to signal, "I didn't pass this in"
- That works great unless you actually need to be able to pass `undefined` in

In that case, you could test to see if the argument is actually omitted, by it actually not being present in the `arguments` array, perhaps like this:

```js
function foo(x,y) {
    x = (0 in arguments) ? x : 11;
    y = (1 in arguments) ? y : 31;

    console.log( x + y );
}

foo( 5 ); // 36
foo( 5, undefined );  // NaN
```

But how would you omit the first `x` argument without the ability to pass in any kind of value (not even `undefined`) that signals "I'm omitting this argument"?

`foo(,5)` is tempting, but it's invalid syntax. `foo.apply(null,[,5])` seems like it should do the trick, but `apply(..)`'s quirks here mean that the arguments are treated as `[undefined,5]`, which of course doesn't omit.

If you investigate further, you'll find you can only omit arguments on the end (i.e., righthand side) by simply passing fewer arguments than "expected," but you cannot omit arguments in the middle or at the beginning of the arguments list. It's just not possible.

There's a principle applied to JavaScript's design here that is important to remember: `undefined` means *missing*. That is, there's no difference between `undefined` and *missing*, at least as far as function arguments go.

**Note:** There are, confusingly, other places in JS where this particular design principle doesn't apply, such as for arrays with empty slots. See the *Types & Grammar* title of this series for more information.

With all this in mind, we can now examine a nice helpful syntax added as of ES6 to streamline the assignment of default values to missing arguments:

```js
function foo(x = 11, y = 31) {
    console.log( x + y );
}

foo();  // 42
foo( 5, 6 );  // 11
foo( 0, 42 ); // 42

foo( 5 ); // 36
foo( 5, undefined );  // 36 <-- `undefined` is missing
foo( 5, null ); // 5  <-- null coerces to `0`

foo( undefined, 6 );  // 17 <-- `undefined` is missing
foo( null, 6 ); // 6  <-- null coerces to `0`
```

Notice the results and how they imply both subtle differences and similarities to the earlier approaches.

`x = 11` in a function declaration is more like `x !== undefined ? x : 11` than the much more common idiom `x || 11`, so you'll need to be careful in converting your pre-ES6 code to this ES6 default parameter value syntax.

**Note:** A rest/gather parameter (see "Spread/Rest") cannot have a default value
- So, while `function foo(...vals=[1,2,3]) {` might seem an intriguing capability, it's not valid syntax
- You'll need to continue to apply that sort of logic manually if necessary

### Default Value Expressions

Function default values can be more than just simple values like `31`; they can be any valid expression, even a function call:

```js
function bar(val) {
    console.log( "bar called!" );
    return y + val;
}

function foo(x = y + 3, z = bar( x )) {
    console.log( x, z );
}

var y = 5;
foo();  // "bar called"
        // 8 13
foo( 10 );  // "bar called"
            // 10 15
y = 6;
foo( undefined, 10 ); // 9 10
```

As you can see, the default value expressions are lazily evaluated, meaning they're only run if and when they're needed -- that is, when a parameter's argument is omitted or is `undefined`.

It's a subtle detail, but the formal parameters in a function declaration are in their own scope (think of it as a scope bubble wrapped around just the `( .. )` of the function declaration), not in the function body's scope
- That means a reference to an identifier in a default value expression first matches the formal parameters' scope before looking to an outer scope
- See the *Scope & Closures* title of this series for more information

Consider:

```js
var w = 1, z = 2;

function foo( x = w + 1, y = x + 1, z = z + 1 ) {
    console.log( x, y, z );
}

foo();  // ReferenceError
```

The `w` in the `w + 1` default value expression looks for `w` in the formal parameters' scope, but does not find it, so the outer scope's `w` is used
- Next, The `x` in the `x + 1` default value expression finds `x` in the formal parameters' scope, and luckily `x` has already been initialized, so the assignment to `y` works fine

However, the `z` in `z + 1` finds `z` as a not-yet-initialized-at-that-moment parameter variable, so it never tries to find the `z` from the outer scope.

As we mentioned in the "`let` Declarations" section earlier in this chapter, ES6 has a TDZ, which prevents a variable from being accessed in its uninitialized state
- As such, the `z + 1` default value expression throws a TDZ `ReferenceError` error

Though it's not necessarily a good idea for code clarity, a default value expression can even be an inline function expression call -- commonly referred to as an immediately invoked function expression (IIFE):

```js
function foo( x =
    (function(v){ return v + 11; })( 31 )
) {
    console.log( x );
}

foo();  // 42
```

There will very rarely be any cases where an IIFE (or any other executed inline function expression) will be appropriate for default value expressions
- If you find yourself tempted to do this, take a step back and reevaluate!

**Warning:** If the IIFE had tried to access the `x` identifier and had not declared its own `x`, this would also have been a TDZ error, just as discussed before.

The default value expression in the previous snippet is an IIFE in that in the sense that it's a function that's executed right inline, via `(31)`
- If we had left that part off, the default value assigned to `x` would have just been a function reference itself, perhaps like a default callback
- There will probably be cases where that pattern will be quite useful, such as:

```js
function ajax(url, cb = function(){}) {
    // ..
}

ajax( "http://some.url.1" );
```

In this case, we essentially want to default `cb` to be a no-op empty function call if not otherwise specified
- The function expression is just a function reference, not a function call itself (no invoking `()` on the end of it), which accomplishes that goal

Since the early days of JS, there's been a little-known but useful quirk available to us: `Function.prototype` is itself an empty no-op function
- So, the declaration could have been `cb = Function.prototype` and saved the inline function expression creation

## Destructuring

ES6 introduces a new syntactic feature called *destructuring*, which may be a little less confusing if you instead think of it as *structured assignment*
- To understand this meaning, consider:

```js
function foo() {
    return [1,2,3];
}

var tmp = foo(),
    a = tmp[0], b = tmp[1], c = tmp[2];

console.log( a, b, c ); // 1 2 3
```

As you can see, we created a manual assignment of the values in the array that `foo()` returns to individual variables `a`, `b`, and `c`, and to do so we (unfortunately) needed the `tmp` variable.

Similarly, we can do the following with objects:

```js
function bar() {
    return {
        x: 4,
        y: 5,
        z: 6
    };
}

var tmp = bar(),
    x = tmp.x, y = tmp.y, z = tmp.z;

console.log( x, y, z ); // 4 5 6
```

The `tmp.x` property value is assigned to the `x` variable, and likewise for `tmp.y` to `y` and `tmp.z` to `z`.

Manually assigning indexed values from an array or properties from an object can be thought of as *structured assignment*
- ES6 adds a dedicated syntax for *destructuring*, specifically *array destructuring* and *object destructuring*
- This syntax eliminates the need for the `tmp` variable in the previous snippets, making them much cleaner
- Consider:

```js
var [ a, b, c ] = foo();
var { x: x, y: y, z: z } = bar();

console.log( a, b, c ); // 1 2 3
console.log( x, y, z ); // 4 5 6
```

You're likely more accustomed to seeing syntax like `[a,b,c]` on the righthand side of an `=` assignment, as the value being assigned.

Destructuring symmetrically flips that pattern, so that `[a,b,c]` on the lefthand side of the `=` assignment is treated as a kind of "pattern" for decomposing the righthand side array value into separate variable assignments.

Similarly, `{ x: x, y: y, z: z }` specifies a "pattern" to decompose the object value from `bar()` into separate variable assignments.

### Object Property Assignment Pattern

Let's dig into that `{ x: x, .. }` syntax from the previous snippet
- If the property name being matched is the same as the variable you want to declare, you can actually shorten the syntax:

```js
var { x, y, z } = bar();
console.log( x, y, z ); // 4 5 6
```

Pretty cool, right?

But is `{ x, .. }` leaving off the `x: ` part or leaving off the `: x` part? We're actually leaving off the `x: ` part when we use the shorter syntax
- That may not seem like an important detail, but you'll understand its importance in just a moment

If you can write the shorter form, why would you ever write out the longer form?
- Because that longer form actually allows you to assign a property to a different variable name, which can sometimes be quite useful:

```js
var { x: bam, y: baz, z: bap } = bar();

console.log( bam, baz, bap ); // 4 5 6
console.log( x, y, z ); // ReferenceError
```

There's a subtle but super-important quirk to understand about this variation of the object destructuring form.
- To illustrate why it can be a gotcha you need to be careful of, let's consider the "pattern" of how normal object literals are specified:

```js
var X = 10, Y = 20;

var o = { a: X, b: Y };

console.log( o.a, o.b );  // 10 20
```

In `{ a: X, b: Y }`, we know that `a` is the object property, and `X` is the source value that gets assigned to it
- In other words, the syntactic pattern is `target: source`, or more obviously, `property-alias: value`
- We intuitively understand this because it's the same as `=` assignment, where the pattern is `target = source`

However, when you use object destructuring assignment -- that is, putting the `{ .. }` object literal-looking syntax on the lefthand side of the `=` operator -- you invert that `target: source` pattern.

Recall:

```js
var { x: bam, y: baz, z: bap } = bar();
```

The syntactic pattern here is `source: target` (or `value: variable-alias`). `x: bam` means the `x` property is the source value and `bam` is the target variable to assign to
- In other words, object literals are `target <-- source`, and object destructuring assignments are `source --> target`. See how that's flipped?

There's another way to think about this syntax though, which may help ease the confusion. Consider:

```js
var aa = 10, bb = 20;

var o = { x: aa, y: bb };
var     { x: AA, y: BB } = o;

console.log( AA, BB );  // 10 20
```

In the `{ x: aa, y: bb }` line, the `x` and `y` represent the object properties. In the `{ x: AA, y: BB }` line, the `x` and the `y` *also* represent the object properties.

Recall how earlier I asserted that `{ x, .. }` was leaving off the `x: ` part?
- In those two lines, if you erase the `x: ` and `y: ` parts in that snippet, you're left only with `aa, bb` and `AA, BB`, which in effect -- only conceptually, not actually -- are assignments from `aa` to `AA` and from `bb` to `BB`

So, that symmetry may help to explain why the syntactic pattern was intentionally flipped for this ES6 feature.

**Note:** I would have preferred the syntax to be `{ AA: x , BB: y }` for the destructuring assignment, as that would have preserved consistency of the more familiar `target: source` pattern for both usages
- Alas, I'm having to train my brain for the inversion, as some readers may also have to do

### Not Just Declarations

So far, we've used destructuring assignment with `var` declarations (of course, they could also use `let` and `const`), but destructuring is a general assignment operation, not just a declaration.

Consider:

```js
var a, b, c, x, y, z;

[a,b,c] = foo();
( { x, y, z } = bar() );

console.log( a, b, c ); // 1 2 3
console.log( x, y, z ); // 4 5 6
```

The variables can already be declared, and then the destructuring only does assignments, exactly as we've already seen.

**Note:** For the object destructuring form specifically, when leaving off a `var`/`let`/`const` declarator, we had to surround the whole assignment expression in `( )`, because otherwise the `{ .. }` on the lefthand side as the first element in the statement is taken to be a block statement instead of an object.

In fact, the assignment expressions (`a`, `y`, etc.) don't actually need to be just variable identifiers. Anything that's a valid assignment expression is allowed. For example:

```js
var o = {};

[o.a, o.b, o.c] = foo();
( { x: o.x, y: o.y, z: o.z } = bar() );

console.log( o.a, o.b, o.c ); // 1 2 3
console.log( o.x, o.y, o.z ); // 4 5 6
```

You can even use computed property expressions in the destructuring. Consider:

```js
var which = "x",
    o = {};

( { [which]: o[which] } = bar() );

console.log( o.x ); // 4
```

The `[which]:` part is the computed property, which results in `x` -- the property to destructure from the object in question as the source of the assignment
- The `o[which]` part is just a normal object key reference, which equates to `o.x` as the target of the assignment

You can use the general assignments to create object mappings/transformations, such as:

```js
var o1 = { a: 1, b: 2, c: 3 },
    o2 = {};

( { a: o2.x, b: o2.y, c: o2.z } = o1 );

console.log( o2.x, o2.y, o2.z );  // 1 2 3
```

Or you can map an object to an array, such as:

```js
var o1 = { a: 1, b: 2, c: 3 },
    a2 = [];

( { a: a2[0], b: a2[1], c: a2[2] } = o1 );

console.log( a2 );  // [1,2,3]
```

Or the other way around:

```js
var a1 = [ 1, 2, 3 ],
    o2 = {};

[ o2.a, o2.b, o2.c ] = a1;

console.log( o2.a, o2.b, o2.c );  // 1 2 3
```

Or you could reorder one array to another:

```js
var a1 = [ 1, 2, 3 ],
    a2 = [];

[ a2[2], a2[0], a2[1] ] = a1;

console.log( a2 );  // [2,3,1]
```

You can even solve the traditional "swap two variables" task without a temporary variable:

```js
var x = 10, y = 20;

[ y, x ] = [ x, y ];

console.log( x, y );  // 20 10
```

**Warning:** Be careful: you shouldn't mix in declaration with assignment unless you want all of the assignment expressions *also* to be treated as declarations
- Otherwise, you'll get syntax errors
- That's why in the earlier example I had to do `var a2 = []` separately from the `[ a2[0], .. ] = ..` destructuring assignment
- It wouldn't make any sense to try `var [ a2[0], .. ] = ..`, because `a2[0]` isn't a valid declaration identifier; it also obviously couldn't implicitly create a `var a2 = []` declaration to use

### Repeated Assignments

The object destructuring form allows a source property (holding any value type) to be listed multiple times. For example:

```js
var { a: X, a: Y } = { a: 1 };

X;	// 1
Y;	// 1
```

That also means you can both destructure a sub-object/array property and also capture the sub-object/array's value itself. Consider:

```js
var { a: { x: X, x: Y }, a } = { a: { x: 1 } };

X;	// 1
Y;	// 1
a;	// { x: 1 }

( { a: X, a: Y, a: [ Z ] } = { a: [ 1 ] } );

X.push( 2 );
Y[0] = 10;

X;	// [10,2]
Y;	// [10,2]
Z;	// 1
```

A word of caution about destructuring: it may be tempting to list destructuring assignments all on a single line as has been done thus far in our discussion
- However, it's a much better idea to spread destructuring assignment patterns over multiple lines, using proper indentation -- much like you would in JSON or with an object literal value -- for readability sake

```js
// harder to read:
var { a: { b: [ c, d ], e: { f } }, g } = obj;

// better:
var {
    a: {
        b: [ c, d ],
        e: { f }
    },
    g
} = obj;
```

Remember: **the purpose of destructuring is not just less typing, but more declarative readability.**

#### Destructuring Assignment Expressions

The assignment expression with object or array destructuring has as its completion value the full righthand object/array value. Consider:

```js
var o = { a:1, b:2, c:3 },
    a, b, c, p;

p = { a, b, c } = o;

console.log( a, b, c ); // 1 2 3
p === o;  // true
```

In the previous snippet, `p` was assigned the `o` object reference, not one of the `a`, `b`, or `c` values
- The same is true of array destructuring:

```js
var o = [1,2,3],
    a, b, c, p;

p = [ a, b, c ] = o;

console.log( a, b, c ); // 1 2 3
p === o;  // true
```

By carrying the object/array value through as the completion, you can chain destructuring assignment expressions together:

```js
var o = { a:1, b:2, c:3 },
    p = [4,5,6],
    a, b, c, x, y, z;

( {a} = {b,c} = o );
[x,y] = [z] = p;

console.log( a, b, c ); // 1 2 3
console.log( x, y, z ); // 4 5 4
```

### Too Many, Too Few, Just Enough

With both array destructuring assignment and object destructuring assignment, you do not have to assign all the values that are present. For example:

```js
var [,b] = foo();
var { x, z } = bar();

console.log( b, x, z ); // 2 4 6
```

The `1` and `3` values that came back from `foo()` are discarded, as is the `5` value from `bar()`.

Similarly, if you try to assign more values than are present in the value you're destructuring/decomposing, you get graceful fallback to `undefined`, as you'd expect:

```js
var [,,c,d] = foo();
var { w, z } = bar();

console.log( c, z );  // 3 6
console.log( d, w );  // undefined undefined
```

This behavior follows symmetrically from the earlier stated "`undefined` is missing" principle.

We examined the `...` operator earlier in this chapter, and saw that it can sometimes be used to spread an array value out into its separate values, and sometimes it can be used to do the opposite: to gather a set of values together into an array.

In addition to the gather/rest usage in function declarations, `...` can perform the same behavior in destructuring assignments
- To illustrate, let's recall a snippet from earlier in this chapter:

```js
var a = [2,3,4];
var b = [ 1, ...a, 5 ];

console.log( b ); // [1,2,3,4,5]
```

Here we see that `...a` is spreading `a` out, because it appears in the array `[ .. ]` value position
- If `...a` appears in an array destructuring position, it performs the gather behavior:

```js
var a = [2,3,4];
var [ b, ...c ] = a;

console.log( b, c );  // 2 [3,4]
```

The `var [ .. ] = a` destructuring assignment spreads `a` out to be assigned to the pattern described inside the `[ .. ]`
- The first part names `b` for the first value in `a` (`2`). But then `...c` gathers the rest of the values (`3` and `4`) into an array and calls it `c`

**Note:** We've seen how `...` works with arrays, but what about with objects? It's not an ES6 feature, but see Chapter 8 for discussion of a possible "beyond ES6" feature where `...` works with spreading or gathering objects.

### Default Value Assignment

Both forms of destructuring can offer a default value option for an assignment, using the `=` syntax similar to the default function argument values discussed earlier.

Consider:

```js
var [ a = 3, b = 6, c = 9, d = 12 ] = foo();
var { x = 5, y = 10, z = 15, w = 20 } = bar();

console.log( a, b, c, d );  // 1 2 3 12
console.log( x, y, z, w );  // 4 5 6 20
```

You can combine the default value assignment with the alternative assignment expression syntax covered earlier. For example:

```js
var { x, y, z, w: WW = 20 } = bar();

console.log( x, y, z, WW ); // 4 5 6 20
```

Be careful about confusing yourself (or other developers who read your code) if you use an object or array as the default value in a destructuring. You can create some really hard to understand code:

```js
var x = 200, y = 300, z = 100;
var o1 = { x: { y: 42 }, z: { y: z } };

( { y: x = { y: y } } = o1 );
( { z: y = { y: z } } = o1 );
( { x: z = { y: x } } = o1 );
```

Can you tell from that snippet what values `x`, `y`, and `z` have at the end? Takes a moment of pondering, I would imagine. I'll end the suspense:

```js
console.log( x.y, y.y, z.y ); // 300 100 42
```

The takeaway here: destructuring is great and can be very useful, but it's also a sharp sword that can cause injury (to someone's brain) if used unwisely.

### Nested Destructuring

If the values you're destructuring have nested objects or arrays, you can destructure those nested values as well:

```js
var a1 = [ 1, [2, 3, 4], 5 ];
var o1 = { x: { y: { z: 6 } } };

var [ a, [ b, c, d ], e ] = a1;
var { x: { y: { z: w } } } = o1;

console.log( a, b, c, d, e ); // 1 2 3 4 5
console.log( w ); // 6
```

Nested destructuring can be a simple way to flatten out object namespaces. For example:

```js
var App = {
    model: {
        User: function(){ .. }
    }
};

// instead of:
// var User = App.model.User;

var { model: { User } } = App;
```

### Destructuring Parameters

In the following snippet, can you spot the assignment?

```js
function foo(x) {
    console.log( x );
}

foo( 42 );
```

The assignment is kinda hidden: `42` (the argument) is assigned to `x` (the parameter) when `foo(42)` is executed
- If parameter/argument pairing is an assignment, then it stands to reason that it's an assignment that could be destructured, right? Of course!

Consider array destructuring for parameters:

```js
function foo( [ x, y ] ) {
    console.log( x, y );
}

foo( [ 1, 2 ] );  // 1 2
foo( [ 1 ] ); // 1 undefined
foo( [] );  // undefined undefined
```

Object destructuring for parameters works, too:

```js
function foo( { x, y } ) {
    console.log( x, y );
}

foo( { y: 1, x: 2 } );  // 2 1
foo( { y: 42 } ); // undefined 42
foo( {} );  // undefined undefined
```

This technique is an approximation of named arguments (a long requested feature for JS!), in that the properties on the object map to the destructured parameters of the same names
- That also means that we get optional parameters (in any position) for free, as you can see leaving off the `x` "parameter" worked as we'd expect

Of course, all the previously discussed variations of destructuring are available to us with parameter destructuring, including nested destructuring, default values, and more
- Destructuring also mixes fine with other ES6 function parameter capabilities, like default parameter values and rest/gather parameters

Consider these quick illustrations (certainly not exhaustive of the possible variations):

```js
function f1([ x=2, y=3, z ]) { .. }
function f2([ x, y, ...z], w) { .. }
function f3([ x, y, ...z], ...w) { .. }

function f4({ x: X, y }) { .. }
function f5({ x: X = 10, y = 20 }) { .. }
function f6({ x = 10 } = {}, { y } = { y: 10 }) { .. }
```

Let's take one example from this snippet and examine it, for illustration purposes:

```js
function f3([ x, y, ...z], ...w) {
    console.log( x, y, z, w );
}

f3( [] ); // undefined undefined [] []
f3( [1,2,3,4], 5, 6 );  // 1 2 [3,4] [5,6]
```

There are two `...` operators in use here, and they're both gathering values in arrays (`z` and `w`), though `...z` gathers from the rest of the values left over in the first array argument, while `...w` gathers from the rest of the main arguments left over after the first.

#### Destructuring Defaults + Parameter Defaults

There's one subtle point you should be particularly careful to notice -- the difference in behavior between a destructuring default value and a function parameter default value. For example:

```js
function f6({ x = 10 } = {}, { y } = { y: 10 }) {
    console.log( x, y );
}

f6(); // 10 10
```

At first, it would seem that we've declared a default value of `10` for both the `x` and `y` parameters, but in two different ways
- However, these two different approaches will behave differently in certain cases, and the difference is awfully subtle

Consider:

```js
f6( {}, {} ); // 10 undefined
```

Wait, why did that happen? It's pretty clear that named parameter `x` is defaulting to `10` if not passed as a property of that same name in the first argument's object.

But what about `y` being `undefined`? The `{ y: 10 }` value is an object as a function parameter default value, not a destructuring default value
- As such, it only applies if the second argument is not passed at all, or is passed as `undefined`

In the previous snippet, we *are* passing a second argument (`{}`), so the default `{ y: 10 }` value is not used, and the `{ y }` destructuring occurs against the passed in `{}` empty object value.

Now, compare `{ y } = { y: 10 }` to `{ x = 10 } = {}`.

For the `x`'s form usage, if the first function argument is omitted or `undefined`, the `{}` empty object default applies
- Then, whatever value is in the first argument position -- either the default `{}` or whatever you passed in -- is destructured with the `{ x = 10 }`, which checks to see if an `x` property is found, and if not found (or `undefined`), the `10` default value is applied to the `x` named parameter

Deep breath. Read back over those last few paragraphs a couple of times. Let's review via code:

```js
function f6({ x = 10 } = {}, { y } = { y: 10 }) {
    console.log( x, y );
}

f6(); // 10 10
f6( undefined, undefined ); // 10 10
f6( {}, undefined );  // 10 10

f6( {}, {} ); // 10 undefined
f6( undefined, {} );  // 10 undefined

f6( { x: 2 }, { y: 3 } ); // 2 3
```

It would generally seem that the defaulting behavior of the `x` parameter is probably the more desirable and sensible case compared to that of `y`
- As such, it's important to understand why and how `{ x = 10 } = {}` form is different from `{ y } = { y: 10 }` form

If that's still a bit fuzzy, go back and read it again, and play with this yourself
- Your future self will thank you for taking the time to get this very subtle gotcha nuance detail straight

#### Nested Defaults: Destructured and Restructured

Although it may at first be difficult to grasp, an interesting idiom emerges for setting defaults for a nested object's properties: using object destructuring along with what I'd call *restructuring*.

Consider a set of defaults in a nested object structure, like the following:

```js
// taken from: http://es-discourse.com/t/partial-default-arguments/120/7

var defaults = {
    options: {
        remove: true,
        enable: false,
        instance: {}
    },
    log: {
        warn: true,
        error: true
    }
};
```

Now, let's say that you have an object called `config`, which has some of these applied, but perhaps not all, and you'd like to set all the defaults into this object in the missing spots, but not override specific settings already present:

```js
var config = {
    options: {
        remove: false,
        instance: null
    }
};
```

You can of course do so manually, as you might have done in the past:

```js
config.options = config.options || {};
config.options.remove = (config.options.remove !== undefined) ?
    config.options.remove : defaults.options.remove;
config.options.enable = (config.options.enable !== undefined) ?
    config.options.enable : defaults.options.enable;
...
```

Yuck.

Others may prefer the assign-overwrite approach to this task
- You might be tempted by the ES6 `Object.assign(..)` utility (see Chapter 6) to clone the properties first from `defaults` and then overwritten with the cloned properties from `config`, as so:

```js
config = Object.assign( {}, defaults, config );
```

That looks way nicer, huh? But there's a major problem! `Object.assign(..)` is shallow, which means when it copies `defaults.options`, it just copies that object reference, not deep cloning that object's properties to a `config.options` object
- `Object.assign(..)` would need to be applied (sort of "recursively") at all levels of your object's tree to get the deep cloning you're expecting

**Note:** Many JS utility libraries/frameworks provide their own option for deep cloning of an object, but those approaches and their gotchas are beyond our scope to discuss here.

So let's examine if ES6 object destructuring with defaults can help at all:

```js
config.options = config.options || {};
config.log = config.log || {};
({
    options: {
        remove: config.options.remove = defaults.options.remove,
        enable: config.options.enable = defaults.options.enable,
        instance: config.options.instance = defaults.options.instance
    } = {},
    log: {
        warn: config.log.warn = defaults.log.warn,
        error: config.log.error = defaults.log.error
    } = {}
} = config);
```

Not as nice as the false promise of `Object.assign(..)` (being that it's shallow only), but it's better than the manual approach by a fair bit, I think
- It is still unfortunately verbose and repetitive, though

The previous snippet's approach works because I'm hacking the destructuring and defaults mechanism to do the property `=== undefined` checks and assignment decisions for me
- It's a trick in that I'm destructuring `config` (see the `= config` at the end of the snippet), but I'm reassigning all the destructured values right back into `config`, with the `config.options.enable` assignment references

Still too much, though. Let's see if we can make anything better.

The following trick works best if you know that all the various properties you're destructuring are uniquely named
- You can still do it even if that's not the case, but it's not as nice -- you'll have to do the destructuring in stages, or create unique local variables as temporary aliases

If we fully destructure all the properties into top-level variables, we can then immediately restructure to reconstitute the original nested object structure.

But all those temporary variables hanging around would pollute scope
- So, let's use block scoping (see "Block-Scoped Declarations" earlier in this chapter) with a general `{ }` enclosing block:

```js
// merge `defaults` into `config`
{
    // destructure (with default value assignments)
    let {
        options: {
            remove = defaults.options.remove,
            enable = defaults.options.enable,
            instance = defaults.options.instance
        } = {},
        log: {
            warn = defaults.log.warn,
            error = defaults.log.error
        } = {}
    } = config;

    // restructure
    config = {
        options: { remove, enable, instance },
        log: { warn, error }
    };
}
```

That seems a fair bit nicer, huh?

**Note:** You could also accomplish the scope enclosure with an arrow IIFE instead of the general `{ }` block and `let` declarations
- Your destructuring assignments/defaults would be in the parameter list and your restructuring would be the `return` statement in the function body

The `{ warn, error }` syntax in the restructuring part may look new to you; that's called "concise properties" and we cover it in the next section!

## Object Literal Extensions

ES6 adds a number of important convenience extensions to the humble `{ .. }` object literal.

### Concise Properties

You're certainly familiar with declaring object literals in this form:

```js
var x = 2, y = 3,
    o = {
        x: x,
        y: y
    };
```

If it's always felt redundant to say `x: x` all over, there's good news
- If you need to define a property that is the same name as a lexical identifier, you can shorten it from `x: x` to `x`. Consider:

```js
var x = 2, y = 3,
    o = {
        x,
        y
    };
```

### Concise Methods

In a similar spirit to concise properties we just examined, functions attached to properties in object literals also have a concise form, for convenience.

The old way:

```js
var o = {
    x: function(){
        // ..
    },
    y: function(){
        // ..
    }
}
```

And as of ES6:

```js
var o = {
    x() {
        // ..
    },
    y() {
        // ..
    }
}
```

**Warning:** While `x() { .. }` seems to just be shorthand for `x: function(){ .. }`, concise methods have special behaviors that their older counterparts don't; specifically, the allowance for `super` (see "Object `super`" later in this chapter).

Generators (see Chapter 4) also have a concise method form:

```js
var o = {
    *foo() { .. }
};
```

#### Concisely Unnamed

While that convenience shorthand is quite attractive, there's a subtle gotcha to be aware of
- To illustrate, let's examine pre-ES6 code like the following, which you might try to refactor to use concise methods:

```js
function runSomething(o) {
    var x = Math.random(),
        y = Math.random();

    return o.something( x, y );
}

runSomething( {
    something: function something(x,y) {
        if (x > y) {
            // recursively call with `x`
            // and `y` swapped
            return something( y, x );
        }

        return y - x;
    }
} );
```

This obviously silly code just generates two random numbers and subtracts the smaller from the bigger
- But what's important here isn't what it does, but rather how it's defined. Let's focus on the object literal and function definition, as we see here:

```js
runSomething( {
    something: function something(x,y) {
        // ..
    }
} );
```

Why do we say both `something:` and `function something`? Isn't that redundant?
- Actually, no, both are needed for different purposes
- The property `something` is how we can call `o.something(..)`, sort of like its public name
- But the second `something` is a lexical name to refer to the function from inside itself, for recursion purposes

Can you see why the line `return something(y,x)` needs the name `something` to refer to the function?
- There's no lexical name for the object, such that it could have said `return o.something(y,x)` or something of that sort

That's actually a pretty common practice when the object literal does have an identifying name, such as:

```js
var controller = {
    makeRequest: function(..){
        // ..
        controller.makeRequest(..);
    }
};
```

Is this a good idea? Perhaps, perhaps not. You're assuming that the name `controller` will always point to the object in question
- But it very well may not -- the `makeRequest(..)` function doesn't control the outer code and so can't force that to be the case
- This could come back to bite you

Others prefer to use `this` to define such things:

```js
var controller = {
    makeRequest: function(..){
        // ..
        this.makeRequest(..);
    }
};
```

That looks fine, and should work if you always invoke the method as `controller.makeRequest(..)`
- But you now have a `this` binding gotcha if you do something like:

```js
btn.addEventListener( "click", controller.makeRequest, false );
```

Of course, you can solve that by passing `controller.makeRequest.bind(controller)` as the handler reference to bind the event to. But yuck -- it isn't very appealing.

Or what if your inner `this.makeRequest(..)` call needs to be made from a nested function?
- You'll have another `this` binding hazard, which people will often solve with the hacky `var self = this`, such as:

```js
var controller = {
    makeRequest: function(..){
        var self = this;

        btn.addEventListener( "click", function(){
            // ..
            self.makeRequest(..);
        }, false );
    }
};
```

More yuck.

**Note:** For more information on `this` binding rules and gotchas, see Chapters 1-2 of the *this & Object Prototypes* title of this series.

OK, what does all this have to do with concise methods? Recall our `something(..)` method definition:

```js
runSomething( {
    something: function something(x,y) {
        // ..
    }
} );
```

The second `something` here provides a super convenient lexical identifier that will always point to the function itself, giving us the perfect reference for recursion, event binding/unbinding, and so on -- no messing around with `this` or trying to use an untrustable object reference.

Great!

So, now we try to refactor that function reference to this ES6 concise method form:

```js
runSomething( {
    something(x,y) {
        if (x > y) {
            return something( y, x );
        }

        return y - x;
    }
} );
```

Seems fine at first glance, except this code will break. The `return something(..)` call will not find a `something` identifier, so you'll get a `ReferenceError`. Oops. But why?

The above ES6 snippet is interpreted as meaning:

```js
runSomething( {
    something: function(x,y){
        if (x > y) {
            return something( y, x );
        }

        return y - x;
    }
} );
```

Look closely. Do you see the problem? The concise method definition implies `something: function(x,y)`
- See how the second `something` we were relying on has been omitted? In other words, concise methods imply anonymous function expressions

Yeah, yuck.

**Note:** You may be tempted to think that `=>` arrow functions are a good solution here, but they're equally insufficient, as they're also anonymous function expressions
- We'll cover them in "Arrow Functions" later in this chapter

The partially redeeming news is that our `something(x,y)` concise method won't be totally anonymous
- See "Function Names" in Chapter 7 for information about ES6 function name inference rules
- That won't help us for our recursion, but it helps with debugging at least

So what are we left to conclude about concise methods? They're short and sweet, and a nice convenience
- But you should only use them if you're never going to need them to do recursion or event binding/unbinding
- Otherwise, stick to your old-school `something: function something(..)` method definitions

A lot of your methods are probably going to benefit from concise method definitions, so that's great news! Just be careful of the few where there's an un-naming hazard.

#### ES5 Getter/Setter

Technically, ES5 defined getter/setter literals forms, but they didn't seem to get used much, mostly due to the lack of transpilers to handle that new syntax (the only major new syntax added in ES5, really)
- So while it's not a new ES6 feature, we'll briefly refresh on that form, as it's probably going to be much more useful with ES6 going forward

Consider:

```js
var o = {
    __id: 10,
    get id() { return this.__id++; },
    set id(v) { this.__id = v; }
}

o.id; // 10
o.id; // 11
o.id = 20;
o.id; // 20

// and:
o.__id; // 21
o.__id; // 21 -- still!
```

These getter and setter literal forms are also present in classes; see Chapter 3.

**Warning:** It may not be obvious, but the setter literal must have exactly one declared parameter; omitting it or listing others is illegal syntax
- The single required parameter *can* use destructuring and defaults (e.g., `set id({ id: v = 0 }) { .. }`), but the gather/rest `...` is not allowed (`set id(...v) { .. }`)

### Computed Property Names

You've probably been in a situation like the following snippet, where you have one or more property names that come from some sort of expression and thus can't be put into the object literal:

```js
var prefix = "user_";

var o = {
    baz: function(..){ .. }
};

o[ prefix + "foo" ] = function(..){ .. };
o[ prefix + "bar" ] = function(..){ .. };
..
```

ES6 adds a syntax to the object literal definition which allows you to specify an expression that should be computed, whose result is the property name assigned. Consider:

```js
var prefix = "user_";

var o = {
    baz: function(..){ .. },
    [ prefix + "foo" ]: function(..){ .. },
    [ prefix + "bar" ]: function(..){ .. }
    ..
};
```

Any valid expression can appear inside the `[ .. ]` that sits in the property name position of the object literal definition.

Probably the most common use of computed property names will be with `Symbol`s (which we cover in "Symbols" later in this chapter), such as:

```js
var o = {
    [Symbol.toStringTag]: "really cool thing",
    ..
};
```

`Symbol.toStringTag` is a special built-in value, which we evaluate with the `[ .. ]` syntax, so we can assign the `"really cool thing"` value to the special property name.

Computed property names can also appear as the name of a concise method or a concise generator:

```js
var o = {
    ["f" + "oo"]() { .. }	// computed concise method
    *["b" + "ar"]() { .. }	// computed concise generator
};
```

### Setting `[[Prototype]]`

We won't cover prototypes in detail here, so for more information, see the *this & Object Prototypes* title of this series.

Sometimes it will be helpful to assign the `[[Prototype]]` of an object at the same time you're declaring its object literal
- The following has been a nonstandard extension in many JS engines for a while, but is standardized as of ES6:

```js
var o1 = {
    // ..
};

var o2 = {
    __proto__: o1,
    // ..
};
```

`o2` is declared with a normal object literal, but it's also `[[Prototype]]`-linked to `o1`
- The `__proto__` property name here can also be a string `"__proto__"`, but note that it *cannot* be the result of a computed property name (see the previous section)

`__proto__` is controversial, to say the least. It's a decades-old proprietary extension to JS that is finally standardized, somewhat begrudgingly it seems, in ES6
- Many developers feel it shouldn't ever be used. In fact, it's in "Annex B" of ES6, which is the section that lists things JS feels it has to standardize for compatibility reasons only

**Warning:** Though I'm narrowly endorsing `__proto__` as a key in an object literal definition, I definitely do not endorse using it in its object property form, like `o.__proto__`
- That form is both a getter and setter (again for compatibility reasons), but there are definitely better options. See the *this & Object Prototypes* title of this series for more information

For setting the `[[Prototype]]` of an existing object, you can use the ES6 utility `Object.setPrototypeOf(..)`. Consider:

```js
var o1 = {
    // ..
};

var o2 = {
    // ..
};

Object.setPrototypeOf( o2, o1 );
```

**Note:** We'll discuss `Object` again in Chapter 6.
- "`Object.setPrototypeOf(..)` Static Function" provides additional details on `Object.setPrototypeOf(..)`
- Also see "`Object.assign(..)` Static Function" for another form that relates `o2` prototypically to `o1`

### Object `super`

`super` is typically thought of as being only related to classes
- However, due to JS's classless-objects-with-prototypes nature, `super` is equally effective, and nearly the same in behavior, with plain objects' concise methods

Consider:

```js
var o1 = {
    foo() {
        console.log( "o1:foo" );
    }
};

var o2 = {
    foo() {
        super.foo();
        console.log( "o2:foo" );
    }
};

Object.setPrototypeOf( o2, o1 );

o2.foo(); // o1:foo
          // o2:foo
```

**Warning:** `super` is only allowed in concise methods, not regular function expression properties
- It also is only allowed in `super.XXX` form (for property/method access), not in `super()` form

The `super` reference in the `o2.foo()` method is locked statically to `o2`, and specifically to the `[[Prototype]]` of `o2`
- `super` here would basically be `Object.getPrototypeOf(o2)` -- resolves to `o1` of course -- which is how it finds and calls `o1.foo()`

For complete details on `super`, see "Classes" in Chapter 3.

## Template Literals

At the very outset of this section, I'm going to have to call out the name of this ES6 feature as being awfully... misleading, depending on your experiences with what the word *template* means.

Many developers think of templates as being reusable renderable pieces of text, such as the capability provided by most template engines (Mustache, Handlebars, etc.)
- ES6's use of the word *template* would imply something similar, like a way to declare inline template literals that can be re-rendered. However, that's not at all the right way to think about this feature

So, before we go on, I'm renaming to what it should have been called: *interpolated string literals* (or *interpoliterals* for short).

You're already well aware of declaring string literals with `"` or `'` delimiters, and you also know that these are not *smart strings* (as some languages have), where the contents would be parsed for interpolation expressions.

However, ES6 introduces a new type of string literal, using the `` ` `` backtick as the delimiter
- These string literals allow basic string interpolation expressions to be embedded, which are then automatically parsed and evaluated

Here's the old pre-ES6 way:

```js
var name = "Kyle";
var greeting = "Hello " + name + "!";

console.log( greeting );  // "Hello Kyle!"
console.log( typeof greeting ); // "string"
```

Now, consider the new ES6 way:

```js
var name = "Kyle";
var greeting = `Hello ${name}!`;

console.log( greeting );  // "Hello Kyle!"
console.log( typeof greeting ); // "string"
```

As you can see, we used the `` `..` `` around a series of characters, which are interpreted as a string literal, but any expressions of the form `${..}` are parsed and evaluated inline immediately
- The fancy term for such parsing and evaluating is *interpolation* (much more accurate than templating)

The result of the interpolated string literal expression is just a plain old normal string, assigned to the `greeting` variable.

**Warning:** `typeof greeting == "string"` illustrates why it's important not to think of these entities as special template values, as you cannot assign the unevaluated form of the literal to something and reuse it
- The `` `..` `` string literal is more like an IIFE in the sense that it's automatically evaluated inline
- The result of a `` `..` `` string literal is, simply, just a string

One really nice benefit of interpolated string literals is they are allowed to split across multiple lines:

```js
var text =
`Now is the time for all good men
to come to the aid of their
country!`;

console.log( text );
// Now is the time for all good men
// to come to the aid of their
// country!
```

The line breaks (newlines) in the interpolated string literal were preserved in the string value.

Unless appearing as explicit escape sequences in the literal value, the value of the `\r` carriage return character (code point `U+000D`) or the value of the `\r\n` carriage return + line feed sequence (code points `U+000D` and `U+000A`) are both normalized to a `\n` line feed character (code point `U+000A`)
-Don't worry though; this normalization is rare and would likely only happen if copy-pasting text into your JS file

### Interpolated Expressions

Any valid expression is allowed to appear inside `${..}` in an interpolated string literal, including function calls, inline function expression calls, and even other interpolated string literals!

Consider:

```js
function upper(s) {
    return s.toUpperCase();
}

var who = "reader";

var text =
`A very ${upper( "warm" )} welcome
to all of you ${upper( `${who}s` )}!`;

console.log( text );
// A very WARM welcome
// to all of you READERS!
```

Here, the inner `` `${who}s` `` interpolated string literal was a little bit nicer convenience for us when combining the `who` variable with the `"s"` string, as opposed to `who + "s"`
- There will be cases that nesting interpolated string literals is helpful, but be wary if you find yourself doing that kind of thing often, or if you find yourself nesting several levels deep

If that's the case, the odds are good that your string value production could benefit from some abstractions.

**Warning:** As a word of caution, be very careful about the readability of your code with such new found power. Just like with default value expressions and destructuring assignment expressions, just because you *can* do something doesn't mean you *should* do it
- Never go so overboard with new ES6 tricks that your code becomes more clever than you or your other team members

#### Expression Scope

One quick note about the scope that is used to resolve variables in expressions
- I mentioned earlier that an interpolated string literal is kind of like an IIFE, and it turns out thinking about it like that explains the scoping behavior as well

Consider:

```js
function foo(str) {
    var name = "foo";
    console.log( str );
}

function bar() {
    var name = "bar";
    foo( `Hello from ${name}!` );
}

var name = "global";

bar();  // "Hello from bar!"
```

At the moment the `` `..` `` string literal is expressed, inside the `bar()` function, the scope available to it finds `bar()`'s `name` variable with value `"bar"`
- Neither the global `name` nor `foo(..)`'s `name` matter
- In other words, an interpolated string literal is just lexically scoped where it appears, not dynamically scoped in any way

### Tagged Template Literals

Again, renaming the feature for sanity sake: *tagged string literals*.

To be honest, this is one of the cooler tricks that ES6 offers
- It may seem a little strange, and perhaps not all that generally practical at first
- But once you've spent some time with it, tagged string literals may just surprise you in their usefulness

For example:

```js
function foo(strings, ...values) {
    console.log( strings );
    console.log( values );
}

var desc = "awesome";

foo`Everything is ${desc}!`;
// [ "Everything is ", "!"]
// [ "awesome" ]
```

Let's take a moment to consider what's happening in the previous snippet
- First, the most jarring thing that jumps out is ``foo`Everything...`;``
- That doesn't look like anything we've seen before. What is it?

It's essentially a special kind of function call that doesn't need the `( .. )`
- The *tag* -- the `foo` part before the `` `..` `` string literal -- is a function value that should be called
- Actually, it can be any expression that results in a function, even a function call that returns another function, like:

```js
function bar() {
    return function foo(strings, ...values) {
        console.log( strings );
        console.log( values );
    }
}

var desc = "awesome";

bar()`Everything is ${desc}!`;
// [ "Everything is ", "!"]
// [ "awesome" ]
```

But what gets passed to the `foo(..)` function when invoked as a tag for a string literal?

The first argument -- we called it `strings` -- is an array of all the plain strings (the stuff between any interpolated expressions)
- We get two values in the `strings` array: `"Everything is "` and `"!"`

For convenience sake in our example, we then gather up all subsequent arguments into an array called `values` using the `...` gather/rest operator (see the "Spread/Rest" section earlier in this chapter), though you could of course have left them as individual named parameters following the `strings` parameter.

The argument(s) gathered into our `values` array are the results of the already-evaluated interpolation expressions found in the string literal
- So obviously the only element in `values` in our example is `"awesome"`

You can think of these two arrays as: the values in `values` are the separators if you were to splice them in between the values in `strings`, and then if you joined everything together, you'd get the complete interpolated string value.

A tagged string literal is like a processing step after the interpolation expressions are evaluated but before the final string value is compiled, allowing you more control over generating the string from the literal.

Typically, the string literal tag function (`foo(..)` in the previous snippets) should compute an appropriate string value and return it, so that you can use the tagged string literal as a value just like untagged string literals:

```js
function tag(strings, ...values) {
    return strings.reduce( function(s,v,idx){
        return s + (idx > 0 ? values[idx-1] : "") + v;
    }, "" );
}

var desc = "awesome";
var text = tag`Everything is ${desc}!`;

console.log( text );  // Everything is awesome!
```

In this snippet, `tag(..)` is a pass-through operation, in that it doesn't perform any special modifications, but just uses `reduce(..)` to loop over and splice/interleave `strings` and `values` together the same way an untagged string literal would have done.

So what are some practical uses? There are many advanced ones that are beyond our scope to discuss here
- But here's a simple idea that formats numbers as U.S. dollars (sort of like basic localization):

```js
function dollabillsyall(strings, ...values) {
    return strings.reduce( function(s,v,idx){
        if (idx > 0) {
            if (typeof values[idx-1] == "number") {
                // look, also using interpolated
                // string literals!
                s += `$${values[idx-1].toFixed( 2 )}`;
            }
            else {
                s += values[idx-1];
            }
        }

        return s + v;
    }, "" );
}

var amt1 = 11.99,
    amt2 = amt1 * 1.08,
    name = "Kyle";

var text = dollabillsyall
`Thanks for your purchase, ${name}! Your
product cost was ${amt1}, which with tax
comes out to ${amt2}.`

console.log( text );
// Thanks for your purchase, Kyle! Your
// product cost was $11.99, which with tax
// comes out to $12.95.
```

If a `number` value is encountered in the `values` array, we put `"$"` in front of it and format it to two decimal places with `toFixed(2)`
- Otherwise, we let the value pass-through untouched

#### Raw Strings

In the previous snippets, our tag functions receive the first argument we called `strings`, which is an array
- But there's an additional bit of data included: the raw unprocessed versions of all the strings
- You can access those raw string values using the `.raw` property, like this:

```js
function showraw(strings, ...values) {
    console.log( strings );
    console.log( strings.raw );
}

showraw`Hello\nWorld`;
// [ "Hello
// World" ]
// [ "Hello\nWorld" ]
```

The raw version of the value preserves the raw escaped `\n` sequence (the `\` and the `n` are separate characters), while the processed version considers it a single newline character. However, the earlier mentioned line-ending normalization is applied to both values.

ES6 comes with a built-in function that can be used as a string literal tag: `String.raw(..)`
-It simply passes through the raw versions of the `strings` values:

```js
console.log( `Hello\nWorld` );
// Hello
// World

console.log( String.raw`Hello\nWorld` );
// Hello\nWorld

String.raw`Hello\nWorld`.length;
// 12
```

Other uses for string literal tags included special processing for internationalization, localization, and more!

## Arrow Functions

We've touched on `this` binding complications with functions earlier in this chapter, and they're covered at length in the *this & Object Prototypes* title of this series
- It's important to understand the frustrations that `this`-based programming with normal functions brings, because that is the primary motivation for the new ES6 `=>` arrow function feature

Let's first illustrate what an arrow function looks like, as compared to normal functions:

```js
function foo(x,y) {
    return x + y;
}

// versus

var foo = (x,y) => x + y;
```

The arrow function definition consists of a parameter list (of zero or more parameters, and surrounding `( .. )` if there's not exactly one parameter), followed by the `=>` marker, followed by a function body.

So, in the previous snippet, the arrow function is just the `(x,y) => x + y` part, and that function reference happens to be assigned to the variable `foo`.

The body only needs to be enclosed by `{ .. }` if there's more than one expression, or if the body consists of a non-expression statement
- If there's only one expression, and you omit the surrounding `{ .. }`, there's an implied `return` in front of the expression, as illustrated in the previous snippet

Here's some other arrow function variations to consider:

```js
var f1 = () => 12;
var f2 = x => x * 2;
var f3 = (x,y) => {
    var z = x * 2 + y;
    y++;
    x *= 3;
    return (x + y + z) / 2;
};
```

Arrow functions are *always* function expressions; there is no arrow function declaration
- It also should be clear that they are anonymous function expressions -- they have no named reference for the purposes of recursion or event binding/unbinding -- though "Function Names" in Chapter 7 will describe ES6's function name inference rules for debugging purposes

**Note:** All the capabilities of normal function parameters are available to arrow functions, including default values, destructuring, rest parameters, and so on.

Arrow functions have a nice, shorter syntax, which makes them on the surface very attractive for writing terser code. Indeed, nearly all literature on ES6 (other than the titles in this series) seems to immediately and exclusively adopt the arrow function as "the new function."

It is telling that nearly all examples in discussion of arrow functions are short single statement utilities, such as those passed as callbacks to various utilities. For example:

```js
var a = [1,2,3,4,5];

a = a.map( v => v * 2 );

console.log( a ); // [2,4,6,8,10]
```

In those cases, where you have such inline function expressions, and they fit the pattern of computing a quick calculation in a single statement and returning that result, arrow functions indeed look to be an attractive and lightweight alternative to the more verbose `function` keyword and syntax.

Most people tend to *ooh and aah* at nice terse examples like that, as I imagine you just did!

However, I would caution you that it would seem to me somewhat a misapplication of this feature to use arrow function syntax with otherwise normal, multistatement functions, especially those that would otherwise be naturally expressed as function declarations.

Recall the `dollabillsyall(..)` string literal tag function from earlier in this chapter -- let's change it to use `=>` syntax:

```js
var dollabillsyall = (strings, ...values) =>
    strings.reduce( (s,v,idx) => {
        if (idx > 0) {
            if (typeof values[idx-1] == "number") {
                // look, also using interpolated
                // string literals!
                s += `$${values[idx-1].toFixed( 2 )}`;
            }
            else {
                s += values[idx-1];
            }
        }

        return s + v;
    }, "" );
```

In this example,  the only modifications I made were the removal of `function`, `return`, and some `{ .. }`, and then the insertion of `=>` and a `var`
- Is this a significant improvement in the readability of the code? Meh

I'd actually argue that the lack of `return` and outer `{ .. }` partially obscures the fact that the `reduce(..)` call is the only statement in the `dollabillsyall(..)` function and that its result is the intended result of the call
- Also, the trained eye that is so used to hunting for the word `function` in code to find scope boundaries now needs to look for the `=>` marker, which can definitely be harder to find in the thick of the code

While not a hard-and-fast rule, I'd say that the readability gains from `=>` arrow function conversion are inversely proportional to the length of the function being converted. The longer the function, the less `=>` helps; the shorter the function, the more `=>` can shine.

I think it's probably more sensible and reasonable to adopt `=>` for the places in code where you do need short inline function expressions, but leave your normal-length main functions as is.

### Not Just Shorter Syntax, But `this`

Most of the popular attention toward `=>` has been on saving those precious keystrokes by dropping `function`, `return`, and `{ .. }` from your code.

But there's a big detail we've skipped over so far. I said at the beginning of the section that `=>` functions are closely related to `this` binding behavior
- In fact, `=>` arrow functions are *primarily designed* to alter `this` behavior in a specific way, solving a particular and common pain point with `this`-aware coding

The saving of keystrokes is a red herring, a misleading sideshow at best.

Let's revisit another example from earlier in this chapter:

```js
var controller = {
    makeRequest: function(..){
        var self = this;

        btn.addEventListener( "click", function(){
            // ..
            self.makeRequest(..);
        }, false );
    }
};
```

We used the `var self = this` hack, and then referenced `self.makeRequest(..)`, because inside the callback function we're passing to `addEventListener(..)`, the `this` binding will not be the same as it is in `makeRequest(..)` itself
- In other words, because `this` bindings are dynamic, we fall back to the predictability of lexical scope via the `self` variable

Herein we finally can see the primary design characteristic of `=>` arrow functions
- Inside arrow functions, the `this` binding is not dynamic, but is instead lexical
- In the previous snippet, if we used an arrow function for the callback, `this` will be predictably what we wanted it to be

Consider:

```js
var controller = {
    makeRequest: function(..){
        btn.addEventListener( "click", () => {
            // ..
            this.makeRequest(..);
        }, false );
    }
};
```

Lexical `this` in the arrow function callback in the previous snippet now points to the same value as in the enclosing `makeRequest(..)` function
- In other words, `=>` is a syntactic stand-in for `var self = this`

In cases where `var self = this` (or, alternatively, a function `.bind(this)` call) would normally be helpful, `=>` arrow functions are a nicer alternative operating on the same principle. Sounds great, right?

Not quite so simple.

If `=>` replaces `var self = this` or `.bind(this)` and it helps, guess what happens if you use `=>` with a `this`-aware function that *doesn't* need `var self = this` to work?
- You might be able to guess that it's going to mess things up. Yeah

Consider:

```js
var controller = {
    makeRequest: (..) => {
        // ..
        this.helper(..);
    },
    helper: (..) => {
        // ..
    }
};

controller.makeRequest(..);
```

Although we invoke as `controller.makeRequest(..)`, the `this.helper` reference fails, because `this` here doesn't point to `controller` as it normally would. Where does it point?
- It lexically inherits `this` from the surrounding scope. In this previous snippet, that's the global scope, where `this` points to the global object. Ugh

In addition to lexical `this`, arrow functions also have lexical `arguments` -- they don't have their own `arguments` array but instead inherit from their parent -- as well as lexical `super` and `new.target` (see "Classes" in Chapter 3).

So now we can conclude a more nuanced set of rules for when `=>` is appropriate and not:

* If you have a short, single-statement inline function expression, where the only statement is a `return` of some computed value, *and* that function doesn't already make a `this` reference inside it, *and* there's no self-reference (recursion, event binding/unbinding), *and* you don't reasonably expect the function to ever be that way, you can probably safely refactor it to be an `=>` arrow function.
* If you have an inner function expression that's relying on a `var self = this` hack or a `.bind(this)` call on it in the enclosing function to ensure proper `this` binding, that inner function expression can probably safely become an `=>` arrow function.
* If you have an inner function expression that's relying on something like `var args = Array.prototype.slice.call(arguments)` in the enclosing function to make a lexical copy of `arguments`, that inner function expression can probably safely become an `=>` arrow function.
* For everything else -- normal function declarations, longer multistatement function expressions, functions that need a lexical name identifier self-reference (recursion, etc.), and any other function that doesn't fit the previous characteristics -- you should probably avoid `=>` function syntax.

Bottom line: `=>` is about lexical binding of `this`, `arguments`, and `super`
- These are intentional features designed to fix some common problems, not bugs, quirks, or mistakes in ES6

Don't believe any hype that `=>` is primarily, or even mostly, about fewer keystrokes
- Whether you save keystrokes or waste them, you should know exactly what you are intentionally doing with every character typed

**Tip:** If you have a function that for any of these articulated reasons is not a good match for an `=>` arrow function, but it's being declared as part of an object literal, recall from "Concise Methods" earlier in this chapter that there's another option for shorter function syntax.

If you prefer a visual decision chart for how/why to pick an arrow function:

<img src="fig1.png">

## `for..of` Loops

Joining the `for` and `for..in` loops from the JavaScript we're all familiar with, ES6 adds a `for..of` loop, which loops over the set of values produced by an *iterator*.

The value you loop over with `for..of` must be an *iterable*, or it must be a value which can be coerced/boxed to an object (see the *Types & Grammar* title of this series) that is an iterable. An iterable is simply an object that is able to produce an iterator, which the loop then uses.

Let's compare `for..of` to `for..in` to illustrate the difference:

```js
var a = ["a","b","c","d","e"];

for (var idx in a) {
    console.log( idx );
}
// 0 1 2 3 4

for (var val of a) {
    console.log( val );
}
// "a" "b" "c" "d" "e"
```

As you can see, `for..in` loops over the keys/indexes in the `a` array, while `for..of` loops over the values in `a`.

Here's the pre-ES6 version of the `for..of` from that previous snippet:

```js
var a = ["a","b","c","d","e"],
    k = Object.keys( a );

for (var val, i = 0; i < k.length; i++) {
    val = a[ k[i] ];
    console.log( val );
}
// "a" "b" "c" "d" "e"
```

And here's the ES6 but non-`for..of` equivalent, which also gives a glimpse at manually iterating an iterator (see "Iterators" in Chapter 3):

```js
var a = ["a","b","c","d","e"];

for (var val, ret, it = a[Symbol.iterator]();
    (ret = it.next()) && !ret.done;
) {
    val = ret.value;
    console.log( val );
}
// "a" "b" "c" "d" "e"
```

Under the covers, the `for..of` loop asks the iterable for an iterator (using the built-in `Symbol.iterator`; see "Well-Known Symbols" in Chapter 7), then it repeatedly calls the iterator and assigns its produced value to the loop iteration variable.

Standard built-in values in JavaScript that are by default iterables (or provide them) include:

* Arrays
* Strings
* Generators (see Chapter 3)
* Collections / TypedArrays (see Chapter 5)

**Warning:** Plain objects are not by default suitable for `for..of` looping
- That's because they don't have a default iterator, which is intentional, not a mistake
- However, we won't go any further into those nuanced reasonings here
- In "Iterators" in Chapter 3, we'll see how to define iterators for our own objects, which lets `for..of` loop over any object to get a set of values we define

Here's how to loop over the characters in a primitive string:

```js
for (var c of "hello") {
    console.log( c );
}
// "h" "e" "l" "l" "o"
```

The `"hello"` primitive string value is coerced/boxed to the `String` object wrapper equivalent, which is an iterable by default.

In `for (XYZ of ABC)..`, the `XYZ` clause can either be an assignment expression or a declaration, identical to that same clause in `for` and `for..in` loops. So you can do stuff like this:

```js
var o = {};

for (o.a of [1,2,3]) {
    console.log( o.a );
}
// 1 2 3

for ({x: o.a} of [ {x: 1}, {x: 2}, {x: 3} ]) {
    console.log( o.a );
}
// 1 2 3
```

`for..of` loops can be prematurely stopped, just like other loops, with `break`, `continue`, `return` (if in a function), and thrown exceptions
- In any of these cases, the iterator's `return(..)` function is automatically called (if one exists) to let the iterator perform cleanup tasks, if necessary

**Note:** See "Iterators" in Chapter 3 for more complete coverage on iterables and iterators.

## Regular Expressions

Let's face it: regular expressions haven't changed much in JS in a long time
- So it's a great thing that they've finally learned a couple of new tricks in ES6. We'll briefly cover the additions here, but the overall topic of regular expressions is so dense that you'll need to turn to chapters/books dedicated to it (of which there are many!) if you need a refresher

### Unicode Flag

We'll cover the topic of Unicode in more detail in "Unicode" later in this chapter
- Here, we'll just look briefly at the new `u` flag for ES6+ regular expressions, which turns on Unicode matching for that expression

JavaScript strings are typically interpreted as sequences of 16-bit characters, which correspond to the characters in the *Basic Multilingual Plane (BMP)* (http://en.wikipedia.org/wiki/Plane_%28Unicode%29)
- But there are many UTF-16 characters that fall outside this range, and so strings may have these multibyte characters in them

Prior to ES6, regular expressions could only match based on BMP characters, which means that those extended characters were treated as two separate characters for matching purposes. This is often not ideal.

So, as of ES6, the `u` flag tells a regular expression to process a string with the interpretation of Unicode (UTF-16) characters, such that such an extended character will be matched as a single entity.

**Warning:** Despite the name implication, "UTF-16" doesn't strictly mean 16 bits
- Modern Unicode uses 21 bits, and standards like UTF-8 and UTF-16 refer roughly to how many bits are used in the representation of a character

An example (straight from the ES6 specification): 𝄞 (the musical symbol G-clef) is Unicode point U+1D11E (0x1D11E).

If this character appears in a regular expression pattern (like `/𝄞/`), the standard BMP interpretation would be that it's two separate characters (0xD834 and 0xDD1E) to match with. But the new ES6 Unicode-aware mode means that `/𝄞/u` (or the escaped Unicode form `/\u{1D11E}/u`) will match `"𝄞"` in a string as a single matched character.

You might be wondering why this matters?
- In non-Unicode BMP mode, the pattern is treated as two separate characters, but would still find the match in a string with the `"𝄞"` character in it, as you can see if you try:

```js
/𝄞/.test( "𝄞-clef" ); // true
```

The length of the match is what matters. For example:

```js
/^.-clef/ .test( "𝄞-clef" );  // false
/^.-clef/u.test( "𝄞-clef" );  // true
```

The `^.-clef` in the pattern says to match only a single character at the beginning before the normal `"-clef"` text. In standard BMP mode, the match fails (two characters), but with `u` Unicode mode flagged on, the match succeeds (one character).

It's also important to note that `u` makes quantifiers like `+` and `*` apply to the entire Unicode code point as a single character, not just the *lower surrogate* (aka rightmost half of the symbol) of the character
- The same goes for Unicode characters appearing in character classes, like `/[💩-💫]/u`

**Note:** There's plenty more nitty-gritty details about `u` behavior in regular expressions, which Mathias Bynens (https://twitter.com/mathias) has written extensively about (https://mathiasbynens.be/notes/es6-unicode-regex).

### Sticky Flag

Another flag mode added to ES6 regular expressions is `y`, which is often called "sticky mode."
- *Sticky* essentially means the regular expression has a virtual anchor at its beginning that keeps it rooted to matching at only the position indicated by the regular expression's `lastIndex` property

To illustrate, let's consider two regular expressions, the first without sticky mode and the second with:

```js
var re1 = /foo/,
    str = "++foo++";

re1.lastIndex;  // 0
re1.test( str );  // true
re1.lastIndex;  // 0 -- not updated

re1.lastIndex = 4;
re1.test( str );  // true -- ignored `lastIndex`
re1.lastIndex;  // 4 -- not updated
```

Three things to observe about this snippet:

* `test(..)` doesn't pay any attention to `lastIndex`'s value, and always just performs its match from the beginning of the input string.
* Because our pattern does not have a `^` start-of-input anchor, the search for `"foo"` is free to move ahead through the whole string looking for a match.
* `lastIndex` is not updated by `test(..)`.

Now, let's try a sticky mode regular expression:

```js
var re2 = /foo/y, // <-- notice the `y` sticky flag
    str = "++foo++";

re2.lastIndex;  // 0
re2.test( str );  // false -- "foo" not found at `0`
re2.lastIndex;  // 0

re2.lastIndex = 2;
re2.test( str );  // true
re2.lastIndex;  // 5 -- updated to after previous match

re2.test( str );  // false
re2.lastIndex;  // 0 -- reset after previous match failure
```

And so our new observations about sticky mode:

* `test(..)` uses `lastIndex` as the exact and only position in `str` to look to make a match. There is no moving ahead to look for the match -- it's either there at the `lastIndex` position or not.
* If a match is made, `test(..)` updates `lastIndex` to point to the character immediately following the match. If a match fails, `test(..)` resets `lastIndex` back to `0`.

Normal non-sticky patterns that aren't otherwise `^`-rooted to the start-of-input are free to move ahead in the input string looking for a match
- But sticky mode restricts the pattern to matching just at the position of `lastIndex`

As I suggested at the beginning of this section, another way of looking at this is that `y` implies a virtual anchor at the beginning of the pattern that is relative (aka constrains the start of the match) to exactly the `lastIndex` position.

**Warning:** In previous literature on the topic, it has alternatively been asserted that this behavior is like `y` implying a `^` (start-of-input) anchor in the pattern
- This is inaccurate. We'll explain in further detail in "Anchored Sticky" later

#### Sticky Positioning

It may seem strangely limiting that to use `y` for repeated matches, you have to manually ensure `lastIndex` is in the exact right position, as it has no move-ahead capability for matching.

Here's one possible scenario: if you know that the match you care about is always going to be at a position that's a multiple of a number (e.g., `0`, `10`, `20`, etc.), you can just construct a limited pattern matching what you care about, but then manually set `lastIndex` each time before match to those fixed positions.

Consider:

```js
var re = /f../y,
    str = "foo       far       fad";

str.match( re );  // ["foo"]

re.lastIndex = 10;
str.match( re );  // ["far"]

re.lastIndex = 20;
str.match( re );  // ["fad"]
```

However, if you're parsing a string that isn't formatted in fixed positions like that, figuring out what to set `lastIndex` to before each match is likely going to be untenable.

There's a saving nuance to consider here. `y` requires that `lastIndex` be in the exact position for a match to occur. But it doesn't strictly require that *you* manually set `lastIndex`.

Instead, you can construct your expressions in such a way that they capture in each main match everything before and after the thing you care about, up to right before the next thing you'll care to match.

Because `lastIndex` will set to the next character beyond the end of a match, if you've matched everything up to that point, `lastIndex` will always be in the correct position for the `y` pattern to start from the next time.

**Warning:** If you can't predict the structure of the input string in a sufficiently patterned way like that, this technique may not be suitable and you may not be able to use `y`.

Having structured string input is likely the most practical scenario where `y` will be capable of performing repeated matching throughout a string. Consider:

```js
var re = /\d+\.\s(.*?)(?:\s|$)/y
    str = "1. foo 2. bar 3. baz";

str.match( re );  // [ "1. foo ", "foo" ]

re.lastIndex; // 7 -- correct position!
str.match( re );  // [ "2. bar ", "bar" ]

re.lastIndex; // 14 -- correct position!
str.match( re );  // ["3. baz", "baz"]
```

This works because I knew something ahead of time about the structure of the input string: there is always a numeral prefix like `"1. "` before the desired match (`"foo"`, etc.), and either a space after it, or the end of the string (`$` anchor)
- So the regular expression I constructed captures all of that in each main match, and then I use a matching group `( )` so that the stuff I really care about is separated out for convenience

After the first match (`"1. foo "`), the `lastIndex` is `7`, which is already the position needed to start the next match, for `"2. bar "`, and so on.

If you're going to use `y` sticky mode for repeated matches, you'll probably want to look for opportunities to have `lastIndex` automatically positioned as we've just demonstrated.

#### Sticky Versus Global

Some readers may be aware that you can emulate something like this `lastIndex`-relative matching with the `g` global match flag and the `exec(..)` method, as so:

```js
var re = /o+./g,  // <-- look, `g`!
    str = "foot book more";

re.exec( str ); // ["oot"]
re.lastIndex; // 4

re.exec( str ); // ["ook"]
re.lastIndex; // 9

re.exec( str ); // ["or"]
re.lastIndex; // 13

re.exec( str ); // null -- no more matches!
re.lastIndex; // 0 -- starts over now!
```

While it's true that `g` pattern matches with `exec(..)` start their matching from `lastIndex`'s current value, and also update `lastIndex` after each match (or failure), this is not the same thing as `y`'s behavior.

Notice in the previous snippet that `"ook"`, located at position `6`, was matched and found by the second `exec(..)` call, even though at the time, `lastIndex` was `4` (from the end of the previous match). Why? Because as we said earlier, non-sticky matches are free to move ahead in their matching
- A sticky mode expression would have failed here, because it would not be allowed to move ahead

In addition to perhaps undesired move-ahead matching behavior, another downside to just using `g` instead of `y` is that `g` changes the behavior of some matching methods, like `str.match(re)`.

Consider:

```js
var re = /o+./g,  // <-- look, `g`!
    str = "foot book more";

str.match( re );  // ["oot","ook","or"]
```

See how all the matches were returned at once? Sometimes that's OK, but sometimes that's not what you want.

The `y` sticky flag will give you one-at-a-time progressive matching with utilities like `test(..)` and `match(..)`
- Just make sure the `lastIndex` is always in the right position for each match!

#### Anchored Sticky

As we warned earlier, it's inaccurate to think of sticky mode as implying a pattern starts with `^`
- The `^` anchor has a distinct meaning in regular expressions, which is *not altered* by sticky mode. `^` is an anchor that *always* refers to the beginning of the input, and *is not* in any way relative to `lastIndex`

Besides poor/inaccurate documentation on this topic, the confusion is unfortunately strengthened further because an older pre-ES6 experiment with sticky mode in Firefox *did* make `^` relative to `lastIndex`, so that behavior has been around for years.

ES6 elected not to do it that way. `^` in a pattern means start-of-input absolutely and only.

As a consequence, a pattern like `/^foo/y` will always and only find a `"foo"` match at the beginning of a string, *if it's allowed to match there*
- If `lastIndex` is not `0`, the match will fail. Consider:

```js
var re = /^foo/y,
    str = "foo";

re.test( str ); // true
re.test( str ); // false
re.lastIndex; // 0 -- reset after failure

re.lastIndex = 1;
re.test( str ); // false -- failed for positioning
re.lastIndex; // 0 -- reset after failure
```

Bottom line: `y` plus `^` plus `lastIndex > 0` is an incompatible combination that will always cause a failed match.

**Note:** While `y` does not alter the meaning of `^` in any way, the `m` multiline mode *does*, such that `^` means start-of-input *or* start of text after a newline
- So, if you combine `y` and `m` flags together for a pattern, you can find multiple `^`-rooted matches in a string
- But remember: because it's `y` sticky, you'll have to make sure `lastIndex` is pointing at the correct new line position (likely by matching to the end of the line) each subsequent time, or no subsequent matches will be made

### Regular Expression `flags`

Prior to ES6, if you wanted to examine a regular expression object to see what flags it had applied, you needed to parse them out -- ironically, probably with another regular expression -- from the content of the `source` property, such as:

```js
var re = /foo/ig;

re.toString();  // "/foo/ig"

var flags = re.toString().match( /\/([gim]*)$/ )[1];

flags;  // "ig"
```

As of ES6, you can now get these values directly, with the new `flags` property:

```js
var re = /foo/ig;

re.flags; // "gi"
```

It's a small nuance, but the ES6 specification calls for the expression's flags to be listed in this order: `"gimuy"`, regardless of what order the original pattern was specified with
- That's the reason for the difference between `/ig` and `"gi"`

No, the order of flags specified or listed doesn't matter.

Another tweak from ES6 is that the `RegExp(..)` constructor is now `flags`-aware if you pass it an existing regular expression:

```js
var re1 = /foo*/y;
re1.source; // "foo*"
re1.flags;  // "y"

var re2 = new RegExp( re1 );
re2.source; // "foo*"
re2.flags;  // "y"

var re3 = new RegExp( re1, "ig" );
re3.source; // "foo*"
re3.flags;  // "gi"
```

Prior to ES6, the `re3` construction would throw an error, but as of ES6 you can override the flags when duplicating.

## Number Literal Extensions

Prior to ES5, number literals looked like the following -- the octal form was not officially specified, only allowed as an extension that browsers had come to de facto agreement on:

```js
var dec = 42,
    oct = 052,
    hex = 0x2a;
```

**Note:** Though you are specifying a number in different bases, the number's mathematic value is what is stored, and the default output interpretation is always base-10
- The three variables in the previous snippet all have the `42` value stored in them

To further illustrate that `052` was a nonstandard form extension, consider:

```js
Number( "42" ); // 42
Number( "052" );  // 52
Number( "0x2a" ); // 42
```

ES5 continued to permit the browser-extended octal form (including such inconsistencies), except that in strict mode, the octal literal (`052`) form is disallowed
- This restriction was done mainly because many developers had the habit (from other languages) of seemingly innocuously prefixing otherwise base-10 numbers with `0`'s for code alignment purposes, and then running into the accidental fact that they'd changed the number value entirely!

ES6 continues the legacy of changes/variations to how number literals outside base-10 numbers can be represented. There's now an official octal form, an amended hexadecimal form, and a brand-new binary form. For web compatibility reasons, the old octal `052` form will continue to be legal (though unspecified) in non-strict mode, but should really never be used anymore.

Here are the new ES6 number literal forms:

```js
var dec = 42,
	oct = 0o52,			// or `0O52` :(
	hex = 0x2a,			// or `0X2a` :/
	bin = 0b101010;		// or `0B101010` :/
```

The only decimal form allowed is base-10. Octal, hexadecimal, and binary are all integer forms.

And the string representations of these forms are all able to be coerced/converted to their number equivalent:

```js
Number( "42" );			// 42
Number( "0o52" );		// 42
Number( "0x2a" );		// 42
Number( "0b101010" );	// 42
```

Though not strictly new to ES6, it's a little-known fact that you can actually go the opposite direction of conversion (well, sort of):

```js
var a = 42;

a.toString();			// "42" -- also `a.toString( 10 )`
a.toString( 8 );		// "52"
a.toString( 16 );		// "2a"
a.toString( 2 );		// "101010"
```

In fact, you can represent a number this way in any base from `2` to `36`, though it'd be rare that you'd go outside the standard bases: 2, 8, 10, and 16.

## Unicode

Let me just say that this section is not an exhaustive everything-you-ever-wanted-to-know-about-Unicode resource. I want to cover what you need to know that's *changing* for Unicode in ES6, but we won't go much deeper than that. Mathias Bynens (http://twitter.com/mathias) has written/spoken extensively and brilliantly about JS and Unicode (see https://mathiasbynens.be/notes/javascript-unicode and http://fluentconf.com/javascript-html-2015/public/content/2015/02/18-javascript-loves-unicode).

The Unicode characters that range from `0x0000` to `0xFFFF` contain all the standard printed characters (in various languages) that you're likely to have seen or interacted with. This group of characters is called the *Basic Multilingual Plane (BMP)*. The BMP even contains fun symbols like this cool snowman: ☃ (U+2603).

There are lots of other extended Unicode characters beyond this BMP set, which range up to `0x10FFFF`. These symbols are often referred to as *astral* symbols, as that's the name given to the set of 16 *planes* (e.g., layers/groupings) of characters beyond the BMP. Examples of astral symbols include 𝄞 (U+1D11E) and 💩 (U+1F4A9).

Prior to ES6, JavaScript strings could specify Unicode characters using Unicode escaping, such as:

```js
var snowman = "\u2603";
console.log( snowman );			// "☃"
```

However, the `\uXXXX` Unicode escaping only supports four hexadecimal characters, so you can only represent the BMP set of characters in this way. To represent an astral character using Unicode escaping prior to ES6, you need to use a *surrogate pair* -- basically two specially calculated Unicode-escaped characters side by side, which JS interprets together as a single astral character:

```js
var gclef = "\uD834\uDD1E";
console.log( gclef );			// "𝄞"
```

As of ES6, we now have a new form for Unicode escaping (in strings and regular expressions), called Unicode *code point escaping*:

```js
var gclef = "\u{1D11E}";
console.log( gclef );			// "𝄞"
```

As you can see, the difference is the presence of the `{ }` in the escape sequence, which allows it to contain any number of hexadecimal characters. Because you only need six to represent the highest possible code point value in Unicode (i.e., 0x10FFFF), this is sufficient.

### Unicode-Aware String Operations

By default, JavaScript string operations and methods are not sensitive to astral symbols in string values. So, they treat each BMP character individually, even the two surrogate halves that make up an otherwise single astral character. Consider:

```js
var snowman = "☃";
snowman.length;					// 1

var gclef = "𝄞";
gclef.length;					// 2
```

So, how do we accurately calculate the length of such a string? In this scenario, the following trick will work:

```js
var gclef = "𝄞";

[...gclef].length;				// 1
Array.from( gclef ).length;		// 1
```

Recall from the "`for..of` Loops" section earlier in this chapter that ES6 strings have built-in iterators. This iterator happens to be Unicode-aware, meaning it will automatically output an astral symbol as a single value. We take advantage of that using the `...` spread operator in an array literal, which creates an array of the string's symbols. Then we just inspect the length of that resultant array. ES6's `Array.from(..)` does basically the same thing as `[...XYZ]`, but we'll cover that utility in detail in Chapter 6.

**Warning:** It should be noted that constructing and exhausting an iterator just to get the length of a string is quite expensive on performance, relatively speaking, compared to what a theoretically optimized native utility/property would do.

Unfortunately, the full answer is not as simple or straightforward. In addition to the surrogate pairs (which the string iterator takes care of), there are special Unicode code points that behave in other special ways, which is much harder to account for. For example, there's a set of code points that modify the previous adjacent character, known as *Combining Diacritical Marks*.

Consider these two string outputs:

```js
console.log( s1 );				// "é"
console.log( s2 );				// "é"
```

They look the same, but they're not! Here's how we created `s1` and `s2`:

```js
var s1 = "\xE9",
	s2 = "e\u0301";
```

As you can probably guess, our previous `length` trick doesn't work with `s2`:

```js
[...s1].length;					// 1
[...s2].length;					// 2
```

So what can we do? In this case, we can perform a *Unicode normalization* on the value before inquiring about its length, using the ES6 `String#normalize(..)` utility (which we'll cover more in Chapter 6):

```js
var s1 = "\xE9",
	s2 = "e\u0301";

s1.normalize().length;			// 1
s2.normalize().length;			// 1

s1 === s2;						// false
s1 === s2.normalize();			// true
```

Essentially, `normalize(..)` takes a sequence like `"e\u0301"` and normalizes it to `"\xE9"`. Normalization can even combine multiple adjacent combining marks if there's a suitable Unicode character they combine to:

```js
var s1 = "o\u0302\u0300",
	s2 = s1.normalize(),
	s3 = "ồ";

s1.length;						// 3
s2.length;						// 1
s3.length;						// 1

s2 === s3;						// true
```

Unfortunately, normalization isn't fully perfect here, either. If you have multiple combining marks modifying a single character, you may not get the length count you'd expect, because there may not be a single defined normalized character that represents the combination of all the marks. For example:

```js
var s1 = "e\u0301\u0330";

console.log( s1 );				// "ḛ́"

s1.normalize().length;			// 2
```

The further you go down this rabbit hole, the more you realize that it's difficult to get one precise definition for "length." What we see visually rendered as a single character -- more precisely called a *grapheme* -- doesn't always strictly relate to a single "character" in the program processing sense.

**Tip:** If you want to see just how deep this rabbit hole goes, check out the "Grapheme Cluster Boundaries" algorithm (http://www.Unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries).

### Character Positioning

Similar to length complications, what does it actually mean to ask, "what is the character at position 2?" The naive pre-ES6 answer comes from `charAt(..)`, which will not respect the atomicity of an astral character, nor will it take into account combining marks.

Consider:

```js
var s1 = "abc\u0301d",
	s2 = "ab\u0107d",
	s3 = "ab\u{1d49e}d";

console.log( s1 );				// "abćd"
console.log( s2 );				// "abćd"
console.log( s3 );				// "ab𝒞d"

s1.charAt( 2 );					// "c"
s2.charAt( 2 );					// "ć"
s3.charAt( 2 );					// "" <-- unprintable surrogate
s3.charAt( 3 );					// "" <-- unprintable surrogate
```

So, is ES6 giving us a Unicode-aware version of `charAt(..)`? Unfortunately, no. At the time of this writing, there's a proposal for such a utility that's under consideration for post-ES6.

But with what we explored in the previous section (and of course with the limitations noted thereof!), we can hack an ES6 answer:

```js
var s1 = "abc\u0301d",
	s2 = "ab\u0107d",
	s3 = "ab\u{1d49e}d";

[...s1.normalize()][2];			// "ć"
[...s2.normalize()][2];			// "ć"
[...s3.normalize()][2];			// "𝒞"
```

**Warning:** Reminder of an earlier warning: constructing and exhausting an iterator each time you want to get at a single character is... not very ideal, performance wise. Let's hope we get a built-in and optimized utility for this soon, post-ES6.

What about a Unicode-aware version of the `charCodeAt(..)` utility? ES6 gives us `codePointAt(..)`:

```js
var s1 = "abc\u0301d",
	s2 = "ab\u0107d",
	s3 = "ab\u{1d49e}d";

s1.normalize().codePointAt( 2 ).toString( 16 );
// "107"

s2.normalize().codePointAt( 2 ).toString( 16 );
// "107"

s3.normalize().codePointAt( 2 ).toString( 16 );
// "1d49e"
```

What about the other direction? A Unicode-aware version of `String.fromCharCode(..)` is ES6's `String.fromCodePoint(..)`:

```js
String.fromCodePoint( 0x107 );		// "ć"

String.fromCodePoint( 0x1d49e );	// "𝒞"
```

So wait, can we just combine `String.fromCodePoint(..)` and `codePointAt(..)` to get a better version of a Unicode-aware `charAt(..)` from earlier? Yep!

```js
var s1 = "abc\u0301d",
	s2 = "ab\u0107d",
	s3 = "ab\u{1d49e}d";

String.fromCodePoint( s1.normalize().codePointAt( 2 ) );
// "ć"

String.fromCodePoint( s2.normalize().codePointAt( 2 ) );
// "ć"

String.fromCodePoint( s3.normalize().codePointAt( 2 ) );
// "𝒞"
```

There's quite a few other string methods we haven't addressed here, including `toUpperCase()`, `toLowerCase()`, `substring(..)`, `indexOf(..)`, `slice(..)`, and a dozen others. None of these have been changed or augmented for full Unicode awareness, so you should be very careful -- probably just avoid them! -- when working with strings containing astral symbols.

There are also several string methods that use regular expressions for their behavior, like `replace(..)` and `match(..)`. Thankfully, ES6 brings Unicode awareness to regular expressions, as we covered in "Unicode Flag" earlier in this chapter.

OK, there we have it! JavaScript's Unicode string support is significantly better over pre-ES6 (though still not perfect) with the various additions we've just covered.

### Unicode Identifier Names

Unicode can also be used in identifier names (variables, properties, etc.). Prior to ES6, you could do this with Unicode-escapes, like:

```js
var \u03A9 = 42;

// same as: var Ω = 42;
```

As of ES6, you can also use the earlier explained code point escape syntax:

```js
var \u{2B400} = 42;

// same as: var 𫐀 = 42;
```

There's a complex set of rules around exactly which Unicode characters are allowed. Furthermore, some are allowed only if they're not the first character of the identifier name.

**Note:** Mathias Bynens has a great post (https://mathiasbynens.be/notes/javascript-identifiers-es6) on all the nitty-gritty details.

The reasons for using such unusual characters in identifier names are rather rare and academic. You typically won't be best served by writing code that relies on these esoteric capabilities.

## Symbols

With ES6, for the first time in quite a while, a new primitive type has been added to JavaScript: the `symbol`. Unlike the other primitive types, however, symbols don't have a literal form.

Here's how you create a symbol:

```js
var sym = Symbol( "some optional description" );

typeof sym;		// "symbol"
```

Some things to note:

* You cannot and should not use `new` with `Symbol(..)`. It's not a constructor, nor are you producing an object.
* The parameter passed to `Symbol(..)` is optional. If passed, it should be a string that gives a friendly description for the symbol's purpose.
* The `typeof` output is a new value (`"symbol"`) that is the primary way to identify a symbol.

The description, if provided, is solely used for the stringification representation of the symbol:

```js
sym.toString();		// "Symbol(some optional description)"
```

Similar to how primitive string values are not instances of `String`, symbols are also not instances of `Symbol`. If, for some reason, you want to construct a boxed wrapper object form of a symbol value, you can do the following:

```js
sym instanceof Symbol;		// false

var symObj = Object( sym );
symObj instanceof Symbol;	// true

symObj.valueOf() === sym;	// true
```

**Note:** `symObj` in this snippet is interchangeable with `sym`; either form can be used in all places symbols are utilized. There's not much reason to use the boxed wrapper object form (`symObj`) instead of the primitive form (`sym`). Keeping with similar advice for other primitives, it's probably best to prefer `sym` over `symObj`.

The internal value of a symbol itself -- referred to as its `name` -- is hidden from the code and cannot be obtained. You can think of this symbol value as an automatically generated, unique (within your application) string value.

But if the value is hidden and unobtainable, what's the point of having a symbol at all?

The main point of a symbol is to create a string-like value that can't collide with any other value. So, for example, consider using a symbol as a constant representing an event name:

```js
const EVT_LOGIN = Symbol( "event.login" );
```

You'd then use `EVT_LOGIN` in place of a generic string literal like `"event.login"`:

```js
evthub.listen( EVT_LOGIN, function(data){
	// ..
} );
```

The benefit here is that `EVT_LOGIN` holds a value that cannot be duplicated (accidentally or otherwise) by any other value, so it is impossible for there to be any confusion of which event is being dispatched or handled.

**Note:** Under the covers, the `evthub` utility assumed in the previous snippet would almost certainly be using the symbol value from the `EVT_LOGIN` argument directly as the property/key in some internal object (hash) that tracks event handlers. If `evthub` instead needed to use the symbol value as a real string, it would need to explicitly coerce with `String(..)` or `toString()`, as implicit string coercion of symbols is not allowed.

You may use a symbol directly as a property name/key in an object, such as a special property that you want to treat as hidden or meta in usage. It's important to know that although you intend to treat it as such, it is not *actually* a hidden or untouchable property.

Consider this module that implements the *singleton* pattern behavior -- that is, it only allows itself to be created once:

```js
const INSTANCE = Symbol( "instance" );

function HappyFace() {
	if (HappyFace[INSTANCE]) return HappyFace[INSTANCE];

	function smile() { .. }

	return HappyFace[INSTANCE] = {
		smile: smile
	};
}

var me = HappyFace(),
	you = HappyFace();

me === you;			// true
```

The `INSTANCE` symbol value here is a special, almost hidden, meta-like property stored statically on the `HappyFace()` function object.

It could alternatively have been a plain old property like `__instance`, and the behavior would have been identical. The usage of a symbol simply improves the metaprogramming style, keeping this `INSTANCE` property set apart from any other normal properties.

### Symbol Registry

One mild downside to using symbols as in the last few examples is that the `EVT_LOGIN` and `INSTANCE` variables had to be stored in an outer scope (perhaps even the global scope), or otherwise somehow stored in a publicly available location, so that all parts of the code that need to use the symbols can access them.

To aid in organizing code with access to these symbols, you can create symbol values with the *global symbol registry*. For example:

```js
const EVT_LOGIN = Symbol.for( "event.login" );

console.log( EVT_LOGIN );		// Symbol(event.login)
```

And:

```js
function HappyFace() {
	const INSTANCE = Symbol.for( "instance" );

	if (HappyFace[INSTANCE]) return HappyFace[INSTANCE];

	// ..

	return HappyFace[INSTANCE] = { .. };
}
```

`Symbol.for(..)` looks in the global symbol registry to see if a symbol is already stored with the provided description text, and returns it if so. If not, it creates one to return. In other words, the global symbol registry treats symbol values, by description text, as singletons themselves.

But that also means that any part of your application can retrieve the symbol from the registry using `Symbol.for(..)`, as long as the matching description name is used.

Ironically, symbols are basically intended to replace the use of *magic strings* (arbitrary string values given special meaning) in your application. But you precisely use *magic* description string values to uniquely identify/locate them in the global symbol registry!

To avoid accidental collisions, you'll probably want to make your symbol descriptions quite unique. One easy way of doing that is to include prefix/context/namespacing information in them.

For example, consider a utility such as the following:

```js
function extractValues(str) {
	var key = Symbol.for( "extractValues.parse" ),
		re = extractValues[key] ||
			/[^=&]+?=([^&]+?)(?=&|$)/g,
		values = [], match;

	while (match = re.exec( str )) {
		values.push( match[1] );
	}

	return values;
}
```

We use the magic string value `"extractValues.parse"` because it's quite unlikely that any other symbol in the registry would ever collide with that description.

If a user of this utility wants to override the parsing regular expression, they can also use the symbol registry:

```js
extractValues[Symbol.for( "extractValues.parse" )] =
	/..some pattern../g;

extractValues( "..some string.." );
```

Aside from the assistance the symbol registry provides in globally storing these values, everything we're seeing here could have been done by just actually using the magic string `"extractValues.parse"` as the key, rather than the symbol. The improvements exist at the metaprogramming level more than the functional level.

You may have occasion to use a symbol value that has been stored in the registry to look up what description text (key) it's stored under. For example, you may need to signal to another part of your application how to locate a symbol in the registry because you cannot pass the symbol value itself.

You can retrieve a registered symbol's description text (key) using `Symbol.keyFor(..)`:

```js
var s = Symbol.for( "something cool" );

var desc = Symbol.keyFor( s );
console.log( desc );			// "something cool"

// get the symbol from the registry again
var s2 = Symbol.for( desc );

s2 === s;						// true
```

### Symbols as Object Properties

If a symbol is used as a property/key of an object, it's stored in a special way so that the property will not show up in a normal enumeration of the object's properties:

```js
var o = {
	foo: 42,
	[ Symbol( "bar" ) ]: "hello world",
	baz: true
};

Object.getOwnPropertyNames( o );	// [ "foo","baz" ]
```

To retrieve an object's symbol properties:

```js
Object.getOwnPropertySymbols( o );	// [ Symbol(bar) ]
```

This makes it clear that a property symbol is not actually hidden or inaccessible, as you can always see it in the `Object.getOwnPropertySymbols(..)` list.

#### Built-In Symbols

ES6 comes with a number of predefined built-in symbols that expose various meta behaviors on JavaScript object values. However, these symbols are *not* registered in the global symbol registry, as one might expect.

Instead, they're stored as properties on the `Symbol` function object. For example, in the "`for..of`" section earlier in this chapter, we introduced the `Symbol.iterator` value:

```js
var a = [1,2,3];

a[Symbol.iterator]; // native function
```

The specification uses the `@@` prefix notation to refer to the built-in symbols, the most common ones being: `@@iterator`, `@@toStringTag`, `@@toPrimitive`. Several others are defined as well, though they probably won't be used as often.

**Note:** See "Well Known Symbols" in Chapter 7 for detailed information about how these built-in symbols are used for meta programming purposes.

## Review

ES6 adds a heap of new syntax forms to JavaScript, so there's plenty to learn!

Most of these are designed to ease the pain points of common programming idioms, such as setting default values to function parameters and gathering the "rest" of the parameters into an array. Destructuring is a powerful tool for more concisely expressing assignments of values from arrays and nested objects.

While features like `=>` arrow functions appear to also be all about shorter and nicer-looking syntax, they actually have very specific behaviors that you should intentionally use only in appropriate situations.

Expanded Unicode support, new tricks for regular expressions, and even a new primitive `symbol` type round out the syntactic evolution of ES6.

# Currying

# Resources
- [You Don't Know JS: Up & Going](https://github.com/getify/You-Dont-Know-JS/blob/master/up%20&%20going/README.md#you-dont-know-js-up--going)
- [You Don't Know JS: Scope & Closures](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20&%20closures/README.md#you-dont-know-js-scope--closures)
- [You Don't Know JS: this & Object Prototypes](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20&%20object%20prototypes/README.md#you-dont-know-js-this--object-prototypes)
- [You Don't Know JS: Types & Grammar](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/README.md#you-dont-know-js-types--grammar)
- [You Don't Know JS: Async & Performance](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20&%20performance/README.md#you-dont-know-js-async--performance)
- [You Don't Know JS: ES6 & Beyond](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20&%20beyond/README.md#you-dont-know-js-es6--beyond)
- [Variables: Scopes, Environments, and Closures](http://speakingjs.com/es5/ch16.html)
- [Function.prototype.apply()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply)
- [Function.prototype.call()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call)
- [The Difference Between Call and Apply in Javascript](http://hangar.runway7.net/javascript/difference-call-apply)

# Awesome Vids
- [JavaScript is too convenient](https://vimeo.com/267418198?activityReferer=1) -  SCNA - Sam Jones of Test Double