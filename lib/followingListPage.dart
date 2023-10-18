// import 'package:flutter_twitter_clone/ui/theme/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_twitter_clone/model/user.dart';
// import 'package:flutter_twitter_clone/ui/page/common/usersListPage.dart';
// import 'package:flutter_twitter_clone/ui/page/profile/follow/followListState.dart';
// import 'package:flutter_twitter_clone/widgets/newWidget/customLoader.dart';
// import 'package:provider/provider.dart';

// class FollowingListPage extends StatelessWidget {
//   const FollowingListPage(
//       {Key? key, required this.profile, required this.userList})
//       : super(key: key);
//   final List<String> userList;
//   final UserModel profile;

//   static MaterialPageRoute getRoute(
//       {required List<String> userList, required UserModel profile}) {
//     return MaterialPageRoute(
//       builder: (BuildContext context) {
//         return ChangeNotifierProvider(
//           create: (_) => FollowListState(StateType.following),
//           child: FollowingListPage(profile: profile, userList: userList),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (context.watch<FollowListState>().isbusy) {
//       return SizedBox(
//         height: context.height,
//         child: CustomScreenLoader(
//           height: double.infinity,
//           width: context.width,
//           backgroundColor: Colors.white,
//         ),
//       );
//     }
//     return UsersListPage(
//       pageTitle: 'Following',
//       userIdsList: userList,
//       appBarIcon: AppIcon.follow,
//       emptyScreenText:
//           '${profile.userName ?? profile.userName} isn\'t follow anyone',
//       emptyScreenSubTileText: 'When they do they\'ll be listed here.',
//       onFollowPressed: (user) {
//         context.read<FollowListState>().followUser(user);
//       },
//       isFollowing: (user) {
//         return context.watch<FollowListState>().isFollowing(user);
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moawen/flushbar_widget.dart';
import 'package:moawen/user.dart';
import 'package:moawen/userProfile.dart';

class FollowingListPage extends StatefulWidget {
  const FollowingListPage({super.key, required this.uId});
  final String uId;

  @override
  State<FollowingListPage> createState() => _FollowingListPageState();
}

class _FollowingListPageState extends State<FollowingListPage> {
  bool isLoading = true;
  List<UserModel> users = [];
  List<String> following = [];

  getAllUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      users.clear();
      for (var element in event.docs) {
        users.add(UserModel.fromMap(element.data()));
        if (element.id == widget.uId) {
          element.reference.collection('following').get().then((value) {
            for (var ele in value.docs) {
              following.add(ele.data()['ID']);
            }
            setState(() {
              isLoading = false;
            });
          }).catchError((e) {
            flushbar(context, e.toString());
          });
        }
      }
    });
  }

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> followings = [];
    for (var e in users) {
      for (var element in following) {
        if (element == e.userId) {
          followings.add(e);
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF2F6968),
        title: const Text('Followings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : followings.isEmpty
                ? Center(
                    child: widget.uId == FirebaseAuth.instance.currentUser!.uid
                        ? const Text('You Don\'t Following any Account !')
                        : const Text(
                            'This account Don\'t have any Following !'),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserProfile(
                                        uid: followings[index].userId,
                                        name:
                                            "${followings[index].fName} ${followings[index].lName}"),
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        color: Colors.black, width: 4),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${followings[index].fName} ${followings[index].lName}"),
                              Text(
                                '@${followings[index].username}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: widget.uId ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? () async {
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .collection('following')
                                            .doc(followings[index].userId)
                                            .delete();
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(followings[index].userId)
                                            .collection('followers')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .delete();

                                        setState(() {
                                          following.removeAt(index);
                                        });
                                      }
                                    : () async {
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .collection('following')
                                            .doc(followings[index].userId)
                                            .set({
                                          'ID': followings[index].userId,
                                        });
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(followings[index].userId)
                                            .collection('followers')
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .set({
                                          'ID': FirebaseAuth
                                              .instance.currentUser?.uid,
                                        });
                                      },
                                child: Text(
                                  'unfollowing @${followings[index].username}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                            shape: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0XFF2F6968),
                                ),
                                child: widget.uId ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? const Text(
                                        'Unfollowing',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const Text(
                                        'Following',
                                        style: TextStyle(color: Colors.white),
                                      )),
                          ),
                          // MaterialButton(
                          //     color: const Color(0XFF2F6968),
                          //     onPressed: widget.uId ==
                          //             FirebaseAuth.instance.currentUser!.uid
                          //         ? () async {
                          //             await FirebaseFirestore.instance
                          //                 .collection("users")
                          //                 .doc(FirebaseAuth
                          //                     .instance.currentUser?.uid)
                          //                 .collection('following')
                          //                 .doc(followings[index].userId)
                          //                 .delete();
                          //             await FirebaseFirestore.instance
                          //                 .collection("users")
                          //                 .doc(followings[index].userId)
                          //                 .collection('followers')
                          //                 .doc(FirebaseAuth
                          //                     .instance.currentUser!.uid)
                          //                 .delete();

                          //             setState(() {
                          //               following.removeAt(index);
                          //             });
                          //           }
                          //         : () async {
                          //             await FirebaseFirestore.instance
                          //                 .collection("users")
                          //                 .doc(FirebaseAuth
                          //                     .instance.currentUser?.uid)
                          //                 .collection('following')
                          //                 .doc(followings[index].userId)
                          //                 .set({
                          //               'ID': followings[index].userId,
                          //             });
                          //             await FirebaseFirestore.instance
                          //                 .collection("users")
                          //                 .doc(followings[index].userId)
                          //                 .collection('followers')
                          //                 .doc(FirebaseAuth
                          //                     .instance.currentUser?.uid)
                          //                 .set({
                          //               'ID': FirebaseAuth
                          //                   .instance.currentUser?.uid,
                          //             });
                          //           },
                          //     child: widget.uId ==
                          //             FirebaseAuth.instance.currentUser!.uid
                          //         ? const Text(
                          //             'Unfollowing',
                          //             style: TextStyle(color: Colors.white),
                          //           )
                          //         : const Text(
                          //             'Following',
                          //             style: TextStyle(color: Colors.white),
                          //           ))
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: followings.length),
      ),
    );
  }
}
