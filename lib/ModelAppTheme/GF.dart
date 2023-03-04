// ignore_for_file: non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class GF {
  void ToastMessage(BuildContext context, String Title, Icon icon) {
    GFToast.showToast(
      Title,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
      backgroundColor: GFColors.DARK,
      toastDuration:  5,
      trailing: Icon(
        icon.icon,
        color: GFColors.SUCCESS,
      ),
    );
  }
  Future<void> loading() async {
    await EasyLoading.show(
      status: 'loading'.tr(),
      maskType: EasyLoadingMaskType.black,
    );
  }
  Future<void> dismissLoading() async {
    await EasyLoading.dismiss();
  }
}
