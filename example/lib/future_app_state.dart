import 'package:redux_future_middleware/redux_future_middleware.dart';

class FutureAppState implements FutureState {
  String error;
  int loadingState = 0;

  @override
  rebuildForError(action) {
    error = "Some error occurred";
    loadingState = 3;
    return this;
  }

  @override
  rebuildForPending(action) {
    error = null;
    loadingState = 1;
    return this;
  }
}
