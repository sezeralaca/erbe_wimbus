import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erbe/widgets/fab_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:erbe/list/user.dart';
import 'package:erbe/list/user_page.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              textStyle: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        home: const MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Test Apartmanı'),
          titleTextStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 25),
          centerTitle: true,

        ),
        body: buildUsers(),
        // body: buildSingleUser(),
        floatingActionButton: CircularFabWidget(),

      );

  Widget buildUsers() => StreamBuilder<List<User>>(
    
      stream: readUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}. Lütfen bu hata için uygulama sağlayıcınızla iletişime geçin.');
        } else if (snapshot.hasData) {
          final users = snapshot.data!;

          return ListView(
            children: users.map(buildUser).toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      });

  Widget buildSingleUser() => FutureBuilder<User?>(
        future: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;

            return user == null
                ? const Center(child: Text('Kullanıcı Yok'))
                : buildUser(user);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );

  Widget buildUser(User user) => ListTile(
        
        leading: CircleAvatar(child: Text('${user.daireNo}',), radius: 25,),
        title: Text(user.adSoyad),
        subtitle: Text(user.telefon.toString(),),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserPage(user: user),
        )),
      );
      

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('daire')
      .orderBy('daireNo',descending: false)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Future<User?> readUser() async {
    /// Get single document by ID
    final docUser = FirebaseFirestore.instance.collection('daire').doc();
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return User.fromJson(snapshot.data()!);
    }
    return null;
  }

  Future createUser({required String adSoyad}) async {
    /// Reference to document
    final docUser = FirebaseFirestore.instance.collection('daire').doc();

    final json = {

      'adSoyad': adSoyad,
      'age': 21,
      'birthday': DateTime(01, 08, 2000),
    };

    /// Create document and write data to Firebase
    await docUser.set(json);
  }
}

/// Example from YouTube Video

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Firebase CRUD Update';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 24),
              minimumSize: Size.fromHeight(64),
            ),
          ),
        ),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(32),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Update'),
                onPressed: () {
                  final docUser = FirebaseFirestore.instance
                      .collection('daire')
                      .doc('my-id');

                  // Update specific fields
                  docUser.update({
                    'adSoyad': 'James',
                  });

                  // Update nested fields
                  docUser.update({
                    'city.adSoyad': 'London',
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: Text('Delete'),
                onPressed: () {
                  final docUser = FirebaseFirestore.instance
                      .collection('daire')
                      .doc('my-id');

                  docUser.delete();
                },
              ),
            ],
          ),
        ),
      );
}
*/