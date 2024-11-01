import 'package:flutter/material.dart' show Widget, Icon, Icons, Color, Container, BoxDecoration, Border, BorderRadius, Alignment, BuildContext, StatelessWidget;
import '../utilities/color.dart';

class PlayIconContainer extends StatelessWidget {
  final double height;
  final double width;
  final bool hasBorder;

  const PlayIconContainer({super.key, required this.height, required this.width, required this.hasBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(75, 148, 96, 0.1),
        borderRadius: BorderRadius.circular(100),
        border: hasBorder ? Border.all(
          color: AppColor.yellowColor,
          width: 1,
        ) : null,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.play_arrow,
        color: AppColor.primaryColor,
      ),
    );
  }
}