import 'package:meta/meta.dart';
import 'package:redux_future_middleware/future_state.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

class FutureReducer<State extends FutureState, Action, Payload> {
  static FutureFailedReducer failedReducer = futureFailedReducer;
  static FuturePendingReducer pendingReducer = futurePendingReducer;

  static State futureFailedReducer<State extends FutureState, Action>(
      State prevState, FutureErrorAction<Action> action) {
    return prevState.rebuildForError(action);
  }

  static State futurePendingReducer<State extends FutureState, Action>(
      State prevState, FuturePendingAction<Action> action) {
    return prevState.rebuildForPending(action);
  }

  final State Function(State, Action) successReducer;

  FutureReducer(this.successReducer);

  State call(state, action) {
    return _futureReducer<State, Action, Payload>(
      action: action,
      prevState: state,
      successReducer: successReducer,
      failedReducer: failedReducer,
      pendingReducer: pendingReducer,
    );
  }

  State _futureReducer<State extends FutureState, Action, Payload>({
    @required State prevState,
    @required dynamic action,
    @required Function successReducer,
    FuturePendingReducer pendingReducer,
    FutureFailedReducer failedReducer,
  }) {
    if (action is FutureSuccessAction<Action, Payload>) {
      return successReducer(prevState, action);
    }
    if (action is FuturePendingAction<Action>) {
      return pendingReducer(prevState, action);
    }
    if (action is FutureErrorAction<Action>) {
      return failedReducer(prevState, action);
    }
    return prevState;
  }
}

typedef FutureFailedReducer = S Function<S extends FutureState, A>(
    S prevState, FutureErrorAction<A> action);

typedef FuturePendingReducer = S Function<S extends FutureState, A>(
    S prevState, FuturePendingAction<A> action);
