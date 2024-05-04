

import 'package:flutter/material.dart';
import 'package:chasski/pages/homepage.dart';


class LayoutModel with ChangeNotifier {
  Widget _currentPage =  const HomePage();


  set currentPage(Widget page){
    _currentPage = page;
    notifyListeners();
  }

  Widget get currentPage => _currentPage; 

}