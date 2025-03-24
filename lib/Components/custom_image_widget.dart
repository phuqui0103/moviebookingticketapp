import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class CustomImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isBackground;

  const CustomImageWidget({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _buildPlaceholder();
    }

    try {
      if (imagePath.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: imagePath,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => _buildLoadingPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorPlaceholder(),
        );
      } else if (imagePath.startsWith('file://')) {
        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Image.file(
            File(imagePath.replaceFirst('file://', '')),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorPlaceholder(),
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Image.file(
            File(imagePath),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorPlaceholder(),
          ),
        );
      }
    } catch (e) {
      print('Error loading image: $e');
      return _buildErrorPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.black,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.orange.withOpacity(0.5),
          size: isBackground ? 100 : 50,
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
          strokeWidth: isBackground ? 3 : 2,
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.black,
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.orange.withOpacity(0.5),
          size: isBackground ? 100 : 50,
        ),
      ),
    );
  }
}
