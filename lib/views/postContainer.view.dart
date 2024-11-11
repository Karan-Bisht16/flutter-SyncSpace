import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/constants.dart';
import 'package:syncspace/controllers/comment.controller.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/user.provider.dart';
import 'package:syncspace/utils/functions.dart';
import 'package:syncspace/widgets/customAppBar.widget.dart';
import 'package:syncspace/widgets/customDrawer.widget.dart';
import 'package:syncspace/widgets/post.widget.dart';

class PostContainer extends StatefulWidget {
  const PostContainer({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  bool loadingComments = false;
  List<CommentModel> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  void fetchComments() async {
    setState(() {
      loadingComments = true;
    });
    Comment comment = Comment();
    var response = await comment.fetchComments(widget.post.id!);
    setState(() {
      comments = response.responseData;
      loadingComments = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IndividualPost(post: widget.post, fullView: true),
            ListView.builder(
              shrinkWrap: true,
              itemCount: comments.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final comment = comments[index];
                return IndividualComment(
                  comment: comment,
                  post: widget.post,
                  indentation: 0,
                );
              },
            ),
            if (loadingComments)
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
      endDrawer: const CustomDrawer(),
    );
  }
}

class IndividualComment extends StatefulWidget {
  const IndividualComment({
    super.key,
    required this.comment,
    required this.post,
    required this.indentation,
  });

  final CommentModel comment;
  final PostModel post;
  final int indentation;

  @override
  State<IndividualComment> createState() => _IndividualCommentState();
}

class _IndividualCommentState extends State<IndividualComment> {
  List<CommentModel> replies = [];
  bool showAllReplies = false;
  bool isCommentVisible = true;

  @override
  void initState() {
    super.initState();
    fetchReplies();
  }

  void fetchReplies() async {
    Comment comment = Comment();
    var response = await comment.fetchReplies(
      widget.post.id!,
      widget.comment.id!,
    );
    if (mounted) {
      setState(() {
        replies = response.responseData;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.comment.userDetails!;
    final postAuthor = widget.post.authorId;
    final indentation = widget.indentation;
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    AuthAPIResponse myData = AuthAPIResponse();
    final bool isLoggedIn = userProvider.isLoggedIn;

    if (isLoggedIn) {
      myData = userProvider.userData!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: indentation * 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: (user.avatar != null && user.avatar != '')
                    ? Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: Image.network(user.avatar!).image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user.userName![0],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                title: InkWell(
                  onTap: () {
                    if (!user.isDeleted! &&
                        !GoRouterState.of(context)
                            .uri
                            .toString()
                            .startsWith('/profile')) {
                      GoRouter.of(context).pushNamed(
                        AppRouteConstants.profile,
                        pathParameters: {
                          'userName': user.userName!,
                        },
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        user.isDeleted! ? '[Deleted]' : 'e/${user.userName!}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (isLoggedIn && user.userName == myData.userName)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'me',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (widget.comment.userId == postAuthor)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'OP',
                            style: TextStyle(
                              color: Color(0xff0090c1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                subtitle: Text(
                  formatDateAndTime(widget.comment.createdAt!),
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      isCommentVisible = !isCommentVisible;
                    });
                  },
                  icon: Icon(
                    isCommentVisible ? Icons.remove_circle : Icons.add_circle,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    size: 18.0,
                  ),
                ),
              ),
              if (isCommentVisible)
                Padding(
                  padding: const EdgeInsets.only(left: 60.0, right: 16.0),
                  child: Text(widget.comment.comment!),
                ),
            ],
          ),
        ),
        if (isCommentVisible)
          ListView.builder(
            shrinkWrap: true,
            itemCount: replies.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final comment = replies[index];
              if (!showAllReplies && indentation == 2) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 180.0,
                    right: 16.0,
                  ),
                  child: Container(
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(72.0),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          showAllReplies = true;
                        });
                      },
                      child: Text(
                        'Load more',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return IndividualComment(
                  comment: comment,
                  post: widget.post,
                  indentation: showAllReplies ? 0 : indentation + 1,
                );
              }
            },
          ),
      ],
    );
  }
}
