import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncspace/constants.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/routes/route.transition.dart';
import 'package:syncspace/views/createPost.view.dart';
import 'package:syncspace/views/postContainer.view.dart';
import 'package:syncspace/views/profile.view.dart';
import 'package:syncspace/views/settings.view.dart';
import 'package:syncspace/views/splashScreen.view.dart';
import 'package:syncspace/views/home.view.dart';
import 'package:syncspace/views/authentication.view.dart';
import 'package:syncspace/views/error.view.dart';

class AppRouter {
  static GoRouter returnRouter() {
    GoRouter router = GoRouter(
      routes: [
        GoRoute(
          name: AppRouteConstants.splashScreen,
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SplashScreen());
          },
        ),
        GoRoute(
          name: AppRouteConstants.home,
          path: '/home',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Home());
          },
        ),
        GoRoute(
          name: AppRouteConstants.authentication,
          path: '/authentication',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Authentication());
          },
        ),
        GoRoute(
          name: AppRouteConstants.profile,
          path: '/profile/:userName',
          pageBuilder: (context, state) {
            return Transition.getSlidePageBuilder(
              context: context,
              state: state,
              child: Profile(
                userName: state.pathParameters['userName']!,
              ),
              leftToRight: true,
            );
          },
        ),
        GoRoute(
          name: AppRouteConstants.settings,
          path: '/settings/:userId',
          pageBuilder: (context, state) {
            return Transition.getSlidePageBuilder(
              context: context,
              state: state,
              child: Settings(
                userId: state.pathParameters['userId']!,
              ),
              leftToRight: true,
            );
          },
        ),
        GoRoute(
          name: AppRouteConstants.post,
          path: '/post',
          builder: (context, state) {
            PostModel post = state.extra as PostModel;
            return PostContainer(
              post: post,
            );
          },
        ),
        GoRoute(
          name: AppRouteConstants.createPost,
          path: '/createPost/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: CreatePost(userId: state.pathParameters['userId']!),
            );
          },
        ),
      ],
      errorPageBuilder: (context, state) {
        return const MaterialPage(child: Error());
      },
    );
    return router;
  }
}
