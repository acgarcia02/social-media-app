//model for the posts

class Posts {
  bool? success;
  List<Data>? data;
  String? message;

  Posts({this.success, this.data, this.message});

  Posts.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

  Data({this.id, this.text, this.username, this.public});

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
