import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child:
            SizedBox(height: 15, width: 15, child: CircularProgressIndicator()),
      ),
    );
  }
}
