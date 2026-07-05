import 'package:flutter/material.dart';

/// Placeholder for features that only have their folder scaffolding so far
/// (see lib/features/*). Replace with the real screen once the feature is
/// implemented.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.featureName});

  final String featureName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(featureName)),
      body: Center(child: Text('$featureName — próximamente')),
    );
  }
}
