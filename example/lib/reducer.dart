import 'package:example/state.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

class Increment {}

class CounterReducer {
  static Function reduce = FutureReducer<CounterState, Increment, int>(
      successReducer: successReducer);

  static CounterState successReducer(CounterState state, action) {
    print(state.loadingState);
    return state.rebuild((builder) => builder
      ..value = state.value + 1
      ..loadingState = 3
      ..build());
  }
}
