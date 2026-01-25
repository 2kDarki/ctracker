import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 64),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
