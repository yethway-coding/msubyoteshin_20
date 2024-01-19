import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../common/utils/const.dart';
import '../../../common/utils/dio_client.dart';
import '../../../common/utils/reusable_widget.dart';
import '../../../common/utils/service_locator.dart';
import '../../../common/widgets/actor_item.dart';
import '../../../common/widgets/network_image_view.dart';
import '../../../common/widgets/remove_scroll_wave.dart';
import '../data/model/serie_model.dart';
import '../data/service/serie_api_service.dart';

class SerieDetail extends StatefulWidget {
  const SerieDetail({super.key, required this.serie});
  final SerieModel serie;

  @override
  State<SerieDetail> createState() => _SerieDetailState();
}

class _SerieDetailState extends State<SerieDetail> {
  final _focus = FocusNode();
  final _scrollController = ItemScrollController();
  final _seasonScrollController = ItemScrollController();
  final _episodeScrollController = ItemScrollController();

  int _focusedIdx = -2;
  SerieModel? serie;

  _getDetail() async {
    var resp = await SerieApiService(sl<DioClient>().dio).getSerieDetail(
      id: widget.serie.id!,
    );

    if (resp.status == true) {
      serie = resp.data;
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

  _seasonScrollTo() {
    _seasonScrollController.scrollTo(
      index: _focusedIdx,
      alignment: 0.04,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  _episodeScrollTo() {
    _seasonScrollController.scrollTo(
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
      body: Center(
        child: serie == null
            ? ReusableWidget.loading(isCenter: true)
            : Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  background(
                      url: serie!.backdrop ?? Const.dBackdrop, size: size),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          poster(url: serie!.poster ?? Const.dBackdrop),
                          info(size),
                        ],
                      ),
                      const SizedBox(height: 12),
                      seasonList(),
                      const SizedBox(height: 12),
                      Container(
                        height: 110,
                        child: RmScrollWave(
                            child: ScrollablePositionedList.builder(
                                itemCount: 20,
                                itemScrollController: _episodeScrollController,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, idx) {
                                  return Container(
                                    width: 180,
                                    height: 80,
                                    clipBehavior: Clip.antiAlias,
                                    margin: EdgeInsets.only(right: 14, left: idx == 0 ? 26 : 0),
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: ExtendedNetworkImageProvider(serie!.backdrop ??
                                              Const.dBackdrop), fit: BoxFit.cover),
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                          height: 40,
                                          color: Colors.black.withOpacity(0.5),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Episode',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                  );
                                })),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        height: 110,
                        child: RmScrollWave(
                          child: ScrollablePositionedList.builder(
                            itemCount: serie!.actors?.length ?? 0,
                            itemScrollController: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, idx) {
                              var actor = serie!.actors![idx];
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

  Container seasonList() {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(left: 26),
      child: RmScrollWave(
        child: ScrollablePositionedList.builder(
          itemCount: 20,
          itemScrollController: _seasonScrollController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, idx) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(300),
              ),
              child: Text('Season $idx'),
            );
          },
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
            serie!.genres!.map((genre) => genre.name).join(' • '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            '$rating $releaseYr',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            '${serie!.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '${serie!.overview}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              button(
                  icon: Icons.movie,
                  title: 'Trailer',
                  isFocused: _focusedIdx == -3),
              const SizedBox(width: 10),
              button(
                  icon: Icons.add,
                  title: 'Watch later',
                  isFocused: _focusedIdx == -2),
              const SizedBox(width: 10),
              button(
                  icon: Icons.menu,
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
      height: 30,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 9, right: 12),
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
          const SizedBox(width: 12),
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
    return serie!.rating == null ? "" : "Rating : ${serie!.rating}";
  }

  String get releaseYr {
    return serie!.releaseYear == null ? "" : " | ${serie!.releaseYear}";
  }
}
