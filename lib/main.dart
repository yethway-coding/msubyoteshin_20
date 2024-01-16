import 'package:bot_toast/bot_toast.dart';
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
        builder: BotToastInit(),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [BotToastNavigatorObserver()],
        onGenerateRoute: Routes.onGenerateRoute,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const PageViewWidget(),
      ),
    );
  }
}
