# General
*(TBD)*

# Benefits of Using Redux
*(TBD)*

# Actions

### Action Types

A lot of people maintain the creation of action **constants** (aka Action **Types**) differently.  Some put them directly in the same file as actions and action creators, and some put them in one constants file usually called ActionTypes.js and then just simply import them into actions.

Personally I like to maintain them in one file.

**Below Dan Abramov explains the benefits of this style:**

*Why is this beneficial? It is often claimed that constants are unnecessary, and for small projects, this might be correct. For larger projects, there are some benefits to defining action types as constants:*

- It helps keep the naming consistent because all action types are gathered in a single place.

- Sometimes you want to see all existing actions before working on a new feature. It may be that the action you need was already added by somebody on the team, but you didn’t know.

- The list of action types that were added, removed, and changed in a Pull Request helps everyone on the team keep track of scope and implementation of new features.

- If you make a typo when importing an action constant, you will get undefined. This is much easier to notice than a typo when you wonder why nothing happens when the action is dispatched

Here is an example:

**ActionTypes.js**
```
 const ActionTypes = {
  auth: {
    REQUEST_AUTHENTICATION:  'REQUEST_AUTHENTICATION',
    AUTHENTICATED: 'AUTHENTICATED',
    REQUEST_UNAUTHENTICATION: 'REQUEST_UNAUTHENTICATION',
    UNAUTHENTICATED: 'UNAUTHENTICATED'
  },
  users: {
    REQUEST_ALL_USERS: 'REQUEST_ALL_USERS',
    USERS_RECEIVED: 'USERS_RECEIVED'
  },
  robots: {
    REQUEST_ALL_ROBOTS: 'REQUEST_ALL_ROBOTS',
    ROBOTS_RECEIVED: 'ROBOTS_RECEIVED'
  }
}

export default ActionTypes
 ```

### Actions
*(TBD)*
### Action Creators
*(TBD)*
### Thunk Action Creators
*(TBD)*


# Resources
- [Solution for simple action creation without string constants and less magic](https://github.com/reduxjs/redux/issues/628#issuecomment-137547668)