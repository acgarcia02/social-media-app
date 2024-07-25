// model for a single comment

class Comment {
  bool? success;
  Data? data;
  String? message;

  Comment({this.success, this.data, this.message});

  Comment.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? id;
  String? text;
  String? postId;
  String? username;
  int? date;

  Data({this.id, this.text, this.postId, this.username, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    postId = json['postId'];
    username = json['username'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['text'] = text;
    data['postId'] = postId;
    data['username'] = username;
    data['date'] = date;
    return data;
  }
}
