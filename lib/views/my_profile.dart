import 'package:flutter/material.dart';
import 'package:king_bet/main.dart';
import 'package:king_bet/models/user.dart';
import 'package:king_bet/views/all_news.dart';
import 'package:king_bet/views/login.dart';
import '../utilities/color.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/text_field.dart';
import '../widgets/action_pop_menu.dart';
import '../widgets/phone_number_input_field.dart';
import '../widgets/elevated_button.dart';
import 'package:country_picker/country_picker.dart';
import '../services/user.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int currentIndex = 2;
  bool updatePasswordButtonIsClicked = false;
  bool updateButtonIsClicked = false;
  bool _isSubmitting = false;
  bool obscureText = true;
  User? currentUser;

  String? passwordError;
  String? emailError;

  @override
  void initState() {
    super.initState();
    loadMyProfile();
  }

  Future<void> loadMyProfile() async {
    User? fetchedUser = await UserService.getMyProfil();
    setState(() {
      currentUser = fetchedUser;
      _setCurrentUser();
    });
  }

  void _setCurrentUser() {
      _nameController.text = currentUser!.name;
      _emailController.text = currentUser!.email;
      _telUserController.text = removeCountryCode(currentUser!.telUser);
      _passwordController.text = '';
  }


  String removeCountryCode(String? phoneNumber) {
  phoneNumber = phoneNumber!.trim();

  int spaceIndex = phoneNumber.indexOf(' ');
  if (spaceIndex != -1) {
    return phoneNumber.substring(spaceIndex + 1);
  }

  return phoneNumber;
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

  Future<void> _onSaveButtonPressed() async {
    try {
      setState(() {
        _isSubmitting = true;
        passwordError = null;
        emailError = null;
      });

      User user;

      if (_passwordController.text.isNotEmpty) {
        user = User(
            name: _nameController.text,
            email: _emailController.text,
            telUser:  "${selectedCountry.phoneCode} ${_telUserController.text}",
            password: _passwordController.text);
      } else {
        user = User(
            name: _nameController.text,
            email: _emailController.text,
            telUser: "${selectedCountry.phoneCode} ${_telUserController.text}");
      }

      // Make the update profile API call
      final response = await UserService.updateClientProfile(user);
      final data = jsonDecode(response.body);


      developer.log(data.toString());
      developer.log(user.toJson().toString());

      if ((response.statusCode == 200) && mounted) {
        final fetchedUser = User.fromJson(data);
        setState(() {
          currentUser = fetchedUser;
        });
      } else if (mounted) {
        final Map<String, dynamic>? errors = data["errors"];

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

  void _onPasswordFieldHideOrShowButtonPressed() {
    setState(() {
      obscureText = !obscureText;
    });
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

  // Creates a global key to identify the form
  final _profileFormKey = GlobalKey<FormState>();
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
      body: CustomScrollView(slivers: [
        SliverAppBar(
          elevation: 0,
          title: const Text(
            "Mon compte",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
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
        ),
        SliverToBoxAdapter(
          child: Container(
            height: height,
            color: AppColor.grayColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _profileFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            readOnly: !updateButtonIsClicked,
                            type: TextInputType.text,
                            placeholder: "Nom et Prénoms",
                            obscureText: false,
                            radius: 8.0,
                            controller: _nameController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            validationError: emailError,
                            readOnly: !updateButtonIsClicked,
                            type: TextInputType.emailAddress,
                            placeholder: "Email",
                            obscureText: false,
                            radius: 8.0,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 10),
                          CustomPhoneNumberInputField(
                            readOnly: !updateButtonIsClicked,
                            selectedCountry: selectedCountry,
                            onPressed: onCountryDropdownPressed,
                            controller: _telUserController,
                          ),
                          updatePasswordButtonIsClicked
                              ? SizedBox(height: 10)
                              : SizedBox(),
                          updatePasswordButtonIsClicked
                              ? CustomTextField(
                                  validationError: passwordError,
                                  readOnly: !(updateButtonIsClicked ||
                                      updatePasswordButtonIsClicked),
                                  type: TextInputType.visiblePassword,
                                  placeholder: "Nouveau mot de passe",
                                  obscureText: obscureText,
                                  onPressed:
                                      _onPasswordFieldHideOrShowButtonPressed,
                                  radius: 8.0,
                                  controller: _passwordController,
                                )
                              : SizedBox(),
                          updatePasswordButtonIsClicked
                              ? SizedBox(height: 10)
                              : SizedBox(),
                          updatePasswordButtonIsClicked
                              ? CustomTextField(
                                  readOnly: !(updateButtonIsClicked ||
                                      updatePasswordButtonIsClicked),
                                  type: TextInputType.visiblePassword,
                                  placeholder: "Confirmer mot de passe",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ce champ est requis';
                                    } else if (value !=
                                        _passwordController.text) {
                                      return 'Les mots de passe ne correspondent pas';
                                    }
                                    return null;
                                  },
                                  obscureText: obscureText,
                                  onPressed:
                                      _onPasswordFieldHideOrShowButtonPressed,
                                  radius: 8.0,
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 12,
                          ),
                          (updateButtonIsClicked ||
                                  updatePasswordButtonIsClicked)
                              ? SizedBox(
                                  width: 0,
                                )
                              : Column(
                                  children: [
                                    IntrinsicWidth(
                                      child: CustomElevatedButton(
                                        withRadius: false,
                                        label: "Modifier",
                                        onPressed: () {
                                          setState(() {
                                            updateButtonIsClicked = true;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    IntrinsicWidth(
                                      child: CustomElevatedButton(
                                        withRadius: false,
                                        label: "Modifier mot de passe",
                                        backgroundColor:
                                            const Color(0xB174788d),
                                        onPressed: () {
                                          setState(() {
                                            updatePasswordButtonIsClicked =
                                                true;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                          (updateButtonIsClicked ||
                                  updatePasswordButtonIsClicked)
                              ? Column(children: [
                                  IntrinsicWidth(
                                    child: CustomElevatedButton(
                                      withRadius: false,
                                      label: "Annuler",
                                      backgroundColor: const Color(0xB1f1b44c),
                                      onPressed: () {
                                        setState(() {
                                          updatePasswordButtonIsClicked = false;
                                          updateButtonIsClicked = false;
                                          _setCurrentUser();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      height: 10.0,
                                    ),
                                  IntrinsicWidth(
                                    child: CustomElevatedButton(
                                      withRadius: false,
                                      label: "Enregistrer",
                                      backgroundColor: const Color(0xB134c38f),
                                      onPressed: _isSubmitting
                                          ? null
                                          : () async {
                                              if (_profileFormKey.currentState!
                                                  .validate()) {
                                                await _onSaveButtonPressed();
                                              }
                                            },
                                    ),
                                  ),
                                ])
                              : SizedBox(),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ]),
      bottomNavigationBar: CustomNavigationBar(
          currentIndex: currentIndex, onTap: _onBottomNavigationItemTapped),
    );
  }
}
