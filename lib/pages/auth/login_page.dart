import 'package:erbe/list/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:erbe/utils/customColors.dart';
import 'package:erbe/utils/customTextStyle.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String topImage = "assets/images/wave.png";
    return Scaffold(
      body: appBody(height, topImage),
    );
  }

  SingleChildScrollView appBody(double height, String topImage) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topImageContainer(height, topImage),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(),
                    customSizedBox(),
                    emailTextField(),
                    customSizedBox(),
                    passwordTextField(),
                    customSizedBox(),
                    /* forgotPasswordButton(), */
                    customSizedBox(),
                    signInButton(),
                    customSizedBox(),
                    /* signUpButton() */
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Text titleText() {
    return const Text(
      "Merhaba,\nHoş Geldiniz",
      style: CustomTextStyle.titleTextStyle,
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
        return null;
      },
      onSaved: (value) {
        email = value!;
      },
      style: const TextStyle(color: Colors.white),
      decoration: customInputDecoration("Email"),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
        return null;
      },
      onSaved: (value) {
        password = value!;
      },
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: customInputDecoration("Şifre"),
    );
  }

  /* Center forgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: customText(
          "Sifremi Unuttum",
          CustomColors.textButtonColor,
        ),
      ),
    );
  } */

  Center signInButton() {
    return Center(
      child: TextButton(
        onPressed: signIn,
        child: Container(
          height: 50,
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: CustomColors.loginButtonColor),
          child: Center(
            child: customText("Giriş Yap", CustomColors.loginButtonTextColor),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      try {
        final userResult = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        // ignore: use_build_context_synchronously
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  MyApp()),
        );
        print(userResult.user!.uid);
      } catch (e) {
        print(e.toString());
      }
    } else {}
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/signUp"),
        child: customText(
          "Yeni Firma",
          CustomColors.textButtonColor,
        ),
      ),
    );
  }

  Container topImageContainer(double height, String topImage) {
    return Container(
      height: height * .25,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(topImage),
        ),
      ),
    );
  }

  Widget customSizedBox() => const SizedBox(
        height: 20,
      );

  Widget customText(String text, Color color) => Text(
        text,
        style: TextStyle(color: color),
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}
