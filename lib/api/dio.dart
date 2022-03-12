import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();

  // flutter run --debug --dart-define=API_TOKEN={YOUR_GITHUB_API_TOKEN}
  const apiToken = String.fromEnvironment('API_TOKEN');
  if (apiToken.isNotEmpty) {
    dio.options.headers['Authorization'] = 'token $apiToken';
  }
  return dio;
});
