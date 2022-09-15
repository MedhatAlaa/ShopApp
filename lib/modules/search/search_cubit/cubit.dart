import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/constants.dart';
import 'package:shop_app/component/end_points.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/search_cubit/states.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  GetSearchModel? searchModel;

  void getSearch({required String? text}) {
    emit(SearchLoadingState());
    DioHelper.postData(
      url: getSearchProduct,
      data: {'text': text},
      token: token,
    ).then((value) {
      searchModel = GetSearchModel.fromJson(value.data);
      print(searchModel!.status);
      print(searchModel!.data!.data.toString());
      emit(SearchSuccessState());
    }).catchError((error) {
      print('error when getting search${error.toString()}');
      emit(SearchErrorState());
    });
  }
}
