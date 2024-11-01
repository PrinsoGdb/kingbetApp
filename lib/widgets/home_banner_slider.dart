import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Column,
        SizedBox,
        Stack,
        Alignment,
        Positioned,
        Builder,
        BoxFit,
        Container,
        EdgeInsets,
        BoxDecoration,
        BorderRadius,
        DecorationImage,
        AssetImage,
        StatelessWidget;

import 'package:carousel_slider/carousel_slider.dart';

typedef CarouselPageChangedCallback = void Function(
    int index, CarouselPageChangedReason reason);

class HomeBannerSlider extends StatelessWidget {
  final double height;

  const HomeBannerSlider({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/images/slider1.jpg',
      'assets/images/slider2.jpg',
      'assets/images/slider3.jpg',
    ];

    return Column(
      children: [
        const SizedBox(
          height: 45,
        ),
        Container(
          height: height * .25,
          width: double.infinity,
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Carouse lSlider
              Positioned.fill(
                child: CarouselSlider(
                  /// It's options
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: 1,
                  ),

                  /// Items
                  items: imgList.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        /// Custom Image Viewer widget
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
