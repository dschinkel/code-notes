
# Typechecking With PropTypes
- **Note:** React.PropTypes has moved into a different package since React v15.5. Please use the [prop-types library](https://www.npmjs.com/package/prop-types) instead
    - We provide a [codemod script to automate the conversion](https://reactjs.org/blog/2017/04/07/react-v15.5.0.html#migrating-from-reactproptypes)

- As your app grows, you can catch a lot of bugs with typechecking
- For some applications, you can use JavaScript extensions like Flow or TypeScript to typecheck your whole application
- But even if you don’t use those, React has some built-in typechecking abilities
- To run typechecking on the props for a component, you can assign the special propTypes property:
    ```
    import PropTypes from 'prop-types';

    class Greeting extends React.Component {
      render() {
        return (
          <h1>Hello, {this.props.name}</h1>
        );
      }
    }

    Greeting.propTypes = {
      name: PropTypes.string
    };
    ```
    - PropTypes exports a range of validators that can be used to make sure the data you receive is valid. In this example, we’re using PropTypes.string
    - When an invalid value is provided for a prop, a warning will be shown in the JavaScript console
    - For performance reasons, propTypes is only checked in development mode

### PropTypes
- Here is an example documenting the different validators provided:
    ```
    import PropTypes from 'prop-types';

    MyComponent.propTypes = {
      // You can declare that a prop is a specific JS type. By default, these
      // are all optional.
      optionalArray: PropTypes.array,
      optionalBool: PropTypes.bool,
      optionalFunc: PropTypes.func,
      optionalNumber: PropTypes.number,
      optionalObject: PropTypes.object,
      optionalString: PropTypes.string,
      optionalSymbol: PropTypes.symbol,

      // Anything that can be rendered: numbers, strings, elements or an array
      // (or fragment) containing these types.
      optionalNode: PropTypes.node,

      // A React element.
      optionalElement: PropTypes.element,

      // You can also declare that a prop is an instance of a class. This uses
      // JS's instanceof operator.
      optionalMessage: PropTypes.instanceOf(Message),

      // You can ensure that your prop is limited to specific values by treating
      // it as an enum.
      optionalEnum: PropTypes.oneOf(['News', 'Photos']),

      // An object that could be one of many types
      optionalUnion: PropTypes.oneOfType([
        PropTypes.string,
        PropTypes.number,
        PropTypes.instanceOf(Message)
      ]),

      // An array of a certain type
      optionalArrayOf: PropTypes.arrayOf(PropTypes.number),

      // An object with property values of a certain type
      optionalObjectOf: PropTypes.objectOf(PropTypes.number),

      // An object taking on a particular shape
      optionalObjectWithShape: PropTypes.shape({
        color: PropTypes.string,
        fontSize: PropTypes.number
      }),

      // You can chain any of the above with `isRequired` to make sure a warning
      // is shown if the prop isn't provided.
      requiredFunc: PropTypes.func.isRequired,

      // A value of any data type
      requiredAny: PropTypes.any.isRequired,

      // You can also specify a custom validator. It should return an Error
      // object if the validation fails. Don't `console.warn` or throw, as this
      // won't work inside `oneOfType`.
      customProp: function(props, propName, componentName) {
        if (!/matchme/.test(props[propName])) {
          return new Error(
            'Invalid prop `' + propName + '` supplied to' +
            ' `' + componentName + '`. Validation failed.'
          );
        }
      },

      // You can also supply a custom validator to `arrayOf` and `objectOf`.
      // It should return an Error object if the validation fails. The validator
      // will be called for each key in the array or object. The first two
      // arguments of the validator are the array or object itself, and the
      // current item's key.
      customArrayProp: PropTypes.arrayOf(function(propValue, key, componentName, location, propFullName) {
        if (!/matchme/.test(propValue[key])) {
          return new Error(
            'Invalid prop `' + propFullName + '` supplied to' +
            ' `' + componentName + '`. Validation failed.'
          );
        }
      })
    };
    ```
### Requiring Single Child
- With PropTypes.element you can specify that only a single child can be passed to a component as children
    ```
    import PropTypes from 'prop-types';

    class MyComponent extends React.Component {
      render() {
        // This must be exactly one element or it will warn.
        const children = this.props.children;
        return (
          <div>
            {children}
          </div>
        );
      }
    }

    MyComponent.propTypes = {
      children: PropTypes.element.isRequired
    };
    ```
### Default Prop Values
- You can define default values for your props by assigning to the special defaultProps property:
    ```
    class Greeting extends React.Component {
      render() {
        return (
          <h1>Hello, {this.props.name}</h1>
        );
      }
    }

    // Specifies the default values for props:
    Greeting.defaultProps = {
      name: 'Stranger'
    };

    // Renders "Hello, Stranger":
    ReactDOM.render(
      <Greeting />,
      document.getElementById('example')
    );
    ```
- If you are using a Babel transform like transform-class-properties , you can also declare defaultProps as static property within a React component class
    - This syntax has not yet been finalized though and will require a compilation step to work within a browser
    - For more information, see the [class fields proposal](https://github.com/tc39/proposal-class-fields)
        ```
        class Greeting extends React.Component {
          static defaultProps = {
            name: 'stranger'
          }

          render() {
            return (
              <div>Hello, {this.props.name}</div>
            )
          }
        }
        ```
        - The defaultProps will be used to ensure that this.props.name will have a value if it was not specified by the parent component
        - The propTypes typechecking happens after defaultProps are resolved, so typechecking will also apply to the defaultProps

# Typechecking With PropTypes
- Static type checkers like Flow and TypeScript identify certain types of problems before you even run your code
- They can also improve developer workflow by adding features like auto-completion
    - For this reason, we recommend using Flow or TypeScript instead of PropTypes for larger code bases

### Flow
- [Flow](https://flow.org/) is a static type checker for your JavaScript code
- It is developed at Facebook and is often used with React
- It lets you annotate the variables, functions, and React components with a special type syntax, and catch mistakes early
- To use Flow, you need to:
    - Add Flow to your project as a dependency
    - Ensure that Flow syntax is stripped from the compiled code
    - Add type annotations and run Flow to check them

### Adding Flow to a Project
- First, navigate to your project directory in the terminal. You will need to run the following command to install the latest version of Flow into your project:
    - If you use Yarn, run: `yarn add --dev flow-bin`
    - If you use npm, run: `npm install --save-dev flow-bin`
- Now, add flow to the "scripts" section of your package.json to be able to use this from the terminal:
    ```
    {
      // ...
      "scripts": {
        "flow": "flow",
        // ...
      },
      // ...
    }
    ```
- Finally, run one of the following commands:
    - If you use Yarn, run: `yarn run flow init`
    - If you use npm, run: `npm run flow init`
    - This command will create a Flow configuration file that you will need to commit.

### Stripping Flow Syntax from the Compiled Code
- Flow extends the JavaScript language with a special syntax for type annotations
    - However, browsers aren’t aware of this syntax, so we need to make sure it doesn’t end up in the compiled JavaScript bundle that is sent to the browser
    - The exact way to do this depends on the tools you use to compile JavaScript.

    ##### Create React App
    - If your project was set up using Create React App, congratulations! The Flow annotations are already being stripped by default so you don’t need to do anything else in this step.
    ##### Babel
    - **Note:** These instructions are not for Create React App users. Even though Create React App uses Babel under the hood, it is already configured to understand Flow. Only follow this step if you don’t use Create React App

    ##### Babel
    - If you manually configured Babel for your project, you will need to install a special preset for Flow
        - If you use Yarn, run: `yarn add --dev babel-preset-flow`
        - If you use npm, run: `npm install --save-dev babel-preset-flow`
    - Then add the flow preset to your Babel configuration. For example, if you configure Babel through .babelrc file, it could look like this:
        ```
        {
          "presets": [
            "flow",
            "react"
          ]
        }
        ```
        - This will let you use the Flow syntax in your code.
        - **Note:** Flow does not require the react preset, but they are often used together. Flow itself understands JSX syntax out of the box

    ##### Other Build Setups
    - If you don’t use either Create React App or Babel, you can use flow-remove-types to strip the type annotations

### Running Flow
- If you followed the instructions above, you should be able to run Flow for the first time
    - `yarn flow`
    - If you use npm, run: `npm run flow`
- You should see a message like:
    ```
    No errors!
    ✨  Done in 0.17s.
    ```

### Adding Flow Type Annotations
- By default, Flow only checks the files that include this annotation: `// @flow`
- Typically it is placed at the top of a file
    - Try adding it to some files in your project and run yarn flow or npm run flow to see if Flow already found any issues
- There is also an option to force Flow to check all files regardless of the annotation
    - This can be too noisy for existing projects, but is reasonable for a new project if you want to fully type it with Flow
- Now you’re all set! We recommend to check out the following resources to learn more about Flow:
    - [Flow Documentation: Type Annotations](https://flow.org/en/docs/types/)
    - [Flow Documentation: Editors](https://flow.org/en/docs/editors/)
    - [Flow Documentation: React](https://flow.org/en/docs/react/)
    - [Linting in Flow](https://medium.com/flow-type/linting-in-flow-7709d7a7e969)

### TypeScript
- TypeScript is a programming language developed by Microsoft.
- It is a typed superset of JavaScript, and  includes its own compiler
- Being a typed language, Typescript can catch errors and bugs at build time, long before your app goes live
- You can learn more about using TypeScript with React [here](https://github.com/Microsoft/TypeScript-React-Starter#typescript-react-starter)
- To use TypeScript, you need to:
    - Add Typescript as a dependency to your project
    - Configure the TypeScript compiler options
    - Use the right file extensions
    - Add definitions for libraries you use

##### Adding TypeScript to a Project
- Install the latest version of TypeScript into your project
    - If you use Yarn, run: `yarn add --dev typescript`
    - If you use npm, run: `npm install --save-dev typescript`
    - Installing TypeScript gives us access to the tsc command
- Before configuration, let’s add tsc to the “scripts” section in our package.json:
    ```
    {
      // ...
      "scripts": {
        "build": "tsc",
        // ...
      },
      // ...
    }
    ```

##### Configuring the TypeScript Compiler
- The compiler is of no help to us until we tell it what to do. In TypeScript, these rules are defined in a special file called tsconfig.json
    - To generate this file run: `tsc --init`
    - Looking at the now generated tsconfig.json, you can see that there are many options you can use to configure the compiler
        - For a detailed description of all the options, check [here](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)
- Of the many options, we’ll look at rootDir and outDir
    - In its true fashion, the compiler will take in typescript files and generate javascript files
        - However we don’t want to get confused with our source files and the generated output
    - We’ll address this in two steps:
        - First, let’s arrange our project structure like this. We’ll place all our source code in the src directory:
            ```
            ├── package.json
            ├── src
            │   └── index.ts
            └── tsconfig.json
            ```
        - Next, we’ll tell the compiler where our source code is and where the output should go
            ```
            // tsconfig.json

            {
              "compilerOptions": {
                // ...
                "rootDir": "src",
                "outDir": "build"
                // ...
              },
            }
            ```
        - Now when we run our build script the compiler will output the generated javascript to the build folder
        - The [TypeScript React Starter](https://github.com/Microsoft/TypeScript-React-Starter/blob/master/tsconfig.json) provides a tsconfig.json with a good set of rules to get you started
        - Generally, you don’t want to keep the generated javascript in your source control, so be sure to add the build folder to your .gitignore

##### File extensions
- In React, you most likely write your components in a .js file. In TypeScript we have 2 file extensions:
    - .ts is the default file extension
    - .tsx is a special extension used for files which contain JSX.

##### Running TypeScript
- If you followed the instructions above, you should be able to run TypeScript for the first time
    - `yarn build`
    - If you use npm, run: `npm run build`
    - If you see no output, it means that it completed successfully.

##### Type Definitions
- To be able to show errors and hints from other packages, the compiler relies on declaration files
    - A declaration file provides all the type information about a library
    - This enables us to use javascript libraries like those on npm in our project
- There are two main ways to get declarations for a library:
    - **Bundled** - The library bundles its own declaration file. This is great for us, since all we need to do is install the library, and we can use it right away. To check if a library has bundled types, look for an index.d.ts file in the project. Some libraries will have it specified in their package.json under the typings or types field
    - **DefinitelyTyped** - DefinitelyTyped is a huge repository of declarations for libraries that don’t bundle a declaration file. The declarations are crowd-sourced and managed by Microsoft and open source contributors. React for example doesn’t bundle its own declaration file. Instead we can get it from DefinitelyTyped. To do so enter this command in your terminal
        ```
        # yarn
        yarn add --dev @types/react

        # npm
        npm i --save-dev @types/react
        ```

    - **Local Declarations** Sometimes the package that you want to use doesn’t bundle declarations nor is it available on DefinitelyTyped. In that case, we can have a local declaration file. To do this, create a declarations.d.ts file in the root of your source directory. A simple declaration could look like this:
        ```
        declare module 'querystring' {
          export function stringify(val: object): string
          export function parse(val: string): object
        }
        ```

##### Using TypeScript with Create React App
- [react-scripts-ts[(https://www.npmjs.com/package/react-scripts-ts) automatically configures a create-react-app project to support TypeScript. You can use it like this:
    - `create-react-app my-app --scripts-version=react-scripts-ts`
        - Note that it is a third party project, and is not a part of Create React App
- You can also try [typescript-react-starter](https://github.com/Microsoft/TypeScript-React-Starter#typescript-react-starter)
- You are now ready to code! We recommend to check out the following resources to learn more about Typescript:
    - [TypeScript Documentation: Basic Types](TypeScript Documentation: Basic Types)
    - [TypeScript Documentation: Migrating from Javascript](http://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html)
    - [TypeScript Documentation: React and Webpack](http://www.typescriptlang.org/docs/handbook/react-&-webpack.html)

### Reason
- [Reason](https://reasonml.github.io/) is not a new language; it’s a new syntax and toolchain powered by the battle-tested language, [OCaml](http://ocaml.org/)
- Reason gives OCaml a familiar syntax geared toward JavaScript programmers, and caters to the existing NPM/Yarn workflow folks already know
- Reason is developed at Facebook, and is used in some of its products like Messenger
- It is still somewhat experimental but it has [dedicated React bindings](https://reasonml.github.io/reason-react/) maintained by Facebook and a [vibrant community](https://reasonml.github.io/docs/en/community.html)

### Kotlin
- [Kotlin](https://kotlinlang.org) is a statically typed language developed by JetBrains
- Its target platforms include the JVM, Android, LLVM, and JavaScript
- JetBrains develops and maintains several tools specifically for the React community:
    - [React bindings](https://github.com/JetBrains/kotlin-wrappers)
    - [Create React Kotlin App](https://github.com/JetBrains/create-react-kotlin-app)

### Other Languages
- Note there are other statically typed languages that compile to JavaScript and are thus React compatible
    - For example, [F#/Fable](http://fable.io/) with [elmish-react](https://fable-elmish.github.io/react)

# Refs and the DOM
- Refs provide a way to access DOM nodes or React elements created in the render method
- In the typical React dataflow, props are the only way that parent components interact with their children
    - To modify a child, you re-render it with new props
    - However, there are a few cases where you need to imperatively modify a child outside of the typical dataflow
    - The child to be modified could be an instance of a React component, or it could be a DOM element
    - For both of these cases, React provides an escape hatch

### When to Use Refs
- There are a few good use cases for refs:
    - Managing focus, text selection, or media playback
    - Triggering imperative animations
    - Integrating with third-party DOM libraries
- Avoid using refs for anything that can be done declaratively
    - For example, instead of exposing open() and close() methods on a Dialog component, pass an isOpen prop to it

### Don’t Overuse Refs
- Your first inclination may be to use refs to “make things happen” in your app
    - If this is the case, take a moment and think more critically about where state should be owned in the component hierarchy
    - Often, it becomes clear that the proper place to “own” that state is at a higher level in the hierarchy
        - See the [Lifting State Up](https://reactjs.org/docs/lifting-state-up.html) guide for examples of this
- **Note:** The examples below have been updated to use the React.createRef() API introduced in React 16.3. If you are using an earlier release of React, we recommend using callback refs instead

### Creating Refs
- Refs are created using React.createRef() and attached to React elements via the ref attribute
- Refs are commonly assigned to an instance property when a component is constructed so they can be referenced throughout the component
    ```
    class MyComponent extends React.Component {
      constructor(props) {
        super(props);
        this.myRef = React.createRef();
      }
      render() {
        return <div ref={this.myRef} />;
      }
    }
    ```
### Accessing Refs
- When a ref is passed to an element in render, a reference to the node becomes accessible at the current attribute of the ref
    `const node = this.myRef.current;`
- The value of the ref differs depending on the type of the node:
    - When the ref attribute is used on an HTML element, the ref created in the constructor with React.createRef() receives the underlying DOM element as its current property.
    - When the ref attribute is used on a custom class component, the ref object receives the mounted instance of the component as its current.
    - **You may not use the ref attribute on functional components** because they don’t have instances
    - The examples below demonstrate the differences

    #### Adding a Ref to a DOM Element
        - This code uses a ref to store a reference to a DOM node:
            ```
            class CustomTextInput extends React.Component {
              constructor(props) {
                super(props);
                // create a ref to store the textInput DOM element
                this.textInput = React.createRef();
                this.focusTextInput = this.focusTextInput.bind(this);
              }

              focusTextInput() {
                // Explicitly focus the text input using the raw DOM API
                // Note: we're accessing "current" to get the DOM node
                this.textInput.current.focus();
              }

              render() {
                // tell React that we want to associate the <input> ref
                // with the `textInput` that we created in the constructor
                return (
                  <div>
                    <input
                      type="text"
                      ref={this.textInput} />

                    <input
                      type="button"
                      value="Focus the text input"
                      onClick={this.focusTextInput}
                    />
                  </div>
                );
              }
            }
            ```
            - React will assign the current property with the DOM element when the component mounts, and assign it back to null when it unmounts
            - ref updates happen before componentDidMount or componentDidUpdate lifecycle hooks
    #### Adding a Ref to a Class Component
        - If we wanted to wrap the CustomTextInput above to simulate it being clicked immediately after mounting, we could use a ref to get access to the custom input and call its focusTextInput method manually:
            ```
            class AutoFocusTextInput extends React.Component {
              constructor(props) {
                super(props);
                this.textInput = React.createRef();
              }

              componentDidMount() {
                this.textInput.current.focusTextInput();
              }

              render() {
                return (
                  <CustomTextInput ref={this.textInput} />
                );
              }
            }
            ```
            - Note that this only works if CustomTextInput is declared as a class:
                ```
                class CustomTextInput extends React.Component {
                  // ...
                }
                ```
    #### Refs and Functional Components
        - **You may not use the ref attribute on functional components** because they don’t have instances:
            ```
            function MyFunctionalComponent() {
              return <input />;
            }

            class Parent extends React.Component {
              constructor(props) {
                super(props);
                this.textInput = React.createRef();
              }
              render() {
                // This will *not* work!
                return (
                  <MyFunctionalComponent ref={this.textInput} />
                );
              }
            }
            ```
### Exposing DOM Refs to Parent Components
- In rare cases, you might want to have access to a child’s DOM node from a parent component
    - This is generally not recommended because it breaks component encapsulation, but it can occasionally be useful for triggering focus or measuring the size or position of a child DOM node
- While you could add a ref to the child component, this is not an ideal solution, as you would only get a component instance rather than a DOM node
    - Additionally, this wouldn’t work with functional components
- If you use React 16.3 or higher, we recommend to use ref forwarding for these cases
    - **Ref forwarding lets components opt into exposing any child component’s ref as their own**
    - You can find a detailed example of how to expose a child’s DOM node to a parent component [in the ref forwarding documentation](https://reactjs.org/docs/forwarding-refs.html#forwarding-refs-to-dom-components)
- If you use React 16.2 or lower, or if you need more flexibility than provided by ref forwarding, you can use [this alternative approach](https://gist.github.com/gaearon/1a018a023347fe1c2476073330cc5509) and explicitly pass a ref as a differently named prop
- When possible, we advise against exposing DOM nodes, but it can be a useful escape hatch
    - Note that this approach requires you to add some code to the child component
    - If you have absolutely no control over the child component implementation, your last option is to use findDOMNode(), but it is discouraged

### Callback Refs
- React also supports another way to set refs called “callback refs”, which gives more fine-grain control over when refs are set and unset
- Instead of passing a ref attribute created by createRef(), you pass a function
    - The function receives the React component instance or HTML DOM element as its argument, which can be stored and accessed elsewhere
- The example below implements a common pattern: using the ref callback to store a reference to a DOM node in an instance property:
    ```
    class CustomTextInput extends React.Component {
      constructor(props) {
        super(props);

        this.textInput = null;

        this.setTextInputRef = element => {
          this.textInput = element;
        };

        this.focusTextInput = () => {
          // Focus the text input using the raw DOM API
          if (this.textInput) this.textInput.focus();
        };
      }

      componentDidMount() {
        // autofocus the input on mount
        this.focusTextInput();
      }

      render() {
        // Use the `ref` callback to store a reference to the text input DOM
        // element in an instance field (for example, this.textInput).
        return (
          <div>
            <input
              type="text"
              ref={this.setTextInputRef}
            />
            <input
              type="button"
              value="Focus the text input"
              onClick={this.focusTextInput}
            />
          </div>
        );
      }
    }
    ```
    - React will call the ref callback with the DOM element when the component mounts, and call it with null when it unmounts
    - ref callbacks are invoked before componentDidMount or componentDidUpdate lifecycle hooks
    - You can pass callback refs between components like you can with object refs that were created with React.createRef():
        ```
        function CustomTextInput(props) {
          return (
            <div>
              <input ref={props.inputRef} />
            </div>
          );
        }

        class Parent extends React.Component {
          render() {
            return (
              <CustomTextInput
                inputRef={el => this.inputElement = el}
              />
            );
          }
        }
        ```
        - In the example above, Parent passes its ref callback as an inputRef prop to the CustomTextInput, and the CustomTextInput passes the same function as a special ref attribute to the <input>
        - As a result, this.inputElement in Parent will be set to the DOM node corresponding to the <input> element in the CustomTextInput

### Legacy API: String Refs
- If you worked with React before, you might be familiar with an older API where the ref attribute is a string, like "textInput", and the DOM node is accessed as this.refs.textInput
- We advise against it because string refs have some issues, are considered legacy, and are **likely to be removed in one of the future releases**
- **Note:** If you’re currently using this.refs.textInput to access refs, we recommend using either the callback pattern or the createRef API instead

### Caveats with callback refs
- If the ref callback is defined as an inline function, it will get called twice during updates, first with null and then again with the DOM element
    - This is because a new instance of the function is created with each render, so React needs to clear the old ref and set up the new one. You can avoid this by defining the ref callback as a bound method on the class, but note that it shouldn’t matter in most cases

# Forwarding Refs
- Ref forwarding is a technique for automatically passing a ref through a component to one of its children
    - This is typically not necessary for most components in the application
    - However, it can be useful for some kinds of components, especially in reusable component libraries
    - The most common scenarios are described below
### Forwarding refs to DOM components
- Consider a FancyButton component that renders the native button DOM element:
    ```
    function FancyButton(props) {
      return (
        <button className="FancyButton">
          {props.children}
        </button>
      );
    }
    ```
    - React components hide their implementation details, including their rendered output
    - Other components using FancyButton **usually will not need to** obtain a ref to the inner button DOM element
        - This is good because it prevents components from relying on each other’s DOM structure too much
    - Although such encapsulation is desirable for application-level components like FeedStory or Comment, it can be inconvenient for highly reusable “leaf” components like FancyButton or MyTextInput
        - These components tend to be used throughout the application in a similar manner as a regular DOM button and input, and accessing their DOM nodes may be unavoidable for managing focus, selection, or animations
- Ref forwarding is an opt-in feature that lets some components take a ref they receive, and pass it further down (in other words, “forward” it) to a child.
    - In the example below, FancyButton uses React.forwardRef to obtain the ref passed to it, and then forward it to the DOM button that it renders:
    ```
    const FancyButton = React.forwardRef((props, ref) => (
      <button ref={ref} className="FancyButton">
        {props.children}
      </button>
    ));

    // You can now get a ref directly to the DOM button:
    const ref = React.createRef();
    <FancyButton ref={ref}>Click me!</FancyButton>;
    ```
    - This way, components using FancyButton can get a ref to the underlying button DOM node and access it if necessary—just like if they used a DOM button directly
    - Here is a step-by-step explanation of what happens in the above example:
      - We create a React ref by calling React.createRef and assign it to a ref variable.
      - We pass our ref down to `<FancyButton ref={ref}>` by specifying it as a JSX attribute.
      - React passes the ref to the (props, ref) => ... function inside forwardRef as a second argument.
      - We forward this ref argument down to `<button ref={ref}>` by specifying it as a JSX attribute.
      - When the ref is attached, ref.current will point to the `<button>` DOM node.
- **Note:**
    - The second ref argument only exists when you define a component with React.forwardRef call. Regular functional or class components don’t receive the ref argument, and ref is not available in props either
    - Ref forwarding is not limited to DOM components. You can forward refs to class component instances, too
### Forwarding refs in higher-order components
- This technique can also be particularly useful with higher-order components (also known as HOCs)
    - Let’s start with an example HOC that logs component props to the console:
        ```
        function logProps(WrappedComponent) {
          class LogProps extends React.Component {
            componentDidUpdate(prevProps) {
              console.log('old props:', prevProps);
              console.log('new props:', this.props);
            }

            render() {
              return <WrappedComponent {...this.props} />;
            }
          }

          return LogProps;
        }
        ```
        - The “logProps” HOC passes all props through to the component it wraps, so the rendered output will be the same
            - For example, we can use this HOC to log all props that get passed to our “fancy button” component:
                ```
                class FancyButton extends React.Component {
                  focus() {
                    // ...
                  }

                  // ...
                }

                // Rather than exporting FancyButton, we export LogProps.
                // It will render a FancyButton though.
                export default logProps(FancyButton);
                ```
            - There is one caveat to the above example: refs will not get passed through
                - That’s because ref is not a prop. Like key, it’s handled differently by React
                - If you add a ref to a HOC, the ref will refer to the outermost container component, not the wrapped component
                - This means that refs intended for our FancyButton component will actually be attached to the LogProps component:
                    ```
                    import FancyButton from './FancyButton';

                    const ref = React.createRef();

                    // The FancyButton component we imported is the LogProps HOC.
                    // Even though the rendered output will be the same,
                    // Our ref will point to LogProps instead of the inner FancyButton component!
                    // This means we can't call e.g. ref.current.focus()
                    <FancyButton
                      label="Click Me"
                      handleClick={handleClick}
                      ref={ref}
                    />;
                    ```
                - Fortunately, we can explicitly forward refs to the inner FancyButton component using the React.forwardRef API. React.forwardRef accepts a render function that receives props and ref parameters and returns a React node. For example:
                    ```
                    function logProps(Component) {
                      class LogProps extends React.Component {
                        componentDidUpdate(prevProps) {
                          console.log('old props:', prevProps);
                          console.log('new props:', this.props);
                        }

                        render() {
                          const {forwardedRef, ...rest} = this.props;

                          // Assign the custom prop "forwardedRef" as a ref
                          return <Component ref={forwardedRef} {...rest} />;
                        }
                      }

                      // Note the second param "ref" provided by React.forwardRef.
                      // We can pass it along to LogProps as a regular prop, e.g. "forwardedRef"
                      // And it can then be attached to the Component.
                      return React.forwardRef((props, ref) => {
                        return <LogProps {...props} forwardedRef={ref} />;
                      });
                    }
                    ```
### Displaying a custom name in DevTools
- React.forwardRef accepts a render function. React DevTools uses this function to determine what to display for the ref forwarding component
    - For example, the following component will appear as ”ForwardRef” in the DevTools:
        ```
        const WrappedComponent = React.forwardRef((props, ref) => {
          return <LogProps {...props} forwardedRef={ref} />;
        });
        ```
    - If you name the render function, DevTools will also include its name (e.g. ”ForwardRef(myFunction)”):
        ```
        const WrappedComponent = React.forwardRef(
          function myFunction(props, ref) {
            return <LogProps {...props} forwardedRef={ref} />;
          }
        );
        ```
    - You can even set the function’s displayName property to include the component you’re wrapping:
        ```
        function logProps(Component) {
          class LogProps extends React.Component {
            // ...
          }

          function forwardRef(props, ref) {
            return <LogProps {...props} forwardedRef={ref} />;
          }

          // Give this component a more helpful display name in DevTools.
          // e.g. "ForwardRef(logProps(MyComponent))"
          const name = Component.displayName || Component.name;
          forwardRef.displayName = `logProps(${name})`;

          return React.forwardRef(forwardRef);
        }
        ```

# Uncontrolled Components
- In most cases, we recommend using [controlled components](https://reactjs.org/docs/forms.html) to implement forms
    - In a controlled component, form data is handled by a React component
    - The alternative is uncontrolled components, where form data is handled by the DOM itself
- To write an uncontrolled component, instead of writing an event handler for every state update, you can use a ref to get form values from the DOM
    - For example, this code accepts a single name in an uncontrolled component:
    ```
    class NameForm extends React.Component {
      constructor(props) {
        super(props);
        this.handleSubmit = this.handleSubmit.bind(this);
      }

      handleSubmit(event) {
        alert('A name was submitted: ' + this.input.value);
        event.preventDefault();
      }

      render() {
        return (
          <form onSubmit={this.handleSubmit}>
            <label>
              Name:
              <input type="text" ref={(input) => this.input = input} />
            </label>
            <input type="submit" value="Submit" />
          </form>
        );
      }
      ```
      - Since an uncontrolled component keeps the source of truth in the DOM, it is sometimes easier to integrate React and non-React code when using uncontrolled components
      - It can also be slightly less code if you want to be quick and dirty. Otherwise, you should usually use controlled components
      - If it’s still not clear which type of component you should use for a particular situation, you might find [this article on controlled versus uncontrolled inputs](http://goshakkk.name/controlled-vs-uncontrolled-inputs-react/) to be helpful

### Default Values
- In the React rendering lifecycle, the value attribute on form elements will override the value in the DOM
- With an uncontrolled component, you often want React to specify the initial value, but leave subsequent updates uncontrolled
    - To handle this case, you can specify a defaultValue attribute instead of value:
        ```
        render() {
          return (
            <form onSubmit={this.handleSubmit}>
              <label>
                Name:
                <input
                  defaultValue="Bob"
                  type="text"
                  ref={(input) => this.input = input} />
              </label>
              <input type="submit" value="Submit" />
            </form>
          );
        }
        ```
        - Likewise, `<input type="checkbox">` and `<input type="radio">` support defaultChecked, and `<select>` and `<textarea>` supports defaultValue

### The file input Tag
- In HTML, an <input type="file"> lets the user choose one or more files from their device storage to be uploaded to a server or manipulated by JavaScript via the [File API](https://developer.mozilla.org/en-US/docs/Web/API/File/Using_files_from_web_applications)
    `<input type="file" />`
- In React, an <input type="file" /> is always an uncontrolled component because its value can only be set by a user, and not programmatically
- You should use the File API to interact with the files. The following example shows how to create a ref to the DOM node to access file(s) in a submit handler:
    ```
    class FileInput extends React.Component {
      constructor(props) {
        super(props);
        this.handleSubmit = this.handleSubmit.bind(this);
      }
      handleSubmit(event) {
        event.preventDefault();
        alert(
          `Selected file - ${this.fileInput.files[0].name}`
        );
      }

      render() {
        return (
          <form onSubmit={this.handleSubmit}>
            <label>
              Upload file:
              <input
                type="file"
                ref={input => {
                  this.fileInput = input;
                }}
              />
            </label>
            <br />
            <button type="submit">Submit</button>
          </form>
        );
      }
    }

    ReactDOM.render(
      <FileInput />,
      document.getElementById('root')
    );
    ```

# Optimizing Performance
- Internally, React uses several clever techniques to minimize the number of costly DOM operations required to update the UI
- For many applications, using React will lead to a fast user interface without doing much work to specifically optimize for performance
    - Nevertheless, there are several ways you can speed up your React application

### Use the Production Build
- If you’re benchmarking or experiencing performance problems in your React apps, make sure you’re testing with the minified production build
- By default, React includes many helpful warnings
    - These warnings are very useful in development
    - However, they make React larger and slower so you should make sure to use the production version when you deploy the app
- If you aren’t sure whether your build process is set up correctly, you can check it by installing [React Developer Tools for Chrome](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)
    - If you visit a site with React in production mode, the icon will have a dark background:
        _<picutre here>_
    - If you visit a site with React in development mode, the icon will have a red background
        _<picutre here>_
- It is expected that you use the development mode when working on your app, and the production mode when deploying your app to the users
- You can find instructions for building your app for production below

### Create React App
- If your project is built with Create React App, run: `npm run build`
    - This will create a production build of your app in the build/ folder of your project
    - Remember that this is only necessary before deploying to production. For normal development, use npm start

### Single-File Builds
- We offer production-ready versions of React and React DOM as single files:
    ```
    <script src="https://unpkg.com/react@16/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@16/umd/react-dom.production.min.js"></script>
    ```
- Remember that only React files ending with .production.min.js are suitable for production

### Brunch
- For the most efficient Brunch production build, install the uglify-js-brunch plugin:
    ```
    # If you use npm
    npm install --save-dev uglify-js-brunch

    # If you use Yarn
    yarn add --dev uglify-js-brunch
    ```
- Then, to create a production build, add the -p flag to the build command: `brunch build -p`
    - Remember that you only need to do this for production builds. You shouldn’t pass the -p flag or apply this plugin in development, because it will hide useful React warnings and make the builds much slower

### Browserify
- For the most efficient Browserify production build, install a few plugins:
    ```
    # If you use npm
    npm install --save-dev envify uglify-js uglifyify

    # If you use Yarn
    yarn add --dev envify uglify-js uglifyify
    ```
- To create a production build, make sure that you add these transforms **(the order matters)**:
    - The envify transform ensures the right build environment is set. Make it global (-g)
    - The uglifyify transform removes development imports. Make it global too (-g)
    - Finally, the resulting bundle is piped to uglify-js for mangling (read why)
    For example:
        ```
        browserify ./index.js \
          -g [ envify --NODE_ENV production ] \
          -g uglifyify \
          | uglifyjs --compress --mangle > ./bundle.js
        ```
    - **Note:** The package name is uglify-js, but the binary it provides is called uglifyjs. This is not a typo
- Remember that you only need to do this for production builds
    - You shouldn’t apply these plugins in development because they will hide useful React warnings, and make the builds much slower

### Rollup
    - For the most efficient Rollup production build, install a few plugins:
        ```
        # If you use npm
        npm install --save-dev rollup-plugin-commonjs rollup-plugin-replace rollup-plugin-uglify

        # If you use Yarn
        yarn add --dev rollup-plugin-commonjs rollup-plugin-replace rollup-plugin-uglify
        ```
- To create a production build, make sure that you add these plugins (the order matters):
      - The replace plugin ensures the right build environment is set
      - The commonjs plugin provides support for CommonJS in Rollup
      - The uglify plugin compresses and mangles the final bundle
    ```
    plugins: [
      // ...
      require('rollup-plugin-replace')({
        'process.env.NODE_ENV': JSON.stringify('production')
      }),
      require('rollup-plugin-commonjs')(),
      require('rollup-plugin-uglify')(),
      // ...
    ]
    ```
    - For a complete setup example see this [gist](https://gist.github.com/Rich-Harris/cb14f4bc0670c47d00d191565be36bf0)
- Remember that you only need to do this for production builds
    - You shouldn’t apply the uglify plugin or the replace plugin with 'production' value in development because they will hide useful React warnings, and make the builds much slower

### webpack
- **Note:** If you’re using Create React App, please follow [the instructions above](the instructions above). This section is only relevant if you configure webpack directly
- For the most efficient webpack production build, make sure to include these plugins in your production configuration:
    ```
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('production')
    }),
    new webpack.optimize.UglifyJsPlugin()
    ```
    - You can learn more about this in [webpack documentation](https://webpack.js.org/guides/production-build/)
- Remember that you only need to do this for production builds
    - You shouldn’t apply UglifyJsPlugin or DefinePlugin with 'production' value in development because they will hide useful React warnings, and make the builds much slower

### Profiling Components with the Chrome Performance Tab
- In the development mode, you can visualize how components mount, update, and unmount, using the performance tools in supported browsers. For example:
    _<picture>_

    To do this in Chrome:

    - Temporarily disable all Chrome extensions, especially React DevTools. They can significantly skew the results!
    - Make sure you’re running the application in the development mode
    - Open the Chrome DevTools Performance tab and press Record
    - Perform the actions you want to profile. Don’t record more than 20 seconds or Chrome might hang
    - Stop recording
    - React events will be grouped under the User Timing label
- For a more detailed walkthrough, check out [this article by Ben Schwarz](https://building.calibreapp.com/debugging-react-performance-with-react-16-and-chrome-devtools-c90698a522ad)
- Note that **the numbers are relative so components will render faster in production**. Still, this should help you realize when unrelated UI gets updated by mistake, and how deep and how often your UI updates occur
- Currently Chrome, Edge, and IE are the only browsers supporting this feature, but we use the standard User Timing API so we expect more browsers to add support for it

### Virtualize Long Lists
- If your application renders long lists of data (hundreds or thousands of rows), we recommended using a technique known as “windowing”
    - This technique only renders a small subset of your rows at any given time, and can dramatically reduce the time it takes to re-render the components as well as the number of DOM nodes created
- [React Virtualized](https://bvaughn.github.io/react-virtualized/) is one popular windowing library
    - It provides several reusable components for displaying lists, grids, and tabular data
    - You can also create your own windowing component, like Twitter did, if you want something more tailored to your application’s specific use case

### Avoid Reconciliation
- React builds and maintains an internal representation of the rendered UI
    - It includes the React elements you return from your components
    - This representation lets React avoid creating DOM nodes and accessing existing ones beyond necessity, as that can be slower than operations on JavaScript objects
    - Sometimes it is referred to as a “virtual DOM”, but it works the same way on React Native
- When a component’s props or state change, React decides whether an actual DOM update is necessary by comparing the newly returned element with the previously rendered one
    - When they are not equal, React will update the DOM
- You can now visualize these re-renders of the virtual DOM with React DevTools:
    - [Chrome Browser Extension](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en)
    - [Firefox Browser Extension](https://addons.mozilla.org/en-GB/firefox/addon/react-devtools/)
    - [Standalone Node Package](https://www.npmjs.com/package/react-devtools)
    - In the developer console select the Highlight Updates option in the React tab:
        _<picture>_
        - Interact with your page and you should see colored borders momentarily appear around any components that have re-rendered
        - This lets you spot re-renders that were not necessary. You can learn more about this React DevTools feature from this [blog post](https://blog.logrocket.com/make-react-fast-again-part-3-highlighting-component-updates-6119e45e6833) from [Ben Edelstein](https://blog.logrocket.com/@edelstein)
- Consider this example:
    _picture_
    - Note that when we’re entering a second todo, the first todo also flashes on the screen on every keystroke
    - This means it is being re-rendered by React together with the input
    - This is sometimes called a “wasted” render
    - We know it is unnecessary because the first todo content has not changed, but React doesn’t know this
- Even though React only updates the changed DOM nodes, re-rendering still takes some time
    - In many cases it’s not a problem, but if the slowdown is noticeable, you can speed all of this up by overriding the lifecycle function shouldComponentUpdate, which is triggered before the re-rendering process starts
    - The default implementation of this function returns true, leaving React to perform the update:
        ```
        shouldComponentUpdate(nextProps, nextState) {
          return true;
        }
        ```
        - If you know that in some situations your component doesn’t need to update, you can return false from shouldComponentUpdate instead, to skip the whole rendering process, including calling render() on this component and below
        - In most cases, instead of writing shouldComponentUpdate() by hand, you can inherit from React.PureComponent
            - It is equivalent to implementing shouldComponentUpdate() with a shallow comparison of current and previous props and state

### shouldComponentUpdate In Action
- Here’s a subtree of components
    - For each one, SCU indicates what shouldComponentUpdate returned, and vDOMEq indicates whether the rendered React elements were equivalent
    - Finally, the circle’s color indicates whether the component had to be reconciled or not
    _<picture>_
    - Since shouldComponentUpdate returned false for the subtree rooted at C2, React did not attempt to render C2, and thus didn’t even have to invoke shouldComponentUpdate on C4 and C5
    - For C1 and C3, shouldComponentUpdate returned true, so React had to go down to the leaves and check them
        - For C6 shouldComponentUpdate returned true, and since the rendered elements weren’t equivalent React had to update the DOM
    - The last interesting case is C8
        - React had to render this component, but since the React elements it returned were equal to the previously rendered ones, it didn’t have to update the DOM
    - Note that React only had to do DOM mutations for C6, which was inevitable
        - For C8, it bailed out by comparing the rendered React elements, and for C2’s subtree and C7, it didn’t even have to compare the elements as we bailed out on shouldComponentUpdate, and render was not called

### Examples
- If the only way your component ever changes is when the props.color or the state.count variable changes, you could have shouldComponentUpdate check that:
    ```
    class CounterButton extends React.Component {
      constructor(props) {
        super(props);
        this.state = {count: 1};
      }

      shouldComponentUpdate(nextProps, nextState) {
        if (this.props.color !== nextProps.color) {
          return true;
        }
        if (this.state.count !== nextState.count) {
          return true;
        }
        return false;
      }

      render() {
        return (
          <button
            color={this.props.color}
            onClick={() => this.setState(state => ({count: state.count + 1}))}>
            Count: {this.state.count}
          </button>
        );
      }
    }
    ```
    - In this code, shouldComponentUpdate is just checking if there is any change in props.color or state.count
    - If those values don’t change, the component doesn’t update. If your component got more complex, you could use a similar pattern of doing a “shallow comparison” between all the fields of props and state to determine if the component should update
    - This pattern is common enough that React provides a helper to use this logic - just inherit from React.PureComponent
    - So this code is a simpler way to achieve the same thing:
        ```
        class CounterButton extends React.PureComponent {
          constructor(props) {
            super(props);
            this.state = {count: 1};
          }

          render() {
            return (
              <button
                color={this.props.color}
                onClick={() => this.setState(state => ({count: state.count + 1}))}>
                Count: {this.state.count}
              </button>
            );
          }
        }
        ```
        - Most of the time, you can use React.PureComponent instead of writing your own shouldComponentUpdate
        - It only does a shallow comparison, so you can’t use it if the props or state may have been mutated in a way that a shallow comparison would miss
        - This can be a problem with more complex data structures
            - For example, let’s say you want a ListOfWords component to render a comma-separated list of words, with a parent WordAdder component that lets you click a button to add a word to the list
                - This code does not work correctly:
                    ```
                    class ListOfWords extends React.PureComponent {
                      render() {
                        return <div>{this.props.words.join(',')}</div>;
                      }
                    }

                    class WordAdder extends React.Component {
                      constructor(props) {
                        super(props);
                        this.state = {
                          words: ['marklar']
                        };
                        this.handleClick = this.handleClick.bind(this);
                      }

                      handleClick() {
                        // This section is bad style and causes a bug
                        const words = this.state.words;
                        words.push('marklar');
                        this.setState({words: words});
                      }

                      render() {
                        return (
                          <div>
                            <button onClick={this.handleClick} />
                            <ListOfWords words={this.state.words} />
                          </div>
                        );
                      }
                    }
                    ```
                    - The problem is that PureComponent will do a simple comparison between the old and new values of this.props.words
                    - Since this code mutates the words array in the handleClick method of WordAdder, the old and new values of this.props.words will compare as equal, even though the actual words in the array have changed
                    - The ListOfWords will thus not update even though it has new words that should be rendered

### The Power Of Not Mutating Data
- The simplest way to avoid this problem is to avoid mutating values that you are using as props or state
     - For example, the handleClick method above could be rewritten using concat as:
        ```
        handleClick() {
          this.setState(prevState => ({
            words: prevState.words.concat(['marklar'])
          }));
        }
        ```
- ES6 supports a spread syntax for arrays which can make this easier. If you’re using Create React App, this syntax is available by default
    ```
    handleClick() {
      this.setState(prevState => ({
        words: [...prevState.words, 'marklar'],
      }));
    };
    ```
- You can also rewrite code that mutates objects to avoid mutation, in a similar way
    - For example, let’s say we have an object named colormap and we want to write a function that changes colormap.right to be 'blue'. We could write:
        ```
        function updateColorMap(colormap) {
          colormap.right = 'blue';
        }
        ```
    - To write this without mutating the original object, we can use Object.assign method:
        ```
        function updateColorMap(colormap) {
          return Object.assign({}, colormap, {right: 'blue'});
        }
        ```
        - updateColorMap now returns a new object, rather than mutating the old one
        - Object.assign is in ES6 and requires a polyfill
        - There is a JavaScript proposal to add object spread properties to make it easier to update objects without mutation as well:
            ```
            function updateColorMap(colormap) {
              return {...colormap, right: 'blue'};
            }
            ```
        - If you’re using Create React App, both Object.assign and the object spread syntax are available by default

### Using Immutable Data Structures
- [Immutable.js](https://github.com/facebook/immutable-js) is another way to solve this problem. It provides immutable, persistent collections that work via structural sharing:
    - _Immutable_: once created, a collection cannot be altered at another point in time.
    - _Persistent_: new collections can be created from a previous collection and a mutation such as set. The original collection is still valid after the new collection is created.
    - _Structural Sharing_: new collections are created using as much of the same structure as the original collection as possible, reducing copying to a minimum to improve performance.
- Immutability makes tracking changes cheap
    - A change will always result in a new object so we only need to check if the reference to the object has changed
    - For example, in this regular JavaScript code:
        ```
        const x = { foo: 'bar' };
        const y = x;
        y.foo = 'baz';
        x === y; // true
        ```
        - Although y was edited, since it’s a reference to the same object as x, this comparison returns true. You can write similar code with immutable.js:
            ```
            const SomeRecord = Immutable.Record({ foo: null });
            const x = new SomeRecord({ foo: 'bar' });
            const y = x.set('foo', 'baz');
            const z = x.set('foo', 'bar');
            x === y; // false
            x === z; // true
            ```
            - In this case, since a new reference is returned when mutating x, we can use a reference equality check (x === y) to verify that the new value stored in y is different than the original value stored in x
    - Two other libraries that can help use immutable data are [seamless-immutable](https://github.com/rtfeldman/seamless-immutable) and [immutability-helper](https://github.com/kolodny/immutability-helper)
    - Immutable data structures provide you with a cheap way to track changes on objects, which is all we need to implement shouldComponentUpdate
        - This can often provide you with a nice performance boost

# React Without ES6
- Normally you would define a React component as a plain JavaScript class:
    ```
    class Greeting extends React.Component {
      render() {
        return <h1>Hello, {this.props.name}</h1>;
      }
    }
    ```
- If you don’t use ES6 yet, you may use the create-react-class module instead:
    ```
    var createReactClass = require('create-react-class');
    var Greeting = createReactClass({
      render: function() {
        return <h1>Hello, {this.props.name}</h1>;
      }
    });
    ```
- The API of ES6 classes is similar to createReactClass() with a few exceptions

### Declaring Default Props
- With functions and ES6 classes defaultProps is defined as a property on the component itself:
    ```
    class Greeting extends React.Component {
      // ...
    }

    Greeting.defaultProps = {
      name: 'Mary'
    };
    ```
- With createReactClass(), you need to define getDefaultProps() as a function on the passed object:
    ```
    var Greeting = createReactClass({
      getDefaultProps: function() {
        return {
          name: 'Mary'
        };
      },

      // ...

    });
    ```

### Setting the Initial State
- In ES6 classes, you can define the initial state by assigning this.state in the constructor:
    ```
    class Counter extends React.Component {
      constructor(props) {
        super(props);
        this.state = {count: props.initialCount};
      }
      // ...
    }
    ```
- With createReactClass(), you have to provide a separate getInitialState method that returns the initial state:
    ```
    var Counter = createReactClass({
      getInitialState: function() {
        return {count: this.props.initialCount};
      },
      // ...
    });
    ```
### Autobinding
- In React components declared as ES6 classes, methods follow the same semantics as regular ES6 classes
    - This means that they don’t automatically bind this to the instance
    - You’ll have to explicitly use .bind(this) in the constructor:
        ```
        class SayHello extends React.Component {
          constructor(props) {
            super(props);
            this.state = {message: 'Hello!'};
            // This line is important!
            this.handleClick = this.handleClick.bind(this);
          }

          handleClick() {
            alert(this.state.message);
          }

          render() {
            // Because `this.handleClick` is bound, we can use it as an event handler.
            return (
              <button onClick={this.handleClick}>
                Say hello
              </button>
            );
          }
        }
        ```
    - With createReactClass(), this is not necessary because it binds all methods:
        ```
        var SayHello = createReactClass({
          getInitialState: function() {
            return {message: 'Hello!'};
          },

          handleClick: function() {
            alert(this.state.message);
          },

          render: function() {
            return (
              <button onClick={this.handleClick}>
                Say hello
              </button>
            );
          }
        });
        ```
    - This means writing ES6 classes comes with a little more boilerplate code for event handlers, but the upside is slightly better performance in large applications
    - If the boilerplate code is too unattractive to you, you may enable the experimental Class Properties syntax proposal with Babel:
        ```
        class SayHello extends React.Component {
          constructor(props) {
            super(props);
            this.state = {message: 'Hello!'};
          }
          // WARNING: this syntax is experimental!
          // Using an arrow here binds the method:
          handleClick = () => {
            alert(this.state.message);
          }

          render() {
            return (
              <button onClick={this.handleClick}>
                Say hello
              </button>
            );
          }
        }
        ```
    - Please note that the syntax above is experimental and the syntax may change, or the proposal might not make it into the language
        - If you’d rather play it safe, you have a few options:
            - Bind methods in the constructor
            - Use arrow functions, e.g. onClick={(e) => this.handleClick(e)}
            - Keep using createReactClass

# Mixins
- **Note:** ES6 launched without any mixin support. Therefore, there is no support for mixins when you use React with ES6 classes
    - **We also found numerous issues in codebases using mixins, [and don’t recommend using them in the new code](https://reactjs.org/blog/2016/07/13/mixins-considered-harmful.html)**
    - This section exists only for the reference
- Sometimes very different components may share some common functionality
    - These are sometimes called cross-cutting concerns
    - createReactClass lets you use a legacy mixins system for that
- One common use case is a component wanting to update itself on a time interval
    - It’s easy to use setInterval(), but it’s important to cancel your interval when you don’t need it anymore to save memory
    - React provides [lifecycle methods](https://reactjs.org/docs/react-component.html#the-component-lifecycle) that let you know when a component is about to be created or destroyed
    - Let’s create a simple mixin that uses these methods to provide an easy setInterval() function that will automatically get cleaned up when your component is destroyed.
        ```
        var SetIntervalMixin = {
          componentWillMount: function() {
            this.intervals = [];
          },
          setInterval: function() {
            this.intervals.push(setInterval.apply(null, arguments));
          },
          componentWillUnmount: function() {
            this.intervals.forEach(clearInterval);
          }
        };

        var createReactClass = require('create-react-class');

        var TickTock = createReactClass({
          mixins: [SetIntervalMixin], // Use the mixin
          getInitialState: function() {
            return {seconds: 0};
          },
          componentDidMount: function() {
            this.setInterval(this.tick, 1000); // Call a method on the mixin
          },
          tick: function() {
            this.setState({seconds: this.state.seconds + 1});
          },
          render: function() {
            return (
              <p>
                React has been running for {this.state.seconds} seconds.
              </p>
            );
          }
        });

        ReactDOM.render(
          <TickTock />,
          document.getElementById('example')
        );
        ```
        - If a component is using multiple mixins and several mixins define the same lifecycle method (i.e. several mixins want to do some cleanup when the component is destroyed), all of the lifecycle methods are guaranteed to be called
        - Methods defined on mixins run in the order mixins were listed, followed by a method call on the component

# React Without JSX
_fill in later_

# Reconciliation
- React provides a declarative API so that you don’t have to worry about exactly what changes on every update
    - This makes writing applications a lot easier, but it might not be obvious how this is implemented within React
    - This article explains the choices we made in React’s “diffing” algorithm so that component updates are predictable while being fast enough for high-performance apps

### Motivation
- When you use React, at a single point in time you can think of the render() function as creating a tree of React elements
    - On the next state or props update, that render() function will return a different tree of React elements
    - React then needs to figure out how to efficiently update the UI to match the most recent tree
- There are some generic solutions to this algorithmic problem of generating the minimum number of operations to transform one tree into another
    - However, the state of the art algorithms have a complexity in the order of O(n3) where n is the number of elements in the tree
- If we used this in React, displaying 1000 elements would require in the order of one billion comparisons
    - This is far too expensive. Instead, React implements a heuristic O(n) algorithm based on two assumptions:
        1. Two elements of different types will produce different trees.
        2. The developer can hint at which child elements may be stable across different renders with a key prop
- In practice, these assumptions are valid for almost all practical use cases

### The Diffing Algorithm
- When diffing two trees, React first compares the two root elements. The behavior is different depending on the types of the root elements

##### Elements Of Different Types
- Whenever the root elements have different types, React will tear down the old tree and build the new tree from scratch
    - Going from <a> to <img>, or from <Article> to <Comment>, or from <Button> to <div> - any of those will lead to a full rebuild
- When tearing down a tree, old DOM nodes are destroyed
    - Component instances receive componentWillUnmount()
    - When building up a new tree, new DOM nodes are inserted into the DOM. Component instances receive componentWillMount() and then componentDidMount()
    - Any state associated with the old tree is lost
- Any components below the root will also get unmounted and have their state destroyed. For example, when diffing:
    ```
    <div>
      <Counter />
    </div>

    <span>
      <Counter />
    </span>
    ```
    - This will destroy the old Counter and remount a new one.

##### DOM Elements Of The Same Type
- When comparing two React DOM elements of the same type, React looks at the attributes of both, keeps the same underlying DOM node, and only updates the changed attributes. For example:
    ```
    <div className="before" title="stuff" />
    <div className="after" title="stuff" />
    ```
    - By comparing these two elements, React knows to only modify the className on the underlying DOM node
    - When updating style, React also knows to update only the properties that changed. For example:
        ```
        <div style={{color: 'red', fontWeight: 'bold'}} />
        <div style={{color: 'green', fontWeight: 'bold'}} />
        ```
        - When converting between these two elements, React knows to only modify the color style, not the fontWeight
- After handling the DOM node, React then recurses on the children

##### Component Elements Of The Same Type
- When a component updates, the instance stays the same, so that state is maintained across renders
    - React updates the props of the underlying component instance to match the new element, and calls componentWillReceiveProps() and componentWillUpdate() on the underlying instance
- Next, the render() method is called and the diff algorithm recurses on the previous result and the new result

##### Recursing On Children
- By default, when recursing on the children of a DOM node, React just iterates over both lists of children at the same time and generates a mutation whenever there’s a difference
    - For example, when adding an element at the end of the children, converting between these two trees works well:
        ```
        <ul>
          <li>first</li>
          <li>second</li>
        </ul>

        <ul>
          <li>first</li>
          <li>second</li>
          <li>third</li>
        </ul>
        ```
        - React will match the two <li>first</li> trees, match the two <li>second</li> trees, and then insert the <li>third</li> tree
    - If you implement it naively, inserting an element at the beginning has worse performanc. For example, converting between these two trees works poorly:
        ```
        <ul>
          <li>Duke</li>
          <li>Villanova</li>
        </ul>

        <ul>
          <li>Connecticut</li>
          <li>Duke</li>
          <li>Villanova</li>
        </ul>
        ```
        - React will mutate every child instead of realizing it can keep the `<li>Duke</li>` and `<li>Villanova</li>` subtrees intact. This inefficiency can be a problem

##### Keys
- In order to solve this issue, React supports a key attribute
- When children have keys, React uses the key to match children in the original tree with children in the subsequent tree
    - For example, adding a key to our inefficient example above can make the tree conversion efficient:
    ```
    <ul>
      <li key="2015">Duke</li>
      <li key="2016">Villanova</li>
    </ul>

    <ul>
      <li key="2014">Connecticut</li>
      <li key="2015">Duke</li>
      <li key="2016">Villanova</li>
    </ul>
    ```
    - Now React knows that the element with key '2014' is the new one, and the elements with the keys '2015' and '2016' have just moved
- In practice, finding a key is usually not hard. The element you are going to display may already have a unique ID, so the key can just come from your data: `<li key={item.id}>{item.name}</li>`
    - When that’s not the case, you can add a new ID property to your model or hash some parts of the content to generate a key
        - The key only has to be unique among its siblings, not globally unique
    - As a last resort, you can pass an item’s index in the array as a key. This can work well if the items are never reordered, but reorders will be slow
- Reorders can also cause issues with component state when indexes are used as keys. Component instances are updated and reused based on their key
    - If the key is an index, moving an item changes it
    - As a result, component state for things like uncontrolled inputs can get mixed up and updated in unexpected ways
- [Here](https://reactjs.org/redirect-to-codepen/reconciliation/index-used-as-key) is an example of the issues that can be caused by using indexes as keys on CodePen, and [here](https://reactjs.org/redirect-to-codepen/reconciliation/no-index-used-as-key) is a updated version of the same example showing how not using indexes as keys will fix these reordering, sorting, and prepending issues

### Tradeoffs
- It is important to remember that the reconciliation algorithm is an implementation detail. React could rerender the whole app on every action; the end result would be the same
    - Just to be clear, rerender in this context means calling render for all components, it doesn’t mean React will unmount and remount them
    - It will only apply the differences following the rules stated in the previous sections
- We are regularly refining the heuristics in order to make common use cases faster. In the current implementation, you can express the fact that a subtree has been moved amongst its siblings, but you cannot tell that it has moved somewhere else
    - The algorithm will rerender that full subtree
- Because React relies on heuristics, if the assumptions behind them are not met, performance will suffer
    1. The algorithm will not try to match subtrees of different component types. If you see yourself alternating between two component types with very similar output, you may want to make it the same type. In practice, we haven’t found this to be an issue.

    2. Keys should be stable, predictable, and unique. Unstable keys (like those produced by Math.random()) will cause many component instances and DOM nodes to be unnecessarily recreated, which can cause performance degradation and lost state in child components.

# Context
- Context provides a way to pass data through the component tree without having to pass props down manually at every level
- In a typical React application, data is passed top-down (parent to child) via props, but this can be cumbersome for certain types of props (e.g. locale preference, UI theme) that are required by many components within an application
    - Context provides a way to share values like this between components without having to explicitly pass a prop through every level of the tree

### When to Use Context
- Context is designed to share data that can be considered “global” for a tree of React components, such as the current authenticated user, theme, or preferred language
    - For example, in the code below we manually thread through a “theme” prop in order to style the Button component:
        ```
        class App extends React.Component {
          render() {
            return <Toolbar theme="dark" />;
          }
        }

        function Toolbar(props) {
          // The Toolbar component must take an extra "theme" prop
          // and pass it to the ThemedButton. This can become painful
          // if every single button in the app needs to know the theme
          // because it would have to be passed through all components.
          return (
            <div>
              <ThemedButton theme={props.theme} />
            </div>
          );
        }

        function ThemedButton(props) {
          return <Button theme={props.theme} />;
        }
        ```
        - Using context, we can avoid passing props through intermediate elements:
            ```
            // Context lets us pass a value deep into the component tree
            // without explicitly threading it through every component.
            // Create a context for the current theme (with "light" as the default).
            const ThemeContext = React.createContext('light');

            class App extends React.Component {
              render() {
                // Use a Provider to pass the current theme to the tree below.
                // Any component can read it, no matter how deep it is.
                // In this example, we're passing "dark" as the current value.
                return (
                  <ThemeContext.Provider value="dark">
                    <Toolbar />
                  </ThemeContext.Provider>
                );
              }
            }

            // A component in the middle doesn't have to
            // pass the theme down explicitly anymore.
            function Toolbar(props) {
              return (
                <div>
                  <ThemedButton />
                </div>
              );
            }

            function ThemedButton(props) {
              // Use a Consumer to read the current theme context.
              // React will find the closest theme Provider above and use its value.
              // In this example, the current theme is "dark".
              return (
                <ThemeContext.Consumer>
                  {theme => <Button {...props} theme={theme} />}
                </ThemeContext.Consumer>
              );
            }
            ```
        - **Note:** Don’t use context just to avoid passing props a few levels down. Stick to cases where the same data needs to be accessed in many components at multiple levels

### API
##### React.createContext
`const {Provider, Consumer} = React.createContext(defaultValue);`
    - Creates a { Provider, Consumer } pair
        - When React renders a context Consumer, it will read the current context value from the closest matching Provider above it in the tree
    - The defaultValue argument is used when you render a Consumer without a matching Provider above it in the tree
        - This can be helpful for testing components in isolation without wrapping them
##### Provider
`<Provider value={/* some value */}>`
    - A React component that allows Consumers to subscribe to context changes
    - Accepts a value prop to be passed to Consumers that are descendants of this Provider
        - One Provider can be connected to many Consumers. Providers can be nested to override values deeper within the tree
##### Consumer
```
<Consumer>
  {value => /* render something based on the context value */}
</Consumer>
```
- A React component that subscribes to context changes
- Requires a [function as a child](https://reactjs.org/docs/render-props.html#using-props-other-than-render)
    - The function receives the current context value and returns a React node
    - The value argument passed to the function will be equal to the value prop of the closest Provider for this context above in the tree
    - If there is no Provider for this context above, the value argument will be equal to the defaultValue that was passed to createContext()
- All Consumers are re-rendered whenever the Provider value changes
    - Changes are determined by comparing the new and old values using the same algorithm as [Object.is](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is#Description)
        - (This can cause some issues when passing objects as value: see Caveats.)
    - For more information about this pattern, see [render props](https://reactjs.org/docs/render-props.html)

### Examples
##### Dynamic Context
- A more complex example with dynamic values for the theme:
    **theme-context.js**
        ```
        export const themes = {
          light: {
            foreground: '#ffffff',
            background: '#222222',
          },
          dark: {
            foreground: '#000000',
            background: '#eeeeee',
          },
        };

        export const ThemeContext = React.createContext(
          themes.dark // default value
        );
        ```
    **themed-button.js**
        ```
        import {ThemeContext} from './theme-context';

        function ThemedButton(props) {
          return (
            <ThemeContext.Consumer>
              {theme => (
                <button
                  {...props}
                  style={{backgroundColor: theme.background}}
                />
              )}
            </ThemeContext.Consumer>
          );
        }

        export default ThemedButton;
        ```
    **app.js**
        ```
        import {ThemeContext, themes} from './theme-context';
        import ThemedButton from './themed-button';

        // An intermediate component that uses the ThemedButton
        function Toolbar(props) {
          return (
            <ThemedButton onClick={props.changeTheme}>
              Change Theme
            </ThemedButton>
          );
        }

        class App extends React.Component {
          constructor(props) {
            super(props);
            this.state = {
              theme: themes.light,
            };

            this.toggleTheme = () => {
              this.setState(state => ({
                theme:
                  state.theme === themes.dark
                    ? themes.light
                    : themes.dark,
              }));
            };
          }

          render() {
            // The ThemedButton button inside the ThemeProvider
            // uses the theme from state while the one outside uses
            // the default dark theme
            return (
              <Page>
                <ThemeContext.Provider value={this.state.theme}>
                  <Toolbar changeTheme={this.toggleTheme} />
                </ThemeContext.Provider>
                <Section>
                  <ThemedButton />
                </Section>
              </Page>
            );
          }
        }

        ReactDOM.render(<App />, document.root);
        ```

##### Updating Context from a Nested Component
- It is often necessary to update the context from a component that is nested somewhere deeply in the component tree
    - In this case you can pass a function down through the context to allow consumers to update the context:
    **theme-context.js**
        ```
        // Make sure the shape of the default value passed to
        // createContext matches the shape that the consumers expect!
        export const ThemeContext = React.createContext({
          theme: themes.dark,
          toggleTheme: () => {},
        });
        ```
    **theme-toggler-button.js**
        ```
        import {ThemeContext} from './theme-context';

        function ThemeTogglerButton() {
          // The Theme Toggler Button receives not only the theme
          // but also a toggleTheme function from the context
          return (
            <ThemeContext.Consumer>
              {({theme, toggleTheme}) => (
                <button
                  onClick={toggleTheme}
                  style={{backgroundColor: theme.background}}>
                  Toggle Theme
                </button>
              )}
            </ThemeContext.Consumer>
          );
        }

        export default ThemeTogglerButton;
        ```
    **app.js**
        ```
        import {ThemeContext, themes} from './theme-context';
        import ThemeTogglerButton from './theme-toggler-button';

        class App extends React.Component {
          constructor(props) {
            super(props);

            this.toggleTheme = () => {
              this.setState(state => ({
                theme:
                  state.theme === themes.dark
                    ? themes.light
                    : themes.dark,
              }));
            };

            // State also contains the updater function so it will
            // be passed down into the context provider
            this.state = {
              theme: themes.light,
              toggleTheme: this.toggleTheme,
            };
          }

          render() {
            // The entire state is passed to the provider
            return (
              <ThemeContext.Provider value={this.state}>
                <Content />
              </ThemeContext.Provider>
            );
          }
        }

        function Content() {
          return (
            <div>
              <ThemeTogglerButton />
            </div>
          );
        }

        ReactDOM.render(<App />, document.root);
        ```
    ### Consuming Multiple Contexts
    - To keep context re-rendering fast, React needs to make each context consumer a separate node in the tree
        ```
        // Theme context, default to light theme
        const ThemeContext = React.createContext('light');

        // Signed-in user context
        const UserContext = React.createContext({
          name: 'Guest',
        });

        class App extends React.Component {
          render() {
            const {signedInUser, theme} = this.props;

            // App component that provides initial context values
            return (
              <ThemeContext.Provider value={theme}>
                <UserContext.Provider value={signedInUser}>
                  <Layout />
                </UserContext.Provider>
              </ThemeContext.Provider>
            );
          }
        }

        function Layout() {
          return (
            <div>
              <Sidebar />
              <Content />
            </div>
          );
        }

        // A component may consume multiple contexts
        function Content() {
          return (
            <ThemeContext.Consumer>
              {theme => (
                <UserContext.Consumer>
                  {user => (
                    <ProfilePage user={user} theme={theme} />
                  )}
                </UserContext.Consumer>
              )}
            </ThemeContext.Consumer>
          );
        }
        ```
        - If two or more context values are often used together, you might want to consider creating your own render prop component that provides both
    ##### Accessing Context in Lifecycle Methods
    - Accessing values from context in lifecycle methods is a relatively common use case
        - Instead of adding context to every lifecycle method, you just need to pass it as a prop, and then work with it just like you’d normally work with a prop:
            ```
            class Button extends React.Component {
              componentDidMount() {
                // ThemeContext value is this.props.theme
              }

              componentDidUpdate(prevProps, prevState) {
                // Previous ThemeContext value is prevProps.theme
                // New ThemeContext value is this.props.theme
              }

              render() {
                const {theme, children} = this.props;
                return (
                  <button className={theme ? 'dark' : 'light'}>
                    {children}
                  </button>
                );
              }
            }

            export default props => (
              <ThemeContext.Consumer>
                {theme => <Button {...props} theme={theme} />}
              </ThemeContext.Consumer>
            );
            ```
##### Consuming Context with a HOC
- Some types of contexts are consumed by many components (e.g. theme or localization)
    - It can be tedious to explicitly wrap each dependency with a <Context.Consumer> element
    - A higher-order component can help with this
    - For example, a button component might consume a theme context like so:
        ```
        const ThemeContext = React.createContext('light');

        function ThemedButton(props) {
          return (
            <ThemeContext.Consumer>
              {theme => <button className={theme} {...props} />}
            </ThemeContext.Consumer>
          );
        }
        ```
        - That’s alright for a few components, but what if we wanted to use the theme context in a lot of places?
        - We could create a higher-order component called withTheme:
            ```
            function Button({theme, ...rest}) {
              return <button className={theme} {...rest} />;
            }

            const ThemedButton = withTheme(Button);
            ```
    ##### Forwarding Refs to Context Consumers
    - One issue with the render prop API is that refs don’t automatically get passed to wrapped elements
        - To get around this, use React.forwardRef:
            **fancy-button.js**
                ```
                class FancyButton extends React.Component {
                  focus() {
                    // ...
                  }

                  // ...
                }

                // Use context to pass the current "theme" to FancyButton.
                // Use forwardRef to pass refs to FancyButton as well.
                export default React.forwardRef((props, ref) => (
                  <ThemeContext.Consumer>
                    {theme => (
                      <FancyButton {...props} theme={theme} ref={ref} />
                    )}
                  </ThemeContext.Consumer>
                ));
                ```
            **app.js**
                ```
                import FancyButton from './fancy-button';

                const ref = React.createRef();

                // Our ref will point to the FancyButton component,
                // And not the ThemeContext.Consumer that wraps it.
                // This means we can call FancyButton methods like ref.current.focus()
                <FancyButton ref={ref} onClick={handleClick}>
                  Click me!
                </FancyButton>;
                ```
### Caveats
- Because context uses reference identity to determine when to re-render, there are some gotchas that could trigger unintentional renders in consumers when a provider’s parent re-renders
    - For example, the code below will re-render all consumers every time the Provider re-renders because a new object is always created for value:
        ```
        class App extends React.Component {
          render() {
            return (
              <Provider value={{something: 'something'}}>
                <Toolbar />
              </Provider>
            );
          }
        }
        ```
    - To get around this, lift the value into the parent’s state:
        ```
        class App extends React.Component {
          constructor(props) {
            super(props);
            this.state = {
              value: {something: 'something'},
            };
          }

          render() {
            return (
              <Provider value={this.state.value}>
                <Toolbar />
              </Provider>
            );
          }
        }
        ```
### Legacy API
- React previously shipped with an experimental context API
- The old API will be supported in all 16.x releases, but applications using it should migrate to the new version
- The legacy API will be removed in a future major React version. Read the [legacy context docs here](https://reactjs.org/docs/legacy-context.html)

# Fragments
- A common pattern in React is for a component to return multiple elements
    - Fragments let you group a list of children without adding extra nodes to the DOM
        ```
        render() {
          return (
            <React.Fragment>
              <ChildA />
              <ChildB />
              <ChildC />
            </React.Fragment>
          );
        }
        ```
    - There is also a new short syntax for declaring them, but it isn’t supported by all popular tools yet

### Motivation
- A common pattern is for a component to return a list of children. Take this example React snippet:
    ```
    class Table extends React.Component {
      render() {
        return (
          <table>
            <tr>
              <Columns />
            </tr>
          </table>
        );
      }
    }
    ```
    - `<Columns />` would need to return multiple `<td>` elements in order for the rendered HTML to be valid
        - If a parent div was used inside the render() of `<Columns />`, then the resulting HTML will be invalid
        ```
        class Columns extends React.Component {
          render() {
            return (
              <div>
                <td>Hello</td>
                <td>World</td>
              </div>
            );
          }
        }
        ```
        results in a <Table /> output of:
        ```
        <table>
          <tr>
            <div>
              <td>Hello</td>
              <td>World</td>
            </div>
          </tr>
        </table>
        ```
        So, we introduce Fragments
### Usage
```
class Columns extends React.Component {
  render() {
    return (
      <React.Fragment>
        <td>Hello</td>
        <td>World</td>
      </React.Fragment>
    );
  }
}
```
which results in a correct <Table /> output of:
```
<table>
  <tr>
    <td>Hello</td>
    <td>World</td>
  </tr>
</table>
```

### Short Syntax
There is a new, shorter syntax you can use for declaring fragments. It looks like empty tags:
```
class Columns extends React.Component {
  render() {
    return (
      <>
        <td>Hello</td>
        <td>World</td>
      </>
    );
  }
}
```
- You can use <></> the same way you’d use any other element except that it doesn’t support keys or attributes

- Note that **[many tools don’t support it yet](https://reactjs.org/blog/2017/11/28/react-v16.2.0-fragment-support.html#support-for-fragment-syntax)** so you might want to explicitly write <React.Fragment> until the tooling catches up

### Keyed Fragments
- Fragments declared with the explicit <React.Fragment> syntax may have keys
    - A use case for this is mapping a collection to an array of fragments — for example, to create a description list:
        ```
        function Glossary(props) {
          return (
            <dl>
              {props.items.map(item => (
                // Without the `key`, React will fire a key warning
                <React.Fragment key={item.id}>
                  <dt>{item.term}</dt>
                  <dd>{item.description}</dd>
                </React.Fragment>
              ))}
            </dl>
          );
        }
        ```
        - key is the only attribute that can be passed to Fragment. In the future, we may add support for additional attributes, such as event handlers
### Live Demo
- You can try out the new JSX fragment syntax with this [CodePen](https://codepen.io/reactjs/pen/VrEbjE?editors=1000)

# Portals
- Portals provide a first-class way to render children into a DOM node that exists outside the DOM hierarchy of the parent component
    `ReactDOM.createPortal(child, container)`
    - The first argument (child) is any renderable React child, such as an element, string, or fragment
    - The second argument (container) is a DOM element
### Usage
- Normally, when you return an element from a component’s render method, it’s mounted into the DOM as a child of the nearest parent node:
    ```
    render() {
      // React mounts a new div and renders the children into it
      return (
        <div>
          {this.props.children}
        </div>
      );
    }
    ```
    However, sometimes it’s useful to insert a child into a different location in the DOM:
        ```
        render() {
          // React does *not* create a new div. It renders the children into `domNode`.
          // `domNode` is any valid DOM node, regardless of its location in the DOM.
          return ReactDOM.createPortal(
            this.props.children,
            domNode
          );
        }
        ```
- A typical use case for portals is when a parent component has an overflow: hidden or z-index style, but you need the child to visually “break out” of its container
    - For example, dialogs, hovercards, and tooltips
    - **Note:** It is important to remember, when working with portals, you’ll need to make sure to follow the proper accessibility guidelines
- Try it on [CodePen](https://codepen.io/gaearon/pen/yzMaBd)

### Event Bubbling Through Portals
- Even though a portal can be anywhere in the DOM tree, it behaves like a normal React child in every other way
    - Features like context work exactly the same regardless of whether the child is a portal, as the portal still exists in the React tree regardless of position in the DOM tree
- This includes event bubbling
    - An event fired from inside a portal will propagate to ancestors in the containing React tree, even if those elements are not ancestors in the DOM tree
    - Assuming the following HTML structure:
        ```
        <html>
          <body>
            <div id="app-root"></div>
            <div id="modal-root"></div>
          </body>
        </html>
        ```
        - A Parent component in #app-root would be able to catch an uncaught, bubbling event from the sibling node #modal-root
            ```
            // These two containers are siblings in the DOM
            const appRoot = document.getElementById('app-root');
            const modalRoot = document.getElementById('modal-root');

            class Modal extends React.Component {
              constructor(props) {
                super(props);
                this.el = document.createElement('div');
              }

              componentDidMount() {
                // The portal element is inserted in the DOM tree after
                // the Modal's children are mounted, meaning that children
                // will be mounted on a detached DOM node. If a child
                // component requires to be attached to the DOM tree
                // immediately when mounted, for example to measure a
                // DOM node, or uses 'autoFocus' in a descendant, add
                // state to Modal and only render the children when Modal
                // is inserted in the DOM tree.
                modalRoot.appendChild(this.el);
              }

              componentWillUnmount() {
                modalRoot.removeChild(this.el);
              }

              render() {
                return ReactDOM.createPortal(
                  this.props.children,
                  this.el,
                );
              }
            }

            class Parent extends React.Component {
              constructor(props) {
                super(props);
                this.state = {clicks: 0};
                this.handleClick = this.handleClick.bind(this);
              }

              handleClick() {
                // This will fire when the button in Child is clicked,
                // updating Parent's state, even though button
                // is not direct descendant in the DOM.
                this.setState(prevState => ({
                  clicks: prevState.clicks + 1
                }));
              }

              render() {
                return (
                  <div onClick={this.handleClick}>
                    <p>Number of clicks: {this.state.clicks}</p>
                    <p>
                      Open up the browser DevTools
                      to observe that the button
                      is not a child of the div
                      with the onClick handler.
                    </p>
                    <Modal>
                      <Child />
                    </Modal>
                  </div>
                );
              }
            }

            function Child() {
              // The click event on this button will bubble up to parent,
              // because there is no 'onClick' attribute defined
              return (
                <div className="modal">
                  <button>Click</button>
                </div>
              );
            }

            ReactDOM.render(<Parent />, appRoot);
            ```
- Try it on [CodePen](https://codepen.io/gaearon/pen/jGBWpE)
- Catching an event bubbling up from a portal in a parent component allows the development of more flexible abstractions that are not inherently reliant on portals
    - For example, if you render a <Modal /> component, the parent can capture its events regardless of whether it’s implemented using portals.


# Resources
- [Typechecking With PropTypes](https://reactjs.org/docs/typechecking-with-proptypes.html)
- [Static Type Checking](https://reactjs.org/docs/static-type-checking.html)

# Error Boundaries
- In the past, JavaScript errors inside components used to corrupt React’s internal state and cause it to [emit](https://github.com/facebook/react/issues/4026) [cryptic](https://github.com/facebook/react/issues/6895) [errors](https://github.com/facebook/react/issues/8579) on next renders
    - These errors were always caused by an earlier error in the application code, but React did not provide a way to handle them gracefully in components, and could not recover from them
### Introducing Error Boundaries
- A JavaScript error in a part of the UI shouldn’t break the whole app
    - To solve this problem for React users, React 16 introduces a new concept of an “error boundary”
- Error boundaries are React components that **catch JavaScript errors anywhere in their child component tree, log those errors, and display a fallback UI** instead of the component tree that crashed
    - Error boundaries catch errors during rendering, in lifecycle methods, and in constructors of the whole tree below them
- **Note:** Error boundaries do not catch errors for:
    - Event handlers ([learn more](https://reactjs.org/docs/error-boundaries.html#how-about-event-handlers))
    - Asynchronous code (e.g. setTimeout or requestAnimationFrame callbacks)
    - Server side rendering
    - Errors thrown in the error boundary itself (rather than its children)
- A class component becomes an error boundary if it defines a new lifecycle method called componentDidCatch(error, info):
    ```
    class ErrorBoundary extends React.Component {
      constructor(props) {
        super(props);
        this.state = { hasError: false };
      }

      componentDidCatch(error, info) {
        // Display fallback UI
        this.setState({ hasError: true });
        // You can also log the error to an error reporting service
        logErrorToMyService(error, info);
      }

      render() {
        if (this.state.hasError) {
          // You can render any custom fallback UI
          return <h1>Something went wrong.</h1>;
        }
        return this.props.children;
      }
    }
    ```
    - Then you can use it as a regular component:
        ```
        <ErrorBoundary>
          <MyWidget />
        </ErrorBoundary>
        ```
    - The componentDidCatch() method works like a JavaScript catch {} block, but for components
        - Only class components can be error boundaries
        - In practice, most of the time you’ll want to declare an error boundary component once and use it throughout your application
    - Note that **error boundaries only catch errors in the components below them in the tree**
        - An error boundary can’t catch an error within itself. If an error boundary fails trying to render the error message, the error will propagate to the closest error boundary above it
        - This, too, is similar to how catch {} block works in JavaScript
### componentDidCatch Parameters
- error is an error that has been thrown
- info is an object with componentStack key
    - The property has information about component stack during thrown error
        ```
        //...
        componentDidCatch(error, info) {

          /* Example stack information:
             in ComponentThatThrows (created by App)
             in ErrorBoundary (created by App)
             in div (created by App)
             in App
          */
          logComponentStackToMyService(info.componentStack);
        }

        //...
        ```
### Live Demo
- Check out [this example of declaring and using an error boundary](https://codepen.io/gaearon/pen/wqvxGa?editors=0010) with [React 16](https://reactjs.org/blog/2017/09/26/react-v16.0.html)
### Where to Place Error Boundaries
- The granularity of error boundaries is up to you
    - You may wrap top-level route components to display a “Something went wrong” message to the user, just like server-side frameworks often handle crashes
    - You may also wrap individual widgets in an error boundary to protect them from crashing the rest of the application
### New Behavior for Uncaught Errors
- This change has an important implication. **As of React 16, errors that were not caught by any error boundary will result in unmounting of the whole React component tree**
- We debated this decision, but in our experience it is worse to leave corrupted UI in place than to completely remove it
    - For example, in a product like Messenger leaving the broken UI visible could lead to somebody sending a message to the wrong person
    - Similarly, it is worse for a payments app to display a wrong amount than to render nothing
- This change means that as you migrate to React 16, you will likely uncover existing crashes in your application that have been unnoticed before
    - Adding error boundaries lets you provide better user experience when something goes wrong
        - For example, Facebook Messenger wraps content of the sidebar, the info panel, the conversation log, and the message input into separate error boundaries
            - If some component in one of these UI areas crashes, the rest of them remain interactive
- We also encourage you to use JS error reporting services (or build your own) so that you can learn about unhandled exceptions as they happen in production, and fix them
### Component Stack Traces
- React 16 prints all errors that occurred during rendering to the console in development, even if the application accidentally swallows them. In addition to the error message and the JavaScript stack, it also provides component stack traces
    - Now you can see where exactly in the component tree the failure has happened:
    _picture_
    - You can also see the filenames and line numbers in the component stack trace. This works by default in Create React App projects:
    _picture_
- If you don’t use Create React App, you can add this plugin manually to your Babel configuration. Note that it’s intended only for development and **must be disabled in production**
- **Note:** Component names displayed in the stack traces depend on the Function.name property. If you support older browsers and devices which may not yet provide this natively (e.g. IE 11), consider including a Function.name polyfill in your bundled application, such as function.name-polyfill. Alternatively, you may explicitly set the displayName property on all your components
### How About try/catch?
- try / catch is great but it only works for imperative code:
    ```
    try {
      showButton();
    } catch (error) {
      // ...
    }
    ``
    - However, React components are declarative and specify what should be rendered:
    `<Button />`
- Error boundaries preserve the declarative nature of React, and behave as you would expect
    - For example, even if an error occurs in a componentDidUpdate hook caused by a setState somewhere deep in the tree, it will still correctly propagate to the closest error boundary
### How About Event Handlers?
- Error boundaries **do not** catch errors inside event handlers
- React doesn’t need error boundaries to recover from errors in event handlers
    - Unlike the render method and lifecycle hooks, the event handlers don’t happen during rendering
    - So if they throw, React still knows what to display on the screen
    - If you need to catch an error inside event handler, use the regular JavaScript try / catch statement:
        ```
        class MyComponent extends React.Component {
          constructor(props) {
            super(props);
            this.state = { error: null };
          }

          handleClick = () => {
            try {
              // Do something that could throw
            } catch (error) {
              this.setState({ error });
            }
          }

          render() {
            if (this.state.error) {
              return <h1>Caught an error.</h1>
            }
            return <div onClick={this.handleClick}>Click Me</div>
          }
        }
        ```
        - Note that the above example is demonstrating regular JavaScript behavior and doesn’t use error boundaries
### Naming Changes from React 15
- React 15 included a very limited support for error boundaries under a different method name: unstable_handleError
    - This method no longer works, and you will need to change it to componentDidCatch in your code starting from the first 16 beta release
    - For this change, we’ve provided a [codemod](https://github.com/reactjs/react-codemod#error-boundaries to automatically migrate your code

# Web Components
- React and Web Components are built to solve different problems
- Web Components provide strong encapsulation for reusable components, while React provides a declarative library that keeps the DOM in sync with your data
- The two goals are complementary
- As a developer, you are free to use React in your Web Components, or to use Web Components in React, or both
- Most people who use React don’t use Web Components, but you may want to, especially if you are using third-party UI components that are written using Web Components
### Using Web Components in React
```
class HelloMessage extends React.Component {
  render() {
    return <div>Hello <x-search>{this.props.name}</x-search>!</div>;
  }
}
```
- **Note:**
    - Web Components often expose an imperative API. For instance, a video Web Component might expose play() and pause() functions. To access the imperative APIs of a Web Component, you will need to use a ref to interact with the DOM node directly. If you are using third-party Web Components, the best solution is to write a React component that behaves as a wrapper for your Web Component
    - Events emitted by a Web Component may not properly propagate through a React render tree. You will need to manually attach event handlers to handle these events within your React components
- One common confusion is that Web Components use “class” instead of “className”.
    ```
    function BrickFlipbox() {
      return (
        <brick-flipbox class="demo">
          <div>front</div>
          <div>back</div>
        </brick-flipbox>
      );
    }
    ```
### Using React in your Web Components
```
class XSearch extends HTMLElement {
  connectedCallback() {
    const mountPoint = document.createElement('span');
    this.attachShadow({ mode: 'open' }).appendChild(mountPoint);

    const name = this.getAttribute('name');
    const url = 'https://www.google.com/search?q=' + encodeURIComponent(name);
    ReactDOM.render(<a href={url}>{name}</a>, mountPoint);
  }
}
customElements.define('x-search', XSearch);
```
- **Note:** This code will not work if you transform classes with Babel. See this issue for the discussion. Include the custom-elements-es5-adapter before you load your web components to fix this issue

# Higher-Order Components
- A higher-order component (HOC) is an advanced technique in React for reusing component logic
- HOCs are not part of the React API, per se
    - They are a pattern that emerges from React’s compositional nature
- Concretely, **a higher-order component is a function that takes a component and returns a new component**
    `const EnhancedComponent = higherOrderComponent(WrappedComponent);`
- Whereas a component transforms props into UI, a higher-order component transforms a component into another component
- HOCs are common in third-party React libraries, such as Redux’s [connect](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options) and Relay’s [createFragmentContainer](http://facebook.github.io/relay/docs/en/fragment-container.html)
- In this document, we’ll discuss why higher-order components are useful, and how to write your own

### Use HOCs For Cross-Cutting Concerns
- **Note:** We previously recommended mixins as a way to handle cross-cutting concerns. We’ve since realized that mixins create more trouble than they are worth. [Read more](https://reactjs.org/blog/2016/07/13/mixins-considered-harmful.html) about why we’ve moved away from mixins and how you can transition your existing components
- Components are the primary unit of code reuse in React
    - However, you’ll find that some patterns aren’t a straightforward fit for traditional components
    - For example, say you have a CommentList component that subscribes to an external data source to render a list of comments:
        ```
        class CommentList extends React.Component {
          constructor(props) {
            super(props);
            this.handleChange = this.handleChange.bind(this);
            this.state = {
              // "DataSource" is some global data source
              comments: DataSource.getComments()
            };
          }

          componentDidMount() {
            // Subscribe to changes
            DataSource.addChangeListener(this.handleChange);
          }

          componentWillUnmount() {
            // Clean up listener
            DataSource.removeChangeListener(this.handleChange);
          }

          handleChange() {
            // Update component state whenever the data source changes
            this.setState({
              comments: DataSource.getComments()
            });
          }

          render() {
            return (
              <div>
                {this.state.comments.map((comment) => (
                  <Comment comment={comment} key={comment.id} />
                ))}
              </div>
            );
          }
        }
        ```
        Later, you write a component for subscribing to a single blog post, which follows a similar pattern:
        ```
        class BlogPost extends React.Component {
          constructor(props) {
            super(props);
            this.handleChange = this.handleChange.bind(this);
            this.state = {
              blogPost: DataSource.getBlogPost(props.id)
            };
          }

          componentDidMount() {
            DataSource.addChangeListener(this.handleChange);
          }

          componentWillUnmount() {
            DataSource.removeChangeListener(this.handleChange);
          }

          handleChange() {
            this.setState({
              blogPost: DataSource.getBlogPost(this.props.id)
            });
          }

          render() {
            return <TextBlock text={this.state.blogPost} />;
          }
        }
        class BlogPost extends React.Component {
          constructor(props) {
            super(props);
            this.handleChange = this.handleChange.bind(this);
            this.state = {
              blogPost: DataSource.getBlogPost(props.id)
            };
          }

          componentDidMount() {
            DataSource.addChangeListener(this.handleChange);
          }

          componentWillUnmount() {
            DataSource.removeChangeListener(this.handleChange);
          }

          handleChange() {
            this.setState({
              blogPost: DataSource.getBlogPost(this.props.id)
            });
          }

          render() {
            return <TextBlock text={this.state.blogPost} />;
          }
        }
        ```
        - CommentList and BlogPost aren’t identical — they call different methods on DataSource, and they render different output. But much of their implementation is the same:
            - On mount, add a change listener to DataSource.
            - Inside the listener, call setState whenever the data source changes.
            - On unmount, remove the change listener
        - You can imagine that in a large app, this same pattern of subscribing to DataSource and calling setState will occur over and over again
            - We want an abstraction that allows us to define this logic in a single place and share it across many components
            - This is where higher-order components excel
        - We can write a function that creates components, like CommentList and BlogPost, that subscribe to DataSource
            - The function will accept as one of its arguments a child component that receives the subscribed data as a prop
            - Let’s call the function withSubscription:
                ```
                const CommentListWithSubscription = withSubscription(
                  CommentList,
                  (DataSource) => DataSource.getComments()
                );

                const BlogPostWithSubscription = withSubscription(
                  BlogPost,
                  (DataSource, props) => DataSource.getBlogPost(props.id)
                );
                ```
                - The first parameter is the wrapped component
                - The second parameter retrieves the data we’re interested in, given a DataSource and the current props
                - When CommentListWithSubscription and BlogPostWithSubscription are rendered, CommentList and BlogPost will be passed a data prop with the most current data retrieved from DataSource:
                    ```
                    // This function takes a component...
                    function withSubscription(WrappedComponent, selectData) {
                      // ...and returns another component...
                      return class extends React.Component {
                        constructor(props) {
                          super(props);
                          this.handleChange = this.handleChange.bind(this);
                          this.state = {
                            data: selectData(DataSource, props)
                          };
                        }

                        componentDidMount() {
                          // ... that takes care of the subscription...
                          DataSource.addChangeListener(this.handleChange);
                        }

                        componentWillUnmount() {
                          DataSource.removeChangeListener(this.handleChange);
                        }

                        handleChange() {
                          this.setState({
                            data: selectData(DataSource, this.props)
                          });
                        }

                        render() {
                          // ... and renders the wrapped component with the fresh data!
                          // Notice that we pass through any additional props
                          return <WrappedComponent data={this.state.data} {...this.props} />;
                        }
                      };
                    }
                    ```
- Note that a HOC doesn’t modify the input component, nor does it use inheritance to copy its behavior
    - Rather, a HOC composes the original component by wrapping it in a container component
    - A HOC is a pure function with zero side-effects
- And that’s it! The wrapped component receives all the props of the container, along with a new prop, data, which it uses to render its output
    - The HOC isn’t concerned with how or why the data is used, and the wrapped component isn’t concerned with where the data came from
- Because withSubscription is a normal function, you can add as many or as few arguments as you like
    - For example, you may want to make the name of the data prop configurable, to further isolate the HOC from the wrapped component
    - Or you could accept an argument that configures shouldComponentUpdate, or one that configures the data source
    - These are all possible because the HOC has full control over how the component is defined
- Like components, the contract between withSubscription and the wrapped component is entirely props-based
    - This makes it easy to swap one HOC for a different one, as long as they provide the same props to the wrapped component
    - This may be useful if you change data-fetching libraries, for example
### Don’t Mutate the Original Component. Use Composition.
- Resist the temptation to modify a component’s prototype (or otherwise mutate it) inside a HOC
    ```
    function logProps(InputComponent) {
      InputComponent.prototype.componentWillReceiveProps = function(nextProps) {
        console.log('Current props: ', this.props);
        console.log('Next props: ', nextProps);
      };
      // The fact that we're returning the original input is a hint that it has
      // been mutated.
      return InputComponent;
    }

    // EnhancedComponent will log whenever props are received
    const EnhancedComponent = logProps(InputComponent);
    ```
    - There are a few problems with this. One is that the input component cannot be reused separately from the enhanced component
        - More crucially, if you apply another HOC to EnhancedComponent that also mutates componentWillReceiveProps, the first HOC’s functionality will be overridden!
        - This HOC also won’t work with functional components, which do not have lifecycle methods
        - Mutating HOCs are a leaky abstraction—the consumer must know how they are implemented in order to avoid conflicts with other HOCs
        - Instead of mutation, HOCs should use composition, by wrapping the input component in a container component:
            ```
            function logProps(WrappedComponent) {
              return class extends React.Component {
                componentWillReceiveProps(nextProps) {
                  console.log('Current props: ', this.props);
                  console.log('Next props: ', nextProps);
                }
                render() {
                  // Wraps the input component in a container, without mutating it. Good!
                  return <WrappedComponent {...this.props} />;
                }
              }
            }
            ```
            - This HOC has the same functionality as the mutating version while avoiding the potential for clashes
            - It works equally well with class and functional components
            - And because it’s a pure function, it’s composable with other HOCs, or even with itself
- You may have noticed similarities between HOCs and a pattern called **container components**
    - Container components are part of a strategy of separating responsibility between high-level and low-level concerns
    - Containers manage things like subscriptions and state, and pass props to components that handle things like rendering UI
    - HOCs use containers as part of their implementation
    - You can think of HOCs as parameterized container component definitions
### Convention: Pass Unrelated Props Through to the Wrapped Component
- HOCs add features to a component
    - They shouldn’t drastically alter its contract
    - It’s expected that the component returned from a HOC has a similar interface to the wrapped component
- HOCs should pass through props that are unrelated to its specific concern
    - Most HOCs contain a render method that looks something like this:
        ```
        render() {
          // Filter out extra props that are specific to this HOC and shouldn't be
          // passed through
          const { extraProp, ...passThroughProps } = this.props;

          // Inject props into the wrapped component. These are usually state values or
          // instance methods.
          const injectedProp = someStateOrInstanceMethod;

          // Pass props to wrapped component
          return (
            <WrappedComponent
              injectedProp={injectedProp}
              {...passThroughProps}
            />
          );
        }
        ```
        - This convention helps ensure that HOCs are as flexible and reusable as possible
### Convention: Maximizing Composability
- Not all HOCs look the same. Sometimes they accept only a single argument, the wrapped component:
    `const NavbarWithRouter = withRouter(Navbar);`
- Usually, HOCs accept additional arguments. In this example from Relay, a config object is used to specify a component’s data dependencies:
    `const CommentWithRelay = Relay.createContainer(Comment, config);`
- The most common signature for HOCs looks like this:
    ```
    // React Redux's `connect`
    const ConnectedComment = connect(commentSelector, commentActions)(CommentList);
    ```
    - What?! If you break it apart, it’s easier to see what’s going on
        ```
        // connect is a function that returns another function
        const enhance = connect(commentListSelector, commentListActions);
        // The returned function is a HOC, which returns a component that is connected
        // to the Redux store
        const ConnectedComment = enhance(CommentList);
        ```
    - In other words, connect is a higher-order function that returns a higher-order component!
        - This form may seem confusing or unnecessary, but it has a useful property
        - Single-argument HOCs like the one returned by the connect function have the signature Component => Component
        - Functions whose output type is the same as its input type are really easy to compose together
            ```
            // Instead of doing this...
            const EnhancedComponent = withRouter(connect(commentSelector)(WrappedComponent))

            // ... you can use a function composition utility
            // compose(f, g, h) is the same as (...args) => f(g(h(...args)))
            const enhance = compose(
              // These are both single-argument HOCs
              withRouter,
              connect(commentSelector)
            )
            const EnhancedComponent = enhance(WrappedComponent)
            ```
            - (This same property also allows connect and other enhancer-style HOCs to be used as decorators, an experimental JavaScript proposal.)
            - The compose utility function is provided by many third-party libraries including lodash (as lodash.flowRight), Redux, and Ramda
### Convention: Wrap the Display Name for Easy Debugging
- The container components created by HOCs show up in the React Developer Tools like any other component
    - To ease debugging, choose a display name that communicates that it’s the result of a HOC
- The most common technique is to wrap the display name of the wrapped component
    - So if your higher-order component is named withSubscription, and the wrapped component’s display name is CommentList, use the display name WithSubscription(CommentList):
        ```
        function withSubscription(WrappedComponent) {
          class WithSubscription extends React.Component {/* ... */}
          WithSubscription.displayName = `WithSubscription(${getDisplayName(WrappedComponent)})`;
          return WithSubscription;
        }

        function getDisplayName(WrappedComponent) {
          return WrappedComponent.displayName || WrappedComponent.name || 'Component';
        }
        ```
### Caveats
- Higher-order components come with a few caveats that aren’t immediately obvious if you’re new to React
##### Don’t Use HOCs Inside the render Method
- React’s diffing algorithm (called reconciliation) uses component identity to determine whether it should update the existing subtree or throw it away and mount a new one
    - If the component returned from render is identical (===) to the component from the previous render, React recursively updates the subtree by diffing it with the new one
    - If they’re not equal, the previous subtree is unmounted completely
- Normally, you shouldn’t need to think about this. But it matters for HOCs because it means you can’t apply a HOC to a component within the render method of a component:
    ```
    render() {
      // A new version of EnhancedComponent is created on every render
      // EnhancedComponent1 !== EnhancedComponent2
      const EnhancedComponent = enhance(MyComponent);
      // That causes the entire subtree to unmount/remount each time!
      return <EnhancedComponent />;
    }
    ```
    - The problem here isn’t just about performance — remounting a component causes the state of that component and all of its children to be lost
        - Instead, apply HOCs outside the component definition so that the resulting component is created only once. Then, its identity will be consistent across renders. This is usually what you want, anyway
        - In those rare cases where you need to apply a HOC dynamically, you can also do it inside a component’s lifecycle methods or its constructor
##### Static Methods Must Be Copied Over
- Sometimes it’s useful to define a static method on a React component
    - For example, Relay containers expose a static method getFragment to facilitate the composition of GraphQL fragments
    - When you apply a HOC to a component, though, the original component is wrapped with a container component
        - That means the new component does not have any of the static methods of the original component
            ```
            // Define a static method
            WrappedComponent.staticMethod = function() {/*...*/}
            // Now apply a HOC
            const EnhancedComponent = enhance(WrappedComponent);

            // The enhanced component has no static method
            typeof EnhancedComponent.staticMethod === 'undefined' // true
            ```
            - To solve this, you could copy the methods onto the container before returning it:
                ```
                function enhance(WrappedComponent) {
                  class Enhance extends React.Component {/*...*/}
                  // Must know exactly which method(s) to copy :(
                  Enhance.staticMethod = WrappedComponent.staticMethod;
                  return Enhance;
                }
                ```
            - However, this requires you to know exactly which methods need to be copied
                - You can use hoist-non-react-statics to automatically copy all non-React static methods:
                    ```
                    import hoistNonReactStatic from 'hoist-non-react-statics';
                    function enhance(WrappedComponent) {
                      class Enhance extends React.Component {/*...*/}
                      hoistNonReactStatic(Enhance, WrappedComponent);
                      return Enhance;
                    }
                    ```
            - Another possible solution is to export the static method separately from the component itself.
                ```
                // Instead of...
                MyComponent.someFunction = someFunction;
                export default MyComponent;

                // ...export the method separately...
                export { someFunction };

                // ...and in the consuming module, import both
                import MyComponent, { someFunction } from './MyComponent.js';
                ```
##### Refs Aren’t Passed Through
- While the convention for higher-order components is to pass through all props to the wrapped component, this does not work for refs
    - That’s because ref is not really a prop — like key, it’s handled specially by React
    -  If you add a ref to an element whose component is the result of a HOC, the ref refers to an instance of the outermost container component, not the wrapped component
    - The solution for this problem is to use the React.forwardRef API (introduced with React 16.3). [Learn more about it in the forwarding refs section](https://reactjs.org/docs/forwarding-refs.html)

# Render Props
- The term “render prop” refers to a simple technique for sharing code between React components using a prop whose value is a function
- A component with a render prop takes a function that returns a React element and calls it instead of implementing its own render logic
    ```
    <DataProvider render={data => (
      <h1>Hello {data.target}</h1>
    )}/>
    ```
- Libraries that use render props include [React Router](https://reacttraining.com/react-router/web/api/Route/Route-render-methods) and [Downshift](https://github.com/paypal/downshift)
- In this document, we’ll discuss why render props are useful, and how to write your own.
### Use Render Props for Cross-Cutting Concerns
- Components are the primary unit of code reuse in React, but it’s not always obvious how to share the state or behavior that one component encapsulates to other components that need that same state
    - For example, the following component tracks the mouse position in a web app:
        ```
        class MouseTracker extends React.Component {
          constructor(props) {
            super(props);
            this.handleMouseMove = this.handleMouseMove.bind(this);
            this.state = { x: 0, y: 0 };
          }

          handleMouseMove(event) {
            this.setState({
              x: event.clientX,
              y: event.clientY
            });
          }

          render() {
            return (
              <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>
                <h1>Move the mouse around!</h1>
                <p>The current mouse position is ({this.state.x}, {this.state.y})</p>
              </div>
            );
          }
        }
        ```
        - As the cursor moves around the screen, the component displays its (x, y) coordinates in a <p>
        - Now the question is: How can we reuse this behavior in another component?
            - In other words, if another component needs to know about the cursor position, can we encapsulate that behavior so that we can easily share it with that component?
        - Since components are the basic unit of code reuse in React, let’s try refactoring the code a bit to use a <Mouse> component that encapsulates the behavior we need to reuse elsewhere.
            ```
            // The <Mouse> component encapsulates the behavior we need...
            class Mouse extends React.Component {
              constructor(props) {
                super(props);
                this.handleMouseMove = this.handleMouseMove.bind(this);
                this.state = { x: 0, y: 0 };
              }

              handleMouseMove(event) {
                this.setState({
                  x: event.clientX,
                  y: event.clientY
                });
              }

              render() {
                return (
                  <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>

                    {/* ...but how do we render something other than a <p>? */}
                    <p>The current mouse position is ({this.state.x}, {this.state.y})</p>
                  </div>
                );
              }
            }

            class MouseTracker extends React.Component {
              render() {
                return (
                  <div>
                    <h1>Move the mouse around!</h1>
                    <Mouse />
                  </div>
                );
              }
            }
            ```
            - Now the <Mouse> component encapsulates all behavior associated with listening for mousemove events and storing the (x, y) position of the cursor, but it’s not yet truly reusable
            - For example, let’s say we have a <Cat> component that renders the image of a cat chasing the mouse around the screen
            - We might use a <Cat mouse={{ x, y }}> prop to tell the component the coordinates of the mouse so it knows where to position the image on the screen
            - As a first pass, you might try rendering the <Cat> inside <Mouse>’s render method, like this:
                ```
                class Cat extends React.Component {
                  render() {
                    const mouse = this.props.mouse;
                    return (
                      <img src="/cat.jpg" style={{ position: 'absolute', left: mouse.x, top: mouse.y }} />
                    );
                  }
                }

                class MouseWithCat extends React.Component {
                  constructor(props) {
                    super(props);
                    this.handleMouseMove = this.handleMouseMove.bind(this);
                    this.state = { x: 0, y: 0 };
                  }

                  handleMouseMove(event) {
                    this.setState({
                      x: event.clientX,
                      y: event.clientY
                    });
                  }

                  render() {
                    return (
                      <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>

                        {/*
                          We could just swap out the <p> for a <Cat> here ... but then
                          we would need to create a separate <MouseWithSomethingElse>
                          component every time we need to use it, so <MouseWithCat>
                          isn't really reusable yet.
                        */}
                        <Cat mouse={this.state} />
                      </div>
                    );
                  }
                }

                class MouseTracker extends React.Component {
                  render() {
                    return (
                      <div>
                        <h1>Move the mouse around!</h1>
                        <MouseWithCat />
                      </div>
                    );
                  }
                }
                ```
                - This approach will work for our specific use case, but we haven’t achieved the objective of truly encapsulating the behavior in a reusable way
                    - Now, every time we want the mouse position for a different use case, we have to create a new component (i.e. essentially another <MouseWithCat>) that renders something specifically for that use case
                - Here’s where the render prop comes in: Instead of hard-coding a <Cat> inside a <Mouse> component, and effectively changing its rendered output, we can provide <Mouse> with a function prop that it uses to dynamically determine what to render–a render prop
                    ```
                    class Cat extends React.Component {
                      render() {
                        const mouse = this.props.mouse;
                        return (
                          <img src="/cat.jpg" style={{ position: 'absolute', left: mouse.x, top: mouse.y }} />
                        );
                      }
                    }

                    class Mouse extends React.Component {
                      constructor(props) {
                        super(props);
                        this.handleMouseMove = this.handleMouseMove.bind(this);
                        this.state = { x: 0, y: 0 };
                      }

                      handleMouseMove(event) {
                        this.setState({
                          x: event.clientX,
                          y: event.clientY
                        });
                      }

                      render() {
                        return (
                          <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>

                            {/*
                              Instead of providing a static representation of what <Mouse> renders,
                              use the `render` prop to dynamically determine what to render.
                            */}
                            {this.props.render(this.state)}
                          </div>
                        );
                      }
                    }

                    class MouseTracker extends React.Component {
                      render() {
                        return (
                          <div>
                            <h1>Move the mouse around!</h1>
                            <Mouse render={mouse => (
                              <Cat mouse={mouse} />
                            )}/>
                          </div>
                        );
                      }
                    }
                    ```
                    - Now, instead of effectively cloning the <Mouse> component and hard-coding something else in its render method to solve for a specific use case, we provide a render prop that <Mouse> can use to dynamically determine what it renders
                    - More concretely, **a render prop is a function prop that a component uses to know what to render**
                        - This technique makes the behavior that we need to share extremely portable
                            - To get that behavior, render a <Mouse> with a render prop that tells it what to render with the current (x, y) of the cursor
- One interesting thing to note about render props is that you can implement most higher-order components (HOC) using a regular component with a render prop
    - For example, if you would prefer to have a withMouse HOC instead of a <Mouse> component, you could easily create one using a regular <Mouse> with a render prop:
        ```
        // If you really want a HOC for some reason, you can easily
        // create one using a regular component with a render prop!
        function withMouse(Component) {
          return class extends React.Component {
            render() {
              return (
                <Mouse render={mouse => (
                  <Component {...this.props} mouse={mouse} />
                )}/>
              );
            }
          }
        }
        ```
    - So using a render prop makes it possible to use either pattern
### Using Props Other Than render
- It’s important to remember that just because the pattern is called “render props” you don’t have to use a prop named render to use this pattern
    - In fact, any prop that is a function that a component uses to know what to render is technically a “render prop”
- Although the examples above use render, we could just as easily use the children prop!
    ```
    <Mouse children={mouse => (
      <p>The mouse position is {mouse.x}, {mouse.y}</p>
    )}/>
    ```
- And remember, the children prop doesn’t actually need to be named in the list of “attributes” in your JSX element. Instead, you can put it directly inside the element!
    ```
    <Mouse>
      {mouse => (
        <p>The mouse position is {mouse.x}, {mouse.y}</p>
      )}
    </Mouse>
    ```
    - You’ll see this technique used in the [react-motion](https://github.com/chenglou/react-motion) API
    - Since this technique is a little unusual, you’ll probably want to explicitly state that children should be a function in your propTypes when designing an API like this
        ```
        Mouse.propTypes = {
          children: PropTypes.func.isRequired
        };
        ```
### Caveats
##### Be careful when using Render Props with React.PureComponent
- Using a render prop can negate the advantage that comes from using React.PureComponent if you create the function inside a render method
    - This is because the shallow prop comparison will always return false for new props, and each render in this case will generate a new value for the render pro
    - For example, continuing with our <Mouse> component from above, if Mouse were to extend React.PureComponent instead of React.Component, our example would look like this:
        ```
        class Mouse extends React.PureComponent {
          // Same implementation as above...
        }

        class MouseTracker extends React.Component {
          render() {
            return (
              <div>
                <h1>Move the mouse around!</h1>

                {/*
                  This is bad! The value of the `render` prop will
                  be different on each render.
                */}
                <Mouse render={mouse => (
                  <Cat mouse={mouse} />
                )}/>
              </div>
            );
          }
        }
        ```
        - In this example, each time <MouseTracker> renders, it generates a new function as the value of the <Mouse render> prop, thus negating the effect of <Mouse> extending React.PureComponent in the first place!
        - To get around this problem, you can sometimes define the prop as an instance method, like so:
        ```
        class MouseTracker extends React.Component {
          // Defined as an instance method, `this.renderTheCat` always
          // refers to *same* function when we use it in render
          renderTheCat(mouse) {
            return <Cat mouse={mouse} />;
          }

          render() {
            return (
              <div>
                <h1>Move the mouse around!</h1>
                <Mouse render={this.renderTheCat} />
              </div>
            );
          }
        }
        ```
        - In cases where you cannot define the prop statically (e.g. because you need to close over the component’s props and/or state) <Mouse> should extend React.Component instead

# Integrating with Other Libraries
*fill in later*
# Accessibility
*fill in later*

# Code-Splitting
### Bundling
- Most React apps will have their files “bundled” using tools like [Webpack](https://webpack.js.org/) or [Browserify](http://browserify.org/)

Example:
##### App:
```
// app.js
import { add } from './math.js';

console.log(add(16, 26)); // 42
```
```
// math.js
export function add(a, b) {
  return a + b;
}
```
##### Bundle:
```
function add(a, b) {
  return a + b;
}

console.log(add(16, 26)); // 42
```
- *Note:* Your bundles will end up looking a lot different than this
- If you’re using [Create React App](https://github.com/facebookincubator/create-react-app), [Next.js](https://github.com/zeit/next.js/), [Gatsby](https://www.gatsbyjs.org/), or a similar tool, you will have a Webpack setup out of the box to bundle your app
    - If you aren’t, you’ll need to setup bundling yourself. For example, see the [Installation](https://webpack.js.org/guides/installation/) and [Getting Started](https://webpack.js.org/guides/getting-started/) guides on the Webpack docs
### Code Splitting
- Bundling is great, but as your app grows, your bundle will grow too
    - Especially if you are including large third-party libraries
        - You need to keep an eye on the code you are including in your bundle so that you don’t accidentally make it so large that your app takes a long time to load
- To avoid winding up with a large bundle, it’s good to get ahead of the problem and start “splitting” your bundle
    -  Code-Splitting is a feature supported by bundlers like Webpack and Browserify (via factor-bundle) which can create multiple bundles that can be dynamically loaded at runtime
- Code-splitting your app can help you “lazy-load” just the things that are currently needed by the user, which can dramatically improve the performance of your app
    - While you haven’t reduced the overall amount of code in your app, you’ve avoided loading code that the user may never need, and reduced the amount of code needed during the initial load

### import()
- The best way to introduce code-splitting into your app is through the dynamic import() syntax.
**Before:**
```
import { add } from './math';

console.log(add(16, 26));
```
**After:**
```
import("./math").then(math => {
  console.log(math.add(16, 26));
});
```
- **Note:** The dynamic import() syntax is a ECMAScript (JavaScript) proposal not currently part of the language standard. It is expected to be accepted within the near future
- When Webpack comes across this syntax, it automatically starts code-splitting your app. If you’re using Create React App, this is already configured for you and you can [start using it](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#code-splitting) immediately. It’s also supported out of the box in Next.js
- If you’re setting up Webpack yourself, you’ll probably want to read Webpack’s [guide on code splitting](https://webpack.js.org/guides/code-splitting/). Your Webpack config should look vaguely [like this](https://gist.github.com/gaearon/ca6e803f5c604d37468b0091d9959269)
- When using [Babel](http://babeljs.io/), you’ll need to make sure that Babel can parse the dynamic import syntax but is not transforming it. For that you will need [babel-plugin-syntax-dynamic-import](https://yarnpkg.com/en/package/babel-plugin-syntax-dynamic-import)

### Libraries
##### React Loadable
- [React Loadable](https://github.com/thejameskyle/react-loadable) wraps dynamic imports in a nice, React-friendly API for introducing code splitting into your app at a given component

**Before**
```
import OtherComponent from './OtherComponent';

const MyComponent = () => (
  <OtherComponent/>
);
```
**After**
```
import Loadable from 'react-loadable';

const LoadableOtherComponent = Loadable({
  loader: () => import('./OtherComponent'),
  loading: () => <div>Loading...</div>,
});

const MyComponent = () => (
  <LoadableOtherComponent/>
);
```
- React Loadable helps you create loading states, error states, timeouts, preloading, and more. It can even help you server-side render an app with lots of code-splitting
##### Route-based code splitting
- Deciding where in your app to introduce code splitting can be a bit tricky. You want to make sure you choose places that will split bundles evenly, but won’t disrupt the user experience
- A good place to start is with routes. Most people on the web are used to page transitions taking some amount of time to load
    - You also tend to be re-rendering the entire page at once so your users are unlikely to be interacting with other elements on the page at the same time
    - Here’s an example of how to setup route-based code splitting into your app using libraries like React Router and React Loadable:
        ```
        import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
        import Loadable from 'react-loadable';

        const Loading = () => <div>Loading...</div>;

        const Home = Loadable({
          loader: () => import('./routes/Home'),
          loading: Loading,
        });

        const About = Loadable({
          loader: () => import('./routes/About'),
          loading: Loading,
        });

        const App = () => (
          <Router>
            <Switch>
              <Route exact path="/" component={Home}/>
              <Route path="/about" component={About}/>
            </Switch>
          </Router>
        );
        ```

# Strict Mode
- StrictMode is a tool for highlighting potential problems in an application
- Like Fragment, StrictMode does not render any visible UI
- It activates additional checks and warnings for its descendants
- **Note:** Strict mode checks are run in development mode only; they do not impact the production build
- You can enable strict mode for any part of your application. For example:
    ```
    import React from 'react';

    function ExampleApplication() {
      return (
        <div>
          <Header />
          <React.StrictMode>
            <div>
              <ComponentOne />
              <ComponentTwo />
            </div>
          </React.StrictMode>
          <Footer />
        </div>
      );
    }
    ```
    - In the above example, strict mode checks will not be run against the Header and Footer components
        - However, ComponentOne and ComponentTwo, as well as all of their descendants, will have the checks
- StrictMode currently helps with:
    - [Identifying components with unsafe lifecycles](https://reactjs.org/docs/strict-mode.html#identifying-unsafe-lifecycles)
    - [Warning about legacy string ref API usage](https://reactjs.org/docs/strict-mode.html#warning-about-legacy-string-ref-api-usage)
    - [Detecting unexpected side effects](https://reactjs.org/docs/strict-mode.html#detecting-unexpected-side-effects)
- Additional functionality will be added with future releases of React
### Identifying unsafe lifecycles
- As explained [in this blog post](https://reactjs.org/blog/2018/03/27/update-on-async-rendering.html), certain legacy lifecycle methods are unsafe for use in async React applications
    - However, if your application uses third party libraries, it can be difficult to ensure that these lifecycles aren’t being used. Fortunately, strict mode can help with this!
- When strict mode is enabled, React compiles a list of all class components using the unsafe lifecycles, and logs a warning message with information about these components, like so:
    _picture_
- Addressing the issues identified by strict mode now will make it easier for you to take advantage of async rendering in future releases of React

### Warning about legacy string ref API usage
- Previously, React provided two ways for managing refs: the legacy string ref API and the callback API
    - Although the string ref API was the more convenient of the two, it had [several downsides](https://github.com/facebook/react/issues/1373) and so our official recommendation was to [use the callback form instead](https://reactjs.org/docs/refs-and-the-dom.html#legacy-api-string-refs)
- React 16.3 added a third option that offers the convenience of a string ref without any of the downsides:
    ```
    class MyComponent extends React.Component {
      constructor(props) {
        super(props);

        this.inputRef = React.createRef();
      }

      render() {
        return <input type="text" ref={this.inputRef} />;
      }

      componentDidMount() {
        this.inputRef.current.focus();
      }
    }
    ```
    - Since object refs were largely added as a replacement for string refs, strict mode now warns about usage of string refs
    - **Note:**
        - Callback refs will continue to be supported in addition to the new createRef API
        - You don’t need to replace callback refs in your components. They are slightly more flexible, so they will remain as an advanced feature
- [Learn more about the new createRef API here](https://reactjs.org/docs/refs-and-the-dom.html)

### Detecting unexpected side effects
Conceptually, React does work in two phases:
    - The render phase determines what changes need to be made to e.g. the DOM. During this phase, React calls render and then compares the result to the previous render
    - The commit phase is when React applies any changes. (In the case of React DOM, this is when React inserts, updates, and removes DOM nodes.) React also calls lifecycles like componentDidMount and componentDidUpdate during this phase
- The commit phase is usually very fast, but rendering can be slow
    - For this reason, the upcoming async mode (which is not enabled by default yet) breaks the rendering work into pieces, pausing and resuming the work to avoid blocking the browser
    - This means that React may invoke render phase lifecycles more than once before committing, or it may invoke them without committing at all (because of an error or a higher priority interruption)
- Render phase lifecycles include the following class component methods:
    - constructor
    - componentWillMount
    - componentWillReceiveProps
    - componentWillUpdate
    - getDerivedStateFromProps
    - shouldComponentUpdate
    - render
    - setState updater functions (the first argument)
- Because the above methods might be called more than once, it’s important that they do not contain side-effects
    - Ignoring this rule can lead to a variety of problems, including memory leaks and invalid application state
    - Unfortunately, it can be difficult to detect these problems as they can often be [non-deterministic](https://en.wikipedia.org/wiki/Deterministic_algorithm)
- Strict mode can’t automatically detect side effects for you, but it can help you spot them by making them a little more deterministic
    - This is done by intentionally double-invoking the following methods:
        - Class component constructor method
        - The render method
        - setState updater functions (the first argument)
        - The static getDerivedStateFromProps lifecycle
- **Note:** This only applies to development mode. Lifecycles will not be double-invoked in production mode
    - For example, consider the following code:
        ```
        class TopLevelRoute extends React.Component {
          constructor(props) {
            super(props);

            SharedApplicationState.recordEvent('ExampleComponent');
          }
        }
        ```
- But if SharedApplicationState.recordEvent is not idempotent, then instantiating this component multiple times could lead to invalid application state
    - But if SharedApplicationState.recordEvent is not idempotent, then instantiating this component multiple times could lead to invalid application state
    - This sort of subtle bug might not manifest during development, or it might do so inconsistently and so be overlooked-