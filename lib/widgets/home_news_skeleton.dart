import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Column,
        Padding,
        BorderRadius,
        Colors,
        CrossAxisAlignment,
        SizedBox,
        Container,
        EdgeInsets,
        BoxDecoration,
        StatelessWidget;
import 'package:king_bet/utilities/color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomeNewsSliderSkeleton extends StatelessWidget {
  const HomeNewsSliderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
        disableCenter: true,
        viewportFraction: 0.4,
        padEnds: false,
      ),
      items: List.generate(3, (index) => const NewsSkeletonItem()), // Génère 3 skeleton items
    );
  }
}

class NewsSkeletonItem extends StatelessWidget {
  const NewsSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.grayColor,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80.0, // Hauteur de l'image placeholder
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              height: 15.0,
              width: 100.0,
              color: Colors.white,
            ),
            const SizedBox(height: 5.0),
            Container(
              height: 15.0,
              width: 60.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
