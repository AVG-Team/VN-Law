from sqlalchemy import Column, String, Integer, ForeignKey, Text, Date
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Pdtopic(Base):
    __tablename__ = "pdtopic"
    id = Column(String(128), primary_key=True)
    name = Column(Text)
    order = Column(Integer)

class Pdsubject(Base):
    __tablename__ = "pdsubject"
    id = Column(String(128), primary_key=True)
    name = Column(Text)
    order = Column(Integer)
    topic_id = Column(String(128), ForeignKey("pdtopic.id"))  # Đổi id_topic thành topic_id

class Pdchapter(Base):
    __tablename__ = "pdchapter"
    id = Column(String(128), primary_key=True)
    name = Column(Text)
    index = Column(Text)
    order = Column(Integer)
    subject_id = Column(String(128), ForeignKey("pdsubject.id"))  # Đổi id_subject thành subject_id

class Pdarticle(Base):
    __tablename__ = "pdarticle"
    id = Column(String(128), primary_key=True)
    name = Column(Text)
    index = Column(String(25))
    order = Column(Integer)
    content = Column(Text(length=4294967295))  # LONGTEXT
    vbqppl = Column(Text)
    vbqppl_link = Column(Text)
    chapter_id = Column(String(128), ForeignKey("pdchapter.id"))  # Đổi id_chapter thành chapter_id
    subject_id = Column(String(128), ForeignKey("pdsubject.id"))  # Đổi id_subject thành subject_id
    topic_id = Column(String(128), ForeignKey("pdtopic.id"))  # Đổi id_topic thành topic_id
    effective_date = Column(Date)  # Thêm ngày hiệu lực

class Pdtable(Base):
    __tablename__ = "pdtable"
    id = Column(Integer, primary_key=True, autoincrement=True)
    article_id = Column(String(128), ForeignKey("pdarticle.id"))  # Đổi id_article thành article_id
    html = Column(Text(length=4294967295))  # LONGTEXT cho HTML

class Pdfile(Base):
    __tablename__ = "pdfile"
    id = Column(Integer, primary_key=True, autoincrement=True)
    article_id = Column(String(128), ForeignKey("pdarticle.id"))  # Đổi id_article thành article_id
    link = Column(Text)
    path = Column(Text)

class Pdrelation(Base):
    __tablename__ = "pdrelation"
    id = Column(Integer, primary_key=True, autoincrement=True)
    article_id1 = Column(String(128), ForeignKey("pdarticle.id"))  # Đổi id_article1 thành article_id1
    article_id2 = Column(String(128), ForeignKey("pdarticle.id"))  # Đổi id_article2 thành article_id2

class Vbqppl(Base):
    __tablename__ = "vbqppl"
    vbqppl_id = Column(String(128), primary_key=True)  # Đổi id thành vbqppl_id
    content = Column(Text(length=4294967295))  # LONGTEXT cho nội dung dài
    html = Column(Text(length=4294967295))  # LONGTEXT cho HTML
    type = Column(String(255))
    number = Column(String(255))

class Indexvbqppl(Base):
    __tablename__ = "indexvbqppl"
    id = Column(Integer, primary_key=True, autoincrement=True)
    vbqppl_id = Column(String(128), ForeignKey("vbqppl.vbqppl_id"), nullable=True)  # Liên kết với vbqppl
    index_parent = Column(Integer, nullable=True)  # Chỉ số cha
    name = Column(Text(length=4294967295), nullable=True)  # LONGTEXT
    content = Column(Text(length=4294967295), nullable=True)  # LONGTEXT