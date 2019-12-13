library redux_future_middleware;

import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

/// A [Redux] action class primarily used for dispatching an
/// action containing [Future].
///
/// The [FutureAction] takes a [Future] which is needed to be
/// completed and an optional [extras] argument in order to pass
/// any extra information down to every FutureAction which is dipatched.
///
/// The [FutureAction] takes an identifying action and a payload type
/// (defining the return type of [Future]), as generic arguments. These
/// generic arguments are used in creating three actions, i.e.,
/// [FuturePendingAction], [FutureSuccessAction] and [FutureErrorAction],
/// which can be consumed by the [Reducer] defined by the user.
class FutureAction<A, P> {
  FutureAction({@required this.future, this.extras});

  /// The [Future] passed to the action.
  Future<P> future;

  /// The extras which are passed along to the created actions.
  Map<String, dynamic> extras;

  /// This function can be used in debugging to identify the
  /// action dispatched, especially in case of multiple actions
  /// dispatched, if needed.
  @override
  String toString() => "FutureAction[type = $A, future = $future]";

  /// The getter for generated [FuturePendingAction] used by
  /// the Middleware.
  FuturePendingAction<A> get _pendingAction =>
      FuturePendingAction(extras: extras);

  /// The getter for generated [FutureSuccessAction] used by
  /// the Middleware.
  FutureSuccessAction<A, P> get _successAction =>
      FutureSuccessAction<A, P>(extras: extras);

  /// The getter for generated [FutureErrorAction] used by
  /// the Middleware.
  FutureErrorAction<A> get _errorAction => FutureErrorAction<A>(extras: extras);
}

/// An action class which is created by the Middleware for
/// signalling that the current state of [Future] is uncompleted.
class FuturePendingAction<A> {
  FuturePendingAction({this.extras});

  /// A property containing the extras passed by [FutureAction].
  Map<String, dynamic> extras;

  /// This function can be used in debugging to identify the
  /// action dispatched, especially in case of multiple actions
  /// dispatched, if needed.
  @override
  String toString() => "FuturePendingAction[type = $A]";
}

/// An action class which is created by the Middleware for
/// signalling that the current state of [Future] is completed
/// and is successful, this class contains the result of [Future]
/// in [payload] property.
class FutureSuccessAction<A, P> {
  FutureSuccessAction({this.extras});

  /// A property containing the extras passed by [FutureAction].
  Map<String, dynamic> extras;

  /// Property containing the result of [Future] after successful
  /// completion.
  P payload;

  /// This function can be used in debugging to identify the
  /// action dispatched, especially in case of multiple actions
  /// dispatched, if needed.
  @override
  String toString() => "FutureSuccessAction[type = $A, payload = $payload]";
}

/// An action class which is created by the Middleware for
/// signalling that the current state of [Future] is completed
/// and is unsuccessful, this class contains the error by [Future]
/// in [error] property.
class FutureErrorAction<A> {
  FutureErrorAction({this.extras});

  /// A property containing the extras passed by [FutureAction].
  Map<String, dynamic> extras;

  /// Property containing the error by [Future] after unsuccessful
  /// completion.
  dynamic error;

  /// This function can be used in debugging to identify the
  /// action dispatched, especially in case of multiple actions
  /// dispatched, if needed.
  @override
  String toString() => "FutureErrorAction[type = $A, error = $error]";
}

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
/// - If the `Future` passed in `FutureAction` fails, a `FutureErrorAction`
/// will be dispatched containing the error that was returned.
/// - When the `FutureAction` is dipatches, a `FuturePendingAction` is
/// dispatched from the `futureMiddleware` for consumption by the `Reducer`.
void futureMiddleware<State>(
    Store<State> store, dynamic action, NextDispatcher next) {
  if (action is FutureAction) {
    store.dispatch(action._pendingAction);
    action.future.then((dynamic value) {
      store.dispatch(action._successAction..payload = value);
    }).catchError((dynamic error) {
      store.dispatch(action._errorAction..error = error);
    });
  } else {
    next(action);
  }
}

/// A utility function provided for checking if the action passed
/// is of any of the Future Actions created above.
bool isActionOfFutureType<A, P>(dynamic action) {
  return action is FutureAction<A, P> ||
      action is FutureSuccessAction<A, P> ||
      action is FuturePendingAction<A> ||
      action is FutureErrorAction<A>;
}
