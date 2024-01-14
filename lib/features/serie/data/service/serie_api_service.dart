import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../model/serie_response_model.dart';
import '../model/episode_response_model.dart';
import '/features/serie/data/model/serie_detail_response_model.dart';
part 'serie_api_service.g.dart';

@RestApi()
abstract class SerieApiService {
  factory SerieApiService(Dio dio) = _SerieApiService;

  @GET('/serie?page={page}&limit=20&sort=desc')
  Future<SerieResponseModel> getSeries({@Path() int page = 1});

  @GET('/serie/{id}')
  Future<SerieDetailResponseModel> getSerieDetail({@Path() required String id});

  @POST('/serie/episode?page={page}&limit=20&sort=asc')
  Future<EpisodeResponseModel> getEpisode({
    @Body() required Map<String, dynamic> body,
    @Path() int page = 1,
  });

  @GET('/serie?page={page}&limit=20&sort=desc&actor={actorId}')
  Future<SerieResponseModel> getSerieByActor({
    @Path() int page = 1,
    @Path() required String actorId,
  });

  @GET('/serie?page={page}&limit=20&sort=desc&genre={genreId}')
  Future<SerieResponseModel> getSerieByGenre({
    @Path() int page = 1,
    @Path() required String genreId,
  });

  @GET('/serie?page={page}&limit=20&sort=desc&search={keyword}')
  Future<SerieResponseModel> getSerieBySearch({
    @Path() int page = 1,
    @Path() required String keyword,
  });
}
