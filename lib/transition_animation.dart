import 'package:flutter/material.dart';
class ScaleAnimationRoute extends PageRouteBuilder {
  final Page;
  ScaleAnimationRoute({this.Page})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => Page,
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, animationtwo, child) {
              var begin = 0.0;
              var end = 1.0;
              var curvesAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeIn);
              var tween = Tween(begin: begin, end: end);
              return ScaleTransition(
                  scale: tween.animate(curvesAnimation), child: child);
            });
}
class SlideLeftAnimationRoute extends PageRouteBuilder {
  final Page;
  SlideLeftAnimationRoute({this.Page})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => Page,
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, animationtwo, child) {
              var begin = const Offset(1.0 , 0.0);
              var end = const Offset(0.0 , 0.0);
              var curvesAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeIn);
              var tween = Tween(begin: begin, end: end);
              return SlideTransition(
                  position: tween.animate(curvesAnimation), child: child);
            });
}
class SlideRightAnimationRoute extends PageRouteBuilder {
  final Page;
  SlideRightAnimationRoute({this.Page})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => Page,
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, animationtwo, child) {
              var begin = const Offset(-1.0 , 0.0);
              var end = const Offset(0.0 , 0.0);
              var curvesAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeIn);
              var tween = Tween(begin: begin, end: end);
              return SlideTransition(
                  position: tween.animate(curvesAnimation), child: child);
            });
}
class SlideDownAnimationRoute extends PageRouteBuilder {
  final Page;
  SlideDownAnimationRoute({this.Page})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => Page,
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, animationtwo, child) {
              var begin = const Offset(0.0 , 1.0);
              var end = const Offset(0.0 , 0.0);
              var curvesAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeIn);
              var tween = Tween(begin: begin, end: end);
              return SlideTransition(
                  position: tween.animate(curvesAnimation), child: child);
            });
}
class SlideUpAnimationRoute extends PageRouteBuilder {
  final Page;
  SlideUpAnimationRoute({this.Page})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => Page,
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, animationtwo, child) {
              var begin = const Offset(0.0 , -1.0);
              var end = const Offset(0.0 , 0.0);
              var curvesAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeIn);
              var tween = Tween(begin: begin, end: end);
              return SlideTransition(
                  position: tween.animate(curvesAnimation), child: child);
            });
}
