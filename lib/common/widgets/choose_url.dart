import 'package:msubyoteshin_20/common/widgets/remove_scroll_wave.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../routes/route_name.dart';
import 'key_code_listener.dart';
import 'package:flutter/material.dart';
import '/common/models/source_model.dart';

class ChooseURL extends StatefulWidget {
  final List<SourceModel> sources;
  final String title;
  final bool? needToPop;
  const ChooseURL({
    super.key,
    required this.title,
    required this.sources,
    this.needToPop = true,
  });

  @override
  State<ChooseURL> createState() => _ChooseURLState();
}

class _ChooseURLState extends State<ChooseURL> {
  final _focus = FocusNode();
  int selectedIdx = 0;
  final _scrollController = ItemScrollController();

  _scrollTo() {
    _scrollController.scrollTo(
      index: selectedIdx,
      alignment: 0.04,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focus);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyCodeListener(
      focusNode: _focus,
      centerClick: _openPlayer,
      upClick: _upClick,
      downClick: _downClick,
      // child: Container(
      //   decoration: const BoxDecoration(color: Colors.white),
      //   // padding: const EdgeInsets.all(10),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       const Text(
      //         'Choose URL',
      //         style: TextStyle(fontSize: 20),
      //       ),
      //       const SizedBox(height: 10),
      //       ...List.generate(
      //         widget.sources.length,
      //         (index) => GestureDetector(
      //           onTap: () {},
      //           child: Container(
      //             // duration: const Duration(milliseconds: 200),
      //             height: 40,
      //             margin: const EdgeInsets.only(bottom: 10),
      //             // width: double.infinity,
      //             decoration: BoxDecoration(
      //               color: selectedIdx == index ? Colors.indigo : Colors.white,
      //               borderRadius: BorderRadius.circular(4),
      //             ),
      //             child: Row(
      //               children: [
      //                 // const SizedBox(width: 10),
      //                 Icon(
      //                   Icons.link,
      //                   color: selectedIdx == index
      //                       ? Colors.white
      //                       : Colors.black.withOpacity(.5),
      //                 ),
      //                 const SizedBox(width: 10),
      //                 Text(
      //                   '${widget.sources[index].resolution} (${index + 1})',
      //                   style: TextStyle(
      //                     color: selectedIdx == index
      //                         ? Colors.white
      //                         : Colors.black,
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      child: Column(
        children: [
          Container(
            height: 130,
            color: Colors.black,
          ),
          Expanded(
            child: widget.sources.isEmpty
                ? const Center(
                    child: Text('Empty Data...',
                        style: TextStyle(color: Color(0xFF9D9FA5))))
                : RmScrollWave(
                    child: ScrollablePositionedList.builder(
                      itemCount: widget.sources.length,
                      itemScrollController: _scrollController,
                      itemBuilder: ((context, index) {
                        return Container(
                          height: 40,
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                            bottom: index == widget.sources.length - 1 ? 10 : 0,
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          decoration: selectedIdx == index
                              ? BoxDecoration(
                                  color: const Color(0xFF272B35),
                                  borderRadius: BorderRadius.circular(8),
                                )
                              : null,
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: selectedIdx == index
                                    ? Colors.white
                                    : const Color(
                                        0xFF9D9FA5,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '${widget.sources[index].resolution}',
                                style: TextStyle(
                                    color: selectedIdx == index
                                        ? Colors.white
                                        : const Color(0xFF9D9FA5)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _upClick() {
    if (selectedIdx > 0) {
      selectedIdx--;
      setState(() {});
      _scrollTo();
    }
  }

  void _downClick() {
    if (selectedIdx < widget.sources.length - 1) {
      selectedIdx++;
      setState(() {});
      _scrollTo();
    }
  }

  _openPlayer() async {
    if (widget.needToPop == true) Navigator.pop(context);
    Navigator.pushNamed(
      context,
      RouteName.vidPlayer,
      arguments: {
        "title": widget.title,
        "url": widget.sources[selectedIdx].url,
      },
    );
  }
}

//sheet 1c222b
//item 272b35
//text 9d9fa5