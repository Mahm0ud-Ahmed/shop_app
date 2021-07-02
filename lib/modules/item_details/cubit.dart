import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/item_details/states.dart';
import 'package:salla/shared/network/local/salla_States.dart';

class ItemDetailsCubit extends Cubit<SallaStates> {
  ItemDetailsCubit() : super(InitialItemDetailsState());

  static ItemDetailsCubit get(context) =>
      BlocProvider.of<ItemDetailsCubit>(context);

  int currentIndexImage = 0;
  bool isSeeMore = false;

  void changeIndex(int newIndex) {
    currentIndexImage = newIndex;
    emit(ChangeImageItemDetailsState());
  }

  changeSee() {
    isSeeMore = !isSeeMore;
    emit(ChangeSeeMoreItemDetailsState());
  }
}
