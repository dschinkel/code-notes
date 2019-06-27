# General

# Benefits of Using React
- The beauty of React is the splitting of complicated UI’s into little, bite-sized bits. Not only can we thus compartmentalize our app, we can also customize each compartment
- Through lifecycle methods, we can then control what happens when each tiny section of your UI renders, updates, thinks about re-rendering, and then disappears entirely

# Elements
- Elements are the smallest building blocks of React apps
- An element describes what you want to see on the screen: `const element = <h1>Hello, world</h1>;`
- Unlike browser DOM elements, React elements are plain objects, and are cheap to create. React DOM takes care of updating the DOM to match the React elements.
- **Note**: One might confuse elements with a more widely known concept of “components”. We will introduce components in the next section. Elements are what components are “made of”, and we encourage you to read this section before jumping ahead

##### Rendering an Element into the DOM
- Let’s say there is a <div> somewhere in your HTML file: `<div id="root"></div>`
    - We call this a “root” DOM node because everything inside it will be managed by React DOM.
    - Applications built with just React usually have a single root DOM node
    - If you are integrating React into an existing app, you may have as many isolated root DOM nodes as you like
- To render a React element into a root DOM node, pass both to ReactDOM.render():
    ```
    const element = <h1>Hello, world</h1>;
    ReactDOM.render(element, document.getElementById('root'));
    ```
    - It displays “Hello, world” on the page

##### Updating the Rendered Element
- React elements are immutable. Once you create an element, you can’t change its children or attributes
- An element is like a single frame in a movie: it represents the UI at a certain point in time
- With our knowledge so far, the only way to update the UI is to create a new element, and pass it to ReactDOM.render()
- Consider this ticking clock example:
    ```
    function tick() {
      const element = (
        <div>
          <h1>Hello, world!</h1>
          <h2>It is {new Date().toLocaleTimeString()}.</h2>
        </div>
      );
      ReactDOM.render(element, document.getElementById('root'));
    }

    setInterval(tick, 1000);
    ```
    - It calls ReactDOM.render() every second from a setInterval() callback.
    - Note: In practice, most React apps only call ReactDOM.render() once
    - In the next sections we will learn how such code gets encapsulated into [stateful components](https://reactjs.org/docs/state-and-lifecycle.html)
        - We recommend that you don’t skip topics because they build on each other

 ##### React Only Updates What’s Necessary
 - React DOM compares the element and its children to the previous one, and only applies the DOM updates necessary to bring the DOM to the desired state
 - Even though we create an element describing the whole UI tree on every tick, only the text node whose contents has changed gets updated by React DOM
 - In our experience, thinking about how the UI should look at any given moment rather than how to change it over time eliminates a whole class of bugs

# Components
- react components let you split the UI into independent, reusable pieces, and think about each piece in isolation
- There are two kinds of components: Stateless and Stateful
- You can use stateless components inside stateful components, and vice versa

#### Stateless Functional Components
- React .14 introduced a simpler way to define components called stateless functional components
- These components use plain JavaScript functions
    ```
    import  React from 'React'

    const HelloWorld - ({}) => {
        const sayHi = (event) => {
            alert(`Hi ${name}`);
        }

        return (
            <div>
                <a href="#" onClick={sayHi}>Say Hi</a>
            </div>
        );
    }

    HelloWorld.propTypes = {
        name: React.PropTypes.string.isRequired
    }

    export default HelloWorld;
    ```
- plain functions are generally preferable, and eliminating the class related cruft like extends and the constructor
- the stateless component is just a function. Thus, all the annoying and confusing quirks with Javascript’s this keyword are avoided
    - The entire component becomes easier to understand without the this keyword. Just compare the click handler in each approach:
    ```
    onClick={this.sayHi.bind(this)}>Say Hi</a>
    onClick={sayHi}>Say Hi</a>
    ```
    - the bind keyword isn’t necessary for the stateless component
        - dumping classes eliminates the need for calling bind to pass the this context around
        - there are [five different ways to handle binding in React](https://medium.freecodecamp.com/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)
- Stateless functional components are useful for dumb/presentational components
    - Presentational components focus on the UI rather than behavior so it’s important to avoid using state in presentational components
    - Instead, state should be managed by higher-level “container” components, or via Flux/Redux/etc
    - Stateless functional components don’t support state or lifecycle methods
    - This is a good thing. Why? Because it protects from laziness
        - it’s always tempting to add state to a presentational component when you’re in a hurry
        - It’s a quick way to hack in a feature
        - Since stateless functional components don’t support local state, you can’t easily hack in some state in a moment of laziness
        - Thus, stateless functional components programatically enforce keeping the component pure
        - You’re forced to put state management where it belongs: in higher level container components
- stateless functional components require less typing which translates less noise so cleaner code means readability is improved
    - with a single line return statement, you can omit the return and parentheses
    - If you do this and also use ES6 destructuring on props, the result is nearly all signal:
        ```
        import React from ‘react’;

        const HelloWorld = ({name}) => (
         <div>{`Hi ${name}`}</div>
        );

        export default HelloWorld;
        ```
        - It’s just a function that takes a parameter and returns markup and it's very clean
        - If you destructure your props in ES6 as I did in the example above, then all the data you use is now specified as a simple function argument
            - This means you also get improved code completion/intellisense support compared to class-based components
- We all know a function that takes a lot of parameters is a code smell
    - When you use ES6 destructuring with your stateless components, the argument list clearly conveys your component’s dependencies
        - Thus, it’s easy to spot components that need attention
        - In this case, you can either break up the component or rethink the data structures you’re passing around
    - Sometimes a long list of props can be easily resolved by passing an object instead
        - But if the props aren’t logically related enough to justify a single object, then it’s likely time to refactor the component into multiple separate components
- They're easy to understand
    - when you see a stateless functional component, you know it’s simply a function that takes props and spits out HTML
    - Even if it contains a lot of markup and nested functions inside the render, it’s conceptually simple
- Since it’s a pure function, your assertions are very straightforward: Given these values for props, I expect it to return this markup
    - So for the example HelloWorld component, I can assert that when the render function is called with the value of ‘Cory’ for props.name, it returns a div with ‘Hi Cory’ inside
    - *With React’s stateless functional components, each component can be easily tested in isolation. No mocking, state manipulation, special libraries, or tricky test harnesses are needed*
- stateless functional components may soon offer improved performance
    - Since there’s no state or lifecycle methods to worry about, the React team plans to avoid unnecessary checks and memory allocations in future releases
- functional components transpile down to less code than class components, which means functional components = smaller bundles
- we should strive to use stateless functional components wherever possible
    - stateless functions offer the most elegant approach for creating a reusable component in any popular framework

### Downsides
- I’m spending the week consulting a team in Seattle to help accelerate their transition to React
    - One response surprised me: Let’s forbid using functional components
        - Woah, really? We discussed the issue at length. Here’s why
- Functional components don’t support state, refs, or lifecycle methods
    - They can’t extend PureComponent either
    - Sometimes, you’ll create a functional component only to realize that you need one of these class-only features later
    - In these situations, it’s a hassle to manually convert to a function into a class
    - Instead of converting to a class, you can enhance existing functional with lifecycle methods, state, and more via recompose
- if you do convert it to a class the diff is noisy
    - Even a trivial one-line change results in a multi-line code review
    - If the component were declared as a class from the start, the true intent of the commit would be crystal clear — it would require a 4 character change
    - Conversion obscures the component’s history by creating the illusion that the component has been largely rewritten when in fact you may have made a very trivial change
    - The person who does the conversion will be “blamed” for writing many lines that they merely changed for conversion reasons
- Compare a minimal class to a function, and the differences are minor
   - Remember, constructors are optional without state
   - I forgot the functional style can be a one-liner with a simple arrow function:
    `const Hello = ({greeting, firstName}) => <div>{greeting} {firstName}</div>
- Function and class components look different. This inconsistency can slow developers down as they shift between the two styles
    - In classes, you say this.props, in functions, you say props
    - In classes, you declare a render function. In functions, you don’t
    - In classes, you destructure at the top of render. In functions, you destructure in the function’s argument list
    - In classes, you declare default props below the component (or via class properties if you’re willing to use a stage-3 feature). In functions, you declare default props using default arguments
- Yes, JavaScript’s classes are certainly different than Java and C# classes. But anyone working in OO-land on the server is likely to find this simple rule easy to understand:
    - A React component is a class that extends React.Component
        - Adding a nuanced conversation about how and when to use plain functions adds confusion for OO devs who are already accustomed to being required to use classes for everything
        - I’m not saying this mindset is healthy — the React community fosters more of a functional mindset. But, one must acknowledge that functional components create mental-model friction for OO devs
- While the React team has alluded to the chance that functional components will be faster or more efficient in the future, that’s not the case yet. So one could argue functional components are currently a premature optimization
    - And since functional components require conversion to a class to implement today’s performance tweaks like shouldComponentUpdate and PureComponent, they’re actually more of a hassle to optimize for performance today
- JavaScript developers already have a ridiculous number of decisions to make. Banning functional components eliminates a decision: Always create a class

#### Pure Functions
The definition of a pure function is:
    1. The function always returns the same result if the same arguments are passed in. It does not depend on any state, or data, change during a program’s execution. It must only depend on its input arguments.
    2. The function does not produce any observable side effects such as network requests, input and output devices, or data mutation

    - That’s all there is to a pure function. If it passes the above 2 requirements it’s pure. You’ve probably created a pure function in the past without even realizing

##### Side Effects Make a Function Impure
- An observable side effect is any interaction with the outside world from within a function
    - That could be anything from changing a variable that exists outside the function, to calling another method from within a function
    - If a pure function calls a pure function this isn’t a side effect and the calling function is still pure

Side effects include, but are not limited to:

    - Making a HTTP request
    - Mutating data
    - Printing to a screen or console
    - DOM Query/Manipulation
    - Math.random()
    - Getting the current time

- Side effects themselves are not bad and are often required. Except, for a function to be declared pure it must not contain any
- Not all functions need to be, or should be, pure

##### Examples of Pure vs. Impure Functions
- pure function that calculates the price of a product including tax (UK tax is 20%):
    ```
    function priceAfterTax(productPrice) {
     return (productPrice * 0.20) + productPrice;
    }
    ```
    - It passes both 1, and 2, of the requirements for a function to be declared pure
        - It doesn’t depend on any external input, it doesn’t mutate any data and it doesn’t have any side effects
    - If you run this function with the same input 100,000,000 times it **will always produce the same result**
- Impure function
    ```
    var tax = 20;
    function calculateTax(productPrice) {
     return (productPrice * (tax/100)) + productPrice;
    }
    ```
    - it’s impure because the function depends on an external tax variable
    - a pure function can not depend on outside variables
    - It fails one of the requirements thus this function is impure

##### Why Are Pure Functions Important In JavaScript?
- Pure functions are used heavily in Functional Programming
- libraries such as ReactJS and Redux require the use of pure functions
- But, pure functions can also be used in regular JavaScript that doesn’t depend on a single programming paradigm. You can mix pure and impure functions and that’s perfectly fine
- Not all functions need to be , or should be, pure
    - For example, an event handler for a button press that manipulates the DOM is not a good candidate for a pure function
    - But, the event handler can call other pure functions which will reduce the number of impure functions in your application

##### Testability And Refactoring
- One of the major benefits of using pure functions is they are immediately testable. They will always produce the same result if you pass in the same arguments
- They also makes maintaining and refactoring code much easier
    - You can change a pure function and not have to worry about unintended side effects messing up the entire application and ending up in debugging hell
    - When used correctly the use of pure functions produces better quality code.  It’s a cleaner way of working with lots of benefits

- pure functions are not limited to JavaScript. For an in depth — mind numbing — explanation of pure functions [see here](https://en.wikipedia.org/wiki/Pure_function)
    - I also highly recommend [reading thi](https://drboolean.gitbooks.io/mostly-adequate-guide/ch3.html)s and [this](https://toddmotto.com/pure-versus-impure-functions).

#### Stateful Components


#### Converting Functional Components to a Class
_converting to a class lets us use additional features such as local state and lifecycle hooks_
###### Steps
- Create an ES6 class, with the same name, that extends React.Component
- Add a single empty method to it called render()
- Move the body of the function into the render() method
- Replace props with this.props in the render() body
- Delete the remaining empty function declaration

#### Mounting
These methods are called when an instance of a component is being created and inserted into the DOM:
- constructor()
- static getDerivedStateFromProps()
- componentWillMount() / UNSAFE_componentWillMount()
- render()
- componentDidMount()

#### Updating
An update can be caused by changes to props or state. These methods are called when a component is being re-rendered:
- componentWillReceiveProps() / UNSAFE_componentWillReceiveProps()
- static getDerivedStateFromProps()
- shouldComponentUpdate()
- componentWillUpdate() / UNSAFE_componentWillUpdate()
- render()
- getSnapshotBeforeUpdate()
- componentDidUpdate()

#### Unmounting
This method is called when a component is being removed from the DOM:
- componentWillUnmount()

#### Class Properties
- defaultProps
- displayName

#### Instance Properties
- props
- state

#### APIs
Each component also provides
- setState()
- forceUpdate()

#### Error Handling
This method is called when there is an error during rendering, in a lifecycle method, or in the constructor of any child component.
- componentDidCatch()

#### Constructor
- called before it is mounted
- avoid introducing any side-effects or subscriptions in the constructor. For those use cases, use componentDidMount() instead
- is the right place to initialize state
    - just assign an object to this.state; don’t try to call setState() from the constructor
- also often used to bind event handlers to the class instance
- if you don’t initialize state and you don’t bind methods, you don’t need to implement a constructor for your React component
- In rare cases, it’s okay to initialize state based on props. This effectively “forks” the props and sets the state with the initial props:
    ```
    constructor(props) {
      super(props);
      this.state = {
        color: props.initialColor
      };
    }
    ```

#### render()
When called, it should examine this.props and this.state and return one of the following types:
- The render() function should be pure, meaning that it does not modify component state, it returns the same result each time it’s invoked, and it does not directly interact with the browser
    - Keeping render() pure makes components easier to think about
    - If you need to interact with the browser, perform your work in componentDidMount() or the other lifecycle methods instead
- render() will not be invoked if shouldComponentUpdate() returns false.

#### Keys
- Since React 16.2.0 if you use fragments, then you don't need to specify keys

- **React elements**
    - Typically created via JSX. An element can either be a representation of a native DOM component `(<div />)`, or a user-defined composite component `(<MyComponent />)`
- **String and numbers**. These are rendered as text nodes in the DOM.
- **Portals**
    - Created with ReactDOM.createPortal
- **null** - Renders nothing
- **Booleans** -  Render nothing. (Mostly exists to support return test && <Child /> pattern, where test is boolean.)
- You can also return multiple items from render() using an array:
    ```
    return [
        <li key="A">First item</li>,
        <li key="B">Second item</li>,
        <li key="C">Third item</li>,
    ];
    ```

# High Order Components

# Data Flow
### The Data Flows Down
- This is commonly called a **“top-down”** or **“unidirectional”** data flow
    - Any state is always owned by some specific component, and any data or UI derived from that state can only affect components “below” them in the tree
    - If you imagine a component tree as a waterfall of props, each component’s state is like an additional water source that joins it at an arbitrary point but also flows down
#### How It Works
- Neither parent nor child components can know if a certain component is stateful or stateless, and they shouldn’t care whether it is defined as a function or a class
    - This is why state is often called local or encapsulated. It is not accessible to any component other than the one that owns and sets it
- A component may choose to pass its state down as props to its child components:
    - `<h2>It is {this.state.date.toLocaleTimeString()}.</h2>`

        This also works for user-defined components:

        - `<FormattedDate date={this.state.date} />`
            - The FormattedDate component would receive the date in its props and wouldn’t know whether it came from the Clock’s state, from the Clock’s props, or was typed by hand:
                ```
                function FormattedDate(props) {
                  return <h2>It is {props.date.toLocaleTimeString()}.</h2>;
                }
                ```
- To show that all components are truly isolated, we can create an App component that renders three <Clock>s:
    ```
    function App() {
      return (
        <div>
          <Clock />
          <Clock />
          <Clock />
        </div>
      );
    }

    ReactDOM.render(
      <App />,
      document.getElementById('root')
    );
    ```
    - Each Clock sets up its own timer and updates independently.

# Lifecycle
- methods (AKA “lifecycle hooks”) that allow you to
    - free up resources taken by the components when they are destroyed
    - used declare special methods on the component class to run some code when a component mounts and unmounts
- UNSAFE_ - methods prefixed with this are being phased out and will only work up until React v17
    - Use the [rename-unsafe-lifecycles codemod](https://github.com/reactjs/react-codemod#rename-unsafe-lifecycles) to automatically update your components.

### componentWillMount (_legacy_)
- now called `UNSAFE_componentWillMount()`
- is invoked just before mounting occurs
- called before render(), therefore calling setState() synchronously in this method will not trigger an extra rendering
    - we recommend using the constructor() instead for initializing state
- Avoid introducing any side-effects or subscriptions in this method. For those use cases, use componentDidMount() instead
- This is the only lifecycle hook called on server rendering

#### _layman's terms_

- Your component is going to appear on the screen very shortly. That chunky render function, with all its beautifully off-putting JSX, is about to be called. What do you want to do?
    - The answer is… probably not much. Sorry to start off slow, but componentWillMount is a bit of a dud
    - The thing about componentWillMount is that there is no component to play with yet, so you can’t do anything involving the DOM
    - Also, nothing has changed since your component’s constructor was called, which is where you should be setting up your component’s default configuration anyway
- Your component is in default position at this point. Almost everything should be taken care of by the rest of your component code, without the complication of an additional lifecycle method
    - The exception is any setup that can only be done at runtime — namely, connecting to external API’s. For example, if you use Firebase for your app, you’ll need to get that set up as your app is first mounting.
    - But the key is that such configuration should be done at the highest level component of your app (the root component). That means 99% of your components should probably not use componentWillMount
- You may see people using componentWillMount to start AJAX calls to load data for your components. Don’t do this. We’ll get to that in the second
- Do Not Fetch Data Here
    - An asynchronous call to fetch data will not return before the render happens. This means the component will render with empty data at least once
        - here is no way to “pause” rendering to wait for data to arrive. You cannot return a promise from componentWillMount or wrangle in a setTimeout somehow
    - The right way to handle this is to setup the component’s initial state so that it’s valid for rendering

#### _Use Cases_
- **Most Common Use Case**: App configuration in your root component.
- **Can call setState**: Don’t. Use default state instead

### componentDidMount
- invoked immediately after a component is mounted
- initialization that requires DOM nodes should go here
- good place to instantiate the network request to get data
- good place to set up any subscriptions
    - If you do that, don’t forget to unsubscribe in componentWillUnmount()
- Calling setState() in this method will trigger an extra rendering
    - it will happen before the browser updates the screen
        - This guarantees that even though the render() will be called twice in this case, the user won’t see the intermediate state
        - Use this pattern with caution because it often causes performance issues
        - It can, however, be necessary for cases like modals and tooltips when you need to measure a DOM node before rendering something that depends on its size or position

#### _layman's terms_
- Now we’re talking. Your component is out there, mounted and ready to be used. Now what?
- Here is where you load in your data. I’ll let Tyler McGinnis explain why:
    - _You can’t guarantee the AJAX request won’t resolve before the component mounts. If it did, that would mean that you’d be trying to setState on an unmounted component, which not only won’t work, but React will yell at you for. Doing AJAX in componentDidMount will guarantee that there’s a component to update_
        - You can read more of his answer [here](https://tylermcginnis.com/react-interview-questions/).
- is also where you can do all the fun things you couldn’t do when there was no component to play with
    Here are some examples
    - draw on a <canvas> element that you just rendered
    - initialize a masonry grid layout from a collection of elements
    - add event listeners
- Basically, here you want to do all the setup you couldn’t do without a DOM, and start getting all the data you need

#### _Use Cases_

- **Most Common Use Case**: Starting AJAX calls to load in data for your component
- **Can call setState**: Yes.

### componentWillReceiveProps() (_legacy_)
- now called `UNSAFE_componentWillReceiveProps()`
- invoked before a mounted component receives new props
    - If you need to update the state in response to prop changes (for example, to reset it), you may compare this.props and nextProps and perform state transitions using this.setState() in this method
- Note that if a parent component causes your component to re-render, this method will be called even if props have not changed. Make sure to compare the current and next values if you only want to handle changes
- React doesn’t call UNSAFE_componentWillReceiveProps() with initial props during mounting. It only calls this method if some of component’s props may update
- Calling this.setState() generally doesn’t trigger UNSAFE_componentWillReceiveProps()

#### _layman's terms_
- Our component was doing just fine, when all of a sudden a stream of new props arrive to mess things up.
- Perhaps some data that was loaded in by a parent component’s componentDidMount finally arrived, and is being passed down
- Before our component does anything with the new props, componentWillReceiveProps is called, with the next props as the argument
    ```
    componentWillReceiveProps(nextProps) {
    	if (parseInt(nextProps.modelId, 10) !== parseInt(this.props.modelId, 10)) {
    		this.setState({ postsLoaded: false })
    		this.contentLoaded = 0
    	}
    }
    ```
- We are now in a fun place, where we have access to both the next props (via nextProps), and our current props (via this.props)
    - Here’s what we should do:
        1. check which props will change (big caveat with componentWillReceiveProps — sometimes it’s called when nothing has changed; React just wants to check in)
        1. If the props will change in a way that is significant, act on it

        - Here’s an example. Let’s say, as we alluded to above, that we have a canvas element. Let’s say we’re drawing a nice circle graphic on there based on this.props.percent
            - When we receive new props, IF the percent has changed, we want to redraw the grid. Here’s the code:
                ```
                componentWillReceiveProps(nextProps) {
                	if (this.props.percent !== nextProps.percent)
                		this.setUpCircle(nextProps.percent)
                	}
                }
                ```
- One more caveat — componentWillReceiveProps is not called on initial render. I mean technically the component is receiving props, but there aren’t any old props to compare to, so… doesn’t count.

#### _Use Cases_

- **Most Common Use Case**: Acting on particular prop changes to trigger state transitions
- **Can call setState**: Yes

### shouldComponentUpdate()
- use it to let React know if a component’s output is not affected by the current change in state or props
- default behavior is to re-render on every state change, and in the vast majority of cases you should rely on the default behavior
- is invoked before rendering when new props or state are being received. Defaults to true
- is not called for the initial render or when forceUpdate() is used
- Returning false does not prevent child components from re-rendering when their state changes

#### _layman's terms_
- Now our component is getting nervous
- We have new props. Typical React dogma says that when a component receives new props, or new state, it should update
    - But our component is a little bit anxious and is going to ask permission first
- Here’s what we get — a shouldComponentUpdate method, called with nextProps as the first argument, and nextState is the second:
    ```
    componentWillReceiveProps(nextProps, nextState) {
    	return this.props.engagement !== nextProps.engagement ||
    	nextState.input !== this.state.input
    }
    ```
- shouldComponentUpdate should always return a boolean — an answer to the question, “should I re-render?” Yes, little component, you should. The default is that it always returns true
    - But if you’re worried about wasted renders and other nonsense — shouldComponentUpdate is an awesome place to improve performance
    - I [wrote an article](https://engineering.musefind.com/how-to-benchmark-react-components-the-quick-and-dirty-guide-f595baf1014c) on using shouldComponentUpdate in this way
        - In the article, we talk about having a table with many many fields. The problem was that when the table re-rendered, each field would also re-render, slowing things down.
- ShouldComponentUpdate allows us to say: only update if the props you care about change
    - But keep in mind that it can cause major problems if you set it and forget it, because your React component will not update normally. So use with caution

#### _Use Cases_

- **Most Common Use Case**: Controlling exactly when your component will re-render
- **Can call setState**: No

### componentWillUpdate() (_legacy_)
- now called `UNSAFE_componentWillUpdate()`
- is not called for the initial render
- is invoked just before rendering when new props or state are being received
- Use this as an opportunity to perform preparation before an update occurs
- you cannot call this.setState() here; nor should you do anything else (e.g. dispatch a Redux action) that would trigger an update to a React component before UNSAFE_componentWillUpdate() returns
- If you need to update state in response to props changes, use getDerivedStateFromProps() instead
- UNSAFE_componentWillUpdate() will not be invoked if shouldComponentUpdate() returns false

#### _layman's terms_
- Wow, what a process. Now we’ve committed to updating. “Want me to do anything before I re-render?” our component asks. No, we say. Stop bothering us
- In the entire MuseFind codebase, we never use componentWillUpdate. Functionally, it’s basically the same as componentWillReceiveProps, except you are not allowed to call this.setState
- If you were using shouldComponentUpdate AND needed to do something when props change, componentWillUpdate makes sense. But it’s probably not going to give you a whole lot of additional utility

#### _Use Cases_

- **Most Common Use Case**: Used instead of componentWillReceiveProps on a component that also has shouldComponentUpdate (but no access to previous props)
- **Can call setState**: No

### getSnapshotBeforeUpdate()
- invoked right before the most recently rendered output is committed to e.g. the DOM
- enables your component to capture current values (e.g. scroll position) before they are potentially changed
- any value returned by this lifecycle will be passed as a parameter to componentDidUpdate()

### componentDidUpdate()
- invoked immediately after updating occurs
- is not called for the initial render
- use this to operate on the DOM when the component has been updated
- also a good place to do network requests as long as you compare the current props to previous props (e.g. a network request may not be necessary if the props have not changed)
- If your component implements the getSnapshotBeforeUpdate() lifecycle, the value it returns will be passed as a third “snapshot” parameter to componentDidUpdate()
- will not be invoked if shouldComponentUpdate() returns false

#### _layman's terms_
- Good job, little component
- Here we can do the same stuff we did in componentDidMount — reset our masonry layout, redraw our canvas, etc.
- Wait - didn’t we redraw our canvas in componentWillReceiveProps?
    - Yes, we did. Here’s why: in componentDidUpdate, you don’t know why it updated
    - So if our component is receiving more props than those relevant to our canvas, we don’t want to waste time redrawing the canvas every time it updates.
    - That doesn’t mean componentDidUpdate isn’t useful. To go back to our masonry layout example, we want to rearrange the grid after the DOM itself updates — so we use componentDidUpdate to do so:
        ```
        componentDidUpdate () {
        	this.createGrid()
        }
        ```
#### _Use Cases_

- **Most Common Use Case**: Updating the DOM in response to prop or state changes
- **Can call setState**: Yes

### componentWillUnmount()
- invoked immediately before a component is unmounted and destroyed
- perform any necessary cleanup in this method, such as invalidating timers, canceling network requests, or cleaning up any subscriptions that were created in componentDidMount()

#### _layman's terms_
- It’s almost over
- Your component is going to go away. Maybe forever. It’s very sad.
- Before it goes, it asks if you have any last-minute requests.
- Here you can cancel any outgoing network requests, or remove all event listeners associated with the component.
- Basically, clean up anything to do that solely involves the component in question — when it’s gone, it should be completely gone:
    ```
    componentWillUnmount () {
    	window.removeEventListener('resize', this.resizeListener)
    }
    ```
#### _Use Cases_

- **Most Common Use Case**: Cleaning up any leftover debris from your component
- **Can call setState**: No

### componentDidCatch
- Error boundaries are React components that catch JavaScript errors anywhere in their child component tree, log those errors, and display a fallback UI instead of the component tree that crashed. Error boundaries catch errors during rendering, in lifecycle methods, and in constructors of the whole tree below them
- A class component becomes an error boundary if it defines this lifecycle method. Calling setState() in it lets you capture an unhandled JavaScript error in the below tree and display a fallback UI. Only use error boundaries for recovering from unexpected exceptions; don’t try to use them for control flow
- Error boundaries only catch errors in the components below them in the tree. An error boundary can’t catch an error within itself

#### Conclusion
- In an ideal world, we wouldn’t use lifecycle methods. All our rendering issues would be controlled via state and props
    - But it’s not an ideal world, and sometimes you need to exact a little more control over how and when your component is updating
    - Use these methods sparingly, and use them with care. I hope this article has been helpful in illuminating when and how to use lifecycle methods

# Local State

#### setState()
- a feature available only to React classes
- you access state by `this.state.someProperty`
- you initialize state in the class constructor using an object literal:
    ```
    constructor(props) {
        super(props);
        this.state = {date: new Date()};
    }
    ```
- state is similar to props, but it is private and fully controlled by the component
- enqueues changes to the component state and tells React that this component and its children need to be re-rendered with the updated state
- the primary method you use to update the user interface in response to event handlers and server responses
- think of setState() as a request rather than an immediate command to update the component
    - for better perceived performance, React may delay it, and then update several components in a single pass. React does not guarantee that the state changes are applied immediately
    - does not always immediately update the component. It may batch or defer the update until later
        - this makes reading this.state right after calling setState() a potential pitfall
            - instead, use componentDidUpdate or a setState callback (setState(updater, callback)), either of which are guaranteed to fire after the update has been applied
         - If you need to set the state based on the previous state, read about the updater argument
 - will always lead to a re-render unless shouldComponentUpdate() returns false
 - If mutable objects are being used and conditional rendering logic cannot be implemented in shouldComponentUpdate(), calling setState() only when the new state differs from the previous state will avoid unnecessary re-renders
 - The first argument is an updater function with the signature:
    - prevState is a reference to the previous state. It should not be directly mutated. Instead, changes should be represented by building a new object based on the input from prevState and props
        - For instance, suppose we wanted to increment a value in state by props.step:
            ```
            this.setState((prevState, props) => {
              return {counter: prevState.counter + props.step};
            });
            ```
            - Both prevState and props received by the updater function are guaranteed to be up-to-date. The output of the updater is shallowly merged with prevState
    - You may optionally pass an object as the first argument to setState() instead of a function:
        ```setState(stateChange[, callback])```
 - The second parameter to setState() is an optional callback function that will be executed once setState is completed and the component is re-rendered
    - Generally we recommend using componentDidUpdate() for such logic instead
- This performs a shallow merge of stateChange into the new state, e.g., to adjust a shopping cart item quantity: `this.setState({quantity: 2})`
    - This form of setState() is also asynchronous, and multiple calls during the same cycle may be batched together. For example, if you attempt to increment an item quantity more than once in the same cycle, that will result in the equivalent of:
        ```
        Object.assign(
          previousState,
          {quantity: state.quantity + 1},
          {quantity: state.quantity + 1},
          ...
        )
        ```
 - Subsequent calls will override values from previous calls in the same cycle, so the quantity will only be incremented once. If the next state depends on the previous state, we recommend using the updater function form, instead:
    ```
    this.setState((prevState) => {
      return {quantity: prevState.quantity + 1};
    });
    ```

#### forceUpdate()
- By default, when your component’s state or props change, your component will re-render. If your render() method depends on some other data, you can tell React that the component needs re-rendering by calling forceUpdate()
- Calling forceUpdate() will cause render() to be called on the component, skipping shouldComponentUpdate(). This will trigger the normal lifecycle methods for child components, including the shouldComponentUpdate() method of each child. React will still only update the DOM if the markup changes
- Normally you should try to avoid all uses of forceUpdate() and only read from this.props and this.state in render()

#### What To Store

# Lifting State Up
- Often, several components need to reflect the same changing data. We recommend lifting the shared state up to their closest common ancestor. Let’s see how this works in action
    - example: Currently, both TemperatureInput components independently keep their values in the local state:
        ```
        class TemperatureInput extends React.Component {
          constructor(props) {
            super(props);
            this.handleChange = this.handleChange.bind(this);
            this.state = {temperature: ''};
          }

          handleChange(e) {
            this.setState({temperature: e.target.value});
          }

          render() {
            const temperature = this.state.temperature;
            // ...
        ```
        - However, we want these two inputs to be in sync with each other
        - When we update the Celsius input, the Fahrenheit input should reflect the converted temperature, and vice versa
        - In React, sharing state is accomplished by moving it up to the closest common ancestor of the components that need it
            - This is called “lifting state up”
                - We will remove the local state from the TemperatureInput and move it into the Calculator instead
                - If the Calculator owns the shared state, it becomes the “source of truth” for the current temperature in both inputs
                - It can instruct them both to have values that are consistent with each other
                - Since the props of both TemperatureInput components are coming from the same parent Calculator component, the two inputs will always be in sync
                - how this works step by step:
                    - First, we will replace this.state.temperature with this.props.temperature in the TemperatureInput component. For now, let’s pretend this.props.temperature already exists, although we will need to pass it from the Calculator in the future:
                        ```
                        render() {
                            // Before: const temperature = this.state.temperature;
                            const temperature = this.props.temperature;
                            // ...
                        ```
                        - We know that props are read-only. When the temperature was in the local state, the TemperatureInput could just call this.setState() to change it. However, now that the temperature is coming from the parent as a prop, the TemperatureInput has no control over it
                        - In React, this is usually solved by making a component “controlled”. Just like the DOM <input> accepts both a value and an onChange prop, so can the custom TemperatureInput accept both temperature and onTemperatureChange props from its parent Calculator
                        - Now, when the TemperatureInput wants to update its temperature, it calls this.props.onTemperatureChange
                            ```
                             handleChange(e) {
                                // Before: this.setState({temperature: e.target.value});
                                this.props.onTemperatureChange(e.target.value);
                                // ...
                            ```
                        - The onTemperatureChange prop will be provided together with the temperature prop by the parent Calculator component. It will handle the change by modifying its own local state, thus re-rendering both inputs with the new values. We will look at the new Calculator implementation very soon
                         - Note: There is no special meaning to either temperature or onTemperatureChange prop names in custom components. We could have called them anything else, like name them value and onChange which is a common convention
                         - Before diving into the changes in the Calculator, let’s recap our changes to the TemperatureInput component:
                            - We have removed the local state from it, and instead of reading this.state.temperature, we now read this.props.temperature
                            - Instead of calling this.setState() when we want to make a change, we now call this.props.onTemperatureChange(), which will be provided by the Calculator:
                                ```
                                class TemperatureInput extends React.Component {
                                  constructor(props) {
                                    super(props);
                                    this.handleChange = this.handleChange.bind(this);
                                  }

                                  handleChange(e) {
                                    this.props.onTemperatureChange(e.target.value);
                                  }

                                  render() {
                                    const temperature = this.props.temperature;
                                    const scale = this.props.scale;
                                    return (
                                      <fieldset>
                                        <legend>Enter temperature in {scaleNames[scale]}:</legend>
                                        <input value={temperature}
                                               onChange={this.handleChange} />
                                      </fieldset>
                                    );
                                  }
                                }
                                ```

                         - Now let’s turn to the Calculator component
                            - We will store the current input’s temperature and scale in its local state
                            - This is the state we “lifted up” from the inputs, and it will serve as the “source of truth” for both of them
                            - It is the minimal representation of all the data we need to know in order to render both inputs
                                - For example, if we enter 37 into the Celsius input, the state of the Calculator component will be:
                                ```
                                {
                                  temperature: '37',
                                  scale: 'c'
                                }
                                ```
                                - If we later edit the Fahrenheit field to be 212, the state of the Calculator will be:
                                    ```
                                    {
                                      temperature: '212',
                                      scale: 'f'
                                    }
                                    ```
                                - We could have stored the value of both inputs but it turns out to be unnecessary
                                    - It is enough to store the value of the most recently changed input, and the scale that it represents
                                    - We can then infer the value of the other input based on the current temperature and scale alone
                                - The inputs stay in sync because their values are computed from the same state:
                                    ```
                                    class Calculator extends React.Component {
                                      constructor(props) {
                                        super(props);
                                        this.handleCelsiusChange = this.handleCelsiusChange.bind(this);
                                        this.handleFahrenheitChange = this.handleFahrenheitChange.bind(this);
                                        this.state = {temperature: '', scale: 'c'};
                                      }

                                      handleCelsiusChange(temperature) {
                                        this.setState({scale: 'c', temperature});
                                      }

                                      handleFahrenheitChange(temperature) {
                                        this.setState({scale: 'f', temperature});
                                      }

                                      render() {
                                        const scale = this.state.scale;
                                        const temperature = this.state.temperature;
                                        const celsius = scale === 'f' ? tryConvert(temperature, toCelsius) : temperature;
                                        const fahrenheit = scale === 'c' ? tryConvert(temperature, toFahrenheit) : temperature;

                                        return (
                                          <div>
                                            <TemperatureInput
                                              scale="c"
                                              temperature={celsius}
                                              onTemperatureChange={this.handleCelsiusChange} />

                                            <TemperatureInput
                                              scale="f"
                                              temperature={fahrenheit}
                                              onTemperatureChange={this.handleFahrenheitChange} />

                                            <BoilingVerdict
                                              celsius={parseFloat(celsius)} />

                                          </div>
                                        );
                                      }
                                    }
                                    ```
    - Now, no matter which input you edit, this.state.temperature and this.state.scale in the Calculator get updated
    - One of the inputs gets the value as is, so any user input is preserved, and the other input value is always recalculated based on it
    - recap:
        - React calls the function specified as onChange on the DOM <input>. In our case, this is the handleChange method in TemperatureInput component
        - The handleChange method in the TemperatureInput component calls this.props.onTemperatureChange() with the new desired value. Its props, including onTemperatureChange, were provided by its parent component, the Calculator
        - When it previously rendered, the Calculator has specified that onTemperatureChange of the Celsius TemperatureInput is the Calculator’s handleCelsiusChange method, and onTemperatureChange of the Fahrenheit TemperatureInput is the Calculator’s handleFahrenheitChange method. So either of these two Calculator methods gets called depending on which input we edited
        - Inside these methods, the Calculator component asks React to re-render itself by calling this.setState() with the new input value and the current scale of the input we just edited
        - React calls the Calculator component’s render method to learn what the UI should look like. The values of both inputs are recomputed based on the current temperature and the active scale. The temperature conversion is performed here
        - React calls the render methods of the individual TemperatureInput components with their new props specified by the Calculator. It learns what their UI should look like
        - React DOM updates the DOM to match the desired input values. The input we just edited receives its current value, and the other input is updated to the temperature after conversion
    - Every update goes through the same steps so the inputs stay in sync

##### Lessons Learned
- There should be a single “source of truth” for any data that changes in a React application. Usually, the state is first added to the component that needs it for rendering. Then, if other components also need it, you can lift it up to their closest common ancestor. Instead of trying to sync the state between different components, you should rely on the top-down data flow
- Lifting state involves writing more “boilerplate” code than two-way binding approaches, but as a benefit, it takes less work to find and isolate bugs. Since any state “lives” in some component and that component alone can change it, the surface area for bugs is greatly reduced. Additionally, you can implement any custom logic to reject or transform user input
- If something can be derived from either props or state, it probably shouldn’t be in the state. For example, instead of storing both celsiusValue and fahrenheitValue, we store just the last edited temperature and its scale. The value of the other input can always be calculated from them in the render() method. This lets us clear or apply rounding to the other field without losing any precision in the user input
- When you see something wrong in the UI, you can use React Developer Tools to inspect the props and move up the tree until you find the component responsible for updating the state. This lets you trace the bugs to their source: [see picture at bottom of this page](https://reactjs.org/docs/lifting-state-up.html)

# Composition vs. Inheritance
- React has a powerful composition model, and we recommend using composition instead of inheritance to reuse code between components
- we will consider a few problems where developers new to React often reach for inheritance, and show how we can solve them with composition

##### Containment
- Some components don’t know their children ahead of time
    - This is especially common for components like Sidebar or Dialog that represent generic “boxes”
    - We recommend that such components use the special children prop to pass children elements directly into their output:
        ```
        function FancyBorder(props) {
          return (
            <div className={'FancyBorder FancyBorder-' + props.color}>
              {props.children}
            </div>
          );
        }
        ```
        - This lets other components pass arbitrary children to them by nesting the JSX:
            ```
            function WelcomeDialog() {
              return (
                <FancyBorder color="blue">
                  <h1 className="Dialog-title">
                    Welcome
                  </h1>
                  <p className="Dialog-message">
                    Thank you for visiting our spacecraft!
                  </p>
                </FancyBorder>
              );
            }
            ```
            - Anything inside the <FancyBorder> JSX tag gets passed into the FancyBorder component as a children prop
            - Since FancyBorder renders {props.children} inside a <div>, the passed elements appear in the final output
- While this is less common, sometimes you might need multiple “holes” in a component. In such cases you may come up with your own convention instead of using children:
    ```
    function SplitPane(props) {
      return (
        <div className="SplitPane">
          <div className="SplitPane-left">
            {props.left}
          </div>
          <div className="SplitPane-right">
            {props.right}
          </div>
        </div>
      );
    }

    function App() {
      return (
        <SplitPane
          left={
            <Contacts />
          }
          right={
            <Chat />
          } />
      );
    }
    ```
    - React elements like <Contacts /> and <Chat /> are just objects, so you can pass them as props like any other data
    - This approach may remind you of “slots” in other libraries but there are no limitations on what you can pass as props in React

##### Specialization
- Sometimes we think about components as being “special cases” of other components
    - For example, we might say that a WelcomeDialog is a special case of Dialog
- In React, this is also achieved by composition, where a more “specific” component renders a more “generic” one and configures it with props:
    ```
    function Dialog(props) {
      return (
        <FancyBorder color="blue">
          <h1 className="Dialog-title">
            {props.title}
          </h1>
          <p className="Dialog-message">
            {props.message}
          </p>
        </FancyBorder>
      );
    }

    function WelcomeDialog() {
      return (
        <Dialog
          title="Welcome"
          message="Thank you for visiting our spacecraft!" />

      );
    }
    ```

- Composition works equally well for components defined as classes:
    ```
    function Dialog(props) {
      return (
        <FancyBorder color="blue">
          <h1 className="Dialog-title">
            {props.title}
          </h1>
          <p className="Dialog-message">
            {props.message}
          </p>
          {props.children}
        </FancyBorder>
      );
    }

    class SignUpDialog extends React.Component {
      constructor(props) {
        super(props);
        this.handleChange = this.handleChange.bind(this);
        this.handleSignUp = this.handleSignUp.bind(this);
        this.state = {login: ''};
      }

      render() {
        return (
          <Dialog title="Mars Exploration Program"
                  message="How should we refer to you?">
            <input value={this.state.login}
                   onChange={this.handleChange} />

            <button onClick={this.handleSignUp}>
              Sign Me Up!
            </button>
          </Dialog>
        );
      }

      handleChange(e) {
        this.setState({login: e.target.value});
      }

      handleSignUp() {
        alert(`Welcome aboard, ${this.state.login}!`);
      }
    }
    ```

##### Containment
- Some components don’t know their children ahead of time
    - This is especially common for components like Sidebar or Dialog that represent generic “boxes”
    - We recommend that such components use the special children prop to pass children elements directly into their output:
        ```
        function FancyBorder(props) {
          return (
            <div className={'FancyBorder FancyBorder-' + props.color}>
              {props.children}
            </div>
          );
        }
        ```
        - This lets other components pass arbitrary children to them by nesting the JSX:
        ```
        function WelcomeDialog() {
          return (
            <FancyBorder color="blue">
              <h1 className="Dialog-title">
                Welcome
              </h1>
              <p className="Dialog-message">
                Thank you for visiting our spacecraft!
              </p>
            </FancyBorder>
          );
        }
        ```

# Props
 - React uses a “top-down” or “unidirectional” data flow.  This is done by passing props to child components (passing props to both functional components or class components)
 - Functional components: you pass them in via a param called `props`
 - Classes: You pass them in via the constructor and to super()
    ```
    constructor(props) {
        super(props);
        this.state = {date: new Date()};
      }
    ```
    - Class components should always call the base constructor with props

#### Inheritance
- At Facebook, we use React in thousands of components, and we haven’t found any use cases where we would recommend creating component inheritance hierarchies
- Props and composition give you all the flexibility you need to customize a component’s look and behavior in an explicit and safe way. Remember that components may accept arbitrary props, including primitive values, React elements, or functions
- If you want to reuse non-UI functionality between components, we suggest extracting it into a separate JavaScript module. The components may import it and use that function, object, or a class, without extending it

# Classes
- While this.props is set up by React itself and this.state has a special meaning, you are free to add additional fields to the class manually if you need to store something that doesn’t participate in the data flow
- When implementing the constructor for a React.Component subclass, you should call super(props) before any other statement. Otherwise, this.props will be undefined in the constructor, which can lead to bugs

#### JS Scope

#### Class Properties
###### defaultProps
- defaultProps can be defined as a property on the component class itself, to set the default props for the class. This is used for undefined props, but not for null props:
    ```
    class CustomButton extends React.Component {
      // ...
    }

    CustomButton.defaultProps = {
      color: 'blue'
    };
    ```
    - If props.color is not provided, it will be set by default to 'blue'
    - If props.color is set to null, it will remain null
##### displayName
- The displayName string is used in debugging messages. Usually, you don’t need to set it explicitly because it’s inferred from the name of the function or class that defines the component. You might want to set it explicitly if you want to display a different name for debugging purposes or when you create a higher-order component, see Wrap the Display Name for Easy Debugging for details

#### Instance Properties
##### props
- this.props contains the props that were defined by the caller of this component
- this.props.children is a special prop, typically defined by the child tags in the JSX expression rather than in the tag itself
##### local state
- state is similar to props, but it is private and fully controlled by the component
- state contains data specific to this component that may change over time
- is user-defined, and it should be a plain JavaScript object
- if some value isn’t used for rendering or data flow (for example, a timer ID), you don’t have to put it in the state. Such values can be defined as fields on the component instance
- never mutate this.state directly, as calling setState() afterwards may replace the mutation you made. Treat this.state as if it were immutable
- this.setState() is used to schedule updates to a component's local state
- There are three things you should know about setState():
    - Do Not Modify State Directly
        ```
        // Wrong
        this.state.comment = 'Hello';
        ```
        - the only place where you can assign this.state is the constructor
    - State Updates May Be Asynchronous
        - **React may batch multiple setState() calls into a single update for performance**
        - **Because this.props and this.state may be updated asynchronously, you should not rely on their values for calculating the next state**
            - For example, this code may fail to update the counter:
                ```
                // Wrong
                this.setState({
                  counter: this.state.counter + this.props.increment,
                });
                ```
            - To fix it, use a second form of setState() that accepts a function rather than an object
                - That function will receive the previous state as the first argument, and the props at the time the update is applied as the second argument:
                    ```
                    // Correct
                    this.setState((prevState, props) => ({
                      counter: prevState.counter + props.increment
                    }));
                    ```
                - We used an arrow function above, but it also works with regular functions:
                    ```
                    // Correct
                    this.setState(function(prevState, props) {
                      return {
                        counter: prevState.counter + props.increment
                      };
                    });
                    ```
         - **State Updates are Merged**
            - When you call setState(), React merges the object you provide into the current state

                For example, your state may contain several independent variables:

                    ```
                      constructor(props) {
                        super(props);
                        this.state = {
                          posts: [],
                          comments: []
                        };
                      }
                    ```
                Then you can update them independently with separate setState() calls:
                    ```
                      componentDidMount() {
                        fetchPosts().then(response => {
                          this.setState({
                            posts: response.posts
                          });
                        });

                        fetchComments().then(response => {
                          this.setState({
                            comments: response.comments
                          });
                        });
                      }
                      ```

                - The merging is shallow, so this.setState({comments}) leaves this.state.posts intact, but completely replaces this.state.comments

#### Destructuring Arguments
- used to allow functions to accept an object
- can specify default values if desired
- When you have an object with several properties this can really reduce the sea of something === undefined checks at the top of your function
    - Example
        ```
        myFunc({ name: 'John', age: 25 }); // send in an object literal

        function myFunc({name, age}) {
            // now I can work with name and age extracted from incoming object
        }
        function myFunc({name = '', age = 0 }) {
            // now I can work with name and age extracted from incoming object
        }
        ```

# JSX
- Fundamentally, JSX just provides syntactic sugar for the React.createElement(component, props, ...children) function. The JSX code:
    ```
    <MyButton color="blue" shadowSize={2}>
      Click Me
    </MyButton>
    ```
    compiles into:
    ```
    React.createElement(
      MyButton,
      {color: 'blue', shadowSize: 2},
      'Click Me'
    )
    ```
- You can also use the self-closing form of the tag if there are no children. So:
    `<div className="sidebar" />`
    compiles into:
    ```
    React.createElement(
      'div',
      {className: 'sidebar'},
      null
    )
    ```
- Consider this variable declaration:
    `const element = <h1>Hello, world!</h1>;`
    - This funny tag syntax is neither a string nor HTML
    - It is called JSX, and it is a syntax extension to JavaScript. We recommend using it with React to describe what the UI should look like
    - JSX may remind you of a template language, but it comes with the full power of JavaScript
    - JSX produces React “elements”
- If you want to test out how some specific JSX is converted into JavaScript, you can try out the [online Babel compiler](https://babeljs.io/repl/#?presets=react&code_lz=GYVwdgxgLglg9mABACwKYBt1wBQEpEDeAUIogE6pQhlIA8AJjAG4B8AEhlogO5xnr0AhLQD0jVgG4iAXyJA)

##### Why JSX?
- React embraces the fact that rendering logic is inherently coupled with other UI logic: how events are handled, how the state changes over time, and how the data is prepared for display
- Instead of artificially separating technologies by putting markup and logic in separate files, React separates concerns with loosely coupled units called “components” that contain both
- It also allows React to show more useful error and warning messages
- React doesn’t require using JSX, but most people find it helpful as a visual aid when working with UI inside the JavaScript code

##### Embedding Expressions in JSX
- You can embed any JavaScript expression in JSX by wrapping it in curly braces
    - For example, 2 + 2, user.firstName, and formatName(user) are all valid expressions:
        ```
        function formatName(user) {
          return user.firstName + ' ' + user.lastName;
        }

        const user = {
          firstName: 'Harper',
          lastName: 'Perez'
        };

        const element = (
          <h1>
            Hello, {formatName(user)}!
          </h1>
        );

        ReactDOM.render(
          element,
          document.getElementById('root')
        );
        ```
        - We split JSX over multiple lines for readability
        - While it isn’t required, when doing this, we also recommend wrapping it in parentheses to avoid the pitfalls of [automatic semicolon insertion](http://stackoverflow.com/q/2846283)

##### JSX is an Expression Too
- After compilation, JSX expressions become regular JavaScript function calls and evaluate to JavaScript objects
    - This means that you can use JSX inside of if statements and for loops, assign it to variables, accept it as arguments, and return it from functions:
        ```
       function getGreeting(user) {
         if (user) {
           return <h1>Hello, {formatName(user)}!</h1>;
         }
         return <h1>Hello, Stranger.</h1>;
       }
       ```

##### Specifying The React Element Type
- The first part of a JSX tag determines the type of the React element
- Capitalized types indicate that the JSX tag is referring to a React component
    - These tags get compiled into a direct reference to the named variable, so if you use the JSX <Foo /> expression, Foo must be in scope

##### React Must Be in Scope
- Since JSX compiles into calls to React.createElement, the React library must also always be in scope from your JSX code
- For example, both of the imports are necessary in this code, even though React and CustomButton are not directly referenced from JavaScript:
    ```
    import React from 'react';
    import CustomButton from './CustomButton';

    function WarningButton() {
      // return React.createElement(CustomButton, {color: 'red'}, null);
      return <CustomButton color="red" />;
    }
    ```
    - If you don’t use a JavaScript bundler and loaded React from a <script> tag, it is already in scope as the React global

##### Using Dot Notation for JSX Type
- You can also refer to a React component using dot-notation from within JSX
    - This is convenient if you have a single module that exports many React components
        - For example, if MyComponents.DatePicker is a component, you can use it directly from JSX with:
            ```
            import React from 'react';

            const MyComponents = {
              DatePicker: function DatePicker(props) {
                return <div>Imagine a {props.color} datepicker here.</div>;
              }
            }

            function BlueDatePicker() {
              return <MyComponents.DatePicker color="blue" />;
            }
            ```

##### User-Defined Components Must Be Capitalized
- When an element type starts with a lowercase letter, it refers to a built-in component like `<div>` or `<span>` and results in a string 'div' or 'span' passed to React.createElement
- Types that start with a capital letter like `<Foo />` compile to React.createElement(Foo) and correspond to a component defined or imported in your JavaScript file
- We recommend naming components with a capital letter. If you do have a component that starts with a lowercase letter, assign it to a capitalized variable before using it in JSX
    - For example, this code will not run as expected:
        ```
        import React from 'react';

        // Wrong! This is a component and should have been capitalized:
        function hello(props) {
          // Correct! This use of <div> is legitimate because div is a valid HTML tag:
          return <div>Hello {props.toWhat}</div>;
        }

        function HelloWorld() {
          // Wrong! React thinks <hello /> is an HTML tag because it's not capitalized:
          return <hello toWhat="World" />;
        }
        ```
        To fix this, we will rename hello to Hello and use <Hello /> when referring to it:
        ```
        import React from 'react';

        // Correct! This is a component and should be capitalized:
        function Hello(props) {
          // Correct! This use of <div> is legitimate because div is a valid HTML tag:
          return <div>Hello {props.toWhat}</div>;
        }

        function HelloWorld() {
          // Correct! React knows <Hello /> is a component because it's capitalized.
          return <Hello toWhat="World" />;
        }
        ```
##### Choosing the Type at Runtime
- You cannot use a general expression as the React element type
    - If you do want to use a general expression to indicate the type of the element, just assign it to a capitalized variable first
    - This often comes up when you want to render a different component based on a prop:
        ```
        import React from 'react';
        import { PhotoStory, VideoStory } from './stories';

        const components = {
          photo: PhotoStory,
          video: VideoStory
        };

        function Story(props) {
          // Wrong! JSX type can't be an expression.
          return <components[props.storyType] story={props.story} />;
        }
        ```
        To fix this, we will assign the type to a capitalized variable first:
        ```
        import React from 'react';
        import { PhotoStory, VideoStory } from './stories';

        const components = {
          photo: PhotoStory,
          video: VideoStory
        };

        function Story(props) {
          // Correct! JSX type can be a capitalized variable.
          const SpecificStory = components[props.storyType];
          return <SpecificStory story={props.story} />;
        }
        ```

##### Props in JSX
- You can pass any JavaScript expression as a prop, by surrounding it with {}. For example, in this JSX:
    `<MyComponent foo={1 + 2 + 3 + 4} />`
    - For MyComponent, the value of props.foo will be 10 because the expression 1 + 2 + 3 + 4 gets evaluated
    - if statements and for loops are not expressions in JavaScript, so they can’t be used in JSX directly. Instead, you can put these in the surrounding code.  For example:
        ```
        function NumberDescriber(props) {
          let description;
          if (props.number % 2 == 0) {
            description = <strong>even</strong>;
          } else {
            description = <i>odd</i>;
          }
          return <div>{props.number} is an {description} number</div>;
        }
        ```
        - ou can learn more about [conditional rendering](https://reactjs.org/docs/conditional-rendering.html) and [loops](https://reactjs.org/docs/lists-and-keys.html) in the corresponding sections

##### String Literals
- You can pass a string literal as a prop. These two JSX expressions are equivalent:
    ```
    <MyComponent message="hello world" />
    <MyComponent message={'hello world'} />
    ```
- When you pass a string literal, its value is HTML-unescaped. So these two JSX expressions are equivalent:
    ```
    <MyComponent message="&lt;3" />
    <MyComponent message={'<3'} />
    ```
- This behavior is usually not relevant. It’s only mentioned here for completeness

##### Props Default to “True”
- If you pass no value for a prop, it defaults to true. These two JSX expressions are equivalent:
    ```
    <MyTextBox autocomplete />
    <MyTextBox autocomplete={true} />
    ```
- In general, we don’t recommend using this because it can be confused with the ES6 object shorthand {foo} which is short for {foo: foo} rather than {foo: true}
    - This behavior is just there so that it matches the behavior of HTML

##### Spread Attributes
- If you already have props as an object, and you want to pass it in JSX, you can use ... as a “spread” operator to pass the whole props object. These two components are equivalent:
    ```
    function App1() {
      return <Greeting firstName="Ben" lastName="Hector" />;
    }

    function App2() {
      const props = {firstName: 'Ben', lastName: 'Hector'};
      return <Greeting {...props} />;
    }
    ```
- You can also pick specific props that your component will consume while passing all other props using the spread operator:
    ```
    const Button = props => {
      const { kind, ...other } = props;
      const className = kind === "primary" ? "PrimaryButton" : "SecondaryButton";
      return <button className={className} {...other} />;
    };

    const App = () => {
      return (
        <div>
          <Button kind="primary" onClick={() => console.log("clicked!")}>
            Hello World!
          </Button>
        </div>
      );
    };
    ```
    - In the example above, the kind prop is safely consumed and is not passed on to the `<button>` element in the DOM
        - All other props are passed via the ...other object making this component really flexible
        - You can see that it passes an onClick and children props
    - Spread attributes can be useful but they also make it easy to pass unnecessary props to components that don’t care about them or to pass invalid HTML attributes to the DOM
        - We recommend using this syntax sparingly

##### Specifying Attributes with JSX
 - You may use quotes to specify string literals as attributes: `const element = <div tabIndex="0"></div>;`
- You may also use curly braces to embed a JavaScript expression in an attribute: `const element = <img src={user.avatarUrl}></img>;`
- Don’t put quotes around curly braces when embedding a JavaScript expression in an attribute. You should either use quotes (for string values) or curly braces (for expressions), but not both in the same attribute
- Warning: Since JSX is closer to JavaScript than to HTML, React DOM uses camelCase property naming convention instead of HTML attribute names
    - For example, class becomes className in JSX, and tabindex becomes tabIndex.

##### Specifying Children with JSX
- In JSX expressions that contain both an opening tag and a closing tag, the content between those tags is passed as a special prop: props.children
- If a tag is empty, you may close it immediately with />, like XML: `const element = <img src={user.avatarUrl} />;`
- JSX tags may contain children:
    ```
    const element = (
      <div>
        <h1>Hello!</h1>
        <h2>Good to see you here.</h2>
      </div>
    );
    ```
- There are several different ways to pass children:
    **String Literals**
    - You can put a string between the opening and closing tags and props.children will just be that string. This is useful for many of the built-in HTML elements. For example: `<MyComponent>Hello world!</MyComponent>`
        - This is valid JSX, and props.children in MyComponent will simply be the string "Hello world!". HTML is unescaped, so you can generally write JSX just like you would write HTML in this way:
        `<div>This is valid HTML &amp; JSX at the same time.</div>`
    - JSX removes whitespace at the beginning and ending of a line
    - It also removes blank lines
    - New lines adjacent to tags are removed; new lines that occur in the middle of string literals are condensed into a single space. So these all render to the same thing:
        ```
        <div>Hello World</div>

        <div>
          Hello World
        </div>

        <div>
          Hello
          World
        </div>

        <div>

          Hello World
        </div>
        ```
- You can provide more JSX elements as the children. This is useful for displaying nested components:
    ```
    <MyContainer>
      <MyFirstComponent />
      <MySecondComponent />
    </MyContainer>
    ```
- You can mix together different types of children, so you can use string literals together with JSX children. This is another way in which JSX is like HTML, so that this is both valid JSX and valid HTML:
    ```
    <div>
      Here is a list:
      <ul>
        <li>Item 1</li>
        <li>Item 2</li>
      </ul>
    </div>
    ```
- A React component can also return an array of elements:
    ```
    render() {
      // No need to wrap list items in an extra element!
      return [
        // Don't forget the keys :)
        <li key="A">First item</li>,
        <li key="B">Second item</li>,
        <li key="C">Third item</li>,
      ];
    }
    ```
##### JavaScript Expressions as Children
- You can pass any JavaScript expression as children, by enclosing it within {}. For example, these expressions are equivalent:
    ```
    <MyComponent>foo</MyComponent>
    <MyComponent>{'foo'}</MyComponent>
    ```
    - This is often useful for rendering a list of JSX expressions of arbitrary length. For example, this renders an HTML list:
        ```
        function Item(props) {
          return <li>{props.message}</li>;
        }

        function TodoList() {
          const todos = ['finish doc', 'submit pr', 'nag dan to review'];
          return (
            <ul>
              {todos.map((message) => <Item key={message} message={message} />)}
            </ul>
          );
        }
        ```
    - JavaScript expressions can be mixed with other types of children. This is often useful in lieu of string templates:
        ```
        function Hello(props) {
          return <div>Hello {props.addressee}!</div>;
        }
        ```
##### Functions as Children
- Normally, JavaScript expressions inserted in JSX will evaluate to a string, a React element, or a list of those things
    - However, props.children works just like any other prop in that it can pass any sort of data, not just the sorts that React knows how to render
    - For example, if you have a custom component, you could have it take a callback as props.children:
        ```
        // Calls the children callback numTimes to produce a repeated component
        function Repeat(props) {
          let items = [];
          for (let i = 0; i < props.numTimes; i++) {
            items.push(props.children(i));
          }
          return <div>{items}</div>;
        }

        function ListOfTenThings() {
          return (
            <Repeat numTimes={10}>
              {(index) => <div key={index}>This is item {index} in the list</div>}
            </Repeat>
          );
        }
        ```
        - Children passed to a custom component can be anything, as long as that component transforms them into something React can understand before rendering
        - This usage is not common, but it works if you want to stretch what JSX is capable of

##### Booleans, Null, and Undefined Are Ignored
- false, null, undefined, and true are valid children. They simply don’t render. These JSX expressions will all render to the same thing:
    ```
    <div />

    <div></div>

    <div>{false}</div>

    <div>{null}</div>

    <div>{undefined}</div>

    <div>{true}</div>
    ```
    - This can be useful to conditionally render React elements. This JSX only renders a <Header /> if showHeader is true:
        ```
        <div>
          {showHeader && <Header />}
          <Content />
        </div>
        ```
    - One caveat is that some “falsy” values, such as the 0 number, are still rendered by React. For example, this code will not behave as you might expect because 0 will be printed when props.messages is an empty array:
        ```
        <div>
          {props.messages.length &&
            <MessageList messages={props.messages} />
          }
        </div>
        ```
        - To fix this, make sure that the expression before && is always boolean:
            ```
            <div>
              {props.messages.length > 0 &&
                <MessageList messages={props.messages} />
              }
            </div>
            ```
    - Conversely, if you want a value like false, true, null, or undefined to appear in the output, you have to convert it to a string first:
        ```
        <div>
          My JavaScript variable is {String(myVariable)}.
        </div>
        ```


##### JSX Prevents Injection Attacks
- By default, React DOM escapes any values embedded in JSX before rendering them
    - Thus it ensures that you can never inject anything that’s not explicitly written in your application
    - Everything is converted to a string before being rendered. This helps prevent XSS (cross-site-scripting) attacks

##### JSX Represents Objects
- Babel compiles JSX down to React.createElement() calls.
- These two examples are identical:
    ```
    const element = (
      <h1 className="greeting">
        Hello, world!
      </h1>
    );
    ```

    ```
    const element = React.createElement(
      'h1',
      {className: 'greeting'},
      'Hello, world!'
    );
    ```
    - React.createElement() performs a few checks to help you write bug-free code but essentially it creates an object like this:
        ```
        // Note: this structure is simplified
        const element = {
          type: 'h1',
          props: {
            className: 'greeting',
            children: 'Hello, world!'
          }
        };
        ```
   - These objects are called “React elements”. You can think of them as descriptions of what you want to see on the screen. React reads these objects and uses them to construct the DOM and keep it up to date

# Forms
- HTML form elements work a little bit differently from other DOM elements in React, because form elements naturally keep some internal state
    - For example, this form in plain HTML accepts a single name:
        ```
        <form>
          <label>
            Name:
            <input type="text" name="name" />
          </label>
          <input type="submit" value="Submit" />
        </form>
        ```
        - This form has the default HTML form behavior of browsing to a new page when the user submits the form
    - If you want this behavior in React, it just works. But in most cases, it’s convenient to have a JavaScript function that handles the submission of the form and has access to the data that the user entered into the form
        - The standard way to achieve this is with a technique called “controlled components”

##### Controlled Components
- in HTML, form elements such as `<input>`, `<textarea>`, and `<select>` typically maintain their own state and update it based on user input
    - In React, mutable state is typically kept in the state property of components, and only updated with setState()
- We can combine the two by making the React state be the “single source of truth”
    - Then the React component that renders a form also controls what happens in that form on subsequent user input
    - An input form element whose value is controlled by React in this way is called a “controlled component”
    - For example, if we want to make the previous example log the name when it is submitted, we can write the form as a controlled component:
        ```
        class NameForm extends React.Component {
          constructor(props) {
            super(props);
            this.state = {value: ''};

            this.handleChange = this.handleChange.bind(this);
            this.handleSubmit = this.handleSubmit.bind(this);
          }

          handleChange(event) {
            this.setState({value: event.target.value});
          }

          handleSubmit(event) {
            alert('A name was submitted: ' + this.state.value);
            event.preventDefault();
          }

          render() {
            return (
              <form onSubmit={this.handleSubmit}>
                <label>
                  Name:
                  <input type="text" value={this.state.value} onChange={this.handleChange} />
                </label>
                <input type="submit" value="Submit" />
              </form>
            );
          }
        }
        ```
        - Since the value attribute is set on our form element, the displayed value will always be this.state.value, making the React state the source of truth
        - Since handleChange runs on every keystroke to update the React state, the displayed value will update as the user types
- With a controlled component, every state mutation will have an associated handler function. This makes it straightforward to modify or validate user input
    - For example, if we wanted to enforce that names are written with all uppercase letters, we could write handleChange as:
        ```
        handleChange(event) {
          this.setState({value: event.target.value.toUpperCase()});
        }
        ```
##### The textarea Tag
- In HTML, a <textarea> element defines its text by its children:
    ```
    <textarea>
      Hello there, this is some text in a text area
    </textarea>
    ```
    - In React, a <textarea> uses a value attribute instead
        - This way, a form using a <textarea> can be written very similarly to a form that uses a single-line input:
            ```
            class EssayForm extends React.Component {
              constructor(props) {
                super(props);
                this.state = {
                  value: 'Please write an essay about your favorite DOM element.'
                };

                this.handleChange = this.handleChange.bind(this);
                this.handleSubmit = this.handleSubmit.bind(this);
              }

              handleChange(event) {
                this.setState({value: event.target.value});
              }

              handleSubmit(event) {
                alert('An essay was submitted: ' + this.state.value);
                event.preventDefault();
              }

              render() {
                return (
                  <form onSubmit={this.handleSubmit}>
                    <label>
                      Essay:
                      <textarea value={this.state.value} onChange={this.handleChange} />
                    </label>
                    <input type="submit" value="Submit" />
                  </form>
                );
              }
            }
            ```
            - Notice that this.state.value is initialized in the constructor, so that the text area starts off with some text in it

##### The select Tag
- In HTML, <select> creates a drop-down list. For example, this HTML creates a drop-down list of flavors:
    ```
    <select>
      <option value="grapefruit">Grapefruit</option>
      <option value="lime">Lime</option>
      <option selected value="coconut">Coconut</option>
      <option value="mango">Mango</option>
    </select>
    ```
    - Note that the Coconut option is initially selected, because of the selected attribute
    - React, instead of using this selected attribute, uses a value attribute on the root select tag
        - This is more convenient in a controlled component because you only need to update it in one place:
            ```
            class FlavorForm extends React.Component {
              constructor(props) {
                super(props);
                this.state = {value: 'coconut'};

                this.handleChange = this.handleChange.bind(this);
                this.handleSubmit = this.handleSubmit.bind(this);
              }

              handleChange(event) {
                this.setState({value: event.target.value});
              }

              handleSubmit(event) {
                alert('Your favorite flavor is: ' + this.state.value);
                event.preventDefault();
              }

              render() {
                return (
                  <form onSubmit={this.handleSubmit}>
                    <label>
                      Pick your favorite La Croix flavor:
                      <select value={this.state.value} onChange={this.handleChange}>
                        <option value="grapefruit">Grapefruit</option>
                        <option value="lime">Lime</option>
                        <option value="coconut">Coconut</option>
                        <option value="mango">Mango</option>
                      </select>
                    </label>
                    <input type="submit" value="Submit" />
                  </form>
                );
              }
            }
            ```
            - Overall, this makes it so that <input type="text">, <textarea>, and <select> all work very similarly - they all accept a value attribute that you can use to implement a controlled component.
            - You can pass an array into the value attribute, allowing you to select multiple options in a select tag: `<select multiple={true} value={['B', 'C']}>`

##### The file input Tag
- In HTML, an <input type="file"> lets the user choose one or more files from their device storage to be uploaded to a server or manipulated by JavaScript via the File API: `<input type="file" />`
- Because its value is read-only, it is an uncontrolled component in React
- more on this [here](https://reactjs.org/docs/uncontrolled-components.html#the-file-input-tag)

##### Handling Multiple Inputs
- When you need to handle multiple controlled input elements, you can add a name attribute to each element and let the handler function choose what to do based on the value of event.target.name
    ```
    class Reservation extends React.Component {
      constructor(props) {
        super(props);
        this.state = {
          isGoing: true,
          numberOfGuests: 2
        };

        this.handleInputChange = this.handleInputChange.bind(this);
      }

      handleInputChange(event) {
        const target = event.target;
        const value = target.type === 'checkbox' ? target.checked : target.value;
        const name = target.name;

        this.setState({
          [name]: value
        });
      }

      render() {
        return (
          <form>
            <label>
              Is going:
              <input
                name="isGoing"
                type="checkbox"
                checked={this.state.isGoing}
                onChange={this.handleInputChange} />
            </label>
            <br />
            <label>
              Number of guests:
              <input
                name="numberOfGuests"
                type="number"
                value={this.state.numberOfGuests}
                onChange={this.handleInputChange} />
            </label>
          </form>
        );
      }
    }
    ```
    - Note how we used the ES6 computed property name syntax to update the state key corresponding to the given input name:
        ```
        this.setState({
          [name]: value
        });
        ```
        - It is equivalent to this ES5 code:
        ```
        var partialState = {};
        partialState[name] = value;
        this.setState(partialState);
        ```
    - Also, since setState() [automatically merges a partial state into the current state](https://reactjs.org/docs/state-and-lifecycle.html#state-updates-are-merged), we only needed to call it with the changed parts

##### Controlled Input Null Value
- Specifying the value prop on a controlled component prevents the user from changing the input unless you desire so
- If you’ve specified a value but the input is still editable, you may have accidentally set value to undefined or null:
    ```
    ReactDOM.render(<input value="hi" />, mountNode);

    setTimeout(function() {
      ReactDOM.render(<input value={null} />, mountNode);
    }, 1000);
    ```
##### Specifying The React Element Type


#####  Alternatives to Controlled Components
- It can sometimes be tedious to use controlled components, because you need to write an event handler for every way your data can change and pipe all of the input state through a React component
    - This can become particularly annoying when you are converting a preexisting codebase to React, or integrating a React application with a non-React library
    - In these situations, you might want to check out [uncontrolled components](https://reactjs.org/docs/uncontrolled-components.html), an alternative technique for implementing input forms




# Functional Component

# Events
## React Docs
  Handling events with React elements is very similar to handling events on DOM elements. There are some syntactic differences:
  - React events are named using camelCase, rather than lowercase
  - When using React you should generally not need to call addEventListener to add listeners to a DOM element after it is created. Instead, just provide a listener when the element is initially rendered
  - you cannot return false to prevent default behavior in React
    - You must call preventDefault explicitly
    - For example, with plain HTML, to prevent the default link behavior of opening a new page, you can write:
       ```
       <a href="#" onclick="console.log('The link was clicked.'); return false">
         Click me
       </a>
       ```

       In React, this could instead be:

       ```
       function ActionLink() {
         function handleClick(e) {
           e.preventDefault();
           console.log('The link was clicked.');
         }

         return (
           <a href="#" onClick={handleClick}>
             Click me
           </a>
         );
       }
       ```
        - e is a synthetic event
        - React defines these [synthetic events](https://reactjs.org/docs/events.html) according to the W3C spec, so you don’t need to worry about cross-browser compatibility
  - With JSX you pass a function as the event handler, rather than a string:

    DOM
    ```
    <button onclick="activateLasers()">
      Activate Lasers
    </button>
    ```
    is slightly different in React:

    JSX
    ```
    <button onClick={activateLasers}>
      Activate Lasers
    </button>
    ```
- When you define a component using an ES6 class, a common pattern is for an event handler to be a method on the class
- You have to be careful about the meaning of this in JSX callbacks
    - In JavaScript, class methods are not bound by default
        - If you forget to bind this.handleClick and pass it to onClick, this will be undefined when the function is actually called
        - This is not React-specific behavior; it is a part of how functions work in JavaScript
    - Generally, if you refer to a method without () after it, such as onClick={this.handleClick}, you should bind that method
    - if calling bind annoys you, there are two ways you can get around this:

        **experimental public class fields syntax**
            - you can use class fields to correctly bind callbacks
            - This syntax is enabled by default in Create React App

            class LoggingButton extends React.Component {
              // This syntax ensures `this` is bound within handleClick.
              // Warning: this is *experimental* syntax.
              handleClick = () => {
                console.log('this is:', this);
              }

              render() {
                return (
                  <button onClick={this.handleClick}>
                    Click me
                  </button>
                );
              }
            }

        **use an arrow function in the callback**

            class LoggingButton extends React.Component {
              handleClick() {
                console.log('this is:', this);
              }

              render() {
                // This syntax ensures `this` is bound within handleClick
                return (
                  <button onClick={(e) => this.handleClick(e)}>
                    Click me
                  </button>
                );
              }
            }

        - The problem with this syntax is that a different callback is created each time the LoggingButton renders
        - In most cases, this is fine.  However, if this callback is passed as a prop to lower components, those components might do an extra re-rendering
            - We generally recommend binding in the constructor or using the class fields syntax, to avoid this sort of performance problem
 - Inside a loop it is common to want to pass an extra parameter to an event handler
    - For example, if id is the row ID, either of the following would work:
        ```
        <button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
        <button onClick={this.deleteRow.bind(this, id)}>Delete Row</button>
        ```
        - The above two lines are equivalent, and use arrow functions and Function.prototype.bind respectively
        - In both cases, the e argument representing the React event will be passed as a second argument after the ID
        - With an arrow function, we have to pass it explicitly, but with bind any further arguments are automatically forwarded
- You can use variables to store elements
    - This can help you conditionally render a part of the component while the rest of the output doesn’t change
    - Consider these two new components representing Logout and Login buttons:
        ```
        function LoginButton(props) {
          return (
            <button onClick={props.onClick}>
              Login
            </button>
          );
        }

        function LogoutButton(props) {
          return (
            <button onClick={props.onClick}>
              Logout
            </button>
          );
        }
        ```
    - In the example below, we will create a stateful component called LoginControl
    - It will render either <LoginButton /> or <LogoutButton /> depending on its current state. It will also render a <Greeting /> from the previous example:
        ```
        class LoginControl extends React.Component {
          constructor(props) {
            super(props);
            this.handleLoginClick = this.handleLoginClick.bind(this);
            this.handleLogoutClick = this.handleLogoutClick.bind(this);
            this.state = {isLoggedIn: false};
          }

          handleLoginClick() {
            this.setState({isLoggedIn: true});
          }

          handleLogoutClick() {
            this.setState({isLoggedIn: false});
          }

          render() {
            const isLoggedIn = this.state.isLoggedIn;

            const button = isLoggedIn ? (
              <LogoutButton onClick={this.handleLogoutClick} />
            ) : (
              <LoginButton onClick={this.handleLoginClick} />
            );

            return (
              <div>
                <Greeting isLoggedIn={isLoggedIn} />
                {button}
              </div>
            );
          }
        }

        ReactDOM.render(
          <LoginControl />,
          document.getElementById('root')
        );
        ```
        Me: I don't like this example because I've seen people do this.  It couples implementation to inside render where that behaviour should live outside render and in their respective components, even if it means doing that if statement twice, once in each login or logout component.  That way you can completely test stuff without any side effects and tests don't have to worry about two concerns, they can test their respective login or logout with their own set of tests.  I get that they're trying to make things cleaner with less typing and duplication by creating a <LoginControl /> but not sure I like this.  I'd much rather just put in both controls and have those controls smart and know if they should render themselves or not

## Other Docs
- look at these two blocks of code.  The first is an ES6 with an experimental public class field (the foo function). The other is plain ES5
    This:
    ```
    class Button {
        constructor() {
          this.handleClick = this.handleClick.bind(this);
        }
        handleClick() {
          console.log(this);
        }
        foo() {
          console.log("foo");
        }
        publicClassFieldFunction = function() {
         console.log(this);
        }
       }
     ```
     is the same as this:
     ```
     var Button = function() {
       this.handleClick = this.handleClick.bind(this);
       this.publicClassFieldFunction = function() {
         console.log(this);
       }
     }
     Button.prototype.handleClick = function() {
       console.log(this);  
     }
     Button.prototype.foo = function() {
         console.log("foo");
     }
     ```
     - ES6 classes are just syntactic sugar over prototypal inheritance
        - \An instance of Button will have two fields: `handleClick` and `publicClassFieldFunction`
        - If we try accessing a non-existing property in that instance, it will go up the next object in prototype chain looking for something with that name
        - That object is Button.prototype, which has the methods `handleClick` and `foo`
    - By looking at the code above you can see that, in the ES6 class syntax, declaring a property like this: `handleClick() {...` means that the function will live in the.prototype of the class, which means it will be shared by every instance
    - Declaring it like this `handleClick = function() {...` means that it will be set in the constructor and each instance will have one copy of it
    - That means that there are two different handleClick functions: the one in the constructor and the one in the prototype
- Now let focus a bit on event handling in React. The documentation suggests this:
    ```
      constructor() {
        this.handleClick = this.handleClick.bind(this);
      }
      handleClick() {
        console.log(this);
      }
      render() {
        return (
          <button onClick={this.handleClick}></button>
        );
    }
    ```
    Why is binding important?
    Answer: Because this happens:
    ```
    var obj = {
      foo: function() {
        console.log(this); 
      }
    }
    obj.foo(); // logs the 'obj' object
    var newVar = obj.foo;
    newVar() // logs the 'window' object
    ```
    - this is evaluated when the code runs.  It depends on how the function gets called
    -   If there are no dots (like in `newVar()`), this will be the `window` object
    -   In `strict` mode, it would be `undefined`
    -   Behind the scenes, React uses their event system and along the way has no way of knowing the instance of the object that should be the context
    -   *Instead of letting this be` window` or `undefined`*, *React will bind it to `null`*
    -   To make sure that this points correctly to the instances you can either use `.bind` or arrow functions
- In that case, **why not use an arrow function inside the render function**?
    - That way we could skip the .bind in the constructor:
        ```
        render() {
            return (
              <button onClick={(e) => this.handleClick(e)}>
                Click me
              </button>
            );
          }
          ```
          - Yes, arrow functions make sure that this is correctly bound to the instance and that would solve the problem
          - However, you’re passing a new inline arrow function every time render gets called
            - That means that there’s always a new reference, which might cause re-rendering
- Why not **binding inside the render function**?:
    `<button onClick={this.handleClick.bind(this)}>`
    - The `bind` method returns a new function, so we have the same problem as above

- What about public class fields?
    ```
    handleClick = () => {
        console.log('this is:', this);
    }
    ```
    - Those work well. The problem is that they’re not officially part of the ECMAScript spec yet
    - it’s important to point out that public class fields are just a different way of setting properties in the constructor
        - That is, each instance will get a copy
        - It’s still suggested in the documentation because performance implications are negligible
- if public class fields are not part of the spec and are just a different way of setting properties in the constructor, and arrow functions are officially part of the spec, why not **using them directly in the constructor instead**?
    ```
    constructor() {
        this.handleClick = () => { this.handleClick() };
    }
    ```
    - Answer: The documentation doesn’t suggest doing that, probably to avoid polluting the constructor
- But by using the recommended .bind version in the constructor we’re already polluting it:
    `this.handleClick = this.handleClick.bind(this);`
    - Also, by doing that, we’re writing more by both including a line in the constructor and declaring the function in the prototype with this bit:
    ```
    handleClick() {
        console.log(this);
    }
    ```
    - Answer: True, but there’s a subtle difference due to how the .bind method works
        - if you declare the function in the constructor or as a public class field using arrow functions, every instance of the class will have a copy of the exact same function
        - if you declare the function using the usual method syntax, it will be placed in the .prototype of the class to be shared by each instance
        - But what you’re doing with .bind, is creating a new function which wraps around the other one, giving it the instance’s context ( `this` )
            - That means that the body of the handler with the actual important logic will live in the prototype object shared by every instance
                - But each instance will have a new function that provides the context
    - Waaaaait But I thought that `this.handleClick = this.handleClick.bind(this);` was like doing something like `x = x + 1;`. Replacing a value with a new value that gets generated using the previous value. Those two this.handleClick are the same thing, right?
        - Answer: Nope
            - The first this.handleClick refers to a property that will be created in every instance, because its being set in the constructor
            - The second this.handleClick refers to an already existing property living in the prototype object of the class
            - Before that line executes, this.handleClick isn’t an actual property of the instance yet
            - If you console.log it, it will show up, but only because it will go up the prototype chain and get the one living in the prototype which gets set before instantiation (the actual handler)
            - If you do this:
                ```
                constructor() {
                    console.log(this.hasOwnProperty("handleClick"); // false
                    this.handleClick = this.handleClick.bind(this);
                    console.log(this.hasOwnProperty("handleClick"); // true
                }
                ```
                - you’ll see that the instance itself will only have it’s own handleClick property after being set with bound function that wraps the prototype’s handleClick
                - The function body that will get called by every instance is the one living in the prototype after the this.handleClick on the left calls it with the proper context
                - Those two this.handleClick functions don’t have to have the same name at all. Just try doing something like `this.handleClickFoo = this.handleClick.bind(this);` and then make sure that what is passed to onClick in the render function is the this.handleClickFoo
                    - It still works. A lot of people got confused simply because they have the same name in the documentation
                    - Try logging a bound function in the developer tools. You’ll see something like this:
                    *picture*



# Conditional Rendering
 - While declaring a variable and using an if statement is a fine way to conditionally render a component, sometimes you might want to use a shorter syntax. There are a few ways to inline conditions in JSX:

    **Inline If with Logical && Operator**
    - You may embed any expressions in JSX by wrapping them in curly braces
        - This includes the JavaScript logical && operator
        ```
        function Mailbox(props) {
          const unreadMessages = props.unreadMessages;
          return (
            <div>
              <h1>Hello!</h1>
              {unreadMessages.length > 0 &&
                <h2>
                  You have {unreadMessages.length} unread messages.
                </h2>
              }
            </div>
          );
        }

        const messages = ['React', 'Re: React', 'Re:Re: React'];
        ReactDOM.render(
          <Mailbox unreadMessages={messages} />,
          document.getElementById('root')
        );
        ```
        - It works because in JavaScript, true && expression always evaluates to expression, and false && expression always evaluates to false.
            - Therefore, if the condition is true, the element right after && will appear in the output. If it is false, React will ignore and skip it

    **Inline If-Else with Conditional Operator**
    - use the JavaScript conditional operator condition ? true : false
        ```
        render() {
          const isLoggedIn = this.state.isLoggedIn;
          return (
            <div>
              The user is <b>{isLoggedIn ? 'currently' : 'not'}</b> logged in.
            </div>
          );
        }
        ```
        - It can also be used for larger expressions although it is less obvious what’s going on:
            ```
            render() {
              const isLoggedIn = this.state.isLoggedIn;
              return (
                <div>
                  {isLoggedIn ? (
                    <LogoutButton onClick={this.handleLogoutClick} />
                  ) : (
                    <LoginButton onClick={this.handleLoginClick} />
                  )}
                </div>
              );
            }
            ```
 - Also remember that whenever conditions become too complex, it might be a good time to extract a component

 **Preventing Component from Rendering**
 - In rare cases you might want a component to hide itself even though it was rendered by another component
    - To do this return null instead of its render output
    - Returning null from a component’s render method does not affect the firing of the component’s lifecycle methods
        - For instance, componentWillUpdate and componentDidUpdate will still be called
    - In the example below, the <WarningBanner /> is rendered depending on the value of the prop called warn. If the value of the prop is false, then the component does not render:
        ```
        function WarningBanner(props) {
          if (!props.warn) {
            return null;
          }
        ```

# Lists & Keys
#### Lists
- we use the map() function to take an array of numbers and double their values
    - We assign the new array returned by map() to the variable doubled and log it:
        ```
        const numbers = [1, 2, 3, 4, 5];
        const doubled = numbers.map((number) => number * 2);
        console.log(doubled);
        ```
        - This code logs [2, 4, 6, 8, 10] to the console
        - In React, transforming arrays into lists of elements is nearly identical

    **Rendering Multiple Components**
    - You can build collections of elements and include them in JSX using curly braces {}
        ```
        const numbers = [1, 2, 3, 4, 5];
        const listItems = numbers.map((number) =>
          <li>{number}</li>
        );
        ```
        - We include the entire listItems array inside a <ul> element, and render it to the DOM:
            ```
            ReactDOM.render(
              <ul>{listItems}</ul>,
              document.getElementById('root')
            );
            ```
            - We can refactor this example into a component that accepts an array of numbers and outputs an unordered list of elements:
                ```
                function NumberList(props) {
                  const numbers = props.numbers;
                  const listItems = numbers.map((number) =>
                    <li>{number}</li>
                  );
                  return (
                    <ul>{listItems}</ul>
                  );
                }

                const numbers = [1, 2, 3, 4, 5];
                ReactDOM.render(
                  <NumberList numbers={numbers} />,
                  document.getElementById('root')
                );
                ```
    **Embedding map() in JSX**
    - JSX allows embedding any expressions in curly braces so we could inline the map() result:

        **Using a Constant to embed a list**
        ```
        function NumberList(props) {
          const numbers = props.numbers;
          const listItems = numbers.map((number) =>
            <ListItem key={number.toString()}
                      value={number} />

          );
          return (
            <ul>
              {listItems}
            </ul>
          );
        }
        ```
        **Embedding Lists** (inlining the map() instead of using a constant)
        ```
        function NumberList(props) {
          const numbers = props.numbers;
          return (
            <ul>
              {numbers.map((number) =>
                <ListItem key={number.toString()}
                          value={number} />

              )}
            </ul>
          );
        }
        ```

#### Keys
- When you run this code, you’ll be given a warning that a **key** should be provided for list items
    - A “key” is a special string attribute you need to include when creating lists of elements
    - Let’s assign a key to our list items inside numbers.map() and fix the missing key issue:
        ```
        function NumberList(props) {
          const numbers = props.numbers;
          const listItems = numbers.map((number) =>
            <li key={number.toString()}>
              {number}
            </li>
          );
          return (
            <ul>{listItems}</ul>
          );
        }
        ```
 - help React identify which items have changed, are added, or are removed
 - A good rule of thumb is that elements inside the map() call need keys
 - Keys serve as a hint to React but they don’t get passed to your components
    - If you need the same value in your component, pass it explicitly as a prop with a different name:
        ```
        const content = posts.map((post) =>
          <Post
            key={post.id}
            id={post.id}
            title={post.title} />
        );
        ```
 - Keys used within arrays should be unique among their siblings
    - However they don’t need to be globally unique
    - We can use the same keys when we produce two different arrays:
        ```
        function Blog(props) {
          const sidebar = (
            <ul>
              {props.posts.map((post) =>
                <li key={post.id}>
                  {post.title}
                </li>
              )}
            </ul>
          );
          const content = props.posts.map((post) =>
            <div key={post.id}>
              <h3>{post.title}</h3>
              <p>{post.content}</p>
            </div>
          );
          return (
            <div>
              {sidebar}
              <hr />
              {content}
            </div>
          );
        }
        ```
 - should be given to the elements inside the array to give the elements a stable identity
 - The best way to pick a key is to use a string that uniquely identifies a list item among its siblings
     - Most often you would use IDs from your data as keys
         ```
         const todoItems = todos.map((todo) =>
           <li key={todo.id}>
             {todo.text}
           </li>
         );
         ```

     - When you don’t have stable IDs for rendered items, you may use the item index as a key as a last resort
        - We don’t recommend using indexes for keys if the order of items may change
            - This can negatively impact performance and [may cause issues with component state](in-depth explanation on the negative impacts of using an index as a key)
 - If you choose not to assign an explicit key to list items then React will default to using indexes as keys

**Extracting Components with Keys**
- Keys only make sense in the context of the surrounding array
    - For example, if you extract a ListItem component, you should keep the key on the <ListItem /> elements in the array rather than on the <li> element in the ListItem itself

    **Incorrect Key Usage**
    ```
    function ListItem(props) {
      const value = props.value;
      return (
        // Wrong! There is no need to specify the key here:
        <li key={value.toString()}>
          {value}
        </li>
      );
    }

    function NumberList(props) {
      const numbers = props.numbers;
      const listItems = numbers.map((number) =>
        // Wrong! The key should have been specified here:
        <ListItem value={number} />
      );
      return (
        <ul>
          {listItems}
        </ul>
      );
    }

    const numbers = [1, 2, 3, 4, 5];
    ReactDOM.render(
      <NumberList numbers={numbers} />,
      document.getElementById('root')
    );
    ```

    **Correct Key Usage**
    ```
    function ListItem(props) {
      // Correct! There is no need to specify the key here:
      return <li>{props.value}</li>;
    }

    function NumberList(props) {
      const numbers = props.numbers;
      const listItems = numbers.map((number) =>
        // Correct! Key should be specified inside the array.
        <ListItem key={number.toString()}
                  value={number} />

      );
      return (
        <ul>
          {listItems}
        </ul>
      );
    }

    const numbers = [1, 2, 3, 4, 5];
    ReactDOM.render(
      <NumberList numbers={numbers} />,
      document.getElementById('root')
    );
    ```

# Browser Support
- React supports all popular browsers, including Internet Explorer 9 and above, although some polyfills are required for older browsers such as IE 9 and IE 10
- We don’t support older browsers that don’t support ES5 methods, but you may find that your apps do work in older browsers if polyfills such as es5-shim and es5-sham are included in the page. You’re on your own if you choose to take this path
    ```
    const listItems = numbers.map((number) =>
      <li key={number.toString()}>
        {number}
      </li>
    );
    ```
# ReactDOM
- package provides DOM-specific methods that can be used at the top level of your app and as an escape hatch to get outside of the React model if you need to. Most of your components should not need to use this module
- it provides the following DOM helpers:
    - render()
    - hydrate()
    - unmountComponentAtNode()
    - findDOMNode()
    - createPortal()
#### render()
- Render a React element into the DOM in the supplied container and return a reference to the component (or returns null for stateless components)
- If the React element was previously rendered into container, this will perform an update on it and only mutate the DOM as necessary to reflect the latest React element
- If the optional callback is provided, it will be executed after the component is rendered or updated
- ReactDOM.render() controls the contents of the container node you pass in. Any existing DOM elements inside are replaced when first called. Later calls use React’s DOM diffing algorithm for efficient updates
- ReactDOM.render() does not modify the container node (only modifies the children of the container). It may be possible to insert a component to an existing DOM node without overwriting the existing children
- ReactDOM.render() currently returns a reference to the root ReactComponent instance. However, using this return value is legacy and should be avoided because future versions of React may render components asynchronously in some cases. If you need a reference to the root ReactComponent instance, the preferred solution is to attach a callback ref to the root element
- Using ReactDOM.render() to hydrate a server-rendered container is deprecated and will be removed in React 17. Use hydrate() instead
#### hydrate()
- Same as render(), but is used to hydrate a container whose HTML contents were rendered by ReactDOMServer. React will attempt to attach event listeners to the existing markup
- React expects that the rendered content is identical between the server and the client. It can patch up differences in text content, but you should treat mismatches as bugs and fix them. In development mode, React warns about mismatches during hydration. There are no guarantees that attribute differences will be patched up in case of mismatches. This is important for performance reasons because in most apps, mismatches are rare, and so validating all markup would be prohibitively expensive.
- If a single element’s attribute or text content is unavoidably different between the server and the client (for example, a timestamp), you may silence the warning by adding suppressHydrationWarning={true} to the element. It only works one level deep, and is intended to be an escape hatch. Don’t overuse it. Unless it’s text content, React still won’t attempt to patch it up, so it may remain inconsistent until future updates.
- f you intentionally need to render something different on the server and the client, you can do a two-pass rendering. Components that render something different on the client can read a state variable like this.state.isClient, which you can set to true in componentDidMount(). This way the initial render pass will render the same content as the server, avoiding mismatches, but an additional pass will happen synchronously right after hydration. Note that this approach will make your components slower because they have to render twice, so use it with caution
#### unmountComponentAtNode()
- Remove a mounted React component from the DOM and clean up its event handlers and state. If no component was mounted in the container, calling this function does nothing. Returns true if a component was unmounted and false if there was no component to unmount
#### findDOMNode()
- If this component has been mounted into the DOM, this returns the corresponding native browser DOM element. This method is useful for reading values out of the DOM, such as form field values and performing DOM measurements. **In most cases, you can attach a ref to the DOM node and avoid using findDOMNode at all**
- When a component renders to null or false, findDOMNode returns null. When a component renders to a string, findDOMNode returns a text DOM node containing that value. As of React 16, a component may return a fragment with multiple children, in which case findDOMNode will return the DOM node corresponding to the first non-empty child.
- findDOMNode is an escape hatch used to access the underlying DOM node. In most cases, use of this escape hatch is discouraged because it pierces the component abstraction
- findDOMNode only works on mounted components (that is, components that have been placed in the DOM). If you try to call this on a component that has not been mounted yet (like calling findDOMNode() in render() on a component that has yet to be created) an exception will be thrown
- findDOMNode cannot be used on functional components
#### createPortal()
- Creates a portal. Portals provide a way to render children into a DOM node that exists outside the hierarchy of the DOM component

# Thinking in React
- React is, in our opinion, the premier way to build big, fast Web apps with JavaScript. It has scaled very well for us at Facebook and Instagram.
- One of the many great parts of React is how it makes you think about apps as you build them. In this document, we’ll walk you through the thought process of building a searchable product data table using React

##### Start With A Mock
Imagine that we already have a JSON API and a mock from our designer. The mock looks like this:
<picture here>

- Our JSON API returns some data that looks like this:
    ```
    [
      {category: "Sporting Goods", price: "$49.99", stocked: true, name: "Football"},
      {category: "Sporting Goods", price: "$9.99", stocked: true, name: "Baseball"},
      {category: "Sporting Goods", price: "$29.99", stocked: false, name: "Basketball"},
      {category: "Electronics", price: "$99.99", stocked: true, name: "iPod Touch"},
      {category: "Electronics", price: "$399.99", stocked: false, name: "iPhone 5"},
      {category: "Electronics", price: "$199.99", stocked: true, name: "Nexus 7"}
    ];
    ```
##### Step 1: Break The UI Into A Component Hierarchy
- The first thing you’ll want to do is to draw boxes around every component (and subcomponent) in the mock and give them all names
    - If you’re working with a designer, they may have already done this, so go talk to them!
    - Their Photoshop layer names may end up being the names of your React components!
- But how do you know what should be its own component?
    - Just use the same techniques for deciding if you should create a new function or object
    - One such technique is the single responsibility principle, that is, a component should ideally only do one thing
        - If it ends up growing, it should be decomposed into smaller subcomponents
- Since you’re often displaying a JSON data model to a user, you’ll find that if your model was built correctly, your UI (and therefore your component structure) will map nicely
    - That’s because UI and data models tend to adhere to the same information architecture, which means the work of separating your UI into components is often trivial
    - Just break it up into components that represent exactly one piece of your data model

    <picture here>
- You’ll see here that we have five components in our simple app. We’ve italicized the data each component represents
    1. FilterableProductTable (orange): contains the entirety of the example
    2. SearchBar (blue): receives all user input
    3. ProductTable (green): displays and filters the data collection based on user input
    4. ProductCategoryRow (turquoise): displays a heading for each category
    5. ProductRow (red): displays a row for each product

    - If you look at ProductTable, you’ll see that the table header (containing the “Name” and “Price” labels) isn’t its own component
        - This is a matter of preference, and there’s an argument to be made either way
            - For this example, we left it as part of ProductTable because it is part of rendering the data collection which is ProductTable’s responsibility
            - However, if this header grows to be complex (i.e. if we were to add affordances for sorting), it would certainly make sense to make this its own ProductTableHeader component

- Now that we’ve identified the components in our mock, let’s arrange them into a hierarchy
    - This is easy. Components that appear within another component in the mock should appear as a child in the hierarchy:
        ```
        FilterableProductTable
            SearchBar
            ProductTable
                ProductCategoryRow
                ProductRow
        ```
##### Step 2: Build A Static Version in React
- Now that you have your component hierarchy, it’s time to implement your app
    - The easiest way is to build a version that takes your data model and renders the UI but has no interactivity
    - It’s best to decouple these processes because building a static version requires a lot of typing and no thinking, and adding interactivity requires a lot of thinking and not a lot of typing. We’ll see why
- To build a static version of your app that renders your data model, you’ll want to build components that reuse other components and pass data using props. props are a way of passing data from parent to child
    - If you’re familiar with the concept of state, don’t use state at all to build this static version
    - State is reserved only for interactivity, that is, data that changes over time. Since this is a static version of the app, you don’t need it
- You can build top-down or bottom-up
    - That is, you can either start with building the components higher up in the hierarchy (i.e. starting with FilterableProductTable) or with the ones lower in it (ProductRow)
    - In simpler examples, it’s usually easier to go top-down, and on larger projects, it’s easier to go bottom-up and write tests as you build
- At the end of this step, you’ll have a library of reusable components that render your data model
    - The components will only have render() methods since this is a static version of your app
    - The component at the top of the hierarchy (FilterableProductTable) will take your data model as a prop
    - If you make a change to your underlying data model and call ReactDOM.render() again, the UI will be updated
    - It’s easy to see how your UI is updated and where to make changes since there’s nothing complicated going on
    - React’s one-way data flow (also called one-way binding) keeps everything modular and fast

    **A Brief Interlude: Props vs State**
    - There are two types of “model” data in React: props and state
    - It’s important to understand the distinction between the two; skim the official React docs if you aren’t sure what the difference is

##### Step 3: Identify The Minimal (but complete) Representation Of UI State
- To make your UI interactive, you need to be able to trigger changes to your underlying data model. React makes this easy with state
- To build your app correctly, you first need to think of the minimal set of mutable state that your app needs
    - The key here is DRY: Don’t Repeat Yourself
        - Figure out the absolute minimal representation of the state your application needs and compute everything else you need on-demand
            - For example, if you’re building a TODO list, just keep an array of the TODO items around; don’t keep a separate state variable for the count
                - Instead, when you want to render the TODO count, simply take the length of the TODO items array
- Think of all of the pieces of data in our example application. We have:
    - The original list of products
    - The search text the user has entered
    - The value of the checkbox
    - The filtered list of products
- Let’s go through each one and figure out which one is state. Simply ask three questions about each piece of data:
    1. Is it passed in from a parent via props? If so, it probably isn’t state
    2. Does it remain unchanged over time? If so, it probably isn’t state
    3. Can you compute it based on any other state or props in your component? If so, it isn’t state

    - The original list of products is passed in as props, so that’s not state
    - The search text and the checkbox seem to be state since they change over time and can’t be computed from anything
    - And finally, the filtered list of products isn’t state because it can be computed by combining the original list of products with the search text and value of the checkbox
    - So finally, our state is:
        - The search text the user has entered
        - The value of the checkbox

##### Step 4: Identify Where Your State Should Live
    See the [Pen Thinking In React: Step 4](https://codepen.io/gaearon/pen/qPrNQZ) on CodePen.
- OK, so we’ve identified what the minimal set of app state is. Next, we need to identify which component mutates, or owns, this state
- Remember: React is all about one-way data flow down the component hierarchy. It may not be immediately clear which component should own what state
    - **This is often the most challenging part for newcomers to understand**, so follow these steps to figure it out:
        - For each piece of state in your application:
            - Identify every component that renders something based on that state
            - Find a common owner component (a single component above all the components that need the state in the hierarchy)
            - Either the common owner or another component higher up in the hierarchy should own the state
            - If you can’t find a component where it makes sense to own the state, create a new component simply for holding the state and add it somewhere in the hierarchy above the common owner component
        - Let’s run through this strategy for our application:
            - ProductTable needs to filter the product list based on state and SearchBar needs to display the search text and checked state
            - The common owner component is FilterableProductTable.
            - It conceptually makes sense for the filter text and checked value to live in FilterableProductTable
        - Cool, so we’ve decided that our state lives in FilterableProductTable
            - First, add an instance property this.state = {filterText: '', inStockOnly: false} to FilterableProductTable’s constructor to reflect the initial state of your application
            - Then, pass filterText and inStockOnly to ProductTable and SearchBar as a prop
            - Finally, use these props to filter the rows in ProductTable and set the values of the form fields in SearchBar
        - You can start seeing how your application will behave: set filterText to "ball" and refresh your app. You’ll see that the data table is updated correctly

##### Step 5: Add Inverse Data Flow
- So far, we’ve built an app that renders correctly as a function of props and state flowing down the hierarchy
- Now it’s time to support data flowing the other way: the form components deep in the hierarchy need to update the state in FilterableProductTable
- React makes this data flow explicit to make it easy to understand how your program works, but it does require a little more typing than traditional two-way data binding
- If you try to type or check the box in the current version of the example, you’ll see that React ignores your input
    - This is intentional, as we’ve set the value prop of the input to always be equal to the state passed in from FilterableProductTable
- Let’s think about what we want to happen
    - We want to make sure that whenever the user changes the form, we update the state to reflect the user input
    - Since components should only update their own state, FilterableProductTable will pass callbacks to SearchBar that will fire whenever the state should be updated
    - We can use the onChange event on the inputs to be notified of it
    - The callbacks passed by FilterableProductTable will call setState(), and the app will be updated
    - Though this sounds complex, it’s really just a few lines of code. And it’s really explicit how your data is flowing throughout the app


# ES6 in React

# Bad Practices

# Good Practices

# Resources
- [React.Component](https://reactjs.org/docs/react-component.html#forceupdate)
- [State and Lifecycle
](https://reactjs.org/docs/state-and-lifecycle.html)
- [React Lifecycle Methods - how and when to use them](https://engineering.musefind.com/react-lifecycle-methods-how-and-when-to-use-them-2111a1b692b1)
- [rename-unsafe-lifecycles codemod](https://github.com/reactjs/react-codemod#rename-unsafe-lifecycles)
- [Destructuring objects as function parameters in ES6](https://simonsmith.io/destructuring-objects-as-function-parameters-in-es6)
- [Handling Events](https://reactjs.org/docs/handling-events.html)
- [Conditional Rendering](https://reactjs.org/docs/conditional-rendering.html)
- [Lists and Keys](https://reactjs.org/docs/lists-and-keys.html)
- [JSX In Depth](https://reactjs.org/docs/jsx-in-depth.html)
- [React Stateless Functional Components: Nine Wins You Might Have Overlooked](https://hackernoon.com/react-stateless-functional-components-nine-wins-you-might-have-overlooked-997b0d933dbc)
- [7 Reasons to Outlaw React’s Functional Components](https://medium.freecodecamp.org/7-reasons-to-outlaw-reacts-functional-components-ff5b5ae09b7c)
- [JavaScript: What Are Pure Functions And Why Use Them?](https://medium.com/@jamesjefferyuk/javascript-what-are-pure-functions-4d4d5392d49c)
- [React — Event handling, binding, ES6 classes and public class fields](https://medium.com/@pauloesteves8/es6-classes-binding-public-class-fields-and-event-handling-in-react-2e1e39b1d498)
- [Where to Fetch Data: componentWillMount vs componentDidMount](https://daveceddia.com/where-fetch-data-componentwillmount-vs-componentdidmount)
