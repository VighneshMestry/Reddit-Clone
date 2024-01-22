import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  FirebaseFirestore _firestore;
  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).set(post.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserFeedPosts(List<Community> communities) {
    return _posts
        .where("communityName",
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String userId) {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        "downvotes": FieldValue.arrayRemove([userId])
      });
    }

    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        "upvotes": FieldValue.arrayRemove([userId])
      });
    } else {
      _posts.doc(post.id).update({
        "upvotes": FieldValue.arrayUnion([userId])
      });
    }
  }

  void downvote(Post post, String userId) {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        "upvotes": FieldValue.arrayRemove([userId])
      });
    }

    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        "downvotes": FieldValue.arrayRemove([userId])
      });
    } else {
      _posts.doc(post.id).update({
        "downvotes": FieldValue.arrayUnion([userId])
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComments(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(
            comment.toMap(),
          );
      return right(
        _posts.doc(comment.postId).update(
          {
            "commentCount": FieldValue.increment(1),
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments
        .where("postId", isEqualTo: postId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _users.doc(post.uid).update({
        "awards": FieldValue.arrayUnion([award]),
      });
      _users.doc(senderId).update({
        "awards": FieldValue.arrayRemove([award]),
      });
      return right(
        _posts.doc(post.id).update(
          {
            "awards": FieldValue.arrayUnion([award]),
          },
        ),
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
