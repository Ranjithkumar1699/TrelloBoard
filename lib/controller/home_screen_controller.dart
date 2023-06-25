import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  //region Private Members
  var mainList = [].obs;
  var showButton = false.obs;
//endregion
  
  @override
  void onInit() {
    super.onInit();
  }

  // for add the parent card.
  addCard() {
    mainList.value.add(ParentList(TextEditingController(), [].obs));
    mainList.refresh();
  }
}

class ParentList {
  TextEditingController? title;
  var child = [].obs;

  ParentList(this.title, this.child);
}
