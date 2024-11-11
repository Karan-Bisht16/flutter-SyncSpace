import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Transition {
  static CustomTransitionPage getSlideTransitionPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    required bool leftToRight,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: leftToRight ? const Offset(-1, 0) : const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeIn)),
        ),
        child: child,
      ),
    );
  }

  static Page<dynamic> getSlidePageBuilder({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    required bool leftToRight,
  }) {
    return getSlideTransitionPage(
      context: context,
      state: state,
      child: child,
      leftToRight: leftToRight,
    );
  }
}
