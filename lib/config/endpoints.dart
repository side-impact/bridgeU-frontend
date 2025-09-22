// API호출 endpoint 관리
class EP {
  // Posts API
  static const posts = '/api/posts';
  static const postsHot = '/api/posts/hot';
  static String postDetail(String postId) => '/api/posts/$postId';
  
  //예시
  //static const loginGoogle = '/api/auth/login/google';
  //static const translate = '/api/translate';
  //static const faq = '/api/school/faq';
}
