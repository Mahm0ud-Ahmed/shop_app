import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/user_model.dart';
import 'package:salla/modules/settings/item_model.dart';
import 'package:salla/modules/settings/profile_information.dart';
import 'package:salla/modules/settings/setting.dart';
import 'package:salla/modules/settings/setting_state.dart';
import 'package:salla/shared/component/constants.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/network/remot/dio_helper.dart';

class SettingCubit extends Cubit<SallaStates> {
  SettingCubit() : super(InitialSettingState());

  static SettingCubit get(context) => BlocProvider.of<SettingCubit>(context);

  List<ItemModel> itemExpansion = [
    new ItemModel(
      isExpanded: false,
      title: 'Language',
      body: itemLang(),
    ),
    new ItemModel(
      isExpanded: false,
      title: 'Theme',
      body: itemTheme(),
    ),
    new ItemModel(
      isExpanded: false,
      title: 'Profile Information',
      body: ProfileInformation(),
    ),
  ];

  void changeExpanded(index, isExpanded) {
    itemExpansion[index].isExpanded = isExpanded;
    emit(ChangeStateExpansionSettingState());
  }

  UserDataLogin userInfoModel;
  UserModel userModel;

  void getUserInfo() {
    emit(LoadingSettingState());
    SallaDioHelper.getData(endPointUrl: END_POINT_PROFILE, token: token)
        .then((value) {
      // print(value.data);
      UserModel userModel = UserModel.fromJsonLogin(value.data);
      userInfoModel = userModel.dataLogin;
      // print(userInfoModel.email);
      emit(SuccessSettingState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorSettingState());
    });
  }

  void updateProfile({String name, String phone, String email}) {
    emit(LoadingUpdateSettingState());
    SallaDioHelper.putData(
        endPointUrl: END_POINT_UPDATE_PROFILE,
        token: token,
        data: {'name': name, 'phone': phone, 'email': email}).then((value) {
      userModel = UserModel.fromJsonLogin(value.data);
      // print(userModel.message);
      emit(SuccessUpdateSettingState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateSettingState());
    });
  }
}
