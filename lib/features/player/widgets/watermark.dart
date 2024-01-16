import '/common/utils/image_name.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Watermark extends StatelessWidget {
  const Watermark({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      sigma: 8,
      opacity: 1,
      offset: const Offset(0, 0),
      color: Colors.black,
      child: Image.asset(
        ImageName.splash,
        height: 50,
      ),
    );
  }
}
