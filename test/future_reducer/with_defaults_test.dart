import 'package:redux_future_middleware/redux_future_middleware.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  group("When FutureReducer is run with built in defaults", () {
    FutureReducer<MockState, MockAction, String> futureReducer =
        FutureReducer<MockState, MockAction, String>(
      successReducer: successReducer,
    );

    test("then default pendingReducer is called", () {
      final action = FuturePendingAction<MockAction>();

      MockState newState = futureReducer(MockState(), action);

      expect(newState.value, "Loading.");
    });

    test("then default failedReducer is called", () {
      final Exception exception = Exception("Something bad happened");
      final action = FutureFailedAction<MockAction>()..error = exception;

      MockState newState = futureReducer(MockState(), action);

      expect(newState.value, exception.toString());
    });
  });
}
