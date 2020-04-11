// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterState extends CounterState {
  @override
  final int value;
  @override
  final String error;
  @override
  final int loadingState;

  factory _$CounterState([void Function(CounterStateBuilder) updates]) =>
      (new CounterStateBuilder()..update(updates)).build();

  _$CounterState._({this.value, this.error, this.loadingState}) : super._() {
    if (value == null) {
      throw new BuiltValueNullFieldError('CounterState', 'value');
    }
    if (loadingState == null) {
      throw new BuiltValueNullFieldError('CounterState', 'loadingState');
    }
  }

  @override
  CounterState rebuild(void Function(CounterStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterStateBuilder toBuilder() => new CounterStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterState &&
        value == other.value &&
        error == other.error &&
        loadingState == other.loadingState;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, value.hashCode), error.hashCode), loadingState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CounterState')
          ..add('value', value)
          ..add('error', error)
          ..add('loadingState', loadingState))
        .toString();
  }
}

class CounterStateBuilder
    implements Builder<CounterState, CounterStateBuilder> {
  _$CounterState _$v;

  int _value;
  int get value => _$this._value;
  set value(int value) => _$this._value = value;

  String _error;
  String get error => _$this._error;
  set error(String error) => _$this._error = error;

  int _loadingState;
  int get loadingState => _$this._loadingState;
  set loadingState(int loadingState) => _$this._loadingState = loadingState;

  CounterStateBuilder();

  CounterStateBuilder get _$this {
    if (_$v != null) {
      _value = _$v.value;
      _error = _$v.error;
      _loadingState = _$v.loadingState;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CounterState;
  }

  @override
  void update(void Function(CounterStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CounterState build() {
    final _$result = _$v ??
        new _$CounterState._(
            value: value, error: error, loadingState: loadingState);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
