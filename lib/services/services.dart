import 'package:chatgpt_app/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> showBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(
                child: TextWidget(
                  label: 'Choose Model:',
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 2,
                child: ModelsDrowDownWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
