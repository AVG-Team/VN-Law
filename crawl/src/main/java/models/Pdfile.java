package models;

import jakarta.persistence.*;

@Entity
public class Pdfile {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "id", nullable = false)
    private int id;
    @Basic
    @Column(name = "id_article", nullable = true, length = 128)
    private String idArticle;
    @Basic
    @Column(name = "link", nullable = true, length = -1)
    private String link;
    @Basic
    @Column(name = "path", nullable = true, length = -1)
    private String path;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getIdArticle() {
        return idArticle;
    }

    public void setIdArticle(String idArticle) {
        this.idArticle = idArticle;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;

        Pdfile pdfile = (Pdfile) object;

        if (id != pdfile.id) return false;
        if (idArticle != null ? !idArticle.equals(pdfile.idArticle) : pdfile.idArticle != null) return false;
        if (link != null ? !link.equals(pdfile.link) : pdfile.link != null) return false;
        if (path != null ? !path.equals(pdfile.path) : pdfile.path != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + (idArticle != null ? idArticle.hashCode() : 0);
        result = 31 * result + (link != null ? link.hashCode() : 0);
        result = 31 * result + (path != null ? path.hashCode() : 0);
        return result;
    }
}
