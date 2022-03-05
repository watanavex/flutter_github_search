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
      return _buildDataBody(context, data);
    }, error: (error, stackTrace) {
      return const ErrorView();
    }, loading: () {
      return const LoadingView();
    });
  }

  Widget _buildDataBody(
      BuildContext context, RepositoryDetail repositoryDetail) {
    return _buildDataColumn(
      children: [
        _buildOwnerImage(context, repositoryDetail.imageUrl),
        const SizedBox(height: 15),
        _buildAutoTextHeadline2(context, repositoryDetail.name),
        const SizedBox(height: 15),
        _buildAutoTextHeadline6(context, repositoryDetail.owner),
        const SizedBox(height: 15),
        if (repositoryDetail.description != null)
          _buildTextCaption(context, repositoryDetail.description!),
        const SizedBox(height: 15),
        _buildAutoTextHeadline6(context, repositoryDetail.language ?? ''),
        const SizedBox(height: 60),
        _buildIconWithText(context, const Icon(Icons.copy),
            '${repositoryDetail.forksCount} forks'),
        const SizedBox(height: 15),
        _buildIconWithText(context, const Icon(Icons.star),
            '${repositoryDetail.starCount} stars'),
        const SizedBox(height: 15),
        _buildIconWithText(context, const Icon(Icons.remove_red_eye),
            '${repositoryDetail.watchersCount} watchers'),
        const SizedBox(height: 15),
        _buildIconWithText(context, const Icon(Icons.remove_circle_sharp),
            'open ${repositoryDetail.issueCount} issues'),
      ],
    );
  }

  Widget _buildDataColumn({required List<Widget> children}) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  Widget _buildOwnerImage(BuildContext context, String imageUrl) {
    const imageWidthFactor = 0.5;
    final size = MediaQuery.of(context).size;
    final placeholder = Icon(
      Icons.person,
      size: size.width * imageWidthFactor,
    );
    return FractionallySizedBox(
      widthFactor: imageWidthFactor,
      alignment: FractionalOffset.center,
      child: CircleImageView(
        imageUrl: imageUrl,
        placeholder: placeholder,
      ),
    );
  }

  Widget _buildAutoTextHeadline2(BuildContext context, String text) {
    return AutoSizeText(
      text,
      style: Theme.of(context).textTheme.headline2,
      maxLines: 1,
    );
  }

  Widget _buildAutoTextHeadline6(BuildContext context, String text) {
    return AutoSizeText(
      text,
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
    );
  }

  Widget _buildTextCaption(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget _buildIconWithText(BuildContext context, Icon icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 5),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
