import 'package:built_value/built_value.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

abstract class FutureAppState implements FutureState {
  @nullable
  String get error;
  int get loadingState;

  FutureAppState rebuild(void Function(dynamic) updates);

  @override
  rebuildForError(action) {
    return rebuild((builder) => builder
      ..error = "Some Error"
      ..loadingState = 1
      ..build());
  }

  @override
  rebuildForPending(action) {
    return rebuild((builder) => builder
      ..error = null
      ..loadingState = 2
      ..build());
  }
}
