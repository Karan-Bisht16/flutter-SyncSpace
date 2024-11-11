import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/controllers/post.controller.dart';
import 'package:syncspace/controllers/user.controller.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/user.provider.dart';
import 'package:syncspace/utils/functions.dart';
import 'package:syncspace/widgets/post.widget.dart';
import 'package:syncspace/widgets/userAvatar.widget.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loadingUserData = false;
  UserModel userData = UserModel();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    setState(() {
      loadingUserData = true;
    });
    User user = User();
    var response = await user.fetchUserInfo(widget.userName);
    setState(() {
      userData = response.responseData;
      loadingUserData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    final bool isLoggedIn = userProvider.isLoggedIn;
    AuthAPIResponse myData = AuthAPIResponse();

    if (isLoggedIn) {
      myData = userProvider.userData!;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          if (loadingUserData)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          if (!loadingUserData)
            UserContainer(
              userData: userData,
              myData: myData,
            ),
        ],
      ),
    );
  }
}

class UserContainer extends StatefulWidget {
  const UserContainer({
    super.key,
    required this.userData,
    required this.myData,
  });

  final UserModel userData;
  final AuthAPIResponse myData;

  @override
  State<UserContainer> createState() => _UserContainerState();
}

class _UserContainerState extends State<UserContainer> {
  bool loadingUserPosts = false;
  List<PostModel> userPosts = [];
  int userPostsPageNumber = 1;
  final ScrollController userPostsScrollController = ScrollController();

  bool loadingLikedPosts = false;
  List<PostModel> likedPosts = [];
  int likedPostsPageNumber = 1;
  final ScrollController likedPostsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
    fetchLikedPosts();
    userPostsScrollController.addListener(userPostsScrollListener);
    likedPostsScrollController.addListener(likedPostsScrollListener);
  }

  void fetchUserPosts() async {
    setState(() {
      loadingUserPosts = true;
    });
    Post post = Post();
    var response = await post.fetchPosts(
      userPostsPageNumber,
      {'authorId': widget.userData.id},
      '',
    );
    setState(() {
      userPosts.addAll(response.responseData.posts);
      userPostsPageNumber += 1;
      loadingUserPosts = false;
    });
  }

  void userPostsScrollListener() {
    if (loadingUserPosts) return;
    if (userPostsScrollController.position.pixels ==
        userPostsScrollController.position.maxScrollExtent) {
      fetchUserPosts();
    }
  }

  void fetchLikedPosts() async {
    setState(() {
      loadingLikedPosts = true;
    });
    Post post = Post();
    var response = await post.fetchPosts(
      likedPostsPageNumber,
      {'userId': widget.userData.id},
      'LIKED_POSTS',
    );
    setState(() {
      likedPosts.addAll(response.responseData.posts);
      likedPostsPageNumber += 1;
      loadingLikedPosts = false;
    });
  }

  void likedPostsScrollListener() {
    if (loadingLikedPosts) return;
    if (likedPostsScrollController.position.pixels ==
        likedPostsScrollController.position.maxScrollExtent) {
      fetchLikedPosts();
    }
  }

  @override
  void dispose() {
    super.dispose();
    userPostsScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              Image.network(
                'http://res.cloudinary.com/cloud-for-karan/image/upload/v1723834044/gzm6r7jzblcovpkhkfve.jpg',
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 48.0,
                left: 16.0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16.0,
                bottom: -48.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: UserAvatar(
                    radius: 48.0,
                    isLoggedIn: true,
                    avatar: widget.userData.avatar!,
                  ),
                ),
              ),
              if (widget.myData.id == widget.userData.id)
                Positioned(
                  // fix cuz btn is outside stack
                  right: 8.0,
                  bottom: -48.0,
                  child: MaterialButton(
                    onPressed: () {
                      print('Edit profile');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceBright,
                        borderRadius: BorderRadius.circular(72.0),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 48.0, left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userData.name!,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.link,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'e/${widget.userData.userName!}',
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Joined ${formatDateAndTime(widget.userData.dateJoined!)}',
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '${widget.userData.credits}',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          TextSpan(
                            text: ' credits',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '${widget.userData.subspacesJoined}',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          TextSpan(
                            text: ' subspaces joined',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                indicatorColor: Colors.blue,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.post_add),
                        SizedBox(width: 8.0),
                        Text('Posts'),
                      ],
                    ),
                  ),
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite),
                        SizedBox(width: 8.0),
                        Text('Liked Posts'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height - 390,
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      controller: userPostsScrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: userPosts.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final post = userPosts[index];
                              return IndividualPost(post: post);
                            },
                          ),
                          if (loadingUserPosts)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 32.0,
                              ),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      controller: likedPostsScrollController,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: likedPosts.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final post = likedPosts[index];
                              return IndividualPost(post: post);
                            },
                          ),
                          if (loadingLikedPosts)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 32.0,
                              ),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
