import 'package:flutter/material.dart'
    show
        NavigationBarTheme,
        NavigationBarThemeData,
        NavigationBar,
        NavigationDestination,
        Icons,
        Colors,
        WidgetStateProperty,
        Widget,
        BuildContext,
        ValueChanged,
        NavigationDestinationLabelBehavior,
        CircleBorder;
        
import 'package:flutter/widgets.dart';
import '../utilities/color.dart';

class CustomNavigationBar extends StatelessWidget {
  
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        overlayColor: WidgetStateProperty.all(
          AppColor.secondaryColor,
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorShape: const CircleBorder(),
      ),
      child: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.home_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            label: "Accueil",
            selectedIcon: Container(
              decoration: const BoxDecoration(
                  color: AppColor.primaryColor, shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          NavigationDestination(
            icon: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.newspaper_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            label: "Infos",
            selectedIcon: Container(
              decoration: const BoxDecoration(
                  color: AppColor.primaryColor, shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.newspaper,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          NavigationDestination(
            icon: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.person_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            label: "Infos",
            selectedIcon: Container(
              decoration: const BoxDecoration(
                  color: AppColor.primaryColor, shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.person_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
         
        ],
        backgroundColor: AppColor.lightColor,
        shadowColor: Colors.black,
        elevation: 100.0,
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
      ),
    );
  }
}
