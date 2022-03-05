// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:flutter_github_search/ui/component/circle_image_view.dart';
import 'package:flutter_github_search/ui/component/error_view.dart';
import 'package:flutter_github_search/ui/component/loading_view.dart';
import 'package:flutter_github_search/ui/component/pagination_list_view.dart';
import 'package:flutter_github_search/ui/page/detail/detail_page.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state_notifier.dart';

// 🌎 Project imports:

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
        return const LoadingView();
      },
      success: (repositories, query, page, haxNext) {
        return _buildListView(context, ref, repositories, haxNext);
      },
      fetchingNext: (repositories, query, page) {
        return _buildListView(context, ref, repositories, true);
      },
      fail: () {
        return const ErrorView();
      },
      empty: () {
        return const ErrorView(
          message: '検索結果は0件です',
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, WidgetRef ref,
      List<RepositorySummary> repositories, bool hasNext) {
    final notifier = ref.read(searchPageStateNotifierProvider.notifier);
    return PaginationListView(
      itemCount: repositories.length,
      hasNext: hasNext,
      fetchNext: notifier.fetchNext,
      itemBuilder: (context, index) {
        return _buildListItems(context, ref, repositories[index]);
      },
    );
  }

  Widget _buildListItems(
      BuildContext context, WidgetRef ref, RepositorySummary item) {
    const leadingSize = 56.0;
    const placeholder = Icon(
      Icons.person,
      size: leadingSize,
    );
    return ListTile(
      leading: CircleImageView(
        imageUrl: item.imageUrl,
        placeholder: () => placeholder,
      ),
      title: Text(
        item.name,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        item.owner,
        style: Theme.of(context).textTheme.caption,
      ),
      minLeadingWidth: leadingSize,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<DetailPage>(
            builder: (_) => DetailPage(
              owner: item.owner,
              name: item.name,
            ),
          ),
        );
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
