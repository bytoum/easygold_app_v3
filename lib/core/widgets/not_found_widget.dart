import 'package:flutter/material.dart';

class NotFoundWidget extends StatelessWidget {
  final String? message;
  const NotFoundWidget({super.key, this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message ?? "Not Found",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
