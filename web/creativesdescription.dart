import 'package:polymer/polymer.dart';
import 'utilities.dart';
import 'dart:html';

class CreativeData {
  InputElement name;
  SelectElement incent;
  SelectElement platform;
  InputElement countries;
  
  bool isReady() {
    return name != null &&
        incent != null &&
        platform != null &&
        countries != null;
  }
  
  String genHTML() {
    return name.value + " - " + incent.value + " - " + platform.value + " - " + countries.value;  
  }
}

@CustomTag('creatives-description')
class CreativesDescription extends PolymerElement {
    
  // Helpers for creating and removing campaign rows
  @observable List<int> numbers = toObservable(genIntSeq(100));
  @observable String numRows;
  @observable List<int> numRowsInt;
  
  @observable String campaignTitle;
  @observable String linkText;
  @observable String resultCode;
  
  MutationObserver observer;
   
  List<CreativeData> references;
  
  CreativesDescription.created() : super.created() {
    
  }
  
  void genCode(){
    resultCode = "<html><head></head><body style='font-family: arial'><img src='http://internal.blindferret.com/images/templates/email_template_creatives-header.png'><div style='position: relative; width: 590; left: 30;'>Hey {firstname},<br><br>Here are some more creatives to add to the following campaigns:<br><div style='position: relative; width: 590; border: 1px solid orange'><img src='http://internal.blindferret.com/images/templates/email_template_creatives-orangebar.png'><p>{{campaignName}}<a href='{{linkText}}' style='position: relative; left: 340'><img src='http://internal.blindferret.com/images/templates/email_template_creatives-getcreativesbutton.png'></a></p><hr><br>{{dataDetail}}</div><br><br>Thanks,<br><br><b><i>The Blind Ferret Team</i></b><br><br></div><div align='center' style='background: lightgrey; width: 650'><br>If you have any questions, please contact your affiliate manager<br><br><b>Blind Ferret Media</b><br><hr><br>If you prefer to not receive these emails, please visit the following link:<br><br>{unsub_email_url}<br></div></body></html>";
    resultCode = insertIntoPlaceholder(resultCode, "{{campaignName}}", campaignTitle);
    resultCode = insertIntoPlaceholder(resultCode, "{{linkText}}", linkText);
    String data = "";
    for (var i = 0; i < references.length; i++) {
      data += references[i].genHTML();
    }
    resultCode = insertIntoPlaceholder(resultCode, "{{detailData}}", data);
  }
  
  void updatedNum() {
    numRowsInt = genIntSeq(int.parse(numRows));    
  }
  
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    references.clear();
    for (var i = 0; i < mutations.length; i++) {
      if (mutations[i].addedNodes.length > 0) {
        CreativeData holder = new CreativeData();
        for (var j = 0; j < mutations[i].addedNodes.length; j++) {
          HtmlElement temp = mutations[i].addedNodes[j];
          switch(temp.className){
            case 'name-text':
              holder.name = temp;
              break;
            case 'incent-select':
              holder.incent = temp;
              break;
            case 'platform-select':
              holder.platform = temp;
              break;
            case 'countries-text':
              holder.countries = temp;
              break;
            default:
              break;
          }
        }
        if(holder.isReady()) {
          references.add(holder);
        }
      }
    }
  }
}