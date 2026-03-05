import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerLayout extends StatelessWidget {
  final List<String> layout; // [h10w20s10, x3h10w30s3]
  final Color baseColor;
  final Color highlightColor;

  const ShimmerLayout({
    super.key,
    required this.layout,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layout.map((desc) {
        return _parseDescriptor(desc);
      }).toList(),
    );
  }

  Widget _parseDescriptor(String desc) {
    desc = desc.toLowerCase();

    // Space: s10
    if (desc.startsWith('s')) {
      final space = double.tryParse(desc.substring(1)) ?? 10;
      return SizedBox(height: space, width: space);
    }

    // Horizontal: x2h10w10
    if (desc.startsWith('x')) {
      final match = RegExp(r'x(\d+)h(\d+)w(\d+)').firstMatch(desc);
      if (match != null) {
        int count = int.parse(match.group(1)!);
        double h = double.parse(match.group(2)!);
        double w = double.parse(match.group(3)!);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(count, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _shimmerBox(h, w),
              );
            }),
          ),
        );
      }
    }

    // Vertical: y3h20w30
    if (desc.startsWith('y')) {
      final match = RegExp(r'y(\d+)h(\d+)(?:w(\d+))?').firstMatch(desc);
      if (match != null) {
        int count = int.parse(match.group(1)!);
        double h = double.parse(match.group(2)!);
        double? w = match.group(3) != null ? double.parse(match.group(3)!) : null;

        return Column(
          children: List.generate(count, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _shimmerBox(h, w),
            );
          }),
        );
      }
    }


    // Simple box: h10w20
    // Simple box: h10 or h10w20
    if (desc.startsWith('h')) {
      final match = RegExp(r'h(\d+)(?:w(\d+))?').firstMatch(desc);
      if (match != null) {
        double h = double.parse(match.group(1)!);
        double? w = match.group(2) != null ? double.parse(match.group(2)!) : null;
        return _shimmerBox(h, w);
      }
    }


    // fallback
    return const SizedBox.shrink();
  }

  Widget _shimmerBox(double height, [double? width]) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
