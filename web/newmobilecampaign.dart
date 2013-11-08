import 'package:polymer/polymer.dart';
import 'utilities.dart';
import 'dart:html';
import 'campaignrow.dart';

@CustomTag('new-mobile-campaign')
class NewMobileCampaign extends PolymerElement {
  
  @observable String campaignTitle;
  @observable String campaignLink;
  @observable String previewLink;
  
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
  
  String genCode(int section) {
    String campaignButton = "";
    String previewButton = "";
    String resultCode = "";
    switch(section) {
      case 0:   
        resultCode += "<div style='position: relative; width: 590; border: 1px solid red;'>";
        resultCode += "<img src='http://internal.blindferret.com/images/templates/email_template-redbar.png'>";
        campaignButton = "<img src='http://internal.blindferret.com/images/templates/email_template-applynow-red.png'>";
        previewButton = "<img src='http://internal.blindferret.com/images/templates/email_template-preview-red.png'>";
        break;
      case 1:
        resultCode += "<div style='position: relative; width: 590; border: 1px solid blue;'>";
        resultCode += "<img src='http://internal.blindferret.com/images/templates/email_template-bluebar.png'>";
        campaignButton = "<img src='http://internal.blindferret.com/images/templates/email_template-applynow-blue.png'>";
        previewButton = "<img src='http://internal.blindferret.com/images/templates/email_template-preview-blue.png'>";
        break;
      case 2:
        resultCode += "<div style='position: relative; width: 590; border: 1px solid green;'>";
        resultCode += "<img src='http://internal.blindferret.com/images/templates/email_template-greenbar.png'>";
        campaignButton = "<img src='http://internal.blindferret.com/images/templates/email_template-applynow-green.png'>";
        previewButton = "<img src='http://internal.blindferret.com/images/templates/email_template-preview-green.png'>";
        break;
      case 3:
        resultCode += "<div style='position: relative; width: 590; border: 1px solid orange;'>";
        resultCode += "<img src='http://internal.blindferret.com/images/templates/email_template-orangebar.png'>";
        campaignButton = "<img src='http://internal.blindferret.com/images/templates/email_template-applynow-orange.png'>";
        previewButton = "<img src='http://internal.blindferret.com/images/templates/email_template-preview-orange.png'>";
        break;
      default:
        break;
    }
    resultCode += "<div><b style='position: relative; top: 10;'>$campaignTitle</b><div style='position: relative; top: -8; left: 420;'><a href='$campaignLink'>$campaignButton</a><a href='$previewLink'>$previewButton</a></div></div><hr style='color: lightgrey'>";
    resultCode += "<div style='color: lightgrey; height: 20'>Campaigns<div style='position: relative; top: -18; left: 500;'>Payout</div></div>";
    for (var i = 0; i < rows.length; i++) {
      resultCode += rows[i].genCode();      
    }
    resultCode += "</div><br><br>";
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