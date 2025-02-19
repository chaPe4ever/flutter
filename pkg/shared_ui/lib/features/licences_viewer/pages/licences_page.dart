import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/core/assets_gen/assets.gen.dart';
import 'package:shared_ui/core/constants/trans_keys_constants.dart';
import 'package:shared_ui/shared_ui.dart';

class LicencesPage extends ConsumerWidget {
  const LicencesPage({this.padding = const EdgeInsets.all(20), super.key});
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.svg.appLogo.svg(height: 16),
              const SizedBox(width: AppSpacing.contentM),
              TextBody.m(
                TransKeys.licences.tr(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionS),
          Expanded(
            child: AsyncValueWidget(
              value: ref.watch(fetchLicencesPod),
              data: (licences) => HookBuilder(
                builder: (context) {
                  return Scrollbar(
                    thumbVisibility: true,
                    radius: AppRadius.xs,
                    child: ListView.builder(
                      addAutomaticKeepAlives: false,
                      itemCount: licences.length,
                      itemBuilder: (context, index) {
                        final item = licences[index];
                        return ExpansionTile(
                          key: Key(index.toString()),
                          title: TextBody.m(
                            item.packages.join(', '),
                          ),
                          children: [
                            TextBody.m(
                              TransKeys.licences.tr(),
                            ),
                            const SizedBox(
                              height: AppSpacing.contentL,
                            ),
                            ListBody(
                              children: item.paragraphs.map((paragraph) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: padding.horizontal,
                                  ),
                                  child: TextBody.s(
                                    paragraph.text,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: AppSpacing.contentL,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sectionL),
          AppButton.primary(
            label: TransKeys.close.tr(),
            onTap: context.pop,
          ),
        ],
      ),
    );
  }
}
