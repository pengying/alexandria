import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Prompt extends StatefulWidget {
  @override
  State<Prompt> createState() => _PromptState();
}

class _PromptState extends State<Prompt> {
  String name = "";
  String prompt = "";
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        TextFormField(
          decoration: const InputDecoration(
            label: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  WidgetSpan(
                    child: Text(
                      'Name',
                    ),
                  ),
                  WidgetSpan(
                    child: Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            border: OutlineInputBorder(),

          ),
          keyboardType: TextInputType.name,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  WidgetSpan(
                    child: Text(
                      'Age',
                    ),
                  ),
                  WidgetSpan(
                    child: Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  WidgetSpan(
                    child: Text(
                      'Story Prompt',
                    ),
                  ),
                  WidgetSpan(
                    child: Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            hintText: 'A story about kids going to space and exploring the solar system',
          ),
          maxLines: 4,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a prompt';
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (_formKey.currentState!.validate()) {
                // Process data.
              }
            },
            child: const Text('Generate'),
          ),
        ),
      ]),
    );
  }
}
