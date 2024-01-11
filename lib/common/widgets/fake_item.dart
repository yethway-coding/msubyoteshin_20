import 'package:flutter/material.dart';

class FakeItem extends StatelessWidget {
  final int count;
  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  const FakeItem({
    super.key,
    this.width,
    this.height,
    this.color,
    this.margin,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          count,
          (index) => Container(
            width: width,
            height: height,
            color: color,
            margin: margin,
          ),
        )
      ],
    );
  }
}
