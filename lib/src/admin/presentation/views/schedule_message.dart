import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/auth_controller.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/client_controller.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';
import 'package:trackmyclients_app/src/admin/domain/models/user.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/main_button.dart';
import 'package:trackmyclients_app/src/utils/functions/date_picker.dart';
import 'package:trackmyclients_app/src/utils/functions/message_tools.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../utils/functions/toast_helper.dart';
import '../../../utils/services/email_scheduling.dart';
import '../../data/helpers/local_database_helper.dart';
import '../../data/models/scheduled_message.dart';

class ScheduleMessageScreen extends ConsumerStatefulWidget {
  const ScheduleMessageScreen({super.key});

  @override
  ConsumerState<ScheduleMessageScreen> createState() =>
      _ScheduleMessageScreenState();
}

class _ScheduleMessageScreenState extends ConsumerState<ScheduleMessageScreen> {
  ClientData? selectedClient;
  List<DateTime> scheduledDates = [];
  bool emailSelected = false;
  bool smsSelected = false;
  bool whatsAppSelected = false;
  QuillController _controller = QuillController.basic();

  final dbHelper = DatabaseHelper();

  void addDate(DateTime dateTime) {
    scheduledDates.add(dateTime);
    setState(() {});
  }

  void removeDate(int index) {
    scheduledDates.removeAt(index);
    setState(() {});
  }

  void scheduleMessage() async {
    if (selectedClient == null) {
      ToastHelper().showCustomToast(
        context: context,
        message: "Please select a client",
      );
      return;
    }

    if (!(emailSelected || smsSelected || whatsAppSelected)) {
      ToastHelper().showCustomToast(
          context: context, message: "Please select a communication method");
      return;
    }

    if (_controller.document.toPlainText().length <= 1) {
      ToastHelper().showCustomToast(
          context: context, message: "Message cannot be empty");
      return;
    }
    UserData? user = await ref.watch(authControllerProvider).getUserData();
    if (emailSelected) {
      final message = _controller.document.toDelta();
      final htmlMessage = deltaToHtml(message);
      await sendMail(
          senderName: "${user!.firstName!} ${user.lastName!}",
          recieverName: selectedClient!.name!,
          receiverEmail: selectedClient!.email!,
          senderEmail: user.email!,
          message: htmlMessage);
      _showToast();
    }
  }

  Future<void> scheduleNewEmail() async {
    if (selectedClient == null) {
      ToastHelper().showCustomToast(
        context: context,
        message: "Please select a client",
      );
      return;
    }

    if (!(emailSelected || smsSelected || whatsAppSelected)) {
      ToastHelper().showCustomToast(
          context: context, message: "Please select a communication method");
      return;
    }

    if (_controller.document.toPlainText().length <= 1) {
      ToastHelper().showCustomToast(
          context: context, message: "Message cannot be empty");
      return;
    }
    UserData? user = await ref.watch(authControllerProvider).getUserData();

    final email = ScheduledEmail(
      id: 13,
      senderName: "${user!.firstName!} ${user.lastName!}",
      receiverName: selectedClient!.name!,
      receiverEmail: selectedClient!.email!,
      senderEmail: user.email!,
      message: 'Hello, this is a scheduled message!',
      scheduledTime: DateTime.now().add(Duration(minutes: 1)),
    );

    final emailId = await dbHelper.insertScheduledEmail(email);
    final scheduledEmail = email.copyWith(id: emailId);
    await scheduleEmail(scheduledEmail);
  }

  _showToast() {
    Widget toast = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check,
          color: Colors.white,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          "Email sent !",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );

    ToastHelper().showCustomToast(context: context, toast: toast);
  }

  @override
  void initState() {
    super.initState();

    ToastHelper().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule message"),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schedule",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          child: StreamBuilder<List<ClientData>>(
                              stream: ref
                                  .read(clientControllerProvider)
                                  .fetchAllClients(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final clients = snapshot.data;
                                  return _DropDownWidget(clients);
                                }
                                return SizedBox();
                              }),
                        ),
                        SizedBox(height: 14),
                        Text(
                          "Select Service",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Checkbox(
                                    value: emailSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        emailSelected = value!;
                                      });
                                    },
                                  ),
                                  Text("Email")
                                ]),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Checkbox(
                                    value: smsSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        smsSelected = value!;
                                      });
                                    },
                                  ),
                                  Text("SMS")
                                ]),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Checkbox(
                                    value: whatsAppSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        whatsAppSelected = value!;
                                      });
                                    },
                                  ),
                                  Text("WhatsApp")
                                ]),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Schedule message delivery",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                            ),
                            Spacer(),
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              radius: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.add),
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                onPressed: () async {
                                  DateTime? dateTime = await showDateTimePicker(
                                      context: context,
                                      firstDate: DateTime.now());
                                  if (dateTime == null) {
                                    return;
                                  }
                                  addDate(dateTime);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Flexible(
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (_, index) {
                              return SizedBox(height: 6);
                            },
                            itemCount: scheduledDates.length,
                            itemBuilder: (context, index) {
                              final date = scheduledDates[index];
                              final formattedDate =
                                  DateFormat('MMMM d, y - h:mm a').format(date);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formattedDate),
                                  InkWell(
                                    onTap: () => removeDate(index),
                                    child: Icon(
                                      FontAwesomeIcons.trash,
                                      size: 22,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Color(0xfff4f4f4),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        selectedClient != null
                            ? Text("To: ${selectedClient!.name}")
                            : SizedBox(),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                              border: Border.all(color: Colors.black26)),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              QuillEditor.basic(
                                configurations: QuillEditorConfigurations(
                                    controller: _controller,
                                    maxHeight: 100,
                                    autoFocus: true,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    placeholder: "Type Message...",
                                    customStyles: DefaultStyles(
                                        placeHolder: DefaultTextBlockStyle(
                                            Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: const Color(
                                                        0xff717171)),
                                            VerticalSpacing(0, 0),
                                            VerticalSpacing(0, 0),
                                            null))),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: Colors.black26)),
                                child: QuillToolbar.simple(
                                  configurations:
                                      QuillSimpleToolbarConfigurations(
                                    controller: _controller,
                                    buttonOptions:
                                        QuillSimpleToolbarButtonOptions(
                                            italic:
                                                QuillToolbarToggleStyleButtonOptions(
                                                    iconData:
                                                        FontAwesomeIcons.italic,
                                                    iconSize: 12),
                                            bold:
                                                QuillToolbarToggleStyleButtonOptions(
                                              iconData: FontAwesomeIcons.bold,
                                              iconSize: 12,
                                            )),
                                    axis: Axis.horizontal,
                                    toolbarSectionSpacing: 0,
                                    showBoldButton: true,
                                    showBackgroundColorButton: false,
                                    showAlignmentButtons: true,
                                    showCenterAlignment: true,
                                    showClearFormat: false,
                                    showSuperscript: false,
                                    showSubscript: false,
                                    showColorButton: false,
                                    showClipboardCut: false,
                                    showCodeBlock: false,
                                    showDirection: false,
                                    showClipboardPaste: false,
                                    showClipboardCopy: false,
                                    showDividers: false,
                                    showFontFamily: false,
                                    showIndent: false,
                                    showLink: false,
                                    showFontSize: false,
                                    showHeaderStyle: false,
                                    showInlineCode: false,
                                    showQuote: false,
                                    showListBullets: false,
                                    showListCheck: false,
                                    showListNumbers: false,
                                    showSearchButton: false,
                                    showSmallButton: false,
                                    showStrikeThrough: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  MainButtonWidget(
                      text: "Confirm & Schedule message",
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      style: Theme.of(context).textTheme.titleMedium!,
                      onPressed: () {
                        scheduleMessage();
                      }),
                  SizedBox(height: 24)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _DropDownWidget(List<ClientData>? clients) {
    return DropdownButtonFormField<ClientData?>(
      icon: SizedBox(),
      menuMaxHeight: 250,
      borderRadius: BorderRadius.circular(8),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xfff4f4f4),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffEFEFEF)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xff717171),
          size: 32,
        ),
        hintText: "Choose your client",
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: const Color(0xff717171)),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
      ),
      items: clients!
          .map((client) => DropdownMenuItem(
                value: client,
                child: Text(
                  client.name!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                ),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedClient = value;
        });
      },
    );
  }
}
