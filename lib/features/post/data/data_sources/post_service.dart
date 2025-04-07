// This file contains the PostApiService class which is responsible for fetching posts from the API.
// class PostApiService{
//   final ApiService api;
//   PostApiService(this.api);
//   Future<List<PostModel>> fetchPosts() async {
//     try {
//       final response = await api.get('posts');
//       return (response as List).map((post) => PostModel.fromJson(post)).toList();
//     } catch (e) {
//       throw Exception('Failed to load posts: $e');
//     }
//   }
// }