// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:flutter_github_search/page/search/search_page_state_notifier.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _SearchAppBar(),
      body: _buildBody(context, ref),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(
        searchPageStateNotifierProvider.select((value) => value.searchState));
    return searchState.when(
      uninitialized: () {
        return Container();
      },
      searching: () {
        return const Text('searching');
      },
      success: (repositories, query, page, haxNext) {
        return const Text('success');
      },
      fetchingNext: (repositories, query, page) {
        return const Text('fetchingNext');
      },
      fail: () {
        return const Text('fail');
      },
      empty: () {
        return const Text('empty');
      },
    );
  }
}

class _SearchAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  final _searchIcon = const Icon(Icons.search);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearchMode = ref.watch(
        searchPageStateNotifierProvider.select((value) => value.isSearchMode));
    return isSearchMode ? _buildSearchBar(ref) : _buildNormalBar(ref);
  }

  PreferredSizeWidget _buildNormalBar(WidgetRef ref) {
    final stateNotifier = ref.watch(searchPageStateNotifierProvider.notifier);
    return AppBar(
      title: const Text('Github Search App'),
      actions: [
        IconButton(
          onPressed: stateNotifier.toggleMode,
          icon: _searchIcon,
        )
      ],
    );
  }

  PreferredSizeWidget _buildSearchBar(WidgetRef ref) {
    final stateNotifier = ref.watch(searchPageStateNotifierProvider.notifier);
    return AppBar(
      leading: _searchIcon,
      title: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: '検索ワードを入力してください',
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: stateNotifier.searchRepositories,
      ),
      actions: [
        IconButton(
          onPressed: stateNotifier.toggleMode,
          icon: const Icon(Icons.close),
        )
      ],
    );
  }
}
