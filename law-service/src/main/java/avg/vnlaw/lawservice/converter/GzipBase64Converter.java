package avg.vnlaw.lawservice.converter;

import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.utils.GzipUtil;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.io.IOException;

@Converter
public class GzipBase64Converter implements AttributeConverter<String, String> {

    @Override
    public String convertToDatabaseColumn(String plainText) {
        try {
            return GzipUtil.compressToBase64(plainText);
        } catch (IOException e) {
            throw new AppException(ErrorCode.COMPRESS_FAILD);
        }
    }

    @Override
    public String convertToEntityAttribute(String base64Content) {
        try {
            return GzipUtil.decompressFromBase64(base64Content);
        } catch (IOException e) {
            throw new AppException(ErrorCode.COMPRESS_FAILD);
        }
    }
}

