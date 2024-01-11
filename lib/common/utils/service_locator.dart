import 'package:get_it/get_it.dart';
import 'dio_client.dart';

GetIt sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
}
