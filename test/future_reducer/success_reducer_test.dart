import 'package:redux_future_middleware/redux_future_middleware.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test("FutureReducer calls successReducer when FutureSuccessAction is passed",
      () {
    FutureReducer<MockState, MockAction, String> futureReducer =
        FutureReducer<MockState, MockAction, String>(
      successReducer: successReducer,
    );
    final expectedValue = "Success";
    final FutureSucceededAction<MockAction, String> action =
        FutureSucceededAction<MockAction, String>(expectedValue);

    var newState = futureReducer(MockState(), action);

    expect(newState.value, expectedValue);
  });
}
