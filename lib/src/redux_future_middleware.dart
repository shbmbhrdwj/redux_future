library redux_future_middleware;

import 'package:redux/redux.dart';
import 'package:redux_future_middleware/src/actions.dart';

/// A [Redux] middleware for handling Dart Futures by creating
/// a FutureAction.
///
/// The [futureMiddleware] can be attached to the [Redux] store
/// upon construction.
///
/// Once attached, you can [store.dipatch] the [FutureAction],
/// and the [futureMiddleware] will intercept it.
///
/// - If the `Future` passed in `FutureAction` completes successfully, a
/// `FutureSuccessAction` will be dipatched with the result of the `Future`.
/// - If the `Future` passed in `FutureAction` fails, a `FutureFailedAction`
/// will be dispatched containing the error that was returned.
/// - When the `FutureAction` is dipatches, a `FuturePendingAction` is
/// dispatched from the `futureMiddleware` for consumption by the `Reducer`.
void futureMiddleware<State>(
    Store<State> store, dynamic action, NextDispatcher next) {
  if (action is! FutureAction) {
    next(action);
    return;
  }
  _dispatchFutureAction<State>(store, action);
}

_dispatchFutureAction<State>(Store<State> store, FutureAction action) {
  Function(dynamic) dispatch = store.dispatch;
  dispatch(action.pendingAction);

  action.future
      .then((value) => dispatch(action.successAction..payload = value))
      .catchError((error) => dispatch(action.failedAction..error = error));
}

/// A utility function provided for checking if the action passed
/// is of any of the Future Actions created above.
bool isActionOfFutureType<A, P>(dynamic action) {
  return action is FutureAction<A, P> ||
      action is FutureSucceededAction<A, P> ||
      action is FuturePendingAction<A> ||
      action is FutureFailedAction<A>;
}
