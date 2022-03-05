// 🐦 Flutter imports:
import 'package:flutter/material.dart';

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
            return const Center(
              child: CircularProgressIndicator(),
            );
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
