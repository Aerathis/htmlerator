import 'package:polymer/polymer.dart';
import 'dart:html';
import 'newmobilecampaign.dart';

@CustomTag('daily-update-description')
class DailyUpdateDescription extends PolymerElement {  
  
  // Helpers to track which campaign panels should be opened
  @observable bool hasNewMobile = false;
  @observable bool hasNewWeb = false;
  @observable bool hasIncMobile = false;
  @observable bool hasIncWeb = false;    
  InputElement newMobileCheck = null;
  InputElement newWebCheck = null;  
  InputElement incMobileCheck = null;  
  InputElement incWebCheck = null;
  
  // Campaign objects that hold the data for the individual sections
  NewMobileCampaign newMobileElement = null;
  NewMobileCampaign newWebElement = null;
  NewMobileCampaign incMobileElement = null;
  NewMobileCampaign incWebElement = null;
  
  // An observer to catch when new mutations occur to the data panels
  MutationObserver observer;
  
  DailyUpdateDescription.created() : super.created() {
    observer = new MutationObserver(_onMutation);
    observer.observe($['data-panels'], childList: true, subtree: true);
    newMobileCheck = $['new-mobile-check'];
    newWebCheck = $['new-web-check'];
    incMobileCheck = $['inc-mobile-check'];
    incWebCheck = $['inc-web-check'];
  }
  
  void newMobileCheckClick() {
    if(newMobileCheck != null) {
      hasNewMobile = newMobileCheck.checked;   
      if (!hasNewMobile) {
        newMobileElement = null;
      }
    }
  }
  
  void newWebCheckClick() {
    if (newWebCheck != null) {
      hasNewWeb = newWebCheck.checked;
      if (!hasNewWeb) {
        newWebElement = null;
      }
    }
  }
  
  void incMobileCheckClick() {
    if (incMobileCheck != null) {
      hasIncMobile = incMobileCheck.checked;
      if (!hasIncMobile) {
        incMobileElement = null;
      }
    }
  }
  
  void incWebCheckClick() {
    if (incWebCheck != null) {
      hasIncWeb = incWebCheck.checked;
      if (!hasIncWeb) {
        incWebElement = null;
      }
    }
  }
  
  void genCode() {
    String newMobileCode = "";
    String newWebCode = "";
    String incMobileCode = "";
    String incWebCode = "";
    
    if (newMobileElement != null) {
      newMobileCode = newMobileElement.genCode();
    }
    if (newWebElement != null) {
      newWebCode = newWebElement.genCode();
    }
    if (incMobileElement != null) {
      incMobileCode = incMobileElement.genCode();      
    }
    if (incWebElement != null) {
      incWebCode = incWebElement.genCode();
    }
    
    String result = newMobileCode + newWebCode + incMobileCode + incWebCode;
    print(result);
  }
  
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    for (var i = 0; i < mutations.length; i++) {
      for (var j = 0; j < mutations[i].addedNodes.length; j++) {
        if (mutations[i].addedNodes[j].nodeName == "NEW-MOBILE-CAMPAIGN") {
          NewMobileCampaign el = mutations[i].addedNodes[j];
          print(el.className);
          switch(el.className){
            case "new-mobile-campaign":
              newMobileElement = el;
              newMobileElement.postDisplay();
              break;
            case "new-web-campaign":
              newWebElement = el;
              newWebElement.postDisplay();
              break;
            case "inc-mobile-campaign":
              incMobileElement = el;
              incMobileElement.postDisplay();
              break;
            case "inc-web-campaign":
              incWebElement = el;
              incWebElement.postDisplay();
              break;
            default:
              break;
          }
        }
      }
    }
  }
}