import 'package:dio/dio.dart';
import 'package:syncspace/models/api.response.model.dart';

class APIService {
  final Dio dio = Dio();
  APIService() {
    configureDio();
  }

  void configureDio() {
    dio.options = BaseOptions(
      baseUrl: 'https://syncspace-backend-karan-bishts-projects.vercel.app/',
    );
  }

  APIResponse processResponse(Response response) {
    APIResponse apiResponse = APIResponse(
      statusCode: response.statusCode,
      responseData: response,
    );
    return apiResponse;
  }

  APIResponse handleError(errorResponse) {
    if (errorResponse != null) {
      var serverMessage = errorResponse!.data['message'];
      APIResponse newErrorResponse = APIResponse(
        statusCode: errorResponse!.statusCode,
        message: serverMessage,
      );
      return newErrorResponse;
    } else {
      APIResponse newErrorResponse = APIResponse(
        statusCode: errorResponse!.statusCode,
        message: 'Server side error',
      );
      return newErrorResponse;
    }
  }

  Future<dynamic> get(String path, Map<String, dynamic>? params,
      [Map<String, dynamic>? cookie]) async {
    try {
      dio.options.headers.addAll(cookie ?? {});
      Response response = await dio.get(path, queryParameters: params);
      return processResponse(response);
    } on DioException catch (error) {
      return handleError(error.response);
    }
  }

  Future<dynamic> post(String path, Object body,
      [Map<String, dynamic>? cookie]) async {
    try {
      dio.options.headers.addAll(cookie ?? {});
      Response response = await dio.post(path, data: body);
      return processResponse(response);
    } on DioException catch (error) {
      return handleError(error.response);
    }
  }

  Future<dynamic> patch(String path, Object body,
      [Map<String, dynamic>? cookie]) async {
    try {
      dio.options.headers.addAll(cookie ?? {});
      Response response = await dio.patch(path, data: body);
      return processResponse(response);
    } on DioException catch (error) {
      return handleError(error.response);
    }
  }
}
