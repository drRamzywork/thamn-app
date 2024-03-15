import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../Config/config.dart';
import '../../../../../../Data/data.dart';

class SearchingController extends GetxController {

  RxList<String> searchHistories=<String>[].obs;
  RxList<AutoCompleteX> autoCompletes=<AutoCompleteX>[].obs;
  List<String> popularSearches=[];
  TextEditingController searchText=TextEditingController();


  getData()async{
    try {
      popularSearches = await DatabaseX.getPopularSearches();
      searchHistories.value= await DatabaseX.getSearchHistory();
    } catch (e) {
      return Future.error(e);
    }
  }
  searchResults({String? word}){
    Get.toNamed(RouteNameX.researchResults,arguments: word??searchText.text);
  }
  getAutoCompletes(search)async{
    try {
      autoCompletes.value =await DatabaseX.getAll<AutoCompleteX>(api: DBContactX.getSearchAutoComplete+search, fromJson: AutoCompleteX.fromJson);
    } catch (e) {
      return Future.error(e);
    }
  }


  Future<List<AutoCompleteX>> searchingAutoComplete(String search)async{
    if(search.isNotEmpty) {
      await getAutoCompletes(search);
      return autoCompletes;
    }else{
      return [];
    }
  }

  removeSearchHistory(word) async {
    try {
      searchHistories.removeWhere((x) => x==word);
      await DatabaseX.deleteSearchHistory(word:word);
    } catch (e) {
      return Future.error(e);
    }
  }
  onTapSearchAutoComplete(id){
    Get.toNamed(RouteNameX.productDetails,arguments: id);
  }

}