import 'package:redux_future_middleware/src/actions.dart';
import 'package:redux_future_middleware/src/state.dart';

/// A class holding the defaults for [FutureReducer].
class FutureReducerDefaults {
  /// A field defining the default pending reducer to be used. It defaults
  /// to [FutureReducerDefaults.futurePendingReducer].
  static State Function<State, Action>(State, FuturePendingAction<Action>)
      pendingReducer = futurePendingReducer;

  /// A field defining the default failed reducer to be used. It defaults
  /// to [FutureReducerDefaults.futureFailedReducer].
  static State Function<State, Action>(State, FutureFailedAction<Action>)
      failedReducer = futureFailedReducer;

  /// A default reducer to handle [FuturePendingAction], which can only be used
  /// with a State extending [FutureState].
  ///
  /// For usage without [FutureState], please check [pendingReducer] and
  /// [FutureReducer.pendingReducer].
  static State futurePendingReducer<State, Action>(
      State prevState, FuturePendingAction<Action> action) {
    if (prevState is FutureState) {
      return prevState.updateOnPending(action) as State;
    }
    throw ArgumentError.notNull(
        "State is not FutureState and Custom PendingReducer is null");
  }

  /// A default reducer to handle [FutureFailedAction], which can only be used
  /// with a State extending [FutureState].
  ///
  /// For usage without [FutureState], please check [failedReducer] and
  /// [FutureReducer.failedReducer].
  static State futureFailedReducer<State, Action>(
      State prevState, FutureFailedAction<Action> action) {
    if (prevState is FutureState) {
      return prevState.updateOnFailed(action) as State;
    }

    throw ArgumentError.notNull(
        "State is not FutureState and Custom FailedReducer is null");
  }
}
