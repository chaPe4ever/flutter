/// This is the core library used for all projects and thus should
/// contain only functionality that is globally used
library;

export 'package:async/async.dart' hide Result;
export 'package:cached_network_image/cached_network_image.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_functions/cloud_functions.dart';
// ignore: depend_on_referenced_packages
export 'package:collection/collection.dart';
export 'package:core/configs/configs.dart';
export 'package:core/constants/constants.dart';
export 'package:core/contracts/contracts.dart';
export 'package:core/enums/enums.dart';
export 'package:core/exceptions/exceptions.dart';
export 'package:core/extensions/extensions.dart';
export 'package:core/helpers/helpers.dart';
export 'package:core/init/init.dart';
export 'package:core/interceptors/interceptors.dart';
export 'package:core/logger/logger.dart';
export 'package:core/mixins/mixins.dart';
export 'package:core/models/models.dart';
export 'package:core/network/network.dart';
export 'package:core/permission/permission.dart';
export 'package:core/pods/pods.dart';
export 'package:core/storage/storage.dart';
export 'package:core/theme/theme.dart';
export 'package:core/utils/utils.dart';
export 'package:core/validators/validators.dart';
export 'package:core/value_objects/value_objects.dart';
export 'package:core/widgets/widgets.dart';
export 'package:custom_annotations/custom_annotations.dart';
export 'package:dartz/dartz.dart' hide Order, State;
export 'package:device_info_plus/device_info_plus.dart';
export 'package:dio/dio.dart';
export 'package:dio/src/cancel_token.dart';
export 'package:easy_localization/easy_localization.dart'
    hide LocaleToStringHelper;
export 'package:easy_localization/src/localization.dart';
export 'package:easy_localization/src/translations.dart';
export 'package:equatable/equatable.dart';
export 'package:faker/faker.dart' hide Color, Image;
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_database/firebase_database.dart'
    hide Query, Transaction, TransactionHandler;
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:flutter_pdfview/flutter_pdfview.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:flutter_timezone/flutter_timezone.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:gap/gap.dart';
export 'package:go_router/go_router.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:hooks_riverpod/hooks_riverpod.dart';
export 'package:json_annotation/json_annotation.dart';
export 'package:logger/logger.dart';
export 'package:package_info_plus/package_info_plus.dart';
export 'package:path_provider/path_provider.dart';
export 'package:pdfrx/pdfrx.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:pretty_dio_logger/pretty_dio_logger.dart';
// ignore: invalid_export_of_internal_element
export 'package:riverpod_annotation/riverpod_annotation.dart';
export 'package:rxdart/rxdart.dart';
export 'package:share_plus/share_plus.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:shimmer/shimmer.dart';
export 'package:signals/signals_flutter.dart'
    hide AsyncData, AsyncError, AsyncLoading;
export 'package:timezone/timezone.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:uuid/uuid.dart';
export 'package:widgetbook/widgetbook.dart';
export 'package:widgetbook_annotation/widgetbook_annotation.dart';
export 'package:window_manager/window_manager.dart';
