import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import '../widgets/elevated_button.dart';
import '../utilities/color.dart';
import '../main.dart';
import 'register.dart';
import '../services/user.dart';

class LoginPage extends StatefulWidget {
  final bool newAccount;
  const LoginPage({super.key, this.newAccount = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;
  bool _isSubmitting = false;

  // Creates a global key to identify the form
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.newAccount) {
      _showSuccessSnackBar();
    }
  }

  void _showSuccessSnackBar() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Compte créé avec succès ! Vous pouvez vous connecter maintenant.",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  });
}

  void _onPasswordFieldHideOrShowButtonPressed() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> _onLoginButtonPressed() async {
    // Show loading indicator during API call
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Make the login API call (using the service method we previously defined)
      final success = await UserService.login(
          email: _emailController.text, password: _passwordController.text);
      if (success && mounted) {
        // If login is successful, check if the widget is still mounted
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (Route<dynamic> route) => false,
        );
      } else if (mounted) {
        // Handle failure case, check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Échec de la connexion. Veuillez vérifier vos identifiants.',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Handle errors, check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Une erreur s\'est produite. Veuillez réessayer plus tard.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        // Hide loading indicator if the widget is still mounted
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        const Center(
                          child: Text(
                            "Connexion",
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 12,
                          child: InkWell(
                            onTap: _onRegisterButtonPressed,
                            hoverColor: AppColor.grayColor,
                            focusColor: AppColor.grayColor,
                            child: const Text(
                              "Inscription",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            type: TextInputType.emailAddress,
                            placeholder: "Email",
                            obscureText: false,
                            radius: 8.0,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            type: TextInputType.visiblePassword,
                            placeholder: "Mot de passe",
                            obscureText: obscureText,
                            onPressed: _onPasswordFieldHideOrShowButtonPressed,
                            radius: 8.0,
                            controller: _passwordController,
                          ),
                          SizedBox(height: height * 0.1),
                          CustomElevatedButton(
                              label: "Se connecter",
                              isSubmitting: _isSubmitting,
                              onPressed: () async {
                                if (_loginFormKey.currentState!.validate()) {
                                  await _onLoginButtonPressed();
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () => {
                                //
                              },
                              hoverColor: AppColor.grayColor,
                              focusColor: AppColor.grayColor,
                              child: const Text(
                                "Mot de passe oublié?",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
