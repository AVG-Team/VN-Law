package helpers;


import com.google.gson.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import models.Pdsubject;
import repositories.HibernateUtil;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Helpers {

    public Helpers(){

    }
    public int ConvertRomanToNum(String romanNum) {
        romanNum = romanNum.toUpperCase();
        HashMap<Character, Integer> num_convert_roman = new HashMap<>();
        num_convert_roman.put('I', 10);
        num_convert_roman.put('V', 50);
        num_convert_roman.put('X', 100);
        num_convert_roman.put('L', 500);
        num_convert_roman.put('C', 1000);
        num_convert_roman.put('D', 5000);
        num_convert_roman.put('M', 10000);

        char[] letter = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'};
        int num = 0;
        for (int i = 0; i < romanNum.length(); i++) {
            char romanChar = romanNum.charAt(i);
            if (!num_convert_roman.containsKey(romanChar)) {
                num += getIndex(letter, romanChar);
                continue;
            }
            if (i > 0 && num_convert_roman.get(romanChar) > num_convert_roman.get(romanNum.charAt(i - 1))) {
                num += num_convert_roman.get(romanChar) - 2 * num_convert_roman.get(romanNum.charAt(i - 1));
            } else {
                num += num_convert_roman.get(romanChar);
            }
        }
        return num;

    }

    private int getIndex(char[] letter, char targer) {
        for (int i = 0; i < letter.length; i++) {
            if (letter[i] == targer) {
                return i;
            }
        }
        return -1;
    }

    public String extractInput(String input) {
        String pattern = "\\((.*?)\\)";

        Pattern regex = Pattern.compile(pattern);

        Matcher matcher = regex.matcher(input);


        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    public JsonArray readJsonFile(String filePath) throws IOException {

        Gson gson = new Gson();
        try (Reader reader = new FileReader(filePath)) {
            JsonElement jsonElement = JsonParser.parseReader(reader);
            if (jsonElement.isJsonArray()) {
                return jsonElement.getAsJsonArray();
            } else {
                throw new IllegalStateException("Dữ liệu không phải là một mảng JSON.");
            }
        }


    }

    public void writeJsonFile(JsonObject jsonObject, String filePath) throws IOException {
        Gson gson = new Gson();
        FileWriter fileWriter = new FileWriter(filePath);
        gson.toJson(jsonObject, fileWriter);
        fileWriter.close();
    }

    public List<Object> getData(Object object) {

        EntityTransaction transaction = null;
        EntityManager entityManager = null;


        entityManager = HibernateUtil.getEntityManagerFactory().createEntityManager();
        transaction = entityManager.getTransaction();
        transaction.begin();


        // Thực hiện truy vấn JPA để lấy dữ liệu từ cơ sở dữ liệu
        List<Object> objects = null;
        if (object instanceof Pdsubject) {
            objects = Collections.singletonList(entityManager.createQuery("SELECT e FROM Pdsubject e", Pdsubject.class).getResultList());
        }

        // Kết thúc transaction
        entityManager.getTransaction().commit();

        // Đóng EntityManager
        entityManager.close();

        return objects;

    }
}
