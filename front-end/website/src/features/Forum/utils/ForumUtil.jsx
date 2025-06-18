// Utility functions
const formatDate = (dateString) => {
  const date = new Date(dateString);
  const now = new Date();
  const diffInHours = (now - date) / (1000 * 60 * 60);
  
  if (diffInHours < 1) return "Vừa xong";
  if (diffInHours < 24) return `${Math.floor(diffInHours)} giờ trước`;
  if (diffInHours < 168) return `${Math.floor(diffInHours / 24)} ngày trước`;
  
  return date.toLocaleDateString('vi-VN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

export { formatDate };