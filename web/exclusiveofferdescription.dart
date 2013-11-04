import 'package:polymer/polymer.dart';
import 'dart:html';

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
  
  ExclusiveOfferDescription.created() : super.created() {
    iconFile = $['icon-file'];
    payoutOption = $['payout-select'];
    budgetOpen = $['budget-open-checkbox'];    
  }
  
  void uploadIcon() {
    if (iconFile.files.length == 1) {
      final file = iconFile.files[0];
      final reader = new FileReader();
      reader.onLoad = (e)  => _sendUpload(reader.result);      
      reader.readAsDataUrl(file);
    }
  }
  
  void genCode() {
    
  }
  
  void _sendUpload(dynamic data) {
    final req = new HttpRequest(); 
    req.onReadyStateChange.listen((_) {
      if (req.readyState == HttpRequest.DONE && (req.status == 200 || req.status == 0)) {
        window.alert("upload complete");
        iconFinished = true;
        imageURL = req.responseText;
      }
    });    
    req.open("POST", "serverloc");
    req.send(data);
  }
}