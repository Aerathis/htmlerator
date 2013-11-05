import 'package:polymer/polymer.dart';
import 'dart:html';

class DataPair {
  String tagName;
  String tagValue;
  
  DataPair(this.tagName, this.tagValue);    
}

@CustomTag('exclusive-offer-description')
class ExclusiveOfferDescription extends PolymerElement {
  @observable String introText;
  @observable String campaignTitle;
  @observable String campaignDescription;
  @observable String previewURL;
  @observable String countries;
  @observable String payoutText;
  @observable String budgetText;
  
  // Reference to the icon file to upload
  InputElement iconFile;
  
  // Reference to the payout select element
  SelectElement payoutOption;
  
  // Reference to the Budge checkbox
  InputElement budgetOpen;
  
  // A flag to make sure that the icon is uploaded before generating the code
  bool iconFinished = false;
  
  // The image URL for the icon after it has been uploaded
  String imageURL = null;
  
  // Output Result
  @observable String resultCode;
  
  ExclusiveOfferDescription.created() : super.created() {
    iconFile = $['icon-file'];
    payoutOption = $['payout-select'];
    budgetOpen = $['budget-open-checkbox'];    
  }
  
  void uploadIcon() {
    if (iconFile.files.length == 1) {
      final file = iconFile.files[0];
      final reader = new FileReader();             
      reader.onLoad.listen((e) => _sendUpload(reader.result));
      reader.readAsDataUrl(file);
    }
  }
  
  void genCode() {
    if (iconFinished && imageURL != null) {
      List<DataPair> data = new List<DataPair>();
      data.add(new DataPair("{{introText}}", introText));
      data.add(new DataPair("{{campaignTitle}}", campaignTitle));
      data.add(new DataPair("{{campaignDescription}}", campaignDescription));
      data.add(new DataPair("{{previewURL}}", previewURL));
      data.add(new DataPair("{{countries}}", countries));
      if (payoutText == "") {
        data.add(new DataPair("{{payout}}", payoutOption.value));
      } else {
        data.add(new DataPair("{{payout}}", payoutText));
      }
      if (budgetOpen.checked) {
        data.add(new DataPair("{{budget}}", "Open"));
      } else {
        data.add(new DataPair("{{budget}}", budgetText));
      }
      resultCode = "<html><head></head><body style='font-family: arial;'><img src='http://internal.blindferret.com/images/templates/email_template_exclusive-header.png'><div style='position: relative; left: 30'><br><br>Hey {firstname},<br>{{introText}}<br><div id='detailBox' style='border: 1px solid red; width: 590'><img src='http://internal.blindferret.com/images/templates/email_template_exclusive-redbar.png'><div id='aboveBar'><p>{{campaignTitle}}<img src='{{icon}}' align='right' style='position:relative; right:10px;'></p></div><hr><div id='belowBar'><div id='description'><p style='color: grey;'>Description</p>{{campaignDescription}}</div><div id='sectionBottom'>{{Preview Button}}{{countries}}{{payout}}{{budget}}</div></div></div><br><br>If you're interested in running this campaign, please let myself of an affiliate manager know.<br><br>Best,<br>Randy<br><br><b><i>The Blind Ferret Team</i></b><div><br>If you have any quesions, please contact your affiliate manager<br><b>Blind Ferret Media</b><br><hr><br>If you prefer to not receive these emails, please visit the following link:<br>{unsub_email_url}</div></div></body></html>";
      resultCode = _insertTags(resultCode, data);      
    } else  {
      window.alert("Can't gen code without an icon");
    }
  }
  
  void _sendUpload(dynamic data) {
    final req = new HttpRequest(); 
    req.onReadyStateChange.listen((_) {
      if (req.readyState == HttpRequest.DONE && (req.status == 200 || req.status == 0)) {
        if (req.responseText == "Error") {
          window.alert("Problem during upload");
        } else {
          window.alert("upload complete");        
          iconFinished = true;
          imageURL = req.responseText;
        }        
      }
    });    
    req.open("POST", "http://localhost:8081");
    req.send(data);
  }
  
  String _insertIntoPlaceholder(String text, String tag, String value) {
    int startPoint = text.indexOf(tag);
    int endPoint = startPoint + tag.length;
    String start = text.substring(0,startPoint);
    String resume = text.substring(endPoint);
    text = start;
    text += value;
    text += resume;
    return text;
  }
  
  String _insertTags(String text, List<DataPair> pairs) {
    for (int i = 0; i < pairs.length; i++) {
      text = _insertIntoPlaceholder(text, pairs[i].tagName, pairs[i].tagValue);
    }
    return text;
  }
}