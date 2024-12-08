import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

class CacheNetworkImageView extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? cachedNetworkImageHeight;
  final double? width;

  final BoxDecoration? boxDecoration;
  const CacheNetworkImageView(
      {required this.imageUrl,
      this.height,
      this.width,
      this.boxDecoration,
      this.cachedNetworkImageHeight,
      super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: cachedNetworkImageHeight ?? 20.h,
      imageUrl: imageUrl,
      width: width ?? 20.w,
      imageBuilder: (context, imageProvider) {
        return Container(
          height: height ?? 20.h,
          width: width ?? 20.w,
          decoration: BoxDecoration(
            shape: boxDecoration?.shape ?? BoxShape.circle,
            borderRadius: boxDecoration?.borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => const CircleAvatar(
        child: Icon(Icons.person),
      ),
      progressIndicatorBuilder: (context, url, progress) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}
