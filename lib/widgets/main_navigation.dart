import 'package:flutter/material.dart';
import 'package:school_app/pages/grades_page.dart';

import 'package:school_app/pages/home_page.dart';
import 'package:school_app/pages/schedule_page.dart';
//import 'package:school_app/pages/student_page.dart';
import 'package:school_app/pages/settings_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  List<Key> _pageKeys = [
    UniqueKey(),
    UniqueKey(),
    UniqueKey(),
    UniqueKey(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index){
      //refresh page
      setState(() {
        _pageKeys[index] = UniqueKey();
      });
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    // _pageController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
    _pageController.jumpToPage(
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            HomePage(key: _pageKeys[0]),
            SchedulePage(key: _pageKeys[1]),
            GradesPage(key: _pageKeys[2]),
            //StudentPage(),
            SettingsPage(key: _pageKeys[3]),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,

        backgroundColor: colors.surface,
        indicatorColor: colors.primary,
        
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard,
              color: _selectedIndex == 0 ? colors.onPrimary : colors.onSurface,
            ), 
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(
              Icons.event,
              color: _selectedIndex == 1 ? colors.onPrimary : colors.onSurface,
            ), 
            label: 'Horário'
          ),
          NavigationDestination(
            icon: Icon(
              Icons.grade,
              color: _selectedIndex == 2 ? colors.onPrimary : colors.onSurface,
            ), 
            label: 'Notas'
          ),
          // NavigationDestination(
          //   icon: Icon(
          //     Icons.badge,
          //     color: _selectedIndex == 2 ? colors.onPrimary : colors.onSurface,
          //   ), 
          //   label: 'Perfil'
          // ),
          NavigationDestination(
            icon: Icon(
              Icons.settings,
              color: _selectedIndex == 3 ? colors.onPrimary : colors.onSurface,
            ), 
            label: 'Definições'
          ),
        ],
      ),
    );
  }
}