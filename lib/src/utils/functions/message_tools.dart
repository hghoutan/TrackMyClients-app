import 'package:http/http.dart' as http;

void sendEmail() async {
  final apiKey = 'pubkey-2bfd829fcc088d7a0d0c92de2e829558';
  final domain = 'sandbox6df3165463c247f3a71b710cb0bb58a6.mailgun.org';
  final from = 'sender@your-domain.com';
  final to = 'hichamghoutani52@gmail.com';
  final subject = 'Hello from Flutter!';
  final text = 'Hello from Flutter!';

  final url = 'https://api.mailgun.net/v3/$domain/messages';
  final headers = {
    'Authorization': 'Basic $apiKey',
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  final body = {
    'from': from,
    'to': to,
    'subject': subject,
    'text': text,
  };

  final response = await http.post(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Email sent successfully!');
  } else {
    print('Error sending email: ${response.statusCode}');
  }
}