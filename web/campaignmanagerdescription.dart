import "package:polymer/polymer.dart";
import "utilities.dart";
import "dart:html";
import "newmobilecampaign.dart";

@CustomTag('campaign-manager')
class CampaignManager extends PolymerElement {
    
  // Again with the number helper
  @observable List<int> numbers = toObservable(genIntSeq(100));
  @observable String numRows;
  @observable List<int> numRowsInt;
  
  int section;
  List<NewMobileCampaign> campaigns;
  
  MutationObserver observer;
  
  CampaignManager.created() : super.created() {
    campaigns = new List<NewMobileCampaign>();    
  }
  
  void postDisplay() {
    observer = new MutationObserver(_onMutation);
    observer.observe($['campaigns'], childList: true, subtree: true);
  }
  
  void numUpdate() {
    numRowsInt = genIntSeq(int.parse(numRows));
  }
  
  String genCode(int section) {
    String result = "";
    for (var i = 0; i < campaigns.length; i++) {
      result += campaigns[i].genCode(section);
    }
    return result;
  }
  
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    campaigns.clear();
    for (var i = 0; i < mutations.length; i++) {
      for (var j = 0; j < mutations[i].addedNodes.length; j++) {
        if (mutations[i].addedNodes[j].nodeName == 'NEW-MOBILE-CAMPAIGN') {
          campaigns.add(mutations[i].addedNodes[j]);
          mutations[i].addedNodes[j].postDisplay();
        }
      }
    }
  }
}