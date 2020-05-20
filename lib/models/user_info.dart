class UsersInfo {
  String username;
  String bio;
  String name;
  String email;
  String phone;
  String gender;
  String propic;


  UsersInfo(
      this.username,
      this.name,
      this.email,
      this.phone,
      this.gender, {
        this.bio, this.propic
      }
      );

  Map<String, dynamic> toJson() => {
    'username': username,
    'name': name,
    'email': email,
    'phone': phone,
    'gender':gender,
    'bio': "",
    'propic': "Users/defpropic.png"
  };
}