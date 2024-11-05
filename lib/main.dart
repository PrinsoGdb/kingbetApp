import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:king_bet/models/match.dart';
import 'package:king_bet/services/match.dart';
import 'package:king_bet/services/user.dart';
import 'package:king_bet/views/login.dart';
import 'package:king_bet/views/splash_screen.dart';
import 'package:king_bet/widgets/home_match_skeleton.dart';
import 'package:king_bet/widgets/home_news_skeleton.dart';
import 'widgets/bottom_navigation_bar.dart';
import 'utilities/color.dart';
import 'widgets/home_banner_slider.dart';
import 'widgets/home_match_slider.dart';
import 'widgets/home_bookmaker_slider.dart';
import 'widgets/action_pop_menu.dart';
import 'widgets/home_news_slider.dart';
import 'views/one_news.dart';
import 'views/all_news.dart';
import 'views/my_profile.dart';
import 'views/welcome.dart';
import 'services/news.dart';
import 'models/news.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black.withOpacity(0.5),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          disabledColor: AppColor.disableColor,
          useMaterial3: false,
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<News> news = [];
  List<Match> matches = [];

  int currentIndex = 0,
      homeBannerSlideCurrentPage = 0,
      homeBookmakerSlideCurrentPage = 0,
      homeNewsSlideCurrentPage = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _launchWhatsApp() async {
    final String phoneNumber = "+22963729500";
    final String message =
        "Bonjour, je souhaite en savoir plus sur les services de KingBet.";
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('WhatsApp non installé'),
            content: Text('Vous n\'avez pas WhatsApp sur votre téléphone.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void loadData() async {
    await Future.delayed(const Duration(seconds: 5));
    await loadNews();
    await loadMatchs();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadNews() async {
    List<News> fetchedNews = await NewsService.getNews();
    setState(() {
      news = fetchedNews;
    });
  }

  Future<void> loadMatchs() async {
    List<Match> fetchedMatches = await MatchService.getMatches();
    setState(() {
      matches = fetchedMatches;
    });
  }

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (currentIndex == 1) {
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

  void _onSeeMoreLinkTaped(News oneNews) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OneNewsPage(
                currentNews: oneNews,
              )),
    );
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
    double height, width;

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return _myScaffold(height, width);
  }

  Scaffold _myScaffold(height, width) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "KingBet",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            centerTitle: false,
            leading: null,
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
            expandedHeight: height * 0.36,
            collapsedHeight: height * 0.36,
            flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
              left: false,
              right: false,
              bottom: false,
              child: Column(children: [
                const Spacer(),
                HomeBannerSlider(height: height),
                const Spacer(),
              ]),
            )),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                isLoading
                    ? HomeMatchSliderSkeleton()
                    : HomeMatchSlider(
                        height: height, width: width, matchs: matches)
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: const Text(
                    'Nos Bookmakers',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: AppColor.primaryColor),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: HomeBookmakerSlider(height: height),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: const Text(
                    'Actualités du jour',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: AppColor.primaryColor),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: isLoading
                      ? HomeNewsSliderSkeleton()
                      : HomeNewsSlider(
                          height: height,
                          onSeeMoreLinkTaped: _onSeeMoreLinkTaped,
                          news: news),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _launchWhatsApp();
        },
        backgroundColor: AppColor.greenColor,
        shape: CircleBorder(),
        mouseCursor: SystemMouseCursors.click,
        child: Icon(
          Icons.phone,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
          currentIndex: currentIndex, onTap: _onBottomNavigationItemTapped),
    );
  }
}
