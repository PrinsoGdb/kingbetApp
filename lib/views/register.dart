import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import '../widgets/phone_number_input_field.dart';
import '../widgets/elevated_button.dart';
import '../utilities/color.dart';
import 'package:flutter/gestures.dart';
import 'package:country_picker/country_picker.dart';
import 'login.dart';
import '../services/user.dart';
import '../models/user.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscureText = true;
  bool isChecked = false;
  bool _isSubmitting = false;

  String? nameError;
  String? phoneError;
  String? passwordError;
  String? emailError;

  // Creates a global key to identify the form
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telUserController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: '229',
    countryCode: 'BJ',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Benin',
    example: '22912345678',
    displayName: 'Benin (BJ) [+229]',
    displayNameNoCountryCode: 'Benin',
    e164Key: '229-BJ-0',
  );

  void _onPasswordFieldHideOrShowButtonPressed() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> _onRegisterButtonPressed() async {
    setState(() {
      _isSubmitting = true;
      nameError = null;
      phoneError = null;
      passwordError = null;
      emailError = null;
    });

    try {
      final user = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        telUser: "${selectedCountry.phoneCode} ${_telUserController.text}",
      );

      // Make the registration API call
      final response = await UserService.register(user);

      if ((response.statusCode == 201) && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage(newAccount: true)),
        );
      } else if (mounted) {
        final Map<String, dynamic>? errors =
            jsonDecode(response.body)["errors"];

        if (errors != null && errors.containsKey('name')) {
          setState(() {
            nameError = errors["name"][0];
          });
        }

        if (errors != null && errors.containsKey('password')) {
          setState(() {
            passwordError = errors["password"][0];
          });
        }

        if (errors != null && errors.containsKey('email')) {
          setState(() {
            emailError = errors["email"][0];
          });
        }

        if (errors != null && errors.containsKey('telUser')) {
          setState(() {
            phoneError = errors["telUser"][0];
          });
        }
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

  void onCountryDropdownPressed() {
    showCountryPicker(
        context: context,
        countryListTheme: const CountryListThemeData(
          flagSize: 25,
          backgroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 16, color: AppColor.placeholderColor),
          bottomSheetHeight: 500, // Optional. Country list modal height
          //Optional. Sets the border radius for the bottomsheet.
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.primaryColor,
              ),
            ),
            hintText: 'Commencez à taper pour rechercher',
            hintStyle: TextStyle(
                color: AppColor.placeholderColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w400),
            prefixIcon: Icon(
              Icons.search,
            ),
            prefixIconColor: AppColor.placeholderColor,
            prefixStyle: TextStyle(
                color: AppColor.placeholderColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w400),
            focusColor: AppColor.primaryColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.secondaryColor,
              ),
            ),
          ),
        ),
        onSelect: (Country country) => {selectedCountry = country});
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
                  child: Form(
                    key: _registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            const Center(
                              child: Text(
                                "Inscription",
                                style: TextStyle(
                                    color: AppColor.primaryColor,
                                    decoration: TextDecoration.none,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 12,
                              child: InkWell(
                                onTap: () => {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  )
                                },
                                hoverColor: AppColor.grayColor,
                                focusColor: AppColor.grayColor,
                                child: const Text(
                                  "Connexion",
                                  style: TextStyle(
                                      color: AppColor.primaryColor,
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          validationError: nameError,
                          type: TextInputType.text,
                          placeholder: "Nom et Prénoms",
                          obscureText: false,
                          radius: 8.0,
                          controller: _nameController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          validationError: emailError,
                          type: TextInputType.emailAddress,
                          placeholder: "Email",
                          obscureText: false,
                          radius: 8.0,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 10),
                        CustomPhoneNumberInputField(
                          validationError: phoneError,
                          selectedCountry: selectedCountry,
                          onPressed: onCountryDropdownPressed,
                          controller: _telUserController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          validationError: passwordError,
                          type: TextInputType.visiblePassword,
                          placeholder: "Mot de passe",
                          obscureText: obscureText,
                          onPressed: _onPasswordFieldHideOrShowButtonPressed,
                          radius: 8.0,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          type: TextInputType.visiblePassword,
                          placeholder: "Confirmer mot de passe",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis';
                            } else if (value != _passwordController.text) {
                              return 'Les mots de passe ne correspondent pas';
                            }
                            return null;
                          },
                          obscureText: obscureText,
                          onPressed: _onPasswordFieldHideOrShowButtonPressed,
                          radius: 8.0,
                        ),
                        // const CustomTextField(
                        //   type: TextInputType.number,
                        //   placeholder: "Code d'invitation(Facultatif)",
                        //   obscureText: false,
                        //   radius: 8.0,
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    100), // Rayon des coins
                              ),
                              checkColor: Colors.white,
                              activeColor: AppColor.primaryColor,
                              value: true,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value ?? false;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 3.0,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(102, 102, 102, 1)),
                                      text: 'En continuant vous acceptez ',
                                    ),
                                    TextSpan(
                                      text:
                                          'la politique de protection de confidentialité et les règles d\'utilisation',
                                      style: const TextStyle(
                                        color: AppColor.primaryColor,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Action lorsque la partie soulignée est tapée
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                        CustomElevatedButton(
                          label: "S’inscrire",
                          isSubmitting: _isSubmitting,
                          onPressed: () async {
                            if (_registerFormKey.currentState!.validate()) {
                              await _onRegisterButtonPressed();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            "Vous avez déjà un compte ?",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.75)),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () => {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              )
                            },
                            hoverColor: AppColor.grayColor,
                            focusColor: AppColor.grayColor,
                            child: const Text(
                              "Se connecter ",
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          )),
    );
  }
}
