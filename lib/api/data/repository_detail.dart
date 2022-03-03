// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'package:flutter_github_search/api/data/owner.dart';

part 'repository_detail.freezed.dart';
part 'repository_detail.g.dart';

@freezed
class RepositoryDetail with _$RepositoryDetail {
  const factory RepositoryDetail({
    required String name,
    required Owner owner,
    required int stargazersCount,
    required int forksCount,
    required int openIssuesCount,
    required int subscribersCount,
    String? description,
    String? language,
  }) = _RepositoryDetail;

  factory RepositoryDetail.fromJson(Map<String, dynamic> json) =>
      _$RepositoryDetailFromJson(json);
}
