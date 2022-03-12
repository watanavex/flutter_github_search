import 'package:flutter/material.dart';
import 'package:flutter_github_search/ui/page/detail/detail_page.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchPageNavigatorProvider =
    Provider<SearchPageNavigator>((ref) => const SearchPageNavigator());

class SearchPageNavigator {
  const SearchPageNavigator();
  Future<void> pushDetailPage(
      BuildContext context, RepositorySummary repositorySummary) {
    return Navigator.push(
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
