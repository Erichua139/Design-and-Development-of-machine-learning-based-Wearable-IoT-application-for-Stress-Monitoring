import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'home.dart';
import 'package:untitled/home.dart';
import 'loading.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'dailydata.dart';
import 'tes.dart';


void main ()
async
{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/': (context) => Loading(),
      // '/home': (context) => Home(),
      '/home': (context) => MyApp(),
      // '/add' : (context) => Add_note(),
    },
  ));
}