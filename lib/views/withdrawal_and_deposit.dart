import 'package:flutter/material.dart';
import 'package:king_bet/main.dart';
import 'package:king_bet/models/caisse.dart';
import 'package:king_bet/models/transaction.dart';
import 'package:king_bet/models/user.dart';
import 'package:king_bet/services/caisse.dart';
import 'package:king_bet/services/transaction.dart';
import 'package:king_bet/services/user.dart';
import 'package:king_bet/views/all_news.dart';
import 'package:king_bet/views/login.dart';
import 'package:king_bet/views/my_profile.dart';
import 'package:king_bet/views/web_payment.dart';
import 'package:king_bet/widgets/action_pop_menu.dart';
import 'package:king_bet/widgets/historical.dart';
import 'package:king_bet/widgets/select_caisse_field.dart';
import '../utilities/color.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/text_field.dart';
import '../widgets/select_field.dart';
import '../widgets/elevated_button.dart';

import 'success_transaction.dart';
import 'dart:developer' as developer;

import 'package:feda/feda.dart';
import 'dart:convert';

class WithdrawalAndDepositPage extends StatefulWidget {
  final String bookmaker;
  final String? currentSectionName;

  const WithdrawalAndDepositPage(
      {super.key, required this.bookmaker, this.currentSectionName});

  @override
  State<WithdrawalAndDepositPage> createState() =>
      _WithdrawalAndDepositPageState();
}

class _WithdrawalAndDepositPageState extends State<WithdrawalAndDepositPage> {
  int currentIndex = 1;
  String currentSection = "withdraw";
  List<Transaction> transactions = [];
  List<Caisse> caisses = [];

  bool _isSubmitting = false;

  String? numeroReccepteurError;
  String? nomReccepteurError;
  String? xbetIdError;
  String? codeIdError;
  int? montantOperationError;
  User? currentUser;

  String? currentMoyenPaiment;
  String? currentLieuRetrait;

  String? transactionUrl;
  int? transactionId;

  // Creates a global key to identify the form
  final _withdrawFormKey = GlobalKey<FormState>();
  final _depositFormKey = GlobalKey<FormState>();
  final TextEditingController _numeroReccepteurController =
      TextEditingController();
  final TextEditingController _nomReccepteurController =
      TextEditingController();
  final TextEditingController _xbetIdController = TextEditingController();
  final TextEditingController _montantOperationController =
      TextEditingController();
  final TextEditingController _codeIdController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.currentSectionName == 'historical') {
      _setCurrentSection(widget.currentSectionName!);
    } else {
      loadCaisse();
    }
    loadMyProfile();
  }

  Future<void> loadMyProfile() async {
    User? fetchedUser = await UserService.getMyProfil();
    setState(() {
      currentUser = fetchedUser;
    });
  }

  Future<void> createRedirectTransaction(amount, email, phoneNumber) async {
    try {
      final data = await Feda.create_transaction(
        FedaTransactionRequest(
          amount: double.parse(amount),
          clienMail: email,
          description: "Operation de depot sur KingBet",
          phone_number: {
            'number': phoneNumber,
            'country': 'bj',
          },
        ),
      );
      setState(() {
        transactionId = data['trx'].id;
        transactionUrl = data['url'];
      });
    } catch (e) {
      developer.log('Erreur lors de la création de la transaction: $e');
    }
  }

  void _redirectToPayment(transactionUrl, transactionId) {
    final transaction = Transaction(
          xbetId: _xbetIdController.text,
          montantOperation: int.parse(_montantOperationController.text),
          typeOperation: "Dépôt",
          bookmaker: widget.bookmaker,
          transId: transactionId.toString());

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebPayment(
                transactionUrl: transactionUrl,
                transactionId: transactionId,
                transaction: transaction,
              )),
    );
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
    }
  }

  void _setCurrentSection(String sectionName) {
    setState(() {
      currentSection = sectionName;
    });

    if (sectionName == 'historical') {
      loadHistorical();
    }
  }

  void _onMoyenPaiementChanged(String? newValue) {
    setState(() {
      currentMoyenPaiment = newValue;
    });
  }

  void _onLieuRetraitChanged(String? newValue) {
    setState(() {
      currentLieuRetrait = newValue;
    });
  }

  Future<void> loadHistorical() async {
    List<Transaction> fetchedTransaction =
        await TransactionService.myOperations(widget.bookmaker);
    setState(() {
      transactions = fetchedTransaction;
    });
  }

  Future<void> loadCaisse() async {
    List<Caisse> fetchedCaisse = await CaisseService.listOfCaisse();
    setState(() {
      caisses = fetchedCaisse;
    });
  }

  Future<void> _onStartWithdrawal() async {
    setState(() {
      _isSubmitting = true;
      numeroReccepteurError = null;
      nomReccepteurError = null;
      xbetIdError = null;
      codeIdError = null;
      montantOperationError = null;
    });

    try {
      final transaction = Transaction(
        numeroReccepteur: _numeroReccepteurController.text,
        nomReccepteur: _nomReccepteurController.text,
        codeId: _codeIdController.text,
        xbetId: _xbetIdController.text,
        montantOperation: int.parse(_montantOperationController.text),
        typeOperation: 'Retrait',
        lieuRetrait: currentLieuRetrait,
        moyenPaiement: currentMoyenPaiment,
        bookmaker: widget.bookmaker,
      );

      // Make the registration API call
      final response = await TransactionService.makeOperation(transaction);

      if ((response.statusCode == 200) && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SuccessTransactionPage(bookmaker: widget.bookmaker)),
          (Route<dynamic> route) => false,
        );
      } else if (mounted) {
        //
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Une erreur s\'est produite. Veuillez réessayer plus tard.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        // Hide the loading indicator
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String? amountValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }

    int? amount = int.tryParse(value);

    if (amount == null) {
      return 'Veuillez entrer un nombre valide';
    } else if (amount < 200) {
      return 'Le montant doit être d\'au moins 200';
    }

    return null;
  }

  void _managePayment() async {
    try {
      setState(() {
        _isSubmitting = true;
      });
      if (transactionUrl == null) {
        await createRedirectTransaction(_montantOperationController.text,
            currentUser!.email, currentUser!.telUser);
        _redirectToPayment(transactionUrl, transactionId);
      } else {
        _redirectToPayment(transactionUrl, transactionId);
      }
    } catch (e) {
      developer.log("Errorrrr$e");
    } finally {
      setState(() {
        _isSubmitting = false;
      });
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.bookmaker,
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
            expandedHeight: 150,
            collapsedHeight: 150,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            )),
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
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: AppColor.secondaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () => {
                                  if (currentSection != "withdraw")
                                    {_setCurrentSection("withdraw")}
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: currentSection == "withdraw"
                                        ? Colors.white
                                        : null,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Retrait",
                                      style: TextStyle(
                                        color: currentSection == "withdraw"
                                            ? AppColor.primaryColor
                                            : const Color.fromRGBO(
                                                136, 136, 136, 1),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () => {
                                if (currentSection != "deposit")
                                  {_setCurrentSection("deposit")}
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: currentSection == "deposit"
                                      ? Colors.white
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    "Dépȏt",
                                    style: TextStyle(
                                      color: currentSection == "deposit"
                                          ? AppColor.primaryColor
                                          : const Color.fromRGBO(
                                              136, 136, 136, 1),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () => {
                                if (currentSection != "historical")
                                  {_setCurrentSection("historical")}
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: currentSection == "historical"
                                      ? Colors.white
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    "Historique",
                                    style: TextStyle(
                                      color: currentSection == "historical"
                                          ? AppColor.primaryColor
                                          : const Color.fromRGBO(
                                              136, 136, 136, 1),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            )),
          ),
          currentSection != "historical"
              ? SliverToBoxAdapter(
                  child: Container(
                    margin:
                        const EdgeInsets.only(top: 20, left: 15.0, right: 15.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Pour plus de détails, consultez notre",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () => {
                              //
                            },
                            child: const Text(
                              "page d’aide.",
                              style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SliverToBoxAdapter(),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 15.0, right: 15.0),
              child: currentSection == "withdraw"
                  ? withdrawSection(context)
                  : currentSection == "deposit"
                      ? depositSection(context)
                      : Historical(transactions: transactions),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
          currentIndex: currentIndex, onTap: _onBottomNavigationItemTapped),
    );
  }

  Widget withdrawSection(BuildContext context) {
    return Form(
        key: _withdrawFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Coordonnées du compte ${widget.bookmaker}",
              style: TextStyle(color: AppColor.yellowColor, fontSize: 13),
            ),
            const SizedBox(
              height: 5.0,
            ),
            CustomTextField(
              type: TextInputType.text,
              placeholder: "Identifiant ${widget.bookmaker}",
              obscureText: false,
              radius: 8.0,
              controller: _xbetIdController,
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              type: TextInputType.number,
              placeholder: "Code de retrait",
              obscureText: false,
              radius: 8.0,
              controller: _codeIdController,
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              "Paiement",
              style: TextStyle(color: AppColor.yellowColor, fontSize: 13),
            ),
            const SizedBox(
              height: 5.0,
            ),
            CustomTextField(
              type: TextInputType.number,
              placeholder: "Montant",
              obscureText: false,
              radius: 8.0,
              controller: _montantOperationController,
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomSelectField(
              placeholder: "Moyen de retrait",
              itemList: ['MTN Bénin', 'MOOV Bénin'],
              onChanged: _onMoyenPaiementChanged,
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomSelectCaisseField(
              placeholder: "Lieu de retrait",
              caisseList: caisses,
              onChanged: _onLieuRetraitChanged,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              "Paiement",
              style: TextStyle(color: AppColor.yellowColor, fontSize: 13),
            ),
            const SizedBox(
              height: 5.0,
            ),
            CustomTextField(
              type: TextInputType.number,
              placeholder: "N° de réception",
              obscureText: false,
              radius: 8.0,
              controller: _numeroReccepteurController,
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              type: TextInputType.text,
              placeholder: "Nom et Prénoms Momo",
              obscureText: false,
              radius: 8.0,
              controller: _nomReccepteurController,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomElevatedButton(
                label: "Lancer le retrait",
                onPressed: () => {
                      if (_withdrawFormKey.currentState!.validate())
                        {_onStartWithdrawal()}
                    },
                isSubmitting: _isSubmitting),
          ],
        ));
  }

  Widget depositSection(BuildContext context) {
    return Form(
        key: _depositFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              type: TextInputType.text,
              placeholder: "Identifiant 1xBet",
              obscureText: false,
              radius: 8.0,
              controller: _xbetIdController,
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              type: TextInputType.text,
              placeholder: "Montant",
              validator: amountValidator,
              obscureText: false,
              radius: 8.0,
              controller: _montantOperationController,
            ),
            // const SizedBox(
            //   height: 10.0,
            // ),
            // CustomSelectField(placeholder: "Moyen de retrait", itemList: ['MTN Bénin', 'MOOV Bénin'], onChanged: _onMoyenPaiementChanged,),
            // const SizedBox(
            //   height: 15.0,
            // ),
            // Container(
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 10.0, vertical: 12.0),
            //     decoration: BoxDecoration(
            //       color: AppColor.grayColor,
            //       border: Border.all(
            //         color: AppColor.secondaryColor,
            //         width: 1.0,
            //       ),
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           "Veuillez cliquer ici pour éffectuer le paiement suivant.",
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 10,
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 5.0,
            //         ),
            //         InkWell(
            //           onTap: () => {
            //             //
            //           },
            //           child: Container(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 8.0, vertical: 6.0),
            //               decoration: BoxDecoration(
            //                 color: AppColor.yellowColor,
            //                 borderRadius: BorderRadius.circular(8.0),
            //               ),
            //               child: const Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     "*880*41*494567*montant#",
            //                     style: TextStyle(
            //                         color: Colors.white,
            //                         fontSize: 10,
            //                         fontWeight: FontWeight.w400),
            //                   ),
            //                   Icon(
            //                     Icons.phone_outlined,
            //                     color: Colors.white,
            //                   ),
            //                 ],
            //               )),
            //         )
            //       ],
            //     )),
            // const SizedBox(
            //   height: 15.0,
            // ),
            // const CustomTextField(
            //   type: TextInputType.number,
            //   placeholder: "Transaction id",
            //   obscureText: false,
            //   radius: 8.0,
            // ),
            const SizedBox(
              height: 20.0,
            ),
            CustomElevatedButton(
              label: "Lancer le dépôt",
              onPressed: () async {
                if (_depositFormKey.currentState!.validate()) {
                  _managePayment();
                }
              },
              isSubmitting: _isSubmitting,
            ),
          ],
        ));
  }
}
