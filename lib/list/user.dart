import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  final String name;
  final int daireNo;
  final int daireSu;
  final int daireElk;
  final int daireIsi;

  final DateTime tarih;

  User({
    this.id = '',
    required this.name,
    required this.daireNo,
    required this.daireSu,
    required this.daireElk,
    required this.daireIsi,
    required this.tarih,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'daireNo': daireNo,
        'daireSu': daireSu,
        'daireElk': daireElk,
        'daireIsi': daireIsi,

        'tarih': tarih,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        daireNo: json['daireNo'],
        daireSu: json['daireSu'],
        daireElk: json['daireElk'],
        daireIsi: json['daireIsi'],
        tarih: (json['tarih'] as Timestamp).toDate(),
      );
}
