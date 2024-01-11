import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../model/movie_detail_response_model.dart';
import '/features/movie/data/model/movie_response_model.dart';

part 'movie_api_service.g.dart';

@RestApi()
abstract class MovieApiService {
  factory MovieApiService(Dio dio) = _MovieApiService;

  @GET('/movie?page={page}&limit=20&sort=desc')
  Future<MovieResponseModel> getMovies({@Path() int page = 1});

  @GET('/movie/{id}')
  Future<MovieDetailResponseModel> getMovieDetail({@Path() required String id});

  @GET('/movie?page={page}&limit=20&sort=desc&actor={actorId}')
  Future<MovieResponseModel> getMovieByActor({
    @Path() int page = 1,
    @Path() required String actorId,
  });

  @GET('/movie?page={page}&limit=20&sort=desc&genre={genreId}')
  Future<MovieResponseModel> getMovieByGenre({
    @Path() int page = 1,
    @Path() required String genreId,
  });

  @GET('/movie?page={page}&limit=20&sort=desc&search={keyword}')
  Future<MovieResponseModel> getMovieBySearch({
    @Path() int page = 1,
    @Path() required String keyword,
  });
}
