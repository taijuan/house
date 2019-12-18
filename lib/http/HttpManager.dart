import 'package:dio/dio.dart';
import 'package:house/http/BaseRes.dart';
import 'package:house/importLib.dart';
import 'package:meta/meta.dart';

class HttpManager {
  static const String DNS = "http://103.253.239.165/";
  static const String BASE_URL = "${DNS}house-api";

  const HttpManager();

  static final dio = Dio(
    BaseOptions(
      receiveTimeout: 30000,
      connectTimeout: 30000,
      baseUrl: BASE_URL,
      responseType: ResponseType.json,
      contentType: "application/x-www-form-urlencoded",
    ),
  );

  static Future<BaseRes> post(
    BuildContext context, {
    @required path,
    Map<String, dynamic> data,
    CancelToken cancelToken,
  }) async {
    data.removeWhere((key, value) {
      return value == null;
    });
    LogUtils.log(data);
    LogUtils.log(BASE_URL + path);
    LogUtils.log("#######################################");
    Response response = await dio.post(
      path,
      data: FormData.fromMap(data),
      cancelToken: cancelToken,
    );
    LogUtils.log(response.request.baseUrl);
    LogUtils.log(response.request.path);
    LogUtils.log(response.request.data);
    LogUtils.log(response.data);
    if (response.statusCode == 200) {
      return new BaseRes.fromJson(response.data);
    } else {
      throw FlutterError(HouseValue.of(context).systemException);
    }
  }

  static void catchError(e, BuildContext context) {
    LogUtils.log(e);
    if (e is DioError && e.type == DioErrorType.CONNECT_TIMEOUT) {
      throw FlutterError(e.message);
    } else if (e is DioError && e.type == DioErrorType.RECEIVE_TIMEOUT) {
      throw FlutterError(e.message);
    } else if (e is DioError && e.type == DioErrorType.RESPONSE) {
      throw FlutterError(e.message);
    } else if (e is DioError && e.type == DioErrorType.DEFAULT) {
      throw FlutterError(e.message);
    } else {
      throw FlutterError(HouseValue.of(context).systemException);
    }
  }
}
