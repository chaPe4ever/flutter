import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_ui/shared_ui.dart';

enum TextSizeEnum { xs, s, m, l }

abstract class AppText extends StatelessWidget {
  const AppText(
    this._size, {
    required this.text,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    super.key,
  });
  final String text;
  final TextSizeEnum _size;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;

  TextStyle style(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style(context),
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}

class TextHeadline extends AppText {
  const TextHeadline._(
    super._size, {
    required super.text,
    this.color,
    super.overflow,
    super.textAlign,
    super.maxLines,
    super.key,
    super.softWrap,
  });

  factory TextHeadline.s(
    String text, {
    Key? key,
    Color? color,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
    bool? softWrap,
  }) =>
      TextHeadline._(
        TextSizeEnum.s,
        text: text,
        softWrap: softWrap,
        key: key,
        color: color,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );

  factory TextHeadline.m(
    String text, {
    Key? key,
    Color? color,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
    bool? softWrap,
  }) =>
      TextHeadline._(
        TextSizeEnum.m,
        text: text,
        softWrap: softWrap,
        key: key,
        color: color,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );

  factory TextHeadline.l(
    String text, {
    Key? key,
    Color? color,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
    bool? softWrap,
  }) =>
      TextHeadline._(
        TextSizeEnum.l,
        text: text,
        key: key,
        softWrap: softWrap,
        color: color,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );

  final Color? color;

  @override
  TextStyle style(BuildContext context) {
    return switch (_size) {
      TextSizeEnum.s => context.textStyles.headlineS.copyWith(color: color),
      TextSizeEnum.m => context.textStyles.headlineM.copyWith(color: color),
      TextSizeEnum.l => context.textStyles.headlineL.copyWith(color: color),
      _ => throw UnknownCoreException(
          innerMessage: 'Unknown TextSizeEnum: $_size',
        ),
    };
  }
}

class TextTitle extends AppText {
  const TextTitle._(
    super._size, {
    required super.text,
    super.overflow,
    this.color,
    super.key,
    super.textAlign,
    super.maxLines,
    super.softWrap,
  });

  factory TextTitle.m(
    String text, {
    Color? color,
    bool? softWrap,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
    Key? key,
  }) =>
      TextTitle._(
        TextSizeEnum.m,
        maxLines: maxLines,
        softWrap: softWrap,
        text: text,
        textAlign: textAlign,
        key: key,
        color: color,
        overflow: overflow,
      );

  factory TextTitle.l(
    String text, {
    Color? color,
    Key? key,
    bool? softWrap,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
  }) =>
      TextTitle._(
        TextSizeEnum.l,
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: softWrap,
        text: text,
        key: key,
        color: color,
        overflow: overflow,
      );

  final Color? color;

  @override
  TextStyle style(BuildContext context) {
    return switch (_size) {
      TextSizeEnum.m => context.textStyles.titleM.copyWith(color: color),
      TextSizeEnum.l => context.textStyles.titleL.copyWith(color: color),
      _ => throw UnknownCoreException(
          innerMessage: 'Unknown TextSizeEnum: $_size',
        ),
    };
  }
}

class TextBody extends AppText {
  const TextBody._(
    super._size, {
    required super.text,
    super.textAlign,
    super.key,
    this.color,
    super.overflow,
    super.maxLines,
    super.softWrap,
  });

  factory TextBody.xs(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    bool? softWrap,
  }) =>
      TextBody._(
        TextSizeEnum.xs,
        softWrap: softWrap,
        text: text,
        maxLines: maxLines,
        textAlign: textAlign,
        key: key,
        color: color,
        overflow: overflow,
      );

  factory TextBody.s(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    bool? softWrap,
  }) =>
      TextBody._(
        TextSizeEnum.s,
        softWrap: softWrap,
        text: text,
        maxLines: maxLines,
        textAlign: textAlign,
        key: key,
        color: color,
        overflow: overflow,
      );

  factory TextBody.m(
    String text, {
    Key? key,
    Color? color,
    bool? softWrap,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
  }) =>
      TextBody._(
        TextSizeEnum.m,
        text: text,
        maxLines: maxLines,
        softWrap: softWrap,
        textAlign: textAlign,
        key: key,
        color: color,
        overflow: overflow,
      );

  factory TextBody.l(
    String text, {
    Key? key,
    Color? color,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
    bool? softWrap,
  }) =>
      TextBody._(
        TextSizeEnum.l,
        softWrap: softWrap,
        text: text,
        maxLines: maxLines,
        textAlign: textAlign,
        key: key,
        color: color,
        overflow: overflow,
      );

  final Color? color;
  @override
  TextStyle style(BuildContext context) {
    return switch (_size) {
      TextSizeEnum.xs => context.textStyles.bodyXS.copyWith(color: color),
      TextSizeEnum.s => context.textStyles.bodyS.copyWith(color: color),
      TextSizeEnum.m => context.textStyles.bodyM.copyWith(color: color),
      TextSizeEnum.l => context.textStyles.bodyL.copyWith(color: color),
    };
  }
}

final class TextLabel extends AppText {
  const TextLabel._(
    super._size, {
    required super.text,
    super.key,
    this.color,
    super.overflow,
    super.textAlign,
    super.maxLines,
    super.softWrap,
  });

  factory TextLabel.m(
    String text, {
    Key? key,
    Color? color,
    TextOverflow? overflow,
    int? maxLines,
    TextAlign? textAlign,
    bool? softWrap,
  }) =>
      TextLabel._(
        TextSizeEnum.m,
        text: text,
        maxLines: maxLines,
        textAlign: textAlign,
        key: key,
        softWrap: softWrap,
        color: color,
        overflow: overflow,
      );

  factory TextLabel.l(
    String text, {
    Key? key,
    bool? softWrap,
    Color? color,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
  }) =>
      TextLabel._(
        TextSizeEnum.l,
        softWrap: softWrap,
        text: text,
        maxLines: maxLines,
        textAlign: textAlign,
        key: key,
        color: color,
        overflow: overflow,
      );

  final Color? color;

  @override
  TextStyle style(BuildContext context) {
    return switch (_size) {
      TextSizeEnum.m => context.textStyles.labelM.copyWith(color: color),
      TextSizeEnum.l => context.textStyles.labelL.copyWith(color: color),
      _ => throw UnknownCoreException(
          innerMessage: 'Unknown TextSizeEnum: $_size',
        ),
    };
  }
}
