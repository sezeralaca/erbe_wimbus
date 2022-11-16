import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //final String daireNo;
  final int daireNo;
  final String adSoyad;
  final String telefon;
  final int protokol;
  final int sayacTipi;
  final String sayacNo;
  final String sonOkumaTarih;
  final int sonEndeks;

  User({
    required this.daireNo,
    required this.adSoyad,
    required this.telefon,
    required this.protokol,
    required this.sayacTipi,
    required this.sayacNo,
    required this.sonOkumaTarih,
    required this.sonEndeks
  });

  Map<String, dynamic> toJson() => {
        'daireNo': daireNo,
        'adSoyad': adSoyad,
        'telefon': telefon,
        'protokol': protokol,
        'sayacTipi': sayacTipi,
        'sayacNo': sayacNo,
        'sonOkumaTarih': sonOkumaTarih,
        'sonEndeks': sonEndeks
      };

  static User fromJson(Map<String, dynamic> json) => User(
        daireNo: json['daireNo'],
        adSoyad: json['adSoyad'],
        telefon: json['telefon'],
        protokol: json['protokol'],
        sayacTipi: json['sayacTipi'],
        sayacNo: json['sayacNo'],
        sonOkumaTarih: json['sonOkumaTarih'],
        sonEndeks: json['sonEndeks'],
      );
}
