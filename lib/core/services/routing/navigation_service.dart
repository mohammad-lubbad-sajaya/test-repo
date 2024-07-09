import 'package:flutter/material.dart';
/*
  The NavigationService class provides methods and extensions for navigating between routes
  in a Flutter application. Here's a brief explanation of what each part of the code does:
 */

class NavigationService {
  // A global key for accessing the NavigatorState and managing navigation.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//Navigates to a specific route with an optional arguments object.
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

//Navigates to a specific route and removes all previous routes from the stack.
  Future<dynamic> navigateToAndRemove(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

//Pops routes until a specific route is reached and then navigates to it.
  void navigateToAndPopUntil(String routeName) {
    return navigatorKey.currentState!.popUntil(
      ModalRoute.withName(routeName),
    );
  }

// Pops routes until a specific route is reached and then pushes a new route.
  void popUntilAndPush(
      {required String routeName,
      String? secondaryRouteName,
      Object? arguments}) {
    navigatorKey.currentState!.popUntilAndPush(
      routeName,
      secondaryRouteName ?? routeName,
      arguments: arguments,
    );
  }

//Navigates to a specific route and replaces the current route in the stack.
  Future<dynamic> navigateToAndReplace(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

//Navigates back to the previous route.
  void navigateToPrevious() {
    return navigatorKey.currentState!.pop();
  }

// Returns the BuildContext associated with the navigator.
  BuildContext getContext() {
    return navigatorKey.currentState!.overlay!.context;
  }

//Retrieves the name of the parent route by iterating through the route stack.
  String getParentName({bool isParent = false}) {
    late Route route;

    navigatorKey.currentState?.popUntil((newRoute) {
      route = newRoute;

      isParent = !isParent;

      return true;
    });

    if (isParent) {
      getParentName(isParent: isParent);
    }

    return route.settings.name ?? '';
  }
}

//NavigatorStateExtension:
//Adds an extension to NavigatorState for custom navigation behavior.
//Defines the popUntilAndPush method, which pops routes until a specific route is reached and then pushes a new route.

extension NavigatorStateExtension on NavigatorState {
  void popUntilAndPush(String routeName, String secondaryRouteName,
      {Object? arguments}) {
    while (true) {
      String? currentRouteName;
      popUntil((route) {
        currentRouteName = route.settings.name;
        return true;
      });
      if (currentRouteName == routeName) {
        break;
      } else if (currentRouteName == null) {
        pushNamed(secondaryRouteName);
        break;
      } else {
        pop();
      }
    }
  }
}
