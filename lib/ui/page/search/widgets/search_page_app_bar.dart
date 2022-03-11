import 'package:flutter/material.dart';
import 'package:flutter_github_search/ui/page/search/notifier/search_mode_notifier.dart';
import 'package:flutter_github_search/ui/page/search/notifier/search_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  Icon get _searchIcon => const Icon(Icons.search);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearchMode = ref.watch(searchModeStateNotifier);
    return isSearchMode ? _buildSearchBar(ref) : _buildNormalBar(ref);
  }

  PreferredSizeWidget _buildNormalBar(WidgetRef ref) {
    final searchModeNotifier = ref.watch(searchModeStateNotifier.notifier);
    return AppBar(
      title: const Text('Github Search App'),
      actions: [
        IconButton(
          onPressed: searchModeNotifier.toggle,
          icon: _searchIcon,
        )
      ],
    );
  }

  PreferredSizeWidget _buildSearchBar(WidgetRef ref) {
    final searchModeNotifier = ref.watch(searchModeStateNotifier.notifier);
    final searchStateNotifier = ref.watch(searchStateNotifierProvider.notifier);
    return AppBar(
      leading: _searchIcon,
      title: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: '検索ワードを入力してください',
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: searchStateNotifier.searchRepositories,
      ),
      actions: [
        IconButton(
          onPressed: searchModeNotifier.toggle,
          icon: const Icon(Icons.close),
        )
      ],
    );
  }
}
