import 'package:flutter/material.dart';
import 'package:flutter_github_search/ui/component/circle_image.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';

class SearchResultListTile extends StatelessWidget {
  const SearchResultListTile(
      {Key? key, required this.repositorySummary, required this.onTap})
      : super(key: key);

  final RepositorySummary repositorySummary;
  final void Function(RepositorySummary) onTap;
  static const _leadingSize = 56.0;
  static const _placeholder = Icon(
    Icons.person,
    size: _leadingSize,
  );

  @override
  Widget build(BuildContext context) {
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
      onTap: () {
        onTap(repositorySummary);
      },
    );
  }
}
