import 'package:dio/dio.dart';
import 'package:flutter_github_search/api/data/repository_detail.dart';
import 'package:flutter_github_search/api/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'repository_detail_api.g.dart';

final repositoryApiProvider =
    Provider((ref) => RepositoryDetailApi(ref.watch(dioProvider)));

@RestApi(baseUrl: 'https://api.github.com')
abstract class RepositoryDetailApi {
  factory RepositoryDetailApi(Dio dio) = _RepositoryDetailApi;

  @GET('/repos/{owner}/{repo}')
  Future<RepositoryDetail> fetch(
    @Path() String owner,
    @Path() String repo,
  );
}
