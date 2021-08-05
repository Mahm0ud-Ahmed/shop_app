import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/item_details_model.dart';
import 'package:salla/modules/item_details/states.dart';
import 'package:salla/shared/component/constants.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/network/remot/dio_helper.dart';

class ItemDetailsCubit extends Cubit<SallaStates> {
  ItemDetailsCubit() : super(InitialItemDetailsState());

  static ItemDetailsCubit get(context) =>
      BlocProvider.of<ItemDetailsCubit>(context);

  ItemDetailsModel itemDetailsModel;

  int currentIndexImage = 0;
  bool isSeeMore = false;

  void changeIndex(int length, int newIndex) {
    print('${length} $newIndex');
    currentIndexImage = newIndex > length - 1 ? 0 : newIndex;
    emit(ChangeImageItemDetailsState());
  }

  changeSee() {
    isSeeMore = !isSeeMore;
    emit(ChangeSeeMoreItemDetailsState());
  }

  getItemDetailsFromServer(int id) {
    currentIndexImage = 0;
    emit(LoadingItemDetailsState());
    String endPoint = END_POINT_PRODUCT_DETAILS + id.toString();
    SallaDioHelper.getData(endPointUrl: endPoint, token: token).then((value) {
      itemDetailsModel = ItemDetailsModel.fromJson(value.data);
      emit(SuccessItemDetailsState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorItemDetailsState());
    });
  }
}
