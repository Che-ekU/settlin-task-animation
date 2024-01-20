import 'package:flutter/material.dart';
import 'package:flutter_application_1/check-out/provider/check_out.dart';
import 'package:flutter_application_1/check-out/ui/cards_section.dart';
import 'package:flutter_application_1/check-out/ui/order_details_card.dart';
import 'package:flutter_application_1/settlin/utils/loading_animation.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Check Out',
          style: TextStyle(
            fontSize: 28,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: Transform.scale(
          scale: 1.5,
          // scaleX: 1.5,
          child: const BackButton(),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            CardsCarousel(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: OrderDetailsCard(),
            ),
            _PayButton()
          ],
        ),
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  const _PayButton();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, CheckOutProvider checkOutProvider, child) =>
          IgnorePointer(
        ignoring: !checkOutProvider.isPayButtonEnabled,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              if (checkOutProvider.isPayButtonEnabled)
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 231, 144, 14).withOpacity(0.3),
                  offset: const Offset(
                    0.0,
                    5.0,
                  ),
                  blurRadius: 5.0,
                  spreadRadius: 5.0,
                ),
            ],
            color: checkOutProvider.isPayButtonEnabled
                ? const Color.fromARGB(255, 231, 144, 14)
                : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const _SuccessPage(),
                    transitionDuration: const Duration(seconds: 1),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: const Text(
                  'Pay It',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessPage extends StatefulWidget {
  const _SuccessPage();

  @override
  State<_SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<_SuccessPage> {
  bool loaderVisible = false;

  void replaceWidget() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        loaderVisible = true;
      });
    });
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    replaceWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 133, 0),
      body: Center(
        child: !loaderVisible
            ? const Padding(
                padding: EdgeInsets.only(right: 120.0),
                child: LoadingAnimation(),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.white,
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
    );
  }
}
