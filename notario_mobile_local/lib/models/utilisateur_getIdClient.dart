class UtilisateurGetIdClient {
  UtilisateurGetIdClient({

    required this.tokenUser,
  });

  String tokenUser;


  Map<String, dynamic> toData() {
    return {
      'token': tokenUser,
    };
  }
}