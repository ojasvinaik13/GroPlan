import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard(
      {@required this.titleText, this.onClick, @required this.imgname});

  final Widget titleText;
  final Function onClick;
  final String imgname;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imgname),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: titleText,
        ),
        margin: EdgeInsets.all(15.0),
      ),
    );
  }
}
