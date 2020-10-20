class User {
  String firstName;
  String lastName;
  String nickName;
  String email;
  String password;

  User({this.firstName, this.lastName, this.nickName, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        firstName: json['firstName'],
        lastName: json['lastName'],
        nickName: json['nickName'],
        email: json['email'],
        password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'nickName': nickName,
    'email': email,
    'password' : password,
  };
}