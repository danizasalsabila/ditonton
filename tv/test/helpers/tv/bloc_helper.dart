import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:tv/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/tv/get_popular_tv.dart';
import 'package:tv/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/tv/get_watchlist_tv.dart';

@GenerateMocks([
  GetNowPlayingTv,
  GetPopularTv,
  GetTvRecommendations,
  GetTopRatedTv,
  GetWatchlistTv,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
