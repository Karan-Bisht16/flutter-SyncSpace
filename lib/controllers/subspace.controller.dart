import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncspace/api/api.dart';
import 'package:syncspace/models/api.response.model.dart';

class Subspace {
  final APIService api = APIService();

  Future<APIResponse> fetchSubspaces(
    int pageParams,
    Object searchQuery,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');

    APIResponse response = await api.post(
      'subspace',
      {
        'pageParams': pageParams,
        'searchQuery': searchQuery,
      },
      {
        'Cookie': 'accessToken=$accessToken; refreshToken=$refreshToken',
      },
    );

    if (response.statusCode == 200) {
      var responseData = response.responseData;
      FetchedSubspaces fetchedSubspaces =
          FetchedSubspaces.fromJson(responseData.data);
      response.responseData = fetchedSubspaces;
      response.message = 'Subspaces fetched';
    }
    return response;
  }
}
