import 'package:flutter/material.dart';
import 'package:msubyoteshin_20/common/models/get_model.dart';
import 'package:msubyoteshin_20/common/utils/enums.dart';
import 'package:msubyoteshin_20/features/genre/ui/genre.dart';
import 'package:msubyoteshin_20/features/movie/ui/movie.dart';
import 'package:msubyoteshin_20/features/serie/ui/series.dart';
import 'package:provider/provider.dart';
import '/common/utils/tabs.dart';
import '/widgets/key_code_listener.dart';
import '/features/home/provider/current_provider.dart';
import '/features/home/home.dart';

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({super.key});

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  final PageController _pageController = PageController();
  final FocusNode _fNode = FocusNode();
  late int _currentTab;
  late int _currentPage;
  late bool _isFocusOnTab;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_fNode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyCodeListener(
        focusNode: _fNode,
        upClick: _upClick,
        downClick: _downClick,
        leftClick: _leftClick,
        rightClick: _rightClick,
        centerClick: _centerClick,
        child: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                Home(),
                Movie(getModel: GetModel(from: From.home)),
                Serie(getModel: GetModel(from: From.home)),
                Genre(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 18, right: 18),
              child: Consumer<CurrentProvider>(
                builder: (BuildContext context, CurrentProvider value,
                    Widget? child) {
                  _currentTab = value.currentTab;
                  _currentPage = value.currentPage;
                  _isFocusOnTab = value.isFocusOnTab;
                  debugPrint('PageView: $_currentTab');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            tabTitles.length,
                            (index) => LeftTabWidget(
                              title: tabTitles[index],
                              isFocused: index == _currentTab,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            tabIcons.length,
                            (index) => RightTabWidget(
                              icon: tabIcons[index],
                              id: index - tabIcons.length,
                              currentTab: _currentTab,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _upClick() {}

  void _downClick() {}

  void _leftClick() {
    if (_isFocusOnTab) {
      //settings and qr
      if (_currentTab > 0 - tabIcons.length) {
        changeCurrentTab(_currentTab - 1);
      }
      //search
      else if (_currentTab == 0 - tabIcons.length) {
        changeCurrentTab(tabTitles.length - 1);
      }
      //actors to movies
      else if (_currentTab != 0 && _currentTab >= tabTitles.length - 1) {
        changeCurrentTab(_currentTab - 1);
      }
      //home
      else if (_currentTab == 0) {
        changeCurrentTab(-1);
      }
    }
  }

  void _rightClick() {
    if (_isFocusOnTab) {
      //home to channels
      if (_currentTab < tabTitles.length - 1) {
        changeCurrentTab(_currentTab + 1);
      }
      //actors
      else if (_currentTab == tabTitles.length - 1) {
        changeCurrentTab(0 - tabIcons.length);
      }
      //search and qr
      else if (_currentTab != -1 && _currentTab >= tabIcons.length) {
        changeCurrentTab(_currentTab + 1);
      }
      //settings
      else if (_currentTab == -1) {
        changeCurrentTab(0);
      }
    }
  }

  void _centerClick() {
    if (_isFocusOnTab && _currentPage != _currentTab) {
      switch (_currentTab) {
        case 0:
          setCurrentPage(); //now currentPage is 0
          animateToPage();

        case 1:
          setCurrentPage();
          changFocusOnTab();
          animateToPage();

        case 2:
          setCurrentPage();
          changFocusOnTab();
          animateToPage();

        case 3:
          setCurrentPage();
          changFocusOnTab();
          animateToPage();
      }
    }
  }

  void animateToPage() {
    _pageController.animateToPage(
      _currentTab,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
    );
  }

  void changFocusOnTab() {
    context.read<CurrentProvider>().changFocusOnTab();
  }

  void changeCurrentTab(int currentTab) {
    context.read<CurrentProvider>().changeCurrentTab(currentTab);
  }

  void setCurrentPage() {
    context.read<CurrentProvider>().changeCurrentPage(_currentTab);
  }
}

class LeftTabWidget extends StatelessWidget {
  const LeftTabWidget(
      {super.key, required this.title, required this.isFocused});
  final String title;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 30,
      alignment: Alignment.center,
      decoration: isFocused
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(300),
            )
          : null,
      child: Text(
        title,
        style: TextStyle(color: isFocused ? Colors.black : Colors.white),
      ),
    );
  }
}

class RightTabWidget extends StatelessWidget {
  const RightTabWidget(
      {super.key,
      required this.icon,
      required this.id,
      required this.currentTab});
  final IconData icon;
  final int id;
  final int currentTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 30,
      alignment: Alignment.center,
      decoration: id == currentTab
          ? BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(300))
          : null,
      child: Icon(
        icon,
        color: id == currentTab ? Colors.black : Colors.white,
      ),
    );
  }
}
