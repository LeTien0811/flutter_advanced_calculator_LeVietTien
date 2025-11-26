```markdown
# Máy Tính Nâng Cao - Dự Án Bài Tập Chương 3

## Mô Tả Dự Án và Tính Năng

Máy Tính Nâng Cao là một ứng dụng máy tính đa năng, được phát triển như một bài tập thực hành trong Chương 3. Ứng dụng này cung cấp một loạt các chế độ tính toán và các chức năng nâng cao, đáp ứng nhu cầu của nhiều đối tượng người dùng.

**Các tính năng chính:**

*   **Chế Độ Cơ Bản:** Thực hiện các phép toán số học cơ bản: cộng, trừ, nhân, chia.
*   **Chế Độ Khoa Học:** Hỗ trợ các hàm toán học nâng cao như lượng giác (sin, cos, tan), logarit (log, ln), lũy thừa, căn bậc, và các hằng số toán học (π, e).
*   **Chế Độ Lập Trình:** Chuyển đổi giữa các hệ số (nhị phân, thập lục phân, bát phân) và thực hiện các phép toán bitwise (AND, OR, XOR, NOT).
*   **Lịch Sử Tính Toán:** Lưu trữ và cho phép người dùng xem lại các phép tính đã thực hiện.
*   **Bộ Nhớ:** Cung cấp các chức năng bộ nhớ (M+, M-, MR, MC) để lưu trữ và gọi lại các giá trị.
*   **Giao Diện Thân Thiện:** Thiết kế giao diện trực quan, dễ sử dụng và tương thích với nhiều kích thước màn hình.

## Ảnh Chụp Màn Hình/GIF

### Chế Độ Cơ Bản

![Chế Độ Cơ Bản]
<img src="assets/images/darknomal.png" width="250">
*Giao diện tính toán cơ bản, dễ dàng thực hiện các phép tính thông thường.*

### Chế Độ Khoa Học

![Chế Độ Khoa Học]
<img src="assets/images/darkscen.png" width="250">
*Giao diện tính toán khoa học, hỗ trợ các hàm toán học phức tạp.*

### Chế Độ Lập Trình

![Chế Độ Lập Trình]
<img src="assets/images/darkprogram.png" width="250">
*Giao diện chuyển đổi hệ số và thực hiện các phép toán bitwise.*

### Lịch Sử Tính Toán

![Lịch Sử Tính Toán]<img src="assets/images/history.png" width="250">
*Giao diện lịch sử tính toán, cho phép xem lại các phép tính trước đó.*

### Cài Đặt

![Giao Diện Cài Đặt]<img src="assets/images/setting.png" width="250">
*Giao cài đặt, có nhiều chứ năng hỗ trợ thay đổi theme xóa lịch sử và cài đặt chế độ.*

### Tính Toán Ở Giao Diện Sáng

![Giao Diện Tính Toán Theme Light]<img src="assets/images/giaodientinhtoanlight.png" width="250">
*Giao tính toán, với theme sáng.*

### Tính Toán Ở Giao Diện Tối

![Giao Diện Tính Toán Theme Dart]<img src="assets/images/giaodientinhtoandark.png" width="250">
*Giao tính toán, với theme tối.*


## Sơ Đồ Kiến Trúc

```text
[Giao Diện Người Dùng]
    - Màn Hình Hiển Thị
    - Bảng Nút
    - Bộ Chọn Chế Độ
    ↓
[Bộ Điều Khiển/Xử Lý Sự Kiện]
    - Xử Lý Đầu Vào
    - Quản Lý Chế Độ
    - Định Tuyến Sự Kiện
    ↓
[Lớp Logic]
    - Engine Máy Tính Cơ Bản
    - Máy Tính Khoa Học
    - Máy Tính Lập Trình
    ↓
[Quản Lý Dữ Liệu]
    - Lưu Trữ Lịch Sử
    - Quản Lý Bộ Nhớ
    - Cài Đặt/Ưu Tiên
```

## Hướng Dẫn Cài Đặt

**Các Bước Cài Đặt:**

1.  **Clone kho lưu trữ:**
    ```bash
    git clone git@github.com:LeTien0811/flutter_advanced_calculator_LeVietTien.git
    cd AdvancedCalculator
    ```
2. **Chạy ứng dụng:**
    ```bash
    flutter run -d web-server
    # hoặc
    flutter run 
    ```
3. **Truy cập ứng dụng:** Mở trình duyệt và truy cập

## Hướng Dẫn Kiểm Thử

**Chạy Unit Tests:**

```bash
flutter test
```

**Kiểm Tra Thủ Công:**

*   **Chế Độ Cơ Bản:** Kiểm tra các phép toán cộng, trừ, nhân, chia, dấu thập phân, xóa và quay lại.
*   **Chế Độ Khoa Học:** Kiểm tra các hàm lượng giác, logarit, lũy thừa, căn bậc, và các hằng số.
*   **Chế Độ Lập Trình:** Kiểm tra các phép chuyển đổi hệ số và các phép toán bitwise.
*   **Các Tính Năng Bổ Sung:** Kiểm tra chức năng lưu lịch sử, bộ nhớ, chuyển đổi chế độ và xử lý lỗi.

## Hạn Chế

*   **Độ Chính Xác:** Các phép tính dấu phẩy động có thể gặp sai số nhỏ trong một số trường hợp.
*   **Khả Năng Tương Thích:** Ứng dụng được tối ưu hóa cho các trình duyệt hiện đại.
*   **Hiệu Năng:** Lịch sử tính toán có giới hạn để đảm bảo hiệu năng.
*   **Xác Thực Đầu Vào:** Một số trường hợp biên trong chế độ lập trình có thể chưa được xác thực đầy đủ.

## Cải Tiến Tương Lai

*   **Phím Tắt:** Thêm phím tắt cho các phép toán phổ biến.
*   **Chủ Đề:** Triển khai công tắc chủ đề tối/sáng.
*   **Chuyển Đổi Đơn Vị:** Thêm tính năng chuyển đổi đơn vị (độ dài, trọng lượng, nhiệt độ).
*   **Cải Thiện Thông Báo Lỗi:** Cung cấp thông báo lỗi chi tiết và gợi ý.
*   **Vẽ Đồ Thị:** Thêm chức năng vẽ đồ thị cho các phương trình.
*   **Hỗ Trợ Đa Ngôn Ngữ:** Mở rộng hỗ trợ đa ngôn ngữ.
*   **Đồng Bộ Hóa Đám Mây:** Cho phép đồng bộ hóa lịch sử tính toán trên nhiều thiết bị.

## Công Nghệ Sử Dụng

*   **Framework:** Flutter
*   **Testing:** flutter_test Library

## Đóng Góp

Đóng góp cho dự án luôn được hoan nghênh! Vui lòng làm theo các bước sau:

1.  Fork kho lưu trữ.
2.  Tạo một nhánh mới (`git checkout -b feature/AmazingFeature`).
3.  Thực hiện thay đổi của bạn.
4.  Commit các thay đổi (`git commit -m 'Add some AmazingFeature'`).
5.  Đẩy lên nhánh (`git push origin feature/AmazingFeature`).
6.  Mở một Pull Request.

## Giấy phép

Dự án này được cấp phép theo Giấy phép MIT - xem file [LICENSE](LICENSE) để biết chi tiết.

## Tác Giả

**[Lê Việt Tiến]**
- Mã số sinh viên: [2224801030398]
- Email: [letien2081@gmail.com]
- GitHub: [@LeTien0811]

---

*Cập nhật lần cuối: 26 tháng 11 năm 2023*
```
