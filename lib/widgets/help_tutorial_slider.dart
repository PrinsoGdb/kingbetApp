import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Column,
        SizedBox,
        Builder,
        Container,
        BoxDecoration,
        BorderRadius,
        InkWell,
        Icons;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:king_bet/utilities/color.dart';
import 'play_icon_container.dart';

typedef CarouselPageChangedCallback = void Function(
    int index, CarouselPageChangedReason reason);


class HelpTutorielSliderSlider extends StatelessWidget {
  final double height;

  const HelpTutorielSliderSlider({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Comment faire un dépȏt avec betWallet ?',
      'Comment faire un retrait avec betWallet ?',
      'Comment faire pour devenir un caissier ?',
    ];

    return IntrinsicHeight(
      child:
        CarouselSlider(
        /// It's options
        options: CarouselOptions(
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          disableCenter: true,
          viewportFraction: 0.4,
          padEnds: false,
          height: height * 0.16 + 82,
        ),

        /// Items
        items: titles.asMap().entries.map((entry) {
          final int index = entry.key;
          final String title = titles[index];
          return Builder(
            builder: (BuildContext context) {
              /// Custom Image Viewer widget
              return Padding(
                padding: index < (titles.length - 1) ? const EdgeInsets.only(right: 10.0) : const EdgeInsets.all(0.0), // Space between items
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(height: height * 0.16),
                      decoration: BoxDecoration(
                        color: AppColor.grayColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: PlayIconContainer(height: 50, width: 50, hasBorder: true),                          
                        ),
                    ),
                    const SizedBox(height: 5.0,),
                    SizedBox(
                      height: 45.0,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    InkWell(
                      onTap: () => {
                        //
                      },
                      hoverColor: AppColor.grayColor,
                      focusColor: AppColor.grayColor,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: AppColor.primaryColor),
                          SizedBox(width: 2.0),
                          Text(
                            "Suivre",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
