import 'package:flutter/material.dart';
import '/common/widgets/network_image_view.dart';

class PosterItem extends StatelessWidget {
  final bool isFocused;
  final String? title;
  final String? cover;
  final VoidCallback onTap;
  const PosterItem({
    super.key,
    this.cover,
    this.title,
    required this.onTap,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isFocused ? 210 : 200,
        width: isFocused ? 130 : 120,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ]
              : null,
          border: isFocused
              ? Border.all(color: Colors.white, width: 2)
              : Border.all(
                  width: 1,
                  color: Colors.transparent,
                ),
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            NetworkImageView(
              url: cover,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              borderRadius: BorderRadius.circular(8),
            ),
            if (isFocused)
              Container(
                width: double.infinity,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.7),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                child: Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
