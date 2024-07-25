import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_try/models/comments_model.dart';
import 'package:project_try/models/single_comment_model.dart';
import 'models/post_model.dart';
import 'models/user_model.dart';
import 'models/token_model.dart';
import 'models/friends_model.dart';
import 'models/single_post_model.dart';

String? token;
String? user;
String? idNext;
String? idPrev;

class Helper {
  //a function that registers a new user
  Future<User> signup(String username, String password, String firstName,
      String lastName) async {
    var response = await http.post(
      // call POST request
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer Zxi!!YbZ4R9GmJJ!h5tJ9E5mghwo4mpBs@*!BLoT6MFLHdMfUA%'
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 response,
      // then throw an exception.
      throw Exception("Unable to sign up.");
    }
  }

  // a function that takes two strings, the username and the password, as parameters and uses post method to log in user
  Future<Response> login(String username, String password) async {
    // try {
    var response = await http.post(
      // call POST request
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    user = username;
    var res = Response.fromJson(jsonDecode(response.body));
    token = res.data?.token;
    return res;
  }

  //a function that gets all posts from network and returns Posts
  Future<Posts> getPosts() async {
    final response = await http // call GET request
        .get(Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      var p = Posts.fromJson(jsonDecode(response.body));
      idNext = p.data![p.data!.length - 1].id;
      return p;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception(token);
    }
  }

  //a function that gets the next posts in the next page from network
  Future<Posts> getNext() async {
    final response = await http // call GET request
        .get(
            Uri.parse(
                'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?next=$idNext'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      var p = Posts.fromJson(jsonDecode(response.body));
      idNext = p.data![p.data!.length - 1].id;
      idPrev = p.data![0].id;
      return p;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception(token);
    }
  }

  //a function that gets the posts in the previous page from network
  Future<Posts> getPrev() async {
    final response = await http // call GET request
        .get(
            Uri.parse(
                'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?previous=$idPrev'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      var p = Posts.fromJson(jsonDecode(response.body));
      idNext = p.data![p.data!.length - 1].id;
      idPrev = p.data![1].id;
      return p;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception(token);
    }
  }

  //a function that calls post to log out user
  Future logout() async {
    var response = await http.post(
      // call POST request
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/logout'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var success = data['success'];
      return success;
    } else {
      // If the server did not return a 200 response,
      // then throw an exception.
      throw Exception("Unable to log out.");
    }
  }

  // a function that updates the data of the user on the server using put and returns the User object
  Future<User> updateUser(String oldPassword, String newPassword,
      String firstName, String lastName) async {
    var response = await http.put(
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user/$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'firstName': firstName,
        'lastName': lastName
      }),
    );
    return User.fromJson(jsonDecode(response.body));
  }

  // a function that takes a string (username) to get other users in the server
  Future<User> fetchUser(String username) async {
    final response = await http // call GET request
        .get(
            Uri.parse(
                'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user/$username'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception(token);
    }
  }

  // a function for getting the current logged in user
  Future<User> fetchCurrent() async {
    final response = await http // call GET request
        .get(
            Uri.parse(
                'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user/$user'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception(token);
    }
  }

  // a function for getting the posts of the current user
  Future<Posts> getUserPosts() async {
    final response = await http // call GET request
        .get(
            Uri.parse(
                'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?username=$user'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Posts.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception("Unable to get posts.");
    }
  }

  // a function that takes a string (username) for getting the posts of the selected user
  Future<Posts> getPostsFromUser(String username) async {
    final response = await http // call GET request
        .get(
            Uri.parse(
                'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?username=$username'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Posts.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception("Unable to get posts.");
    }
  }

  // a function gfor getting the friends of the logged in user
  Future<Friend> getFriends() async {
    final response = await http // call GET request
        .get(
            Uri.parse(
                'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user?friends=true'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Friend.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception(token);
    }
  }

  // a function for adding a selected user to the followeing of the logged in user
  Future follow(String id) async {
    var response = await http.post(
        Uri.parse(
            'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/follow/$id'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var success = data['success'];
      return success;
    } else {
      var data = jsonDecode(response.body);
      var message = data['message'];
      return message;
    }
  }

  // a function for removing a selected user to the followeing of the logged in user
  Future unfollow(String id) async {
    var response = await http.delete(
        Uri.parse(
            'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/follow/$id'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var success = data['success'];
      return success;
    } else {
      var data = jsonDecode(response.body);
      var message = data['message'];
      return message;
    }
  }

  // a function for creating a new post
  Future<Post> newPost(String text, bool public) async {
    var response = await http.post(
      // call POST request
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{'text': text, 'public': public}),
    );
    return Post.fromJson(jsonDecode(response.body));
  }

  // a function for updating a post of the logged in user
  Future<Post> updatePost(String id, String text, bool public) async {
    var response = await http.put(
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{'text': text, 'public': public}),
    );
    return Post.fromJson(jsonDecode(response.body));
  }

  // a function for deleting a post of the logged in user
  Future deletePost(String id) async {
    var response = await http.delete(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var success = data['success'];
      return success;
    } else {
      // If the server did not return a 200 response,
      // then throw an exception.
      throw Exception("Unable to delete post.");
    }
  }

  // a function for getting a single post
  Future<Post> getSinglePost(String id) async {
    final response = await http.get(
        Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Post.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception("Unable to fetch post.");
    }
  }

  // a function for getting all the comments
  Future<Comments> getComments(String postId) async {
    final response = await http // call GET request
        .get(
            Uri.parse(
                'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/comment/$postId'),
            headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Comments.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception("Unable to get comments.");
    }
  }

  // a function for adding a new comment
  Future<Comment> newComment(String postId, String text) async {
    var response = await http.post(
      // call POST request
      Uri.parse(
          'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/comment/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{'text': text}),
    );
    return Comment.fromJson(jsonDecode(response.body));
  }

// a function for removing a comment
  Future deleteComment(String postId, String id) async {
    var response = await http.delete(
        Uri.parse(
            'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/comment/$postId/$id'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var success = data['success'];
      return success;
    } else {
      // If the server did not return a 200 response,
      // then throw an exception.
      throw Exception("Unable to delete post.");
    }
  }
}
