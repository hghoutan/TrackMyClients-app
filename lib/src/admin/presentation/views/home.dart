import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/client_controller.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/add_client.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/home_calls_container.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/home_message_container.dart';
import 'package:trackmyclients_app/src/utils/functions/next_screen.dart';
import 'package:trackmyclients_app/src/utils/images.dart';

import '../../domain/controllers/chat_controller.dart';
import '../../domain/models/chat.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  int switcherIndex = 0;
  List<Client> fullClientDataList = [];
  List<Client> clientDataList = [];

  void getClientList(void Function(void Function()) setState) async {
    clientDataList = fullClientDataList;
    setState(() {});
    ;
  }

  void searchClients(
      String value, void Function(void Function()) setState) async {
    if (value.isEmpty) {
      getClientList(setState);
    } else {
      clientDataList = fullClientDataList
          .where((client) =>
              client.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    fullClientDataList =
        await ref.read(clientControllerProvider).fetchAllClients().first;
    getClientList(
      (_) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      'Client Inbox',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: FaIcon(
                      FontAwesomeIcons.bell,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
            ),
          ),
          const SizedBox(height: 22.0),
          StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff0f0f0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xffd2d2d7)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        prefixIcon: const SizedBox(
                            width: 50,
                            child: Align(
                                alignment: Alignment.center,
                                child: FaIcon(FontAwesomeIcons.search))),
                        hintText: 'Trouvez votre clients ici',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: const Color(0xff717171)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 18.0),
                      ),
                      validator: (value) {},
                      style: Theme.of(context).textTheme.titleMedium,
                      onChanged: (value) => searchClients(value, setState),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: clientDataList.length + 1,
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  nextScreenAnimation(context,
                                                      const AddClientScreen());
                                                },
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffd2d2d7)),
                                                      shape: BoxShape.circle),
                                                  child: Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons.add,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 32,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6.0),
                                              Text(
                                                'Ajouter un client',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                              )
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Container(
                                                  width: 70,
                                                  height: 70,
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: clientDataList[
                                                            index - 1]
                                                        .profilePic!,
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  )),
                                              const SizedBox(height: 6.0),
                                              Text(
                                                clientDataList[index - 1].name!,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                              )
                                            ],
                                          );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        width: 10,
                                      )))
                        ]),
                  ),
                ),
              ],
            );
          }),
          Flexible(
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SlideSwitcher(
                      onSelect: (index) =>
                          setState(() => switcherIndex = index),
                      containerHeight: 45,
                      containerWight:
                          MediaQuery.of(context).size.width - (24 * 2),
                      containerColor: Theme.of(context).colorScheme.primary,
                      containerBorderRadius: 12.0,
                      initialIndex: 0,
                      slidersBorder: Border.all(color: const Color(0xffd2d2d7)),
                      children: [
                        Text(
                          'Voir Messages',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 14,
                                  fontWeight: switcherIndex == 0
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: switcherIndex == 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white),
                        ),
                        Text(
                          'Voir appelles',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 14,
                                  fontWeight: switcherIndex == 1
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: switcherIndex == 1
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24),
                        child: StreamBuilder<List<ChatContact>>(
                            stream:
                                ref.read(chatControllerProvider).chatContacts(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return switcherIndex == 0
                                  ?  snapshot.data!.length == 0 ?
                                    Center(
                                      child: Image.asset(Images.emptyData),
                                    )
                              
                                  : ListView.separated(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        ChatContact messageData =
                                            snapshot.data![index];
                                        var timeSent = DateFormat.Hm()
                                            .format(messageData.timeSent);
                                        return HomeMessageContainer(
                                            chat: messageData,
                                            timeSent: timeSent,
                                            active: !(messageData
                                                .lastMessageSeen!));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(height: 12.0);
                                      },
                                    )
                                  : ListView.separated(
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return HomeCallsContainer(
                                            active: index == 0);
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(height: 12.0);
                                      },
                                    );
                            })),
                  ),
                  const SizedBox(height: 16)
                ],
              );
            }),
          ),
        ],
      ),
    ));
  }
}
