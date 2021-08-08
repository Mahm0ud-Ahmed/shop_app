import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/address/address_model.dart';
import 'package:salla/modules/settings/component/address_details.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';

import '../cubit.dart';
import '../setting_state.dart';

class AddressScreen extends StatefulWidget {
  static const String ADDRESS_SCREEN = 'address_screen';

  const AddressScreen({Key key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  SettingCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = SettingCubit.get(context);
    cubit.getCurrentAddressForUser();
  }

  @override
  Widget build(BuildContext context) {
    List<AllAddressData> addressDetails;
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SettingCubit, SallaStates>(
        listener: (context, state) {
          if (state is SuccessGetAddressState) {
            addressDetails = SettingCubit.get(context).addressGroup.data.data;
          }
        },
        builder: (context, state) {
          return addressDetails != null
              ? Container(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 90,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            color: Colors.green,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (DismissDirection direction) {
                            switch (direction) {
                              case DismissDirection.endToStart:
                                cubit.deleteAddressForUser(
                                    id: addressDetails[index].id,
                                    address: addressDetails[index],
                                    index: index);
                                break;
                              case DismissDirection.startToEnd:
                                pushInStack(
                                    context, AddressDetails.ADDRESS_DETAILS,
                                    arg: addressDetails[index]);
                                cubit.changeEditState(isEditing: true);
                                break;
                            }
                          },
                          child: Card(
                            elevation: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  addressDetails[index].name.toLowerCase() ==
                                          'home'
                                      ? Icons.home_outlined
                                      : Icons.work_outline,
                                  size: 62,
                                  color: Colors.green,
                                ),
                                Container(
                                  width: 2,
                                  height: 55,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        addressDetails[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                              color: Colors.teal,
                                            ),
                                      ),
                                      Text(
                                        '${addressDetails[index].city}, '
                                        '${addressDetails[index].region}, '
                                        '${addressDetails[index].details} ',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: cubit.addressGroup.data.data.length,
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 24,
        ),
        onPressed: () {
          pushInStack(context, AddressDetails.ADDRESS_DETAILS);
          cubit.changeEditState(isEditing: false);
        },
      ),
    );
  }
}
