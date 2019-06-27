
# event.preventDefault()
### JS Documentation
- The Event interface's preventDefault() method tells the user agent that if the event does not get explicitly handled, its default action should not be taken as it normally would be
- The event continues to propagate as usual, unless one of its event listeners calls [stopPropagation()](https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation) or [stopImmediatePropagation()](https://developer.mozilla.org/en-US/docs/Web/API/Event/stopImmediatePropagation), either of which terminates propagation at once
- Calling preventDefault() during any stage of event flow cancels the event, meaning that any default action normally taken by the implementation as a result of the event will not occur

#### Use Case: Hitting Enter on a Form Field
- If you’re anything like me, you probably rarely use your mouse and instead press Enter on your keyboard. Apparently so does everyone else
    - Pressing Enter would immediately submit the form before the formatted address was converted into individual fields
    - you can prevent the Enter from propagating up:
        ```
        handleKeyDown(event) {
          if (event.keyCode === 13) {
            event.preventDefault(); // Let's stop this event.
            event.stopPropagation(); // Really this time.
            
            alert("Is it stopped?");
            // "Hahaha, I'm gonna submit anyway!" - Chrome
          }
        }
        ```
#### Use Case: Blocking default click handling
- Toggling a checkbox is the default action of clicking on a checkbox
    - This example demonstrates how to prevent that from happening:
        ```
        document.querySelector("#id-checkbox").addEventListener("click", function(event) {
                 document.getElementById("output-box").innerHTML += "Sorry! <code>preventDefault()</code> won't let you check this!<br>";
                 event.preventDefault();
        }, false);
        ```
        ```
        <p>Please click on the checkbox control.</p>
        
        <form>
          <label for="id-checkbox">Checkbox:</label>
          <input type="checkbox" id="id-checkbox"/>
        </form>
        
        <div id="output-box"></div>
        ```
#### Use Case: Stopping keystrokes from reaching an edit field
- The following example demonstrates how invalid text input can be stopped from reaching the input field with preventDefault()
- Nowadays, you should usually use [native HTML form validation](https://developer.mozilla.org/en-US/docs/Learn/HTML/Forms/Form_validation) instead
    ```
    <div class="container">
      <p>Please enter your name using lowercase letters only.</p>
    
      <form>
        <input type="text" id="my-textbox">
      </form>
    </div>
    ```
    - First, listen for keypress events:
        ```
        var myTextbox = document.getElementById('my-textbox');
        myTextbox.addEventListener('keypress', checkName, false);
        ```
    - The checkName() function, which looks at the pressed key and decides whether to allow it:
        ```
        function checkName(evt) {
          var charCode = evt.charCode;
          if (charCode != 0) {
            if (charCode < 97 || charCode > 122) {
              evt.preventDefault();
              displayWarning(
                "Please use lowercase letters only."
                + "\n" + "charCode: " + charCode + "\n"
              );
            }
          }
        }
        ```
    - The displayWarning() function presents a notification of a problem. It's not an elegant function but does the job for the purposes of this example:
        ```
        var warningTimeout;
        var warningBox = document.createElement("div");
        warningBox.className = "warning";
        
        function displayWarning(msg) {
          warningBox.innerHTML = msg;
        
          if (document.body.contains(warningBox)) {
            window.clearTimeout(warningTimeout);
          } else {
            // insert warningBox after myTextbox
            myTextbox.parentNode.insertBefore(warningBox, myTextbox.nextSibling);
          }
        
          warningTimeout = window.setTimeout(function() {
              warningBox.parentNode.removeChild(warningBox);
              warningTimeout = -1;
            }, 2000);
        }
        ```

### React and native DOM events
- Why Don’t Events in React Work as Expected?
    - a [comment buried in StackOverflow[(http://stackoverflow.com/questions/24415631/reactjs-syntheticevent-stoppropagation-only-works-with-react-events#comment37772453_24415631) offers this:

      *React’s actual event listener is also at the root of the document, meaning the click event has already bubbled to the root. You can use event.nativeEvent.stopImmediatePropagation to prevent other event listeners from firing, but order of execution is not guaranteed.*
    - Sure enough, React’s documentation [Interactivity and Dynamic UIs](https://facebook.github.io/react/docs/interactivity-and-dynamic-uis.html#under-the-hood-autobinding-and-event-delegation) inexplicably says:

        *React doesn’t actually attach event handlers to the nodes themselves. When React starts up, it starts listening for all events at the top level using a single event listener.*
    - this is great for memory usage, but insanely confusing when you attempt to leverage the standard event APIs
        - React events are actually Synthetic Events, not Native Events

            *With React, events are to be observed, not mutated or intercepted.*
##### A Wild Solution Appears
- Because our forms produce HTTP GET/POST-friendly HTML, we wanted to ensure that standard functionality was not broken (e.g. pressing Enter, or pressing Go on a mobile keyboard)
    - However, we still needed to ensure that normal user behavior didn’t break our improved functionality
    - The solution was to go back to Native Events
        ```
        componentDidMount() {
          // Direct reference to autocomplete DOM node
          // (e.g. <input ref="autocomplete" ... />
          const node = React.findDOMNode(this.refs.autocomplete);
          // Evergreen event listener || IE8 event listener
          const addEvent = node.addEventListener || node.attachEvent;
          addEvent(“keypress”, this.handleKeyPress, false);
        }
        componentWillUnmount() {
          const removeEvent = node.removeEventListener || node.detachEvent;
          // Reduce any memory leaks
          removeEvent("keypress", this.handleKeyPress);
        }
        handleKeyPress(event) {
          // [Enter] should not submit the form when choosing an address.
          if (event.keyCode === 13) {
            event.preventDefault();
          }
        }
        ```
        - if you’re using React v0.14 already, there’s a library for this: [react-native-listener](https://github.com/erikras/react-native-listener)
        - I’m genuinely surprised that this expectation of event handling is quietly broken in React
        - I would have expected that, since events are turned into SyntheticEvents, the event.preventDefault() and event.stopPropagation() would call console.warn or console.error due to the break in functionality



# Resources
[React & event.preventDefault()](https://medium.com/@ericclemmons/react-event-preventdefault-78c28c950e46)
[Event.preventDefault() - Mozilla](https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault)