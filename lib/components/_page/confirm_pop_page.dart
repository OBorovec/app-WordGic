import 'package:flutter/material.dart';

class PopDialogPage extends StatefulWidget {
  final Widget body;
  final String popDialogTitle;
  final String popDialogText;
  final List<Widget> controlButtons;

  const PopDialogPage({
    Key? key,
    required this.body,
    required this.popDialogTitle,
    required this.popDialogText,
    this.controlButtons = const <Widget>[],
  }) : super(key: key);

  @override
  State<PopDialogPage> createState() => _PopDialogPagetate();
}

class _PopDialogPagetate extends State<PopDialogPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: widget.body),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        onWillPop().then((value) {
                          if (value) Navigator.of(context).pop();
                        });
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                    ...widget.controlButtons,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(widget.popDialogTitle),
            content: Text(widget.popDialogText),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
