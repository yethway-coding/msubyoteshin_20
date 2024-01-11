import '/common/utils/image_name.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NetworkImageView extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  const NetworkImageView({
    super.key,
    this.borderRadius,
    this.url,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final logoIMG = Image.asset(
      ImageName.splash,
      fit: BoxFit.contain,
    );
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: ExtendedImage.network(
        url == null ? ImageName.splash : url!,
        width: width,
        height: height,
        fit: fit ?? BoxFit.fill,
        cache: true,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Shimmer(
                duration: const Duration(milliseconds: 1800),
                interval: const Duration(milliseconds: 200),
                color: Colors.white,
                colorOpacity: .2,
                enabled: true,
                child: logoIMG,
              );
            case LoadState.failed:
              return logoIMG;
            default:
          }
          return null;
        },
      ),
    );
  }
}
