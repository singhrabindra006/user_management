import 'package:currency_conveter/pages/currency_conveter_material_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
//Types of widgets

//1. Stateless widgets
//2. Stateful widgets

// State
/* 1. Material Design for Android   
----exampl-import 'package:flutter/material.dart';*/
/* 2. Cupertion Design for IOS   
 ----examp-import 'package:flutter/cupertino.dart';*/
//these two both pacakge comes under the fultter skd
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    /*here we can use i.e return MaterialApp or CupertionAPP if we want to build
     iso used cupertion design and for android used material design*/
    return const MaterialApp(home: CurrencyConveterMaterialPage());
  }
}
