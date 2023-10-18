import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moawen/widget/flushbar_widget.dart';
import 'package:moawen/layout.dart';

import 'package:moawen/postmodel.dart';
import 'package:moawen/userProfile.dart';

class ViewPost extends StatefulWidget {
  final PostModel data;
  final String docId;
  const ViewPost({Key? key, required this.data, required this.docId})
      : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  final commentKey = GlobalKey<FormState>();
  final textComment = TextEditingController();
  final List<CommentsModel> _comment = [];

  // getComments() {
  //   //_comment.clear();
  //   FirebaseFirestore.instance
  //       .collection('Post')
  //       .doc(widget.docId)
  //       .collection('comments')
  //       .orderBy('Time', descending: true)
  //       .snapshots()
  //       .listen((value) {
  //     print('test');
  //     FirebaseFirestore.instance.collection('users').get().then((valUser) {
  //       print('test2');
  //       for (var users in valUser.docs) {
  //         print('in loop user');
  //         for (var element in value.docs) {
  //           print('in loop comment');
  //           if (users.id == element.data()['UserID']) {
  //             print('in if');
  //             var map = element.data();
  //             map.addAll({'commentsId': element.id});
  //             map.addAll({
  //               'name': '${users.data()['fname']} ${users.data()['lname']}',
  //               'username': users.data()['username'].toString(),
  //               'imageUser':
  //                   'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
  //             });
  //             _comment.add(CommentsModel.json(map));
  //           }
  //         }
  //       }
  //     }).catchError((e) {
  //       Fluttertoast.showToast(
  //         msg: e.toString(),
  //         gravity: ToastGravity.TOP,
  //       );
  //     });
  //     setState(() {});
  //   });
  // }

  FocusNode focusNode = FocusNode();
  getComments() async {
    FirebaseFirestore.instance
        .collection('Post')
        .doc(widget.docId)
        .collection('comments')
        .orderBy('time', descending: true)
        .snapshots()
        .listen((value) {
      FirebaseFirestore.instance.collection('users').get().then((users) {
        _comment.clear();
        for (var element in value.docs) {
          for (var user in users.docs) {
            if (element.data()['userid'] == user.data()['NID']) {
              var map = element.data();
              map.addAll({'commentsId': element.id});
              map.addAll({
                'name': '${user.data()['fname']} ${user.data()['lname']}',
                'username': user.data()['username'],
                'imageUser':
                    'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
              });
              _comment.add(CommentsModel.json(map));
              setState(() {});
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Post Details',
          ),
          backgroundColor: const Color(0XFFF6FFFC),
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 10, bottom: 10.0),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(25),
                        color: Color(0XFFF6FFFC)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                        uid: widget.data.userid,
                                        name: widget.data.name,
                                      ),
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
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                    uid: widget.data.userid,
                                    name: widget.data.name,
                                  ),
                                ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.data.name),
                                  Text(
                                    '@${widget.data.username}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (widget.data.image != 'null')
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0XFFF6FFFC),
                                image: DecorationImage(
                                  image: NetworkImage(widget.data.image),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.data.postText,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(TimeOfDay.fromDateTime(
                                    DateTime.parse(widget.data.time))
                                .format(context)
                                .toString()),
                            const SizedBox(width: 5.0),
                            Text(DateFormat.yMMMMd()
                                .format(DateTime.parse(widget.data.time))
                                .toString()),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                                    child:
                                        const Icon(Icons.mode_comment_outlined),
                                    onTap: () {
                                      focusNode.requestFocus();
                                    },
                                  ),
                                ),
                              ), //addcommentIcon
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        child: const Icon(Icons.favorite),
                                        onTap: () {},
                                      ))), //likeIcon

                              if (widget.data.userid == CatchHelper.uid)
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
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text("Delete Post"),
                                            content: const Text(
                                                "Are you sure you want to delete your Post ?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, "Cancel"),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  FirebaseFirestore.instance
                                                      .collection("Post")
                                                      .doc(widget.docId)
                                                      .delete()
                                                      .then((value) {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const MainLayout(),
                                                            ),
                                                            (route) => false);
                                                  });
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...List.generate(_comment.length, (index) {
                    return Card(
                      color: const Color(0XFFF6FFFC),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                    child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_comment[index].name),
                                      Text(
                                        '@${_comment[index].username}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  if (_comment[index].userid == CatchHelper.uid)
                                    IconButton(
                                      onPressed: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext site) =>
                                              AlertDialog(
                                            title: const Text("Delete Post"),
                                            content: const Text(
                                                "Are you sure you want to delete your Post ?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    site, "Cancel"),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  FirebaseFirestore.instance
                                                      .collection('Post')
                                                      .doc(widget.docId)
                                                      .collection('comments')
                                                      .doc(_comment[index]
                                                          .commentsId)
                                                      .delete()
                                                      .then((value) {
                                                    Navigator.of(site).pop();
                                                  }).catchError((e) {
                                                    print(e.toString());
                                                  });
                                                  Navigator.of(site).pop();
                                                  flushbar(context,
                                                      'Deleted successfully');
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
                                      icon: const Icon(Icons.delete),
                                    )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _comment[index].text,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(TimeOfDay.fromDateTime(
                                              DateTime.parse(
                                                  _comment[index].time))
                                          .format(context)
                                          .toString()),
                                      const SizedBox(width: 5.0),
                                      Text(DateFormat.yMMMMd()
                                          .format(DateTime.parse(
                                              _comment[index].time))
                                          .toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0XFF2F6968),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: commentKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "plz inter comment ";
                          }
                          return null;
                        },
                        focusNode: focusNode,
                        controller: textComment,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add Comment ..',
                            hintStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (commentKey.currentState!.validate()) {
                          FirebaseFirestore.instance
                              .collection('Post')
                              .doc(widget.docId)
                              .collection('comments')
                              .add({
                            'time': DateTime.now().toString(),
                            'text': textComment.text,
                            'userid': CatchHelper.uid,
                          }).then((value) {
                            textComment.clear();
                            getComments();
                          }).catchError((e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          });
                        }
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.only(left: 10),
            //   alignment: Alignment.centerLeft,
            //   width: double.infinity,
            //   height: 50,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(25),
            //     color: const Color.fromARGB(255, 185, 224, 195),
            //   ),
            //   child: const Text('Add Comment'),
            // )
          ],
        ));
  }
} //end

class CommentsModel {
  late String text;
  late String commentsId;
  late String userid;
  late String time;
  late String username;
  late String name;
  late String imageUser;
  CommentsModel({
    required this.text,
    required this.commentsId,
    required this.time,
    required this.username,
    required this.name,
    required this.imageUser,
    required this.userid,
  });

  CommentsModel.json(Map data) {
    text = data['text'];
    userid = data['userid'];
    imageUser = data['imageUser'].toString();
    name = data['name'].toString();
    username = data['username'].toString();
    time = data['time'].toString();
    commentsId = data['commentsId'];
  }
}
