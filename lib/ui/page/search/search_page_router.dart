import 'package:flutter/material.dart';
import 'package:flutter_github_search/ui/page/detail/detail_page.dart';
import 'package:flutter_github_search/ui/page/search/search_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchPageRouterProvider =
    Provider<SearchPageRouter>((ref) => const SearchPageRouter());

class SearchPageRouter {
  const SearchPageRouter();
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
