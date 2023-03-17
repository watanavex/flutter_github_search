import 'package:flutter/material.dart';
import 'package:flutter_github_search/ui/component/circle_image.dart';
import 'package:flutter_github_search/ui/page/search/search_page_navigator.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchResultListTile extends ConsumerWidget {
  const SearchResultListTile({Key? key, required this.repositorySummary})
      : super(key: key);

  final RepositorySummary repositorySummary;
  static const _leadingSize = 56.0;
  static const _placeholder = Icon(
    Icons.person,
    size: _leadingSize,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPageNavigator = ref.watch(searchPageNavigatorProvider);
    return ListTile(
      leading: CircleImage(
        imageUrl: repositorySummary.imageUrl,
        placeholder: _placeholder,
      ),
      title: Text(
        repositorySummary.name,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        repositorySummary.owner,
        style: Theme.of(context).textTheme.caption,
      ),
      minLeadingWidth: _leadingSize,
      onTap: () =>
          searchPageNavigator.pushDetailPage(context, repositorySummary),
    );
  }
}
