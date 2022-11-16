import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:erbe/list/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  final User? user;

  const UserPage({Key? key, this.user}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController controllerdaireNo;
  late TextEditingController controllerAdSoyad;
  late TextEditingController controllerTelefon;
  late TextEditingController controllerProtokol;
  late TextEditingController controllersayacTipi;
  late TextEditingController controllerSayacNo;
  late TextEditingController controllersonOkumaTarih;
  late TextEditingController controllerSonEndeks;

  @override
  void initState() {
    super.initState();

    controllerdaireNo = TextEditingController();
    controllerAdSoyad = TextEditingController();
    controllerTelefon = TextEditingController();
    controllerProtokol = TextEditingController();
    controllersayacTipi = TextEditingController();
    controllerSayacNo = TextEditingController();
    controllersonOkumaTarih = TextEditingController();
    controllerSonEndeks = TextEditingController();

    if (widget.user != null) {
      final user = widget.user!;

      controllerdaireNo.text = user.daireNo.toString();
      controllerAdSoyad.text = user.adSoyad;
      controllerTelefon.text = user.telefon.toString();
      controllerProtokol.text = user.protokol.toString();
      controllersayacTipi.text = user.sayacTipi.toString();
      controllerSayacNo.text = user.sayacNo.toString();
      controllersonOkumaTarih.text = user.sonOkumaTarih.toString();
      controllerSonEndeks.text = user.sonEndeks.toString();
    }
  }

  @override
  void dispose() {

    controllerdaireNo.dispose();
    controllerAdSoyad.dispose();
    controllerTelefon.dispose();
    controllerProtokol.dispose();
    controllersayacTipi.dispose();
    controllerSayacNo.dispose();
    controllersonOkumaTarih.dispose();
    controllerSonEndeks.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? controllerAdSoyad.text : 'daireNo Ekle'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteUser(widget.user!);

                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    '${controllerdaireNo.text} Silindi',
                    style: const TextStyle(fontSize: 24),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
             TextFormField(
              controller: controllerdaireNo,
              decoration: decoration('daireNo No'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: controllerAdSoyad,
              decoration: decoration('Ad Soyad'),
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),
           
            TextFormField(
              controller: controllerTelefon,
              decoration: decoration('Telefon'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: controllerProtokol,
              decoration: decoration('Protokol'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: controllersayacTipi,
              decoration: decoration('Sayaç Tipi'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: controllerSayacNo,
              decoration: decoration('Sayaç No'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: controllersonOkumaTarih,
              decoration: decoration('Tarih'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: controllerSonEndeks,
              decoration: decoration('Son Endeks'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              child: Text(isEditing ? 'Güncelle' : 'Oluştur'),
              onPressed: () {
                final isValid = formKey.currentState!.validate();

                if (isValid) {
                  final user = User(
                    daireNo: int.parse(controllerdaireNo.text),
                    //daireNo: controllerdaireNo.text,
                    adSoyad: controllerAdSoyad.text,
                    telefon: controllerTelefon.text,
                    protokol: int.parse(controllerProtokol.text),
                    sayacTipi: int.parse(controllersayacTipi.text),
                    sayacNo: controllerSayacNo.text,
                    sonOkumaTarih: controllersonOkumaTarih.text,
                    sonEndeks: int.parse(controllerSonEndeks.text),
                  );

                  if (isEditing) {
                    updateUser(user);
                  } else {
                    createUser(user);
                  }

                  final action = isEditing ? 'Güncellendi' : 'Eklendi';
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'daireNo ${controllerdaireNo.text} Başarıyla $action.',
                      style: const TextStyle(fontSize: 24),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  Future createUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('daire').doc();

    final json = user.toJson();
    await docUser.set(json);
  }

  Future updateUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('daire').doc(user.adSoyad);

    final json = user.toJson();
    await docUser.update(json);
  }

  Future deleteUser(User user) async {
    /// Reference to document
    final docUser = FirebaseFirestore.instance.collection('daire').doc(user.adSoyad);

    await docUser.delete();
  }
}
