import 'package:core/core.dart';
import 'package:shared_ui/shared_ui.dart';

class AppLoadingIndicator extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.responsive(AppSpacing.sectionM),
      height: context.responsive(AppSpacing.sectionM),
      child: CircularProgressIndicator(
        strokeWidth: context.responsive(
          AppBorderWidth.l,
        ),
        color: context.colors.backgroundBrand,
      ),
    );
  }
}
