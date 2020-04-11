import 'package:redux_future_middleware/src/actions.dart';

abstract class FutureState<State extends FutureState<State>> {
  State updateOnFailed(FutureFailedAction action);
  State updateOnPending(FuturePendingAction action);
}
