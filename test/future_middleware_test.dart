import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';
import 'package:test/test.dart';

class Action {}

void main() {
  group('Future Middleware', () {
    late Store<String?> store;
    late List<String> logs;
    void loggingMiddleware<State>(
        Store<State> store, dynamic action, NextDispatcher next) {
      logs.add(action.toString());
      next(action);
    }

    String? futureReducer(String? state, dynamic action) {
      if (action is FuturePendingAction<Action>) {
        return action.toString();
      }
      if (action is FutureSucceededAction<Action, String>) {
        return action.payload;
      }
      if (action is FutureFailedAction) {
        return action.error.toString();
      }
      {
        return state;
      }
    }

    setUp(() {
      store = Store<String?>(
        futureReducer,
        middleware: <Middleware<String?>>[
          loggingMiddleware,
          futureMiddleware,
        ],
        initialState: null,
      );
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
          'dispatches a FutureSucceededAction if the future completes successfully',
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
        final Future<String?> future = Future<String?>.error(exception);
        final FutureAction<Action, String?> action =
            FutureAction<Action, String?>(future: future);

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
        final Future<String?> future = Future<String?>.error(exception);
        final FutureAction<Action, String?> action =
            FutureAction<Action, String?>(future: future);

        store.dispatch(action);
        expect(future.catchError((_) => store.state),
            completion(contains(exception.toString())));
      });

      test(
          'Follows the FutureAction -> FuturePendingAction -> FutureSucceededAction logic',
          () async {
        FutureAction<Action, String> action = FutureAction<Action, String>(
            future: Future<String>.value("Friend"));

        store.dispatch(action);
        final String fulfilledAction = await action.future;
        expect(logs, <String>[
          action.toString(),
          FuturePendingAction<Action>().toString(),
          (FutureSucceededAction<Action, String>(fulfilledAction)).toString(),
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
        FutureSucceededAction<Action, String> futureSucceededAction =
            FutureSucceededAction<Action, String>("");
        FutureFailedAction<String> futureFailedAction =
            FutureFailedAction<String>();

        expect(isActionOfFutureType(futureAction), true);
        expect(isActionOfFutureType(futurePendingAction), true);
        expect(isActionOfFutureType(futureSucceededAction), true);
        expect(isActionOfFutureType(futureFailedAction), true);
      });
    });
  });
}
