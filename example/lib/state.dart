import 'package:built_value/built_value.dart';
import 'package:example/future_app_state.dart';

part 'state.g.dart';

abstract class CounterState
    with FutureAppState
    implements Built<CounterState, CounterStateBuilder> {
  factory CounterState([updates(CounterStateBuilder b)]) = _$CounterState;
  CounterState._();

  int get value;
  // error loadingState

  factory CounterState.initialState() {
    return CounterState((CounterStateBuilder builder) => builder
      ..value = 0
      ..loadingState = 0);
  }
}
