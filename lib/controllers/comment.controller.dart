import 'package:syncspace/api/api.dart';
import 'package:syncspace/models/api.response.model.dart';

class Comment {
  final APIService api = APIService();

  Future<APIResponse> fetchComments(
    String postId,
  ) async {
    APIResponse response = await api.get('comment/', {'id': postId});
    if (response.statusCode == 200) {
      var responseData = response.responseData;
      List<CommentModel> fetchedComments = (responseData.data as List)
          .map((commentJson) => CommentModel.fromJson(commentJson))
          .toList();
      response.responseData = fetchedComments;
      response.message = 'Comments fetched';
    }

    return response;
  }

  Future<APIResponse> fetchReplies(
    String postId,
    String parentId,
  ) async {
    APIResponse response = await api.get('comment/reply/', {
      'postId': postId,
      'parentId': parentId,
    });
    if (response.statusCode == 200) {
      var responseData = response.responseData;
      List<CommentModel> fetchedComments = (responseData.data as List)
          .map((commentJson) => CommentModel.fromJson(commentJson))
          .toList();
      response.responseData = fetchedComments;
      response.message = 'Replies fetched';
    }

    return response;
  }
}
