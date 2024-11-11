import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/constants.dart';
import 'package:syncspace/controllers/post.controller.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/user.provider.dart';
import 'package:syncspace/widgets/customAppBar.widget.dart';
import 'package:syncspace/widgets/customDrawer.widget.dart';
import 'package:syncspace/widgets/post.widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loadingPosts = false;
  int pageNumber = 1;
  List<PostModel> posts = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchHomePagePosts();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void fetchHomePagePosts() async {
    setState(() {
      loadingPosts = true;
    });
    Post post = Post();
    var response = await post.fetchPosts(pageNumber, null, 'HOME_PAGE');
    setState(() {
      posts.addAll(response.responseData.posts);
      pageNumber += 1;
      loadingPosts = false;
    });
  }

  void scrollListener() {
    if (loadingPosts) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      fetchHomePagePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    final bool isLoggedIn = userProvider.isLoggedIn;
    AuthAPIResponse userData = AuthAPIResponse();

    if (isLoggedIn) {
      userData = userProvider.userData!;
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return IndividualPost(post: post);
                },
              ),
              if (loadingPosts)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isLoggedIn) {
            GoRouter.of(context).pushNamed(
              AppRouteConstants.createPost,
              pathParameters: {
                'userId': userData.id!,
              },
            );
          } else {
            GoRouter.of(context).pushNamed(AppRouteConstants.authentication);
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff0090c1),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded),
      ),
      endDrawer: isLoggedIn ? const CustomDrawer() : null,
    );
  }
}
