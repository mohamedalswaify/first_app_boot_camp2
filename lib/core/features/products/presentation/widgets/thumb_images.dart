import 'package:flutter/material.dart';

class ThumbImages extends StatelessWidget {
  final String? url;
  const ThumbImages({this.url});

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return Image.network(
        url!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (ctx, child, evt) =>
            evt == null ? child : _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 28, color: Colors.grey),
    );
  }
}
