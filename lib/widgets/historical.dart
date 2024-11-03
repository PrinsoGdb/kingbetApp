import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Column,
        SizedBox,
        Card,
        Colors,
        Container,
        BoxDecoration,
        BorderRadius;

import 'package:flutter/widgets.dart';
import 'package:king_bet/models/transaction.dart';
import 'package:shimmer/shimmer.dart';
import 'package:king_bet/utilities/color.dart';

class Historical extends StatefulWidget {
  final List<Transaction> transactions;
  final bool isLoading;
  const Historical({super.key, required this.transactions, required this.isLoading});

  @override
  State<Historical> createState() => _HistoricalState();
}

class _HistoricalState extends State<Historical> {
  int currentIndex = 1;

  String _getOperationStatusName(String? status) {
    String statusName = "Refusé";

    if (status == "Validé") {
      statusName = "Validé";
    } else if (status == "En cours") {
      statusName = "En cours";
    }

    return statusName;
  }

  Color _getOperationStatusColor(String? status) {
    Color statusColor = const Color.fromRGBO(239, 79, 43, 1);

    if (status == "Validé") {
      statusColor = const Color.fromRGBO(8, 179, 56, 1);
    } else if (status == "on_hold") {
      statusColor = const Color.fromRGBO(220, 133, 3, 1);
    }

    return statusColor;
  }

  Widget _buildSkeleton() {
    return Card(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    margin: const EdgeInsets.only(bottom: 10.0),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: AppColor.grayColor,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100,
                  height: 12,
                  color: Colors.white,
                ),
              ),
              Shimmer.fromColors(
                baseColor: AppColor.grayColor,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 60,
                  height: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(80, 80, 80, 1),
                  borderRadius: BorderRadius.circular(100),
                ),
                margin: const EdgeInsets.only(right: 10.0),
                height: 80,
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: AppColor.grayColor
              ,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 10,
                                  width: 100,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 2),
                              Shimmer.fromColors(
                                baseColor: AppColor.grayColor
              ,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 10,
                                  width: 100,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 2),
                              Shimmer.fromColors(
                                baseColor: AppColor.grayColor
              ,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 10,
                                  width: 100,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 2),
                              Shimmer.fromColors(
                                baseColor: AppColor.grayColor
              ,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 10,
                                  width: 100,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 2),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Shimmer.fromColors(
                                baseColor: AppColor.grayColor
              ,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 10,
                                  width: 80,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Shimmer.fromColors(
                                baseColor: AppColor.grayColor
              ,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 10,
                                  width: 80,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Shimmer.fromColors(
                                baseColor: AppColor.grayColor
              ,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 10,
                                  width: 80,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Shimmer.fromColors(
                                baseColor: AppColor.grayColor
              ,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 10,
                                  width: 80,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        child: Center(
          child: Text(
            "Vos dix dernières transactions",
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      ),
      Container(
          margin: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
          child: widget.isLoading ? _buildSkeleton() : Column(
            children: List.generate(
                widget.transactions.length,
                (int index) => Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    margin: index != widget.transactions.length - 1
                        ? const EdgeInsets.only(bottom: 10.0)
                        : const EdgeInsets.all(0),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    // TextSpan(
                                    //   style: const TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.black,
                                    //   ),
                                    //   text: '${widget.transactions[index].createdAt}',
                                    // ),
                                    TextSpan(
                                      text:
                                          '(${_getOperationStatusName(widget.transactions[index].statutOperation)})',
                                      style: TextStyle(
                                          color: _getOperationStatusColor(
                                              widget.transactions[index].statutOperation),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${widget.transactions[index].montantOperation} FCFA',
                                style: const TextStyle(
                                  color: AppColor.yellowColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(80, 80, 80, 1),
                                    borderRadius: BorderRadius.circular(100)),
                                margin: const EdgeInsets.only(right: 10.0),
                                height: 80,
                                width: 8,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Type d’opération : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: 2,
                                                // ),
                                                // Text(
                                                //   "Référence : ",
                                                //   style: TextStyle(
                                                //     color: Colors.black,
                                                //     fontSize: 10,
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "Heure : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "Numero du deposant : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "Nom du deposant : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  widget.transactions[index].typeOperation!,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                // const SizedBox(
                                                //   height: 2,
                                                // ),
                                                // Text(
                                                //   widget.transactions[index].transId!,
                                                //   style: const TextStyle(
                                                //     color: Colors.black,
                                                //     fontSize: 10,
                                                //   ),
                                                // ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  '${widget.transactions[index].createdAt}',                                                 style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  widget.transactions[index].numeroReccepteur!,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  widget.transactions[index].nomReccepteur!,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ))),
          )),
    ]);
  }
}
