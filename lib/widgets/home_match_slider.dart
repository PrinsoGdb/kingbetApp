import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Column,
        State,
        Alignment,
        TextAlign,
        MainAxisSize,
        Colors,
        Builder,
        Row,
        MainAxisAlignment,
        NetworkImage,
        FontWeight,
        Text,
        TextStyle,
        SizedBox,
        BoxFit,
        Container,
        EdgeInsets,
        BoxDecoration,
        DecorationImage,
        StatefulWidget;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:king_bet/models/match.dart';

typedef CarouselPageChangedCallback = void Function(
    int index, CarouselPageChangedReason reason);

class HomeMatchSlider extends StatefulWidget {
  final double height;
  final double width;
  final List<Match> matchs;

  const HomeMatchSlider(
      {super.key,
      required this.height,
      required this.width,
      required this.matchs});

  @override
  State<HomeMatchSlider> createState() => _HomeMatchSliderState();
}

class _HomeMatchSliderState extends State<HomeMatchSlider> {
  String formatMatchDate(String date) {
    var parts = date.split(':');
    if (parts.length > 2) {
      return '${parts[0]}:${parts[1]}'; // Return date with "HH:mm"
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 2,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              viewportFraction: 1,
            ),
            items: widget.matchs.map((matchItems) {
              return Builder(
                builder: (BuildContext context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(matchItems.homeLogo),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              softWrap: true,
                              matchItems.homeTeam,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: widget.width * 0.5,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            matchItems.leagueName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(formatMatchDate(matchItems.matchDate)),
                        ],
                      ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(matchItems.awayLogo),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              softWrap: true,
                              matchItems.awayTeam,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
