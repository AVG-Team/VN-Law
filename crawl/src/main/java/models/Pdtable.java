package models;

import jakarta.persistence.*;

@Entity
public class Pdtable {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "id", nullable = false)
    private int id;
    @Basic
    @Column(name = "id_article", nullable = true, length = 128)
    private String idArticle;
    @Basic
    @Column(name = "html", nullable = true, length = -1)
    private String html;

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

    public String getHtml() {
        return html;
    }

    public void setHtml(String html) {
        this.html = html;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;

        Pdtable pdtable = (Pdtable) object;

        if (id != pdtable.id) return false;
        if (idArticle != null ? !idArticle.equals(pdtable.idArticle) : pdtable.idArticle != null) return false;
        if (html != null ? !html.equals(pdtable.html) : pdtable.html != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + (idArticle != null ? idArticle.hashCode() : 0);
        result = 31 * result + (html != null ? html.hashCode() : 0);
        return result;
    }
}
