package models;

import jakarta.persistence.*;

@Entity
public class Pdchapter {
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
    @Column(name = "`index`", nullable = true, length = -1)
    private String index;
    @Basic
    @Column(name = "`order`", nullable = true)
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

    public String getIndex() {
        return index;
    }

    public void setIndex(String index) {
        this.index = index;
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

        Pdchapter pdchapter = (Pdchapter) object;

        if (id != null ? !id.equals(pdchapter.id) : pdchapter.id != null) return false;
        if (name != null ? !name.equals(pdchapter.name) : pdchapter.name != null) return false;
        if (idSubject != null ? !idSubject.equals(pdchapter.idSubject) : pdchapter.idSubject != null) return false;
        if (index != null ? !index.equals(pdchapter.index) : pdchapter.index != null) return false;
        if (order != null ? !order.equals(pdchapter.order) : pdchapter.order != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (idSubject != null ? idSubject.hashCode() : 0);
        result = 31 * result + (index != null ? index.hashCode() : 0);
        result = 31 * result + (order != null ? order.hashCode() : 0);
        return result;
    }
}
