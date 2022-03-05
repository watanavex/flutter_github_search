// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';

class CircleImageView extends StatelessWidget {
  const CircleImageView({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
  }) : super(key: key);

  final String imageUrl;
  final Widget Function() placeholder;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => placeholder(),
        // ignore: implicit_dynamic_parameter
        errorWidget: (context, url, _) => placeholder(),
      ),
    );
  }
}
