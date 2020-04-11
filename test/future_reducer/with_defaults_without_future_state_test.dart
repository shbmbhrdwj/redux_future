import 'package:redux_future_middleware/redux_future_middleware.dart';
import 'package:test/test.dart';

import '../mocks.dart';

class BasicMockState {
  String value;
}

void main() {
  group("When the state provided to built-in reducers is not FutureState", () {
    BasicMockState successReducer(BasicMockState prevState,
        FutureSucceededAction<MockAction, String> action) {
      return prevState..value = action.payload;
    }

    FutureReducer<BasicMockState, MockAction, String> futureReducer =
        FutureReducer<BasicMockState, MockAction, String>(
      successReducer: successReducer,
    );

    test("then default pendingReducer throws error", () {
      final action = FuturePendingAction<MockAction>();

      try {
        futureReducer(BasicMockState(), action);
        fail("pendingReducer did not throw exception");
      } catch (error) {
        expect(error is ArgumentError, true);
      }
    });

    test("then default failedReducer throws error", () {
      final action = FutureFailedAction<MockAction>();

      try {
        futureReducer(BasicMockState(), action);
        fail("failedReducer did not throw exception");
      } catch (error) {
        expect(error is ArgumentError, true);
      }
    });
  });
}
