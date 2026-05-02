# 📑 QUY ĐỊNH PHÂN NHÁNH (BRANCHING POLICY) - GDG CMS PROJECT

Tài liệu này hướng dẫn cách quản lý luồng code (Git Flow) dành cho các lập trình viên tham gia phát triển dự án GDG CMS. Mục tiêu là đảm bảo tính ổn định của mã nguồn, dễ dàng tra cứu lịch sử và tối ưu hóa phối hợp nhóm.

## 1. Mô hình Phân nhánh (GitFlow Model)

Dự án áp dụng mô hình **GitFlow cải tiến**, tách biệt rõ ràng giữa môi trường phát triển và môi trường ổn định.  

### 🔹 Các nhánh chính (Long-lived Branches)
* **`main`**:
    * Chứa mã nguồn sạch nhất, đã qua kiểm thử (Production-ready).
    * **Quy tắc:** Tuyệt đối không commit trực tiếp. Chỉ nhận code từ các nhánh `hotfix/` hoặc `develop` thông qua Pull Request.
* **`develop`**:
    * Nhánh tích hợp chính (Integration branch).
    * Nơi tập hợp tất cả các tính năng mới đã hoàn thiện để chuẩn bị cho các bản release tiếp theo.

## 2. Các nhánh tạm thời (Short-lived Branches)

Mọi tác vụ lập trình phải được thực hiện trên các nhánh phụ. Tên nhánh phải tuân thủ tiền tố quy định:

### 🧩 Nhánh Tính năng (`feature/`)
Dùng để phát triển các module hoặc tính năng mới.
* **Cấu trúc:** `feature/feature-name` hoặc `feature/short-description`
* **Ví dụ:** `feature/login-ui`, `feature/api-auth-service`, `feature/home-calendar`

### 🛠️ Nhánh Sửa lỗi (`fix/`)
Dùng để sửa các lỗi (bugs) phát hiện trên nhánh `develop`.
* **Ví dụ:** `fix/login-overflow-error`, `fix/token-refresh-logic`

### 🚨 Nhánh Sửa lỗi khẩn cấp (`hotfix/`)
Dùng để sửa các lỗi nghiêm trọng ảnh hưởng trực tiếp đến người dùng trên nhánh `main`.
* **Ví dụ:** `hotfix/crash-on-ios-startup`

## 3. Workflow

1.  **Cập nhật code mới nhất:** Luôn xuất phát từ nhánh `develop` mới nhất.
    ```bash
    git checkout develop
    git pull origin develop
    ```
2.  **Tạo nhánh mới:**
    ```bash
    git checkout -b feature/ten-tinh-nang
    ```
3.  **Đồng bộ thường xuyên (Sync):** Trước khi hoàn tất, hãy gộp code mới nhất từ `develop` để giải quyết xung đột (Conflict) sớm.
    ```bash
    git fetch origin
    git merge origin/develop
    ```
4.  **Tạo Pull Request (PR):** Đẩy nhánh lên remote và tạo PR trên GitHub/GitLab vào nhánh `develop`.
5.  **Review Code:** Ít nhất **1 thành viên khác** phải duyệt (Approve) trước khi code được phép merge.  

## 4. Quy ước Commit Message (Conventional Commits)

Để dễ dàng tra cứu lịch sử, commit message phải tuân thủ cấu trúc:
`<type>: <mô tả ngắn bằng tiếng Việt hoặc tiếng Anh>`

* `feat`: Một tính năng mới.
* `fix`: Sửa một lỗi (bug).
* `docs`: Thay đổi tài liệu, comment.
* `style`: Thay đổi format code, UI (không ảnh hưởng logic).
* `refactor`: Cơ cấu lại mã nguồn (ví dụ: chuyển đổi cấu trúc thư mục).
* `chore`: Các thay đổi nhỏ về build system hoặc thư viện (ví dụ: nâng cấp Kotlin).

> **Ví dụ:** `feat: thêm nút ẩn/hiện mật khẩu trong login screen`

