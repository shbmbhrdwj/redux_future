import 'package:built_value/built_value.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

part 'future_app_state.g.dart';

@BuiltValue(instantiable: false)
abstract class FutureAppState implements FutureState {
  @nullable
  String get error;
  int get loadingState;
}

abstract class FutureAppStateRebuildMixin {
  FutureAppState rebuild(void Function(FutureAppStateBuilder) updates);

  FutureAppStateBuilder toBuilder();

  rebuildForError(action) {
    return rebuild((builder) => builder
      ..error = "Some Error"
      ..loadingState = 1);
  }

  rebuildForPending(action) {
    return rebuild((builder) => builder
      ..error = null
      ..loadingState = 2);
  }
}
