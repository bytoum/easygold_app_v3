import 'package:easygold_app_v3/core/constants/enums/data_status.dart';
import 'package:easygold_app_v3/core/widgets/easy_loading_overlay.dart';
import 'package:easygold_app_v3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case DataStatus.loading:
            EasyLoadingOverlay.easyLoadingOverlay();
            break;
          case DataStatus.success:
            EasyLoadingOverlay.dismiss();
            // Navigate to the home page or perform any other action on successful sign-in
            break;
          case DataStatus.failure:
            EasyLoadingOverlay.dismiss();
            final errorMessage = state.errorMessage ?? 'An error occurred';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
            break;
          default:
            EasyLoadingOverlay.dismiss();
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: FormBuilder(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  FormBuilderTextField(
                    name: "phone",
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Phone number is required',
                      ),
                      FormBuilderValidators.numeric(
                        errorText: 'Phone number must be numeric',
                      ),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'password',
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: FormBuilderValidators.required(
                      errorText: 'Password is required',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = formKey.currentState?.value;
                        final phoneNumber = formData?['phone'] as String;
                        final password = formData?['password'] as String;
                        context.read<AuthCubit>().signInWithPassword(
                          phoneNumber: phoneNumber,
                          password: password,
                        );
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
