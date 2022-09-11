import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../config/config.dart';
import 'pretty_dio_logger.dart';

// @see https://github.com/flutterchina/dio/blob/master/example/lib/response_interceptor.dart

class HttpClient {
  late Dio _dio;

  final BaseOptions _options = BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    validateStatus: (_) => true,
    connectTimeout: 60 * 1000,
    receiveTimeout: 60 * 1000,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    headers: {
      'Accept': '*/*',
    },
  );
  static final HttpClient _instance = HttpClient._internal();

  factory HttpClient() => _instance;

  HttpClient._internal() {
    _dio = Dio(_options);
    _dio.interceptors.clear();
    final cookieJar = CookieJar();
    // first request, and save cookies (CookieManager do it).
    // second request with the cookies
    _dio.interceptors
      ..add(CookieManager(cookieJar))
      ..add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Do something before request is sent
            return handler.next(options); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onResponse: (response, handler) {
            // Do something with response data
            // Print cookies
            // List<Cookie> cookies = await cookieJar.loadForRequest(response.requestOptions.uri);
            // if (cookies.isNotEmpty && cookies.length == 2) {
            //   final authenticationToken = cookies[0].toString().split(';')[0];
            //   print(authenticationToken);
            //   final refreshToken = cookies[0].toString().split(';')[0];
            //   print(refreshToken);
            // }
            return handler.next(response); // continue
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onError: (DioError e, handler) {
            // Do something with response error
            return handler.next(e); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
          },
        ),
      )
      ..add(
        QueuedInterceptorsWrapper(
          onError: (error, handler) {
            final options = error.response!.requestOptions;
            if (error.response?.statusCode == 401) {
              _dio.get<dynamic>('/auth/refresh').then(
                (_) {
                  _dio.fetch(options).then(
                    (response) => handler.resolve(response),
                    onError: (err) {
                      handler.reject(err);
                    },
                  );
                },
                onError: (err) {
                  handler.reject(err);
                },
              );
            }
            return handler.next(error);
          },
        ),
      )
      ..add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // https://www.developerlibs.com/2020/06/flutter-dio-client-to-create-http.html
  // Multiple Concurrent Requests
  Future developerlibs() async {
    List<Response> response =
        await Future.wait([_dio.post("/info"), _dio.get("/token")]);
    // print(response.data);
  }

  // Download A File From Server.

  download() async {
    Response response =
        await _dio.download("https://www.developerlibs.com/pdf", '');
    print(response.data);
  }

  // Sending FormData
  sendFormData() async {
    FormData formData = FormData.fromMap({
      "name": "imhsa",
      "age": 22,
    });
    Response response = await _dio.post("/info", data: formData);
    print(response.data);
  }

  // Uploading Multiple Files To Server By FormData
  uploadMultipleFiles() async {
    FormData formData = FormData.fromMap({
      "name": "developerlibs",
      "age": 5,
      "file": await MultipartFile.fromFile("./developerlibs.txt",
          filename: "developerlibs.txt"),
      "files": [
        await MultipartFile.fromFile("./developerlibs.txt",
            filename: "developerlibs.txt"),
        await MultipartFile.fromFile("./developerlibs.txt",
            filename: "developerlibs.txt"),
      ]
    });
    Response response = await _dio.post("/resource", data: formData);
  }
}
