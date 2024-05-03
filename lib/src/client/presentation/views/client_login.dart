import 'package:flutter/material.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/main_button.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/text_input.dart';

class ClientLoginScreen extends StatelessWidget {
  const ClientLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextInput(
                controller: emailController,
                hintText: 'email',
                validator: (value) {
                  
                },
            ),
            const SizedBox(height: 22.0),
            CustomTextInput(
                controller: passwordController,
                hintText: 'password',
                validator: (value) {
                },
            ),
            const SizedBox(height: 22.0),
            MainButtonWidget(
              text: 'se connecter',
              style: Theme.of(context).textTheme.titleMedium!,
              onPressed: (){
        
              }
            )
        
        
          ],
        ),
      ),
    );
  }
}
