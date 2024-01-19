import 'package:msubyoteshin_20/features/home/provider/current_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/key_code_listener.dart';
import '../../../routes/route_name.dart';
import '/common/utils/dio_client.dart';
import 'package:flutter/material.dart';
import '/common/widgets/fake_item.dart';
import '../../../common/utils/enums.dart';
import '/common/utils/reusable_widget.dart';
import '/common/utils/service_locator.dart';
import '../../../common/models/get_model.dart';
import '../data/service/serie_api_service.dart';
import '/common/widgets/remove_scroll_wave.dart';
import '/features/serie/data/model/serie_model.dart';
import '../../../../common/widgets/poster_item.dart';
import '/features/serie/data/model/serie_response_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Serie extends StatefulWidget {
  final GetModel getModel;
  const Serie({super.key, required this.getModel});

  @override
  State<Serie> createState() => _SerieState();
}

class _SerieState extends State<Serie> {
  int _page = 1;
  bool _initLoading = true;
  bool _hasNextPage = true;
  bool _loadMoreRunning = false;

  final FocusNode _focus = FocusNode();
  final int crossAxisCount = 6;

  final List<ItemScrollController> _scrollControllers = [];
  final ItemScrollController _scrollController = ItemScrollController();
  List<int> countsXLineSaver = [];
  List<SerieModel> series = [];
  int currentX = 0;
  int currentY = 0;
  int focusedIdx = 0;

  late bool _isFocusOnTab;
  late int _currentPage;
  late int _currentTab;

  @override
  void initState() {
    _init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_focus);
    });
    super.initState();
  }

  _init() async {
    var resp = await response();

    if (resp.status == true) {
      series.addAll(resp.data ?? []);
      var movsLength = series.length;

      for (int i = 0; i < ((movsLength / crossAxisCount).ceil()); i++) {
        int itemsCount = (movsLength - ((i + 1) * crossAxisCount) > 0)
            ? crossAxisCount
            : (movsLength - (i * crossAxisCount)).abs();
        ItemScrollController controller = ItemScrollController();
        _scrollControllers.add(controller);
        countsXLineSaver.add(itemsCount);
      }
      setState(() => _initLoading = false);
    } else {
      ///
    }
  }

  Future _scrollToIndexXY(int x, int y) async {
    try {
      _scrollControllers[y].scrollTo(
        index: x,
        duration: const Duration(milliseconds: 400),
        alignment: 0.04,
        curve: Curves.fastOutSlowIn,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    _scrollController.scrollTo(
      index: y,
      alignment: 0.04,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _loadMore() async {
    if (_hasNextPage == true &&
        _initLoading == false &&
        _loadMoreRunning == false) {
      _loadMoreRunning = true;
      _page += 1;

      var resp = await response();

      if (resp.status == true) {
        List<SerieModel> seri = resp.data ?? [];
        if (seri.isNotEmpty) {
          series.addAll(seri);
          //clear old data
          _scrollControllers.clear();
          countsXLineSaver.clear();

          //re-add
          var movsLength = series.length;

          for (int i = 0; i < ((movsLength / crossAxisCount).ceil()); i++) {
            int itemsCount = (movsLength - ((i + 1) * crossAxisCount) > 0)
                ? crossAxisCount
                : (movsLength - (i * crossAxisCount)).abs();
            ItemScrollController controller = ItemScrollController();
            _scrollControllers.add(controller);
            countsXLineSaver.add(itemsCount);
          }

          _loadMoreRunning = false;
          if (seri.length < 20) {
            _hasNextPage = false;
          }
        } else {
          _loadMoreRunning = false;
          _hasNextPage = false;
        }
      } else {
        _loadMoreRunning = false;
      }
      setState(() {});
    } else {
      ///normal scroll
    }
    return;
  }

  Future<SerieResponseModel> response() async {
    SerieResponseModel resp;
    GetModel mod = widget.getModel;

    if (mod.from == From.actor) {
      resp = await SerieApiService(sl<DioClient>().dio).getSerieByActor(
        actorId: mod.actor!,
        page: _page,
      );
    } else if (mod.from == From.genre) {
      resp = await SerieApiService(sl<DioClient>().dio).getSerieByGenre(
        genreId: mod.genre!,
        page: _page,
      );
    } else if (mod.from == From.search) {
      resp = await SerieApiService(sl<DioClient>().dio).getSerieBySearch(
        keyword: mod.keyword!,
        page: _page,
      );
    } else {
      ///all
      resp = await SerieApiService(sl<DioClient>().dio).getSeries(
        page: _page,
      );
    }
    return resp;
  }

  Future<bool> _onWillPop() async {
    if (_currentPage == 2 && _isFocusOnTab == false) {
      focusedIdx = -1;
      currentX = -1;
      currentY = -1;
      changeFocus();
      debugPrint('I am working...');
      return await Future.value(false);
    }
    return await Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Consumer<CurrentProvider>(
        builder: (BuildContext context, CurrentProvider value, Widget? child) {
          _isFocusOnTab = value.isFocusOnTab;
          _currentPage = value.currentPage;
          _currentTab = value.currentTab;
          return KeyCodeListener(
            focusNode: _focus,
            upClick: _upClick,
            downClick: _downClick,
            leftClick: _leftClick,
            rightClick: _rightClick,
            centerClick: _centerClick,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: _initLoading
                  ? ReusableWidget.loading(isCenter: true)
                  : Column(
                      children: [
                        Expanded(
                          child: RmScrollWave(
                            child: ScrollablePositionedList.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount:
                                  (series.length / crossAxisCount).ceil(),
                              scrollDirection: Axis.vertical,
                              itemScrollController: _scrollController,
                              itemBuilder: (context, idx) {
                                int itemsCount = (series.length -
                                            ((idx + 1) * crossAxisCount) >
                                        0)
                                    ? crossAxisCount
                                    : (series.length - (idx * crossAxisCount))
                                        .abs();
                                return _gridLineWidget(idx, itemsCount);
                              },
                            ),
                          ),
                        ),
                        if (_loadMoreRunning)
                          ReusableWidget.loadmoreLoading(
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _gridLineWidget(idx, int itemCount) {
    return Container(
      height: 210,
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      alignment: Alignment.center,
      child: RmScrollWave(
        child: ScrollablePositionedList.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          itemScrollController: _scrollControllers[idx],
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var serie = series[(idx * crossAxisCount) + index];
            return Row(
              children: [
                PosterItem(
                  onTap: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   RouteName.serieDetail,
                    //   arguments: serie,
                    // );
                  },
                  cover: serie.poster,
                  title: serie.title,
                  isFocused: hasFocus(idx, index),
                ),
                if (itemCount < crossAxisCount && index == (itemCount - 1))
                  FakeItem(
                    width: 120,
                    count: crossAxisCount - itemCount,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  hasFocus(int jndex, int index) {
    return currentY == jndex && currentX == index;
  }

  void _upClick() {
    if (_currentPage == 2 && _isFocusOnTab == false) {
      if (currentY == 0) {
        focusedIdx = -1;
        currentX = -1;
        currentY = -1;
        changeFocus();
      } else if (currentY > 0) {
        currentY--;
        _scrollToIndexXY(currentX, currentY);
        focusedIdx = ((currentY * crossAxisCount) + currentX);
      }

      setState(() {});
    }
  }

  void _downClick() async {
    if (_currentPage == 2) {
      if (_initLoading) return;

      if (focusedIdx == -1) {
        changeFocus();
        focusedIdx = 0;
        currentY = 0;
        currentX = 0;
        _scrollToIndexXY(currentX, currentY);
        focusedIdx = ((currentY * crossAxisCount) + currentX);
      } else if ((series.length / crossAxisCount).ceil() - 1 == currentY) {
        debugPrint("End");
      } else {
        currentY++;
        if (currentY >= 0) {
          if (currentX > (countsXLineSaver[currentY] - 1)) {
            currentX = countsXLineSaver[currentY] - 1;
          }
          _scrollToIndexXY(currentX, currentY);
          focusedIdx = ((currentY * crossAxisCount) + currentX);
        } else {
          currentX = 0;
        }

        var remaingY = (series.length / crossAxisCount).ceil() - currentY;
        if (remaingY == 1) {
          await _loadMore();
        }
      }
    }
    setState(() {});
  }

  void _leftClick() {
    if (_currentPage == 2 && _isFocusOnTab == false) {
      if (_initLoading) return;

      if (currentX == 0 && currentY != 0) {
        //start of left
        currentX = crossAxisCount - 1;
        currentY--;
        _scrollToIndexXY(currentX, currentY);
      } else if (currentX == 0 && currentY == 0) {
        //first item
      } else {
        currentX--;
        _scrollToIndexXY(currentX, currentY);
      }
      focusedIdx = ((currentY * crossAxisCount) + currentX);
      setState(() {});
    }
  }

  void _rightClick() async {
    if (_currentPage == 2 && _isFocusOnTab == false) {
      if (_initLoading) return;

      if ((series.length / crossAxisCount).ceil() - 1 == currentY &&
          countsXLineSaver[currentY] - 1 == currentX) {
        debugPrint("No more data...");
      } else if (countsXLineSaver[currentY] - 1 == currentX) {
        //end of right
        currentY++;
        currentX = 0;
        _scrollToIndexXY(currentX, currentY);
      } else {
        currentX++;
        _scrollToIndexXY(currentX, currentY);
      }
      focusedIdx = ((currentY * crossAxisCount) + currentX);
      setState(() {});
      //load more
      var remaingY = (series.length / crossAxisCount).ceil() - currentY;
      if (remaingY == 1) {
        await _loadMore();
      }
    }
  }

  void _centerClick() {
    // if (focusedIdx == -1) {
    //   Navigator.pop(context);
    //   return;
    // }

    // var serie = series[focusedIdx];
    // Navigator.pushNamed(
    //   context,
    //   RouteName.serieDetail,
    //   arguments: serie,
    // );
    if (_currentPage == 2 && _currentTab == 2) {
      if (focusedIdx == -1) {
        changeFocus();
        focusedIdx = 0;
        currentY = 0;
        currentX = 0;
        _scrollToIndexXY(currentX, currentY);
        focusedIdx = ((currentY * crossAxisCount) + currentX);

        setState(() {});
        return;
      }
      var serie = series[focusedIdx];
        Navigator.pushNamed(
          context,
          RouteName.serieDetail,
          arguments: serie,
        );
    }
  }

  void changeFocus() {
    context.read<CurrentProvider>().changFocusOnTab();
  }
}
