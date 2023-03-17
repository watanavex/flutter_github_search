import 'package:flutter/material.dart';

import 'package:flutter_github_search/ui/component/loading_view.dart';

class PaginationListView extends StatelessWidget {
  const PaginationListView({
    Key? key,
    required this.itemCount,
    required this.hasNext,
    required this.fetchNext,
    required this.itemBuilder,
  }) : super(key: key);

  final int itemCount;
  final bool hasNext;
  final void Function() fetchNext;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: NotificationListener<ScrollNotification>(
        child: ListView.builder(
          itemCount: itemCount + (hasNext ? 1 : 0),
          itemBuilder: (context, index) {
            if (!hasNext || index < itemCount) {
              return itemBuilder(context, index);
            }
            return const LoadingView();
          },
        ),
        onNotification: (notification) {
          if (notification.metrics.atEdge &&
              notification.metrics.extentAfter == 0) {
            fetchNext();
          }
          return false;
        },
      ),
    );
  }
}
