import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'chat_api.g.dart';

@RestApi()
abstract class ChatApi {
  factory ChatApi(Dio dio) = _ChatApi;

  @GET('ai/history')
  Future<dynamic> getChatHistory();
}
