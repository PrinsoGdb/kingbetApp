import 'package:flutter/material.dart';
import '../utilities/color.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/elevated_button.dart';



class SoccerMatchPage extends StatefulWidget {
  final String title;

  const SoccerMatchPage({super.key, required this.title});
  
  @override
  State<SoccerMatchPage> createState() => _SoccerMatchPageState();
}

class _SoccerMatchPageState extends State<SoccerMatchPage> {
   int currentIndex = 1;

   final List<Map<String, dynamic>> soccerMatchs = [
     {
        'date': "28 Mai, 2024",
        'images' : [
          'assets/images/current_match.jpg',
          'assets/images/current_match.jpg',
        ],
     },
     {
        'date': "27 Mai, 2024",
        'images' : [
          'assets/images/current_match.jpg',
          'assets/images/current_match.jpg',
          'assets/images/current_match.jpg',
        ],
     },
     {
        'date': "26 Mai, 2024",
        'images' : [
          'assets/images/current_match.jpg',
        ],
     },
    ];


  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onValidateFilterButtonPressed() {
    // Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {

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
            leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Color.fromRGBO(232, 232, 232, 1),
                ),  
                onPressed: () {
                  
                },
              ),
            ],
            backgroundColor: AppColor.primaryColor,
            pinned: true,
            floating: true,
            primary: true,
            expandedHeight: 100,
            collapsedHeight: 100,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tous les matchs à venir",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                            ),
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext modalContext) {
                              return Container(
                                padding: const EdgeInsets.all(10.0),
                                height: 295,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 4,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: AppColor.secondaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: const Color.fromRGBO(246, 246, 246, 1),
                                          ),
                                          child: IconButton(
                                            splashColor: Colors.transparent,
                                            icon: const Icon(Icons.close, color: Colors.black),
                                            onPressed: () {
                                              Navigator.of(modalContext).pop();
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Filtrer",
                                          style: TextStyle(
                                            color: AppColor.primaryColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 20.0,),
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Expanded(
                                            //   child: CustomSelectField(placeholder: "Date"),
                                            // ),
                                            // SizedBox(width: 5.0,),
                                            // Expanded(
                                            //   child: CustomSelectField(placeholder: "Championnat"),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(height: 20.0,),
                                        CustomElevatedButton(label: "Valider", onPressed: _onValidateFilterButtonPressed),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.tune, color: AppColor.primaryColor,),
                            SizedBox(width: 2.0),
                            Text(
                              'Filtre',
                              style: TextStyle(
                                fontSize: 16, 
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      soccerMatchs.length,
                      (int index1) => Column(
                        children: [
                          const SizedBox(height: 20.0,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${soccerMatchs[index1]['date']}',
                            ),
                          ),
                          const Divider(
                            color: AppColor.secondaryColor,
                            thickness: 1,
                          ),
                          Column(
                            children: List.generate(
                              soccerMatchs[index1]["images"].length,
                              (int index2) => Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Image.asset(
                                      soccerMatchs[index1]["images"][index2],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                                ],
                              )
                            )
                          ),
                        ],
                      )
                    ),
                  )
                ],
              )
            ),
          )
        ],
      ),
    bottomNavigationBar: CustomNavigationBar(currentIndex: currentIndex, onTap: _onBottomNavigationItemTapped),
    );
  }
}