import 'package:redux/redux.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';
import 'package:redux_future_middleware/src/actions.dart';
import 'package:redux_future_middleware/src/reducer_defaults.dart';

/// A utitlity [Reducer] class aimed at simplifying the boilerplate
/// written in respective reducers for various [FutureAction]s.
///
/// Usage:
/// {@tool snippet}
///
/// ```dart
/// class CounterState{
///   int value = 0;
/// }
///
/// class IncrementAction {}
///
/// var reducer = FutureReducer<CounterState, IncrementAction, int>
///   (successReducer: successReducer);
///
/// CounterState successReducer(CounterState prevState,
///   FutureSucceededAction<IncrementAction>) {
///     return prevState..value = prevState.value + 1;
/// }
/// ```
/// {@end-tool}
class FutureReducer<State, Action, Payload> extends ReducerClass<State> {
  /// A reducer to handle [FutureSucceededAction].
  final State Function(State, FutureSucceededAction<Action, Payload>)
      successReducer;

  /// A reducer to handle [FutureFailedAction], when you need to use custom
  /// implementation to handle the action. If not null, this will be used
  /// instead of [FutueReducerDefaults.failedReducer].
  final State Function(State, FutureFailedAction<Action>) failedReducer;

  /// A reducer to handle [FuturePendingAction], when you need to use custom
  /// implementation to handle the action. If not null, this will be used
  /// instead of [FutureReducerDefaults.pendingReducer].
  final State Function(State, FuturePendingAction<Action>) pendingReducer;

  /// Creates a [Reducer] which handles the `success`, `pending` and `failed`
  /// state of the [Future] passed to the [FutureMiddleware].
  ///
  /// The [successReducer] must not be null.
  ///
  /// If [pendingReducer] or [failedReducer] is not passsed, then it defaults
  /// to [FutureReducerDefaults.pendingReducer] or [FutureReducerDefaults.failedReducer].
  ///
  factory FutureReducer({
    required State Function(State, FutureSucceededAction<Action, Payload>)
        successReducer,
    State Function(State, FuturePendingAction<Action>)? pendingReducer,
    State Function(State, FutureFailedAction<Action>)? failedReducer,
  }) {
    return FutureReducer._(
      successReducer: successReducer,
      pendingReducer: pendingReducer ??
          ((State state, FuturePendingAction<Action> action) =>
              FutureReducerDefaults.pendingReducer(state, action)),
      failedReducer: failedReducer ??
          ((State state, FutureFailedAction<Action> action) =>
              FutureReducerDefaults.failedReducer(state, action)),
    );
  }

  FutureReducer._({
    required this.successReducer,
    required this.pendingReducer,
    required this.failedReducer,
  });

  State call(State prevState, dynamic action) {
    if (action is FutureSucceededAction<Action, Payload>) {
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
