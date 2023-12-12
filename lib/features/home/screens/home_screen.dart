import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';
// import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});


    //Different context because the context used is the context of the widget that instantiated the scaffold and not the context of the child of the scaffold
    // No Scaffold ancestor could be found starting from the context that was passed to Scaffold.of(). This
    //  usually happens when the context provided is from the same StatefulWidget as that whose build
    // function actually creates the Scaffold widget being sought.

    // There are several ways to avoid this problem. The simplest is to use a Builder to get a context that is "under" the Scaffold.
  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => openDrawer(context),
              icon: const Icon(Icons.menu),
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            // icon: const CircleAvatar(backgroundImage: NetworkImage("")),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      drawer: const CommunityListDrawer(),
    );
  }
}
