package fit.hutech.service.chatservice.services.implement;

import com.corundumstudio.socketio.*;
import com.corundumstudio.socketio.listener.ConnectListener;
import com.corundumstudio.socketio.listener.DataListener;
import fit.hutech.service.chatservice.services.RAGService;
import fit.hutech.service.chatservice.services.SocketService;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Service
public class SocketServiceImpl implements SocketService {

//    @PostConstruct
//    public void init() {
//        Test();
//        handleSocketService();
//    }

    private final SocketIOServer server;

    public SocketServiceImpl() {
        Configuration config = new Configuration();
        config.setHostname("localhost");
        config.setPort(9004);
        server = new SocketIOServer(config);
    }

    @Override
    public void Test() {
        System.out.println("Hello World Socket Service");
    }

    @Override
    public void handleSocketService() {
        server.addConnectListener(new ConnectListener() {
            @Override
            public void onConnect(SocketIOClient client) {
                System.out.println("Client đã kết nối: " + client.getSessionId());
            }
        });

        // Xử lý sự kiện "sendDataClient" từ client
        server.addEventListener("sendDataClient", String.class, new DataListener<String>() {
            @Override
            public void onData(SocketIOClient client, String data, AckRequest ackRequest) throws Exception {
                System.out.println("câu hỏi từ client: " + data);

                // Xử lý dữ liệu và gửi phản hồi lại cho client
                String responseData = "Server đã nhận: " + data;
                System.out.println("Phản hồi từ server: " + responseData);
                client.sendEvent("sendDataServer", responseData);
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
