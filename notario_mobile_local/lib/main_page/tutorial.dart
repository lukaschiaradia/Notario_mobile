import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:notario_mobile/main_page/profil_page.dart';

class TutorialScreen extends StatelessWidget {
  final List<Slide> slides = [
    Slide(
      title: "Tutoriel",
      description: "Bienvenue chez Notario ! Ici vous pourrez gérer vos documents, vos rendez-vous et plus encore.",
      pathImage: "images/notario.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Documents",
      description: "Pour consulter vos documents, accédez à la section 'Documents' depuis la NavBar. Vous pouvez visualiser ou télécharger vos fichiers importants.",
      pathImage: "images/tutorial/document.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Rendez-vous",
      description: "Pour voir vos rendez-vous, allez dans la section 'Rendez-vous'. Vous y trouverez un calendrier avec toutes vos prochaines rencontres ou ceux passés.",
      pathImage: "images/tutorial/rdv.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "FAQ",
      description: "Des questions? Consultez notre FAQ pour des réponses rapides. Vous la trouverez dans la section 'FAQ'.",
      pathImage: "images/tutorial/FAQ.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Profil",
      description: "Pour gérer votre profil, accédez à la section 'Profil'. Vous pouvez mettre à jour vos informations personnelles et vos préférences.",
      pathImage: "images/tutorial/profil.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Profil_2",
      description: "Depuis le menu déroulant en haut à droite du profil, vous pouvez vous lier/dissocier d'un notaire, modifier vos infos et bien plus encore !",
      pathImage: "images/tutorial/menuderoulant.png",
      backgroundColor: Color(0xFF351EA4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      onDonePress: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Profil()),
        );
      },
      colorDot: Colors.black,
      colorActiveDot: Colors.black,
      sizeDot: 13.0,
      renderNextBtn: Text('Suivant', style: TextStyle(color: Colors.white)),
      renderDoneBtn: Text('Terminer', style: TextStyle(color: Colors.white)),
      renderPrevBtn: Text('Précédent', style: TextStyle(color: Colors.white)),
      renderSkipBtn: Text('Passer', style: TextStyle(color: Colors.white)),
    );
  }
}