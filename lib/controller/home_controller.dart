import 'package:vtech_test/model/item_model.dart';
import '../repo/home_repo.dart';

class HomeController {
  ///
  Future<List<ItemModel>?> getData() async {
    return await HomeRepo().getData().then((value) {
      return value;
    });
  }

  Future<String> add(ItemModel params) async {
    return await HomeRepo().add(params).then((value) => value);
  }

  Future<int> updateTitle(ItemModel params) async {
    return await HomeRepo().updateTitle(params).then((value) => value);
  }

  Future<int> updateStatus(ItemModel params) async {
    return await HomeRepo().updateStatus(params).then((value) => value);
  }

  Future<int> remove(String strId) async {
    return await HomeRepo().remove(strId).then((value) => value);
  }
}
