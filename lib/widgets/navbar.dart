import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/add_entry/add_entry_stepone.dart';
import '../screens/stray_checklist/checklist.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final Color _activeColor = const Color(0xFFF08080);
  final Color _inactiveColor = Colors.black;

  final List<Widget> _pages = const [HomeScreen(), ChecklistScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEntryStep1()),
              );
            },
            backgroundColor: const Color(0xFFF08080),
            shape: const CircleBorder(),
            child: const Icon(Icons.pets, color: Colors.white),
          ),
          const Positioned(
            bottom: -20,
            child: Text(
              'Add Entry',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: Colors.white12),

          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Colors.white,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /// HOME
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home,
                        color: _selectedIndex == 0
                            ? _activeColor
                            : _inactiveColor,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == 0
                              ? _activeColor
                              : _inactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 40),

                /// CHECKLIST
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: _selectedIndex == 1
                            ? _activeColor
                            : _inactiveColor,
                      ),
                      Text(
                        'Checklist',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == 1
                              ? _activeColor
                              : _inactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
