package models;

import jakarta.persistence.*;

@Entity
public class Vbqppl {
    @Id
    @Column(name = "id", nullable = false, length = 128)
    private String id;
    @Basic
    @Column(name = "content", nullable = true, length = -1)
    private String content;
    @Basic
    @Column(name = "name", nullable = false, length = 255)
    private String name;
    @Basic
    @Column(name = "type", nullable = false, length = 255)
    private String type;
    @Basic
    @Column(name = "number", nullable = true, length = 255)
    private String number;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;

        Vbqppl vbqppl = (Vbqppl) object;

        if (id != null ? !id.equals(vbqppl.id) : vbqppl.id != null) return false;
        if (content != null ? !content.equals(vbqppl.content) : vbqppl.content != null) return false;
        if (name != null ? !name.equals(vbqppl.name) : vbqppl.name != null) return false;
        if (type != null ? !type.equals(vbqppl.type) : vbqppl.type != null) return false;
        if (number != null ? !number.equals(vbqppl.number) : vbqppl.number != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (content != null ? content.hashCode() : 0);
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (type != null ? type.hashCode() : 0);
        result = 31 * result + (number != null ? number.hashCode() : 0);
        return result;
    }
}
