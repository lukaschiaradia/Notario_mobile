class UtilisateurDelete {
  UtilisateurDelete({
  required this.idClient,
  });

  String idClient;


  Map<String, dynamic> toData() {
    return {
      'token': idClient,
    };
  }
}
