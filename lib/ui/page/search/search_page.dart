import 'package:flutter/material.dart';
import 'package:flutter_github_search/ui/component/error_view.dart';
import 'package:flutter_github_search/ui/component/loading_view.dart';
import 'package:flutter_github_search/ui/page/search/notifier/search_state_notifier.dart';
import 'package:flutter_github_search/ui/page/search/widgets/search_page_app_bar.dart';
import 'package:flutter_github_search/ui/page/search/widgets/search_result_list_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchStateNotifierProvider);
    return Scaffold(
      appBar: const SearchAppBar(),
      body: searchState.when(
        uninitialized: () => const SizedBox.shrink(),
        searching: () => const LoadingView(),
        fail: () => const ErrorView(),
        empty: () => const ErrorView(message: '検索結果は0件です'),
        fetchingNext: (repositories, query, page) => SearchResultListView(
          repositories: repositories,
          hasNext: true,
        ),
        success: (repositories, query, page, hasNext) => SearchResultListView(
          repositories: repositories,
          hasNext: hasNext,
        ),
      ),
    );
  }
}
