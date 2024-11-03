import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        BorderRadius,
        CrossAxisAlignment,
        SizedBox,
        Colors,
        Column,
        Container,
        BoxDecoration,
        StatelessWidget;
import 'package:king_bet/utilities/color.dart';

import 'package:shimmer/shimmer.dart';

class ProfileFormSkeleton extends StatelessWidget {
  const ProfileFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.grayColor,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSkeletonBox(height: 38.0, width: double.infinity),
          SizedBox(height: 10),
          _buildSkeletonBox(height: 48.0, width: double.infinity),
          SizedBox(height: 10),
          _buildSkeletonBox(height: 48.0, width: double.infinity),
          SizedBox(height: 10),
          _buildSkeletonBox(height: 38.0, width: 100),
          SizedBox(height: 10),
          _buildSkeletonBox(height: 38.0, width: 120),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({required double height, double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
