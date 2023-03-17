// 🎯 Dart imports:
import 'dart:convert';

import 'package:flutter_github_search/api/data/search_result.dart';
import 'package:flutter_github_search/api/search_api.dart';
import 'package:flutter_github_search/ui/page/search/notifier/search_state_notifier.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy/dummy_search_result.dart';
import '../../helper.dart';
import 'seach_page_state_notifier_test.mocks.dart';

late MockSearchApi _mockSearchApi;
late ProviderContainer _container;
final SearchResult _dummySearchResult = () {
  final map = json.decode(dummySearchResponse) as Map<String, dynamic>;
  return SearchResult.fromJson(map);
}();

@GenerateMocks([SearchApi])
void main() {
  setUp(() {
    _mockSearchApi = MockSearchApi();
    when(_mockSearchApi.search(any, any))
        .thenAnswer((realInvocation) => Future.value(_dummySearchResult));

    _container = ProviderContainer(
      overrides: [searchApiProvider.overrideWithValue(_mockSearchApi)],
    );
  });

  tearDown(() {
    _container.dispose();
  });

  test('searchRepositories success', () async {
    final notifier = _container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<SearchState>();
    _container.listen(
      searchStateNotifierProvider,
      listener,
      fireImmediately: true,
    );

    // given
    // when
    await notifier.searchRepositories('query');

    // then
    final repositories = _dummySearchResult.items
        .map((e) => RepositorySummary(
              owner: e.owner.login,
              name: e.name,
              imageUrl: e.owner.avatarUrl,
            ))
        .toList();

    verifyInOrder([
      listener(any, const SearchState.uninitialized()),
      listener(any, const SearchState.searching()),
      listener(
        any,
        SearchState.success(
          repositories: repositories,
          query: 'query',
          page: 1,
          hasNext: true,
        ),
      ),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test('searchRepositories fail', () async {
    final notifier = _container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<SearchState>();
    _container.listen(
      searchStateNotifierProvider,
      listener,
      fireImmediately: true,
    );

    // given
    when(_mockSearchApi.search(any, any))
        .thenAnswer((realInvocation) => Future.error(Exception()));

    // when
    await notifier.searchRepositories('query');

    // then
    verifyInOrder([
      listener(any, const SearchState.uninitialized()),
      listener(any, const SearchState.searching()),
      listener(any, const SearchState.fail()),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test('searchRepositories empty', () async {
    final notifier = _container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<SearchState>();
    _container.listen(
      searchStateNotifierProvider,
      listener,
      fireImmediately: true,
    );

    // given
    when(_mockSearchApi.search(any, any))
        .thenAnswer((realInvocation) => Future.value(const SearchResult(
              totalCount: 0,
              incompleteResults: false,
              items: [],
            )));

    // when
    await notifier.searchRepositories('query');

    // then
    verifyInOrder([
      listener(any, const SearchState.uninitialized()),
      listener(any, const SearchState.searching()),
      listener(any, const SearchState.empty()),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test('fetchNext success', () async {
    final notifier = _container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<SearchState>();
    _container.listen(
      searchStateNotifierProvider,
      listener,
      fireImmediately: true,
    );

    // given
    notifier.debugState = const SearchState.success(
      repositories: [],
      query: 'query',
      page: 1,
      hasNext: true,
    );

    // when
    await notifier.fetchNext();

    // then
    final repositories = _dummySearchResult.items
        .map((e) => RepositorySummary(
              owner: e.owner.login,
              name: e.name,
              imageUrl: e.owner.avatarUrl,
            ))
        .toList();

    verifyInOrder([
      listener(any, const SearchState.uninitialized()),
      listener(
        any,
        const SearchState.success(
          repositories: [],
          query: 'query',
          page: 1,
          hasNext: true,
        ),
      ),
      listener(
        any,
        const SearchState.fetchingNext(
          repositories: [],
          query: 'query',
          page: 2,
        ),
      ),
      listener(
        any,
        SearchState.success(
          repositories: repositories,
          query: 'query',
          page: 2,
          hasNext: true,
        ),
      ),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test('fetchNext fail', () async {
    final notifier = _container.read(searchStateNotifierProvider.notifier);

    final listener = Listener<SearchState>();
    _container.listen(
      searchStateNotifierProvider,
      listener,
      fireImmediately: true,
    );

    // given
    notifier.debugState = const SearchState.success(
      repositories: [],
      query: 'query',
      page: 1,
      hasNext: true,
    );
    when(_mockSearchApi.search(any, any))
        .thenAnswer((realInvocation) => Future.error(Exception()));

    // when
    await notifier.fetchNext();

    // then
    verifyInOrder([
      listener(any, const SearchState.uninitialized()),
      listener(
        any,
        const SearchState.success(
          repositories: [],
          query: 'query',
          page: 1,
          hasNext: true,
        ),
      ),
      listener(
        any,
        const SearchState.fetchingNext(
          repositories: [],
          query: 'query',
          page: 2,
        ),
      ),
      listener(
        any,
        const SearchState.success(
          repositories: [],
          query: 'query',
          page: 2,
          hasNext: false,
        ),
      ),
    ]);
    verifyNoMoreInteractions(listener);
  });
}
