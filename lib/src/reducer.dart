import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_future_middleware/src/actions.dart';
import 'package:redux_future_middleware/src/state.dart';

/// A utitlity [Reducer] class aiming at simplifying the boilerplate
/// written in respective reducers for various [FutureAction]s.
///
///
class FutureReducer<State, Action, Payload> extends ReducerClass<State> {
  static FutureFailedReducer defaultFailedReducer = futureFailedReducer;
  static FuturePendingReducer defaultPendingReducer = futurePendingReducer;

  /// A default reducer to handle [FutureFailedAction], which can only be used
  /// with [FutureState].
  ///
  /// For usage without [FutureState], please check [failedReducer].
  static State futureFailedReducer<State, Action>(
      State prevState, FutureFailedAction<Action> action) {
    if (prevState is FutureState) {
      return prevState.rebuildForError(action);
    }

    throw ArgumentError.notNull(
        "State is not FutureState and Custom FailedReducer is null");
  }

  /// A default reducer to handle [FuturePendingAction], which can only be used
  /// with [FutureState].
  ///
  /// For usage without [FutureState], please check [pendingReducer].
  static State futurePendingReducer<State, Action>(
      State prevState, FuturePendingAction<Action> action) {
    if (prevState is FutureState) {
      return prevState.rebuildForPending(action);
    }
    throw ArgumentError.notNull(
        "State is not FutureState and Custom PendingReducer is null");
  }

  /// A reducer to handle [FutureSuccededAction].
  final State Function(State, FutureSuccededAction<Action, Payload>)
      successReducer;

  /// A reducer to handle [FutureFailedAction], when you need to use custom
  /// implementation to handle the action. This will be used instead of the
  /// [defaultFailedReducer].
  final FutureFailedReducer failedReducer;

  /// A reducer to handle [FuturePendingAction], when you need to use custom
  /// implementation to handle the action. This will be used instead of the
  /// [defaultPendingReducer].
  final FuturePendingReducer pendingReducer;

  FutureReducer({
    @required this.successReducer,
    this.pendingReducer,
    this.failedReducer,
  });

  State call(State prevState, dynamic action) {
    if (action is FutureSuccededAction<Action, Payload>) {
      return successReducer(prevState, action);
    }
    if (action is FuturePendingAction<Action>) {
      return callPendingReducer(prevState, action);
    }
    if (action is FutureFailedAction<Action>) {
      return callFailedReducer(prevState, action);
    }
    return prevState;
  }

  State callFailedReducer(State prevState, FutureFailedAction action) {
    Reducer reducer = failedReducer ?? defaultFailedReducer;
    return reducer(prevState, action);
  }

  State callPendingReducer(State prevState, FuturePendingAction action) {
    Reducer reducer = pendingReducer ?? defaultPendingReducer;
    return reducer(prevState, action);
  }
}

typedef FutureFailedReducer = S Function<S, A>(
    S prevState, FutureFailedAction<A> action);

typedef FuturePendingReducer = S Function<S, A>(
    S prevState, FuturePendingAction<A> action);
