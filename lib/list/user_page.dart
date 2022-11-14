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
  late TextEditingController controllerName;
  late TextEditingController controllerNo;
  late TextEditingController controllerSu;
  late TextEditingController controllerElk;
  late TextEditingController controllerIsi;
  late TextEditingController controllerDate;

  @override
  void initState() {
    super.initState();

    controllerName = TextEditingController();
    controllerNo = TextEditingController();
    controllerSu = TextEditingController();
    controllerElk = TextEditingController();
    controllerIsi = TextEditingController();
    controllerDate = TextEditingController();

    if (widget.user != null) {
      final user = widget.user!;

      controllerName.text = user.name;
      controllerNo.text = user.daireNo.toString();
      controllerSu.text = user.daireSu.toString();
      controllerElk.text = user.daireElk.toString();
      controllerIsi.text = user.daireIsi.toString();
      controllerDate.text = DateFormat('yyyy-MM-dd').format(user.tarih);
    }
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerNo.dispose();
    controllerSu.dispose();
    controllerElk.dispose();
    controllerIsi.dispose();
    controllerDate.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? controllerName.text : 'Daire Ekle'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteUser(widget.user!);

                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    '${controllerNo.text} to Firebase!',
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
              controller: controllerName,
              decoration: decoration('İsim'),
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: controllerNo,
              decoration: decoration('Daire No'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: controllerSu,
              decoration: decoration('Su'),
              keyboardType: TextInputType.number,
              validator: (text) => text != null && int.tryParse(text) == null
                  ? 'Geçersiz değer'
                  : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: controllerElk,
              decoration: decoration('Elektrik'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: controllerIsi,
              decoration: decoration('Isı'),
              keyboardType: TextInputType.number,
              validator: (text) =>
                  text != null && text.isEmpty ? 'Geçersiz değer' : null,
            ),
            const SizedBox(height: 24),
            DateTimeField(
              initialValue: widget.user?.tarih,
              controller: controllerDate,
              decoration: decoration('Tarih'),
              validator: (dateTime) =>
                  dateTime == null ? 'Geçersiz Tarih' : null,
              format: DateFormat('yyyy-MM-dd'),
              onShowPicker: (context, currentValue) => showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                initialDate: currentValue ?? DateTime.now(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Text(isEditing ? 'Güncelle' : 'Oluştur'),
              onPressed: () {
                final isValid = formKey.currentState!.validate();

                if (isValid) {
                  final user = User(
                    id: widget.user?.id ?? '',
                    name: controllerName.text,
                    daireNo: int.parse(controllerNo.text),
                    daireSu: int.parse(controllerSu.text),
                    daireElk: int.parse(controllerElk.text),
                    daireIsi: int.parse(controllerIsi.text),
                    tarih: DateTime.parse(controllerDate.text),
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
                      'Daire ${controllerNo.text} Başarıyla $action.',
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
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }

  Future updateUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('daire').doc(user.id);

    final json = user.toJson();
    await docUser.update(json);
  }

  Future deleteUser(User user) async {
    /// Reference to document
    final docUser = FirebaseFirestore.instance.collection('daire').doc(user.id);

    await docUser.delete();
  }
}
