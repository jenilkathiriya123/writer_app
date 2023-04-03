import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Helper/firebase_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailc = TextEditingController();
  TextEditingController passc = TextEditingController();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Flutter App"),
        centerTitle: true,
        toolbarHeight: 130,
        leading: Container(),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.orange,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(
                      'https://firebase.google.com/static/images/brand-guidelines/logo-logomark.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailc,
                  onSaved: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter email first...";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    hintText: "Enter Email",
                    prefixIcon: Icon(Icons.email),
                    label: Text("Email"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: passc,
                  onSaved: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter Password first...";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    hintText: "Enter Password",
                    prefixIcon: Icon(Icons.lock),
                    label: Text("Password"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        Map<String, dynamic> res = await FirebaseHelper
                            .firebaseHelper
                            .signUp(email: email!, password: password!);
                        if (res['user'] != null) {
                          Navigator.of(context).pushNamed('/');
                        } else if (res['error']) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(res['error']),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating));
                        }
                      }
                    },
                    child: Text("SignUp"),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: Offset(1, 1)),
                      ],
                    ),
                    height: 50,
                    width: 120,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/google.jpg',
                            height: 25,
                            fit: BoxFit.fill,
                          ),
                          onTap: () async {
                            await FirebaseHelper.firebaseHelper
                                .signInWithGoogle();
                            SharedPreferences prfs =
                                await SharedPreferences.getInstance();
                            prfs.setBool('isLogged', true);
                            Navigator.of(context).pushNamed('/');
                          },
                        ),
                        const Text(
                          "Google",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset: Offset(1, 1)),
                        ],
                      ),
                      height: 50,
                      width: 120,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                await FirebaseHelper.firebaseHelper.guest();
                                SharedPreferences prfs =
                                    await SharedPreferences.getInstance();
                                prfs.setBool('isLogged', true);
                                Navigator.of(context).pushNamed('/');
                              },
                              child: Icon(Icons.person)),
                          const Text(
                            "Guest",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Create new",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
