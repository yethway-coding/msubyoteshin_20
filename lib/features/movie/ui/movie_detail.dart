import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:msubyoteshin_20/common/utils/reusable_widget.dart';
import 'package:msubyoteshin_20/common/widgets/choose_url.dart';
import 'package:msubyoteshin_20/common/widgets/network_image_view.dart';
import 'package:msubyoteshin_20/common/widgets/remove_scroll_wave.dart';
import 'package:msubyoteshin_20/common/widgets/key_code_listener.dart';
import 'package:msubyoteshin_20/src/side_sheet.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../common/utils/const.dart';
import '../../../common/utils/dio_client.dart';
import '../../../common/utils/service_locator.dart';
import '../../../common/widgets/actor_item.dart';
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
                alignment: Alignment.bottomLeft,
                children: [
                  background(url: mov!.backdrop ?? Const.dBackdrop, size: size),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          poster(url: mov!.poster ?? Const.dBackdrop),
                          info(size),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        height: 130,
                        child: RmScrollWave(
                          child: ScrollablePositionedList.builder(
                            itemCount: mov!.actors?.length ?? 0,
                            itemScrollController: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, idx) {
                              var actor = mov!.actors![idx];
                              return ActorItem(
                                onTap: () {},
                                actor: actor,
                                margin: idx == 0
                                    ? const EdgeInsets.only(right: 14, left: 26)
                                    : null,
                                isFocused: _focusedIdx == idx,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
              button(
                  icon: Icons.play_arrow_outlined,
                  title: 'Play',
                  isFocused: _focusedIdx == -3),
              const SizedBox(width: 10),
              button(
                  icon: Icons.add,
                  title: 'Watch later',
                  isFocused: _focusedIdx == -2),
              const SizedBox(width: 10),
              button(
                  icon: Icons.info_outline,
                  title: 'Review',
                  isFocused: _focusedIdx == -1),
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

  Container button(
      {required IconData? icon,
      required String title,
      required bool isFocused}) {
    return Container(
      width: 100,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFocused ? Colors.white : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(300),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isFocused ? Colors.black : Colors.white,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isFocused ? Colors.black : Colors.white,
            ),
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

  void _upClick() {
    if (_focusedIdx == -3 || _focusedIdx == -2 || _focusedIdx == -1) {
      // _focusedIdx = -4;
      // setState(() {});
    } else if (!_focusedIdx.toString().startsWith("-")) {
      _focusedIdx = -3;
      setState(() {});
      return;
    }
  }

  void _downClick() {
    if (mov == null) return;
    if (_focusedIdx == -4) {
      _focusedIdx = -3;
      setState(() {});
    } else if (_focusedIdx.toString().startsWith("-")) {
      _focusedIdx = 0;
      setState(() {});
      _scrollTo();
      return;
    }
  }

  void _leftClick() {
    if (mov == null) return;

    if (_focusedIdx.toString().startsWith("-")) {
      if (_focusedIdx == -3) {
        // play now
        // we don't have to go anymore
      } else {
        _focusedIdx--;
        setState(() {});
      }
      return;
    }

    if (_focusedIdx == 0) {
      //  _focusedIdx = tabs.length - 1;
    } else {
      _focusedIdx--;
      setState(() {});
      _scrollTo();
    }
  }

  void _rightClick() {
    if (mov == null) return;

    if (_focusedIdx.toString().startsWith("-")) {
      if (_focusedIdx == -1) {
        // more info
        // we don't have to go anymore
      } else {
        _focusedIdx++;
        setState(() {});
      }
      return;
    }

    if (_focusedIdx == mov!.actors!.length - 1) {
      // _focusedIdx = 0;
    } else {
      _focusedIdx++;
      setState(() {});
      _scrollTo();
    }
  }

  void _centerClick() {
    if (_focusedIdx == -3) {
      SideSheet.right(
        width: 230,
        sheetBorderRadius: 16,
        sheetColor: const Color(0xFF1C222B),
        body: ChooseURL(
          sources: mov!.sources!,
          title: mov!.title ?? "",
        ),
        context: context,
      );
    }
  }
}
