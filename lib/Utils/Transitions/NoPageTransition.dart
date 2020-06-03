import 'package:flutter/material.dart';

/// Use instead of MaterialPageRoute if you want to have a different animation when changing page.
// class NoPageTransition<T> extends MaterialPageRoute<T> {
//   NoPageTransition({ WidgetBuilder builder, RouteSettings settings })
//       : super(builder: builder, settings: settings);

//   @override
//   Widget buildTransitions(BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       Widget child) {
//     if (settings.isInitialRoute) return child;
//     return  child;
//   }
// }