import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? loadingIndicatorColor;
  final double loadingIndicatorStrokeWidth;
  final Color? errorIconColor;
  final double errorIconSize;

  const CustomNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width = 75,
    this.height = 75,
    this.fit = BoxFit.cover,
    this.loadingIndicatorColor = Colors.grey,
    this.loadingIndicatorStrokeWidth = 1.0,
    this.errorIconColor,
    this.errorIconSize = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: width! * 0.4,
          height: height! * 0.4,
          child: CircularProgressIndicator(
            strokeWidth: loadingIndicatorStrokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(loadingIndicatorColor!),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: errorIconSize,
          color: errorIconColor ?? Colors.grey[400],
        ),
      ),
      cacheManager: DefaultCacheManager(),
      maxHeightDiskCache: 1024,
      maxWidthDiskCache: 1024,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
    );
  }
}
