import 'package:polymer/polymer.dart';
import 'utilities.dart';
import 'dart:html';

class RateDropReference {
  InputElement campaignTitle;
  SelectElement incent;
  SelectElement platform;
  InputElement countries;
  InputElement payout;
  SelectElement scheme;   
  
  bool isReady() {
    return campaignTitle != null && 
        incent != null &&
        platform != null &&
        countries != null &&
        payout != null &&
        scheme != null;
  }
  
  String genDetailHTML() {
    return "<div>" + incent.value + " - " + platform.value + " - " + countries.value + "</div><div>" + payout.value + "/" + scheme.value;
  }
}

@CustomTag('ratedrop-description')
class RateDropDescription extends PolymerElement {
    
  MutationObserver observer;
  
  // List of references to objects inside the capaign row list
  List<RateDropReference> references;
  
  @observable String dropDate;
  @observable String campaignTitle;
  @observable String resultCode;
  
  // Some helpers for modifying the number of campaign rows
  final List<int> numbers = toObservable(genIntSeq(100));
  @observable String numRows;
  @observable List<int> numRowsInt;
  
  RateDropDescription.created() : super.created() {
    observer = new MutationObserver(_onMutation);
    observer.observe($['campaign-items'], childList: true, subtree: true);
  }
  
  void updatedNum() {
    numRowsInt = genIntSeq(int.parse(numRows));
    print(numRowsInt);
  }
  
  void genCode() {
    resultCode = "<html><head></head><body style='font-family: arial'><img src='http://internal.blindferret.com/images/templates/email_template_ratedrop-header.png'><div style='width: 590; position: relative; left: 30'>Hey {firstname},<br><br>Unfortunately we need to lower the rates for the following campaigns effective {{dropDate}}:<br><br><div style='width: 590; border: 1px solid green'><img src='http://internal.blindferret.com/images/templates/email_template_ratedrop-greenbar.png'><br><p>{{campaignTitle}}</p><hr><div>{{detailData}}</div><div id='calendar' align='center' style='position: relative; left: 400; top: -50; background: url(http://internal.blindferret.com/images/templates/email_template_ratedrop-calendar.png); width: 182; height: 182'><div id='monthName' style='position: relative; top: 25px; color: white'>{{monthName}}</div><div id='dayNumber' style='position: relative; top: 60px; font-size: 49'>{{dayNumber}}</div></div></div><br><br>Please contact your affiliate manager if you have any questions.<br><br>Thanks,<br><br><b><i>The Blind Ferret Team</i></b><br><br><div style='background-color: lightgrey' align='center'><br>If you have any questions, please contact your affiliate manager<br><br><b>Blind Ferret Media</b><br><br><hr><br><br>If you prefer to not receive these emails, please visit the following link:<br><br>{unsub_email_url}</div></div></body></html>";
    resultCode = insertIntoPlaceholder(resultCode, "{{dropDate}}", dropDate);
    resultCode = insertIntoPlaceholder(resultCode, "{{campaignTitle}}", campaignTitle);
    resultCode = insertIntoPlaceholder(resultCode, "{{monthName}}", "TBD");
    resultCode = insertIntoPlaceholder(resultCode, "{{dayNumber}}", "TBD");
    String detailData = "";
    for (var i = 0; i < references.length; i++) {
      detailData += references[i].genDetailHTML();
    }
    resultCode = insertIntoPlaceholder(resultCode, "{{detailData}}", detailData);
  }
  
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    references.clear();
    for (var i = 0; i < mutations.length; i++) {
      if (mutations[i].addedNodes.length > 0) {
        RateDropReference holder = new RateDropReference();
        for (var j = 0; j < mutations[i].addedNodes.length; j++) {
          HtmlElement el = mutations[i].addedNodes[j];
          switch(el.className){
            case "camp-title":
              holder.campaignTitle = el;
              break;
            case "incent-select":
              holder.incent = el;
              break;
            case "platform-select":
              holder.platform = el;
              break;
            case "country-text":
              holder.countries = el;
              break;
            case "payout-text":
              holder.payout = el;
              break;
            case "payout-select":
              holder.scheme = el;
              break;
            default:
              break;
          }
        }
        if (holder.isReady()) {
          references.add(holder);
        }
      }
    }
  }
}