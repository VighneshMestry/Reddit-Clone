import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/community_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      final communityDocs = await _communities.doc(community.name).get();
      if (communityDocs.exists) {
        throw "Community already exists";
      }
      // No 'await' is used because the return type of the function is 'void' so no need of the 'await' as there is no output to be waited for
      // hover on the below right function and check the type and the return type of the function "createCommunity" is also FutureVoid
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  Stream<List<Community>> getUserCommunities (String uid) {
    // snapshots() provides the list of QuerySnapshot so the map function iterates the list and provides event which is the every single QuerySnapshot from the list
    return _communities.where("members", arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for(var docs in event.docs){
        // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
        communities.add(Community.fromMap(docs.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
