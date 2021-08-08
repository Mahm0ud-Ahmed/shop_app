import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/address/address_model.dart';
import 'package:salla/modules/settings/component/address_screen.dart';
import 'package:salla/modules/settings/cubit.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';

import '../setting_state.dart';
import 'component.dart';

class AddressDetails extends StatefulWidget {
  static const String ADDRESS_DETAILS = 'address_details';

  const AddressDetails({Key key}) : super(key: key);

  @override
  _AddressDetailsState createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  String currentValue;
  SettingCubit cubit;
  AllAddressData addressDetails;

  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cubit = SettingCubit.get(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addressDetails = ModalRoute.of(context).settings.arguments;
    setValueOfController();
    // print(addressDetails.name);
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
    regionController.dispose();
    detailsController.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingCubit, SallaStates>(
      listener: (context, state) {
        if (state is SuccessGetAddressState) {
          pushAndReplace(context, AddressScreen.ADDRESS_SCREEN);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        currentValue = cubit.currentElementInDropDown;
        return Scaffold(
          appBar: AppBar(
            title: Text('Address'),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropdownButton(
                      context: context,
                      value: currentValue,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    customNormalText(context: context, title: 'City Name:'),
                    customTextEditing(
                      controller: cityController,
                      label: 'City',
                      icon: Icon(Icons.location_city),
                      keyboard: TextInputType.text,
                      valid: (String value) {
                        if (value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    customNormalText(context: context, title: 'Region:'),
                    customTextEditing(
                      controller: regionController,
                      label: 'Region',
                      icon: Icon(Icons.location_city),
                      keyboard: TextInputType.text,
                      valid: (String value) {
                        if (value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    customNormalText(
                        context: context, title: 'Address Details:'),
                    customTextEditing(
                      controller: detailsController,
                      label: 'Details',
                      icon: Icon(Icons.details),
                      keyboard: TextInputType.text,
                      valid: (String value) {
                        if (value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    customNormalText(context: context, title: 'Address Note:'),
                    customTextEditing(
                      controller: noteController,
                      label: 'Notes',
                      icon: Icon(Icons.notes),
                      keyboard: TextInputType.text,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: state is! LoadingUpdateAddressState
                          ? buildButton(
                              title: 'Save',
                              onClick: () {
                                if (formState.currentState.validate()) {
                                  if (cubit.isEditing) {
                                    cubit.updateCurrentAddressForUser(
                                      id: addressDetails.id,
                                      addressType: currentValue,
                                      city: cityController.text.toString(),
                                      region: regionController.text.toString(),
                                      details:
                                          detailsController.text.toString(),
                                      notes: noteController.text.toString(),
                                    );
                                  } else {
                                    cubit.addAddressForUser(
                                      addressType: currentValue,
                                      city: cityController.text.toString(),
                                      region: regionController.text.toString(),
                                      details:
                                          detailsController.text.toString(),
                                      notes: noteController.text.toString(),
                                    );
                                  }
                                }
                              },
                            )
                          : CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void setValueOfController() {
    if (cubit.isEditing) {
      cityController.text = addressDetails.city.toString();
      regionController.text = addressDetails.region.toString();
      detailsController.text = addressDetails.details.toString();
      noteController.text = addressDetails.notes.toString() == 'null'
          ? ''
          : addressDetails.notes.toString();
      cubit.setNewDropdownElement(addressDetails.name);
    }
  }
}
