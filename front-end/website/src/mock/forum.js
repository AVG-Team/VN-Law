// Mock API service
const apiService = {
  // Posts
  getPosts: async () => {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve({
          data: {
            posts: [
              {
                id: 1,
                title: "Chào mừng đến với diễn đàn pháp luật!",
                content: "Hãy chia sẻ những ý kiến của bạn về pháp luật Việt Nam.",
                author: "Admin",
                created_at: "2024-01-15T10:30:00Z",
                likes: 15,
                comments_count: 8,
                is_pinned: true,
                is_liked: false,
                is_starred: false,
                comments: [
                  {
                    id: 1,
                    content: "Cảm ơn admin đã tạo diễn đàn này!",
                    author: "User1",
                    created_at: "2024-01-15T11:00:00Z",
                    likes: 5,
                    is_liked: false,
                    parent_id: null,
                    replies: [
                      {
                        id: 2,
                        content: "Đồng ý, rất hữu ích!",
                        author: "User2",
                        created_at: "2024-01-15T11:30:00Z",
                        likes: 2,
                        is_liked: false,
                        parent_id: 1
                      }
                    ]
                  }
                ]
              },
              {
                id: 2,
                title: "Thảo luận về Luật Lao động mới",
                content: "Các bạn có ý kiến gì về những thay đổi trong Luật Lao động 2019?",
                author: "LegalExpert",
                created_at: "2024-01-14T09:15:00Z",
                likes: 23,
                comments_count: 12,
                is_pinned: false,
                is_liked: true,
                is_starred: false,
                comments: []
              }
            ]
          }
        });
      }, 1000);
    });
  },

  createPost: async (postData) => {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve({
          data: {
            post: {
              id: Date.now(),
              ...postData,
              author: "Current User",
              created_at: new Date().toISOString(),
              likes: 0,
              comments_count: 0,
              is_pinned: false,
              is_liked: false,
              is_starred: false,
              comments: []
            }
          }
        });
      }, 500);
    });
  },

  likePost: async (postId) => {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve({ data: { action: "like" } });
      }, 300);
    });
  },

  createComment: async (postId, commentData) => {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve({
          data: {
            comment: {
              id: Date.now(),
              ...commentData,
              author: "Current User",
              created_at: new Date().toISOString(),
              likes: 0,
              is_liked: false,
              replies: []
            }
          }
        });
      }, 500);
    });
  }
};

export default apiService;