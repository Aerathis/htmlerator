import 'package:polymer/polymer.dart';
import 'utilities.dart';
import 'dart:html';

// Small data structure that handles writing blocks of HTML for each Pause Item
class PauseData {
  String title;
  String country;
  String incent;
  String platform;
  
  PauseData(String tit, String count, String inc, String plat) {
    title = tit;
    country = count;
    incent = inc;
    platform = plat;
  }
  
  String genHTMLForData() {
    return title + " - " + platform + " - " + incent + " - " + country;
  }
}

// Reference holder for the three pieces of data required for a Pause Item
class TrioReference {
  InputElement nameEl = null;
  InputElement countryEl = null;
  SelectElement firstSelect = null;
  SelectElement secondSelect = null;
  
  void setName(InputElement inNode) {
    nameEl = inNode;
  }
  
  void setCountry(InputElement inNode) {
    countryEl = inNode;
  }
  
  void setIncent(SelectElement inNode) {
    firstSelect = inNode;
  }
  
  void setPlatform(SelectElement inNode) {
    secondSelect = inNode;
  }
  
  bool isPopulated() {
    return nameEl != null && firstSelect != null && secondSelect != null;
  }
}

@CustomTag('pause-description')
class PauseDescription extends PolymerElement {  
  
  MutationObserver observer;  
  List<TrioReference> references = new List<TrioReference>();
  
  // Generate a list of 100 numbers to fill out the number of rows dropdown
  final List<int> numbers = toObservable(genIntSeq(100));
  
  // The Campaign title
  @observable String campaignTitle;
  
  // The Pause date
  @observable String pauseDate;
  
  // A number of observable properties to get the number of necessary rows
  @observable String numRows;
  @observable List<int> numRowsInt = new List<int>();  
  
  // The Output Code
  @observable String resultCode = "";
  
  PauseDescription.created() : super.created() {
    observer = new MutationObserver(_onMutation);        
    observer.observe($['campaign-items'], childList: true, subtree: true);
  }
  
  void updatedNum() {
    numRowsInt = genIntSeq(int.parse(numRows));    
  }
  
  // Output the actual HTML for copy and paste purposes
  void genCode() {    
    List<PauseData> pauses = new List<PauseData>();
    for (var i = 0; i < references.length; i++) {
      pauses.add(new PauseData(references[i].nameEl.value, references[i].countryEl.value, references[i].firstSelect.value, references[i].secondSelect.value));
    }
    resultCode = "<html><head></head><body style='font-family:arial'><img src='http://internal.blindferret.com/images/templates/email_template_campaignpause-header.png' width='650' height='129'><div style='position: relative; left: 30; width: 590'> <br><br>Hey {firstname},<br><br>Unfortunately we need to ask that you pause the following campaigns, effective {{date}}<br><br><div style='border: 1px solid blue; width: 590'><img src='http://internal.blindferret.com/images/templates/email_template_campaignpause-bluebar.png'><br><div style='position: relative; left: 10;'><br>{{Campaign name}}<hr style='position: relative; left: -10;'><p style='color: lightgrey'>Campaigns</p>{{fill in the bitches}}<div id='calendar' style=' position: relative; top: -60px; right: -390; background: url(\"http://internal.blindferret.com/images/templates/email_template_campaignpause-calendar.png\"); width: 182px; height: 182px;' align='center'><div id='month' style=' position: relative; top: 25; color: white; font-weight: bold; font-size: large;'>{{month}}</div><div id='day' style=' position: relative; top: 60; font-size: 49; font-weight: bold;'>{{day}}</div></div></div></div><br><br>Please contact your affiliate manager if you have any questions<br><br>Thanks,<br><br><b><i>The Blind Ferret Team</i></b><div align='center' style='background-color: lightgrey'>If you have any questions, please contact your affiliate manager<br><br><b>Blind Ferret Media</b><br><br><hr><br>If you prefer to not receive these emails, please visit the following link:<br><br>{unsub_email_url}</div></div></body></html>";
    resultCode = _pushDateInResultCode(resultCode);
    resultCode = _replaceCampaignNamePlaceholder(resultCode);
    resultCode = _fillCalendarBox(resultCode);
    resultCode = _fillInTheBitches(resultCode, pauses);
    /*
    for (var i = 0; i < pauses.length; i++) {
      resultCode += pauses[i].genHTMLForData();
    }*/
  }
  
  // Watch the list of campaign items and collect references to the inputs when the number of campaigns changes
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    references.clear();        
    for (var i = 0; i < mutations.length; i++) {           
      if (mutations[i].addedNodes.length > 0) {
        TrioReference holder = new TrioReference();
        for (var j = 0; j < mutations[i].addedNodes.length; j++) {          
          if (mutations[i].addedNodes[j].nodeName == "INPUT") {            
            InputElement test = mutations[i].addedNodes[j];
            assert(test != null); 
            if (test.className == 'title') {
              holder.setName(test);  
            } else if (test.className == 'country'){
              holder.setCountry(test);    
            }                                  
          } else if (mutations[i].addedNodes[j].nodeName == "SELECT") {            
            SelectElement test = mutations[i].addedNodes[j];
            assert(test != null);            
            if (test.className == 'incent') {
              holder.setIncent(test);
            } else if (test.className == 'platform') {
              holder.setPlatform(test);
            }
          }          
        }
        if (holder.isPopulated()) {
          references.add(holder);
        }        
      }
    }    
  }
     
  String _pushDateInResultCode(String code) {
    int startPoint = code.indexOf("{{date}}");
    int resumePoint = code.indexOf("{{date}}") + 8;
    String start = code.substring(0, startPoint);
    String resume = code.substring(resumePoint);
    code = start;
    print(code);
    print(pauseDate.substring(5, 7));
    print(monthNames[pauseDate.substring(5, 7)]);
    code += pauseDate;
    code += resume;
    return code;
  }
  
  String _replaceCampaignNamePlaceholder(String code) {
    int startPoint = code.indexOf("{{Campaign name}}");
    int resumePoint = code.indexOf("{{Campaign name}}") + 17;
    String start = code.substring(0, startPoint);
    String resume = code.substring(resumePoint);
    code = start;
    code += "<b>" + campaignTitle + "<b>";
    code += resume;
    return code;
  }
  
  String _fillCalendarBox(String code) {
    int monthStart = code.indexOf("{{month}}");    
    int monthResume = monthStart + 9;    
    String start = code.substring(0, monthStart);
    String resume = code.substring(monthResume);
    code = start;
    code += monthNames[pauseDate.substring(5,7)];
    code += resume;
    int dayStart = code.indexOf("{{day}}");
    int dayResume = dayStart + 7;
    start = code.substring(0, dayStart);
    resume = code.substring(dayResume);
    code = start;
    code += pauseDate.substring(8,10);
    code += resume;
    return code;
  }
  
  String _fillInTheBitches(String code, List<PauseData> pauses) {
    int startPoint = code.indexOf("{{fill in the bitches}}");
    int resumePoint = startPoint + 23;
    String start = code.substring(0, startPoint);
    String resume = code.substring(resumePoint);
    code = start;
    for (var i = 0; i < pauses.length; i++) {
      code += pauses[i].genHTMLForData();
      code += "<br>";
    }
    code += resume;
    return code;
  }
}