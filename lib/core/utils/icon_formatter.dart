import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget formatIcon(String path, {double? size, BoxFit fit = BoxFit.contain}) {
  final isUrl = path.startsWith('http://') || path.startsWith('https://');

  // URL (network)
  if (isUrl) {
    if (path.endsWith('.svg')) {
      // SVG URL
      return SvgPicture.network(path, width: size, height: size, fit: fit);
    } else {
      // PNG/JPG URL
      return Image.network(
        path,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, _, __) =>
            const Icon(Icons.broken_image, size: 24),
      );
    }
  }

  // Local assets
  if (path.endsWith('.svg')) {
    return SvgPicture.asset(path, width: size, height: size, fit: fit);
  }

  return Image.asset(path, width: size, height: size, fit: fit);
}
