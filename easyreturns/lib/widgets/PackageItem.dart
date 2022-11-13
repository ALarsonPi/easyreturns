import 'package:easyreturns/widgets/CustomInput.dart';
import 'package:flutter/material.dart';

class PackageItem extends StatefulWidget {
  var elevatedButtonStyle;
  bool isFirst;
  TextEditingController descriptionController;
  Function removeThisItemCallback;
  int indexInList;
  PackageItem({
    super.key,
    required this.elevatedButtonStyle,
    required this.descriptionController,
    required this.removeThisItemCallback,
    required this.indexInList,
    this.isFirst = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _PackageItem();
  }
}

class _PackageItem extends State<PackageItem> {
  final String uploadString = "upload";
  final String leaveOutsideString = "LeaveOutside";
  String? currentRadioOptionChosen = "";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 0.0,
      dense: false,
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      trailing: SizedBox(
        height: double.infinity,
        child: GestureDetector(
          onTap: () => {
            widget.removeThisItemCallback(widget),
          },
          child: Visibility(
            visible: !widget.isFirst,
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      ),
      title: Column(
        children: [
          CustomInput(
            hint: "What are you returning? (single item)",
            inputBorder: const OutlineInputBorder(),
            minlines: 2,
            controller: widget.descriptionController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              "How will you include the Amazon QR Return Code?",
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: RadioListTile<String>(
                    title: const Text('Upload'),
                    value: uploadString,
                    groupValue: currentRadioOptionChosen,
                    onChanged: (String? value) {
                      setState(() {
                        currentRadioOptionChosen = value;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: (currentRadioOptionChosen == uploadString),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                    onPressed: () => {},
                    style: widget.elevatedButtonStyle,
                    child: const Text(
                      "Upload QR Code",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          RadioListTile<String>(
            title: const Text('Leave it with my stuff'),
            value: leaveOutsideString,
            groupValue: currentRadioOptionChosen,
            onChanged: (String? value) {
              setState(() {
                currentRadioOptionChosen = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
