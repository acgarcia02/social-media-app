import 'package:flutter/material.dart';

Widget avatar() {
  return const SizedBox(
    width: 70,
    height: 70,
    child: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-11.jpg')),
  );
}

Widget numPosts(int num) {
  return Container(
      padding: const EdgeInsets.only(left: 30.0, right: 15.0),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  num.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text("Posts", style: TextStyle(fontSize: 14))
              ],
            ),
          )
        ],
      ));
}

Widget buildUserInfo(userInfo) {
  return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Column(
        children: <Widget>[
          Text(
            userInfo.data.firstName + " " + userInfo.data.lastName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text("@" + userInfo.data.username,
              style: const TextStyle(fontSize: 16, color: Colors.grey))
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ));
}
