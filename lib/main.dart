import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/auth_view_model.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'views/user_home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Psique Lounge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          primary: const Color(0xFFD4AF37),
          secondary: const Color(0xFFC5A028),
        ),
        useMaterial3: true,
      ),
      home: Consumer<AuthViewModel>(
        builder: (context, auth, _) {
          if (!auth.isAuthenticated) {
            return const LoginScreen();
          }
          
          return auth.isAdmin ? const HomeScreen() : const UserHomeScreen();
        },
      ),
    );
  }
}
