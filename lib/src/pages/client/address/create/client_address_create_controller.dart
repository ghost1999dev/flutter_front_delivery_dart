import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/Models/response_api.dart';
import 'package:flutter_delivery/src/Models/user.dart';
import 'package:flutter_delivery/src/pages/client/address/map/client_address_map_pages.dart';
import 'package:flutter_delivery/src/provider/address_provaider.dart';
import 'package:flutter_delivery/src/utils/my_snackbar.dart';
import 'package:flutter_delivery/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_delivery/src/Models/address.dart';
class ClientAddressCreateController{


  BuildContext context;
  Function refresh;
  TextEditingController refPointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController neighborhoodController = new TextEditingController();
  AddressProvaider _addressProvaider = new AddressProvaider();
  User user;

  SharedPref _sharedPref = new SharedPref();
  Map<String,dynamic> refPoint;
  List<Adress> address=[];
  Future init(BuildContext context, refresh) async{
    this.context=context;
    this.refresh=refresh;
    user=User.fromJson(await _sharedPref.read('user'));
    _addressProvaider.init(context, user);
  }

  void createAddress()async{
    String addressName= addressController.text;
    String neighborhood=neighborhoodController.text;
    double lat = refPoint['lat'] ?? 0;
    double lng = refPoint['lng'] ?? 0;
    if(addressName.isEmpty || neighborhood.isEmpty || lat==0 || lng==0){
      MySnackbar.show(context, "Completa todos los campos");
      return;
    }
    Adress address=new Adress(
      address: addressName,
      neighborhood: neighborhood,
      lat: lat,
      lng: lng,
      idUser: user.id
    );
    ResponseApi responseApi=await _addressProvaider.create(address);

    if(responseApi.success){

      address.id=responseApi.data;

      print(' Respuesta address ${responseApi.data}');
      _sharedPref.save('address', address);
      MySnackbar.show(context, "Direccion creada exitosamente");
      Navigator.pop(context,true);
    }
  }

  void openMap() async{
    refPoint= await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context)=> ClientAddressMapPage()
    );
    if(refPoint != null){
      refPointController.text= refPoint['address'];
      refresh();
    }
  }


}