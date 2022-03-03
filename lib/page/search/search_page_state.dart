import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'search_page_state.freezed.dart';

@freezed
class SearchPageState with _$SearchPageState {
  const factory SearchPageState({
    required bool isSearchMode,
    required SearchState searchState,
  }) = _SearchPageState;
}

@freezed
class SearchState with _$SearchState {
  const factory SearchState.uninitialized() = Uninitialized;
  const factory SearchState.searching() = Searching;
  factory SearchState.success({
    required List<RepositorySummary> repositories,
    required String query,
    required int page,
    required bool hasNext,
  }) = Success;
  const factory SearchState.fetchingNext({
    required List<RepositorySummary> repositories,
    required String query,
    required int page,
  }) = FetchingNext;
  const factory SearchState.fail() = Fail;
  const factory SearchState.empty() = Empty;
}

@freezed
class RepositorySummary with _$RepositorySummary {
  const factory RepositorySummary({
    required String owner,
    required String name,
    required String imageUrl,
  }) = _RepositorySummary;
  factory RepositorySummary.fromJson(Map<String, dynamic> json) =>
      _$RepositorySummaryFromJson(json);
}
