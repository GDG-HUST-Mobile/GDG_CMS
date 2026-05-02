# 📘 Tài liệu Kỹ thuật GDG CMS API cho AI Agents

Tài liệu này cung cấp chi tiết về các điểm cuối (endpoints), cấu trúc dữ liệu và cơ chế xác thực của hệ thống quản trị nội dung GDG CMS.

**Base URL:** `https://gdg-cms.vercel.app/`

---

## 🔐 Cơ chế Xác thực (Authentication)

Dự án sử dụng cơ chế xác thực dựa trên Token (Bearer Token).

* **Header yêu cầu:** Đối với các API yêu cầu quyền truy cập, Agent phải thêm header:
    * `Content-Type: application/json`
    * `authorization: Bearer <accessToken>`
* **Vòng đời Token:**
    * Sử dụng `accessToken` cho các tác vụ thông thường.
    * Khi `accessToken` hết hạn, sử dụng `refreshToken` để lấy token mới qua endpoint `/refresh`.

---

## 🛠 Danh sách Endpoints

### 1. Quản lý Tài khoản (Auth)

| Phương thức | Endpoint | Công dụng | Yêu cầu Header |
| :--- | :--- | :--- | :--- |
| **POST** | `/register` | Đăng ký tài khoản mới | JSON |
| **POST** | `/login` | Đăng nhập lấy cặp Token | JSON |
| **POST** | `/refresh` | Làm mới `accessToken` | JSON |
| **POST** | `/logout` | Đăng xuất tài khoản | JSON |

**Cấu trúc Request Đăng ký (`/register`):**
```json
{
  "username": "string",
  "password": "string",
  "firstName": "string",
  "lastName": "string",
  "email": "string"
}
```

---

### 2. Quản lý Bài viết (Posts)

Xử lý các nội dung bài đăng trên hệ thống. Yêu cầu Bearer Token cho các tác vụ thay đổi dữ liệu.

* **GET `/posts`**: Lấy toàn bộ bài viết.
* **GET `/posts/:id`**: Lấy chi tiết một bài viết cụ thể qua thông số id.
* **POST `/posts`**: Tạo bài viết mới. Yêu cầu `title`, `content`, `author`.
* **PUT `/posts/:id`**: Cập nhật bài viết dựa trên id. Chỉ gửi các trường cần thay đổi.
* **DELETE `/posts/:id`**: Xóa bài viết khỏi hệ thống bằng id.

**Mô hình dữ liệu Post:**
* `id` (int)
* `title` (string)
* `content` (string)
* `author` (string)
* `vote` (int - mặc định: 0)

---

### 3. Quản lý Sự kiện (Events)

Xử lý các sự kiện của câu lạc bộ. Mọi thao tác đều yêu cầu Bearer Token.

* **GET `/events`**: Lấy danh sách toàn bộ sự kiện hoặc chi tiết qua `/:id`.
* **POST `/events`**: Tạo sự kiện mới.
* **PUT `/events/:id`**: Chỉnh sửa thông tin sự kiện theo id.
* **DELETE `/events/:id`**: Xóa sự kiện theo id.

**Mô hình dữ liệu Event:**
* `notifyTo` (string[]): Danh sách vai trò nhận thông báo (VD: `["Member", "Leader"]`).
* `confirmed` (string[]): Danh sách username đã xác nhận tham gia.
* `vote` (int): Số lượt bình chọn.

---

## 📊 Bảng Quy định Giá trị (Data Schemas)

### Người dùng (User)
| Trường | Kiểu dữ liệu | Ghi chú |
| :--- | :--- | :--- |
| `username` | string | Định danh duy nhất |
| `role` | string | Mặc định là "Member" |
| `email` | string | Định dạng email hợp lệ |

### Phản hồi lỗi & Thành công
* **Thành công:** Trả về đối tượng JSON chứa dữ liệu yêu cầu hoặc thông báo xác nhận.
* **Lỗi:** Các lỗi phổ biến bao gồm sai Token, thiếu trường bắt buộc hoặc sai định dạng JSON.

---

**Lưu ý cho AI Agent:** Luôn kiểm tra tính khả dụng của `accessToken` trước khi thực hiện các yêu cầu POST/PUT/DELETE. Nếu nhận phản hồi lỗi xác thực, hãy tự động thực hiện quy trình `refresh` token.