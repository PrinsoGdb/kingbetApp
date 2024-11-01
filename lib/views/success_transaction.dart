import 'package:flutter/material.dart';
import 'package:king_bet/views/withdrawal_and_deposit.dart';
import '../widgets/elevated_button.dart';
import '../widgets/play_icon_container.dart';
import '../utilities/color.dart';
import '../main.dart';

class SuccessTransactionPage extends StatefulWidget {
  final String bookmaker;
  const SuccessTransactionPage({super.key, required this.bookmaker});

  @override
  State<SuccessTransactionPage> createState() => _SuccessTransactionPageState();
}

class _SuccessTransactionPageState extends State<SuccessTransactionPage> {
  void _onConsultOperationsPressed() {
     Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WithdrawalAndDepositPage(bookmaker: widget.bookmaker, currentSectionName: "historical")),
      (Route<dynamic> route) => false,
    );
  }

  void _onGoToHomeLinkTaped() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PlayIconContainer(
                    height: 60, width: 60, hasBorder: false),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Félicitations!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Votre opération est en cours de traitement, vous recevrez sous peu une notification.",
                    style: TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                    label: "Consulter mes notifications",
                    onPressed: _onConsultOperationsPressed),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: InkWell(
                    onTap: _onGoToHomeLinkTaped,
                    hoverColor: AppColor.grayColor,
                    focusColor: AppColor.grayColor,
                    child: const Text(
                      "Retourner sur l’accueil",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
