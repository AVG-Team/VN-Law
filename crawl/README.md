## Crawler

Chạy module này để cào dữ liệu pháp luật từ [Pháp Điển Việt Nam](https://phapdien.moj.gov.vn/) và [Văn bản quy phạm pháp luật](https://vbpl.vn/). Bước này là optional cho hệ thống, bạn có thể bỏ qua nếu không cần dữ liệu ban đầu.

Lấy dữ liệu từ [Pháp Điển Việt Nam](https://phapdien.moj.gov.vn/), tải file zip và giải nén vào thư mục này.

### Cào dữ liệu pháp điển

-   Tạo 2 file json từ file jsonData.json gốc:
    -   chude.json: chứa các chủ đề
    -   demuc.json: chứa các đề mục
    -   treeNode: chứa các node là các Phần, Chương, Mục, Tiểu mục, Điều.
-   Cuối cùng thư mục của bạn sẽ có cấu trúc như sau:

```
phap-dien
├── chude.json
├── demuc.json
├── treeNode.json
├── demuc/
│   ├── 1/...
│   ├── 2/...
```

-   Cài đặt các thư viện cần thiết:

<!-- ```bash
pip install -r requirements.txt
```

-   Chạy MySQL và PHPMyAdmin containers từ docker-compose:

```bash
docker-compose up -d
```

-   Chạy crawler:

```bash
python main.py
```

Sau khi chạy xong, dữ liệu sẽ được lưu vào DB, bạn có thể export ra bằng PHPAdmin dưới dạng .sql để dùng lại.

### Cào dữ liệu văn bản quy phạm pháp luật

-   Chạy MySQL và PHPMyAdmin containers từ docker-compose:

```bash
docker-compose up -d
```

-   Tiếp tục từ thư mục ở bước trên, cd vào thư mục này:

```bash
cd document-crawler
```

-   Cài đặt các thư viện cần thiết:

```bash
pip install -r requirements.txt
```

-   Chạy crawler:

```bash
python main.py
```

-   Phân chia VBQPPL thành các điều

```bash
python split_document.py
``` -->

## Cấu trúc thư mục
<pre>
crawl
	|_.gitignore
	|_.idea
		|_.gitignore
		|_compiler.xml
		|_dataSources.xml
		|_encodings.xml
		|_jarRepositories.xml
		|_misc.xml
		|_modules.xml
		|_vcs.xml
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
				|_Controller
					|_CrawlController.java
					|_CrawlDocumentController.java
					|_SplitDocumentController.java
				|_CrawlApplication.java
				|_helpers
					|_Helpers.java
				|_law_direction
					|_Subjects.json
					|_Topics.json
					|_TreeNodes.json
				|_models
					|_Indexvbqppl.java
					|_Pdarticle.java
					|_Pdchapter.java
					|_Pdfile.java
					|_Pdrelation.java
					|_Pdsubject.java
					|_Pdtable.java
					|_Pdtopic.java
					|_Vbqppl.java
				|_repositories
					|_HibernateUtil.java
			|_resources
				|_META-INF
					|_persistence.xml
	|_target
		|_classes
			|_Controller
				|_CrawlController$1.class
				|_CrawlController.class
				|_CrawlDocumentController.class
				|_SplitDocumentController.class
			|_CrawlApplication.class
			|_helpers
				|_Helpers.class
			|_law_direction
				|_Subjects.json
				|_Topics.json
				|_TreeNodes.json
			|_META-INF
				|_persistence.xml
			|_models
				|_Indexvbqppl.class
				|_Pdarticle.class
				|_Pdchapter.class
				|_Pdfile.class
				|_Pdrelation.class
				|_Pdsubject.class
				|_Pdtable.class
				|_Pdtopic.class
				|_Vbqppl.class
			|_repositories
				|_HibernateUtil.class
		|_test-classes

</pre>

Sau khi chạy xong, dữ liệu VBQPPL và các điều sẽ được lưu vào DB, bạn có thể export ra bằng PHPAdmin dưới dạng .sql để dùng lại.
