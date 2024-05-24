## Chat Service

> Dịch vụ Chat là một microservice chịu trách nhiệm xử lý chức năng chatbot trong ứng dụng VN-LAW. Nó cho phép người dùng tương tác với chatbot để nhận thông tin và hỗ trợ về các vấn đề pháp lý thông qua giao diện chat.

### Cài đặt:

Để cài đặt và chạy ứng dụng riêng, bạn cần có:

-   [JDK 21](https://www.oracle.com/java/technologies/downloads/#java21)
-   [Maven](https://maven.apache.org)

-   Chỉnh sửa các thông tin cần thiết trong file application.properties

-   Đầu tiên cd vào thư mục chat-service:

```bash
cd chat-service
```
-  Sau đó, để chạy service hãy:

```bash
mvn spring-boot:run
```
-   API sẽ được chạy trên port 9003

Mô tả: Sử dụng thư viện Axios để kiểm thử các api như đăng ký, đăng nhập, yêu cầu token.

## Cấu trúc thư mục
<pre>
chat-service
	|_.gitignore
	|_.mvn
		|_wrapper
			|_maven-wrapper.jar
			|_maven-wrapper.properties
	|_mvnw
	|_mvnw.cmd
	|_pom.xml
	|_README.md
	|_src
		|_main
			|_java
				|_fit
					|_hutech
						|_service
							|_chatservice
								|_ChatServiceApplication.java
			|_resources
				|_application.properties
		|_test
			|_java
				|_fit
					|_hutech
						|_service
							|_chatservice
								|_ChatServiceApplicationTests.java
	|_target
		|_classes
			|_application.properties
			|_fit
				|_hutech
					|_service
						|_chatservice
							|_ChatServiceApplication.class
		|_test-classes
			|_fit
				|_hutech
					|_service
						|_chatservice
							|_ChatServiceApplicationTests.class

</pre>