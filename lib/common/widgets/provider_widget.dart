import 'package:flutter/material.dart';
import 'package:msubyoteshin_20/features/genre/provider/gnere_provider.dart';
import 'package:provider/provider.dart';
import '/features/home/provider/current_provider.dart';

class ProviderWidget extends StatelessWidget {
  const ProviderWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentProvider()),
        ChangeNotifierProvider(create: (_) => GenreProvider()),
      ],
      child: child,
    );
  }
}
