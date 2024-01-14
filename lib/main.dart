import 'package:flutter/material.dart';
import 'package:msubyoteshin_20/routes/routes.dart';
import '/common/widgets/provider_widget.dart';
import '/common/utils/service_locator.dart';
import 'pageview/ui/pageview_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      child: MaterialApp(
        title: 'MSub YoteShin 2.0',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: Routes.onGenerateRoute,
        home: const PageViewWidget(),
      ),
    );
  }
}
