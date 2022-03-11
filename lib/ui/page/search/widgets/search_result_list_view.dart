import 'package:flutter/material.dart';
import 'package:flutter_github_search/ui/component/pagination_list_view.dart';
import 'package:flutter_github_search/ui/page/search/notifier/search_state_notifier.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
import 'package:flutter_github_search/ui/page/search/widgets/search_result_list_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchResultListView extends ConsumerWidget {
  const SearchResultListView({
    Key? key,
    required this.repositories,
    required this.hasNext,
    required this.onTapItem,
  }) : super(key: key);

  final List<RepositorySummary> repositories;
  final bool hasNext;
  final void Function(RepositorySummary) onTapItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(searchStateNotifierProvider.notifier);
    return PaginationListView(
      itemCount: repositories.length,
      hasNext: hasNext,
      fetchNext: notifier.fetchNext,
      itemBuilder: (context, index) {
        return SearchResultListTile(
          repositorySummary: repositories[index],
          onTap: onTapItem,
        );
      },
    );
  }
}
