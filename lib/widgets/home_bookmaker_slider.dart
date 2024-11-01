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
        MaterialPageRoute,
        Image;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:king_bet/utilities/color.dart';
import '../views/withdrawal_and_deposit.dart';

typedef CarouselPageChangedCallback = void Function(
    int index, CarouselPageChangedReason reason);

  
class HomeBookmakerSlider extends StatelessWidget {
  final double height;

  const HomeBookmakerSlider({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/images/bookmaker3.png',
      'assets/images/bookmaker2.png',
      'assets/images/bookmaker1.png',
    ];

    final List<String> bookmakerNames = [
      '1xbet',
      'Melbet',
      '1win',
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
          height: height * 0.16 + 21,
        ),

        /// Items
        items: imgList.asMap().entries.map((entry) {
          final int index = entry.key;
          final String imagePath = entry.value;
          final String title = bookmakerNames[index];
          return Builder(
            builder: (BuildContext context) {
              /// Custom Image Viewer widget
              return Padding(
                padding: index < (imgList.length - 1) ? const EdgeInsets.only(right: 10.0) : const EdgeInsets.all(0.0), // Space between items
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WithdrawalAndDepositPage(bookmaker: title)),
                        )
                      },
                      child: Container(
                        constraints: BoxConstraints.expand(height: height * 0.16),
                        decoration: BoxDecoration(
                          color: AppColor.grayColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(imagePath, 
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
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