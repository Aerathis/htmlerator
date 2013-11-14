import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('controller-panel')
class ControllerPanel extends PolymerElement {
  @observable String selectedPanel;
 
  MutationObserver observer;  
  
  ControllerPanel.created() : super.created() {
    observer = new MutationObserver(_onMutation);
    observer.observe($['main-panel'], childList: true, subtree: true);
  }
  
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    for (var i = 0; i < mutations.length; i++) {
      print(mutations[i].addedNodes);
      for (var j = 0; j < mutations[i].addedNodes.length; j++) {                
        if (mutations[i].addedNodes[j].nodeName == "DAILY-UPDATE-DESCRIPTION") {
          mutations[i].addedNodes[j].postDisplay();  
        } else if (mutations[i].addedNodes[j].nodeName == "PAUSE-DESCRIPTION") {
          mutations[i].addedNodes[j].postDisplay();  
        } else if (mutations[i].addedNodes[j].nodeName == "RATEDROP-DESCRIPTION") {
          mutations[i].addedNodes[j].postDisplay();
        }
      }
    }
  }
}