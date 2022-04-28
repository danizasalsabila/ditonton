// Mocks generated by Mockito 5.1.0 from annotations
// in movie/test/presentation/pages/top_rated_movies_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:bloc/bloc.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:tv/presentation/bloc/watchlist/bloc/watchlist_tv_bloc.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeWatchlistTvState_0 extends _i1.Fake
    implements _i2.WatchlistTvState {}

/// A class which mocks [WatchlistTvBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockWatchlistTvBloc extends _i1.Mock
    implements _i2.WatchlistTvBloc {
  MockWatchlistTvBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WatchlistTvState get state => (super.noSuchMethod(
      Invocation.getter(#state),
      returnValue: _FakeWatchlistTvState_0()) as _i2.WatchlistTvState);
  @override
  _i3.Stream<_i2.WatchlistTvState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i2.WatchlistTvState>.empty())
          as _i3.Stream<_i2.WatchlistTvState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  _i4.EventTransformer<T> debounce<T>(Duration? duration) =>
      (super.noSuchMethod(Invocation.method(#debounce, [duration]),
          returnValue: (_i3.Stream<T> events, _i4.EventMapper<T> mapper) =>
              Stream<T>.empty()) as _i4.EventTransformer<T>);
  @override
  void add(_i2.WatchlistTvEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i2.WatchlistTvEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i2.WatchlistTvState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i2.WatchlistTvEvent>(
          _i4.EventHandler<E, _i2.WatchlistTvState>? handler,
          {_i4.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i4.Transition<_i2.WatchlistTvEvent, _i2.WatchlistTvState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i3.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  void onChange(_i4.Change<_i2.WatchlistTvState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}
