
import 'package:chasski/page/empleado/home/dashboard_page.dart';
import 'package:flutter/material.dart';


class LayoutModel with ChangeNotifier {
  Widget _currentPage =  const Dashboardpage();


  set currentPage(Widget page){
    _currentPage = page;
    notifyListeners();
  }

  Widget get currentPage => _currentPage; 
  
}