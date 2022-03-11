import 'package:flutter/foundation.dart';
import 'package:flutter_github_search/api/data/search_result.dart';
import 'package:flutter_github_search/api/search_api.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchStateNotifierProvider =
    StateNotifierProvider.autoDispose<SearchStateNotifier, SearchState>(
        (ref) => SearchStateNotifier(ref.read));

class SearchStateNotifier extends StateNotifier<SearchState> {
  SearchStateNotifier(this._reade) : super(const SearchState.uninitialized());

  final Reader _reade;
  SearchApi get _searchApi => _reade(searchApiProvider);

  Future<void> searchRepositories(String query) async {
    if (state is SearchStateSearching) {
      return;
    }

    state = const SearchState.searching();

    const page = 1;
    final SearchResult result;
    try {
      result = await _searchApi.search(query, page);
    } on Exception catch (e) {
      debugPrint('$e');
      state = const SearchState.fail();
      return;
    }

    if (result.items.isEmpty) {
      state = const SearchState.empty();
      return;
    }

    state = SearchState.success(
      repositories: result.repositories,
      query: query,
      page: page,
      hasNext: result.hasNext,
    );
  }

  Future<void> fetchNext() async {
    if (state is SearchStateSearching || state is SearchStateFetchingNext) {
      return;
    }

    final currentState = state.maybeMap(
      success: (value) => value,
      orElse: () {
        AssertionError();
      },
    )!;

    final query = currentState.query;
    final page = currentState.page + 1;
    state = SearchState.fetchingNext(
      repositories: currentState.repositories,
      query: query,
      page: page,
    );

    final SearchResult result;
    try {
      result = await _searchApi.search(query, page);
    } on Exception catch (e) {
      debugPrint('$e');
      state = SearchState.success(
        repositories: currentState.repositories,
        query: query,
        page: page,
        hasNext: false,
      );
      return;
    }

    state = SearchState.success(
      repositories: currentState.repositories + result.repositories,
      query: query,
      page: page,
      hasNext: result.hasNext,
    );
  }

  @visibleForTesting
  set debugState(SearchState state) {
    assert(() {
      this.state = state;
      return true;
    }(), '');
  }
}

extension Pagination on SearchResult {
  bool get hasNext => totalCount > items.length;

  List<RepositorySummary> get repositories => items
      .map((repo) => RepositorySummary(
            owner: repo.owner.login,
            name: repo.name,
            imageUrl: repo.owner.avatarUrl,
          ))
      .toList();
}
