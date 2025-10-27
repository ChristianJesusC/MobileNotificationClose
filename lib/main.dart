import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/secure_storage_service.dart';
import 'data/repositories/user_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  final firebaseService = FirebaseService();
  final secureStorageService = SecureStorageService();
  final notificationService = NotificationService(secureStorageService);
  
  await firebaseService.initialize(notificationService);
  
  runApp(MyApp(
    firebaseService: firebaseService,
    secureStorageService: secureStorageService,
    notificationService: notificationService,
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseService firebaseService;
  final SecureStorageService secureStorageService;
  final NotificationService notificationService;

  const MyApp({
    Key? key,
    required this.firebaseService,
    required this.secureStorageService,
    required this.notificationService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>.value(value: firebaseService),
        Provider<SecureStorageService>.value(value: secureStorageService),
        Provider<NotificationService>.value(value: notificationService),
        Provider<UserRepository>(
          create: (context) => UserRepository(secureStorageService),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<UserRepository>(),
            notificationService,
          ),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
            context.read<UserRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Secure App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}