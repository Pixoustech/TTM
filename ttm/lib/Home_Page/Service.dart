import '../Comman_pages/Constant.dart';
import 'Home_page.dart';
import 'model.dart'; // Make sure to import your model classes

class DataService {
  final String userId;

  DataService(this.userId);

  Future<HomePageData> fetchData(String filterType) async {
    final url = '/Event/Event_Master_Get?userId=$userId&FilterType=$filterType';

    try {
      final response = await AppApi.dio.get(url);
      if (response.statusCode == 200) {
        final jsonData = response.data; // No need to decode, Dio does it for you
        final eventResponse = EventResponse.fromJson(jsonData);
        return HomePageData(
          tasks: eventResponse.data.tasks,
          meetings: eventResponse.data.meetings,
        );
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<HomePageDatastatusbased> fetchData1() async {
    final url = '/Event/Event_Master_Get?userId=$userId';

    try {
      final response = await AppApi.dio.get(url);
      if (response.statusCode == 200) {
        final jsonData = response.data; // No need to decode, Dio does it for you
        final eventResponse = EventResponsestatusbased.fromJson(jsonData);
        return HomePageDatastatusbased(
          tasks: eventResponse.data.tasks,
          meetings: eventResponse.data.meetings,
        );
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}