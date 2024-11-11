import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncspace/api/api.dart';
import 'package:syncspace/models/api.response.model.dart';

class Post {
  final APIService api = APIService();

  Future<APIResponse> fetchPosts(
    int pageParams,
    Object? searchQuery,
    String customParams,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');
    APIResponse response = APIResponse();
    if (accessToken != null && refreshToken != null) {
      response = await api.post(
        'post/',
        {
          'pageParams': pageParams,
          'searchQuery': searchQuery,
          'customParams': customParams,
        },
        {
          'Cookie': 'accessToken=$accessToken; refreshToken=$refreshToken',
        },
      );
    } else {
      response = await api.post('post/', {
        'pageParams': pageParams,
        'searchQuery': searchQuery,
        'customParams': customParams,
      });
    }

    if (response.statusCode == 200) {
      var responseData = response.responseData;
      FetchedPosts fetchedPosts = FetchedPosts.fromJson(responseData.data);
      response.responseData = fetchedPosts;
      response.message = 'Post fetched';
    }

    return response;
  }

  Future<APIResponse> isPostLiked(
    String postId,
    String userId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');

    APIResponse response = await api.get(
      'post/isLiked/',
      {
        'postId': postId,
        'userId': userId,
      },
      {
        'Cookie': 'accessToken=$accessToken; refreshToken=$refreshToken',
      },
    );

    if (response.statusCode == 200) {
      var responseData = response.responseData;
      response.responseData = responseData.data;
      response.message = 'Is post liked?';
    }

    return response;
  }

  Future<APIResponse> likePost(
    String postId,
    String userId,
    bool action,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');

    APIResponse response = await api.patch(
      'post/like/',
      {
        'postId': postId,
        'userId': userId,
        'action': action,
      },
      {
        'Cookie': 'accessToken=$accessToken; refreshToken=$refreshToken',
      },
    );
    if (response.statusCode == 200) {
      response.responseData = true;
      response.message = 'Post liked';
    }

    return response;
  }
}
