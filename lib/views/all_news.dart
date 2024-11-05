import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:king_bet/main.dart';
import 'package:king_bet/models/news.dart';
import 'package:king_bet/services/news.dart';
import 'package:king_bet/services/user.dart';
import 'package:king_bet/views/login.dart';
import 'package:king_bet/views/my_profile.dart';
import 'package:king_bet/widgets/action_pop_menu.dart';
import '../utilities/color.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import 'one_news.dart';

class AllNewsPage extends StatefulWidget {
  const AllNewsPage({super.key});

  @override
  State<AllNewsPage> createState() => _AllNewsPageState();
}

class _AllNewsPageState extends State<AllNewsPage> {
  int currentIndex = 1;
  List<News> news = [];

  Future<void> loadNews() async {
    List<News> fetchedNews = await NewsService.getNews();
    if(mounted) {
      setState(() {
        news = fetchedNews;
      });
    }
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
    } else if (currentIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyProfile()),
      );
    }
  }

  void _onSeeMoreLinkTaped(News oneNews) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OneNewsPage(currentNews: oneNews)),
    );
  }

  String truncateText(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length > wordLimit) {
      return words.take(wordLimit).join(' ');
    } else {
      return text;
    }
  }

  String formatDate(publishedAt) {
    DateTime date = DateTime.parse(publishedAt);
    return DateFormat('EEE d MMM y', 'fr_FR').format(date);
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
  void initState() {
    super.initState();
    loadNews();
  }

  @override
  Widget build(BuildContext context) {
    Size size;
    double height;

    size = MediaQuery.of(context).size;
    height = size.height;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
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
            icon: const Icon(
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
          pinned: true,
          floating: true,
          primary: true,
          expandedHeight: 130,
          collapsedHeight: 130,
          flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: const Column(children: [
                SizedBox(height: kToolbarHeight * 0.9),
                Expanded(
                    child: Align(
                  alignment: Alignment.center,
                  child: CustomTextField(
                    type: TextInputType.text,
                    placeholder: "Recherche",
                    obscureText: false,
                    radius: 100,
                  ),
                )),
              ]),
            ),
          )),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: List.generate(
                      news.length,
                      (int index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.25,
                                decoration: BoxDecoration(
                                  color: AppColor.grayColor,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(news[index].imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '${truncateText(news[index].title, 5)}...',
                                style: const TextStyle(
                                    color: AppColor.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      text:
                                          '${truncateText(news[index].content, 20)} ',
                                    ),
                                    TextSpan(
                                      text: 'lire plus',
                                      style: const TextStyle(
                                          color: AppColor.primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _onSeeMoreLinkTaped(news[index]);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                formatDate(news[index].publishedAt),
                                style: TextStyle(
                                  color: AppColor.placeholderColor,
                                  fontSize: 14,
                                ),
                              ),
                              index != news.length - 1
                                  ? const SizedBox(
                                      height: 30.0,
                                    )
                                  : const SizedBox(),
                            ],
                          )),
                ),
              ],
            ),
          ),
        )
      ]),
      bottomNavigationBar: CustomNavigationBar(
          currentIndex: currentIndex, onTap: _onBottomNavigationItemTapped),
    );
  }
}
