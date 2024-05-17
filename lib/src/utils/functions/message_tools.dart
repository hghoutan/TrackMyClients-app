import 'package:flutter_quill/quill_delta.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:trackmyclients_app/src/utils/services/google_service.dart';

// const String _serviceId = 'service_qdktf8q';
// const String _templateId = 'template_sqynhy9';
// const String _apiKey = 'lF02vM6hh2jEsBsTp';

String deltaToHtml(Delta delta) {
  final html = <String>[];
  for (final op in delta.operations) {
    if (op.isInsert) {
      print(op.data.toString().contains('\n'));
      if (op.attributes != null) {
        final attrs = <String>[];
        if (op.attributes!.containsKey('bold')) {
          attrs.add('font-weight: bold');
        }
        if (op.attributes!.containsKey('italic')) {
          attrs.add('font-style: italic');
        }
        if (op.attributes!.containsKey('underline')) {
          attrs.add('text-decoration: underline');
        }
        if (op.attributes!.containsKey('strike')) {
          attrs.add('text-decoration: line-through');
        }
        String style = '';
        if (attrs.isNotEmpty) {
          style = 'style="';
          for (var a in attrs) {
            style += '${a}; ';
          }
          style += '"';
        }
        // if (op.attributes!.containsKey('color')) {
        //   attrs.add('color: ${op.attributes['color']}');
        // }

        html.add(
            '<span $style>${op.data.toString().replaceAll('\n', '<br>')}</span>');
      } else {
        html.add(op.data.toString().replaceAll('\n', '<br>'));
      }
    }
    // else if (op.delete != null) {
    //   // handle delete operation
    // } else if (op.retain != null) {
    //   // handle retain operation
    // }
  }
  return html.join('');
}

Future<void> sendMail({
  required String senderName,
  required String recieverName,
  required String receiverEmail,
  required String senderEmail,
  required String message,
}) async {
  String username = senderEmail;
  try {
    final _smtpLogin =
        "postmaster@sandbox6df3165463c247f3a71b710cb0bb58a6.mailgun.org";
    final _password = "a2292231efaff1faf74849f52f19fbe3-32a0fef1-6b65e2b6";
    // this for sending emails with mail.google.com
    // String? token = await GoogleService().signInGoogle();
    // if (token == null) {
    //   return;
    // }
    // with mailgun
    final smtpServer = mailgun(
        _smtpLogin,
        _password
      );
    // send with mail.google.com
    // gmailSaslXoauth2(username, token);

    final mailMessage = Message()
      ..from = Address(username, senderName)
      ..recipients.add(receiverEmail)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'New message from ${senderName}'
      ..html = message;
    await send(mailMessage, smtpServer);
  } on MailerException catch (e) {
    print(e.message);
  }

  // try {
  //   final privateKey = 'mVPfcinSo1Azd89SW8fK2';
  //   final Map<String, dynamic> _params = {
  //       "from_name": senderName,
  //       "to_name": recieverName,
  //       "receiver_email": receiverEmail,
  //       "reply_to": senderEmail,
  //       "message": message,
  //   };
  //    await EmailJS.send(
  //     _serviceId,
  //     _templateId,
  //     _params,
  //     Options(
  //     publicKey: _apiKey,
  //     privateKey: privateKey,
  //   ),
  // );

  // } catch (e) {
  //   print("Error sending email: $e");
  // }
}
