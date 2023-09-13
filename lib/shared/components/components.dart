import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../style/icon_broken.dart';

Widget defaultButton({
  required String title,
  required Function()? onPressed,
  Color background = Colors.blue,
  double width = double.infinity,
  double height = 50.0,
  bool isUpperCase = true,
  double radius = 3.0,
  Function? onSuffixPressed,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        padding: const EdgeInsets.all(10.0),
        color: background,
        onPressed: onPressed,
        child: Text(
          isUpperCase ? title.toUpperCase() : title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w100,
            fontSize: 16.0,
          ),
        ),
      ),
    );

Widget defaultTextButton({
  required String title,
  required void Function()? onPressed,
}) =>
    TextButton(onPressed: onPressed, child: Text(title));

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  required String? Function(String?)? validate,
  bool isPassword = false,
  IconData? suffix,
  Function()? onSuffixPressed,
  Function()? onTap,
  Function(String)? onChanged,
  void Function(String)? onSubmit,
}) =>
    TextFormField(
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      onTap: onTap,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        hintText: controller.text,
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: onSuffixPressed,
              )
            : null,
        border: const OutlineInputBorder(),
      ),
      validator: validate!,
    );

Widget myDivider() => Container(
      color: Colors.grey,
      width: double.infinity,
      height: 1.0,
      margin: const EdgeInsetsDirectional.only(start: 20.0),
    );

void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));

void navigateAndFinish(context, widget) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARING }

Color chooseToastColor(ToastStates state) {
  Color? color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;

    case ToastStates.ERROR:
      color = Colors.red;
      break;

    case ToastStates.WARING:
      color = Colors.amber;
      break;
  }
  return color;
}

void showToast(
    {required BuildContext context,
    required String message,
    required ToastStates state,
    IconData? icon}) {
  FToast fToast = FToast();

  TextSpan span = TextSpan(text: message);
  TextPainter tp = TextPainter(
    text: span,
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
  );
  tp.layout();

  fToast.init(context);
  Widget toast = ListTile(
    tileColor: chooseToastColor(state),
    leading: Icon(
      icon,
      size: 40.0,
    ),
    title: Text(
      message,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          overflow: TextOverflow.ellipsis),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: const Duration(seconds: 4),
    gravity: ToastGravity.BOTTOM,
  );
}

Future<bool> onWillPop() {
  // Do something before the user goes back.
  // For example, you can save the user's progress.
  return Future.value(false);
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          IconBroken.Arrow___Left_2,
        ),
      ),
      title: Text(title ?? ''),
      titleSpacing: 5.0,
      actions: actions,
    );
