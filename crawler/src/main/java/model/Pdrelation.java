package model;

import jakarta.persistence.*;

@Entity
public class Pdrelation {
    @Id
    @Column(name = "id_article1", nullable = false, length = 128)
    private String idArticle1;
    @Basic
    @Column(name = "id_article2", nullable = true, length = 128)
    private String idArticle2;

    public String getIdArticle1() {
        return idArticle1;
    }

    public void setIdArticle1(String idArticle1) {
        this.idArticle1 = idArticle1;
    }

    public String getIdArticle2() {
        return idArticle2;
    }

    public void setIdArticle2(String idArticle2) {
        this.idArticle2 = idArticle2;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;

        Pdrelation that = (Pdrelation) object;

        if (idArticle1 != null ? !idArticle1.equals(that.idArticle1) : that.idArticle1 != null) return false;
        if (idArticle2 != null ? !idArticle2.equals(that.idArticle2) : that.idArticle2 != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = idArticle1 != null ? idArticle1.hashCode() : 0;
        result = 31 * result + (idArticle2 != null ? idArticle2.hashCode() : 0);
        return result;
    }
}
