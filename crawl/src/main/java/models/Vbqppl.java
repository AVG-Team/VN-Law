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

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;

        Vbqppl vbqppl = (Vbqppl) object;

        if (id != null ? !id.equals(vbqppl.id) : vbqppl.id != null) return false;
        if (content != null ? !content.equals(vbqppl.content) : vbqppl.content != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (content != null ? content.hashCode() : 0);
        return result;
    }
}
