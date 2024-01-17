import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

// class SignInButton extends ConsumerWidget {
//   final bool isFromLogin;
//   const SignInButton({Key? key, this.isFromLogin = true}) : super(key: key);

//   void signInWithGoogle(BuildContext context, WidgetRef ref) {
//     ref.read(authControllerProvider.notifier).signInWithGoogle(context);

//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: const EdgeInsets.all(18.0),
//       child: ElevatedButton.icon(
//         onPressed: () => signInWithGoogle(context, ref),
//         icon: Image.asset(
//           Constants.googlePath,
//           width: 35,
//         ),
//         label: const Text(
//           'Continue with Google',
//           style: TextStyle(fontSize: 18),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Pallete.greyColor,
//           minimumSize: const Size(double.infinity, 50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//     );
//   }
// }

class SignInButton extends ConsumerStatefulWidget {
  final bool isFromLogin;
  const SignInButton({Key? key, this.isFromLogin = true}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<SignInButton> {
  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
    setState(() {
      print("done");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
