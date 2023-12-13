import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_line.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateToCreateCommunity(BuildContext context) {
      Routemaster.of(context).push('/create-community');
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text("Create a community"),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(getUserCommunitiesProvider).when(
              // Despite having the size of the drawer the ListView.builder wants to take all the available space which was not possible
              // So we used the Expanded widget to make the Listview.builder adjust in the available space
                data: (communities) => Expanded(
                  child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text('r/${communities[index].name}'),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(communities[index].avatar),
                          ),
                          onTap: () {},
                        ),
                      ),
                ),
                error: (error, stackTrace) =>
                    ErrorLine(error: error.toString()),
                loading: () => const Loader()),
          ],
        ),
      ),
    );
  }
}
