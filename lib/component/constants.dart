import 'package:shop_app/component/ruse_component.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/modules/login/login_screen.dart';

void signOut(context)
{
  CacheHelper.removeData(
    key:'token',
  ).then((value)
  {
    if(value)
    {
      navigateAndFinish(context,LoginScreen());
    }
  });
}

String? token;