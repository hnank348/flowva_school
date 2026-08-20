import 'package:flutter/material.dart';
import 'package:flowva_school/services/constant_api.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final IconData defaultIcon;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool enablePreview;

  const CustomAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 26,
    this.defaultIcon = Icons.person_rounded,
    this.backgroundColor,
    this.iconColor,
    this.enablePreview = true,
  });

  void _openFullScreen(BuildContext context, String url) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.92),
        barrierDismissible: true,
        pageBuilder: (_, __, ___) => _FullScreenImageViewer(imageUrl: url),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = radius * 2;
    final bg = backgroundColor ?? cs.primary.withOpacity(0.12);
    final icColor = iconColor ?? cs.primary;

    final fallbackWidget = Icon(
      defaultIcon,
      size: radius * 1.1,
      color: icColor,
    );

    final resolvedUrl = ConstantApi.getImageUrl(imageUrl);
    final hasValidImage = resolvedUrl != null && resolvedUrl.isNotEmpty;

    return GestureDetector(
      onTap: (enablePreview && hasValidImage)
          ? () => _openFullScreen(context, resolvedUrl!)
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: size,
          height: size,
          color: bg,
          child: hasValidImage
              ? Image.network(
            resolvedUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            headers: const {'Accept': '*/*'},
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: SizedBox(
                  width: radius * 0.7,
                  height: radius * 0.7,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: icColor,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return fallbackWidget;
            },
          )
              : fallbackWidget,
        ),
      ),
    );
  }
}

class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.8,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                headers: const {'Accept': '*/*'},
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Colors.white70,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}