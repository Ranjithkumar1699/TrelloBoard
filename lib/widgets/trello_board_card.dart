import 'package:flutter/material.dart';
import 'package:trelloboard/Support/string.dart';
import 'package:trelloboard/support/colors.dart';
import 'package:trelloboard/support/validate_input.dart';

class TerlloBoardCard extends StatefulWidget {
  //region Private Members
  TextEditingController? title;
  List<dynamic>? childItems;
  Function(String)? addData;
  Function()? deleteItem;
  Function()? deleteList;
  int? index;

//endregion

  TerlloBoardCard(
      {super.key,
      this.title,
      this.childItems,
      this.addData,
      this.deleteItem,
      this.index,
      this.deleteList});

  @override
  _TerlloBoardCardState createState() => _TerlloBoardCardState();
}

class _TerlloBoardCardState extends State<TerlloBoardCard> {
  //region Private Members
  TextEditingController? childTextController;
  TextEditingController? searchTextController;
  List<dynamic>? filteredItems;
  final CardFormKey = GlobalKey<FormState>();

  //endregion

  @override
  void initState() {
    childTextController = TextEditingController();
    searchTextController = TextEditingController();
    filteredItems = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 350,
        height: MediaQuery.of(context).size.width * .35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: MyColors.lightBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onSaved: (String? value) {},
                      controller: widget.title,
                      decoration: InputDecoration(
                        hintText: MyString.title,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: new Icon(Icons.delete, color: MyColors.kPrimaryColor),
                    onPressed: () {
                      widget.deleteList!();
                    },
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: MyString.searchItem,
                  ),
                  minLines: 1,
                  onChanged: (value) {
                    filterData();
                  },
                ),
              ),
              searchTextController!.text.isEmpty
                  ? Expanded(
                      child: DragTarget<String>(
                        builder: (
                          BuildContext context,
                          List<String?> candidateData,
                          List<dynamic> rejectedData,
                        ) {
                          return ReorderableListView(
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }

                                final String item =
                                    widget.childItems!.removeAt(oldIndex);
                                widget.childItems!.insert(newIndex, item);
                              });
                            },
                            children: <Widget>[
                              for (int index = 0;
                                  index < widget.childItems!.length;
                                  index++)
                                LongPressDraggable<String>(
                                  key: ValueKey(index),
                                  data: widget.childItems![index],
                                  feedback: Container(
                                    width: 340,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.10),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.childItems![index] ?? "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Text(""),
                                  onDragCompleted: () {
                                    widget.childItems!.removeAt(index);
                                    widget.deleteItem!();
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.10),
                                                    spreadRadius: 5,
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    widget.childItems![index] ??
                                                        ""),
                                              ),
                                              width: 340,
                                            ),
                                          ),
                                          IconButton(
                                            icon: new Icon(Icons.delete,
                                                color: MyColors.red),
                                            onPressed: () {
                                              widget.childItems!
                                                  .removeAt(index);
                                              widget.deleteItem!();
                                            },
                                          ),
                                          SizedBox(
                                            width: 18,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                )
                            ],
                          );
                        },
                        onWillAccept: (data) => true,
                        onAccept: (data) {
                          setState(() {
                            widget.childItems!.add(data);
                          });
                        },
                      ),
                    )
                  : Expanded(
                      child: DragTarget<String>(
                        builder: (
                          BuildContext context,
                          List<String?> candidateData,
                          List<dynamic> rejectedData,
                        ) {
                          return ReorderableListView(
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }

                                final String item =
                                    filteredItems!.removeAt(oldIndex);
                                filteredItems!.insert(newIndex, item);
                              });
                            },
                            children: <Widget>[
                              for (int index = 0;
                                  index < filteredItems!.length;
                                  index++)
                                LongPressDraggable<String>(
                                  key: ValueKey(index),
                                  data: filteredItems![index],
                                  feedback: Container(
                                    width: 340,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.10),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        filteredItems![index] ?? "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Text(""),
                                  onDragCompleted: () {
                                    filteredItems!.removeAt(index);
                                    widget.deleteItem!();
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.10),
                                                    spreadRadius: 5,
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    filteredItems![index] ??
                                                        ""),
                                              ),
                                              width: 340,
                                            ),
                                          ),
                                          IconButton(
                                            icon: new Icon(Icons.delete,
                                                color: MyColors.red),
                                            onPressed: () {
                                              filteredItems!.removeAt(index);
                                              widget.deleteItem!();
                                            },
                                          ),
                                          SizedBox(
                                            width: 18,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                )
                            ],
                          );
                        },
                        onWillAccept: (data) => true,
                        onAccept: (data) {
                          setState(() {
                            filteredItems!.add(data);
                          });
                        },
                      ),
                    ),
              Row(
                children: [
                  Expanded(
                    child: Form(
                      key: CardFormKey,
                      child: TextFormField(
                        controller: childTextController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add),
                          hintText: MyString.addItem,
                          enabledBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        onSaved: (String? value) {},
                        validator: ValidateInput.validateCardName,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: new Icon(Icons.check),
                    onPressed: () {
                      if (CardFormKey.currentState!.validate()) {
                        CardFormKey.currentState!.save();
                        widget.addData!(childTextController!.text);
                        childTextController!.text = "";
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

// Search and filter the user enter the item.
  void filterData() {
    filteredItems!.clear();
    for (int i = 0; i < widget.childItems!.length; i++) {
      if (widget.childItems![i]
          .toString()
          .contains(searchTextController!.text)) {
        filteredItems!.add(widget.childItems![i]);
      }
    }
    setState(() {});
  }
}
