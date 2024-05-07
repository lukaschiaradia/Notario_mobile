class UtilisateurModif {
  UtilisateurModif({
    required this.LastName,
    required this.age,
    required this.email,
    required this.firstName,
    required this.password,
    required this.phone,
  });

  String email;
  String password;
  String firstName;
  String LastName;
  String age;
  String phone;

  Map<String, dynamic> toData() {
    return {

      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': LastName,
      'phone': phone,
      'age': age,
    };
  }
}