

import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/credit_card_model.dart';

class ClientPaymentsCreateController {

  BuildContext context;
  Function refresh;

  String cardNumber='';
  String expiryDate='';
  String cardHolderName='';
  String cvvCode='';
  GlobalKey<FormState> keyForm = new GlobalKey();

  Future init(BuildContext context, Function refresh ){
    this.context = context;
    this.refresh = refresh;
  }


  void onCreditCardModelChanged(CreditCardModel creditCardModel){
    cardNumber = creditCardModel.cardNumber;
    
  }
  
}