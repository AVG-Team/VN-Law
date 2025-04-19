package avg.vnlaw.lawservice.utils;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.io.*;
import java.util.Base64;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

public class GzipUtil {

    private GzipUtil() {
        throw new UnsupportedOperationException("Utility class should not be instantiated");
    }

    // Nén chuỗi thành Base64 (GZIP + Base64)
    public static String compressToBase64(String data) throws IOException {
        if (data == null || data.isEmpty()) return data;

        ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
        try (GZIPOutputStream gzipStream = new GZIPOutputStream(byteStream)) {
            gzipStream.write(data.getBytes("UTF-8"));
        }

        byte[] compressedBytes = byteStream.toByteArray();
        return Base64.getEncoder().encodeToString(compressedBytes);
    }

    // Giải nén từ Base64 (Base64 + GZIP)
    public static String decompressFromBase64(String base64) throws IOException {
        if (base64 == null || base64.isEmpty()) return base64;

        byte[] compressedBytes = Base64.getDecoder().decode(base64);
        ByteArrayInputStream byteStream = new ByteArrayInputStream(compressedBytes);
        InputStream gzipStream = new GZIPInputStream(byteStream);

        BufferedReader reader = new BufferedReader(new InputStreamReader(gzipStream, "UTF-8"));
        StringBuilder outStr = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            outStr.append(line);
        }

        return outStr.toString();
    }
}


