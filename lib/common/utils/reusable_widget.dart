import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReusableWidget {
  static Widget loading({bool isCenter = false, Color? color}) {
    var loading = LoadingAnimationWidget.bouncingBall(
      color: color ?? Colors.white,
      size: 60,
    );
    if (isCenter) {
      return Center(child: loading);
    } else {
      return loading;
    }
  }

  static Widget loadmoreLoading(
      {bool isCenter = false, Color? color, EdgeInsetsGeometry? margin}) {
    var loading = Padding(
      padding: margin ?? const EdgeInsets.all(0),
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? Colors.white,
        size: 40,
      ),
    );
    if (isCenter) {
      return Center(child: loading);
    } else {
      return loading;
    }
  }
}
