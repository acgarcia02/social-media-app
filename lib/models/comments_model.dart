//model for comments

class Comments {
  bool? success;
  List<Data>? data;

  Comments({this.success, this.data});

  Comments.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//defines data of each comment that will be stored
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['text'] = text;
    data['postId'] = postId;
    data['username'] = username;
    data['date'] = date;
    return data;
  }
}
