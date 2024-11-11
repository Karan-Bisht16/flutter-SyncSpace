class APIResponse {
  int? statusCode;
  String? message;
  dynamic responseData;

  APIResponse({
    this.statusCode,
    this.message,
    this.responseData,
  });

  APIResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    responseData = json['responseData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['responseData'] = responseData;
    return data;
  }
}

class AuthAPIResponse {
  String? id;
  String? name;
  String? userName;
  String? email;
  bool? viaGoogle;
  String? avatar;

  AuthAPIResponse({
    this.id,
    this.name,
    this.userName,
    this.email,
    this.viaGoogle,
    this.avatar,
  });

  AuthAPIResponse.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    userName = json['userName'];
    email = json['email'];
    viaGoogle = json['viaGoogle'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['userName'] = userName;
    data['email'] = email;
    data['viaGoogle'] = viaGoogle;
    data['avatar'] = avatar;
    return data;
  }
}

class FetchedPosts {
  int? count;
  int? previous;
  int? next;
  List<PostModel>? posts;

  FetchedPosts({
    this.count,
    this.previous,
    this.next,
    this.posts,
  });

  FetchedPosts.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    previous = json['previous'];
    next = json['next'];
    if (json['results'] != null) {
      posts = <PostModel>[];
      json['results'].forEach((v) {
        posts!.add(PostModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['previous'] = previous;
    data['next'] = next;
    if (posts != null) {
      data['results'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostModel {
  String? id;
  String? title;
  List<SelectedFile>? selectedFile;
  String? authorId;
  String? subspaceId;
  int? likesCount;
  int? commentsCount;
  bool? edited;
  String? dateCreated;
  CondenseAuthorDetails? authorDetails;
  CondenseSubspaceDetails? subspaceDetails;
  String? body;

  PostModel({
    this.id,
    this.title,
    this.selectedFile,
    this.authorId,
    this.subspaceId,
    this.likesCount,
    this.commentsCount,
    this.edited,
    this.dateCreated,
    this.authorDetails,
    this.subspaceDetails,
    this.body,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    if (json['selectedFile'] != null) {
      selectedFile = <SelectedFile>[];
      json['selectedFile'].forEach((v) {
        selectedFile!.add(SelectedFile.fromJson(v));
      });
    }
    authorId = json['authorId'];
    subspaceId = json['subspaceId'];
    likesCount = json['likesCount'];
    commentsCount = json['commentsCount'];
    edited = json['edited'];
    dateCreated = json['dateCreated'];
    authorDetails = json['authorDetails'] != null
        ? CondenseAuthorDetails.fromJson(json['authorDetails'])
        : null;
    subspaceDetails = json['subspaceDetails'] != null
        ? CondenseSubspaceDetails.fromJson(json['subspaceDetails'])
        : null;
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    if (selectedFile != null) {
      data['selectedFile'] = selectedFile!.map((v) => v.toJson()).toList();
    }
    data['authorId'] = authorId;
    data['subspaceId'] = subspaceId;
    data['likesCount'] = likesCount;
    data['commentsCount'] = commentsCount;
    data['edited'] = edited;
    data['dateCreated'] = dateCreated;
    if (authorDetails != null) {
      data['authorDetails'] = authorDetails!.toJson();
    }
    if (subspaceDetails != null) {
      data['subspaceDetails'] = subspaceDetails!.toJson();
    }
    data['body'] = body;
    return data;
  }
}

class SelectedFile {
  String? mediaPublicId;
  String? mediaType;
  String? mediaURL;

  SelectedFile({
    this.mediaPublicId,
    this.mediaType,
    this.mediaURL,
  });

  SelectedFile.fromJson(Map<String, dynamic> json) {
    mediaPublicId = json['mediaPublicId'];
    mediaType = json['mediaType'];
    mediaURL = json['mediaURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mediaPublicId'] = mediaPublicId;
    data['mediaType'] = mediaType;
    data['mediaURL'] = mediaURL;
    return data;
  }
}

class CondenseAuthorDetails {
  String? userName;
  bool? isDeleted;

  CondenseAuthorDetails({
    this.userName,
    this.isDeleted,
  });

  CondenseAuthorDetails.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class CondenseSubspaceDetails {
  String? subspaceName;
  bool? isDeleted;
  String? avatarURL;

  CondenseSubspaceDetails({
    this.subspaceName,
    this.isDeleted,
    this.avatarURL,
  });

  CondenseSubspaceDetails.fromJson(Map<String, dynamic> json) {
    subspaceName = json['subspaceName'];
    isDeleted = json['isDeleted'];
    avatarURL = json['avatarURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subspaceName'] = subspaceName;
    data['isDeleted'] = isDeleted;
    data['avatarURL'] = avatarURL;
    return data;
  }
}

class FetchedSubspaces {
  int? count;
  int? previous;
  int? next;
  List<SubspaceModel>? subspaces;

  FetchedSubspaces({this.count, this.previous, this.next, this.subspaces});

  FetchedSubspaces.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    previous = json['previous'];
    next = json['next'];
    if (json['results'] != null) {
      subspaces = <SubspaceModel>[];
      json['results'].forEach((v) {
        subspaces!.add(SubspaceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['previous'] = previous;
    data['next'] = next;
    if (subspaces != null) {
      data['results'] = subspaces!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubspaceModel {
  String? id;
  String? name;
  String? subspaceName;
  String? description;
  String? creator;
  int? membersCount;
  int? postsCount;
  List<Topics>? topics;
  bool? isDeleted;
  String? dateCreated;
  int? iV;
  String? avatarURL;
  String? avatarPublicId;

  SubspaceModel({
    this.id,
    this.name,
    this.subspaceName,
    this.description,
    this.creator,
    this.membersCount,
    this.postsCount,
    this.topics,
    this.isDeleted,
    this.dateCreated,
    this.iV,
    this.avatarURL,
    this.avatarPublicId,
  });

  SubspaceModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    subspaceName = json['subspaceName'];
    description = json['description'];
    creator = json['creator'];
    membersCount = json['membersCount'];
    postsCount = json['postsCount'];
    if (json['topics'] != null) {
      topics = <Topics>[];
      json['topics'].forEach((v) {
        topics!.add(Topics.fromJson(v));
      });
    }
    isDeleted = json['isDeleted'];
    dateCreated = json['dateCreated'];
    iV = json['__v'];
    avatarURL = json['avatarURL'];
    avatarPublicId = json['avatarPublicId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['subspaceName'] = subspaceName;
    data['description'] = description;
    data['creator'] = creator;
    data['membersCount'] = membersCount;
    data['postsCount'] = postsCount;
    if (topics != null) {
      data['topics'] = topics!.map((v) => v.toJson()).toList();
    }
    data['isDeleted'] = isDeleted;
    data['dateCreated'] = dateCreated;
    data['__v'] = iV;
    data['avatarURL'] = avatarURL;
    data['avatarPublicId'] = avatarPublicId;
    return data;
  }
}

class Topics {
  int? key;
  String? label;

  Topics({this.key, this.label});

  Topics.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    return data;
  }
}

class CommentModel {
  String? id;
  String? postId;
  String? userId;
  String? parentId;
  String? comment;
  int? repliesCount;
  String? createdAt;
  UserDetails? userDetails;

  CommentModel({
    this.id,
    this.postId,
    this.userId,
    this.parentId,
    this.comment,
    this.repliesCount,
    this.createdAt,
    this.userDetails,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    postId = json['postId'];
    userId = json['userId'];
    parentId = json['parentId'];
    comment = json['comment'];
    repliesCount = json['repliesCount'];
    createdAt = json['createdAt'];
    userDetails = json['userDetails'] != null
        ? UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['postId'] = postId;
    data['userId'] = userId;
    data['parentId'] = parentId;
    data['comment'] = comment;
    data['repliesCount'] = repliesCount;
    data['createdAt'] = createdAt;
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? userName;
  String? avatar;
  bool? isDeleted;

  UserDetails({
    this.userName,
    this.avatar,
    this.isDeleted,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    avatar = json['avatar'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['avatar'] = avatar;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

class UserModel {
  String? id;
  String? name;
  String? userName;
  String? email;
  String? avatar;
  String? bio;
  int? credits;
  int? subspacesJoined;
  int? postsCount;
  bool? isDeleted;
  String? dateJoined;
  int? iV;
  bool? viaGoogle;

  UserModel({
    this.id,
    this.name,
    this.userName,
    this.email,
    this.avatar,
    this.bio,
    this.credits,
    this.subspacesJoined,
    this.postsCount,
    this.isDeleted,
    this.dateJoined,
    this.iV,
    this.viaGoogle,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    userName = json['userName'];
    email = json['email'];
    avatar = json['avatar'];
    bio = json['bio'];
    credits = json['credits'];
    subspacesJoined = json['subspacesJoined'];
    postsCount = json['postsCount'];
    isDeleted = json['isDeleted'];
    dateJoined = json['dateJoined'];
    iV = json['__v'];
    viaGoogle = json['viaGoogle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['userName'] = userName;
    data['email'] = email;
    data['avatar'] = avatar;
    data['bio'] = bio;
    data['credits'] = credits;
    data['subspacesJoined'] = subspacesJoined;
    data['postsCount'] = postsCount;
    data['isDeleted'] = isDeleted;
    data['dateJoined'] = dateJoined;
    data['__v'] = iV;
    data['viaGoogle'] = viaGoogle;
    return data;
  }
}
