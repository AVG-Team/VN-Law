package fit.hutech.service.chatservice.DTO;

import fit.hutech.service.chatservice.DTO.ArticleDTOINT;
import fit.hutech.service.chatservice.DTO.FileDTO;
import fit.hutech.service.chatservice.DTO.TableDTO;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class ArticleDTO implements ArticleDTOINT {
    private String id;
    private String name;
    private String content;
    private String index;
    private String vbqppl;
    private String vbqpplLink;
    private Integer order;

    // Add these fields
    private String subjectName;
    private String chapterName;
    private String topicName;

    private List<FileDTO> files;
    private List<TableDTO> tables;

    public ArticleDTO(String id, String name, String content, String index, String vbqppl, String vbqpplLink, Integer order){
        this.id = id;
        this.name = name;
        this.content = content;
        this.index = index;
        this.vbqppl = vbqppl;
        this.vbqpplLink = vbqpplLink;
        this.order = order;
    }

    public ArticleDTO(String id, String name, String content, String index, String vbqppl, String vbqpplLink, Integer order, List<FileDTO> files, List<TableDTO> tables){
        this.id = id;
        this.name = name;
        this.content = content;
        this.index = index;
        this.vbqppl = vbqppl;
        this.vbqpplLink = vbqpplLink;
        this.order = order;
        this.files = files;
        this.tables = tables;
    }

    public ArticleDTO(String id, String name, String content, String index, String vbqppl, String vbqpplLink, Integer order, String subjectName, String chapterName, String topicName){
        this.id = id;
        this.name = name;
        this.content = content;
        this.index = index;
        this.vbqppl = vbqppl;
        this.vbqpplLink = vbqpplLink;
        this.order = order;
        this.subjectName = subjectName;
        this.chapterName = chapterName;
        this.topicName = topicName;
    }

    public ArticleDTO(String id, String name, String content, String index, String vbqppl, String vbqpplLink, Integer order, String subjectName, String chapterName, String topicName, List<FileDTO> files){
        this.id = id;
        this.name = name;
        this.content = content;
        this.index = index;
        this.vbqppl = vbqppl;
        this.vbqpplLink = vbqpplLink;
        this.order = order;
        this.subjectName = subjectName;
        this.chapterName = chapterName;
        this.topicName = topicName;
        this.files = files;
    }
}
