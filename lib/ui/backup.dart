import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:vtech_test/model/item_model.dart';
import 'package:vtech_test/helper/g_enum.dart';
import 'components/cus_search.dart';
import 'components/item.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/home_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

TextEditingController titleTEC = TextEditingController();

RxList<ItemModel> rxList = <ItemModel>[].obs;
RxBool isDpublciate = false.obs;
RxBool isUpdate = false.obs;

ItemModel updateData = ItemModel(); // store value update

HomeController controller = HomeController();

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    controller.getData().then((value) {
      rxList.value = value ?? [];
    });

    super.initState();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Todo List'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  // delegate to customize the search bar
                  delegate: CustomSearchDelegate(list: rxList));
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _addUpdate(),
            Expanded(
              child: Obx(() => ListView.builder(
                  itemCount: rxList.length,
                  itemBuilder: (builder, i) {
                    return _item2(rxList[i]);
                  })),
            )
          ],
        ),
      ),
    );
  }

  Widget _item2(ItemModel data) {
    return Item(
      data: data,
      onChanged: (value) {
        /// remove
        if (value == ActionList.remove) {
          _remove(data.strId ?? '');
        }

        /// edit
        if (value == ActionList.edit) {
          _setTextToField(data);
        }

        /// mark completed
        if (value == ActionList.markCompleted) {
          _showLoading();
          _updateStatus(data.strId ?? '', true).then((code) {
            _closeLoading();
            if (code == 200) {
              data.isCompleted = true;
              rxList.refresh();
            } else {
              _updateFailedSnackBar();
            }
          });
        }

        /// mark incompleted
        if (value == ActionList.markIncompleted) {
          _showLoading();
          _updateStatus(data.strId ?? '', false).then((code) {
            _closeLoading();
            if (code == 200) {
              data.isCompleted = false;
              rxList.refresh();
            } else {
              _updateFailedSnackBar();
            }
          });
        }
      },
    );
  }

  Widget _addUpdate() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() => Column(
            children: [
              /// trigger
              Text(
                '${isDpublciate.value}${isUpdate.value}',
                style: const TextStyle(fontSize: 0),
              ),

              Row(
                children: [
                  /// add item field
                  Expanded(
                    child: TextFormField(
                      controller: titleTEC,
                      onFieldSubmitted: (v) {
                        /// if update or empty dont enter add item
                        if (isUpdate.value) {
                          return;
                        }

                        /// check duplicate
                        _checkDuplicate(v);
                        if (isDpublciate.value) {
                          return;
                        }
                        _showLoading();

                        // String uniqeId = _unqiuteStrId();
                        ItemModel d = ItemModel();
                        d.title = v;
                        // d.strId = uniqeId;

                        /// add data
                        controller.add(d).then((strId) {
                          _closeLoading();

                          /// sucess display to ui
                          if (strId != "") {
                            d.strId = strId;
                            rxList.value = [...rxList, d];

                            /// clear input
                            titleTEC.clear();
                          } else {
                            /// error
                            _snackbar('Add item failed, try again');
                          }
                        });
                      },
                      decoration: InputDecoration(
                        errorText:
                            isDpublciate.value ? 'item already exists' : null,
                        hintText: 'enter title',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 16)),

                  /// update button
                  if (isUpdate.value)
                    Container(
                      width: 95,
                      child: ElevatedButton(
                          onPressed: () => _update(), child: Text('update')),
                    )
                ],
              ),
            ],
          )),
    );
  }

  void _snackbar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 1), content: Text(content)));
  }

  ///====================================================================
  ///
  ///====================================================================

  void _setTextToField(ItemModel data) {
    titleTEC.text = data.title ?? '';
    updateData.title = data.title ?? '';
    updateData.strId = data.strId ?? '';
    updateData.isCompleted = data.isCompleted ?? false;
    isUpdate.value = true;
  }

  /// remove
  void _remove(String id) {
    _showLoading();

    /// cannot remove last item
    if (rxList.length > 1) {
      controller.remove(id).then((code) {
        _closeLoading();
        if (code == 200) {
          rxList.removeWhere((e) => e.strId == id);
          _snackbar('item removed!');
        } else {
          _snackbar('removed failed, try again!');
        }
      });
    } else {
      _snackbar('cannot remove last item!');
    }
  }

  void _checkDuplicate(String title) {
    /// if 1 record can update
    if (rxList.length == 1) {
      isDpublciate.value = false;
      return;
    }

    /// duplicate when update
    if (updateData.strId != '') {
      for (int i = 0; i < rxList.length; i++) {
        /// if current item can update with the same title
        if (rxList[i].strId == updateData.strId) {
          isDpublciate.value = false;
        } else {
          /// different id cannot update with the same title
          if (rxList[i].title!.toLowerCase() == title.toLowerCase()) {
            isDpublciate.value = true;
            break;
          } else {
            isDpublciate.value = false;
          }
        }
      }
    } else {
      /// check duplicate when add
      for (int i = 0; i < rxList.length; i++) {
        if (rxList[i].title!.toLowerCase() == title.toLowerCase()) {
          isDpublciate.value = true;
          break;
        } else {
          isDpublciate.value = false;
        }
      }
    }
  }

  void _update() {
    /// check duplicate
    _checkDuplicate(titleTEC.text);
    if (isDpublciate.value) {
      return;
    }

    /// should be below check duplicate
    _showLoading();
    for (int i = 0; i < rxList.length; i++) {
      if (rxList[i].strId == updateData.strId) {
        updateData.title = titleTEC.text;

        /// to controller
        controller.updateTitle(updateData).then((value) {
          _closeLoading();

          /// update success
          if (value == 200) {
            rxList[i].title = titleTEC.text;
            isUpdate.value = false;

            rxList.refresh();
            titleTEC.clear();

            /// clear
            updateData.strId = '';
            updateData.title = '';
            _snackbar('item updated!');
          } else {
            _updateFailedSnackBar();
          }
        });

        break;
      }
    }
  }

  /// updatate complete or in complete
  Future<int> _updateStatus(String strId, bool status) async {
    ItemModel d = ItemModel();
    d.isCompleted = status;
    d.strId = strId;
    return await controller.updateStatus(d).then((code) => code);
  }

  void _updateFailedSnackBar() {
    _snackbar('update failed, try again!');
  }

  void _showLoading() {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.25),
      context: context,
      builder: (BuildContext context) => const AlertDialog(
        surfaceTintColor: Colors.transparent,
        title: Center(
            child: SizedBox(
                width: 50,
                height: 50,
                child: LoadingIndicator(
                    indicatorType: Indicator.circleStrokeSpin,
                    colors: const [Colors.purple],
                    strokeWidth: 5,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.transparent

                    /// Optional, the stroke backgroundColor
                    ))),
        backgroundColor: Colors.transparent,
        actions: <Widget>[],
      ),
    );
  }

  void _closeLoading() {
    Navigator.pop(context);
  }
}
