import 'package:flutter/foundation.dart';
import 'package:flutter_github_search/api/data/repository_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required int totalCount,
    required bool incompleteResults,
    required List<RepositorySummary> items,
  }) = _SearchResult;
  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}
