import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/repository/post_repository.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    storageRepository: ref.read(storageRepositoryProvider),
    ref: ref,
    postRepository: ref.read(postRepositoryProvider),
  );
});

final getUserFeedPostProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserFeedPosts(communities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId)  {
  final postController = ref.read(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getCommentsOfPostProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.read(postControllerProvider.notifier);
  return postController.getCommentsOfPost(postId);
});

class PostController extends StateNotifier<bool> {
  StorageRepository _storageRepository;
  Ref _ref;
  PostRepository _postRepository;
  PostController({
    required StorageRepository storageRepository,
    required Ref ref,
    required PostRepository postRepository,
  })  : _storageRepository = storageRepository,
        _ref = ref,
        _postRepository = postRepository,
        super(false);

  void addTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    final postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: "text",
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).upateUserKarma(Userkarma.textPost);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "Posted successfully!");
        Routemaster.of(context).pop();
      },
    );
  }

  void addLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    final postId = Uuid().v1();
    final user = _ref.read(userProvider)!;

    Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: "link",
      createdAt: DateTime.now(),
      awards: [],
      description: link,
    );

    final res = await _postRepository.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).upateUserKarma(Userkarma.linkPost);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "Posted successfully!");
        Routemaster.of(context).pop();
      },
    );
  }

  void addImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File file,
  }) async {
    state = true;
    final postId = Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
        path: "posts/${selectedCommunity.name}", id: postId, file: file);

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: "image",
        createdAt: DateTime.now(),
        awards: [],
        link: r,
      );

      final res = await _postRepository.addPost(post);
      _ref.read(userProfileControllerProvider.notifier).upateUserKarma(Userkarma.imagePost);
      state = false;
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, "Posted successfully!");
          Routemaster.of(context).pop();
        },
      );
    });
  }

  Stream<List<Post>> fetchUserFeedPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserFeedPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post) async {
    _ref.read(userProfileControllerProvider.notifier).upateUserKarma(Userkarma.delete);
    await _postRepository.deletePost(post);
  }

  void upvote(Post post) {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, userId);
  }

  void downvote(Post post) {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, userId);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required String postId,
  }) async {
    String commentId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    Comment comment = Comment(
        id: commentId,
        text: text,
        createdAt: DateTime.now(),
        postId: postId,
        username: user.name,
        profilePic: user.profilePic);
    final res = await _postRepository.addComments(comment);
    _ref.read(userProfileControllerProvider.notifier).upateUserKarma(Userkarma.comment);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, "Comment Posted!"),
    );
  }

  Stream<List<Comment>> getCommentsOfPost (String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
