package model;

import jakarta.persistence.*;

@Entity
public class Pdsubject {
    @Id
    @Column(name = "id", nullable = false, length = 128)
    private String id;
    @Basic
    @Column(name = "name", nullable = true, length = -1)
    private String name;
    @Basic
    @Column(name = "`order`", nullable = true)
    private Integer order;
    @Basic
    @Column(name = "id_topic", nullable = true, length = 128)
    private String idTopic;

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

    public Integer getOrder() {
        return order;
    }

    public void setOrder(Integer order) {
        this.order = order;
    }

    public String getIdTopic() {
        return idTopic;
    }

    public void setIdTopic(String idTopic) {
        this.idTopic = idTopic;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;

        Pdsubject pdsubject = (Pdsubject) object;

        if (id != null ? !id.equals(pdsubject.id) : pdsubject.id != null) return false;
        if (name != null ? !name.equals(pdsubject.name) : pdsubject.name != null) return false;
        if (order != null ? !order.equals(pdsubject.order) : pdsubject.order != null) return false;
        if (idTopic != null ? !idTopic.equals(pdsubject.idTopic) : pdsubject.idTopic != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (order != null ? order.hashCode() : 0);
        result = 31 * result + (idTopic != null ? idTopic.hashCode() : 0);
        return result;
    }
}
