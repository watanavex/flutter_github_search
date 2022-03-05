// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:flutter_github_search/api/data/repository_detail.dart' as api;
import 'package:flutter_github_search/api/repository_detail_api.dart';

part 'detail_data.freezed.dart';

@freezed
class RepositoryDetail with _$RepositoryDetail {
  const factory RepositoryDetail({
    required String owner,
    required String name,
    required String imageUrl,
    required String? language,
    required String? description,
    required int starCount,
    required int forksCount,
    required int watchersCount,
    required int issueCount,
  }) = _RepositoryDetail;
}

extension _Converter on api.RepositoryDetail {
  RepositoryDetail convert() {
    return RepositoryDetail(
      owner: owner.login,
      name: name,
      imageUrl: owner.avatarUrl,
      language: language,
      description: description,
      starCount: stargazersCount,
      forksCount: forksCount,
      watchersCount: subscribersCount,
      issueCount: openIssuesCount,
    );
  }
}

@freezed
class Argment with _$Argment {
  const factory Argment({
    required String owner,
    required String name,
  }) = _Argment;
}

final repositoryDetailFutureProvider = FutureProvider.family
    .autoDispose<RepositoryDetail, Argment>((ref, arg) async {
  final api = ref.read(repositoryApiProvider);

  return api.fetch(arg.owner, arg.name).then((value) => value.convert());
});
