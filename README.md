# Redux Future Middleware (Dart/Flutter)

[![Build Status](https://travis-ci.org/shbmbhrdwj/redux_future.svg?branch=master)](https://travis-ci.org/shbmbhrdwj/redux_future) [![codecov](https://codecov.io/gh/shbmbhrdwj/redux_future/branch/master/graph/badge.svg)](https://codecov.io/gh/shbmbhrdwj/redux_future)

Redux middleware package for handling Dart Futures by creating a FutureAction.

The `futureMiddleware` can be attached to the `Redux` store upon construction.

Once attached, you can `store.dipatch` the `FutureAction`, and the `futureMiddleware` will intercept it.

    * If the `Future` passed in `FutureAction` completes successfully, a `FutureSuccessAction` will be dipatched with the result of the `Future`.
    * If the `Future` passed in `FutureAction` fails, a `FutureErrorAction` will be dispatched containing the error that was returned.
    * When the `FutureAction` is dipatches, a `FuturePendingAction` is dispatched from the `futureMiddleware` for consumption by the `Reducer`.

# Usage:

```dart
main() {
    // First, create an action to uniquely identify each FutureAction from others.
    class ExampleAction {}

    // Then, create a reducer that knows how to handle the future actions
    String exampleReducer(String state, dynamic action) {
        if (action is FuturePendingAction<ExampleAction>) {
            return 'Fetching';
        } else if (action is FutureSuccessAction<ExampleAction, String>) {
            return action.payload;
        } else if (action is FuturePendingAction<ExampleAction>) {
            return action.error.toString();
        }

        return state;
    }

    // Next, create a store that includes `futureMiddleware`. It will
    // intercept all `FutureAction` that are dispatched.
    final store = Store(
        exampleReducer,
        middleware: [futureMiddleware],
    );

    // Next, dispatch `FutureAction` for intercepting.
    store.dipatch(FutureAction<ExampleAction, String>(
        future: Future.value('Hi')));
}
```

# Credits:

- [Brian Egan](http://github.com/brianegan), for the inspiration on developing it.
- [Ibrahim Mubarak Hussain](https://github.com/ibrahim-mubarak), for lending a helping hand.
