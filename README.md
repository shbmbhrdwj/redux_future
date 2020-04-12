# Redux Future Middleware (Dart/Flutter)

![Pub](https://img.shields.io/pub/v/redux_future_middleware)
[![Build Status](https://travis-ci.org/shbmbhrdwj/redux_future.svg?branch=master)](https://travis-ci.org/shbmbhrdwj/redux_future) [![codecov](https://codecov.io/gh/shbmbhrdwj/redux_future/branch/master/graph/badge.svg)](https://codecov.io/gh/shbmbhrdwj/redux_future)

Redux middleware package for handling Dart Futures by creating a FutureAction.

The `futureMiddleware` can be attached to the `Redux` store upon construction.

Once attached, you can `store.dipatch` the `FutureAction`, and the `futureMiddleware` will intercept it.

- If the `Future` passed in `FutureAction` completes successfully, a `FutureSucceededAction` will be dipatched with the result of the `Future`.
- If the `Future` passed in `FutureAction` fails, a `FutureFailedAction` will be dispatched containing the error that was returned.
- When the `FutureAction` dispatches, a `FuturePendingAction` is dispatched from the `futureMiddleware` for consumption by the `Reducer`.

# Usage:

```dart
main() {
    // First, create an appState, which will store the state of the app at any instant.
    class AppState {
        String value;
        String loadingValue;
    }

    // Then, create an action to uniquely identify each FutureAction from others.
    class ExampleAction {}

    // Then, create a reducer that knows how to handle the future actions
    AppState exampleReducer(AppState prevState, dynamic action) {
        if (action is FuturePendingAction<ExampleAction>) {
            return prevState
                        ..loadingValue='Fetching';
        } else if (action is FutureSucceededAction<ExampleAction, String>) {
            return prevState
                        ..value=action.payload
                        ..loadingValue='Done';
        } else if (action is FutureFailedAction<ExampleAction>) {
            return prevState
                        ..loadingValue='Failed';
        }

        return prevState;
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

## Simplifying reducer logic:

This library now ships with a `FutureReducer` utility. This helps in reducing the overall redundant logic that has to be written when creating reducers for `FuturePendingAction` and `FutureFailedAction` with a little bit of setup code.

### Built-in defaults

With built-in defaults the above example can be written as follows:

```dart
class AppState extends BaseState<AppState> {
    String value;
}

FutureReducer<AppState, ExampleAction, String> exampleReducer =
    FutureReducer<AppState, ExampleAction, String>(
    successReducer: successReducer,
);
```

In order to work with built-in defaults, our `AppState` should extend from a `BaseState` class which in turn extends
from `FutureState`. Then the `BaseState` class will become the parent of any state which needs to implement `FutureAction`s. For the above example, the `BaseState` might look like this:

```dart
class BaseState extends FutureState<BaseState> {

    String loadingValue;

    @override
    BaseState updateOnFailed(FutureFailedAction action) => this
        ..loadingValue = "Failed";

    @override
    BaseState updateOnPending(FuturePendingAction action) => this
        ..loadingValue = "Fetching";
}
```

### Custom Defaults:

In order to give more flexibility, if you don't want to use `FutureState` with built-in defaults, you can set your own
default `pendingReducer` and `failedReducer` on `FutureReducerDefaults` class and use your own implementation.

### Situational custom reducers:

Sometimes you may want to use custom `pendingReducer` or `failedReducer` for a specific action. In such scenarioas, you can provide the custom reducer directly when creating the `FutureReducer` instance. These reducers will take precedence over the default ones only for this particular instance.

```dart
FutureReducer<AppState, ExampleAction, String> exampleReducer =
    FutureReducer<AppState, ExampleAction, String>(
    successReducer: successReducer,
    pendingReducer: pendingReducer,
    failedReducer: failedReducer,
);
```

# Credits:

- [Brian Egan](http://github.com/brianegan), for the inspiration on developing it.
- [Ibrahim Mubarak Hussain](https://github.com/ibrahim-mubarak), for lending a helping hand.
