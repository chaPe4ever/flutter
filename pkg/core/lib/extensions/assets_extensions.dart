import 'package:core/assets_gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

extension SvgGenImageX on SvgGenImage {
  SvgPicture svgFromPkg(
    BuildContext context, {
    required String pkgName,
    Color? color,
    AlignmentGeometry alignment = Alignment.center,
    BoxFit fit = BoxFit.contain,
    double height = 24,
    double width = 24,
  }) {
    return this.svg(
      package: pkgName,
      height: height,
      width: width,
      alignment: alignment,
      colorFilter: ColorFilter.mode(
        context.appImgTheme.copyWith(color: color).color,
        BlendMode.srcIn,
      ),
      fit: fit,
    );
  }

  void precache() {
    final loader = SvgAssetLoader(path);
    svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }
}

extension SvgPictureX on SvgPicture {
  SvgPicture copyWith({
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode blendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool matchTextDirection = false,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture(
      bytesLoader,
      key: key,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      alignment: alignment,
      colorFilter:
          color != null ? ColorFilter.mode(color, blendMode) : colorFilter,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder ?? this.placeholderBuilder,
      clipBehavior: clipBehavior,
    );
  }
}

extension AssetGenImageX on AssetGenImage {
  Image imageFromPkg(
    BuildContext context, {
    required String pkgName,
    double height = 24,
    double width = 24,
    Color? color,
    BoxFit? fit,
    Alignment alignment = Alignment.center,
  }) =>
      image(
        package: pkgName,
        height: height,
        width: width,
        color: context.appImgTheme.copyWith(color: color).color,
        fit: fit,
        alignment: alignment,
      );
}
