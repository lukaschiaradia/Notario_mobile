class UtilisateurAskRdv {
  UtilisateurAskRdv({
    required this.available_dates,
    required this.reason,
  });

  String available_dates;
  String reason;

  Map<String, dynamic> toData() {
    return {

      'available_dates': available_dates,
      'reason': reason,
    };
  }
}