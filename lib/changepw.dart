import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'logging_in/user_logging_in.dart';

class change extends StatefulWidget {
  final email;

  change({Key? mykey, this.email}) : super(key: mykey);

  @override
  State<change> createState() => _changeState();
}

class _changeState extends State<change> {
  final oldpwcontroller = TextEditingController();
  var newpwcontroller = TextEditingController();

  var auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  changepw({email, oldpassword, newpassword}) async {
    var cred =
        EmailAuthProvider.credential(email: email, password: oldpassword);
    await currentUser!
        .reauthenticateWithCredential(cred)
        .then((value) => {currentUser!.updatePassword(newpassword)})
        .catchError((error) {
      final snackBar = SnackBar(
        content: Container(
          width: 150,
          height: 50,
          child: Center(
            child: Text(
              'Wrong Password',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
        action: SnackBarAction(
          label: 'Try Again',
          onPressed: () {
            oldpwcontroller.clear();
            newpwcontroller.clear();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: "old password: ",
              hintText: "enter old password: ",
              labelStyle: TextStyle(fontSize: 20.0),
              border: OutlineInputBorder(),
              errorStyle: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            controller: oldpwcontroller,
          ),
          SizedBox(height: 10,),
          TextFormField(
            decoration: InputDecoration(
              labelText: "new password: ",
              hintText: "enter new password: ",
              labelStyle: TextStyle(fontSize: 20.0),
              border: OutlineInputBorder(),
              errorStyle: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            controller: newpwcontroller,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            onPressed: () {
              setState(() {
                changepw(
                  email: widget.email,
                  oldpassword: oldpwcontroller.text,
                  newpassword: newpwcontroller.text,
                ).then((_) {
                  final snackBar = SnackBar(
                    content: Container(
                      width: 150,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Şifre değiştirildi.',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    action: SnackBarAction(
                      label: 'GİRİŞ YAP',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KullaniciGiris(),
                        ));
                      },
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              });
            },
            child: Text('Approve'),
          ),
        ],
      ),
    );
  }
}
