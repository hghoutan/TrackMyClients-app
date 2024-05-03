import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/auth_controller.dart';

import '../../../../utils/functions/next_screen.dart';
import '../../../../utils/images.dart';
import '../../widgets/main_button.dart';
import '../../widgets/text_input.dart';
import 'admin_login.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController emailController = TextEditingController();
    GlobalKey<FormState> formkey = GlobalKey();
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
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "Mot de passe oublié",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 2.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Color(0xff022150),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22.0),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Image(
                      image: AssetImage(Images.forgotPassword01),
                      height: 100,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Mot de passe oublié ?",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black, fontSize: 20),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: Text(
                          "Saisissez votre adresse électronique ci-dessous pour recevoir les instructions de réinitialisation du mot de passe.",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: const Color(0xff8F8F8F),
                                  ),
                        ),
                      )),
                  const SizedBox(height: 22.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CustomTextInput(
                      controller: emailController,
                      hintText: "Email/ Telephone",
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
                  MainButtonWidget(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                          String msg = await ref.watch(authControllerProvider).sendPasswordResetEmail(emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(msg),
                              duration:  const Duration(seconds: 2) ,
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                              ),
                            ),
                          ).closed.then((value) {
                            if (msg == 'Password reset email sent.') {
                              nextScreenAnimation(context, const AdminLoginScreen());
                            }
                          });
                        }
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    text: 'Continue',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}

void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        contentPadding: const EdgeInsets.symmetric(vertical: 22.0),
        content: SizedBox(
          width: 290,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const Image(
                    image: AssetImage(Images.forgotPassword02),
                    height: 64,
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  Text(
                    "Nous avons envoyé des instructions de récupération du mot de passe à votre adresse électronique.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18, color: const Color(0xff1F1F1F)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Vous n'avez pas reçu l'e-mail ? Vérifiez votre filtre anti-spam ou renvoyez-le.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: const Color(0xff8F8F8F)),
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  SizedBox(
                    width: 105,
                    height: 55,
                    child: MainButtonWidget(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: 'Annuler',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      isSmallBtn: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
