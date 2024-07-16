package fit.hutech.service.chatservice.models;

public enum TypeAnswerResult {
    ARTICLE(0),
    VBQPPL(1),
    QUESTION(2),
    NOANSWER(3);

    private final int value;

    // Constructor
    TypeAnswerResult(Integer value) {
        this.value = value;
    }

    // Phương thức để lấy giá trị
    public int getValue() {
        return value;
    }

    // Phương thức để lấy enum từ giá trị
    public static TypeAnswerResult fromValue(int value) {
        for (TypeAnswerResult type : TypeAnswerResult.values()) {
            if (type.value == value) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown value: " + value);
    }
}

