class UtilisateurDelete {
  UtilisateurDelete({

    required this.tokenMobile,
  });

  String tokenMobile;


  Map<String, dynamic> toData() {
    return {
      'token': tokenMobile,
    };
  }
}
