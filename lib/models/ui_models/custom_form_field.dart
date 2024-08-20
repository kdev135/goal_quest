import 'package:flutter/material.dart';
import 'package:goal_quest/styles.dart';

import '../../utils/operations/email_validation.dart';


class CustomFormField extends StatelessWidget {
  CustomFormField({
    super.key,
    required this.hintText,
    required this.fieldLabel,
    required this.textEditingController,
    this.linecount = 1,
    this.obscureText = false,
    this.shouldValidate = true,
    this.isEmail = false,
    this.onEditingComplete,
    this.isNumber = false,
    this.maxLength = 50,
    this.showCharacterCount = false,
  });

  final String hintText;
  final int linecount;
  final String fieldLabel;
  final TextEditingController textEditingController;
  final bool shouldValidate;
  final bool obscureText;
  final bool isEmail;
  final bool isNumber;
  final Function? onEditingComplete;
  final FocusNode focusNode = FocusNode();
  final int maxLength;
  final bool showCharacterCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              fieldLabel,
              style: AppTextStyles.labelText,
            ),
          ),
          TextFormField(
            maxLines: linecount,
        textInputAction: linecount > 1 ? TextInputAction.next : TextInputAction.done,
            style: AppTextStyles.bodyText2,
            controller: textEditingController,
            textCapitalization: TextCapitalization.sentences,
            maxLength: showCharacterCount ? maxLength : null,
            keyboardType: isNumber ? TextInputType.number : null,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodyText1.copyWith(color: Theme.of(context).hintColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              fillColor: Theme.of(context).hoverColor,
              counterText: showCharacterCount ? null : '',
            ),
            obscureText: obscureText,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: !shouldValidate
                ? null
                : (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (isEmail && !isValidEmail(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
            onFieldSubmitted: (value) {
              if (onEditingComplete != null) {
      onEditingComplete!(value);
    } else {
      FocusScope.of(context).nextFocus();
    }
            },
          ),
        ],
      ),
    );
  }
}