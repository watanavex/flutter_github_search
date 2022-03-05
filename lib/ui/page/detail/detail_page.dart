// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:flutter_github_search/ui/component/circle_image_view.dart';
import 'package:flutter_github_search/ui/component/error_view.dart';
import 'package:flutter_github_search/ui/component/loading_view.dart';
import 'package:flutter_github_search/ui/page/detail/detail_data.dart';

class DetailPage extends HookConsumerWidget {
  const DetailPage({
    Key? key,
    required this.owner,
    required this.name,
  }) : super(key: key);

  final String owner;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: _buildBody(context, ref),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final repositoryDetail = ref.watch(
        repositoryDetailFutureProvider(Argment(owner: owner, name: name)));

    return repositoryDetail.when(data: (data) {
      return Container();
    }, error: (error, stackTrace) {
      return const ErrorView();
    }, loading: () {
      return const LoadingView();
    });
  }
}
