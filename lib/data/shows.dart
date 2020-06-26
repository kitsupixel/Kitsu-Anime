import 'package:flutter/foundation.dart';

import '../models/show.dart';

class Shows extends ChangeNotifier {
  List<Show> _shows;

  List<Show> get shows {
    return [..._shows];
  }

  Shows() {
    _shows = [
      Show(
        id: 1,
        title: "100% Pascal-sensei",
        synopsis:
            "The story centers around an elementary school teacher who is so stupid that he cannot even write his own name. He does whatever he likes in his classroom. Plus, by all appearances, he is not human.",
        thumbnail:
            "https://kpplus.kitsupixel.pt/storage/shows/JWFIYYdPHgPmK3mDodQ713uwxuUEzglgHteMky5i.jpeg",
        season: "Spring",
        year: 2017,
        ongoing: false,
        active: true,
      ),
      Show(
          id: 2,
          title: "18if",
          synopsis:
              "Part of a multi-media project that also includes a mobile game and a virtual reality game.",
          thumbnail:
              "https://horriblesubs.info/wp-content/uploads/2017/07/18if.jpg",
          season: "Summer",
          year: 2017,
          ongoing: false,
          active: true),
      Show(
        id: 762,
        title: "22/7 (Nanabun no Nijyuuni)",
        synopsis:
            "One day, Takigawa Miu suddenly receives a letter notifying her that she has been chosen as a member of a brand-new project. Half in disbelief, she heads over to the location stated on the letter. There, she finds seven other girls summoned there in the same fashion. The girls behold a giant, top-secret facility. They stand in bewilderment as they are told: \"You are going to debut for a major record label as an idol group.\"\r\nA new kind of idol, never-before-seen, is about to be born here...\r\n\r\nSource: Official website",
        thumbnail:
            "https://kpplus.kitsupixel.pt/storage/shows/pJQycdz1DtyJBYGowKR8I0UVc9GH4raBCXiQXDxW.jpeg",
        season: "Winter",
        year: 2020,
        ongoing: false,
        active: true,
      ),
      Show(
        id: 3,
        title: "3-gatsu no Lion",
        synopsis: "Rei Kiriyama is a 17-yea…anks begin to stagnate.",
        thumbnail:
            "https://horriblesubs.info/wp-content/uploads/2016/10/3gatsunolion.jpg",
        season: "Fall",
        year: 2016,
        ongoing: false,
        active: true,
      ),
      Show(
        id: 8,
        title: "A3! Season Spring & Summer",
        synopsis:
            "Mankai Company is a far cry from its glory days as an all-male theater. With only one member left and debt collectors at the door, it’s no wonder Izumi Tachibana finds herself in over her head when she boldly confronts the Yakuza’s loan sharks, promising to bring her father’s theater back into the spotlight. She might be able to recruit enough talent, but can they bloom into the actors she needs?",
        thumbnail:
            "https://kpplus.kitsupixel.pt/storage/shows/HeZVd4MF5OZXc4szZ3ebPqHdyLfsSkcmfIxygovu.jpeg",
        season: "Winter",
        year: 2020,
        ongoing: true,
        active: true,
      ),
    ];
  }
}
