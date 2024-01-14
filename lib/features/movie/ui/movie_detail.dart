import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:msubyoteshin_20/common/utils/reusable_widget.dart';
import 'package:msubyoteshin_20/common/widgets/network_image_view.dart';
import 'package:msubyoteshin_20/widgets/key_code_listener.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../common/utils/const.dart';
import '../../../common/utils/dio_client.dart';
import '../../../common/utils/service_locator.dart';
import '../data/model/movie_model.dart';
import '../data/service/movie_api_service.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({super.key, required this.movie});
  final MovieModel movie;

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final _focus = FocusNode();
  final _scrollController = ItemScrollController();

  int _focusedIdx = -3;
  MovieModel? mov;

  _getDetail() async {
    var resp = await MovieApiService(sl<DioClient>().dio).getMovieDetail(
      id: widget.movie.id!,
    );

    if (resp.status == true) {
      mov = resp.data;
      setState(() {});
    }
  }

  _scrollTo() {
    _scrollController.scrollTo(
      index: _focusedIdx,
      alignment: 0.04,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_focus);
      _getDetail();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: KeyCodeListener(
        focusNode: _focus,
        upClick: _upClick,
        downClick: _downClick,
        leftClick: _leftClick,
        rightClick: _rightClick,
        centerClick: _centerClick,
        child: mov == null
            ? ReusableWidget.loading(isCenter: true)
            : Stack(
                children: [
                  background(url: mov!.backdrop ?? Const.dBackdrop, size: size),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            poster(url: mov!.poster ?? Const.dBackdrop),
                            info(size),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 20, bottom: 20),
                          height: 130,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Container info(Size size) {
    return Container(
      margin: const EdgeInsets.only(left: 26),
      width: size.width * 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mov!.genres!.map((genre) => genre.name).join(' • '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            '$rating $releaseYr $runTime',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            '${mov!.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '${mov!.overview}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              button(Icons.play_arrow_outlined, 'Play'),
              const SizedBox(width: 10),
              button(Icons.add, 'Watch later'),
              const SizedBox(width: 10),
              button(Icons.info_outline, 'Review'),
            ],
          ),
        ],
      ),
    );
  }

  Padding poster({required String? url}) {
    return Padding(
      padding: const EdgeInsets.only(left: 26),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: NetworkImageView(
          url: url,
          width: 120,
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container button(IconData? icon, String title) {
    return Container(
      width: 100,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Container background({required String url, required Size size}) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExtendedNetworkImageProvider(url),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  String get rating {
    return mov!.rating == null ? "" : "Rating : ${mov!.rating}";
  }

  String get releaseYr {
    return mov!.releaseYear == null ? "" : " | ${mov!.releaseYear}";
  }

  String get runTime {
    return mov!.runtime == null ? " | Unknow Runtime" : " | ${mov!.runtime}";
  }

  void _leftClick() {}

  void _upClick() {}

  void _downClick() {}

  void _rightClick() {}

  void _centerClick() {}
}
