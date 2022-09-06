import 'package:dio/dio.dart';
import 'package:sse/utils/const.dart';

var dioGoogle = Dio(BaseOptions(
  baseUrl: Const.HOST_GOOGLE_MAP_URL,
  receiveTimeout: 30000,
  connectTimeout: 30000,
));