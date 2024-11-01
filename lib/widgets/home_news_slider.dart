import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Column,
        SizedBox,
        Builder,
        Container,
        BoxDecoration,
        TextOverflow,
        InkWell,
        BorderRadius;
        
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:king_bet/models/news.dart';
import 'package:king_bet/utilities/color.dart';
import 'dart:developer' as developer;


typedef CarouselPageChangedCallback = void Function(
    int index, CarouselPageChangedReason reason);


class HomeNewsSlider extends StatefulWidget {
  final double height;
  final Function(News) onSeeMoreLinkTaped;
  final List<News> news;

  const HomeNewsSlider({super.key, required this.height, required this.news, required this.onSeeMoreLinkTaped });


  @override
  State<HomeNewsSlider> createState() => _HomeNewsSliderState();

}

class _HomeNewsSliderState extends State<HomeNewsSlider>{
  @override
  Widget build(BuildContext context) {

    return IntrinsicHeight(
      child: CarouselSlider(
              /// It's options
        options: CarouselOptions(
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          disableCenter: true,
          viewportFraction: 0.4,
          padEnds: false,
        ),

        /// Items
        items: widget.news.asMap().entries.map((entry) {
          final int index = entry.key;
          final News newsItem = entry.value;
          return Builder(
            builder: (BuildContext context) {
              /// Custom Image Viewer widget
              return Padding(
                padding: index < (widget.news.length - 1) ? const EdgeInsets.only(right: 10.0) : const EdgeInsets.all(0.0), // Space between items
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: widget.height * 0.16,
                      decoration: BoxDecoration(
                        color: AppColor.grayColor,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(newsItem.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Text(
                      newsItem.content,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5.0,),
                    InkWell(
                      onTap: () {
                        widget.onSeeMoreLinkTaped(newsItem);
                      },
                      hoverColor: AppColor.grayColor,
                      focusColor: AppColor.grayColor,
                      child: const Text(
                        "Lire plus ...",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ]
                )
              );
            },
          );
        }).toList(),
      ),
    );
  }
}