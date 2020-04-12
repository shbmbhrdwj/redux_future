import 'package:redux_future_middleware/redux_future_middleware.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  group("When FutureReducer is run with custom defaults", () {
    FutureReducer<MockState, MockAction, String> futureReducer =
        FutureReducer<MockState, MockAction, String>(
      successReducer: successReducer,
    );

    test("then the custom default pendingReducer is called", () {
      bool pendingReducerCalled = false;
      final FuturePendingAction<MockAction> action =
          FuturePendingAction<MockAction>();
      FutureReducerDefaults.pendingReducer =
          <State, Action>(State prevState, FuturePendingAction<Action> action) {
        pendingReducerCalled = true;
        return prevState;
      };

      futureReducer(MockState(), action);

      expect(pendingReducerCalled, true);
    });

    test("then the custom default failedReducer is called", () async {
      bool failedReducerCalled = false;
      final Exception exception = Exception("Something bad happened");
      final action = FutureFailedAction<MockAction>()..error = exception;
      FutureReducerDefaults.failedReducer =
          <State, Action>(State prevState, FutureFailedAction<Action> action) {
        failedReducerCalled = true;
        return prevState;
      };

      futureReducer(MockState(), action);

      expect(failedReducerCalled, true);
    });

    tearDown(() {
      FutureReducerDefaults.pendingReducer =
          FutureReducerDefaults.futurePendingReducer;
      FutureReducerDefaults.failedReducer =
          FutureReducerDefaults.futureFailedReducer;
    });
  });
}
