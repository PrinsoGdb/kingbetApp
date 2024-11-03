import 'package:flutter/material.dart';
import 'package:king_bet/models/transaction.dart';
import 'package:king_bet/services/transaction.dart';
import 'package:king_bet/views/success_transaction.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPayment extends StatefulWidget {
  final String transactionUrl;
  final int transactionId;
  final Transaction transaction; 

  const WebPayment({super.key, required this.transactionUrl, required this.transactionId, required this.transaction});

  @override
  State<WebPayment> createState() => _WebPaymentState();
}

class _WebPaymentState extends State<WebPayment> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar if needed.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('http://king-power-recharges.com')) {
              _onStartDeposit();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.transactionUrl));
  }

  Future<void> _onStartDeposit() async {
    try {
      // Make the registration API call
      final response = await TransactionService.makeOperation(widget.transaction);

      if ((response.statusCode == 200) && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SuccessTransactionPage(bookmaker: widget.transaction.bookmaker!)),
          (Route<dynamic> route) => false,
        );
      } else if (mounted) {
        // Handle other statuses if necessary
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Une erreur s\'est produite. Veuillez réessayer plus tard.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Paiement",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}