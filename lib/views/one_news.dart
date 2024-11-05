import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:king_bet/main.dart';
import 'package:king_bet/models/news.dart';
import 'package:king_bet/services/user.dart';
import 'package:king_bet/views/all_news.dart';
import 'package:king_bet/views/login.dart';
import 'package:king_bet/views/my_profile.dart';
import 'package:king_bet/widgets/action_pop_menu.dart';
import '../utilities/color.dart';
import '../widgets/bottom_navigation_bar.dart';

class OneNewsPage extends StatefulWidget {
  final News currentNews;

  const OneNewsPage({super.key, required this.currentNews});

  @override
  State<OneNewsPage> createState() => _OneNewsPageState();
}

class _OneNewsPageState extends State<OneNewsPage> {
  int currentIndex = 1;

  String formatDate(publishedAt) {
    DateTime date = DateTime.parse(publishedAt);
    return DateFormat('EEE d MMM y', 'fr_FR').format(date);
  }

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (currentIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else if (currentIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AllNewsPage()),
      );
    } else if (currentIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyProfile()),
      );
    }
  }

  void _handleMenuSelection(BuildContext context, int value) async {
    switch (value) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyProfile()),
        );
        break;
      case 2:
        await UserService.logout();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size;
    double height;

    size = MediaQuery.of(context).size;
    height = size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Actualités du jour",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (mounted) {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          CustomPopupMenu(
            onItemSelected: (value) {
              _handleMenuSelection(context, value);
            },
          )
        ],
        backgroundColor: AppColor.primaryColor,
      ),
      body: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(),
          child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.25,
                decoration: BoxDecoration(
                  color: AppColor.grayColor,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.currentNews.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                widget.currentNews.title,
                style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                formatDate(widget.currentNews.publishedAt),
                style: TextStyle(
                    color: AppColor.placeholderColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                widget.currentNews.content,
                style: TextStyle(
                    color: Color.fromRGBO(102, 102, 102, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: CustomNavigationBar(
          currentIndex: currentIndex, onTap: _onBottomNavigationItemTapped),
    );
  }
}
