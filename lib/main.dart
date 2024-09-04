import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter/src/painting/gradient.dart' as grad;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        fontFamily: "Montserrat",
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFD6E2EA),
        resizeToAvoidBottomInset: false,
        body: BearAnimationloginpage(),
      ),
    );
  }
}

class BearAnimationloginpage extends StatefulWidget {
  const BearAnimationloginpage({Key? key}) : super(key: key);

  @override
  BearAnimationloginpageState createState() => BearAnimationloginpageState();
}

class BearAnimationloginpageState extends State<BearAnimationloginpage> {
  SMIInput<bool>? _check;
  SMIInput<bool>? _handsUp;
  SMIInput<double>? _look;
  SMITrigger? _success;
  SMITrigger? _fail;
  String stateChangeMessage = '';
  Artboard? _riveArtboard;

  bool _formStatus = false;

  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    focusEmail.addListener(_onEmailFocusChange);
    focusPassword.addListener(_onPasswordFocusChange);
    rootBundle.load('assets/rive/teddy_login_screen.riv').then((data) async {
      final file = RiveFile.import(data);

      final artboard = file.mainArtboard;

      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
        onStateChange: _onStateChange,
      );

      if (controller != null) {
        artboard.addController(controller);
        _check = controller.findInput<bool>('Check');
        _look = controller.findInput<double>("Look");
        _handsUp = controller.findInput<bool>('hands_up');
        _success = controller.findInput<bool>("success") as SMITrigger;
        _fail = controller.findInput<bool>("fail") as SMITrigger;

        // _like = controller.findInput<bool>('Like') as SMIBool;
        // _like?.value = false;
      }
      setState(() {
        _riveArtboard = artboard;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusEmail.dispose();
    focusPassword.dispose();
  }

  void _onPasswordFocusChange() {
    debugPrint("Focuspassword: ${focusPassword.hasFocus}");
    _handsUp!.value = focusPassword.hasFocus;
  }

  void _onEmailFocusChange() {
    debugPrint("Focus email: ${focusEmail.hasFocus}");

    _check!.value = focusEmail.hasFocus;
  }

  void _onStateChange(String stateMachineName, String stateName) => setState(
        () => stateChangeMessage =
            'State Changed in $stateMachineName to $stateName',
      );

  @override
  Widget build(BuildContext context) {
    var mQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      reverse: true,
      child: Stack(
        children: [
          Container(
            height: mQuery.viewInsets.bottom == 0.0
                ? mQuery.size.height
                : mQuery.size.height + mQuery.viewInsets.bottom / 5,
          ),
          _riveArtboard == null
              ? const SizedBox(
                  height: 400,
                )
              : SizedBox(
                  height: 400,
                  child: Rive(
                    fit: BoxFit.contain,
                    artboard: _riveArtboard!,
                  ),
                ),
          Positioned(
            top: 350,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(
                  top: 28, left: 12, right: 12, bottom: 28),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      focusNode: focusEmail,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String value) {
                        _look!.value = value.length.toDouble() * 2;
                      },
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        } else if (value.length < 6) {
                          return 'a minimum of 3 characters is required';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        hintText: "User Name",
                        contentPadding: EdgeInsets.only(
                            left: 24, top: 20, bottom: 20, right: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      scrollPadding: const EdgeInsets.only(bottom: 32.0),
                      focusNode: focusPassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: "Password",
                        contentPadding: EdgeInsets.only(
                            left: 24, top: 20, bottom: 20, right: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "this field is required";
                        } else if (val.length < 6) {
                          return 'Password too short.';
                        }
                      },
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () {
                        // reset the bear animation according to focus
                        if (focusEmail.hasFocus) focusEmail.unfocus();
                        if (focusPassword.hasFocus) focusPassword.unfocus();

                        // trigger bear sucess ot failure animation
                        if (_formKey.currentState!.validate()) {
                          _success!.fire();
                          setState(() {
                            _formStatus = true;
                          });
                        } else {
                          _fail!.fire();
                          _formStatus = false;
                        }
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const grad.LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFAF32C5), Color(0xFFF45176)]),
                          boxShadow: [
                            // color: Colors.white, //background color of box
                            BoxShadow(
                              color: const Color(0xFFF45176).withOpacity(0.6),
                              blurRadius: 15.0, // soften the shadow
                              spreadRadius: 0.0, //extend the shadow
                              offset: const Offset(
                                0.0, // Move to right 10  horizontally
                                8.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: _formStatus
                              ? const CheckMark()
                              : const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CheckMark extends StatefulWidget {
  const CheckMark({Key? key}) : super(key: key);

  @override
  CheckMarkState createState() => CheckMarkState();
}

class CheckMarkState extends State<CheckMark> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation("show");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild");
    return SizedBox(
      height: 40,
      child: RiveAnimation.asset(
        "assets/rive/check_icon.riv",
        controllers: [_controller],
      ),
    );
  }
}
