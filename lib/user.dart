class UserModel {
  final String email;
  final String userId;
  final String date;
  final String fName;
  final String lName;
  final String state;
  final String username;
  final String type;
  UserModel({
    required this.email,
    required this.userId,
    required this.date,
    required this.fName,
    required this.lName,
    required this.state,
    required this.username,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'Email': email});
    result.addAll({'NID': userId});
    result.addAll({'doc': date});
    result.addAll({'fname': fName});
    result.addAll({'lname': lName});
    result.addAll({'state': state});
    result.addAll({'username': username});
    result.addAll({'type': type});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['Email'] ?? '',
      userId: map['NID'] ?? '',
      date: map['doc'] ?? '',
      fName: map['fname'] ?? '',
      lName: map['lname'] ?? '',
      state: map['state'] ?? '',
      username: map['username'] ?? '',
      type: map['type'] ?? '',
    );
  }
}
