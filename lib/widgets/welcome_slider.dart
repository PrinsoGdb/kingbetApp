import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Column,
        SizedBox,
        Builder,
        Container,
        BoxDecoration,
        Colors,
        BorderRadius;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:king_bet/utilities/color.dart';

typedef CarouselPageChangedCallback = void Function(
    int index, CarouselPageChangedReason reason);

class WelcomeSlider extends StatelessWidget {
  final double height;
  final CarouselPageChangedCallback onPageChanged;
  final int welcomeSlideCurrentPage;

  const WelcomeSlider({super.key, required this.height, required this.onPageChanged, required this.welcomeSlideCurrentPage});

  @override
  Widget build(BuildContext context) {
    int innerCurrentPage = welcomeSlideCurrentPage;

    final List<String> imgList = [
      'assets/images/slider1.jpg',
      'assets/images/slider2.jpg',
      'assets/images/slider3.jpg',
    ];

    final List<String> titles = [
    'Vos opérations en un clic !',
    'Des avantages à chaque opération !',
    'Rapide, simple et sécurisé !',
    ];

    final List<String> descriptions = [
      'Effectuez vos opérations instantanément avec une grande simplicité.',
      'Profitez de services enrichis et de nombreux avantages à chaque opération.',
      'Vos opérations sont réalisées en toute sécurité, rapidement et sans effort.',
    ];

    return Stack(children: [
      CarouselSlider(
        /// It's options
        options: CarouselOptions(
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          disableCenter: true,
          viewportFraction: 1,
          padEnds: true,
          onPageChanged: onPageChanged,
          height: height * 0.45,
        ),

        /// Items
        items: imgList.asMap().entries.map((entry) {
          final int index = entry.key;
          final String imagePath = entry.value;
          final String title = titles[index];
          final String description = descriptions[index];
          return Builder(
            builder: (BuildContext context) {
              /// Custom Image Viewer widget
              return Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        height: height * 0.25,
                        decoration: BoxDecoration(
                          color: AppColor.grayColor,
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                     const SizedBox(
                        height: 10,
                      ),
                    ]),
              );
            },
          );
        }).toList(),
      ),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                imgList.length,
                (index) {
                  bool isSelected = innerCurrentPage == index;
                  return GestureDetector(
                    onTap: () {
                      //
                    },
                    child: AnimatedContainer(
                      width: 12,
                      height: 12,
                      margin:
                          EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.primaryColor
                            : AppColor.secondaryColor,
                        borderRadius: BorderRadius.circular(
                          40,
                        ),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                  );
                },
              ),
            ),
          )),
    ]);
  }
}
