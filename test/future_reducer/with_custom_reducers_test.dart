import 'package:redux_future_middleware/redux_future_middleware.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  group("When Future Reducers is given custom reducers", () {
    String pendingString = "Pending from custom";
    String errorString = "Something bad happened from custom";

    MockState pendingReducer(
        MockState prevState, FuturePendingAction<MockAction> action) {
      return prevState..value = pendingString;
    }

    MockState failedReducer(
        MockState prevState, FutureFailedAction<MockAction> action) {
      return prevState..value = action.error.toString();
    }

    FutureReducer<MockState, MockAction, String> futureReducer =
        FutureReducer<MockState, MockAction, String>(
            successReducer: successReducer,
            pendingReducer: pendingReducer,
            failedReducer: failedReducer);

    test("then custom pendingReducer sets pendingString", () {
      final action = FuturePendingAction<MockAction>();

      MockState state = futureReducer(MockState(), action);

      expect(state.value, pendingString);
    });

    test("then custom errorReducer sets errorString", () {
      final Exception exception = Exception(errorString);
      final action = FutureFailedAction<MockAction>()..error = exception;

      MockState state = futureReducer(MockState(), action);

      expect(state.value, exception.toString());
    });
  });
}
