import 'package:flutter/material.dart';
import '/common/models/actor_model.dart';
import '/common/widgets/network_image_view.dart';

class ActorItem extends StatelessWidget {
  final bool isFocused;
  final ActorModel actor;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;

  const ActorItem({
    super.key,
    this.margin,
    required this.actor,
    required this.onTap,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isFocused ? 120 : 110,
        width: isFocused ? 120 : 110,
        clipBehavior: Clip.antiAlias,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
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
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            NetworkImageView(
              url: actor.cover,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            if (isFocused)
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(.7),
                alignment: Alignment.center,
                child: Text(
                  actor.name ?? '',
                  textAlign: TextAlign.center,
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
