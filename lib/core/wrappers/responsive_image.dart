
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/exported_files/exported_file.dart';

// Conditional import
import 'file_io_stub.dart'
if (dart.library.io) 'file_io_mobile.dart';


class ResponsiveImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit fit;
  final BoxShape shape;
  final double borderRadiusTop;
  final double borderRadiusBottom;
  final Color? color;

   ResponsiveImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.borderRadiusTop = 0.0,
    this.borderRadiusBottom = 0.0,
    this.color,
  });

  bool get _isNetwork => path.startsWith('http');
  bool get _isSVG => path.toLowerCase().endsWith('.svg');

  final XFileLoader _fileLoader = XFileLoader();

  bool get _isFile => _fileLoader.exists(path);

  double get _width {
    final value = size ?? width ?? 50.0;
    return (value.isFinite && value > 0) ? value : 50.0;
  }
  
  double get _height {
    final value = size ?? height ?? 50.0;
    return (value.isFinite && value > 0) ? value : 50.0;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_isSVG) {
      if (_isNetwork) {
        imageWidget = SvgPicture.network(
          path,
          width: _width,
          height: _height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (_) => _buildShimmerPlaceholder(),
        );
      } else if (_isFile) {
        imageWidget = SvgPicture.file(
          _fileLoader.load(path),
          width: _width,
          height: _height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      } else {
        imageWidget = SvgPicture.asset(
          path,
          width: _width,
          height: _height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      }
    } else {
      if (_isNetwork) {
        imageWidget = CachedNetworkImage(
          imageUrl: path,
          width: _width,
          height: _height,
          fit: fit,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          placeholder: (_, __) => _buildShimmerPlaceholder(),
          errorWidget: (_, __, ___) => _buildErrorWidget(),
        );
      } else if (_isFile) {
        imageWidget = Image.file(
          _fileLoader.load(path),
          width: _width,
          height: _height,
          fit: fit,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          errorBuilder: (_, __, ___) => _buildErrorWidget(),
        );
      } else {
        imageWidget = Image.asset(
          path,
          width: _width,
          height: _height,
          fit: fit,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          errorBuilder: (_, __, ___) => _buildErrorWidget(),
        );
      }
    }

    // Shape / Border
    if (shape == BoxShape.circle) {
      return ClipOval(child: imageWidget);
    } else if (borderRadiusTop > 0 || borderRadiusBottom > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadiusTop),
          bottom: Radius.circular(borderRadiusBottom),
        ),
        child: imageWidget,
      );
    } else {
      return imageWidget;
    }
  }

  // Shimmer Placeholder
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.vertical(
                  top: Radius.circular(borderRadiusTop),
                  bottom: Radius.circular(borderRadiusBottom),
                )
              : null,
        ),
      ),
    );
  }

  // Error Widget
  Widget _buildErrorWidget() {
    return Container(
      width: _width,
      height: _height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.vertical(
                top: Radius.circular(borderRadiusTop),
                bottom: Radius.circular(borderRadiusBottom),
              )
            : null,
      ),
      child: Icon(
        Icons.broken_image_outlined,
        color: Colors.grey.shade500,
        size: (_width * 0.4).clamp(20.0, 100.0),
      ),
    );
  }
}
