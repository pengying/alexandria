import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Prompt extends StatefulWidget {
  @override
  State<Prompt> createState() => _PromptState();
}

class _PromptState extends State<Prompt> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final promptController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ageController.dispose();
    promptController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 10),
          Text(
            "Story Prompt",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              autofocus: true,
              controller: nameController,
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
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: ageController,
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
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an age';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: promptController,
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
                hintText:
                    'A story about kids riding a magic school bus to space and exploring the solar system',
              ),
              maxLines: 4,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a prompt';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating Book')),
                  );  
                }
                log('name: ${nameController.text}');
              },
              child: const Text('Generate'),
            ),
          ),
        ]),
      ),
    );
  }
}
