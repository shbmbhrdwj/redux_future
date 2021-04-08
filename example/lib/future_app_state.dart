import 'package:redux_future_middleware/redux_future_middleware.dart';

class FutureAppState implements FutureState<FutureAppState> {
  String? error;
  int? loadingState;

  @override
  FutureAppState updateOnFailed(action) => this
    ..error = "Some error occured"
    ..loadingState = 1;

  @override
  FutureAppState updateOnPending(action) => this
    ..error = null
    ..loadingState = 2;
}
