import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final List<String> homeCategoriesName = [
    'Phones',
    'Consoles',
    'Laptops',
    'Audios',
  ];
  final List<String> homeCategoriesImages = [
    AssetStore().phoneIcon,
    AssetStore().consoleIcon,
    AssetStore().laptopIcon,
    AssetStore().headphoneIcon
  ];

  final List<String> flashSaleImages = [
    'https://pngimg.com/uploads/iphone16/iphone16_PNG13.png',
    'https://pngimg.com/uploads/iphone16/iphone16_PNG13.png',
    'https://pngimg.com/uploads/iphone16/iphone16_PNG13.png',
    'https://pngimg.com/uploads/iphone16/iphone16_PNG13.png',
  ];
}
