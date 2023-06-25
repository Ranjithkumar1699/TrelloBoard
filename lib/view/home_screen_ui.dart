import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trelloboard/controller/home_screen_controller.dart';
import 'package:trelloboard/support/constants.dart';
import '../Support/string.dart';
import '../support/colors.dart';
import '../widgets/trello_board_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final HomeScreenController controller = Get.put(HomeScreenController());

    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      controller.showButton.value = false;
    } else {
      controller.showButton.value = true;
    }
    return Scaffold(
      floatingActionButton:
      controller.showButton.value
          ? FloatingActionButton(
              backgroundColor: MyColors.kPrimaryColor,
              onPressed: () {
                controller.addCard();
              },
              child: Icon(Icons.add, color: MyColors.white),
            )
          : null,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: false,
          backgroundColor: MyColors.kPrimaryColor,
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(MyString.trelloBoard,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: MyColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: kIsWeb
                        ? Constants.largeSizeFont
                        : Constants.mediumSizeFont)),
          ),
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: double.infinity,
            maxHeight: MediaQuery.of(context).size.height * .80,
          ),
          child: Obx(() => ReorderableListView(
                buildDefaultDragHandles: false,
                scrollDirection: Axis.horizontal,
                onReorder: (int oldIndex, int newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final ParentList item =
                      controller.mainList.value.removeAt(oldIndex);
                  controller.mainList.value.insert(newIndex, item);
                  controller.mainList.refresh();
                },
                children: <Widget>[
                  for (int index = 0;
                      index < controller.mainList.value.length;
                      index++)
                    ReorderableDelayedDragStartListener(
                      key: ValueKey(index),
                      index: index,
                      child: TerlloBoardCard(
                        title: controller.mainList.value[index].title,
                        childItems:
                            controller.mainList.value[index].child.value,
                        deleteItem: () {
                          controller.mainList.refresh();
                        },
                        deleteList: () {
                          controller.mainList.removeAt(index);
                          controller.mainList.refresh();
                        },
                        addData: (value) {
                          controller.mainList.value[index].child.value
                              .add(value);
                          controller.mainList.refresh();
                        },
                      ),
                    )
                ],
              )),
        ),
      ),
    );
  }
}
