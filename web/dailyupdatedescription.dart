import 'package:polymer/polymer.dart';
import 'dart:html';
import 'campaignmanagerdescription.dart';

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
  CampaignManager newMobileElement = null;
  CampaignManager newWebElement = null;
  CampaignManager incMobileElement = null;
  CampaignManager incWebElement = null;
  
  // An observer to catch when new mutations occur to the data panels
  MutationObserver observer;
  
  @observable String emailIntro;
  @observable String resultCode = "";
  
  DailyUpdateDescription.created() : super.created() {}
  
  void postDisplay() {
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
      print("Not null");
      newMobileCode = newMobileElement.genCode(0);
    }
    if (newWebElement != null) {
      newWebCode = newWebElement.genCode(1);
    }
    if (incMobileElement != null) {
      incMobileCode = incMobileElement.genCode(2);      
    }
    if (incWebElement != null) {
      incWebCode = incWebElement.genCode(3);
    }
    if (emailIntro != null) {
      emailIntro = emailIntro.replaceAll('\n', "<br>");
    } else {
      emailIntro = "";
    }
    String result = "<html><head></head><body style='font-family: arial'><img src='http://internal.blindferret.com/images/templates/email_template-header.png'><div style='position: relative; left: 30; width: 590;'>";
    result += "Hey {firstname},<br><br>$emailIntro<br><br>";
    result += newMobileCode + newWebCode + incMobileCode + incWebCode;
    result += "</div><div align='center' style='background: lightgrey; width: 650'><br>If you have any questions, please contact your affiliate manager<br><br><b>Blind Ferret Media</b><br><hr><br>If you prefer to not receive these emails, please visit the following link:<br><br>{unsub_email_url}<br></div>";
    result += "</body></html>";
    print(result);
    resultCode = result;
  }
  
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    for (var i = 0; i < mutations.length; i++) {
      for (var j = 0; j < mutations[i].addedNodes.length; j++) {
        if (mutations[i].addedNodes[j].nodeName == "CAMPAIGN-MANAGER") {
          CampaignManager el = mutations[i].addedNodes[j];
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