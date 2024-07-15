

import 'package:chasski/pages/t_local_storage.dart';
import 'package:flutter/material.dart';


class LayoutModel with ChangeNotifier {
  Widget _currentPage =  const LocalStoragePage();


  set currentPage(Widget page){
    _currentPage = page;
    notifyListeners();
  }

  Widget get currentPage => _currentPage; 

}