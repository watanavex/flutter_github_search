// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:flutter_github_search/api/data/search_result.dart';
import 'package:flutter_github_search/api/search_api.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';

final searchPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<SearchPageStateNotifier, SearchPageState>(
        (ref) => SearchPageStateNotifier(ref.read));

class SearchPageStateNotifier extends StateNotifier<SearchPageState> {
  SearchPageStateNotifier(this._reader)
      : super(
          const SearchPageState(
            isSearchMode: false,
            searchState: SearchState.uninitialized(),
          ),
        );

  final Reader _reader;
  late final _searchApi = _reader(searchApiProvider);

  void toggleMode() {
    final newIsSearchMode = !state.isSearchMode;
    state = state.copyWith(isSearchMode: newIsSearchMode);
  }

  Future<void> searchRepositories(String query) async {
    if (state.searchState is Searching) {
      return;
    }

    state = state.copyWith(
      searchState: const SearchState.searching(),
    );

    const page = 1;
    final SearchResult result;
    try {
      result = await _searchApi.search(query, page);
    } on Exception catch (e) {
      debugPrint('$e');
      state = state.copyWith(
        searchState: const SearchState.fail(),
      );
      return;
    }

    if (result.items.isEmpty) {
      state = state.copyWith(searchState: const SearchState.empty());
      return;
    }

    state = state.copyWith(
      searchState: SearchState.success(
          repositories: result.repositories,
          query: query,
          page: page,
          hasNext: result.hasNext),
    );
  }

  Future<void> fetchNext() async {
    if (state.searchState is Searching || state.searchState is FetchingNext) {
      return;
    }

    final currentState = state.searchState.maybeMap(
      success: (value) => value,
      orElse: () {
        AssertionError();
      },
    )!;

    final query = currentState.query;
    final page = currentState.page + 1;
    state = state.copyWith(
      searchState: SearchState.fetchingNext(
        repositories: currentState.repositories,
        query: query,
        page: page,
      ),
    );

    final SearchResult result;
    try {
      result = await _searchApi.search(query, page);
    } on Exception catch (e) {
      debugPrint('$e');
      state = state.copyWith(
        searchState: SearchState.success(
          repositories: currentState.repositories,
          query: query,
          page: page,
          hasNext: false,
        ),
      );
      return;
    }

    state = state.copyWith(
      searchState: SearchState.success(
        repositories: currentState.repositories + result.repositories,
        query: query,
        page: page,
        hasNext: result.hasNext,
      ),
    );
  }

  set debugState(SearchPageState state) {
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
