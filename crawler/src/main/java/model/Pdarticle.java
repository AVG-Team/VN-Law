package model;

import jakarta.persistence.*;

@Entity
public class Pdarticle {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "id", nullable = false, length = 128)
    private String id;
    @Basic
    @Column(name = "name", nullable = true, length = -1)
    private String name;
    @Basic
    @Column(name = "id_subject", nullable = true, length = 128)
    private String idSubject;
    @Basic
    @Column(name = "id_chapter", nullable = true, length = 128)
    private String idChapter;
    @Basic
    @Column(name = "id_topic", nullable = true, length = 128)
    private String idTopic;
    @Basic
    @Column(name = "content", nullable = true, length = -1)
    private String content;
    @Basic
    @Column(name = "index", nullable = true, length = 25)
    private String index;
    @Basic
    @Column(name = "vbqppl", nullable = true, length = -1)
    private String vbqppl;
    @Basic
    @Column(name = "vbqppl_link", nullable = true, length = -1)
    private String vbqpplLink;
    @Basic
    @Column(name = "order", nullable = true)
    private Integer order;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIdSubject() {
        return idSubject;
    }

    public void setIdSubject(String idSubject) {
        this.idSubject = idSubject;
    }

    public String getIdChapter() {
        return idChapter;
    }

    public void setIdChapter(String idChapter) {
        this.idChapter = idChapter;
    }

    public String getIdTopic() {
        return idTopic;
    }

    public void setIdTopic(String idTopic) {
        this.idTopic = idTopic;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getIndex() {
        return index;
    }

    public void setIndex(String index) {
        this.index = index;
    }

    public String getVbqppl() {
        return vbqppl;
    }

    public void setVbqppl(String vbqppl) {
        this.vbqppl = vbqppl;
    }

    public String getVbqpplLink() {
        return vbqpplLink;
    }

    public void setVbqpplLink(String vbqpplLink) {
        this.vbqpplLink = vbqpplLink;
    }

    public Integer getOrder() {
        return order;
    }

    public void setOrder(Integer order) {
        this.order = order;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;

        Pdarticle pdarticle = (Pdarticle) object;

        if (id != null ? !id.equals(pdarticle.id) : pdarticle.id != null) return false;
        if (name != null ? !name.equals(pdarticle.name) : pdarticle.name != null) return false;
        if (idSubject != null ? !idSubject.equals(pdarticle.idSubject) : pdarticle.idSubject != null) return false;
        if (idChapter != null ? !idChapter.equals(pdarticle.idChapter) : pdarticle.idChapter != null) return false;
        if (idTopic != null ? !idTopic.equals(pdarticle.idTopic) : pdarticle.idTopic != null) return false;
        if (content != null ? !content.equals(pdarticle.content) : pdarticle.content != null) return false;
        if (index != null ? !index.equals(pdarticle.index) : pdarticle.index != null) return false;
        if (vbqppl != null ? !vbqppl.equals(pdarticle.vbqppl) : pdarticle.vbqppl != null) return false;
        if (vbqpplLink != null ? !vbqpplLink.equals(pdarticle.vbqpplLink) : pdarticle.vbqpplLink != null) return false;
        if (order != null ? !order.equals(pdarticle.order) : pdarticle.order != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (idSubject != null ? idSubject.hashCode() : 0);
        result = 31 * result + (idChapter != null ? idChapter.hashCode() : 0);
        result = 31 * result + (idTopic != null ? idTopic.hashCode() : 0);
        result = 31 * result + (content != null ? content.hashCode() : 0);
        result = 31 * result + (index != null ? index.hashCode() : 0);
        result = 31 * result + (vbqppl != null ? vbqppl.hashCode() : 0);
        result = 31 * result + (vbqpplLink != null ? vbqpplLink.hashCode() : 0);
        result = 31 * result + (order != null ? order.hashCode() : 0);
        return result;
    }
}
