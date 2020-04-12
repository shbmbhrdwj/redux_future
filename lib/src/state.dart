import 'package:redux_future_middleware/src/actions.dart';

/// Extend this class to create a base state class which handles
/// the update logic for [FuturePendingAction] and [FutureFailedAction] for
/// all the inheriting classes.
abstract class FutureState<State extends FutureState<State>> {
  /// Implement this method to update the state
  /// when [FutureFailedAction] is passed.
  State updateOnFailed(FutureFailedAction action);

  /// Implement this method to update the state
  /// when [FuturePendingAction] is passed.
  State updateOnPending(FuturePendingAction action);
}
