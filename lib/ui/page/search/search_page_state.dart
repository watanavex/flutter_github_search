import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_page_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.uninitialized() = SearchStateUninitialized;

  const factory SearchState.searching() = SearchStateSearching;

  const factory SearchState.success({
    required List<RepositorySummary> repositories,
    required String query,
    required int page,
    required bool hasNext,
  }) = SearchStateSuccess;

  const factory SearchState.fetchingNext({
    required List<RepositorySummary> repositories,
    required String query,
    required int page,
  }) = SearchStateFetchingNext;

  const factory SearchState.fail() = SearchStateFail;

  const factory SearchState.empty() = SearchStateEmpty;
}

@freezed
class RepositorySummary with _$RepositorySummary {
  const factory RepositorySummary({
    required String owner,
    required String name,
    required String imageUrl,
  }) = _RepositorySummary;
}
