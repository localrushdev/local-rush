import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*void main() {
  runApp(const LocalRushApp());
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jpddgjgldsfpnabfnsgb.supabase.co',
    publishableKey: 'sb_publishable_KBm90IDFMQb1ne9HZazhjQ_SnRPO9UW',
  );

  runApp(const LocalRushApp());
}

class LocalRushApp extends StatelessWidget {
  const LocalRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Rush',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
      home: const SplashPage(),
    );
  }
}
