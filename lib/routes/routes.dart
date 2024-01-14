import 'package:flutter/cupertino.dart';
import 'package:msubyoteshin_20/routes/route_name.dart';

import '../features/movie/data/model/movie_model.dart';
import '../features/movie/ui/movie_detail.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.movieDetail:
        var mov = settings.arguments as MovieModel;
        return _pageRoute(page: MovieDetail(movie: mov));

      default:
        return null;
    }
  }

  static CupertinoPageRoute _pageRoute(
      {required Widget page, RouteSettings? settings}) {
    return CupertinoPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
