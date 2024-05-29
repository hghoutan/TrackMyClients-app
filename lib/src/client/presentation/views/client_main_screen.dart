import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/client/presentation/views/client_profile.dart';

class ClientMainScreen extends ConsumerStatefulWidget {
  const ClientMainScreen({super.key});

  @override
  ConsumerState<ClientMainScreen> createState() => _ClientMainScreenState();
}

class _ClientMainScreenState extends ConsumerState<ClientMainScreen> {
 final indexBottomNavbarProvider = StateProvider<int>((ref) {
    return 0;
  });
  final List<Widget> _widgetOptions = <Widget>[
    Container(color: Colors.red),
    ClientProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    return Scaffold(
      body: _widgetOptions.elementAt(indexBottomNavbar),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexBottomNavbar,
        onTap: (value) {
          ref.read(indexBottomNavbarProvider.notifier).update((state) => value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: FaIcon(FontAwesomeIcons.house)
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: FaIcon(FontAwesomeIcons.user)
          )
        ]
      ),
    );
  }
}