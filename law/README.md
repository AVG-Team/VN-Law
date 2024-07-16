## Law Service

> Service quản lý dữ liệu về pháp điển, văn bản quy phạm pháp luật, sử dụng Spring Boot

### Cài đặt:

Để cài đặt và chạy ứng dụng riêng, bạn cần có:

-   [JDK 21](https://www.oracle.com/java/technologies/downloads/#java21)
-   [Maven](https://maven.apache.org)

-   Chỉnh sửa các thông tin cần thiết trong file application.properties

-   Đầu tiên cd vào thư mục law-service:

```bash
cd law-service
```
-  Sau đó, để chạy service hãy:

```bash
mvn spring-boot:run
```
-   API sẽ được chạy trên port 9002


## Cấu trúc thư mục
<pre>
law-service
	|_.env
	|_.gitignore
	|_.idea
		|_.gitignore
		|_compiler.xml
		|_encodings.xml
		|_jarRepositories.xml
		|_misc.xml
		|_vcs.xml
		|_workspace.xml
	|_.mvn
		|_wrapper
			|_maven-wrapper.jar
			|_maven-wrapper.properties
	|_HELP.md
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
							|_lawservice
								|_config
									|_response
										|_ResponseHandler.java
								|_controller
									|_ArticleController.java
									|_ChapterController.java
									|_IndexVbqpplController.java
									|_SubjectController.java
									|_TableController.java
									|_TopicController.java
									|_VbqpplController.java
								|_DTO
									|_ArticleDTO.java
									|_ArticleDTOINT.java
									|_ArticleTreeViewDTO.java
									|_ChapterDTO.java
									|_FileDTO.java
									|_ListTreeViewDTO.java
									|_SubjectDTO.java
									|_TableDTO.java
									|_VbqpplDTO.java
								|_exception
									|_Exception.java
									|_NotFoundException.java
									|_ObjectExceptionHandler.java
								|_LawServiceApplication.java
								|_models
									|_Article.java
									|_Chapter.java
									|_Files.java
									|_IndexVbqppl.java
									|_Subject.java
									|_Tables.java
									|_Topic.java
									|_Vbqppl.java
								|_repositories
									|_ArticleRepository.java
									|_ChapterRepository.java
									|_FileRepository.java
									|_IndexVbqpplRepository.java
									|_SubjectRepository.java
									|_TableRepository.java
									|_TopicRepository.java
									|_VbqpplRepository.java
								|_services
									|_ArticleService.java
									|_ChapterService.java
									|_implement
										|_ArticleServiceImpl.java
										|_ChapterServiceImpl.java
										|_IndexVbqpplServiceImpl.java
										|_SubjectServiceImpl.java
										|_TableServiceImpl.java
										|_TopicServiceImpl.java
										|_VbqpplServiceImpl.java
									|_IndexVbqpplService.java
									|_SubjectService.java
									|_TableService.java
									|_TopicService.java
									|_VbqpplService.java
			|_resources
				|_application.properties
		|_test
			|_java
				|_fit
					|_hutech
						|_service
							|_lawservice
								|_LawServiceApplicationTests.java
	|_target
		|_classes
			|_application.properties
			|_fit
				|_hutech
					|_service
						|_lawservice
							|_config
								|_response
									|_ResponseHandler.class
							|_controller
								|_ArticleController.class
								|_ChapterController.class
								|_IndexVbqpplController.class
								|_SubjectController.class
								|_TableController.class
								|_TopicController.class
								|_VbqpplController.class
							|_DTO
								|_ArticleDTO.class
								|_ArticleDTOINT.class
								|_ArticleTreeViewDTO$ArticleTreeViewDTOBuilder.class
								|_ArticleTreeViewDTO.class
								|_ChapterDTO$ChapterDTOBuilder.class
								|_ChapterDTO.class
								|_FileDTO$FileDTOBuilder.class
								|_FileDTO.class
								|_ListTreeViewDTO$ListTreeViewDTOBuilder.class
								|_ListTreeViewDTO.class
								|_SubjectDTO$SubjectDTOBuilder.class
								|_SubjectDTO.class
								|_TableDTO$TableDTOBuilder.class
								|_TableDTO.class
								|_VbqpplDTO$VbqpplDTOBuilder.class
								|_VbqpplDTO.class
							|_exception
								|_Exception.class
								|_NotFoundException.class
								|_ObjectExceptionHandler.class
							|_LawServiceApplication.class
							|_models
								|_Article$ArticleBuilder.class
								|_Article.class
								|_Chapter$ChapterBuilder.class
								|_Chapter.class
								|_Files$FilesBuilder.class
								|_Files.class
								|_IndexVbqppl$IndexVbqpplBuilder.class
								|_IndexVbqppl.class
								|_Subject$SubjectBuilder.class
								|_Subject.class
								|_Tables$TablesBuilder.class
								|_Tables.class
								|_Topic$TopicBuilder.class
								|_Topic.class
								|_Vbqppl$VbqpplBuilder.class
								|_Vbqppl.class
							|_repositories
								|_ArticleRepository.class
								|_ChapterRepository.class
								|_FileRepository.class
								|_IndexVbqpplRepository.class
								|_SubjectRepository.class
								|_TableRepository.class
								|_TopicRepository.class
								|_VbqpplRepository.class
							|_services
								|_ArticleService.class
								|_ChapterService.class
								|_implement
									|_ArticleServiceImpl.class
									|_ChapterServiceImpl.class
									|_IndexVbqpplServiceImpl.class
									|_SubjectServiceImpl.class
									|_TableServiceImpl.class
									|_TopicServiceImpl.class
									|_VbqpplServiceImpl.class
								|_IndexVbqpplService.class
								|_SubjectService.class
								|_TableService.class
								|_TopicService.class
								|_VbqpplService.class
		|_generated-sources
			|_annotations
		|_generated-test-sources
			|_test-annotations
		|_test-classes
			|_fit
				|_hutech
					|_service
						|_lawservice
							|_LawServiceApplicationTests.class

</pre>

