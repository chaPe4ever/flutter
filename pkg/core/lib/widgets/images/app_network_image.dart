import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    super.key,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.height,
    this.width,
    this.fit,
  });

  final String url;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder:
          (context, url) => placeholder ?? const CircularProgressIndicator(),
      errorWidget:
          (context, url, error) => errorWidget ?? const Icon(Icons.error),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }
}
