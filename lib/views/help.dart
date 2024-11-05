import 'package:flutter/material.dart';
import '../utilities/color.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/play_icon_container.dart';
import '../widgets/help_tutorial_slider.dart';

class HelpPage extends StatefulWidget {
  final String title;

  const HelpPage({super.key, required this.title});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int currentIndex = 3, helpTutorielSliderCurrentPage = 0;

  List<Map<String, dynamic>> questions = [
    {
      'question': "Comment faire un dépȏt avec betWallet ?",
      "answers": [
        "Saisissez le Montant à Retirer",
        "Collez ou Saisissez le code obtenu dans la case Code",
        "Choisissez le Moyen de paiement (Operateur) (MTN BENIN, MOOV BENIN, etc).",
        "Modifiez le numéro si le numéro présent dans le champ a changé",
        "Modifiez le nom lié à ce numéro.",
      ],
      'isExpanded': false,
    },
    {
      'question': "Que dois-je mettre au niveau de Identifiant 1xbet ?",
      "answers": [
        "Saisissez le Montant à Retirer",
        "Collez ou Saisissez le code obtenu dans la case Code",
        "Choisissez le Moyen de paiement (Operateur) (MTN BENIN, MOOV BENIN, etc).",
        "Modifiez le numéro si le numéro présent dans le champ a changé",
        "Modifiez le nom lié à ce numéro.",
      ],
      'isExpanded': false,
    },
    {
      'question': "Que dois-je mettre au niveau de Transaction Id ?",
      "answers": [
        "Saisissez le Montant à Retirer",
        "Collez ou Saisissez le code obtenu dans la case Code",
        "Choisissez le Moyen de paiement (Operateur) (MTN BENIN, MOOV BENIN, etc).",
        "Modifiez le numéro si le numéro présent dans le champ a changé",
        "Modifiez le nom lié à ce numéro."
      ],
      'isExpanded': false,
    },
    {
      'question': "Comment faire un retrait avec betWallet ?",
      "answers": [
        "Saisissez le Montant à Retirer",
        "Collez ou Saisissez le code obtenu dans la case Code",
        "Choisissez le Moyen de paiement (Operateur) (MTN BENIN, MOOV BENIN, etc).",
        "Modifiez le numéro si le numéro présent dans le champ a changé",
        "Modifiez le nom lié à ce numéro."
      ],
      'isExpanded': false,
    }
  ];

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size;
    double height;

    size = MediaQuery.of(context).size;
    height = size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            leading: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Color.fromRGBO(232, 232, 232, 1),
                ),
                onPressed: () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
            backgroundColor: AppColor.primaryColor,
            pinned: true,
            floating: true,
            primary: true,
            expandedHeight: 300,
            collapsedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
              left: false,
              right: false,
              bottom: false,
              child: Column(children: [
                const SizedBox(height: kToolbarHeight),
                const Divider(
                  color: Colors.white,
                  height: 0,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 200,
                      child: const Align(
                        alignment: Alignment.center,
                        child: PlayIconContainer(
                            height: 70, width: 70, hasBorder: true),
                      ),
                    ),
                  ),
                ),
              ]),
            )),
          ),
          SliverToBoxAdapter(
            child: Container(
                margin: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nos tutoriels videos",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    HelpTutorielSliderSlider(height: height)
                  ],
                )),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Les questions fréquentes ",
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Column(
                    children: List.generate(
                        questions.length,
                        (int index1) => Container(
                              margin: index1 < (questions.length - 1)
                                  ? const EdgeInsets.only(bottom: 10.0)
                                  : const EdgeInsets.all(0.0),
                              child: Theme(
                                data: ThemeData(
                                  hoverColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    height: 30,
                                    width: 30,
                                    child: Icon(
                                      questions[index1]["isExpanded"]
                                          ? Icons.remove
                                          : Icons.add,
                                    ),
                                  ),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      side: BorderSide(
                                          color: AppColor.secondaryColor)),
                                  collapsedShape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      side: BorderSide(
                                          color: AppColor.secondaryColor)),
                                  backgroundColor: AppColor.grayColor,
                                  collapsedBackgroundColor: AppColor.grayColor,
                                  iconColor: AppColor.primaryColor,
                                  collapsedIconColor: AppColor.primaryColor,
                                  textColor: Colors.black,
                                  collapsedTextColor:
                                      const Color.fromRGBO(102, 102, 102, 1),
                                  childrenPadding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, bottom: 10.0),
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  expandedAlignment: Alignment.topLeft,
                                  title: Text(
                                    questions[index1]["question"],
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  children: List.generate(
                                      questions[index1]["answers"].length,
                                      (int index2) {
                                    return Row(
                                      children: [
                                        Text(
                                          '${index2 + 1}. ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            questions[index1]["answers"]
                                                [index2],
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  onExpansionChanged: (bool expanded) {
                                    setState(() {
                                      questions[index1]["isExpanded"] =
                                          expanded;
                                    });
                                  },
                                ),
                              ),
                            )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
          currentIndex: currentIndex, onTap: _onBottomNavigationItemTapped),
    );
  }
}
