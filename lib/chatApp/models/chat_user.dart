class ChatUser {
  late String image;
  late String phone;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;

  ChatUser({
    required this.phone,
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      image: map['image'] ?? '',
      phone: map['phone'] ?? '',
      about: map['about'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['created_at'] ?? '',
      isOnline: map['is_online'] ?? false,
      id: map['id'] ?? '',
      lastActive: map['last_active'] ?? '',
      email: map['email'] ?? '',
      pushToken: map['push_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'about': about,
      'phone': phone,
      'name': name,
      'created_at': createdAt,
      'is_online': isOnline,
      'id': id,
      'last_active': lastActive,
      'email': email,
      'push_token': pushToken,
    };
  }
}
