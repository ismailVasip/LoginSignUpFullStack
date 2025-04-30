abstract class Usecase<SuccessType,Param> {
  Future<SuccessType> call({Param param});
}