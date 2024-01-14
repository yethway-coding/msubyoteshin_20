import 'package:msubyoteshin_20/features/home/provider/current_provider.dart';
import 'package:msubyoteshin_20/routes/route_name.dart';
import 'package:provider/provider.dart';

import '../../../widgets/key_code_listener.dart';
import '/common/utils/enums.dart';
import '/common/models/get_model.dart';
import '/common/utils/dio_client.dart';
import 'package:flutter/material.dart';
import '/common/widgets/fake_item.dart';
import '../data/model/movie_model.dart';
import '/common/utils/reusable_widget.dart';
import '/common/utils/service_locator.dart';
import '/common/widgets/remove_scroll_wave.dart';
import '../../../common/widgets/poster_item.dart';
import '/features/movie/data/service/movie_api_service.dart';
import '/features/movie/data/model/movie_response_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Movie extends StatefulWidget {
  final GetModel getModel;
  const Movie({super.key, required this.getModel});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  int _page = 1;
  bool _initLoading = true;
  bool _hasNextPage = true;
  bool _loadMoreRunning = false;

  final FocusNode _focus = FocusNode();
  final int crossAxisCount = 6;

  final List<ItemScrollController> _scrollControllers = [];
  final ItemScrollController _scrollController = ItemScrollController();
  List<int> countsXLineSaver = [];
  List<MovieModel> movies = [];
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
      movies.addAll(resp.data ?? []);
      var movsLength = movies.length;

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
        List<MovieModel> movs = resp.data ?? [];
        if (movs.isNotEmpty) {
          movies.addAll(movs);
          //clear old data
          _scrollControllers.clear();
          countsXLineSaver.clear();

          //re-add
          var movsLength = movies.length;

          for (int i = 0; i < ((movsLength / crossAxisCount).ceil()); i++) {
            int itemsCount = (movsLength - ((i + 1) * crossAxisCount) > 0)
                ? crossAxisCount
                : (movsLength - (i * crossAxisCount)).abs();
            ItemScrollController controller = ItemScrollController();
            _scrollControllers.add(controller);
            countsXLineSaver.add(itemsCount);
          }

          _loadMoreRunning = false;
          if (movs.length < 20) {
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

  Future<MovieResponseModel> response() async {
    MovieResponseModel resp;
    GetModel mod = widget.getModel;

    if (mod.from == From.actor) {
      resp = await MovieApiService(sl<DioClient>().dio).getMovieByActor(
        actorId: mod.actor!,
        page: _page,
      );
    } else if (mod.from == From.genre) {
      resp = await MovieApiService(sl<DioClient>().dio).getMovieByGenre(
        genreId: mod.genre!,
        page: _page,
      );
    } else if (mod.from == From.search) {
      resp = await MovieApiService(sl<DioClient>().dio).getMovieBySearch(
        keyword: mod.keyword!,
        page: _page,
      );
    } else {
      ///all
      resp = await MovieApiService(sl<DioClient>().dio).getMovies(
        page: _page,
      );
    }
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentProvider>(
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
                            itemCount: (movies.length / crossAxisCount).ceil(),
                            scrollDirection: Axis.vertical,
                            itemScrollController: _scrollController,
                            itemBuilder: (context, idx) {
                              int itemsCount = (movies.length -
                                          ((idx + 1) * crossAxisCount) >
                                      0)
                                  ? crossAxisCount
                                  : (movies.length - (idx * crossAxisCount))
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
            var mov = movies[(idx * crossAxisCount) + index];
            return Row(
              children: [
                PosterItem(
                  onTap: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   RouteName.movieDetail,
                    //   arguments: mov,
                    // );
                  },
                  cover: mov.poster,
                  title: mov.title,
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
    if (_currentPage == 1 && _isFocusOnTab == false) {
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
    if (_currentPage == 1) {
      if (_initLoading) return;

      if ((movies.length / crossAxisCount).ceil() - 1 == currentY) {
        debugPrint("End");
      } else if (focusedIdx == -1) {
        changeFocus();
        focusedIdx = 0;
        currentY = 0;
        currentX = 0;
        _scrollToIndexXY(currentX, currentY);
        setState(() {});
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
        setState(() {});

        var remaingY = (movies.length / crossAxisCount).ceil() - currentY;
        if (remaingY == 1) {
          await _loadMore();
        }
      }
    }
  }

  void _leftClick() {
    if (_currentPage == 1 && _isFocusOnTab == false) {
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
    if (_currentPage == 1 && _isFocusOnTab == false) {
      if (_initLoading) return;

      if ((movies.length / crossAxisCount).ceil() - 1 == currentY &&
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
      var remaingY = (movies.length / crossAxisCount).ceil() - currentY;
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

    // var mov = movies[focusedIdx];
    // Navigator.pushNamed(
    //   context,
    //   RouteName.movieDetail,
    //   arguments: mov,
    // );
    if (_currentPage == 1 && _currentTab == 1) {
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
      var mov = movies[focusedIdx];
      Navigator.pushNamed(context, RouteName.movieDetail, arguments: mov);
    }
  }

  void changeFocus() {
    context.read<CurrentProvider>().changFocusOnTab();
  }
}
