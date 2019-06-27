
## Big O Notation
- time complexity of a function
- ...more to come

#### Videos
- [Big O Notation](https://www.youtube.com/watch?v=v4cd1O4zkGw)
#### Posts


## Data Structures

### Linked Lists
##### Posts
##### Videos
- [Linked Lists](https://www.youtube.com/watch?v=njTh_OwMljA)
### Trees
##### Posts
- [recursive tree construction](https://stackoverflow.com/questions/10347942/recursive-tree-construction?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
- [Implement a Binary Search Tree in JavaScript](https://initjs.org/implement-a-binary-search-tree-in-javascript-952a44ee7c26)
- [The HTML Document Tree](http://web.simmons.edu/~grabiner/comm244/weekfour/document-tree.html)

##### Videos
- [build employee hierarchy tree](https://www.youtube.com/watch?v=p3Ct3hELjSs)
- [Data Structures: Trees](https://www.youtube.com/watch?v=oSWTXtMglKE)
- [Data structures: Introduction to Trees](https://www.youtube.com/watch?v=qH6yxkw0u78)
- [Binary Search Tree - Beau teaches JavaScript](https://www.youtube.com/watch?v=5cU1ILGy6dM)

#### github
- [dabeng/OrgChart](https://github.com/dabeng/OrgChart/blob/master/src/js/jquery.orgchart.js) (createNode, buildChildNode)

## Sorts
### Bubble
##### Posts
##### Videos
- [Sorting | packtpub.com](https://www.youtube.com/watch?v=Ymh_AurrMbA)

# Katas
Do **3 versions** of **each** of the the **bigger katas**:
- using **object literals** & **functions**
- using **Object.create()** & **functions**
- using ES6 **classes** & **functions**

## Trees
- **Build a Binary Search Tree**
- **Build a hierarchical Tree**
- **invert a binary tree**

## Lists
- **binary search with array**
- **Build a LinkedList**
- **Build a thread safe LinkedList**
- **Create a sequence of dictionary words from a predefined set of letters**
## Sorts
- **Bubble Sort**
- **Merge Sort**

## JS
- Write a function that mimics JS's setTimeout

## Misc
- **Write a debouncer function in JS**
    - [JavaScript Debounce Function](https://davidwalsh.name/javascript-debounce-function)
    - [Debounce in JavaScript — Improve Your Application’s Performance](https://levelup.gitconnected.com/debounce-in-javascript-improve-your-applications-performance-5b01855e086)
- **Given an array of integers, find the maximum difference of any 2 numbers**
    - I'd probably sort the list and then take the highest number and subtract the lowest
- **Find all prime numbers up to any given limit**
    - [Determine If A Number Is Prime Using JavaScript](https://www.thepolyglotdeveloper.com/2015/04/determine-if-a-number-is-prime-using-javascript)
- **Sum of prime number until 1 million**
    - A prime number (or a prime) is a natural number greater than 1 that has no positive divisors other than 1 and itself
    - _prime number_: a whole number greater than 1 whose only factors are 1 and itself
        - (val % i === 0).  Use mod % - returns the division remainder to determine if the number is prime
    - _factors_ are the numbers you multiply together to get another number
        - factors are whole numbers no fractions
        - factors are the integers that are multiplied together to find other integers For example, 3 × 5 = 15.  1 and 15 would also be factors of 15
    - _natural numbers_ - the positive integers (whole numbers) 1, 2, 3, etc., and zero as well
        - refers either to a member of the set of positive integers 1, 2, 3, ... or to the set of nonnegative integers 0, 1, 2, 3
- **Find a unique list of integers from given a list of integers**
- **Coin exchange: given the amount of change you must return and a list of denominations, give the least amount of coins needed to be given for change**
- **Write a function to reverse all the words in a string separated by spaces. There will be k spaces, and k + 1 words**

- **get nth Fibonacci number**
- **verify if a word is a palindrome**
    - if you reverse a word and it becomes same as the previous word, it is called palindrome

# References
- [a short list of algorithms](https://thatjsdude.com/interview/js1.html)

# Common JS Utilities
### String
[split()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/split)
- splits a String object into an array of strings
    - _return value_: An Array of strings split at each point where the separator occurs in the given string
    ```
    stringToSplit.split(separator)
    // separators: ' ', ',', etc.
    ```
    using it to reverse a string:
    ```
    var str = 'asdfghjkl';
    var strReverse = str.split('').reverse().join(''); // 'lkjhgfdsa'
    // split() returns an array on which reverse() and join() can be applied
    ```
### Array
[indexOf](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf)
- returns the first index at which a given element can be found in the array, or -1 if it is not present
    ```
    var beasts = ['ant', 'bison', 'camel', 'duck', 'bison'];

    console.log(beasts.indexOf('bison'));
    // output: 1
    ```
[findIndex()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex)
- returns the index of the first element in the array that satisfies the provided testing function
    ```
    var array1 = [5, 12, 8, 130, 44];

    function findFirstLargeNumber(element) {
      return element > 13;
    }

    console.log(array1.findIndex(findFirstLargeNumber));
    // expected output: 3
    ```

[keys](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/keys)
- returns a new Array Iterator object that contains the keys for each index in the array
    ```
    var array1 = ['a', 'b', 'c'];
    var iterator = array1.keys();

    for (let key of iterator) {
      console.log(key); // expected output: 0 1 2
    }
    ```
[values()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/values)
- returns a new Array Iterator object that contains the values for each index in the array
    ```
    const array1 = ['a', 'b', 'c'];
    const iterator = array1.values();

    for (const value of iterator) {
      console.log(value); // expected output: "a" "b" "c"
    }
    ```
[entries()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/entries)
- returns a new Array Iterator object that contains the key/value pairs for each index in the array
    ```
    var array1 = ['a', 'b', 'c'];

    var iterator1 = array1.entries();

    console.log(iterator1.next().value);
    // output: Array [0, "a"]
    ```
[of()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/of)
- creates a new Array instance with a variable number of arguments, regardless of number or type of the arguments
    ```
    Array.of(7);       // [7]
    Array.of(1, 2, 3); // [1, 2, 3]
    ```
[splice()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice)
- changes the contents of an array by removing existing elements and/or adding new
 elements
    ```
    var months = ['Jan', 'March', 'April', 'June'];
    months.splice(1, 0, 'Feb');
    // inserts at 1st index position
    console.log(months);
    // expected output: Array ['Jan', 'Feb', 'March', 'April', 'June']

    months.splice(4, 1, 'May');
    // replaces 1 element at 4th index
    console.log(months);
    // expected output: Array ['Jan', 'Feb', 'March', 'April', 'May']
    ```
[join()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/join)
- joins all elements of an array (or an array-like object) into a string
    ```
    elements = ['Fire', 'Wind', 'Rain'];
    elements.join();
    // output: Fire,Wind,Rain
    ```
[length](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/length) - number of elements in that array

[concat()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/concat)
- merge two or more arrays
     ```
     array1.concat(array2)
     ```
[join()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/join)
- joins all elements of an array (or an array-like object) into a string and returns this string
    ```
    var elements = ['Fire', 'Wind', 'Rain'];

    console.log(elements.join());
    // output: Fire,Wind,Rain
    console.log(elements.join(''));
    // output: FireWindRain
    console.log(elements.join('-'));
    // output: Fire-Wind-Rain
    ```
[map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map)
- creates a new array with the results of calling a provided function on every element in the calling array
    ```
    var array1 = [1, 4, 9, 16];

    // pass a function to map
    const map1 = array1.map(x => x * 2);
    ```

[entries()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/entries)
- returns a new Array Iterator object that contains the key/value pairs for each index in the array
    ```
    var array1 = ['a', 'b', 'c'];
    var iterator1 = array1.entries();
    console.log(iterator1.next().value);
    // output: Array [0, "a"]
    ```
[flatten()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flatten)
- creates a new array with all sub-array elements concatted into it recursively up to the specified depth
    ```
    var arr1 = [1, 2, [3, 4]];
    arr1.flatten();
    // [1, 2, 3, 4]

    var arr2 = [1, 2, [3, 4, [5, 6]]];
    arr2.flatten();
    // [1, 2, 3, 4, [5, 6]]
    ```

[every()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every)
- tests whether all elements in the array pass the test implemented by the provided function
    ```
    function isBelowThreshold(currentValue) {
      return currentValue < 40;
    }

    var array1 = [1, 30, 39, 29, 10, 13];

    console.log(array1.every(isBelowThreshold));
    // output: true
    ```
[filter()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter)
- creates a new array with all elements that pass the test implemented by the provided function
    ```
    var words = ['spray', 'limit', 'elite', 'exuberant', 'destruction', 'present'];

    const result = words.filter(word => word.length > 6);

    console.log(result);
    // output: Array ["exuberant", "destruction", "present"]
    ```
[find()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/find)
- returns the **value** of the **first element** in the array that satisfies the provided testing function
    ```
    var array1 = [5, 12, 8, 130, 44];

    var found = array1.find(function(element) {
      return element > 10;
    });

    console.log(found);
    // output: 12
    ```
[includes()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes)
- determines whether an array includes a certain element, returning true or false as appropriate
    ```
    var array1 = [1, 2, 3];

    console.log(array1.includes(2));
    // output: true
    ```

[forEach()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach)
- executes a provided function once for each array element
    ```
    var array1 = ['a', 'b'];

    array1.forEach(function(element) {
      console.log(element);
    });

    // expected output: "a"
    // expected output: "b"
    ```
[reverse()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reverse)
- reverses an array in place. The first array element becomes the last, and the last array element becomes the first
    ```
    var array1 = ['one', 'two', 'three'];
    var reversed = array1.reverse();

    console.log(array1);
    // expected output: Array ['three', 'two', 'one']

    console.log(reversed);
    // expected output: Array ['three', 'two', 'one']
    ```
[shift()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/shift)
- removes the first element from an array and returns that removed element. This method changes the length of the array
    ```
    var array1 = [1, 2, 3];

    var firstElement = array1.shift();

    console.log(array1);
    // expected output: Array [2, 3]

    console.log(firstElement);
    // expected output: 1
    ```
[sort()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
- sorts the elements of an array in place and returns the array. The sort is not necessarily stable. The default sort order is according to string Unicode code points
    - The time and space complexity of the sort cannot be guaranteed as it is implementation dependent
        ```
        var months = ['March', 'Jan', 'Feb', 'Dec'];
        months.sort();
        console.log(months);
        // expected output: Array ["Dec", "Feb", "Jan", "March"]

        var array1 = [1, 30, 4, 21];
        array1.sort();
        console.log(array1);
        // expected output: Array [1, 21, 30, 4]
        ```
[some()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some)
- tests whether at least one element in the array passes the test implemented by the provided function
    ```
    var array = [1, 2, 3, 4, 5];

    var even = function(element) {
      // checks whether an element is even
      return element % 2 === 0;
    };

    console.log(array.some(even));
    // expected output: true
    ```


#### Hash Table / Dictionary / Map
[Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map)
- use as a hash map / dictionary `new Map([iterable])`
    - A Map object iterates its elements in insertion order
        ```
        var myMap = new Map();

        var keyString = 'a string',
            keyObj = {},
            keyFunc = function() {};

        // setting the values
        myMap.set(keyString, "value associated with 'a string'");
        myMap.set(keyObj, 'value associated with keyObj');
        myMap.set(keyFunc, 'value associated with keyFunc');

        myMap.size; // 3

        // getting the values
        myMap.get(keyString);    // "value associated with 'a string'"
        myMap.get(keyObj);       // "value associated with keyObj"
        myMap.get(keyFunc);      // "value associated with keyFunc"

        myMap.get('a string');   // "value associated with 'a string'"
                                 // because keyString === 'a string'
        myMap.get({});           // undefined, because keyObj !== {}
        myMap.get(function() {}) // undefined, because keyFunc !== function () {}
        ```
        ```
        for (var [key, value] of myMap) {
          console.log(key + ' = ' + value);
        }
        ```

# References
- [CS Dojo - Data Structures and Algorithms](https://www.youtube.com/playlist?list=PLBZBJbE_rGRV8D7XZ08LK6z-4zPoWzu5H)
- [Sorting algorithms in JavaScript](http://blog.benoitvallon.com/sorting-algorithms-in-javascript/sorting-algorithms-in-javascript/)
- [JavaScript - Exercises, Practice, Solution](https://www.w3resource.com/javascript-exercises)
- [When should LinkedList be used over arrays?](https://www.quora.com/When-should-LinkedList-be-used-over-arrays)
