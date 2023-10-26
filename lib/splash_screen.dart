import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_app_ad/app_open_ad_manager.dart';
import 'package:open_app_ad/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    super.initState();

    //Load AppOpen Ad
    appOpenAdManager.loadAd();

    //Show AppOpen Ad After 8 Seconds
    Future.delayed(const Duration(milliseconds: 900)).then((value) {
      //Here we will wait for 8 seconds to load our ad
      //After 8 second it will go to HomePage
      appOpenAdManager.showAdIfAvailable();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
