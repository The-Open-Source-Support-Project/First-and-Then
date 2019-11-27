import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsModel extends Model{
  bool _locked = false;
  bool _timer = false;
  Icon _lockIcon = Icon(Icons.lock_open);

  get locked =>_locked;
  get lockIcon => _lockIcon;
  get timer => _timer;

  void lockScreen(index) {
    if(index == 0){
      _locked = false;
      _lockIcon = Icon(Icons.lock_open);
    }else{
      _locked = true;
      _lockIcon = Icon(Icons.lock);
    }
    notifyListeners();
  }

  void toggleTimer(bool value) {
    _timer = value;
  }
}