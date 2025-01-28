Future<void> _fetchAddressSuggestions(String input) async {
  setState(() {
    _isLoadingSuggestions = true; // Show loading indicator
  });
  
  final String apiKey = googlemapkey.mapkey; // Replace with your API key
  final String url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];
      for (var prediction in data['predictions']) {
        suggestions.add(prediction['description']);
      }
      setState(() {
        _addressSuggestions = suggestions; // Update suggestions
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  } catch (e) {
    print("Error fetching suggestions: $e");
  } finally {
    setState(() {
      _isLoadingSuggestions = false; // Hide loading indicator
    });
  }
}