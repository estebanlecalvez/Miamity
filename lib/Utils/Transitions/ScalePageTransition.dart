import 'package:flutter/material.dart';

class ScalePageTransition<T> extends MaterialPageRoute<T> {
  ScalePageTransition({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute) return child;
    return  ScaleTransition(scale: animation,child: child,);
  }
}