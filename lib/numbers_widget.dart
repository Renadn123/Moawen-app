import 'package:flutter/material.dart';
import 'package:moawen/followerListPage.dart';
import 'package:moawen/followingListPage.dart';

class NumbersWidget extends StatelessWidget {
  final String postNum;
  final String uId;

  final int followings;
  final int followers;

  const NumbersWidget(
      {super.key,
      required this.postNum,
      required this.uId,
      required this.followings,
      required this.followers});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, postNum, 'Posts', () {}),
          buildDivider(),
          buildButton(context, '$followings', 'Following', () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FollowingListPage(uId: uId),
            ));
          }),
          buildDivider(),
          buildButton(context, '$followers', 'Followers', () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FollowersListPage(uId: uId),
            ));
          }),
        ],
      );
  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(
          BuildContext context, String value, String text, onPressed) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
