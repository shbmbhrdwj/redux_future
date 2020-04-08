import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';
import 'package:redux_future_middleware/src/actions.dart';
import 'package:redux_future_middleware/src/reducer_defaults.dart';

/// A utitlity [Reducer] class aiming at simplifying the boilerplate
/// written in respective reducers for various [FutureAction]s.
///
///
class FutureReducer<State, Action, Payload> extends ReducerClass<State> {
  /// A reducer to handle [FutureSuccededAction].
  final State Function(State, FutureSuccededAction<Action, Payload>)
      successReducer;

  /// A reducer to handle [FutureFailedAction], when you need to use custom
  /// implementation to handle the action. This will be used instead of the
  /// [defaultFailedReducer].
  final State Function(State, FutureFailedAction<Action>) failedReducer;

  /// A reducer to handle [FuturePendingAction], when you need to use custom
  /// implementation to handle the action. This will be used instead of the
  /// [defaultPendingReducer].
  final State Function(State, FuturePendingAction<Action>) pendingReducer;

  factory FutureReducer({
    @required
        State Function(State, FutureSuccededAction<Action, Payload>)
            successReducer,
    State Function(State, FuturePendingAction<Action>) pendingReducer,
    State Function(State, FutureFailedAction<Action>) failedReducer,
  }) {
    return FutureReducer._(
      successReducer: successReducer,
      pendingReducer: pendingReducer ?? FutureReducerDefaults.pendingReducer,
      failedReducer: failedReducer ?? FutureReducerDefaults.failedReducer,
    );
  }

  FutureReducer._({
    @required this.successReducer,
    @required this.pendingReducer,
    @required this.failedReducer,
  });

  State call(State prevState, dynamic action) {
    if (action is FutureSuccededAction<Action, Payload>) {
      return successReducer(prevState, action);
    }
    if (action is FuturePendingAction<Action>) {
      return pendingReducer(prevState, action);
    }
    if (action is FutureFailedAction<Action>) {
      return failedReducer(prevState, action);
    }
    return prevState;
  }
}
