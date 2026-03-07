import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _showButton = false;
  bool _isPressed = false;

  // Controller being used by both the button scale and logo slide animations
  late AnimationController _controller;
  
  // Scales the button up from 0 to full size
  late Animation<double> _buttonScaleAnimation;
  
  // Slides the logo from a lower position (Offset Y: 0.5) to the actual position (Offset Y: 0)
  late Animation<Offset> _logoSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Bouncy button scale
    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.elasticOut, // Bouncy curve!
      ),
    );

    // Bouncy logo slide
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Starts at slightly lower position
      end: Offset.zero,            // Slides up to its actual position in the center
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // bouncy animation
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showButton = true;
        });
      }
      _controller.forward(); // To trigger BOTH animations at the same time
    });
  }
  
  /// Dispose controllers to avoid memory leaks
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFB5A7),
        width: double.infinity,
        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),

              /// EMBARK LOGO & TITLE
              SlideTransition(
                position: _logoSlideAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.pets, size: 125, color: Color(0xFFFFB5A7)),
                    ),

                    const SizedBox(height: 20),
                
                    Text(
                      " Embark!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: const [
                          Shadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 4),
                            blurRadius: 5.6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// GET STARTED BUTTON 
              ScaleTransition(
                scale: _buttonScaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),

                  child: GestureDetector(
                    onTapDown: _showButton
                        ? (_) {
                          setState(() {
                            _isPressed = true;
                          });
                        }
                        : null,

                    onTapUp: _showButton
                        ? (_) {
                          setState(() {
                            _isPressed = false;
                          });
                          Navigator.pushReplacementNamed(context, '/navbar');
                        }
                        : null,

                    onTapCancel: _showButton
                        ? () {
                          setState(() {
                            _isPressed = false;
                          });
                          
                        } : null,
                        
                    child: Container(
                      width: 345,
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isPressed 
                        ? const Color.fromARGB(255, 255, 197, 186) 
                        : const Color(0xFFF8EDEB),
                        
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFC94545),
                            offset: Offset(4, 5),   
                            blurRadius: 2,               
                            spreadRadius: 0
                          ),
                        ],
                      ),

                      child: Text(
                        "Get Started",
                        style: GoogleFonts.nunito(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        textAlign: TextAlign.center,
                      )

                    ),
                  )
                )
              )
            ],
          ),
        ),
      )
    );
  }
}