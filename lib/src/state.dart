abstract class FutureState<State> {
  State rebuildForError(dynamic action);
  State rebuildForPending(dynamic action);
}
