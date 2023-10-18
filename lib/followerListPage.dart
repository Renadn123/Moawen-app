// import 'package:flutter_twitter_clone/ui/theme/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_twitter_clone/model/user.dart';
// import 'package:flutter_twitter_clone/ui/page/common/usersListPage.dart';
// import 'package:flutter_twitter_clone/ui/page/profile/follow/followListState.dart';
// import 'package:flutter_twitter_clone/widgets/newWidget/customLoader.dart';
// import 'package:provider/provider.dart';

// class FollowerListPage extends StatelessWidget {
//   const FollowerListPage({Key? key, this.userList, this.profile})
//       : super(key: key);
//   final List<String>? userList;
//   final UserModel? profile;

//   static MaterialPageRoute getRoute(
//       {required List<String> userList, required UserModel profile}) {
//     return MaterialPageRoute(
//       builder: (BuildContext context) {
//         return ChangeNotifierProvider(
//           create: (_) => FollowListState(StateType.follower),
//           child: FollowerListPage(userList: userList, profile: profile),
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
//       pageTitle: 'Followers',
//       userIdsList: userList,
//       // appBarIcon: AppIcon.follow,
//       emptyScreenText: '${profile?.userName} doesn\'t have any followers',
//       emptyScreenSubTileText:
//           'When someone follow them, they\'ll be listed here.',
//       isFollowing: (user) {
//         return context.watch<FollowListState>().isFollowing(user);
//       },
//       onFollowPressed: (user) {
//         context.read<FollowListState>().followUser(user);
//       },
//     );
//   }
// }
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
import 'package:moawen/user.dart';
import 'package:moawen/userProfile.dart';

class FollowersListPage extends StatefulWidget {
  const FollowersListPage({super.key, required this.uId});
  final String uId;

  @override
  State<FollowersListPage> createState() => _FollowersListPageState();
}

class _FollowersListPageState extends State<FollowersListPage> {
  bool isLoading = true;
  List<UserModel> users = [];
  List<String> follower = [];

  getAllUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      users.clear();
      for (var element in event.docs) {
        users.add(UserModel.fromMap(element.data()));
        if (element.id == widget.uId) {
          element.reference.collection('followers').get().then((value) {
            for (var ele in value.docs) {
              follower.add(ele.data()['ID']);
            }
            setState(() {
              isLoading = false;
            });
          }).catchError((e) {
            print(e.toString());
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
    List<UserModel> followers = [];
    for (var e in users) {
      for (var element in follower) {
        if (element == e.userId) {
          followers.add(e);
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF2F6968),
        title: const Text('Followers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : followers.isEmpty
                ? Center(
                    child: widget.uId == FirebaseAuth.instance.currentUser!.uid
                        ? const Text('You Don\'t have any Followers !')
                        : const Text(
                            'This account Don\'t have any Followers !'),
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
                                        uid: followers[index].userId,
                                        name:
                                            "${followers[index].fName} ${followers[index].lName}"),
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
                                  "${followers[index].fName} ${followers[index].lName}"),
                              Text(
                                '@${followers[index].username}',
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
                                            .collection('followers')
                                            .doc(followers[index].userId)
                                            .delete();
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(followers[index].userId)
                                            .collection('following')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .delete();

                                        setState(() {
                                          follower.removeAt(index);
                                        });
                                      }
                                    : () async {
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .collection('following')
                                            .doc(followers[index].userId)
                                            .set({
                                          'ID': followers[index].userId,
                                        });
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(followers[index].userId)
                                            .collection('followers')
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .set({
                                          'ID': FirebaseAuth
                                              .instance.currentUser?.uid,
                                        });
                                      },
                                child: Row(
                                  children: [
                                    Text(
                                      widget.uId ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? 'Remove  @${followers[index].username}'
                                          : 'Following @${followers[index].username}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
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
                              child: Text(
                                widget.uId ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? 'Remove'
                                    : 'Following',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // MaterialButton(
                          //   color: const Color(0XFF2F6968),
                          //   onPressed: widget.uId ==
                          //           FirebaseAuth.instance.currentUser!.uid
                          //       ? () async {
                          //           await FirebaseFirestore.instance
                          //               .collection("users")
                          //               .doc(FirebaseAuth
                          //                   .instance.currentUser?.uid)
                          //               .collection('followers')
                          //               .doc(followers[index].userId)
                          //               .delete();
                          //           await FirebaseFirestore.instance
                          //               .collection("users")
                          //               .doc(followers[index].userId)
                          //               .collection('following')
                          //               .doc(FirebaseAuth
                          //                   .instance.currentUser!.uid)
                          //               .delete();

                          //           setState(() {
                          //             follower.removeAt(index);
                          //           });
                          //         }
                          //       : () async {
                          //           await FirebaseFirestore.instance
                          //               .collection("users")
                          //               .doc(FirebaseAuth
                          //                   .instance.currentUser?.uid)
                          //               .collection('following')
                          //               .doc(followers[index].userId)
                          //               .set({
                          //             'ID': followers[index].userId,
                          //           });
                          //           await FirebaseFirestore.instance
                          //               .collection("users")
                          //               .doc(followers[index].userId)
                          //               .collection('followers')
                          //               .doc(FirebaseAuth
                          //                   .instance.currentUser?.uid)
                          //               .set({
                          //             'ID': FirebaseAuth
                          //                 .instance.currentUser?.uid,
                          //           });
                          //         },
                          //   child: Text(
                          //     widget.uId ==
                          //             FirebaseAuth.instance.currentUser!.uid
                          //         ? 'Remove'
                          //         : 'Following',
                          //     style: const TextStyle(color: Colors.white),
                          //   ),
                          // )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: followers.length),
      ),
    );
  }
}
