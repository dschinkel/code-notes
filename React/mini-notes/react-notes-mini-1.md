> [mini notes - 2](react-notes-mini-2.md) extends this cheat sheet with more detail (deeper dive)

# Table Of Contents
- [Benefits of Using React](#benefits-of-using-react)
- [Pure Functions](#pure-functions)
- [Data Flow](#data-flow)
- [Lifecycle](#lifecycle)
- [Local State](#local-state)
- [Props](#props)
- [Inheritance](#performance)
- [JSX](#jsx)
- [Performance](#performance)
- [References](#references)


# Benefits of Using React
#### Simplicity
- beauty of React is that you **c*an split complicated UIs into tiny bite-sized, reusable, testable pieces***
    - allows you to think about, maintain, and test each piece in isolation
- ***Stateless Functional (Pure) components*** provide **many benefits**:
    - useful for presentational components that only focus on UI rather than behavior
    - they're efficient
        - Since there’s no state or lifecycle methods to worry about, the React team plans to avoid unnecessary checks and memory allocations in future releases
    - good practice is to add more functional components than classes
        - Functional components actually prevent you from having local state, thus forcing you to put state where it belongs (in a higher level container or elsewhere) or elsewhere in your app (e.g. Redux Store, or some other place)
            - they help force you to keep the component pure
    - they are less noise because they're cleaner, easier to read, easy to test, and easy to maintain (because they're simple), and transpile to less code
        - they don't require use of bind to give this context, you use the "props" param incoming to the method instead of "this.props" etc.
    - easy to test means:
        - What makes it simple is: no mocks necessary, no state manipulation to worry about, no special libraries, no state or lifecycle behavior to worry about, and no test harnesses needed
        - the tests are simple assertions: Given these values for props, I expect it to return this markup
        - the tests isolated and are fast
        - the tests are easy to maintain
        - the tests test very small pieces of behavior
    - When you use ES6 destructuring with your stateless components, the argument list clearly conveys your component’s dependencies, thus it’s easy to spot components that need attention
        - you can then either break up the component or rethink the data structures you’re passing
around
#### Flexiblility
- **lifecycle methods allow you to control what happens** when each **tiny section of your UI** *renders*, *updates*, decides whether to  *re-render,* and *disappears*

#### Efficient
- **React DOM compares the element and its children to the previous one**, and **only applies the DOM updates necessary to bring the DOM to the desired state**

# Pure Functions
#####  Rule #1: *always returns the same result if the same arguments are passed in*
- does not depend on any **state** or **data change** during a program’s execution
- It must **only depend on its input arguments**

##### Rule #2: does *not produce any observable side effects*
- such as network requests, input and output devices, or data mutation

    - Side effects include, but are not limited to:

        - Making a HTTP request
        - Mutating data
        - Printing to a screen or console
        - DOM Query/Manipulation
        - Math.random()
        - Getting the current time
- Note: Not all functions need to be, or should be, pure

##### Examples
**Pure**:
```
function priceAfterTax(productPrice) {
    return (productPrice * 0.20) + productPrice;
}
```
- It passes both rules
- It doesn’t depend on any external input
- If you run this function with the same input 100,000,000 times it **will always produce the same result**

**Impure**:

```
var tax = 20;
function calculateTax(productPrice) {
    return (productPrice * (tax/100)) + productPrice;
}
```
- depends on an external tax variable
- depends on outside variables
- It fails one of the requirements thus this function is impure

# Data Flow
- called a **“top-down”** or **“unidirectional”** data flow
- state is always owned by some specific component
    - any data or UI derived from that state can only affect components “below” them in the tree
    - imagine a component tree as a waterfall of props; each component’s state is like an additional water source that joins it at an arbitrary point but also flows down
- Neither parent nor child components can know if a certain component is stateful or stateless, and they shouldn’t care whether it is defined as a function or a class
    - This is why state is often called local or encapsulated. It is not accessible to any component other than the one that owns and sets it
- A component may choose to pass its state down as props to its child components

# Lifecycle
legacy (UNSAFE) - it still works but will be phased out when React v17 comes out

- methods (“hooks”) that allow you to
    - free up resources taken by the components when they are destroyed
    - special methods on a component class to run some code when a component mounts and unmounts

#### Constructor
- called before it is mounted

#### Mounting
These methods are called when an instance of a component is being created and inserted into the DOM:
- constructor
- static getDerivedStateFromProps
- componentWillMount (_legacy_)
- render
- componentDidMount

#### Updating
An update can be caused by changes to props or state. These methods are called when a component is being re-rendered:
- componentWillReceiveProps (_legacy_)
- static getDerivedStateFromProps (_legacy_)
- shouldComponentUpdate
- componentWillUpdate (_legacy_)
- render
- getSnapshotBeforeUpdate
- componentDidUpdate

#### Error Handling
This method is called when there is an error during rendering, in a lifecycle method, or in the constructor of any child component.
- componentDidCatch

#### Entire List
*in order of when they're called:*
- [componentWillMount](#componentwillmount-legacy) (_legacy_)
- [componentDidMount](#componentdidmount)
- [componentWillReceiveProps (nextProps)](#componentwillreceiveprops-legacy) (_legacy_)
- [shouldComponentUpdate (nextProps, nextState)](#shouldcomponentupdate)
- [componentWillUpdate](#componentwillupdate-legacy) (_legacy_)
- [getSnapshotBeforeUpdate](#getsnapshotbeforeupdate) (_v16_)
- [componentDidUpdate](#componentdidupdate)
- [componentWillUnmount](#componentwillunmount)
- [componentDidCatch](#componentdidcatch) (_v16_)

#### Called on Initial render
 *TODO: Add list *

### componentWillMount (_legacy_)
- **Can call setState**: Don’t. Use default state instead

- invoked just before mounting occurs
    - component is going to appear on the screen very shortly
    - there is no component to play with yet
    - component is in default position at this point
- called before render()
- only lifecycle hook called on server rendering

**Use Cases**
- it's a bit of a dud, you will barely use this method since your constructor and other lifecycle methods do most the work
- setup that can only be done at runtime
    - connecting to external API’s
        - e.g. if you use Firebase, you’ll need to get that set up as your app is first mounting
        - but...the key is that such configuration should be done at the highest level component of your app (the root component). That means 99% of your components should probably not use componentWillMount
- *Do **Not** Fetch Data Here*
    - An asynchronous call to fetch data will not return before the render happens. This means the component will render with empty data at least once

### componentDidMount
- invoked immediately after a component is mounted
- Your component is out there and appears on the screen (mounted), and ready to be used
    - now you can do all the fun things you couldn’t do when there was no component to play with
    - do all the setup you couldn’t do without a DOM
- initialization that requires DOM nodes should go here
Can call setState: Yes
- If you ever need to render your app on the server (SSR/isomorphic/other buzzwords), componentWillMount will actually be called twice – once on the server, and again on the client – which is probably not what you want. Putting the data loading code in componentDidMount will ensure that data is only fetched from the client

**Use Cases**
- good place to instantiate the network request to get data
- draw on a <canvas> element that you just rendered
- initialize a masonry grid layout from a collection of elements
- add event listeners
- set up subscriptions

**Examples**

### componentWillReceiveProps (_legacy_)
**Can call setState**: Yes
- Our component was doing just fine, when all of a sudden a stream of new props arrive to mess things up
    - Perhaps some data that was loaded in by a parent component’s componentDidMount finally arrived, and is being passed down
- invoked before a mounted component receives new props
- Before our component does anything with the new props, componentWillReceiveProps is called, with the next props as the argument
- we have access to both the next props (via nextProps), and our current props (via this.props)
- Here’s what you should do:
           1. check which props will change (big caveat with componentWillReceiveProps — sometimes it’s called when nothing has changed; React just wants to check in)
           1. If the props will change in a way that is significant, act on it

**Use Cases**
- acting on particular prop changes to trigger state transitions
- If you need to update the state in response to prop changes (for example, to reset it)
    - compare this.props and nextProps and perform state transitions using this.setState()

**Examples**
 *TODO: Add some examples*

###### Generic
```
componentWillReceiveProps(nextProps) {
    if (parseInt(nextProps.modelId, 10) !== parseInt(this.props.modelId, 10)) {
        this.setState({ postsLoaded: false })
        this.contentLoaded = 0
    }
}
```
###### Canvas
-  we have a canvas element
-  we’re drawing a nice circle graphic based on this.props.percent
-  whenever we receive new props, IF the percent has changed, we want to redraw the grid
    ```
    componentWillReceiveProps(nextProps) {
        if (this.props.percent !== nextProps.percent)
            this.setUpCircle(nextProps.percent)
        }
    }
    ```

### shouldComponentUpdate
**Can call setState**: No
- Now our component is getting nervous:
    - We have new props. Typical React dogma says that when a component receives new props, or new state, it should update
      - But our component is a little bit anxious and is going to ask permission first
- is invoked before rendering when new props or state are being received. Defaults to true
- default behavior is to re-render on every state change, and in the vast majority of cases you should rely on the default behavior

**Use Cases**
- controlling exactly when your component will re-render
- - use it to let React know if a component’s output is not affected by the current change in state or props
- if worried about wasted renders and other nonsense it's a great place to improve performance

**Examples**
###### Generic
```
componentWillReceiveProps(nextProps, nextState) {
    return this.props.engagement !== nextProps.engagement ||
    nextState.input !== this.state.input
}
```
###### Table With Many Fields

*TODO: Add a code example for this*
- we have a table with many many fields
- problem: when table re-renders, each field also re-renders, slowing things down
- ShouldComponentUpdate lets us say: only update if the props I care about change
    - keep in mind that it can cause major problems if you set it and forget it, because your React component will not update normally. So use with caution

### componentWillUpdate (_legacy_)
**Can call setState**: No
- Wow, what a process. Now we’ve committed to updating. “Want me to do anything before I re-render?” our component asks
- invoked just before rendering when new props or state are being received
- it’s basically the same as componentWillReceiveProps, except you are not allowed to call this.setState
- If you are using shouldComponentUpdate AND needed to do something when props change, componentWillUpdate makes sense. But it’s probably not going to give you a whole lot of additional utility

**Use Cases**
- Use this as an opportunity to perform preparation before an update occurs
- Used instead of componentWillReceiveProps on a component that also has shouldComponentUpdate (but no access to previous props)

**Examples**
*TODO: Add some examples*

### getSnapshotBeforeUpdate
- invoked immediately after a component is mounted

**Can call setState**: ?

**Use Cases**
*TODO: Add some use cases*

**Examples**
*TODO: Add some examples*

### componentDidUpdate
- invoked immediately after updating occurs

**Can call setState**: ?

**Use Cases**
- to operate on the DOM when the component has been updated
- Updating the DOM in response to prop or state changes
- a good place to do network requests as long as you compare the current props to previous props (e.g. a network request may not be necessary if the props have not changed)
- If your component implements the getSnapshotBeforeUpdate lifecycle, the value it returns will be passed as a third “snapshot” parameter to componentDidUpdate

**Examples**
###### Rearrange a Grid
- after we've [redrawn the canvas](#canvas), we want to rearrange the grid after the DOM itself updates — so we use componentDidUpdate to do so:
    ```
    componentDidUpdate () {
        this.createGrid()
    }
    ```

### componentWillUnmount
- It’s almost over
    - Your component is going to go away
    - Before it goes, it asks if you have any last-minute requests

**Can call setState**: No

**Use Cases**
- Cleaning up any leftover debris from your component
    - when it’s gone, it should be completely gone
    - clean up anything to do that solely involves the component
- cancel any outgoing network requests
- remove all event listeners associated with the component

**Examples**
 ###### Remove Event Listeners
 ```
 componentWillUnmount() {
    window.removeEventListener('resize', this.resizeListener)
 }
 ```

### componentDidCatch
- Error boundaries are React components that catch JavaScript errors anywhere in their child component tree, log those errors, and display a fallback UI instead of the component tree that crashed
    - Error boundaries catch errors during rendering, in lifecycle methods, and in constructors of the whole tree below them
- A class component becomes an error boundary if it defines this lifecycle method
- Calling setState() in it lets you capture an unhandled JavaScript error in the below tree and display a fallback UI
- Error boundaries only catch errors in the components below them in the tree
    - **An error boundary can’t catch an error within itself**

**Can call setState**: No

**Use Cases**
- Only use error boundaries for recovering from unexpected exceptions; don’t try to use them for control flow
- In an ideal world, we wouldn’t use lifecycle methods. All our rendering issues would be controlled via state and props
      - But it’s not an ideal world, and sometimes you need to exact a little more control over how and when your component is updating
      - Use these methods sparingly, and use them with care
**Examples**
 *TODO: Add some examples*

# Local State
- a feature available only to React classes
- is user-defined, and it should be a plain JavaScript object (literal)
- state is similar to props, but it is private and fully controlled by the component
- state contains data specific to this component that may change over time
- if some value isn’t used for rendering or data flow (for example, a timer ID), you don’t have to put it in the state. Such values can be defined as fields on the component instance
- enqueues changes to the component state and tells React that this component and its children need to be re-rendered with the updated state
- ***never mutate this.state directly***, as calling setState() afterwards may replace the mutation you made
    - **Treat this.state as if it were immutable**
    - **instead use this.setState()** which is used to schedule updates to a component's local state:
        ```
        // Wrong
        this.state.comment = 'Hello';
        ```
        ```
        // Correct
        this.setState({
          counter: this.state.counter++
        });
        ```
- when you call setState(), React merges the object you provide into the current state
- will always lead to a re-render unless shouldComponentUpdate() returns false
- you access state by `this.state.someProperty`
- think of setState() as a request rather than an immediate command to update the component
- you initialize state in the class constructor using an object literal:
    ```
    constructor(props) {
    super(props);
        this.state = {date: new Date()};
    }
    ```
**Use Cases**
- the primary method you use to update the user interface in response to event handlers and server responses

**Examples**

*TODO: Add example of using setState(), using this.state to access state, and other examples*

# Props
 - React uses a “top-down” or “unidirectional” data flow.  This is done by passing props to child components
    - ***Functional components***: you pass them in via a **param** called `props`
    - ***Classes***: You pass them in via the **constructor** and to **super()**
       ```
        constructor(props) {
          super(props);
          this.state = {date: new Date()};
        }
        ```
        - Class components should always call the base constructor with props
            - you should call `super(props)` before any other statement. Otherwise, this.props will be undefined in the constructor, which can lead to bugs
        - **defaultProps**
            - a property on the component class itself, to set default props for the class
                - This is used for undefined props, but not for null props:
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
- `this.props` contains the props that were defined by the caller of this component
- `this.props.children` is a special prop, typically defined by the child tags in the JSX expression rather than in the tag itself
- While `this.props` is set up by React itself and `this.state` has a special meaning, you are free to add additional fields to the class manually if you need to store something that doesn’t participate in the data flow

# Inheritance
- At Facebook, we use React in thousands of components, and we haven’t found any use cases where we would recommend creating component inheritance hierarchies
- to **reuse non-UI functionality between components**, we suggest **extracting it into a separate JavaScript module**
    - The **components** may then **import it** and use that function, object, or a class, without extending it

# JSX
- provides syntactic sugar for the React.createElement

    The JSX code:
    ```
    <MyButton color="blue" shadowSize={2}>
      Click Me
    </MyButton>
    ```
    compiles (transpiles) into:
    ```
    React.createElement(
      MyButton,
      {color: 'blue', shadowSize: 2},
      'Click Me'
    )
    ```
    - After compilation, JSX expressions become regular JavaScript function calls and evaluate to JavaScript objects
    - This means that you can use JSX inside of if statements and for loops, assign it to variables, accept it as arguments, and return it from functions
- Consider this variable declaration: `const element = <h1>Hello, world!</h1>;`
    - This tag syntax is **neither a string nor HTML**
    - It is called JSX, and it is a **syntax extension to JavaScript**
    -  JSX may remind you of a template language, but it comes with the full power of JavaScript
    - JSX produces React “elements”
- it's used with React to describe what the UI should look like
- You can embed any JavaScript expression in JSX by wrapping it in curly braces
##### Why JSX?
- React embraces the fact that rendering logic is inherently coupled with other UI logic: how events are handled, how the state changes over time, and how the data is prepared for display
- **Instead of artificially separating technologies by putting markup and logic in separate files, React separates concerns with loosely coupled units called “components”** that contain both
- allows React to show more useful error and warning messages

# Performance
**slow**: taking more than a half second to provide visual feedback

**Possible Causes**
- most of the time its when useless rerenders of many components happens that's unrelated to each other (behavior is unrelated to other parts of your component or component tree)
- While React VirtualDom is super fast, in a medium size app, a full redraw can easily render hundreds of components
    - Even the fastest VirtualDom templating engine can't make that in less than 16ms

**Possible Optimzations**

* // TODO: fill in stuff here

#### Tools
An HOC you can use to determine how many times your components are being called:
```
// in src/log.js
const log = BaseComponent => props => {
    console.log(`Rendering ${BaseComponent.name}`);
    return <BaseComponent {...props} />;
}
export default log;

// in src/MyComponent.js
import log from './log';
export default log(MyComponent);
```

# Reference
- [React is Slow, React is Fast: Optimizing React Apps in Practice](https://marmelab.com/blog/2017/02/06/react-is-slow-react-is-fast.html)