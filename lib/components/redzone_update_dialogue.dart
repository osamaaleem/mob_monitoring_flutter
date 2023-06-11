import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';

class RedzoneUpdateDialogue extends StatelessWidget {
  const RedzoneUpdateDialogue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      //A dialog box to ask the user if they want to add redzone coordinates on not, if they want to add then navigate to next screen else go back
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 8, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Do you want to update redzone coordinates too?',style: Theme.of(context).textTheme.titleMedium,),
            CustomSizedBox.small(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yes')),
                // const SizedBox(
                //   width: 5.0,),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
