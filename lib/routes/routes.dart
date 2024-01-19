import 'package:flutter/cupertino.dart';
import 'package:msubyoteshin_20/features/serie/data/model/serie_model.dart';
import 'package:msubyoteshin_20/features/serie/ui/serie_detail.dart';
import 'package:msubyoteshin_20/routes/route_name.dart';

import '../features/movie/data/model/movie_model.dart';
import '../features/movie/ui/movie_detail.dart';
import '../features/player/vid_player/vid_player.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.movieDetail:
        var mov = settings.arguments as MovieModel;
        return _pageRoute(page: MovieDetail(movie: mov));

      case RouteName.serieDetail:
        var serie = settings.arguments as SerieModel;
        return _pageRoute(page: SerieDetail(serie: serie));

      case RouteName.vidPlayer:
        var map = settings.arguments as Map;
        return _pageRoute(
          page: VidPlayer(
            url: map['url'],
            title: map['title'],
          ),
        );

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
