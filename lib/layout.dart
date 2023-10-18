import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moawen/ProfilePage.dart';
import 'package:moawen/SearchbyKeywrds.dart';
import 'package:moawen/explore.dart';
import 'package:moawen/listviewpost.dart';
import 'package:moawen/postmodel.dart';
import 'package:moawen/screens/postForm.dart';
import 'package:moawen/search1.dart';
import 'ads_request.dart';
import 'login_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int index = 1;
  List<String> title = [
    'Home',
    'Explore',
    'Ads',
    'Profile',
  ];

  List<PostModel> post = [];
  List<String> docsId = [];

  getdata() {
    // post.clear();
    FirebaseFirestore.instance
        .collection('Post')
        .orderBy('Time', descending: true)
        .snapshots()
        .listen((value) {
      FirebaseFirestore.instance.collection('users').get().then((valUser) {
        post = [];
        for (var element in value.docs) {
          for (var users in valUser.docs) {
            // print(users.data()['NID']);
            // print(element.data()['UserID']);
            if (users.data()['NID'] == element.data()['UserID']) {
              var map = element.data();
              map.addAll({
                'name': '${users.data()['fname']} ${users.data()['lname']}',
                'username': users.data()['username'].toString(),
                'imageUser':
                    'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
              });
              post.add(PostModel.json(map));
              docsId.add(element.id);
            }
          }
        }
        setState(() {});
      }).catchError((e) {
        print(e.toString());
      });
      //setState(() {});
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      getdata();

      return Scaffold(
          appBar: AppBar(
            title: Text(title[index]),
            centerTitle: true,
            actions: [
              if (index == 3)
                PopupMenuButton(
                  onSelected: (value) {
                    // your logic
                    // if (value ==1){
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //         const ADSRequest()),
                    //   );
                    // }
                    if (value == 2) {
                      // Signout
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
                    }

                    // if (value ==4){
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //          makePayment()),
                    //   );
                    // }
                  },
                  itemBuilder: (BuildContext bc) {
                    return const [
                      
                      // PopupMenuItem(
                      //   value: 1,
                      //   child: Text("Ads"),
                      // ),
                      
                      PopupMenuItem(
                        value: 2,
                        child: Text("Logout"),
                      ),
                      PopupMenuItem(
                        value: 4,
                        child: Text("Make Payment"),
                      ),
                    ];
                  },
                ),
              if (index == 1)
                DropdownButton<String>(
                  underline: Container(),
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'account',
                      child: Text('Search by Account'),
                    ),
                    DropdownMenuItem(
                      value: 'post',
                      child: Text('Search by Post'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == 'post') {
                      showSearch(
                          context: context, delegate: CustomSearchDelegate());
                    }
                    if (value == 'account') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const search1()));
                    }
                  },
                )
            ],
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
            backgroundColor: const Color(0XFF2F6968),
            elevation: 0,
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) => setState(() {
              index = value;
            }),
            type: BottomNavigationBarType.fixed,
            currentIndex: index,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            backgroundColor: const Color(0XFF2F6968),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box),
                label: 'Ads',
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_pin),
                label: 'Profile',
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          ),
          body: index == 0
              ? Listview(post: post, docsId: docsId)
              : index == 1
                  ? ExploreScreen(docsId: docsId, post: post)
                  : index == 2
                      ? const ADSRequest()
                      : const ProfilePage(),
          floatingActionButton: index != 2 && index != 3
              ? FloatingActionButton.extended(
                  label: const Text('Add'),
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const postForm()));
                  },
                  backgroundColor: const Color(0XFF2F6968),
                  //child: const Text('Add'),
                )
              : Container());
    });
  }
}
