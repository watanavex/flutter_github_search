import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
  }) : super(key: key);

  final String imageUrl;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => placeholder,
        // ignore: implicit_dynamic_parameter
        errorWidget: (context, url, _) => placeholder,
      ),
    );
  }
}
