# this and Call-site

**Exceptions to the 4 Rules**
- If you pass `null` or `undefined` as a `this` binding parameter to `call`, `apply`, or `bind`, those values are effectively ignored, and instead the *default binding* rule applies to the invocation
- you can (intentionally or not!) create "indirect references" to functions, and in those cases, when that function reference is invoked, the *default binding* rule also applies

# JS Modules

## ECMAScript 5 (ES5) Modules

### Module Pattern Using Closures
#### First a few definitions again:

**Lexical scoping:**
```
function init() {
  var name = 'Mozilla'; // name is a local variable created by init
  function displayName() { // displayName() is the inner function, a closure
    alert(name); // use variable declared in the parent function    
  }
  displayName();    
}
init();
```
- init() creates a local variable called name and a function called displayName(). The displayName() function is an inner function that is defined inside init() and is only available within the body of the  init() function. The displayName() function has no local variables of its own. However, because inner functions have access to the variables of outer functions, displayName() can access the variable name declared in the parent function, init(). However, the same local variables in displayName() will be used if they exist
- Run the code and notice that the alert() statement within the displayName() function successfully displays the value of the name variable, which is declared in its parent function
- This is an example of lexical scoping, which describes how a parser resolves variable names when functions are nested
- The word "lexical" refers to the fact that lexical scoping uses the location where a variable is declared within the source code to determine where that variable is available. Nested functions have access to variables declared in their outer scope

#### Closure:
- A closure is the combination of a function and the lexical environment within which that function was declared
- Closures happen as a result of writing code that relies on lexical scope
  - They just happen. You do not even really have to intentionally create closures to take advantage of them
    - What you are missing is the proper mental context to recognize, embrace, and leverage closures for your own will

        ```
        function makeFunc() {
          var name = 'Mozilla';
          function displayName() {
            alert(name);
          }
          return displayName;
        }
        
        var myFunc = makeFunc();
        myFunc();
        ```
- Running this code has exactly the same effect as the previous example of the init() function above; what's different — and interesting — is that the displayName() inner function is returned from the outer function before being executed
- At first glance, it may seem unintuitive that this code still works. In some programming languages, the local variables within a function exist only for the duration of that function's execution. Once makeFunc() has finished executing, you might expect that the name variable would no longer be accessible. However, because the code still works as expected, this is obviously not the case in JavaScript
- The reason is that functions in JavaScript form closures. A **closure** is the **combination of a function and the lexical environment within which that function was declared. This environment consists of any local variables that were in-scope at the time the closure was created**
  - In this case, myFunc is a reference to the instance of the function displayName created when makeFunc is run. The instance of displayName maintains a reference to its lexical environment, within which the variable name exists. For this reason, when myFunc is invoked, the variable name remains available for use and "Mozilla" is passed to alert

The approaches below all have one thing in common: the use of a single global variable to **wrap its code in a function, thereby creating a private namespace for itself using a closure scope**

- The Module pattern is used to mimic the concept of classes (since JavaScript doesn’t natively support classes) so that we can store both public and private methods and variables inside a single object — similar to how classes are used in other programming languages like Java or Python
  - That allows us to create a public facing API for the methods that we want to expose to the world, while still encapsulating private variables and methods in a closure scope
- **Remember:** **in JavaScript, functions are the only way to create new scope**
  - There are no "classes" only scope so that's how you isolate things in JS, modules using closure is one way to accomplish this
- There are several ways to accomplish the module pattern shown below

#### Closure Scope Chain
For every closure we have three scopes:
- Local Scope ( Own scope)
- Outer Functions Scope
- Global Scope

So, we have access to all three scopes for a closure but often make a common mistake when we have nested inner functions. Consider the following example:
```
// global scope
var e = 10;
function sum(a){
  return function(b){
    return function(c){
      // outer functions scope
      return function(d){
        // local scope
        return a + b + c + d + e;
      }
    }
  }
}

console.log(sum(1)(2)(3)(4)); // log 20

// We can also write without anonymous functions:

// global scope
var e = 10;
function sum(a){
  return function sum2(b){
    return function sum3(c){
      // outer functions scope
      return function sum4(d){
        // local scope
        return a + b + c + d + e;
      }
    }
  }
}

var s = sum(1);
var s1 = s(2);
var s2 = s1(3);
var s3 = s2(4);
console.log(s3) //log 20
```
- So, in the example above, we have a series of nested functions all of which have access to the outer functions' scope scope, but which mistakenly guess only for their immediate outer function scope. In this context, we can say all closures have access to all outer function scopes within which they were declared.

#### Closure via Function Factory:
```
function makeAdder(x) {
  return function(y) {
    return x + y;
  };
}

var add5 = makeAdder(5);
var add10 = makeAdder(10);

console.log(add5(2));  // 7
console.log(add10(2)); // 12
```
- In this example, we have defined a function makeAdder(x), which takes a single argument, x, and returns a new function. The function it returns takes a single argument, y, and returns the sum of x and y
- In essence, makeAdder is a function factory — it creates functions which can add a specific value to their argument. In the above example we use our function factory to create two new functions — one that adds 5 to its argument, and one that adds 10
- add5 and add10 are both closures. They share the same function body definition, but store different lexical environments. In add5's lexical environment, x is 5, while in the lexical environment for add10, x is 10

#### Example 1: Simple Module Pattern
- Using closures in this way is known as the module pattern:
    ```
    var counter = (function() {
      var privateCounter = 0;
      function changeBy(val) {
        privateCounter += val;
      }
      return {
        increment: function() {
          changeBy(1);
        },
        decrement: function() {
          changeBy(-1);
        },
        value: function() {
          return privateCounter;
        }
      };   
    })();
    ```
- In previous examples, each closure has had its own lexical environment. Here, though, we create a single lexical environment that is shared by three functions: counter.increment, counter.decrement, and counter.value
- The shared lexical environment is created in the body of an anonymous function, which is executed as soon as it has been defined
- The lexical environment contains two private items: a variable called privateCounter and a function called changeBy. Neither of these private items can be accessed directly from outside the anonymous function
  - Instead, they must be accessed by the three public functions that are returned from the anonymous wrapper
  - Those three public functions are closures that share the same environment
    - Thanks to JavaScript's lexical scoping, they each have access to the privateCounter variable and changeBy function
-You'll notice we're defining an anonymous function that creates a counter, and then we call it immediately and assign the result to the counter variable. We could store this function in a separate variable makeCounter and use it to create several counters:
        ```
        var makeCounter = function() {
          var privateCounter = 0;
          function changeBy(val) {
            privateCounter += val;
          }
          return {
            increment: function() {
              changeBy(1);
            },
            decrement: function() {
              changeBy(-1);
            },
            value: function() {
              return privateCounter;
            }
          }  
        };
        
        var counter1 = makeCounter();
        var counter2 = makeCounter();
        alert(counter1.value()); /* Alerts 0 */
        counter1.increment();
        counter1.increment();
        alert(counter1.value()); /* Alerts 2 */
        counter1.decrement();
        alert(counter1.value()); /* Alerts 1 */
        alert(counter2.value()); /* Alerts 0 */
        ```
- Notice how each of the two counters, counter1 and counter2, maintains its independence from the other
- Each closure references a different version of the privateCounter variable through its own closure
- Each time one of the counters is called, its lexical environment changes by changing the value of this variable; however changes to the variable value in one closure do not affect the value in the other closure
- Using closures in this way provides a number of benefits that are normally associated with object-oriented programming -- in particular, data hiding and encapsulation.



#### Example 2: Function set to Constant
- hides its local binding names inside the scope of a function expression that is immediately invoked
- provides isolation, to a certain degree, but it does not declare dependencies
  - Instead, it just puts its interface into the global scope and expects its dependencies, if any, to do the same
  - For a long time this was the main approach used in web programming, but it is mostly obsolete now
- If we want to make dependency relations part of the code, we’ll have to take control of loading dependencies. Doing that requires being able to execute strings as code. JavaScript can do this

Example:
```
const weekDay = function() {
  const names = ["Sunday", "Monday", "Tuesday", "Wednesday",
                 "Thursday", "Friday", "Saturday"];
  return {
    name(number) { return names[number]; },
    number(name) { return names.indexOf(name); }
  };
}();

console.log(weekDay.name(weekDay.number("Sunday")));
// → Sunday
```
- Its interface consists of weekDay.name and weekDay.number

#### Example 3: Anonymous closure
- putting all our code in an anonymous function
- With this construct, our anonymous function has its own evaluation environment or “closure”, and then we immediately evaluate it
  - This lets us hide variables from the parent (global) namespace
- the parenthesis around the anonymous function are required, because statements that begin with the keyword function are always considered to be function declarations (remember, you can’t have unnamed function declarations in JavaScript.)
  - Consequently, [the surrounding parentheses create a function expression instead](https://stackoverflow.com/questions/1634268/explain-the-encapsulated-anonymous-function-syntax)

**Benefits using Pattern:** you can use local variables inside this function without accidentally overwriting existing global variables, yet still access the global variables
```
(function () {
  // We keep these variables private inside this closure scope
  
  var myGrades = [93, 95, 88, 0, 55, 91];
  
  var average = function() {
    var total = myGrades.reduce(function(accumulator, item) {
      return accumulator + item}, 0);
    
      return 'Your average grade is ' + total / myGrades.length + '.';
  }

  var failing = function(){
    var failingGrades = myGrades.filter(function(item) {
      return item < 70;});
      
    return 'You failed ' + failingGrades.length + ' times.';
  }

  console.log(failing());

}());
```

#### Example 4: Global import
- similar to the anonymous closure, except now we pass in globals as parameters
- In this example, globalVariable is the only variable that’s global

**Benefits using Pattern:** you declare the global variables upfront, making it crystal clear to people reading your code

```
(function (globalVariable) {

  // Keep this variables private inside this closure scope
  var privateFunction = function() {
    console.log('Shhhh, this is private!');
  }

  // Expose the below methods via the globalVariable interface while
  // hiding the implementation of the method within the 
  // function() block

  globalVariable.each = function(collection, iterator) {
    if (Array.isArray(collection)) {
      for (var i = 0; i < collection.length; i++) {
        iterator(collection[i], i, collection);
      }
    } else {
      for (var key in collection) {
        iterator(collection[key], key, collection);
      }
    }
  };

  globalVariable.filter = function(collection, test) {
    var filtered = [];
    globalVariable.each(collection, function(item) {
      if (test(item)) {
        filtered.push(item);
      }
    });
    return filtered;
  };

  globalVariable.map = function(collection, iterator) {
    var mapped = [];
    globalUtils.each(collection, function(value, key, collection) {
      mapped.push(iterator(value));
    });
    return mapped;
  };

  globalVariable.reduce = function(collection, iterator, accumulator) {
    var startingValueMissing = accumulator === undefined;

    globalVariable.each(collection, function(item) {
      if(startingValueMissing) {
        accumulator = item;
        startingValueMissing = false;
      } else {
        accumulator = iterator(accumulator, item);
      }
    });

    return accumulator;

  };

 }(globalVariable));
 ```

#### Example 5: Object interface
- uses a self-contained object interface

##### Example 1:
```
const myGradesCalculateModule = (function () {
    
  // Keep this variable private inside this closure scope
  var myGrades = [93, 95, 88, 0, 55, 91];

  // Expose these functions via an interface while hiding
  // the implementation of the module within the function() block

  return {
    average: function() {
      var total = myGrades.reduce(function(accumulator, item) {
        return accumulator + item;
        }, 0);
        
      return'Your average grade is ' + total / myGrades.length + '.';
    },

    failing: function() {
      var failingGrades = myGrades.filter(function(item) {
          return item < 70;
        });

      return 'You failed ' + failingGrades.length + ' times.';
    }
  }
})();

myGradesCalculateModule.failing(); // 'You failed 2 times.' 
myGradesCalculateModule.average(); // 'Your average grade is 70.33333333333333.'
```


#### Example 6: Revealing module pattern
**Benefits using Pattern:**
- similar to the Object interface pattern, except that it ensures all methods and variables are kept private until explicitly exposed
- easier to understand and read
    - Instead of defining all of the private methods inside the IIFE and the public methods within the returned object, you write all methods within the IIFE and just “reveal” which ones you wish to make public within the return statement
  - this approach lets us decide what variables/methods we want to keep private (e.g. myGrades) and what variables/methods we want to expose by putting them in the return statement (e.g. average & failing)
  - All the functions are declared and implemented in the same place, thus creating less confusion
  - Private functions now have access to public functions if they need to
  - Example2: When a public function needs to call another public function they can call publicFunc2() rather than this.publicFunc2(), which saves a few characters and saves your butt if this ends up being something different than originally intended
- An object with a function property on it alone is not really a module
- An object which is returned from a function invocation which only has data properties on it and no closured functions is not really a module, in the observable sense
- The code snippet below shows a standalone module creator called CoolModule() which can be invoked any number of times, each time creating a new module instance

##### Example 1:
```
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
- This is the pattern in JavaScript we call module. The most common way of implementing the module pattern is often called "Revealing Module", and it's the variation we present here
- Firstly, CoolModule() is just a function, but it has to be invoked for there to be a module instance created
  - Without the execution of the outer function, the creation of the inner scope and the closures would not occur
- Secondly, the CoolModule() function returns an object, denoted by the object-literal syntax { key: value, ... }
  - The object we return has references on it to our inner functions, but not to our inner data variables.  We keep those hidden and private
  - it's appropriate to think of this object return value as essentially a **public API for our module**
  - This object return value is ultimately assigned to the outer variable foo, and then we can access those property methods on the API, like foo.doSomething()
  - The doSomething() and doAnother() functions have closure over the inner scope of the module "instance" (arrived at by actually invoking CoolModule())
  - When we transport those functions outside of the lexical scope, by way of property references on the object we return, we have now set up a condition by which closure can be observed and exercised

To state it more simply, there are two "requirements" for the module pattern to be exercised:
  - There must be an outer enclosing function, and it must be invoked at least once (each time creates a new module instance)
  - The enclosing function must return back at least one inner function, so that this inner function has closure over the private scope, and can access and/or modify that private state

Note: It is not required that we return an actual object (literal) from our module. We could just return back an inner function directly. jQuery is actually a good example of this. The jQuery and $ identifiers are the public API for the jQuery "module", but they are, themselves, just a function (which can itself have properties, since all functions are objects)

A slight variation on this pattern above is when you only care to have one instance, a "singleton" of sorts
```
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

Modules are just functions, so they can receive parameters:
```
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

Another slight but powerful variation on the module pattern is to name the object you are returning as your public API:
```
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

##### Example 2:

```
var myGradesCalculate = (function () {
    
  // Keep this variable private inside this closure scope
  var myGrades = [93, 95, 88, 0, 55, 91];
  
  var average = function() {
    var total = myGrades.reduce(function(accumulator, item) {
      return accumulator + item;
      }, 0);
      
    return'Your average grade is ' + total / myGrades.length + '.';
  };

  var failing = function() {
    var failingGrades = myGrades.filter(function(item) {
        return item < 70;
      });

    return 'You failed ' + failingGrades.length + ' times.';
  };

  // Explicitly reveal public pointers to the private functions 
  // that we want to reveal publicly

  return {
    average: average,
    failing: failing
  }
})();

myGradesCalculate.failing(); // 'You failed 2 times.' 
myGradesCalculate.average(); // 'Your average grade is 70.33333333333333.'
```

##### Example 3:
```
var Module = (function() {
    // All functions now have direct access to each other
    var privateFunc = function() {
        publicFunc1();
    };
    var publicFunc1 = function() {
        publicFunc2();
    };
    var publicFunc2 = function() {
        privateFunc();
    };
    // Return the object that is assigned to Module
    return {
        publicFunc1: publicFunc1,
        publicFunc2: publicFunc2
    };
}());
```

#### Example 7: Module Pattern for Extension
- for extending already-existing modules.
- done quite often when making plugins to libraries like jQuery

```
(function($) {
    $.pluginFunc = function() {
        ...
    }
}(jQuery));
```
- This code is pretty flexible because you don’t even need the var jQuery = or the return statement near the end. jQuery will still be extended with the new method without them
- It’s actually probably bad for performance to return the entire jQuery object and assign it, however, if you want to assign jQuery to a new variable name at the same time that you’re extending it, you can just change jQuery on the first line to whatever you want

#### Example 6:

```
var Module = (function() {
    // Following function is private, but can be accessed by the public functions
    function privateFunc() { ... };
    // Return an object that is assigned to Module
    return {
        publicFunc: function() {
            privateFunc(); // publicFunc has direct access to privateFunc
        }
    };
}());
```
- You can also use the arguments to send in and shrink the name of commonly used assets:
    ```
    var Module = (function($, w, undefined) {
        // ...
        // return {...};
    }(jQuery, window));
    ```
    - sent in jQuery and window, which were abbreviated to $ and w, respectively
    - Notice that I didn’t send anything in for the third argument. This way undefined will be undefined, so it works perfectly. Some people do this with undefined because for whatever reason it is editable. So if you check to see if something is undefined, but undefined has been changed, your comparison will not work. This technique ensures that it will work as expected

## CommonJS

The Module Pattern Using Closures above all have one thing in common: the use of a single global variable to wrap its code in a function, thereby creating a private namespace for itself using a closure scope

- The most widely used approach to bolted-on JavaScript modules is called CommonJS modules. Node.js uses it and is the system used by most packages on NPM

**Downsides to Module Pattern Using Closures**:

- as a developer, you need to know the right dependency order to load your files in
  - For instance, let’s say you’re using Backbone in your project, so you include the script tag for Backbone’s source code in your file
  - However, since Backbone has a hard dependency on Underscore.js, the script tag for the Backbone file can’t be placed before the Underscore.js file
  - As a developer, managing dependencies and getting these things right can sometimes be a headache
- Another downside is that they can still lead to namespace collisions
  - For example, what if two of your modules have the same name? Or what if you have two versions of a module, and you need both?

- can we design a way to ask for a module’s interface without going through the global scope?
  - Yes. There are two popular and well-implemented approaches: CommonJS and AMD

### CommonJS
- CommonJS is a volunteer working group that designs and implements JavaScript APIs for declaring modules
- A CommonJS module is essentially a reusable piece of JavaScript which exports specific objects, making them available for other modules to require in their programs
  - If you’ve programmed in Node.js, you’ll be very familiar with this format
- With CommonJS, each JavaScript file stores modules in its own unique module context (just like wrapping it in a closure)
  - In this scope, we use the module.exports object to expose modules, and require to import them
- The main concept in CommonJS modules is a function called require. When you call this with the module name of a dependency, it makes sure the module is loaded and returns its interface
- Because the loader wraps the module code in a function, modules automatically get their own local scope
  - All they have to do is call require to access their dependencies and put their interface in the object bound to exports
- To avoid loading the same module multiple times, require keeps a store (cache) of already loaded modules. When called, it first checks if the requested module has been loaded and, if not, loads it. This involves reading the module’s code, wrapping it in a function, and calling it
- By defining require, exports, and module as parameters for the generated wrapper function (and passing the appropriate values when calling it), the loader makes sure that these bindings are available in the module’s scope
- The dominant implementation of this standard is in Node.js (Node.js modules have a few features that go beyond CommonJS). Characteristics:
  - Compact syntax
  - Designed for synchronous loading and servers

#### Benefits to this approach over the module closure patterns:
- Avoiding global namespace pollution
- Making our dependencies explicit
- syntax is very compact
- CommonJS takes a server-first approach and synchronously loads modules
  - This matters because if we have three other modules we need to require, it’ll load them one by one

### Downsides
- works great on the server but, unfortunately, makes it harder to use when writing JavaScript for the browser
  - Reading a module from the web takes a lot longer than reading from disk
  - For as long as the script to load a module is running, it blocks the browser from running anything else until it finishes loading
    - It behaves this way because the JavaScript thread stops until the code has been loaded
    - You can work around this issue with module bundling
- CommonJS modules work quite well and, in combination with NPM, have allowed the JavaScript community to start sharing code on a large scale
  - But they remain a bit of a duct-tape hack
    - The notation is slightly awkward—the things you add to exports are not available in the local scope, for example
    - And because require is a normal function call taking any kind of argument, not just a string literal, it can be hard to determine the dependencies of a module without running its code
    - This is why the JavaScript standard from 2015 introduces its own, different module system. It is usually called ES modules, where ES stands for ECMAScript
      - The main concepts of dependencies and interfaces remain the same, but the details differ
#### Example 1:
```
function myModule() {
  this.hello = function() {
    return 'hello!';
  }

  this.goodbye = function() {
    return 'goodbye!';
  }
}

module.exports = myModule;
```
- here we use the special object module and place a reference of our function into module.exports
  - This lets the CommonJS module system know what we want to expose so that other files can consume it
  - Then when someone wants to use myModule, they can require it in their file, like so:

```
var myModule = require('myModule');

var myModuleInstance = new myModule();
myModuleInstance.hello(); // 'hello!'
myModuleInstance.goodbye(); // 'goodbye!'
```

#### Example 2:
```
const ordinal = require("ordinal");
const {days, months} = require("date-names");

exports.formatDate = function(date, format) {
  return format.replace(/YYYY|M(MMM)?|Do?|dddd/g, tag => {
    if (tag == "YYYY") return date.getFullYear();
    if (tag == "M") return date.getMonth();
    if (tag == "MMMM") return months[date.getMonth()];
    if (tag == "D") return date.getDate();
    if (tag == "Do") return ordinal(date.getDate());
    if (tag == "dddd") return days[date.getDay()];
  });
};
```
- The module adds its interface function to exports so that modules that depend on it get access to it

We could use the module like this:
```
const {formatDate} = require("./format-date");

console.log(formatDate(new Date(2017, 9, 13),
                       "dddd the Do"));
// → Friday the 13th
```

## AMD (Asynchronous Module Definition)
CommonJS is good but what if you want to load modules asyncronously?

**Benefits**
- your modules can be objects, functions, constructors, strings, JSON and many other types, while CommonJS only supports objects as modules

** Downsides**
- AMD isn’t compatible with io, filesystem, and other server-oriented features available via CommonJS, and the function wrapping syntax is a bit more verbose compared to a simple require statement


#### Example 1: Loading Modules via AMD
```
define(['myModule', 'myOtherModule'], function(myModule, myOtherModule) {
  console.log(myModule.hello());
});
```

- What’s happening here is that the define function takes as its first argument an array of each of the module’s dependencies
  - These dependencies are loaded in the background (in a non-blocking manner), and once loaded **define** calls the callback function it was given
- Next, the callback function takes, as arguments, the dependencies that were loaded — in our case, myModule and myOtherModule — allowing the function to use these dependencies
- Finally, the dependencies themselves must also be defined using the **define** keyword

Example 1: AMD Module
```
define([], function() {

  return {
    hello: function() {
      console.log('hello');
    },
    goodbye: function() {
      console.log('goodbye');
    }
  };
});
```
- unlike CommonJS, AMD takes a browser-first approach alongside asynchronous behavior to get the job done
  - Note: there are a lot of people who strongly believe that dynamically loading files piecemeal as you start to run code isn’t favorable, which we’ll explore more when in the next section on module-building)

## ECMAScript 6 (ES6) Modules

None of the modules above were native to JavaScript. Instead, we’ve created ways to emulate a modules system by using either the module pattern, CommonJS or AMD

- ES6 offers up a variety of possibilities for importing and exporting modules which others have done a great job explaining — here are a few of those resources:
  - [jsmodules.io](jsmodules.io)
  - [exploringjs.com](exploringjs.com)
- It is usually called ES modules, where ES stands for ECMAScript
- In practice, most JavaScript modules export an object literal, a function, or a constructor
- Modules are singletons. Even if a module is imported multiple times, only a single “instance” of it exists
- There are two kinds of exports: named exports (several per module) and default exports (one per module)
  - it is possible use both at the same time, but usually best to keep them separate
- This approach to modules avoids global variables, the only things that are global are module specifiers
- The main concepts of dependencies and interfaces remain the same, but the details differ
    - Instead of calling a function to access a dependency, you use a special import keyword
    - the export keyword is used to export things
      - It may appear in front of a function, class, or binding definition
  - Another important difference is that ES module imports happen before a module’s script starts running
    - That means import declarations may not appear inside functions or blocks, and the names of dependencies must be quoted strings, not arbitrary expressions
- At the time of writing, the JavaScript community is in the process of adopting this module style. But it has been a slow process. It took a few years, after the format was specified, for browsers and Node.js to start supporting it. And though they mostly support it now, this support still has issues, and the discussion on how such modules should be distributed through NPM is still ongoing
  - Many projects are written using ES modules and then automatically converted to some other format when published. We are in a transitional period in which two different module systems are used side by side, and it is useful to be able to read and write code in either of them

**Benefits**

- Offers the best of both worlds:
  - compact and declarative syntax
  - asynchronous loading
  - better support for cyclic dependencies
  - imports are live read-only views of the exports
    - Compare this to CommonJS, where imports are copies of exports and consequently not alive


#### Example 1:
```
import ordinal from "ordinal";
import {days, months} from "date-names";

export function formatDate(date, format) { /* ... */ }
```
- An ES module’s interface is not a single value but a set of named bindings
  - The preceding module binds formatDate to a function. When you import from another module, you import the binding, not the value, which means an exporting module may change the value of the binding at any time, and the modules that import it will see its new value
  - When there is a binding named default, it is treated as the module’s main exported value
  - If you import a module like ordinal in the example, without braces around the binding name, you get its default binding
  - Such modules can still export other bindings under different names alongside their default export

- To create a default export, you write export default before an expression, a function declaration, or a class declaration:
    ```
    export default ["Winter", "Spring", "Summer", "Autumn"];
    ```
- It is possible to rename imported bindings using the word as:
    ```
    import {days as dayNames} from "date-names";
    ```

#### Example 2: Multiple Exports

- A module can export multiple things by prefixing its declarations with the keyword export
    ```
    //------ lib.js ------
    export const sqrt = Math.sqrt;
    export function square(x) {
        return x * x;
    }
    export function diag(x, y) {
        return sqrt(square(x) + square(y));
    }
    
    //------ main.js ------
    import { square, diag } from 'lib';
    console.log(square(11)); // 121
    console.log(diag(4, 3)); // 5
    ```

#### Example 3: Default exports (one per module)
- An ES6 module can pick a default export, the main exported value. Default exports are especially easy to import
  - Modules that only export single values are very popular in the Node.js community
    - They are also common in frontend development where you often have classes for models and components, with one class per module

    ```
    //------ myFunc.js ------
    export default function () {} // no semicolon!
    
    //------ main1.js ------
    import myFunc from 'myFunc';
    myFunc();
    ```
    - in this example, the module _is_ a single function

### Example 1:
```
// lib/counter.js

var counter = 1;

function increment() {
  counter++;
}

function decrement() {
  counter--;
}

module.exports = {
  counter: counter,
  increment: increment,
  decrement: decrement
};


// src/main.js

var counter = require('../../lib/counter');

counter.increment();
console.log(counter.counter); // 1
```

- we basically make two copies of the module: one when we export it, and one when we require it
- Moreover, the copy in main.js is now disconnected from the original module
  - That’s why even when we increment our counter it still returns 1 — because the counter variable that we imported is a disconnected copy of the counter variable from the module
  - So, incrementing the counter will increment it in the module, but won’t increment your copied version
  - The only way to modify the copied version of the counter variable is to do so manually:
    ```
    counter.counter++;
    console.log(counter.counter); // 2
    ```
- On the other hand, ES6 creates a live read-only view of the modules we import:
    ```
    // lib/counter.js
    export let counter = 1;
    
    export function increment() {
      counter++;
    }
    
    export function decrement() {
      counter--;
    }
    
    
    // src/main.js
    import * as counter from '../../counter';
    
    console.log(counter.counter); // 1
    counter.increment();
    console.log(counter.counter); // 2
    ```
- what's compelling about live read-only views is how they allow you to split your modules into smaller pieces without losing functionality

## NodeJS Modules

- instead of import, uses the require() function

### Example 1:
```
exports.myDateTime = function () {
    return Date();
};
```
Now you can include and use the module in any of your Node.js files:
```
var http = require('http');
var dt = require('./myfirstmodule');

http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write("The date and time are currently: " + dt.myDateTime());
    res.end();
}).listen(8080);
```


# Resources
- [JavaScript Modules: A Beginner’s Guide](https://medium.freecodecamp.org/javascript-modules-a-beginner-s-guide-783f7d7a5fcc)
- [Modules](http://exploringjs.com/es6/ch_modules.html)
- [Modules](https://eloquentjavascript.net/10_modules.html)
- [Closures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)
- [You Don't Know JS: Scope & Closures](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20%26%20closures/ch5.md)
