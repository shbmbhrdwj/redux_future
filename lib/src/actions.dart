/// A [Redux] action class primarily used for dispatching an
/// action containing [Future].
///
/// The [FutureAction] takes a [Future] which is needed to be
/// completed and an optional [extras] argument in order to pass
/// any extra information down to every FutureAction which is dipatched.
///
/// The [FutureAction] takes an identifying action and a payload type
/// (defining the return type of [Future]), as generic arguments. These
/// generic arguments are used in creating three actions, i.e.,
/// [FuturePendingAction], [FutureSucceededAction] and [FutureFailedAction],
/// which can be consumed by the [Reducer] defined by the user.
class FutureAction<A, P> {
  FutureAction({
    required this.future,
    this.extras = const {},
  });

  /// The [Future] passed to the action.
  Future<P> future;

  /// The extras which are passed along to the created actions.
  Map<String, dynamic> extras;

  /// This function can be used in debugging to identify the
  /// action dispatched, especially in case of multiple actions
  /// dispatched, if needed.
  @override
  String toString() => "FutureAction[type = $A, future = $future]";

  /// This function is used to convert the action into FSA format
  /// This is useful for interoperability between different redux modules
  Map<String, dynamic> toJson() {
    return {
      "type": "FutureAction<$A, $P>",
      "meta": {
        "future_action_type": A.toString(),
        "future_payload_type": P.toString(),
        "extras": extras,
      }
    };
  }

  /// The getter for generated [FuturePendingAction] used by
  /// the Middleware.
  FuturePendingAction<A> get pendingAction =>
      FuturePendingAction(extras: extras);

  /// The getter for generated [FutureSucceededAction] used by
  /// the Middleware.
  FutureSucceededAction<A, P> succeededWith(P payload) =>
      FutureSucceededAction<A, P>(payload, extras: extras);

  /// The getter for generated [FutureFailedAction] used by
  /// the Middleware.
  FutureFailedAction<A> failedWith(dynamic error) =>
      FutureFailedAction<A>(error: error, extras: extras);
}

/// An action class which is created by the Middleware for
/// signalling that the current state of [Future] is incomplete.
class FuturePendingAction<A> {
  FuturePendingAction({this.extras = const {}});

  /// A property containing the extras passed by [FutureAction].
  Map<String, dynamic> extras;

  /// This function can be used in debugging to identify the
  /// action dispatched, especially in case of multiple actions
  /// dispatched, if needed.
  @override
  String toString() => "FuturePendingAction[type = $A]";

  /// This function is used to convert the action into FSA format
  /// This is useful for interoperability between different redux modules
  Map<String, dynamic> toJson() {
    return {
      "type": "FuturePendingAction<$A>",
      "meta": {
        "future_action_type": A.toString(),
        "extras": extras,
      }
    };
  }
}

/// An action class which is created by the Middleware for
/// signalling that the current state of [Future] is completed
/// and is successful, this class contains the result of [Future]
/// in [payload] property.
class FutureSucceededAction<A, P> {
  FutureSucceededAction(this.payload, {this.extras = const {}});

  /// A property containing the extras passed by [FutureAction].
  Map<String, dynamic> extras;

  /// Property containing the result of [Future] after successful
  /// completion.
  P payload;

  /// This function can be used in debugging to identify the
  /// action dispatched, especially in case of multiple actions
  /// dispatched, if needed.
  @override
  String toString() => "FutureSucceededAction[type = $A, payload = $payload]";

  /// This function is used to convert the action into FSA format
  /// This is useful for interoperability between different redux modules
  Map<String, dynamic> toJson() {
    return {
      "type": "FutureSucceededAction<$A, $P>",
      "payload": payload,
      "meta": {
        "future_action_type": A.toString(),
        "future_payload_type": P.toString(),
        "extras": extras,
      }
    };
  }
}

/// An action class which is created by the Middleware for
/// signalling that the current state of [Future] is completed
/// and is unsuccessful, this class contains the error by [Future]
/// in [error] property.
class FutureFailedAction<A> {
  FutureFailedAction({this.extras = const {}, this.error});

  /// A property containing the extras passed by [FutureAction].
  Map<String, dynamic> extras;

  /// Property containing the error by [Future] after unsuccessful
  /// completion.
  dynamic error;

  /// This function can be used in debugging to identify the
  /// action dispatched, especially in case of multiple actions
  /// dispatched, if needed.
  @override
  String toString() => "FutureFailedAction[type = $A, error = $error]";

  /// This function is used to convert the action into FSA format
  /// This is useful for interoperability between different redux modules
  Map<String, dynamic> toJson() {
    return {
      "type": "FutureFailedAction<$A>",
      "error": error,
      "meta": {
        "future_action_type": A.toString(),
        "extras": extras,
      }
    };
  }
}
