import 'package:polymer/polymer.dart';

@CustomTag('campaign-row')
class CampaignRow extends PolymerElement {
  
  @observable String campTitle;
  @observable String incent;
  @observable String platform;
  @observable String countries;
  @observable String payoutText;
  @observable String payoutSelect;
  
  
  CampaignRow.created() : super.created();
  
  void setTitle(String title) {    
    campTitle = toObservable(title);  
  }
  
  String genCode() {
    //return "<div>"+campTitle+"-"+incent+"-"+platform+"-"+countries+"</div><div>"+payoutText+"/"+payoutSelect+"</div>";
    return "<div><div>$campTitle - $incent - $platform - $countries</div><div style='position: relative; top: -18; left: 500;'>$payoutText/$payoutSelect</div></div>";
  }
}