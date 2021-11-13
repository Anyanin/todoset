import 'package:flutter/material.dart';

class TopObject extends StatelessWidget {
  const TopObject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TopRectangle(
          positionRight: 20,
          positionTop: -10,
          width: size.shortestSide / 1.5,
          height: 30,
          color: 0xFFD68FB0,
          shape: BoxShape.rectangle,
        ),
        TopRectangle(
          positionRight: 20,
          positionTop: 10,
          width: size.shortestSide / 1.8,
          height: 20,
          color: 0xFFB4F8C8,
          shape: BoxShape.rectangle,
        ),
        Positioned(
          top: -40,
          right: 0,
          child: Container(
            height: size.shortestSide / 5,
            width: size.shortestSide / 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFAEBC),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TopRectangle extends StatelessWidget {
  const TopRectangle({
    Key? key,
    required this.positionRight,
    required this.positionTop,
    required this.width,
    required this.height,
    required this.color,
    required this.shape,
  }) : super(key: key);

  final double positionRight;
  final double positionTop;
  final double width;
  final double height;
  final int color;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: positionRight,
      top: positionTop,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            shape: shape,
            color: Color(color),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(300),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ]),
      ),
    );
  }
}

Widget textFieldItem(
    {required String label,
    required bool obscure,
    required TextInputType inputType,
    required TextEditingController controller,
    required BuildContext context}) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        TextFormField(
          style: Theme.of(context).textTheme.bodyText2,
          controller: controller,
          obscureText: obscure,
          keyboardType: inputType,
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ),
  );
}

Widget tagButton({required BuildContext context,required onTap, required String label, required String selectedTag}) {
  return InkWell(
    onTap: onTap,
    child: Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      padding: const EdgeInsets.all(10),
      backgroundColor:
      selectedTag == label ? const Color(0xFFFFD898) : Colors.white,
    ),
  );
}
