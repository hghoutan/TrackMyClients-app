import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/domain/controllers/auth_controller.dart';
import 'package:trackmyclients_app/src/domain/models/user.dart';

import '../../../../utils/images.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/text_input.dart';
import '../../../../services/auth_service.dart';
import 'admin_register.dart';

class AdminRegisterAdditionalInfoPage extends ConsumerStatefulWidget {
  final UserData user;
  const AdminRegisterAdditionalInfoPage({required this.user, super.key});

  @override
  ConsumerState<AdminRegisterAdditionalInfoPage> createState() =>
      _AdminRegisterAdditionalInfoPageState();
}

class _AdminRegisterAdditionalInfoPageState
    extends ConsumerState<AdminRegisterAdditionalInfoPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
                    key: additionalInfoFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 22.0),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTextInput(
                              controller: emailController,
                              hintText: "Email Address *",
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez saisir votre email.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTextInput(
                              controller: phoneController,
                              hintText: "Telephone *",
                              obscureText: false,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez saisir votre numéro de téléphone.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTextInput(
                              controller: passwordController,
                              hintText: "Mot de passe *",
                              obscureText: true,
                              obscuringCharacter: '*',
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez saisir votre mot de passe.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTextInput(
                              controller: confirmPasswordController,
                              hintText: "Confirmer mot de passe *",
                              obscureText: true,
                              obscuringCharacter: '*',
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez confirmer votre mot de passe.';
                                } else if (value != passwordController.text) {
                                  return 'Les mots de passe ne correspondent pas.';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          MainButtonWidget(
                            onPressed: () async {
                              if (additionalInfoFormKey.currentState!
                                  .validate()) {
                                // await AuthService().verifyPhoneNumber(
                                //     '+212${phoneController.text}');
                                UserData newUserData =  widget.user.copyWith(
                                  email: emailController.text,
                                  phone: phoneController.text
                                );
                                String msg = await ref.read(authControllerProvider).signUp(context, newUserData, passwordController.text);

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(msg),
                                ));
                                // _showAlertDialog(context, emailController.text);
                              }
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            text: 'Sauvgarder',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
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
