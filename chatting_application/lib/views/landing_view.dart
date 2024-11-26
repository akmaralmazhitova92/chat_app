import 'package:flutter/material.dart';

class LandingView extends StatefulWidget {
  const LandingView({ super.key });

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Flash chat',
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: const Text('sign in'),
          )
          ],
        ),
      ),
    );
  }
}