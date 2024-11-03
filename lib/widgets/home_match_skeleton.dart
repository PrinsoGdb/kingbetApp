import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Column,
        MainAxisSize,
        BorderRadius,
        Colors,
        Row,
        MainAxisAlignment,
        SizedBox,
        Container,
        EdgeInsets,
        BoxDecoration,
        StatelessWidget;
import 'package:king_bet/utilities/color.dart';
import 'package:shimmer/shimmer.dart';

class HomeMatchSliderSkeleton extends StatelessWidget {
  const HomeMatchSliderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          child: _buildSkeletonItem(),
        ),
      ],
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSkeletonTeam(),
          SizedBox(
            width: 100, // Ajuster la largeur selon le besoin
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSkeletonText(100, 20), // League Name
                const SizedBox(height: 4.0),
                _buildSkeletonText(60, 16), // Match Date
              ],
            ),
          ),
          _buildSkeletonTeam(),
        ],
      ),
    );
  }

  Widget _buildSkeletonTeam() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: AppColor.grayColor,
            borderRadius: BorderRadius.circular(25), // Arrondi pour une image
          ),
        ),
        const SizedBox(height: 5.0),
        _buildSkeletonText(50, 16), // Team Name
      ],
    );
  }

  Widget _buildSkeletonText(double width, double height) {
    return Shimmer.fromColors(
      baseColor: AppColor.grayColor,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}

