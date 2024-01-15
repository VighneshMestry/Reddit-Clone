// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_line.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int ctr = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void save() {
    ref.read(communityControllerProvider.notifier).addMods(
          widget.name,
          uids.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: save, icon: const Icon(Icons.done))],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) {
            return ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (BuildContext context, int index) {
                final member = community.members[index];
                // EXTREME LOGIC!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                return ref.watch(getUserDataProvider(member)).when(
                    data: (user) {
                      if (community.mods.contains(member) && ctr == 0) {
                        uids.add(member);
                      }
                      ctr++;
                      print(ctr);
                      return CheckboxListTile(
                        value: uids.contains(user.uid),
                        onChanged: (val) {
                          if (val!) {
                            addUid(user.uid);
                          } else {
                            removeUid(user.uid);
                          }
                        },
                        title: Text(user.name),
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorLine(error: error.toString()),
                    loading: () => const Loader());
              },
            );
          },
          error: (error, stackTrace) => ErrorLine(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
