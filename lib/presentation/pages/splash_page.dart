import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presenta_app/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthenticationWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00B7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset(
                  'lib/assets/images/Logo Presenta.png',
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Presenta',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0A4ED2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
