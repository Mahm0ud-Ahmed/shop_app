import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/search_model.dart';
import 'package:salla/modules/search/search_state.dart';
import 'package:salla/shared/component/constants.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/network/remot/dio_helper.dart';

class SearchCubit extends Cubit<SallaStates> {
  SearchCubit() : super(InitialSearchState());

  static SearchCubit get(context) => BlocProvider.of<SearchCubit>(context);

  SearchModel searchModel;

  void getSearch(String text) {
    emit(LoadingSearchState());
    SallaDioHelper.postData(
            endPointUrl: END_POINT_SEARCH, data: {'text': text}, token: token)
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      print(searchModel.data.searchItemData[0].name);
      emit(SuccessSearchState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorSearchState());
    });
  }
}
