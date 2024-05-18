import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/client_controller.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/drop_down_input.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/main_button.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/new_client_text_input.dart';

import '../../../utils/utils.dart';

class AddClientScreen extends ConsumerStatefulWidget {
  const AddClientScreen({super.key});

  @override
  ConsumerState<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends ConsumerState<AddClientScreen> {
  final GlobalKey<FormState> newClientFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? selectedProduct;
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    if (newClientFormKey.currentState!.validate()) {
      Client clientData = Client(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim());
      await ref.read(clientControllerProvider).saveClientDataToFirebase(
            context,
            passwordController.text.trim(),
            clientData,
            image,
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const FaIcon(Icons.arrow_back_ios)),
              Text(
                'New Client',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                    ),
              ),
              const SizedBox()
            ],
          ),
          const SizedBox(height: 24.0),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: newClientFormKey,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        image == null
                            ? const CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                                ),
                                radius: 64,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(
                                  image!,
                                ),
                                radius: 64,
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff0f0f0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client Information',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Name',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8.0),
                          NewClientTextInput(
                            controller: nameController,
                            hintText: 'Name of your client',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir le nom de votre client.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Email',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8.0),
                          NewClientTextInput(
                            controller: emailController,
                            hintText: 'Email for your client',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir l'email de votre client.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Password',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8.0),
                          NewClientTextInput(
                            controller: passwordController,
                            hintText: 'Password for your client',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir mot de passe de votre client.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Phone Number',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8.0),
                          NewClientTextInput(
                            controller: phoneController,
                            hintText: 'Phone number of your client',
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir le numero de votre client.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff0f0f0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Attachement',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                          ),
                          const SizedBox(height: 16.0),
                          CustomDropdownInput(
                            hint: 'Select a Product',
                            value: selectedProduct,
                            dropdownItems: const ['test', 'apple'],
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xff717171),
                              size: 32,
                            ),
                            onChanged: (value) {},
                            validator: (value) {
                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    MainButtonWidget(
                      text: 'Sauvegarder',
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      isSmallBtn: true,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      onPressed: storeUserData,
                    ),
                    MainButtonWidget(
                        text: 'Cancel',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        isSmallBtn: true,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        onPressed: () {}),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
