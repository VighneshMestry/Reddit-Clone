import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_line.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/router.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getData(WidgetRef ref, User user) async {
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(user.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (user) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Reddit',
            theme: Pallete.darkModeAppTheme,
            // routerDelegate: RoutemasterDelegate(
            //   routesBuilder: (context) {
            //     if(user != null) {
            //       getData(ref, user);
            //       if(userModel != null){
            //         return loggedInRoute;
            //       }
            //     }
            //     return loggedOutRoute;
            //   },
            // ),
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) => loggedInRoute),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorLine(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}

