import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moawen/widget/flushbar_widget.dart';
import 'package:moawen/postmodel.dart';
import 'package:moawen/userProfile.dart';
import 'package:moawen/viewpost.dart';
import 'package:intl/intl.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.post, required this.docsId});
  final List<PostModel> post;
  final List<String> docsId;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.post.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.separated(
            separatorBuilder: (context, index) => Container(
              color: Colors.grey,
              height: 1,
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ViewPost(
                    data: widget.post[index], docId: widget.docsId[index]),
              )),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 10, bottom: 20),
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
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserProfile(
                                        uid: widget.post[index].userid,
                                        name: widget.post[index].name),
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
                                    uid: widget.post[index].userid,
                                    name: widget.post[index].name),
                              ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.post[index].name),
                                Text(
                                  '@${widget.post[index].username}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
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
                            widget.post[index].postText,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          if (widget.post[index].image != 'null')
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0XFFF6FFFC),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(widget.post[index].image),
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
                              Text(TimeOfDay.fromDateTime(
                                      DateTime.parse(widget.post[index].time))
                                  .format(context)
                                  .toString()),
                              const SizedBox(width: 5.0),
                              Text(DateFormat.yMMMMd()
                                  .format(
                                      DateTime.parse(widget.post[index].time))
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
                                      child: const Icon(
                                          Icons.mode_comment_outlined),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => ViewPost(
                                              data: widget.post[index],
                                              docId: widget.docsId[index]),
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
                            if (CatchHelper.uid == widget.post[index].userid)
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
                                                Navigator.of(context).pop();
                                                final docuser =
                                                    FirebaseFirestore.instance
                                                        .collection('Post')
                                                        .doc(widget
                                                            .docsId[index]);
                                                docuser.delete();
                                                setState(() {
                                                  widget.post.removeAt(index);
                                                });
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
            ),
            itemCount: widget.post.length,
          );
    // floatingActionButton: post.isNotEmpty
    //     ? FloatingActionButton(
    //         onPressed: () {
    //           Navigator.push(context,
    //               MaterialPageRoute(builder: (context) => const postForm()));
    //         },
    //         child: const Text('Add'))
    //     : Container(),
    // );
  }
}
