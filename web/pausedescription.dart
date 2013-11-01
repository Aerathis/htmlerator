import 'package:polymer/polymer.dart';
import 'utilities.dart';
import 'dart:html';

// Small data structure that handles writing blocks of HTML for each Pause Item
class PauseData {
  String title;
  String incent;
  String platform;
  
  PauseData(String tit, String inc, String plat) {
    title = tit;
    incent = inc;
    platform = plat;
  }
  
  String genHTMLForData() {
    return "Not Implemented Yet";
  }
}

// Reference holder for the three pieces of data required for a Pause Item
class TrioReference {
  InputElement nameEl = null;
  SelectElement firstSelect = null;
  SelectElement secondSelect = null;
  
  void setName(InputElement inNode) {
    nameEl = inNode;
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
      pauses.add(new PauseData(references[i].nameEl.value, references[i].firstSelect.value, references[i].secondSelect.value));
    }
    resultCode = "Hi {firstname}";
    for (var i = 0; i < pauses.length; i++) {
      resultCode += pauses[i].genHTMLForData();
    }
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
            holder.setName(test);
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
}