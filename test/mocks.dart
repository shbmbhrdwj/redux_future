import 'package:redux_future_middleware/src/actions.dart';
import 'package:redux_future_middleware/src/state.dart';

class MockState extends FutureState<MockState> {
  String? value;

  @override
  MockState updateOnFailed(action) {
    return this..value = action.error.toString();
  }

  @override
  MockState updateOnPending(action) {
    return this..value = "Loading.";
  }
}

class MockAction {}

MockState successReducer(
    MockState prevState, FutureSucceededAction<MockAction, String> action) {
  return prevState..value = action.payload;
}
