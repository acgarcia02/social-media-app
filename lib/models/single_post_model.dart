// model for a single post

class Post {
  bool? success;
  Data? data;
  String? message;

  Post({this.success, this.data, this.message});

  Post.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
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
  String? username;
  bool? public;

  Data({
    this.id,
    this.text,
    this.username,
    this.public,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    username = json['username'];
    public = json['public'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['text'] = text;
    data['username'] = username;
    data['public'] = public;
    return data;
  }
}
