import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

class CacheNetworkImageView extends StatelessWidget {
  final String imageUrl;
  const CacheNetworkImageView({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: 20.h,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          height: 20.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
          ),
        );
      },
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