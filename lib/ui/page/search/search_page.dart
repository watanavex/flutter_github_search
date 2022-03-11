import 'package:flutter/material.dart';
import 'package:flutter_github_search/ui/component/error_view.dart';
import 'package:flutter_github_search/ui/component/loading_view.dart';
import 'package:flutter_github_search/ui/page/detail/detail_page.dart';
import 'package:flutter_github_search/ui/page/search/notifier/search_state_notifier.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
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
        uninitialized: () {
          return Container();
        },
        searching: () {
          return const LoadingView();
        },
        success: (repositories, query, page, hasNext) {
          return SearchResultListView(
            repositories: repositories,
            hasNext: hasNext,
            onTapItem: (repositorySummary) {
              _onTapListItem(context, repositorySummary);
            },
          );
        },
        fetchingNext: (repositories, query, page) {
          return SearchResultListView(
            repositories: repositories,
            hasNext: true,
            onTapItem: (repositorySummary) {
              _onTapListItem(context, repositorySummary);
            },
          );
        },
        fail: () {
          return const ErrorView();
        },
        empty: () {
          return const ErrorView(
            message: '検索結果は0件です',
          );
        },
      ),
    );
  }

  void _onTapListItem(
      BuildContext context, RepositorySummary repositorySummary) {
    Navigator.push(
      context,
      MaterialPageRoute<DetailPage>(
        builder: (_) => DetailPage(
          owner: repositorySummary.owner,
          name: repositorySummary.name,
        ),
      ),
    );
  }
}
