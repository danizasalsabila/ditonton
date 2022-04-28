import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv/tv_detail.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/domain/usecases/tv/get_tv_detail.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/tv/remove_watchlist.dart';
import 'package:tv/domain/usecases/tv/save_watchlist.dart';
import 'package:tv/presentation/bloc/tv_detail/bloc/tv_detail_bloc.dart';

import '../../dummy_data/tv/dummy_objects_tv.dart';
import 'tv_detail_bloc_test.mocks.dart';


@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatusTv mockGetWatchlistStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;
      late int listenerCallCount;



  setUp(() {
    mockGetTvDetail = MockGetTvDetail();

    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();
    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;
  final tvDetailStateInit = TvDetailState.initial();
  final tTv = Tv(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvSeries = <Tv>[tTv];

  final tTvDetail = TvDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
  );


  group(
    'Get Tv Detail',
    () {
      blocTest<TvDetailBloc, TvDetailState>(
        'Should change Tv when data is gotten succesfully',
        build: () {
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvDetail));
          when(mockGetTvRecommendations.execute(tId))
              .thenAnswer((_) async => Right(tTvSeries));
          return bloc;
        },
        act: (bloc) => bloc.add( OnFetchTvDetail(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
          tvDetailStateInit.copyWith(
            tvRecommendationState: RequestState.Loading,
            tvDetail: tTvDetail,
            tvDetailState: RequestState.Loaded,
            message: '',
          ),
          tvDetailStateInit.copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: tTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: tTvSeries,
            message: '',
          ),
        ],
        verify: (bloc) {
          mockGetTvDetail.execute(tId);
          mockGetTvRecommendations.execute(tId);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should return Error when data is failed',
        build: () {
          when(mockGetTvDetail.execute(tId)).thenAnswer(
              (_) async =>  Left(ServerFailure('Server Failure')));
          when(mockGetTvRecommendations.execute(tId)).thenAnswer(
              (_) async =>  Left(ServerFailure('Server Failure')));
          return bloc;
        },
        act: (bloc) => bloc.add( OnFetchTvDetail(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
          tvDetailStateInit.copyWith(
            tvRecommendationState: RequestState.Empty,
            tvDetailState: RequestState.Error,
          ),
        ],
        verify: (bloc) {
          mockGetTvDetail.execute(tId);
        },
      );
    },
  );

  group(
    'Watchlist',
    () {
      blocTest<TvDetailBloc, TvDetailState>(
        'Should get the watchlist status',
        build: () {
          when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) => bloc.add( OnLoadWatchlistStatus(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(isAddedToWatchlist: true),
        ],
        verify: (bloc) {
          mockGetWatchlistStatus.execute(1);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit watchlistmessage and add the watchlist when added to watchlist',
        build: () {
          when(mockSaveWatchlist.execute(testTvDetail))
              .thenAnswer((_) async =>  Right('Success'));
          when(mockGetWatchlistStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnAddWatchlist(testTvDetail));
        },
        wait:  Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(watchlistMessage: 'Success'),
          tvDetailStateInit.copyWith(
              isAddedToWatchlist: true, watchlistMessage: 'Success'),
        ],
        verify: (bloc) {
          mockSaveWatchlist.execute(testTvDetail);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit failed to add into watchlist when failed',
        build: () {
          when(mockSaveWatchlist.execute(testTvDetail))
              .thenAnswer((_) async =>  Left(Failed('')));
          when(mockGetWatchlistStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) {
          bloc.add(OnAddWatchlist(testTvDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: ''),
        ],
        verify: (bloc) {
          mockSaveWatchlist.execute(testTvDetail);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit watchlistmessage and remove the watchlist when removed from watchlist',
        build: () {
          when(mockRemoveWatchlist.execute(tTvDetail))
              .thenAnswer((_) async => const Right('Success'));
          when(mockGetWatchlistStatus.execute(tTvDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnRemoveWatchlist(tTvDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: 'Success'),
        ],
        verify: (bloc) {
          mockRemoveWatchlist.execute(tTvDetail);
          mockGetWatchlistStatus.execute(tTvDetail.id);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit failed when fail to remove watchlist',
        build: () {
          when(mockRemoveWatchlist.execute(tTvDetail))
              .thenAnswer((_) async => Left(Failed('')));
          when(mockGetWatchlistStatus.execute(tTvDetail.id))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnRemoveWatchlist(tTvDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: ''),
              tvDetailStateInit.copyWith(
              isAddedToWatchlist: true, watchlistMessage: ''),
        ],
        verify: (bloc) {
          mockRemoveWatchlist.execute(tTvDetail);
          mockGetWatchlistStatus.execute(tTvDetail.id);
        },
      );
    },
  );
}





/////////////////////////////////
///// Mocks generated by Mockito 5.1.0 from annotations
// in movie/test/presentation/bloc/movie_detail_bloc_test.dart.
// Do not manually edit this file.

// import 'dart:async' as _i5;

// import 'package:core/utils/failure.dart' as _i6;
// import 'package:dartz/dartz.dart' as _i3;
// import 'package:mockito/mockito.dart' as _i1;
// import 'package:tv/domain/entities/tv/tvseries.dart' as _i9;
// import 'package:tv/domain/entities/tv/tv_detail.dart' as _i7;
// import 'package:tv/domain/repositories/tv/tv_repository.dart' as _i2;
// import 'package:tv/domain/usecases/tv/get_tv_detail.dart' as _i4;
// import 'package:tv/domain/usecases/tv/get_tv_recommendations.dart' as _i8;
// import 'package:tv/domain/usecases/tv/get_watchlist_status_tv.dart' as _i10;
// import 'package:tv/domain/usecases/tv/remove_watchlist.dart' as _i12;
// import 'package:tv/domain/usecases/tv/save_watchlist.dart' as _i11;

// // ignore_for_file: type=lint
// // ignore_for_file: avoid_redundant_argument_values
// // ignore_for_file: avoid_setters_without_getters
// // ignore_for_file: comment_references
// // ignore_for_file: implementation_imports
// // ignore_for_file: invalid_use_of_visible_for_testing_member
// // ignore_for_file: prefer_const_constructors
// // ignore_for_file: unnecessary_parenthesis
// // ignore_for_file: camel_case_types

// class _FakeTvRepository_0 extends _i1.Fake implements _i2.TvRepository {}

// class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

// /// A class which mocks [GetTvDetail].
// ///
// /// See the documentation for Mockito's code generation for more information.
// class MockGetTvDetail extends _i1.Mock implements _i4.GetTvDetail {
//   MockGetTvDetail() {
//     _i1.throwOnMissingStub(this);
//   }

//   @override
//   _i2.TvRepository get repository =>
//       (super.noSuchMethod(Invocation.getter(#repository),
//           returnValue: _FakeTvRepository_0()) as _i2.TvRepository);
//   @override
//   _i5.Future<_i3.Either<_i6.Failure, _i7.TvDetail>> execute(int? id) =>
//       (super.noSuchMethod(Invocation.method(#execute, [id]),
//           returnValue: Future<_i3.Either<_i6.Failure, _i7.TvDetail>>.value(
//               _FakeEither_1<_i6.Failure, _i7.TvDetail>())) as _i5
//           .Future<_i3.Either<_i6.Failure, _i7.TvDetail>>);
// }

// /// A class which mocks [GetTvRecommendations].
// ///
// /// See the documentation for Mockito's code generation for more information.
// class MockGetTvRecommendations extends _i1.Mock
//     implements _i8.GetTvRecommendations {
//   MockGetTvRecommendations() {
//     _i1.throwOnMissingStub(this);
//   }

//   @override
//   _i2.TvRepository get repository =>
//       (super.noSuchMethod(Invocation.getter(#repository),
//           returnValue: _FakeTvRepository_0()) as _i2.TvRepository);
//   @override
//   _i5.Future<_i3.Either<_i6.Failure, List<_i9.Tv>>> execute(dynamic id) =>
//       (super.noSuchMethod(Invocation.method(#execute, [id]),
//           returnValue: Future<_i3.Either<_i6.Failure, List<_i9.Tv>>>.value(
//               _FakeEither_1<_i6.Failure, List<_i9.Tv>>())) as _i5
//           .Future<_i3.Either<_i6.Failure, List<_i9.Tv>>>);
// }

// /// A class which mocks [GetWatchListStatus].
// ///
// /// See the documentation for Mockito's code generation for more information.
// class MockGetWatchListStatusTv extends _i1.Mock
//     implements _i10.GetWatchListStatusTv {
//   MockGetWatchListStatusTv() {
//     _i1.throwOnMissingStub(this);
//   }

//   @override
//   _i2.TvRepository get repository =>
//       (super.noSuchMethod(Invocation.getter(#repository),
//           returnValue: _FakeTvRepository_0()) as _i2.TvRepository);
//   @override
//   _i5.Future<bool> execute(int? id) =>
//       (super.noSuchMethod(Invocation.method(#execute, [id]),
//           returnValue: Future<bool>.value(false)) as _i5.Future<bool>);
// }

// /// A class which mocks [SaveWatchlist].
// ///
// /// See the documentation for Mockito's code generation for more information.
// class MockSaveWatchlistTv extends _i1.Mock implements _i11.SaveWatchlistTv {
//   MockSaveWatchlistTv() {
//     _i1.throwOnMissingStub(this);
//   }

//   @override
//   _i2.TvRepository get repository =>
//       (super.noSuchMethod(Invocation.getter(#repository),
//           returnValue: _FakeTvRepository_0()) as _i2.TvRepository);
//   @override
//   _i5.Future<_i3.Either<_i6.Failure, String>> execute(_i7.TvDetail? tv) =>
//       (super.noSuchMethod(Invocation.method(#execute, [tv]),
//               returnValue: Future<_i3.Either<_i6.Failure, String>>.value(
//                   _FakeEither_1<_i6.Failure, String>()))
//           as _i5.Future<_i3.Either<_i6.Failure, String>>);
// }

// /// A class which mocks [RemoveWatchlist].
// ///
// /// See the documentation for Mockito's code generation for more information.
// class MockRemoveWatchlistTv extends _i1.Mock implements _i12.RemoveWatchlistTv {
//   MockRemoveWatchlistTv() {
//     _i1.throwOnMissingStub(this);
//   }

//   @override
//   _i2.TvRepository get repository =>
//       (super.noSuchMethod(Invocation.getter(#repository),
//           returnValue: _FakeTvRepository_0()) as _i2.TvRepository);
//   @override
//   _i5.Future<_i3.Either<_i6.Failure, String>> execute(_i7.TvDetail? tv) =>
//       (super.noSuchMethod(Invocation.method(#execute, [tv]),
//               returnValue: Future<_i3.Either<_i6.Failure, String>>.value(
//                   _FakeEither_1<_i6.Failure, String>()))
//           as _i5.Future<_i3.Either<_i6.Failure, String>>);
// }
