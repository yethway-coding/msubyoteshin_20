import 'dart:math';
import 'package:flutter/material.dart';
import 'package:msubyoteshin_20/common/utils/colors.dart';
import '/common/models/genre_model.dart';

class GenreCard extends StatelessWidget {
  final bool isFocus;
  final GenreModel genre;
  final VoidCallback onTap;
  const GenreCard({
    super.key,
    required this.onTap,
    required this.genre,
    required this.isFocus,
  });

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isFocus ? 70 : 60,
        width: isFocus ? 130 : 120,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: isFocus ? null : const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: colors[random.nextInt(colors.length)],
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: isFocus
            //       ? [
            //           Colors.primaries[random.nextInt(Colors.primaries.length)]
            //               .withOpacity(.8),
            //           Colors.primaries[random.nextInt(Colors.primaries.length)]
            //               .withOpacity(.8)
            //         ]
            //       : [
            //           Colors.primaries[random.nextInt(Colors.primaries.length)]
            //               .withOpacity(.6),
            //           Colors.primaries[random.nextInt(Colors.primaries.length)]
            //               .withOpacity(.6)
            //         ],
            // ),
            border: isFocus ? Border.all(color: Colors.white, width: 2) : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isFocus
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ]
                : null),
        alignment: Alignment.center,
        child: isFocus
            ? Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  genre.name ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                genre.name ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
