import 'package:flutter/material.dart';
import '../widgets/elevated_button.dart';
import '../widgets/welcome_slider.dart';
import '../utilities/color.dart';
import 'login.dart';
import 'register.dart';
import 'package:carousel_slider/carousel_slider.dart' show CarouselPageChangedReason;

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
   int welcomeSlideCurrentPage = 0;

   void _onWelcomeSlidePageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      welcomeSlideCurrentPage = index;
    });
  }
  void _onLoginButtonPressed() {
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
  }

    void _onRegisterButtonPressed() {
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size;
    double height;

    size = MediaQuery.of(context).size;
    height = size.height;

    return Scaffold(
      body: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                height: height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WelcomeSlider(height: height, onPageChanged: _onWelcomeSlidePageChanged, welcomeSlideCurrentPage: welcomeSlideCurrentPage),
                    const SizedBox(height: 40),
                    CustomElevatedButton(label: "S’inscrire", onPressed: _onRegisterButtonPressed),
                    const SizedBox(height: 10,),
                     Center(
                      child: Text(
                        "Vous avez déjà un compte ?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:Colors.black.withOpacity(0.75)
                        ),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: _onLoginButtonPressed,
                        hoverColor: AppColor.grayColor,
                        focusColor: AppColor.grayColor,
                        child: const Text(
                          "Se connecter ",
                          
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
    );
  }
}