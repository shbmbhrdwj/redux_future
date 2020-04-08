import 'dart:async';

import 'package:redux/redux.dart';
import 'package:test/test.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

class Action {}

void main() {
  group('Future Middleware', () {
    Store<String> store;
    List<String> logs;
    void loggingMiddleware<State>(
        Store<State> store, dynamic action, NextDispatcher next) {
      logs.add(action.toString());
      next(action);
    }

    String futureReducer(String state, dynamic action) {
      if (action is FuturePendingAction<Action>) {
        return action.toString();
      } else if (action is FutureSuccededAction<Action, String>) {
        return action.payload;
      } else if (action is FutureFailedAction) {
        return action.error.toString();
      } else {
        return state;
      }
    }

    setUp(() {
      store = Store<String>(futureReducer, middleware: <Middleware<String>>[
        loggingMiddleware,
        futureMiddleware
      ]);
      logs = <String>[];
    });

    group('FutureAction', () {
      test('can synchronously dispatch a pending action', () {
        final FutureAction<Action, String> action =
            FutureAction<Action, String>(
                future: Future<String>.value("Fetch Complete"));
        store.dispatch(action);
        expect(store.state, FuturePendingAction<Action>().toString());
      });

      test(
          'dispatches a FutureSuccededAction if the future completes successfully',
          () async {
        const String dispatchedAction = "Friend";
        final Future<String> future = Future<String>.value(dispatchedAction);
        final FutureAction<Action, String> action =
            FutureAction<Action, String>(future: future);

        store.dispatch(action);
        await future;
        expect(store.state, dispatchedAction);
      });

      test('dispatches a FutureErrorAction if the future returns an error', () {
        final Exception exception = Exception("Error Message");
        final Future<String> future = Future<String>.error(exception);
        final FutureAction<Action, String> action =
            FutureAction<Action, String>(future: future);

        store.dispatch(action);
        expect(
          future.catchError((_) => store.state),
          completion(contains(exception.toString())),
        );
      });

      test('returns the result of the Future after it has been dispatched',
          () async {
        const String dispatchedAction = "Friend";
        final Future<String> future = Future<String>.value(dispatchedAction);
        final FutureAction<Action, String> action =
            FutureAction<Action, String>(future: future);

        store.dispatch(action);
        expect(await action.future, dispatchedAction);
      });

      test('returns the error of the Future after it has been dispatched',
          () async {
        final Exception exception = Exception("Something bad happened");
        final Future<String> future = Future<String>.error(exception);
        final FutureAction<Action, String> action =
            FutureAction<Action, String>(future: future);

        store.dispatch(action);
        expect(future.catchError((_) => store.state),
            completion(contains(exception.toString())));
      });

      test(
          'Follows the FutureAction -> FuturePendingAction -> FutureSuccededAction logic',
          () async {
        FutureAction<Action, String> action = FutureAction<Action, String>(
            future: Future<String>.value("Friend"));

        store.dispatch(action);
        final String fulfilledAction = await action.future;
        expect(logs, <String>[
          action.toString(),
          FuturePendingAction<Action>().toString(),
          (FutureSuccededAction<Action, String>()..payload = fulfilledAction)
              .toString(),
        ]);
      });
    });

    group('isActionOfFutureType method tests', () {
      test('Should give false for non future type actions', () {
        bool answer = isActionOfFutureType(Action());
        expect(answer, false);
      });

      test(
          'Should give true for any action which is of defined Future Action Type',
          () {
        FutureAction<Action, String> futureAction =
            FutureAction<Action, String>(
                future: Future<String>.value("Friend"));
        FuturePendingAction<Action> futurePendingAction =
            FuturePendingAction<Action>();
        FutureSuccededAction<Action, String> futureSuccededAction =
            FutureSuccededAction<Action, String>();
        FutureFailedAction<String> futureErrorAction =
            FutureFailedAction<String>();

        expect(isActionOfFutureType(futureAction), true);
        expect(isActionOfFutureType(futurePendingAction), true);
        expect(isActionOfFutureType(futureSuccededAction), true);
        expect(isActionOfFutureType(futureErrorAction), true);
      });
    });
  });
}
