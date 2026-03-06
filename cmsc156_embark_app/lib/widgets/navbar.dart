import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final Color _activeColor = const Color(0xFFF08080);
  final Color _inactiveColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _selectedIndex == 0 ? 'Home Page' : 'Checklist Page', //for testing
          style: const TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            onPressed: () {
              print("FAB Pressed"); //temp
            },
            backgroundColor: const Color(0xFFF08080),
            shape: const CircleBorder(),
            child: const Icon(Icons.pets, color: Colors.white),
          ),
          Positioned(
            bottom: -20,
            child: const Text(
              'Add Entry',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ), //reminder: change font
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: Colors.white10),
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  //home icon
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
                InkWell(
                  //checklist icon
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
