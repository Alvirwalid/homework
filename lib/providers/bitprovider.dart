import 'package:flutter/cupertino.dart';

import '../model/item.dart';

class OrderProvider with ChangeNotifier {
  List<Item> orderConfirmlist = [];

  addConfirmorder(name, price, quantity, time) {
    Item item = Item(name: name, price: price, quantity: quantity, time: time);
    orderConfirmlist.add(item);

    print(orderConfirmlist.length);
    print(orderConfirmlist[0].price);

    notifyListeners();
  }
}
