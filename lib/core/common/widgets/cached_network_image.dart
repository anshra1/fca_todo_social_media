// ignore_for_file: lines_longer_than_80_chars

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CacheImage extends HookWidget {
  const CacheImage({
    required this.url,
    super.key,
    this.radius = 65,
    this.errorIcon,
    this.placeholderColor,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double radius;
  final Widget? errorIcon;
  final Color? placeholderColor;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    useEffect(
      () {
        animationController.repeat(reverse: true);
        return null;
      },
      [],
    );

    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: radius,
      ),
      //
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius,
        backgroundColor: colorScheme.error,
        child: errorIcon ?? Icon(Icons.error, color: colorScheme.onError),
      ),
      //
      placeholder: (context, url) => AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Color.lerp(
              placeholderColor ?? colorScheme.surface,
              colorScheme.primary.withOpacity(0.5),
              animationController.value,
            ),
          );
        },
      ),
      //
      fit: fit,
      fadeOutDuration: const Duration(milliseconds: 300),
      memCacheWidth:
          (radius * 2 * MediaQuery.of(context).devicePixelRatio).round(),
      errorListener: (error) => debugPrint('Error loading image: $error'),
    );
  }
}
