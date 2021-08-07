import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/address_model.dart';
import 'package:salla/modules/settings/cubit.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';

import '../setting_state.dart';

class AddressScreen extends StatefulWidget {
  static const String ADDRESS_SCREEN = 'address_screen';

  const AddressScreen({Key key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String currentValue;
  SettingCubit cubit;
  AddressModel model;
  Data addressDetails;

  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = SettingCubit.get(context);
    currentValue = cubit.currentElementInDropDown;
    cubit.getCurrentAddressForUser();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      body: BlocConsumer<SettingCubit, SallaStates>(
        listener: (context, state) {
          if (state is SuccessGetAddressState) {
            model = cubit.address;
            addressDetails = model.data.data[0];
            currentValue = cubit.currentElementInDropDown;
            cityController.text = addressDetails.city.toString();
            regionController.text = addressDetails.region.toString();
            detailsController.text = addressDetails.details.toString();
            noteController.text = addressDetails.notes.toString();
            cubit.setValue();
          }
        },
        builder: (context, state) {
          currentValue = cubit.currentElementInDropDown;
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: addressDetails != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customNormalText(
                            context: context, title: 'Address Type:'),
                        SizedBox(
                          width: double.infinity,
                          child: DropdownButton(
                              isExpanded: true,
                              value: currentValue,
                              icon: Icon(Icons.keyboard_arrow_down),
                              onChanged: (String newValue) {
                                cubit.setNewDropdownElement(newValue);
                              },
                              items: cubit.dropdownElement
                                  .map<DropdownMenuItem<String>>((element) {
                                return DropdownMenuItem(
                                  child: Text(element),
                                  value: element,
                                );
                              }).toList()),
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
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        customNormalText(
                            context: context, title: 'Address Note:'),
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
                              ? MaterialButton(
                                  color: Colors.green,
                                  height: 40,
                                  minWidth: 100,
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  colorBrightness: Brightness.light,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  onPressed: () {
                                    cubit.updateCurrentAddressForUser(
                                      id: addressDetails.id,
                                      addressType: currentValue,
                                      city: cityController.text.toString(),
                                      region: regionController.text.toString(),
                                      details:
                                          detailsController.text.toString(),
                                      notes: noteController.text.toString(),
                                    );
                                  },
                                )
                              : CircularProgressIndicator(),
                        )
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}
