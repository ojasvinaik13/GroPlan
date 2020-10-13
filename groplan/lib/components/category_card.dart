import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({this.titleText, this.onClick, @required this.imgname});

  final Widget titleText;
  final Function onClick;
  final String imgname;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(imgname),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(15.0),
            child: titleText,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          )
        ],
      ),
    );
  }
}
