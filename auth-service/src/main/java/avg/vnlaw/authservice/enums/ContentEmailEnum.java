package avg.vnlaw.authservice.enums;

import lombok.Getter;
import lombok.Setter;

@Getter
public enum ContentEmailEnum {
    REGISTRATION("Đăng ký thành công",
            "Chúc mừng bạn đã đăng ký thành công!!!",
            "Cảm ơn bạn đã đăng ký trên nền tảng của chúng tôi. Vui lòng nhấp vào liên kết bên dưới để xác minh địa chỉ email của bạn."),

    REGISTER_WITH_PASSWORD("Đăng nhập thành công",
            "Chúc mừng bạn đã đăng nhập thành công!!!",
            "Cảm ơn bạn đã đăng nhập với chúng tôi. Tài khoản của bạn đã được đăng nhập thành công và sẵn sàng sử dụng. Chúng tôi rất vui được chào đón bạn và mong muốn mang đến cho bạn trải nghiệm tốt nhất. Mật khẩu của bạn là: `%s`; Vui lòng đăng nhập ngay bây giờ bằng cách nhấp vào nút bên dưới."),

    FORGOT_PASSWORD("Yêu cầu đặt lại mật khẩu",
            "Quên mật khẩu của bạn?",
            "Vui lòng nhấp vào liên kết bên dưới để đặt lại mật khẩu của bạn.");

    private final String subject;
    private final String title;
    private final String message;

    ContentEmailEnum(String subject, String title, String message) {
        this.subject = subject;
        this.title = title;
        this.message = message;
    }

    public String getMessage(Object... args) {
        return String.format(message, args);
    }
}
