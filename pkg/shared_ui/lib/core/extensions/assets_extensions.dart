import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/core/assets_gen/assets.gen.dart';
import 'package:shared_ui/shared_ui.dart';

extension SvgGenImageX on SvgGenImage {
  SvgPicture svgFromUIPkg(
    BuildContext context, {
    Color? color,
    double height = 24,
    double width = 24,
    AlignmentGeometry alignment = Alignment.center,
    BoxFit fit = BoxFit.contain,
  }) {
    return this.svg(
      package: kSharedUiPkgName,
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
      colorFilter: color != null
          ? ColorFilter.mode(color, blendMode)
          : colorFilter,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder ?? this.placeholderBuilder,
      clipBehavior: clipBehavior,
    );
  }
}

extension AssetGenImageX on AssetGenImage {
  Image imageFromUIPkg(
    BuildContext context, {
    double height = 16.0,
    double width = 16.0,
    Color? color,
    BoxFit? fit,
    Alignment alignment = Alignment.center,
  }) => image(
    package: kSharedUiPkgName,
    height: height,
    width: width,
    color: context.appImgTheme.copyWith(color: color).color,
    fit: fit,
    alignment: alignment,
  );
}
