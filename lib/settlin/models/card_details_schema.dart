class CardDetailsSchema {
  CardDetailsSchema({
    required this.creditCardNumber,
    required this.securityCode,
    required this.cardHolderName,
    required this.expiryDate,
    required this.zipCode,
    required this.cardName,
    required this.cardDetailsCompleted,
  });

  String creditCardNumber;
  String securityCode;
  String cardHolderName;
  String expiryDate;
  String zipCode;
  String cardName;
  bool cardDetailsCompleted;
}
