import 'package:flutter/material.dart';
import 'package:trackmyclients_app/src/domain/models/user.dart';
import 'package:trackmyclients_app/src/presentation/views/auth/register/admin_register_additional_info.dart';

import '../../../../utils/functions/next_screen.dart';
import '../../../../utils/images.dart';
import '../../../widgets/drop_down_input.dart';
import '../../../widgets/text_input.dart';

final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
final GlobalKey<FormState> additionalInfoFormKey = GlobalKey<FormState>();

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  String? selectedGender;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * .1,
              width: double.infinity,
              child: const Stack(alignment: Alignment.center, children: [
                Positioned(
                    top: 0,
                    left: 0,
                    child: Image(
                      image: AssetImage(Images.loginEllipse01),
                    )),
                Positioned(
                    right: 0,
                    child: Image(
                      image: AssetImage(Images.loginEllipse02),
                      width: 350,
                    )),
                Positioned(
                    top: 0,
                    left: 0,
                    child: Image(
                      image: AssetImage(Images.loginEllipse03),
                      width: 350,
                    )),
              ])),
          Container(
            height: MediaQuery.of(context).size.height * .9,
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20.0),
                      child: Text(
                        "Créer un compte",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Form(
                    key: registerFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 22.0),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTextInput(
                              controller: lastNameController,
                              hintText: "Nom *",
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez saisir votre nom.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTextInput(
                              controller: firstNameController,
                              hintText: "Prenom *",
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez saisir votre prenom.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTextInput(
                              controller: birthdayController,
                              hintText: "Date de naissance *",
                              obscureText: false,
                              keyboardType: TextInputType.datetime,
                              icon: const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xff717171),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez sélectionner votre date de naissance.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: CustomDropdownInput(
                                hint: "Civilité *",
                                dropdownItems: const ["Monsieur", "Madame"],
                                value: selectedGender,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xff717171),
                                  size: 32,
                                ),
                                onChanged: (String? value) {
                                  selectedGender = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez sélectionner votre civilité.';
                                  }
                                  return null;
                                },
                              )),
                          Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: CustomDropdownInput(
                                hint: "Ville *",
                                dropdownItems: const [
                                  "Casablanca",
                                  "Marrakech",
                                  "Tanger",
                                  "Rabat"
                                ],
                                value: selectedCity,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xff717171),
                                  size: 32,
                                ),
                                onChanged: (String? newValue) {
                                  selectedCity = newValue;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez sélectionner votre ville.';
                                  }
                                  return null;
                                },
                              )),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      if (registerFormKey.currentState!
                                          .validate()) {
                                        UserData user = UserData(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            birthdayYear:
                                                birthdayController.text,
                                            gender: selectedGender,
                                            city: selectedCity);
                                        nextScreenAnimation(
                                            context,
                                            AdminRegisterAdditionalInfoPage(
                                                user: user));
                                      }
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: const CircleBorder(),
                                    elevation: 0,
                                    child: const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
