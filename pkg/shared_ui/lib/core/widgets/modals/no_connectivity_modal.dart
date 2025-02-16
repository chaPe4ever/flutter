import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class NoConnectivityModal extends StatefulHookConsumerWidget {
  const NoConnectivityModal({super.key});

  @override
  ConsumerState<NoConnectivityModal> createState() =>
      _NoConnectivityModalState();
}

class _NoConnectivityModalState extends ConsumerState<NoConnectivityModal> {
  // late final StreamSubscription<NetworkStatus> _networkStreamSubscription;

  // @override
  // void initState() {
  //   super.initState();
  //   _networkStreamSubscription = ref
  //       .read(networkPod)
  //       .connectionStatusController
  //       .stream
  //       .distinct()
  //       .skipWhile(
  //         (e) => e == NetworkStatus.offline || e == NetworkStatus.other,
  //       )
  //       .listen((_) {
  //     if (mounted && context.canPop()) {
  //       context.pop();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _networkStreamSubscription.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    // useOnAppLifecycleStateChange((_, state) {
    //   if (state case AppLifecycleState.resumed) {
    //     _networkStreamSubscription.resume();
    //   } else if (state case AppLifecycleState.paused) {
    //     _networkStreamSubscription.pause();
    //   }
    // });

    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: context.colors.overlay50,
            child: Center(
              child: Container(
                width: constraints.maxWidth * 0.9,
                height: constraints.maxHeight * 0.97,
                color: context.colors.backgroundPrimary,
                child: SpacedColumn(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextBody.l(
                      'no_internet_connection'.tr(),
                    ),
                    TextBody.m(
                      'no_internet_connection_details'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
