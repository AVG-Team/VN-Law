class NotificationDataModel {
  final String? image;
  final String? body;
  final String? title;
  final String? type;
  final String? id;
  final String? url;

  NotificationDataModel(
      {this.image, this.body, this.title, this.type, this.id, this.url});

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
        image: json['image'],
        body: json['body'],
        title: json['title'],
        type: json['type'],
        id: json['id'],
        url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'body': body,
      'title': title,
      'type': type,
      'id': id,
      'url': url,
    };
  }
}
