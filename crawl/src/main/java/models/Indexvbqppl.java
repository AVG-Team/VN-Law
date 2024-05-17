package models;

import jakarta.persistence.*;

@Entity
public class Indexvbqppl {
    @Id
    @Column(name = "id", nullable = false)
    private int id;
    @Basic
    @Column(name = "id_vbqppl", nullable = true, length = 128)
    private String idVbqppl;
    @Basic
    @Column(name = "index_parent", nullable = true, length = 128)
    private int indexParent;
    @Basic
    @Column(name = "name", nullable = true, length = -1)
    private String name;
    @Basic
    @Column(name = "content", nullable = true, length = -1)
    private String content;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getIdVbqppl() {
        return idVbqppl;
    }

    public void setIdVbqppl(String idVbqppl) {
        this.idVbqppl = idVbqppl;
    }

    public int getIndexParent() {
        return indexParent;
    }

    public void setIndexParent(int indexParent) {
        this.indexParent = indexParent;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String contentt) {
        this.content = contentt;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;

        Indexvbqppl that = (Indexvbqppl) object;

        if (id != that.id) return false;
        if (idVbqppl != null ? !idVbqppl.equals(that.idVbqppl) : that.idVbqppl != null) return false;
        if (indexParent != that.indexParent) return false;
        if (name != null ? !name.equals(that.name) : that.name != null) return false;
        if (content != null ? !content.equals(that.content) : that.content != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + (idVbqppl != null ? idVbqppl.hashCode() : 0);
        result = 31 * result ;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (content != null ? content.hashCode() : 0);
        return result;
    }
}
