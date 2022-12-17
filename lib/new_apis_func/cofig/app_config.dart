import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String appTitle, buildFlavor, databaseTableName;
  final Widget child;

  AppConfig({
    required this.child,
    required this.appTitle,
    required this.buildFlavor,
    required this.databaseTableName,
  }) : super(child: child);

  static AppConfig of({required BuildContext context}) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
