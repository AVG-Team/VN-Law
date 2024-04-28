package fit.hutech.api.apigateway.chatbot;

import com.corundumstudio.socketio.*;
import com.corundumstudio.socketio.listener.*;

public class ChatbotServer {

    public static void main(String[] args) {
        Configuration config = new Configuration();
        config.setHostname("localhost");
        config.setPort(9000);

        SocketIOServer server = new SocketIOServer(config);

        // Xử lý sự kiện "sendDataClient" từ client
        server.addEventListener("sendDataClient", String.class, new DataListener<String>() {
            @Override
            public void onData(SocketIOClient client, String data, AckRequest ackRequest) throws Exception {
                System.out.println("Dữ liệu từ client: " + data);

                // Xử lý dữ liệu và gửi phản hồi lại cho client
                String responseData = "Server đã nhận: " + data;
                System.out.println("Phản hồi từ server: " + responseData);
                client.sendEvent("sendDataServer", responseData); // Gửi phản hồi lại cho client
            }
        });

        server.start();
        System.out.println("Socket.IO Server đang chạy trên cổng 9000");

        // Dừng server khi nhận được lệnh từ console
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            server.stop();
            System.out.println("Socket.IO Server đã dừng");
        }));
    }
}
