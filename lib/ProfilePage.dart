import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:moawen/edit_profile.dart';
import 'package:moawen/widget/flushbar_widget.dart';
import 'package:moawen/widget/numbers_widget.dart';
import 'package:moawen/postmodel.dart';
import 'package:moawen/user.dart';
import 'package:moawen/viewpost.dart';
import 'widget/button_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int followings = 0;
  int followers = 0;
  UserModel? profile;
  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(CatchHelper.uid ?? FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('followers')
            .get()
            .then((value) {
          followers = value.size;
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('following')
              .get()
              .then((val) {
            followings = val.size;
            profile =
                UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
            setState(() {});
          });
        });
      }
    });
  }

  List<PostModelProfile> post = [];
  List<String> docsId = [];

  getdata() {
    FirebaseFirestore.instance
        .collection('Post')
        .orderBy('Time', descending: true)
        .snapshots()
        .listen((value) {
      post = [];
      for (var e in value.docs) {
        if (e.data()['UserID'] == CatchHelper.uid) {
          post.add(PostModelProfile.json(e.data()));
          docsId.add(e.id);
        }
      }
    });
  }

  @override
  void initState() {
    _getDataFromDatabase();
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return profile == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 4.5,
                    child: Image.asset('lib/images/moawen.png'),
                  ),
                  const SizedBox(height: 24),
                  buildName(profile!),
                  const SizedBox(height: 24),
                  Center(child: buildUpgradeButton()),
                  const SizedBox(height: 24),
                  NumbersWidget(
                    postNum: post.length.toString(),
                    followers: followers,
                    followings: followings,
                    uId: profile!.userId,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
              ...List.generate(post.length, (index) {
                return buildAbout(post[index], profile!, docsId[index]);
              }),
            ],
          );
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Text(
            "${user.fName} ${user.lName}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Edit Profile',
        onClicked: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditScreen(
              profile: profile!,
            ),
          ));
        },
      );

  Widget buildAbout(PostModelProfile post, UserModel profile, String doc) =>
      InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewPost(
            data: PostModel(
                image: post.image,
                time: post.time,
                postText: post.postText,
                userid: post.userid,
                imageUser: '',
                name: "${profile.fName} ${profile.lName}",
                username: profile.username),
            docId: doc,
          ),
        )),
        child: Column(children: [
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0XFFF6FFFC)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.black, width: 4),
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
                        Text('${profile.fName} ${profile.lName}'),
                        Text(
                          '@${profile.username}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.postText,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    if (post.image != 'null')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0XFFF6FFFC),
                            image: DecorationImage(
                              image: NetworkImage(post.image),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(TimeOfDay.fromDateTime(DateTime.parse(post.time))
                            .format(context)
                            .toString()),
                        const SizedBox(width: 5.0),
                        Text(DateFormat.yMMMMd()
                            .format(DateTime.parse(post.time))
                            .toString()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                child: const Icon(Icons.mode_comment_outlined),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewPost(
                                      data: PostModel(
                                          image: post.image,
                                          time: post.time,
                                          postText: post.postText,
                                          userid: post.userid,
                                          imageUser: '',
                                          name:
                                              "${profile.fName} ${profile.lName}",
                                          username: profile.username),
                                      docId: profile.userId,
                                    ),
                                  ));
                                },
                              ))), //addcommentIcon
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                child: const Icon(Icons.favorite),
                                onTap: () {},
                              ))), //likeIcon

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            child: const Icon(
                              Icons.delete,
                            ),
                            onTap: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Delete Post"),
                                  content: const Text(
                                      "Are you sure you want to delete your Post ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, "Cancel"),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        final docuser = FirebaseFirestore
                                            .instance
                                            .collection('Post')
                                            .doc(doc);
                                        docuser.delete();
                                        setState(() {});
                                        flushbar(
                                            context, 'Deleted successfully');
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFFEC1F1F),
                                      ),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
                              //endshowDialog
                            },
                          ),
                        ),
                      ), //deletIcon
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
}
