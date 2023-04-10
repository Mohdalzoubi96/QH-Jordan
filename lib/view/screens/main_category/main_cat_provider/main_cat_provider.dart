import 'package:flutter/cupertino.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainCatProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  bool loadData = false;

  MainCatProvider({@required this.sharedPreferences});

  void saveSelectedCatToSharedPrefs(int selectedCatId) {
    sharedPreferences.setInt(AppConstants.SELECTED_CATEGORY_ID, selectedCatId);
  }

  int getSelectedCatValue() {
    return sharedPreferences.getInt(AppConstants.SELECTED_CATEGORY_ID) ?? 1;
  }
}
