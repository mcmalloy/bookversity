import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/Constants/custom_textstyle.dart';
import 'file:///C:/Users/Mark/StudioProjects/bookversity/lib/Pages/Books/set_book_for_sale_page.dart';
import 'package:bookversity/TabPages/profile_dashboard.dart';
import 'package:bookversity/Widgets/shapes.dart';
import 'package:flutter/material.dart';

class EmptyBookList extends StatelessWidget {
  CustomShapes _shapes = CustomShapes();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 4,
              left: 15,
              right: 15,
              bottom: 15),
          child: CustomTextStyle(
              "Øv... Du har på nuværende tidspunkt ingen bøger til salg. "
              "For at komme igang med at sælge din bog, tryk på 'Sælg nu'",
              18,
              CustomColors.materialYellow),
        ),
        SizedBox(
          height: 95,
        ),
        AnimatedContainer(
          width: 200,
          height: 50,
          duration: Duration(milliseconds: 1200),
          curve: Curves.fastOutSlowIn,
          child: RaisedButton(
            shape: _shapes.customButtonShape(),
            color: CustomColors.materialYellow,
            child: Center(
                child: CustomTextStyle(
                    "Opret Annonce", 18, CustomColors.materialDarkGreen)),
            onPressed: () {

            },
          ),
        ),
      ],
    );
  }
}
