import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:v_mate_project/screen/homeScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String uid;
  bool isLogin = false;
  bool otpsend = false;
  bool loginScreen = true;
  String verificationid = '';
  bool eye = true;
  bool confirm = false;
  bool back = false;
  TextEditingController _phoneController =
      TextEditingController(); //helps to change text
  TextEditingController _otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _sendotp() async {
    await _auth.verifyPhoneNumber(
      timeout: Duration(seconds: 60),
      phoneNumber: _phoneController.text,
      verificationCompleted: (phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
        if (_auth.currentUser != null) {
          //check user is or not present
          setState(() {
            isLogin = true;
            uid = _auth.currentUser.uid;
          });
        } else {
          print("Failed to sign In");
        }
      },
      verificationFailed: (verificationFailed) {
        //it pass an exception "error"
        print(verificationFailed.message);
        setState(() {
          isLogin = false;
          otpsend = false;
          loginScreen = false;
        });
      },
      codeSent: (verificationId, [resendingTocken]) async {
        //verificationId is string and toKn is int
        setState(() {
          verificationid = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        setState(() {
          verificationid = verificationId;
          otpsend = true;
          loginScreen = true;
        });
      },
    );
    setState(() {
      otpsend = true;
    });
  }

  _otpConfirmation() async {
    //know that verificationid is nt mt
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationid, smsCode: _otpController.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential); //check
      if (FirebaseAuth.instance.signInWithCredential(credential) != null) {
        isLogin = true;
        uid = FirebaseAuth.instance.currentUser.uid;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      // confirm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loginScreen
        ? Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text(
                'Login Screen',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                          labelText: "Enter your Phone_No",
                          hintText: "Mobile no",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: _sendotp,
                      color: Colors.black,
                      child: Text(
                        "Generate OTP",
                        style: TextStyle(fontSize: 25, color: Colors.blue[50]),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        maxLines: 1,
                        controller: _otpController,
                        obscureText: eye,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_open_rounded,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                eye = !eye;
                              });
                            },
                          ),
                          labelText: "OTP",
                          hintText: "OTP",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Did not get otp,',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Resend?',
                              recognizer: TapGestureRecognizer()
                                ..onTap = _sendotp,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),                    RichText(
                      text: TextSpan(
                        text: 'NEW user?,',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Sign Up',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    loginScreen = false;
                                  });
                                },
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        //TODO: OtpConfirmation
                        onPressed: _otpConfirmation,
                        color: Colors.black,
                        child: Text(
                          "Get Started",
                          style:
                              TextStyle(fontSize: 25, color: Colors.blue[50]),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        //-------------------------------------------------------------------------------------------------------------
        //SignUp Screen
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  loginScreen = true;
                });
              },
              backgroundColor: Colors.black,
              child: Text(
                "back",
                style: TextStyle(fontSize: 15, color: Colors.blue[50]),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            appBar: AppBar(
              title: Center(
                  child: Text(
                'SignUp Screen',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          labelText: "Enter your Name",
                          hintText: "Nirbhay Srivastava",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                          labelText: "Enter your Phone_No",
                          hintText: "Mobile no",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: _sendotp,
                      color: Colors.black,
                      child: Text(
                        "Generate OTP",
                        style: TextStyle(fontSize: 25, color: Colors.blue[50]),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        maxLines: 1,
                        controller: _otpController,
                        obscureText: eye,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_open_rounded,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                eye = !eye;
                              });
                            },
                          ),
                          labelText: "OTP",
                          hintText: "OTP",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Did not get otp,',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Resend?',
                              recognizer: TapGestureRecognizer()
                                ..onTap = _sendotp,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        //TODO: OtpConfirmation
                        onPressed: _otpConfirmation,
                        color: Colors.black,
                        child: Text(
                          "Get Started",
                          style:
                              TextStyle(fontSize: 25, color: Colors.blue[50]),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
