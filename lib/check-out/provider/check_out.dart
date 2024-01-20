import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/settlin/models/card_details_schema.dart';
import 'package:flutter_application_1/settlin/models/order_details_schema.dart';

class CheckOutProvider extends ChangeNotifier {
  List<CardDetailsSchema> userCards = [];

  CardDetailsSchema? currentCard;

  int maxCards = 3;

  bool isPayButtonEnabled = false;

  // bool isAddedCardValid = false;

  bool zoomInCard = false;

  CarouselController carouselController = CarouselController();

  void notify() => notifyListeners();

  OrderDetailsSchema order = OrderDetailsSchema(
    items: [
      OrderItem(
        name: 'Bonsai Plant',
        price: 38.99,
        tax: 4.04,
      ),
      OrderItem(
        name: 'Plant Fertilizer',
        price: 19.99,
        tax: 2.40,
      ),
      OrderItem(
        name: 'Bonsai Plant',
        price: 12.99,
        tax: 2.20,
      ),
    ],
    shippingCharge: 9.99,
  );
}
