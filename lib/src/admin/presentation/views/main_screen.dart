import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/chat/layout_screen.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/home.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentPageIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    Container(color: Colors.green),
    const LayoutScreen(),
    const ProfileScreen()
  ];
  
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (_) => _widgetOptions.elementAt(currentPageIndex),
            );
        },
      ),
      extendBody: true,
      floatingActionButton:
       Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ClipOval(
          child: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 4, color: Colors.white),
                  borderRadius: BorderRadius.circular(100)),
              child: const FaIcon(
                FontAwesomeIcons.add,
                color: Colors.white,
              )
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 65,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 380 ? 125 : 130,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTab(0, 'Home', Icons.home_outlined ,activeIcon: Icons.home_rounded
                        ),
                        buildTab(1, 'Search', FontAwesomeIcons.search),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 380 ? 125 : 130,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTab(2, 'Messages',  FontAwesomeIcons.message, activeIcon:  FontAwesomeIcons.solidMessage),
                        buildTab(3, 'Profile', FontAwesomeIcons.user, activeIcon: FontAwesomeIcons.userLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
    );
  }
  Widget buildTab(int index, String label, IconData icon, {IconData? activeIcon}) {
    bool isSelected = currentPageIndex == index;
    return InkWell(
      onTap: () {
        _onItemTapped(index);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            child: IconButton(
              icon: buildIcon(icon, index, activeIcon),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                _onItemTapped(index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              label,
              style: isSelected
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: const Color(0xff00587A),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins')
                  : Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: const Color(0xff484C52),
                        fontSize: 12,
                      ),
            ),
          ),
        ],
      ),
    );
  }
  FaIcon buildIcon(IconData icon, int index, IconData? activeIcoon) {
    return FaIcon(
      currentPageIndex == index ? activeIcoon ?? icon : icon,
      color: currentPageIndex == index
          ? Theme.of(context).colorScheme.primary
          : const Color(0xff484C52),
      size: index == 0 ? 30 : null,
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }
}
