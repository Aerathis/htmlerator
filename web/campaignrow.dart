import 'package:polymer/polymer.dart';

@CustomTag('campaign-row')
class CampaignRow extends PolymerElement {
  
  @observable String campTitle;
  
  CampaignRow.created() : super.created();
  
  void setTitle(String title) {    
    campTitle = toObservable(title);  
  }
  
  String genCode() {
    return "row";
  }
}