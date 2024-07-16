# Dịch vụ xác thực và phân quyền

> Dịch vụ xác thực và phân quyền với các chức năng như đăng nhập, đăng ký và kiểm soát truy cập. Có thể phát triển như một ứng dụng đơn giản hay một dịch vụ microservice. Sử dụng các thư viện và framework như Node.js, Spring Boot, JWT, Redis, MySQL,...

## Kiến trúc

## Các công nghệ sử dụng chính

1.  NodeJS
2.  Spring Boot
3.  EJS
4.  MySQL
5.  Redis
6.  Sequenlize

## Yêu cầu

-   Redis
-   NodeJS
-   MySQL
-   Docker

## Cài đặt

Để cài đặt và chạy ứng dụng riêng, bạn cần có:

-   [JDK 21](https://www.oracle.com/java/technologies/downloads/#java21)
-   [Maven](https://maven.apache.org)

-   Chỉnh sửa các thông tin cần thiết trong file application.properties.

-   Đầu tiên cd vào thư mục auth-service:

```bash
cd auth-service
```
-  Sau đó, để chạy service hãy:

```bash
mvn spring-boot:run
```
-   API sẽ được chạy trên port 9001

Mô tả: Sử dụng thư viện Axios để kiểm thử các api như đăng ký, đăng nhập, yêu cầu token.

## Cấu trúc thư mục

<pre>
auth-service
|_src
	|_main
		|_java
			|_fit
				|_hutech
					|_service
						|_authservice
							|_AuthServiceApplication.java
							|_config
								|_ApplicationConfig.java
								|_OpenApiConfig.java
								|_SecurityConfig.java
							|_controller
								|_AdminController.java
								|_AuthenticationController.java
								|_DemoController.java
								|_ManagementController.java
								|_UserController.java
							|_enums
								|_Permission.java
								|_Role.java
								|_TokenType.java
							|_models
								|_Token.java
								|_User.java
							|_payloads
								|_request
									|_AuthenticationRequest.java
									|_ChangePasswordRequest.java
									|_ForgotPasswordRequest.java
									|_RegisterRequest.java
								|_response
									|_AuthenticationResponse.java
									|_ForgotPasswordResponse.java
							|_repositories
								|_TokenRepository.java
								|_UserRepository.java
							|_security
								|_jwt
									|_JwtAuthenticationFilter.java
								|_services
									|_AuthenticationService.java
									|_EmailSenderService.java
									|_JwtService.java
									|_LogoutService.java
									|_UserService.java
		|_resources
			|_application.properties
			|_templates
	|_test
		|_java
			|_fit
				|_hutech
					|_service
						|_authservice
							|_AuthServiceApplicationTests.java

</pre>
