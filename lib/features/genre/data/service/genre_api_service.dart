import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '/features/genre/data/model/genre_response_model.dart';
part 'genre_api_service.g.dart';

@RestApi()
abstract class GenreApiService {
  factory GenreApiService(Dio dio) = _GenreApiService;

  @GET('/genre?page={page}&limit=20&sort=desc')
  Future<GenreResponseModel> getGenres({@Path() int page = 1});
}
