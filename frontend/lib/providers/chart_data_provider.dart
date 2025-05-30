import 'package:flutter/foundation.dart';

class ChartDataProvider with ChangeNotifier {
  List<Map<String, dynamic>> _weekData = [];
  List<Map<String, dynamic>> _categoryData = [];

  List<Map<String, dynamic>> get weekData => _weekData;
  List<Map<String, dynamic>> get categoryData => _categoryData;

  void setWeekData(List<Map<String, dynamic>> data) {
    _weekData = data;
    notifyListeners();
  }

  void setCategoryData(List<Map<String, dynamic>> data) {
    _categoryData = data;
    notifyListeners();
  }

  // 获取所有数据的组合方法
  Map<String, dynamic> getAllData() {
    return {
      'weekData': _weekData,
      'categoryData': _categoryData,
    };
  }
}