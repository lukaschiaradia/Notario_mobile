import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:notario_mobile/main_page/profil_page.dart';

class TutorialScreen extends StatelessWidget {
  final List<Slide> slides = [
    Slide(
      title: "Tutoriel",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bienvenue sur l'application mobile de Notario ! Ici vous pourrez gérer vos documents, vos rendez-vous et plus encore.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      pathImage: "images/notario.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Barre de navigation",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
             "Naviguez entre les différentes sections de l'application grâce à la barre de navigation en bas de l'écran.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      pathImage: "images/tutorial/navbar.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Documents",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Pour consulter vos documents, accédez à la section 'Documents' depuis la barre de navigation. Vous pouvez visualiser ou télécharger vos fichiers importants.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      pathImage: "images/tutorial/document.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Documents",
      widgetDescription: Column(
        children: [
          Image.asset(
            "images/tutorial/document2.png",
            width: 425.0,
            height: 425.0,
          ),
        ],
      ),
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Rendez-vous",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Pour voir vos rendez-vous, allez dans la section 'Rendez-vous'. Vous y trouverez un calendrier avec toutes vos prochaines rencontres ou ceux passés.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      pathImage: "images/tutorial/rdv.png",
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "FAQ",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/tutorial/faq.png",
            width: 400.0,
            height: 400.0,
          ),
          Text(
            "Des questions? Consultez notre FAQ pour des réponses rapides. Vous la trouverez dans la section 'FAQ'.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "FAQ",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/tutorial/faq2.png",
            width: 400.0,
            height: 400.0,
          ),
          Text(
            "Vous pouvez également filtrer les questions par catégorie pour trouver plus facilement ce que vous cherchez.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Profil",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/tutorial/profil.png",
            width: 400.0,
            height: 400.0,
          ),
          Text(
            "Pour consulter votre profil, accédez à la section 'Profil'.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Profil",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/tutorial/profil2.png",
            width: 400.0,
            height: 400.0,
          ),
          Text(
            "Depuis le menu déroulant vous pouvez vous lier/dissocier d'un notaire, modifier vos infos et bien plus encore !",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF351EA4),
    ),
    Slide(
      title: "Des retours/remarques ?",
      widgetDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/tutorial/question.png",
            width: 400.0,
            height: 400.0,
          ),
          Text(
            "N'hésitez pas à nous contacter si vous avez des retours ou des remarques sur l'application. Nous sommes à votre écoute !",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
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
      colorDot: Colors.grey,
      colorActiveDot: Colors.black,
      sizeDot: 8.0,
      renderNextBtn: Text('Suivant', style: TextStyle(color: Colors.white)),
      renderDoneBtn: Text('Terminer', style: TextStyle(color: Colors.white)),
      renderPrevBtn: Text('Précédent', style: TextStyle(color: Colors.white)),
      renderSkipBtn: Text('Passer', style: TextStyle(color: Colors.white)),
    );
  }
}

