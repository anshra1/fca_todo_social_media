import 'package:flutter/material.dart';

class NetworkImageWithOutCache extends StatelessWidget {
  const NetworkImageWithOutCache({
    required this.url,
    super.key,
    this.width,
    this.height,
    this.loadingWidget,
    this.errorWidget,
  });

  final String url;
  final double? width;
  final double? height;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: width ?? 35,
      height: height ?? 35,
      loadingBuilder: (context, child, loadingProgress) {
        return loadingWidget ?? const SizedBox();
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const SizedBox();
      },
    );
  }
}
