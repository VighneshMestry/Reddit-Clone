import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref),
);


// Here we can also use "StreamBuilder" instead of "StreamProvider" to consume any stream
// There are two reason to not use the "StreamBuilder" 1] It has a lot of boiler-plate code 2] We gonna need to use it multiple times and it doesnot allow reusing the existing streambuilder so we have to make a new streambuilder every time
final authStateChangeProvider = StreamProvider((ref) {
  // WITHOUT THE .NOTIFIER THE AUTHCONTROLLERPROVIDER WILL GIVE ONLY THE BOOLEAN VALUE BECAUSE STATENOTIFIERPROVIDER PROVIDES THE PROVIDER AND BOOLEAN VALUE ONLY!!!!
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});


// The .family here allow us to use getUserDataProvider as a function which will accept uid as a parameter
// and the aim of accepting the uid is so that this provider can be used to get the userData of other users also. eg. while browsing any users profile.
final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Stream<UserModel> getUserData (String uid) {
    return _authRepository.getUserData(uid);
  }
}
