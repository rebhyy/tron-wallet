import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:on_chain_bridge/models/models.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  AppScrollBehavior(this.platform);
  final AppPlatform platform;
  late final bool isWindowsOrWeb =
      platform.isDesktop || platform == AppPlatform.web;
  @override
  late final Set<PointerDeviceKind> dragDevices = isWindowsOrWeb
      ? {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }
      : super.dragDevices;
}
