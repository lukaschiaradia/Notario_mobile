class UtilisateurModif {
  UtilisateurModif({
    required this.LastName,
    required this.age,
    required this.email,
    required this.firstName,
    required this.password,
  });

  String email;
  String password;
  String firstName;
  String LastName;
  String age;

  Map<String, dynamic> toData() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'LastName': LastName,
      'age': age,
    };
  }
}