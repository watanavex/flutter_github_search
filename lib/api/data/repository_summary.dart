// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'package:flutter_github_search/api/data/owner.dart';

part 'repository_summary.freezed.dart';
part 'repository_summary.g.dart';

@freezed
class RepositorySummary with _$RepositorySummary {
  const factory RepositorySummary({
    required String name,
    required Owner owner,
  }) = _RepositorySummary;
  factory RepositorySummary.fromJson(Map<String, dynamic> json) =>
      _$RepositorySummaryFromJson(json);
}
