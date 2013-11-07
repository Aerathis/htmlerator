import 'package:polymer/polymer.dart';
import 'utilities.dart';
import 'dart:html';
import 'campaignrow.dart';

@CustomTag('new-mobile-campaign')
class NewMobileCampaign extends PolymerElement {
  
  @observable String campaignTitle;
  
  @observable List<int> numbers = toObservable(genIntSeq(100));
  @observable List<int> numCampsInt;
  @observable String numRows;
  
  MutationObserver observer;
  
  List<CampaignRow> rows = new List<CampaignRow>();
  
  NewMobileCampaign.created() : super.created();       
  
  void postDisplay() {
    observer = new MutationObserver(_onMutation);
    observer.observe($['row-data'], childList: true, subtree: true);
  }
  
  void numCampsUpdate() {    
    numCampsInt = genIntSeq(int.parse(numRows));    
  }
  
  void titleUpdate() {
    for (var i = 0; i < rows.length; i++) {
      rows[i].setTitle(campaignTitle);
    }
  }
  
  String genCode() {
    String resultCode = "Campaign";
    for (var i = 0; i < rows.length; i++) {
      resultCode += rows[i].genCode();      
    }
    return resultCode;
  }
  
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    rows.clear();
    for (var i = 0; i < mutations.length; i++) {
      for (var j = 0; j < mutations[i].addedNodes.length; j++) {        
        if (mutations[i].addedNodes[j].nodeName == "CAMPAIGN-ROW") {
          CampaignRow el = mutations[i].addedNodes[j];                   
          rows.add(el);
        }
      }
    }
    for (var i = 0; i < rows.length; i ++) {
      rows[i].setTitle(campaignTitle);
    }
  }
}