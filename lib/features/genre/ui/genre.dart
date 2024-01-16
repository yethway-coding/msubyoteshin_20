import 'package:msubyoteshin_20/features/home/provider/current_provider.dart';

import '../../../common/widgets/key_code_listener.dart';
import '/common/utils/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/common/widgets/fake_item.dart';
import '/common/models/genre_model.dart';
import '/common/utils/reusable_widget.dart';
import '/common/utils/service_locator.dart';
import '../data/service/genre_api_service.dart';
import '/common/widgets/remove_scroll_wave.dart';
import '/features/genre/ui/widgets/genre_card.dart';
import '/features/genre/provider/gnere_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Genre extends StatefulWidget {
  const Genre({super.key});

  @override
  State<Genre> createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  int _page = 1;
  bool _initLoading = true;
  bool _hasNextPage = true;
  bool _loadMoreRunning = false;

  final FocusNode _focus = FocusNode();
  final int crossAxisCount = 6;
  late GenreProvider _genreProvider;

  final List<ItemScrollController> _scrollControllers = [];
  final ItemScrollController _scrollController = ItemScrollController();
  List<int> countsXLineSaver = [];
  int currentX = 0;
  int currentY = 0;
  int focusedIdx = 0;

  late int _listCount;
  late bool _isFocusOnTab;
  late int _currentPage;
  late int _currentTab;

  @override
  void initState() {
    _genreProvider = Provider.of(context, listen: false);
    _init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_focus);
    });
    super.initState();
  }

  _init() async {
    _genreProvider.list.clear();
    var resp = await GenreApiService(sl<DioClient>().dio).getGenres();

    if (resp.status == true) {
      _genreProvider.list.addAll(resp.data ?? []);
      var gensLength = _genreProvider.listCount;

      for (int i = 0; i < ((gensLength / crossAxisCount).ceil()); i++) {
        int itemsCount = (gensLength - ((i + 1) * crossAxisCount) > 0)
            ? crossAxisCount
            : (gensLength - (i * crossAxisCount)).abs();
        ItemScrollController controller = ItemScrollController();
        _scrollControllers.add(controller);
        countsXLineSaver.add(itemsCount);
      }
      setState(() {
        _initLoading = false;
      });
    } else {
      ///
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
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
      print(e);
    }
    _scrollController.scrollTo(
      index: y,
      alignment: 0.04,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutQuart,
    );
  }

  Future<void> _loadMore() async {
    if (_hasNextPage == true &&
        _initLoading == false &&
        _loadMoreRunning == false) {
      _loadMoreRunning = true;

      _page += 1;

      var resp = await GenreApiService(sl<DioClient>().dio).getGenres(
        page: _page,
      );

      if (resp.status == true) {
        List<GenreModel> gens = resp.data ?? [];
        if (gens.isNotEmpty) {
          _genreProvider.addAll(gens);

          //clear old data
          _scrollControllers.clear();
          countsXLineSaver.clear();

          //re-add
          var gensLength = _genreProvider.listCount;

          for (int i = 0; i < ((gensLength / crossAxisCount).ceil()); i++) {
            int itemsCount = (gensLength - ((i + 1) * crossAxisCount) > 0)
                ? crossAxisCount
                : (gensLength - (i * crossAxisCount)).abs();
            ItemScrollController controller = ItemScrollController();
            _scrollControllers.add(controller);
            countsXLineSaver.add(itemsCount);
          }
          _loadMoreRunning = false;

          if (gens.length < 20) {
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

  Future<bool> _onWillPop() async {
    if (_currentPage == 3 && _isFocusOnTab == false) {
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
      child: Consumer<GenreProvider>(
        builder: (ctx, pd, child) {
          _listCount = pd.listCount;
          return Consumer<CurrentProvider>(
            builder:
                (BuildContext context, CurrentProvider value, Widget? child) {
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
                                      (pd.listCount / crossAxisCount).ceil(),
                                  scrollDirection: Axis.vertical,
                                  itemScrollController: _scrollController,
                                  itemBuilder: (context, idx) {
                                    int itemsCount = (pd.listCount -
                                                ((idx + 1) * crossAxisCount) >
                                            0)
                                        ? crossAxisCount
                                        : (pd.listCount -
                                                (idx * crossAxisCount))
                                            .abs();
                                    return _gridLineWidget(idx, itemsCount);
                                  },
                                ),
                              ),
                            ),
                            if (_loadMoreRunning)
                              ReusableWidget.loadmoreLoading(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                              ),
                          ],
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _gridLineWidget(idx, int itemCount) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      alignment: Alignment.center,
      child: RmScrollWave(
        child: ScrollablePositionedList.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          itemScrollController: _scrollControllers[idx],
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var gen = _genreProvider.list[(idx * crossAxisCount) + index];
            return Row(
              children: [
                GenreCard(
                  genre: gen,
                  onTap: () {},
                  isFocus: hasFocus(idx, index),
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
    if (_currentPage == 3 && _isFocusOnTab == false) {
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
    if (_currentPage == 3) {
      if (_initLoading) return;

      if ((_listCount / crossAxisCount).ceil() - 1 == currentY) {
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

        var remaingY = (_listCount / crossAxisCount).ceil() - currentY;
        if (remaingY == 1) {
          await _loadMore();
        }
      }
    }
  }

  void _leftClick() {
    if (_currentPage == 3 && _isFocusOnTab == false) {
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
    if (_currentPage == 3 && _isFocusOnTab == false) {
      if (_initLoading) return;

      if ((_listCount / crossAxisCount).ceil() - 1 == currentY &&
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
      var remaingY = (_listCount / crossAxisCount).ceil() - currentY;
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

    // var gen = _genreProvider.list[focusedIdx];
    // SideSheet.right(
    //   context: context,
    //   width: MediaQuery.of(context).size.width / 3.2,
    //   body: ChooseMovieOrSerie(
    //     onSelect: (MainType typs) {
    //       if (typs == MainType.movie) {
    //         Navigator.popAndPushNamed(
    //           context,
    //           RouteName.movie,
    //           arguments: GetModel(
    //             from: From.genre,
    //             genre: gen.id,
    //             extra: gen.name,
    //           ),
    //         );
    //       } else {
    //         Navigator.popAndPushNamed(
    //           context,
    //           RouteName.serie,
    //           arguments: GetModel(
    //             from: From.genre,
    //             genre: gen.id,
    //             extra: gen.name,
    //           ),
    //         );
    //       }
    //     },
    //   ),
    // );
    if (_currentPage == 3 && _currentTab == 3) {
      if (focusedIdx == -1) {
        changeFocus();
        focusedIdx = 0;
        currentY = 0;
        currentX = 0;
        _scrollToIndexXY(currentX, currentY);
        focusedIdx = ((currentY * crossAxisCount) + currentX);
      }
      setState(() {});
    }
  }

  void changeFocus() {
    context.read<CurrentProvider>().changFocusOnTab();
  }
}
