import 'package:flutter/material.dart';


class CardModel {
  String caregiver;
  int cardBackground;
  var cardIcon;

  CardModel(this.caregiver, this.cardBackground, this.cardIcon);
}

List<CardModel> cards = [
  CardModel("护理员", 0xFFec407a, Icons.people_outline),
  CardModel("护士", 0xFF5c6bc0, Icons.local_hospital),
  CardModel("康复护理员", 0xFFfbc02d, Icons.accessibility_new),
  CardModel("居家护工", 0xFF1565C0, Icons.home_work),
  CardModel("手术室护工", 0xFF2E7D32, Icons.local_hospital_outlined),
  CardModel("老年护理员", 0xfffd7468, Icons.person_outline),
];
