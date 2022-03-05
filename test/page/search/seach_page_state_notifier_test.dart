// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// 🌎 Project imports:
import 'package:flutter_github_search/api/data/search_result.dart';
import 'package:flutter_github_search/api/search_api.dart';
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

  test('searchRepos success', () async {
    final notifier = _container.read(searchPageStateNotifierProvider.notifier);

    final listener = Listener<SearchState>();
    _container.listen(
      searchPageStateNotifierProvider.select((value) => value.searchState),
      listener,
      fireImmediately: true,
    );

    await notifier.searchRepositories('query');

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
}
