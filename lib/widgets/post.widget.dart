import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/constants.dart';
import 'package:syncspace/controllers/post.controller.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/user.provider.dart';
import 'package:syncspace/utils/functions.dart';
import 'package:syncspace/widgets/customDivider.widget.dart';

class IndividualPost extends StatefulWidget {
  const IndividualPost({
    super.key,
    required this.post,
    this.fullView,
  });

  final PostModel post;
  final bool? fullView;

  @override
  State<IndividualPost> createState() => _IndividualPostState();
}

class _IndividualPostState extends State<IndividualPost> {
  bool isPostLiked = false;
  int likesCount = 0;

  @override
  void initState() {
    super.initState();
    likesCount = widget.post.likesCount!;
    checkIfPostLiked();
  }

  void toggleIsPostLiked(bool value) {
    if (mounted) {
      setState(() {
        isPostLiked = value;
      });
    }
  }

  void checkIfPostLiked() async {
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    if (!userProvider.isLoggedIn) {
      return;
    }
    final String userId = userProvider.userData!.id!;
    Post postController = Post();
    var response = await postController.isPostLiked(widget.post.id!, userId);
    // if response.responseData == null: then logout cuz the refresh token has been changed
    toggleIsPostLiked(response.responseData);
  }

  @override
  Widget build(BuildContext context) {
    final CondenseSubspaceDetails subspace = widget.post.subspaceDetails!;
    final CondenseAuthorDetails author = widget.post.authorDetails!;
    final List<SelectedFile> files = widget.post.selectedFile!;

    return InkWell(
      onTap: () {
        if (widget.fullView == null) {
          context.push('/post', extra: widget.post);
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 64.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: Image.network(subspace.avatarURL!).image,
              ),
              title: InkWell(
                onTap: () {
                  if (!subspace.isDeleted!) {
                    print('GoRoute to Subspace');
                  }
                },
                child: Text(
                  subspace.isDeleted!
                      ? '[Deleted]'
                      : 'ss/${subspace.subspaceName!}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: InkWell(
                onTap: () {
                  if (!author.isDeleted! &&
                      !GoRouterState.of(context)
                          .uri
                          .toString()
                          .startsWith('/profile')) {
                    GoRouter.of(context).pushNamed(
                      AppRouteConstants.profile,
                      pathParameters: {
                        'userName': author.userName!,
                      },
                    );
                  }
                },
                child: Text(
                  author.isDeleted! ? '[Deleted]' : 'e/${author.userName!}',
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: (widget.fullView == null) ? 72.0 : 16.0,
              right: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.title!),
                const SizedBox(height: 12.0),
                if (files.isNotEmpty)
                  MediaContainer(
                    files: files,
                    fullView: widget.fullView,
                  ),
                if (files.isEmpty)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    child: HtmlWidget(widget.post.body!),
                  ),
                if (widget.fullView != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDateAndTime(widget.post.dateCreated!),
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const CustomDivider(),
                      ],
                    ),
                  ),
                PostActionContainer(
                  post: widget.post,
                  fullView: widget.fullView,
                  isPostLiked: isPostLiked,
                  toggleIsPostLiked: toggleIsPostLiked,
                  likesCount: widget.post.likesCount!,
                ),
              ],
            ),
          ),
          const CustomDivider(),
        ],
      ),
    );
  }
}

class MediaContainer extends StatelessWidget {
  const MediaContainer({
    super.key,
    required this.files,
    this.fullView,
  });

  final List<SelectedFile> files;
  final bool? fullView;

  @override
  Widget build(BuildContext context) {
    if (files.length == 1) {
      final file = files[0];
      if (file.mediaType!.contains('image')) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              files[0].mediaURL!,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
        );
      } else if (file.mediaType!.contains('audio')) {
        return HtmlWidget('<audio controls src="${file.mediaURL}"/>');
      }
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width,
        maxHeight: 500,
      ),
      child: CarouselView(
        itemExtent:
            MediaQuery.sizeOf(context).width - (fullView == null ? 80 : 0),
        shrinkExtent:
            MediaQuery.sizeOf(context).width - (fullView == null ? 90 : 0),
        children: [
          for (SelectedFile file in files)
            if (file.mediaType!.contains('image'))
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(file.mediaURL!),
                ),
              )
        ],
      ),
    );
  }
}

class PostActionContainer extends StatefulWidget {
  const PostActionContainer({
    super.key,
    required this.post,
    this.fullView,
    required this.isPostLiked,
    required this.toggleIsPostLiked,
    required this.likesCount,
  });

  final PostModel post;
  final bool? fullView;
  final bool isPostLiked;
  final Function toggleIsPostLiked;
  final int likesCount;

  @override
  State<PostActionContainer> createState() => _PostActionContainerState();
}

class _PostActionContainerState extends State<PostActionContainer> {
  int likesCount = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      likesCount = widget.post.likesCount!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    final bool isLoggedIn = userProvider.isLoggedIn;
    String userId = '';
    if (isLoggedIn) {
      userId = userProvider.userData!.id!;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MaterialButton(
          onPressed: () async {
            if (isLoggedIn) {
              Post postController = Post();
              var response = await postController.likePost(
                widget.post.id!,
                userId,
                !widget.isPostLiked,
              );
              if (response.responseData) {
                setState(() {
                  likesCount =
                      widget.isPostLiked ? likesCount - 1 : likesCount + 1;
                });
                widget.toggleIsPostLiked(!widget.isPostLiked);
              }
            } else {
              GoRouter.of(context).pushNamed(AppRouteConstants.authentication);
            }
          },
          child: PostActionButton(
            label: likesCount,
            icon: widget.isPostLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: widget.isPostLiked ? Colors.pink : null,
          ),
        ),
        MaterialButton(
          onPressed: () {
            if (isLoggedIn) {
              if (widget.fullView == null) {
                context.push('/post', extra: widget.post);
              }
            } else {
              GoRouter.of(context).pushNamed(AppRouteConstants.authentication);
            }
          },
          child: PostActionButton(
            label: widget.post.commentsCount,
            icon: Icons.comment_outlined,
          ),
        ),
        MaterialButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: "your text"));
          },
          child: const PostActionButton(
            icon: Icons.share_outlined,
          ),
        )
      ],
    );
  }
}

class PostActionButton extends StatelessWidget {
  const PostActionButton({
    super.key,
    required this.icon,
    this.label,
    this.iconColor,
  });

  final int? label;
  final IconData icon;
  final MaterialColor? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.0,
          color: iconColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Text(
              '$label',
              style: TextStyle(
                fontSize: 14.0,
                color: iconColor ??
                    Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
      ],
    );
  }
}
