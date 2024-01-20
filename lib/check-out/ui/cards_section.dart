import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/check-out/provider/check_out.dart';
import 'package:flutter_application_1/settlin/models/card_details_schema.dart';
import 'package:flutter_application_1/settlin/utils/loading_animation.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class CardsCarousel extends StatefulWidget {
  const CardsCarousel({super.key});

  @override
  State<CardsCarousel> createState() => _CardsCarouselState();
}

class _CardsCarouselState extends State<CardsCarousel> {
  CheckOutProvider? checkOutProvider;

  int currentIndex = 0;
  final TextEditingController _creditCardNumberController =
      TextEditingController();

  final TextEditingController _expiryDateController = TextEditingController();

  final TextEditingController _securityCodeController = TextEditingController();

  final TextEditingController _cardHolderController = TextEditingController();

  final TextEditingController _zipCodeController = TextEditingController();

  bool isEnteredCardValid = false;

  void _formatCreditCardNumber() {
    String enteredText = _creditCardNumberController.text;

    // Remove existing spaces and any leading/trailing spaces
    enteredText = enteredText.replaceAll(' ', '').trim();

    // Add space every four digits from the right
    String formattedText = '';
    int length = enteredText.length;
    int spaceCount = (length / 4).floor();
    for (int i = 0; i < spaceCount; i++) {
      int startIndex = length - (i + 1) * 4;
      int endIndex = length - i * 4;
      if (startIndex < 0) startIndex = 0;
      formattedText =
          ' ${enteredText.substring(startIndex, endIndex)}$formattedText';
    }
    formattedText = enteredText.substring(0, length % 4) + formattedText;

    if (formattedText.startsWith(' ')) {
      formattedText = formattedText.replaceFirst(' ', '');
    }
    _creditCardNumberController.text = formattedText;
  }

  void _formatExpiryDate() {
    String enteredText = _expiryDateController.text;

    enteredText = enteredText.replaceAll('/', '').trim();

    String formattedText = '';
    int length = enteredText.length;
    int spaceCount = (length / 2).floor();
    for (int i = 0; i < spaceCount; i++) {
      int startIndex = length - (i + 1) * 2;
      int endIndex = length - i * 2;
      if (startIndex < 0) startIndex = 0;
      formattedText =
          '/${enteredText.substring(startIndex, endIndex)}$formattedText';
    }
    formattedText = enteredText.substring(0, length % 2) + formattedText;

    if (formattedText.startsWith('/')) {
      formattedText = formattedText.replaceFirst('/', '');
    }
    _expiryDateController.text = formattedText;
  }

  void activatePayAndContinueButton() {
    isEnteredCardValid = (_creditCardNumberController.text.length > 18 &&
        _securityCodeController.text.length > 2 &&
        _cardHolderController.text.isNotEmpty &&
        _expiryDateController.text.length > 3 &&
        _zipCodeController.text.length > 5);
    checkOutProvider?.isPayButtonEnabled =
        (_creditCardNumberController.text.length > 18 &&
            _securityCodeController.text.length > 2 &&
            _cardHolderController.text.isNotEmpty &&
            _expiryDateController.text.length > 3 &&
            _zipCodeController.text.length > 5);
    checkOutProvider?.notify();
    setState(() {});
  }

  void setValues(CardDetailsSchema details) {
    _creditCardNumberController.text = details.creditCardNumber;
    _securityCodeController.text = details.securityCode;
    _cardHolderController.text = details.cardHolderName;
    _expiryDateController.text = details.expiryDate;
    _zipCodeController.text = details.zipCode;
    _formatExpiryDate();
    _formatCreditCardNumber();
    activatePayAndContinueButton();
  }

  void addCard() {
    //remove the card if credit card number is not entered
    checkOutProvider?.userCards
        .removeWhere((element) => element.creditCardNumber.isEmpty);
    //zoom in effect only when new card is added
    checkOutProvider?.zoomInCard = true;
    //adds new card at 0th index
    checkOutProvider?.userCards.insert(
      0,
      CardDetailsSchema(
        creditCardNumber: '',
        securityCode: '',
        cardHolderName: '',
        expiryDate: '',
        zipCode: '',
        cardName: '',
        cardDetailsCompleted: false,
      ),
    );
    checkOutProvider?.notify();
    setState(() {});
    checkOutProvider?.carouselController.animateToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    checkOutProvider ??= context.read<CheckOutProvider>();
    return Consumer(
      builder: (context, CheckOutProvider checkOutProvider, child) =>
          CarouselSlider(
        carouselController: checkOutProvider.carouselController,
        options: CarouselOptions(
          onPageChanged: (index, reason) {
            currentIndex = index;
            if (index == checkOutProvider.userCards.length) {
              checkOutProvider.isPayButtonEnabled = false;
              setValues(CardDetailsSchema(
                creditCardNumber: '',
                securityCode: '',
                cardHolderName: '',
                expiryDate: '',
                zipCode: '',
                cardName: '',
                cardDetailsCompleted: false,
              ));
            } else {
              setValues(checkOutProvider.userCards[index]);
            }
          },
          viewportFraction: 1,
          autoPlay: false,
          height: 278,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: true,
          enableInfiniteScroll: false,
        ),
        items: [
          ...checkOutProvider.userCards
              .map(
                (e) => PlayAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1),
                  onCompleted: () {
                    checkOutProvider.zoomInCard = false;
                  },
                  duration: Duration(
                      milliseconds: checkOutProvider.zoomInCard ? 600 : 0),
                  curve: Curves.ease,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 5),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color.fromARGB(255, 46, 71, 69),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      offset: const Offset(0.0, 5.0),
                                      blurRadius: 15.0,
                                      spreadRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Credit Card Number',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  height: 22,
                                                  child: DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 0.6,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _creditCardNumberController,
                                                      onChanged: (val) {
                                                        _formatCreditCardNumber();
                                                        e.creditCardNumber =
                                                            val;
                                                        activatePayAndContinueButton();
                                                      },
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        letterSpacing: 2,
                                                        color: Colors.white,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                "[0-9 ]+")),
                                                        LengthLimitingTextInputFormatter(
                                                            19),
                                                      ],
                                                      enableInteractiveSelection:
                                                          false,
                                                      showCursor: false,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 30),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Security Code',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  height: 22,
                                                  width: 55,
                                                  child: DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 0.6,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        e.securityCode = value;
                                                        activatePayAndContinueButton();
                                                      },
                                                      controller:
                                                          _securityCodeController,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        letterSpacing: 2,
                                                        color: Colors.white,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                "[0-9]")),
                                                        LengthLimitingTextInputFormatter(
                                                            3),
                                                      ],
                                                      enableInteractiveSelection:
                                                          false,
                                                      showCursor: false,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Card Holder',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  height: 22,
                                                  child: DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 0.6,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        e.cardHolderName =
                                                            value;
                                                        activatePayAndContinueButton();
                                                      },
                                                      controller:
                                                          _cardHolderController,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        letterSpacing: 2,
                                                        color: Colors.white,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp("[a-z A-Z]"),
                                                        ),
                                                        LengthLimitingTextInputFormatter(
                                                          20,
                                                        ),
                                                      ],
                                                      enableInteractiveSelection:
                                                          false,
                                                      showCursor: false,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 30),
                                          const Spacer(flex: 2),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Exp. Date',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  height: 22,
                                                  width: 70,
                                                  child: DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 0.6,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _expiryDateController,
                                                      onChanged: (value) {
                                                        e.expiryDate = value;
                                                        activatePayAndContinueButton();
                                                        _formatExpiryDate();
                                                      },
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        letterSpacing: 2,
                                                        color: Colors.white,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                "[0-9/]+")),
                                                        LengthLimitingTextInputFormatter(
                                                            5),
                                                      ],
                                                      enableInteractiveSelection:
                                                          false,
                                                      showCursor: false,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Zip Code',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  height: 22,
                                                  width: 75,
                                                  child: DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 0.6,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        e.zipCode = value;
                                                        activatePayAndContinueButton();
                                                      },
                                                      controller:
                                                          _zipCodeController,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        letterSpacing: 2,
                                                        color: Colors.white,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                "[0-9]")),
                                                        LengthLimitingTextInputFormatter(
                                                            6),
                                                      ],
                                                      enableInteractiveSelection:
                                                          false,
                                                      showCursor: false,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Consumer(builder: (context,
                                                CheckOutProvider
                                                    checkOutProvider,
                                                child) {
                                              return e.creditCardNumber.length >
                                                      18
                                                  ? const AnimatedCardName()
                                                  : const SizedBox();
                                            }),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 0),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (!e.cardDetailsCompleted)
                            _SubmitCard(
                              isCardValid: isEnteredCardValid,
                              index: checkOutProvider.userCards.indexOf(e),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              )
              .toList(),
          _AddCard(onTap: addCard),
        ],
      ),
    );
  }
}

class _SubmitCard extends StatefulWidget {
  const _SubmitCard({
    required this.isCardValid,
    required this.index,
  });
  final bool isCardValid;
  final int index;

  @override
  State<_SubmitCard> createState() => _SubmitCardState();
}

class _SubmitCardState extends State<_SubmitCard> {
  bool loaderVisible = false;

  Control control = Control.stop;

  @override
  void initState() {
    super.initState();
  }

  void replaceWidget() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        loaderVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, CheckOutProvider checkOutProvider, child) =>
          checkOutProvider.userCards[widget.index].cardDetailsCompleted
              ? const SizedBox()
              : CustomAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  control: control,
                  tween: Tween(
                      begin: 0.0, end: -MediaQuery.of(context).size.width / 4),
                  builder: (context, value, child) {
                    return Stack(
                      children: [
                        IgnorePointer(
                          ignoring: control == Control.stop,
                          child: CustomAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 600),
                            control: control,
                            tween: Tween(begin: 0.0, end: 1),
                            builder: (context, value, child) => AnimatedOpacity(
                              opacity: value,
                              duration: const Duration(milliseconds: 600),
                              child: Center(
                                child: Container(
                                  width: double.infinity,
                                  height: 220,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        const Color.fromARGB(255, 46, 71, 69),
                                  ),
                                  child: !loaderVisible
                                      ? const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 48),
                                            Align(
                                              alignment: Alignment(-0.35, 0.3),
                                              child: LoadingAnimation(),
                                            ),
                                            SizedBox(height: 48),
                                            Text(
                                              'Verifying your card',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: Color.fromARGB(
                                                  255, 231, 144, 14),
                                              size: 48,
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              'Successfully verified',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(value, 0),
                          child: child,
                        ),
                      ],
                    );
                  },
                  child: CustomAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    control: control,
                    tween: Tween(begin: 1, end: 0),
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (widget.isCardValid) {
                          Future.delayed(
                            const Duration(seconds: 4),
                            () {
                              checkOutProvider.userCards[widget.index]
                                  .cardDetailsCompleted = true;
                              checkOutProvider.notify();
                            },
                          );
                          replaceWidget();
                          control = Control.play;
                          setState(() {});
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !widget.isCardValid
                                ? Colors.grey
                                : const Color.fromARGB(255, 231, 144, 14),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}

class _AddCard extends StatelessWidget {
  const _AddCard({
    required this.onTap,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
          width: 1,
        ),
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 231, 144, 14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add a new card',
                style: TextStyle(
                  color: Color.fromARGB(255, 231, 144, 14),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCardName extends StatefulWidget {
  const AnimatedCardName({Key? key}) : super(key: key);

  @override
  _AnimatedCardNameState createState() => _AnimatedCardNameState();
}

// Add AnimationMixin to state class
class _AnimatedCardNameState extends State<AnimatedCardName> {
  Control control = Control.play; // state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      control: control, // bind state variable to parameter
      tween: Tween(begin: -50.0, end: 0.0),
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value / 50 + 1,
          // opacity: 1,
          duration: const Duration(milliseconds: 300),
          child: Transform.translate(
            // animation that moves childs from left to right
            offset: Offset(20, value),
            child: child,
          ),
        );
      },
      child: const Text(
        'VISA',
        style: TextStyle(
          fontSize: 28,
          color: Colors.white,
        ),
      ),
    );
  }
}
