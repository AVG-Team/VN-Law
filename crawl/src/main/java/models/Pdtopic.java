package models;

import jakarta.persistence.*;

@Entity
public class Pdtopic {
    @Id
    @Column(name = "id", nullable = false, length = 128)
    private String id;
    @Basic
    @Column(name = "name", nullable = true, length = -1)
    private String name;
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

        Pdtopic pdtopic = (Pdtopic) object;

        if (id != null ? !id.equals(pdtopic.id) : pdtopic.id != null) return false;
        if (name != null ? !name.equals(pdtopic.name) : pdtopic.name != null) return false;
        if (order != null ? !order.equals(pdtopic.order) : pdtopic.order != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (order != null ? order.hashCode() : 0);
        return result;
    }
}
