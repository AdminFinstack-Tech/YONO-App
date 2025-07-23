import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static NavigatorState? get navigator => navigatorKey.currentState;

  static Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigator?.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? navigateToReplacement(String routeName, {Object? arguments}) {
    return navigator?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? navigateToAndRemoveUntil(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return navigator?.pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void goBack({dynamic result}) {
    navigator?.pop(result);
  }

  static bool canGoBack() {
    return navigator?.canPop() ?? false;
  }

  static void popUntil(bool Function(Route<dynamic>) predicate) {
    navigator?.popUntil(predicate);
  }

  static Future<dynamic>? push(Route<dynamic> route) {
    return navigator?.push(route);
  }

  static Future<dynamic>? pushReplacement(Route<dynamic> route) {
    return navigator?.pushReplacement(route);
  }

  static Future<dynamic>? pushAndRemoveUntil(
    Route<dynamic> route,
    bool Function(Route<dynamic>) predicate,
  ) {
    return navigator?.pushAndRemoveUntil(route, predicate);
  }

  static void showSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    final context = currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration ?? const Duration(seconds: 3),
          action: action,
        ),
      );
    }
  }

  static Future<T?> showDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    final context = currentContext;
    if (context != null) {
      return showGeneralDialog<T>(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) => dialog,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor ?? Colors.black54,
        barrierLabel: barrierLabel,
        transitionDuration: const Duration(milliseconds: 200),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
      );
    }
    return Future.value(null);
  }

  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    final context = currentContext;
    if (context != null) {
      return showModalBottomSheet<T>(
        context: context,
        builder: (context) => child,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
      );
    }
    return Future.value(null);
  }
}