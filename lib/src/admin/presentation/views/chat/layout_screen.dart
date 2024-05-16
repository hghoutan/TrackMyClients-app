import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/admin/domain/repositories/firebase_notification_repository.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/chat/select_client.dart';
import 'package:trackmyclients_app/src/utils/functions/next_screen.dart';

import '../../../domain/controllers/auth_controller.dart';
import '../../../domain/controllers/chat_controller.dart';
import '../../../domain/models/chat.dart';
import '../../widgets/features/chat/contacts_list.dart';

class LayoutScreen extends ConsumerStatefulWidget {
  const LayoutScreen({super.key});

  @override
  ConsumerState<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends ConsumerState<LayoutScreen>
    with WidgetsBindingObserver {
  final  notificationService = NotificationsService();
  TextEditingController searchController = TextEditingController();
  List<ChatContact> contacts = [];

  Future<void> getChatContacts() async {
    contacts = await ref.read(chatControllerProvider).chatContacts().first;
    setState(() {});
  }

  searchContact(String value) async {
    getChatContacts();
    if (!value.isEmpty) {
      contacts = contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(value.toLowerCase()) ||
              contact.lastMessage.toLowerCase().contains(value.toLowerCase()))
          .toList();

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getChatContacts();
    notificationService.firebaseNotification(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ref
        .read(authControllerProvider)
        .setUserState(state == AppLifecycleState.resumed);
  }

  @override
  Widget build(BuildContext context) {
    // use it to establish data by loading it here
    ref.read(userDataAuthProvider).whenData((value) => value);

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          prefixIcon: const SizedBox(
                              width: 50,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: FaIcon(
                                    FontAwesomeIcons.search,
                                  ))),
                          hintText: 'Search message...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: const Color(0xff717171)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 12.0),
                        ),
                        validator: (value) {},
                        style: Theme.of(context).textTheme.titleMedium,
                        onChanged: searchContact,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 22.0),
                    InkWell(
                      onTap: () {
                        nextScreenAnimation(
                            context, const SelectClientsScreen());
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: const Center(
                            child: FaIcon(Icons.open_in_new_rounded)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            ContactsList(contacts: contacts)
          ],
        ),
      ),
    ));
  }
}
