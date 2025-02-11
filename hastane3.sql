PGDMP  6    #                |         
   hastaneDb1    15.8    16.4 f    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    27488 
   hastaneDb1    DATABASE     �   CREATE DATABASE "hastaneDb1" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Turkish_T�rkiye.1254';
    DROP DATABASE "hastaneDb1";
                postgres    false            �            1255    27489 0   brans_ekle(character varying, character varying)    FUNCTION     K  CREATE FUNCTION public.brans_ekle(ad character varying, branstip character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Brans WHERE ad = ad) THEN
        RAISE NOTICE 'Bu branş zaten mevcut.';
    ELSE
        INSERT INTO Brans (ad, bransTip) VALUES (ad, bransTip);
    END IF;
END;
$$;
 S   DROP FUNCTION public.brans_ekle(ad character varying, branstip character varying);
       public          postgres    false            �            1255    27490    brans_silme_engelle()    FUNCTION     �   CREATE FUNCTION public.brans_silme_engelle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE EXCEPTION 'Bu branş silinemez!';
    RETURN NULL;
END;
$$;
 ,   DROP FUNCTION public.brans_silme_engelle();
       public          postgres    false            �            1255    27491    doktor_atama(integer, integer)    FUNCTION     �  CREATE FUNCTION public.doktor_atama(randevuid integer, doktorid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Randevular WHERE randevuId = randevuId) THEN
        RAISE EXCEPTION 'Randevu mevcut değil.';
    ELSIF NOT EXISTS (SELECT 1 FROM Doktor WHERE id = doktorId) THEN
        RAISE EXCEPTION 'Doktor mevcut değil.';
    ELSE
        UPDATE Randevular SET doktorId = doktorId WHERE randevuId = randevuId;
    END IF;
END;
$$;
 H   DROP FUNCTION public.doktor_atama(randevuid integer, doktorid integer);
       public          postgres    false            �            1255    27492    ensure_unique_id()    FUNCTION       CREATE FUNCTION public.ensure_unique_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Diğer tablolarda aynı ID var mı kontrol et
    IF EXISTS (
        SELECT 1 FROM public.kisi WHERE id = NEW.id
        UNION
        SELECT 1 FROM public.hasta WHERE id = NEW.id
        UNION
        SELECT 1 FROM public.personel WHERE id = NEW.id
        UNION
        SELECT 1 FROM public.doktor WHERE id = NEW.id
    ) THEN
        RAISE EXCEPTION 'ID already exists in another table';
    END IF;
    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.ensure_unique_id();
       public          postgres    false            �            1255    27493    fatura_sil()    FUNCTION     �   CREATE FUNCTION public.fatura_sil() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Fatura WHERE randevuId = OLD.randevuId;
    RETURN OLD;
END;
$$;
 #   DROP FUNCTION public.fatura_sil();
       public          postgres    false            �            1255    27494 C   hasta_ekle(character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.hasta_ekle(ad character varying, soyad character varying, tcno character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Kisi WHERE tcNo = tcNo) THEN
        RAISE NOTICE 'Bu TC kimlik numarası zaten mevcut.';
    ELSE
        INSERT INTO Kisi (ad, soyad, tcNo, kisiTip) VALUES (ad, soyad, tcNo, 'Hasta');
        INSERT INTO Hasta (kisiId) VALUES (currval('kisi_id_seq'));
    END IF;
END;
$$;
 h   DROP FUNCTION public.hasta_ekle(ad character varying, soyad character varying, tcno character varying);
       public          postgres    false            �            1255    27495    odeme_guncelle(integer)    FUNCTION     =  CREATE FUNCTION public.odeme_guncelle(faturaid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Fatura WHERE id = faturaId) THEN
        RAISE EXCEPTION 'Fatura mevcut değil.';
    ELSE
        UPDATE Fatura SET odemeDurumu = TRUE WHERE id = faturaId;
    END IF;
END;
$$;
 7   DROP FUNCTION public.odeme_guncelle(faturaid integer);
       public          postgres    false            �            1255    27496    randevu_iptal()    FUNCTION     �   CREATE FUNCTION public.randevu_iptal() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Randevular SET doktorId = NULL WHERE doktorId = OLD.id;
    RETURN OLD;
END;
$$;
 &   DROP FUNCTION public.randevu_iptal();
       public          postgres    false            �            1259    27497    brans    TABLE     �   CREATE TABLE public.brans (
    bransid integer NOT NULL,
    ad character varying(50) NOT NULL,
    branstipi character varying(20)
);
    DROP TABLE public.brans;
       public         heap    postgres    false            �            1259    27500    brans_bransid_seq    SEQUENCE     �   CREATE SEQUENCE public.brans_bransid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.brans_bransid_seq;
       public          postgres    false    214            �           0    0    brans_bransid_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.brans_bransid_seq OWNED BY public.brans.bransid;
          public          postgres    false    215            �            1259    27501 
   cocukbrans    TABLE     _   CREATE TABLE public.cocukbrans (
    ekbilgi character varying(100)
)
INHERITS (public.brans);
    DROP TABLE public.cocukbrans;
       public         heap    postgres    false    214            �            1259    27504    kisi    TABLE     �   CREATE TABLE public.kisi (
    id integer NOT NULL,
    ad character varying(50) NOT NULL,
    soyad character varying(50) NOT NULL,
    tcno character(11) NOT NULL,
    kisitip character varying(20) NOT NULL
);
    DROP TABLE public.kisi;
       public         heap    postgres    false            �            1259    27507    personel    TABLE     j   CREATE TABLE public.personel (
    personelsifre character varying(50) NOT NULL
)
INHERITS (public.kisi);
    DROP TABLE public.personel;
       public         heap    postgres    false    217            �            1259    27510    doktor    TABLE     �   CREATE TABLE public.doktor (
    doktorturu character varying(50),
    bransid integer,
    bransad character varying(20)
)
INHERITS (public.personel);
    DROP TABLE public.doktor;
       public         heap    postgres    false    218            �            1259    27513    cocukdoktoru    TABLE     g   CREATE TABLE public.cocukdoktoru (
    uzmanlikalani character varying(50)
)
INHERITS (public.doktor);
     DROP TABLE public.cocukdoktoru;
       public         heap    postgres    false    219            �            1259    27516    hasta    TABLE     ~   CREATE TABLE public.hasta (
    hastasifre character varying(20),
    telefon character varying(15)
)
INHERITS (public.kisi);
    DROP TABLE public.hasta;
       public         heap    postgres    false    217            �            1259    27519 
   cocukhasta    TABLE     <   CREATE TABLE public.cocukhasta (
)
INHERITS (public.hasta);
    DROP TABLE public.cocukhasta;
       public         heap    postgres    false    221            �            1259    27522    duyuru    TABLE     �   CREATE TABLE public.duyuru (
    duyuruid integer NOT NULL,
    duyuruicerik text NOT NULL,
    tarih date DEFAULT CURRENT_DATE,
    sekreterid integer,
    doktorid integer
);
    DROP TABLE public.duyuru;
       public         heap    postgres    false            �            1259    27528    duyuru_duyuruid_seq    SEQUENCE     �   CREATE SEQUENCE public.duyuru_duyuruid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.duyuru_duyuruid_seq;
       public          postgres    false    223            �           0    0    duyuru_duyuruid_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.duyuru_duyuruid_seq OWNED BY public.duyuru.duyuruid;
          public          postgres    false    224            �            1259    27529    fatura    TABLE     �   CREATE TABLE public.fatura (
    id integer NOT NULL,
    kisiid integer NOT NULL,
    randevuid integer NOT NULL,
    toplamtutar character varying(10) NOT NULL,
    odemedurumu boolean DEFAULT false
);
    DROP TABLE public.fatura;
       public         heap    postgres    false            �            1259    27533    fatura_id_seq    SEQUENCE     �   CREATE SEQUENCE public.fatura_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.fatura_id_seq;
       public          postgres    false    225            �           0    0    fatura_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.fatura_id_seq OWNED BY public.fatura.id;
          public          postgres    false    226            �            1259    27534    kisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.kisi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.kisi_id_seq;
       public          postgres    false    217            �           0    0    kisi_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.kisi_id_seq OWNED BY public.kisi.id;
          public          postgres    false    227            �            1259    27535 
   randevular    TABLE     w  CREATE TABLE public.randevular (
    randevuid integer NOT NULL,
    tarih character varying(10) NOT NULL,
    saat character varying(6) NOT NULL,
    bransid integer,
    id integer,
    hastatc character(11),
    sekreterid integer,
    doktorad character varying(25),
    randevudurum boolean,
    hastasikayet character varying(100),
    bransad character varying(20)
);
    DROP TABLE public.randevular;
       public         heap    postgres    false            �            1259    27538    randevular_randevuid_seq    SEQUENCE     �   CREATE SEQUENCE public.randevular_randevuid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.randevular_randevuid_seq;
       public          postgres    false    228            �           0    0    randevular_randevuid_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.randevular_randevuid_seq OWNED BY public.randevular.randevuid;
          public          postgres    false    229            �            1259    27539    sekreter    TABLE     c   CREATE TABLE public.sekreter (
    odemedurumu boolean DEFAULT false
)
INHERITS (public.personel);
    DROP TABLE public.sekreter;
       public         heap    postgres    false    218            �            1259    27543    yetiskinbrans    TABLE     b   CREATE TABLE public.yetiskinbrans (
    ekbilgi character varying(100)
)
INHERITS (public.brans);
 !   DROP TABLE public.yetiskinbrans;
       public         heap    postgres    false    214            �            1259    27546    yetiskindoktor    TABLE     i   CREATE TABLE public.yetiskindoktor (
    uzmanlikalani character varying(50)
)
INHERITS (public.doktor);
 "   DROP TABLE public.yetiskindoktor;
       public         heap    postgres    false    219            �            1259    27549    yetiskinhasta    TABLE     ?   CREATE TABLE public.yetiskinhasta (
)
INHERITS (public.hasta);
 !   DROP TABLE public.yetiskinhasta;
       public         heap    postgres    false    221            �           2604    27552    brans bransid    DEFAULT     n   ALTER TABLE ONLY public.brans ALTER COLUMN bransid SET DEFAULT nextval('public.brans_bransid_seq'::regclass);
 <   ALTER TABLE public.brans ALTER COLUMN bransid DROP DEFAULT;
       public          postgres    false    215    214            �           2604    27553    cocukbrans bransid    DEFAULT     s   ALTER TABLE ONLY public.cocukbrans ALTER COLUMN bransid SET DEFAULT nextval('public.brans_bransid_seq'::regclass);
 A   ALTER TABLE public.cocukbrans ALTER COLUMN bransid DROP DEFAULT;
       public          postgres    false    215    216            �           2604    27554    cocukdoktoru id    DEFAULT     j   ALTER TABLE ONLY public.cocukdoktoru ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 >   ALTER TABLE public.cocukdoktoru ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    220            �           2604    27555    cocukhasta id    DEFAULT     h   ALTER TABLE ONLY public.cocukhasta ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 <   ALTER TABLE public.cocukhasta ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    222            �           2604    27556 	   doktor id    DEFAULT     d   ALTER TABLE ONLY public.doktor ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 8   ALTER TABLE public.doktor ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    219            �           2604    27557    duyuru duyuruid    DEFAULT     r   ALTER TABLE ONLY public.duyuru ALTER COLUMN duyuruid SET DEFAULT nextval('public.duyuru_duyuruid_seq'::regclass);
 >   ALTER TABLE public.duyuru ALTER COLUMN duyuruid DROP DEFAULT;
       public          postgres    false    224    223            �           2604    27558 	   fatura id    DEFAULT     f   ALTER TABLE ONLY public.fatura ALTER COLUMN id SET DEFAULT nextval('public.fatura_id_seq'::regclass);
 8   ALTER TABLE public.fatura ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225            �           2604    27559    hasta id    DEFAULT     c   ALTER TABLE ONLY public.hasta ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 7   ALTER TABLE public.hasta ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    221            �           2604    27560    kisi id    DEFAULT     b   ALTER TABLE ONLY public.kisi ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 6   ALTER TABLE public.kisi ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    217            �           2604    27561    personel id    DEFAULT     f   ALTER TABLE ONLY public.personel ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 :   ALTER TABLE public.personel ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    227            �           2604    27562    randevular randevuid    DEFAULT     |   ALTER TABLE ONLY public.randevular ALTER COLUMN randevuid SET DEFAULT nextval('public.randevular_randevuid_seq'::regclass);
 C   ALTER TABLE public.randevular ALTER COLUMN randevuid DROP DEFAULT;
       public          postgres    false    229    228            �           2604    27563    sekreter id    DEFAULT     f   ALTER TABLE ONLY public.sekreter ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 :   ALTER TABLE public.sekreter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    230            �           2604    27564    yetiskinbrans bransid    DEFAULT     v   ALTER TABLE ONLY public.yetiskinbrans ALTER COLUMN bransid SET DEFAULT nextval('public.brans_bransid_seq'::regclass);
 D   ALTER TABLE public.yetiskinbrans ALTER COLUMN bransid DROP DEFAULT;
       public          postgres    false    215    231            �           2604    27565    yetiskinbrans branstipi    DEFAULT     i   ALTER TABLE ONLY public.yetiskinbrans ALTER COLUMN branstipi SET DEFAULT 'Yetişkin'::character varying;
 F   ALTER TABLE public.yetiskinbrans ALTER COLUMN branstipi DROP DEFAULT;
       public          postgres    false    231            �           2604    27566    yetiskindoktor id    DEFAULT     l   ALTER TABLE ONLY public.yetiskindoktor ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 @   ALTER TABLE public.yetiskindoktor ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    227            �           2604    27567    yetiskinhasta id    DEFAULT     k   ALTER TABLE ONLY public.yetiskinhasta ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 ?   ALTER TABLE public.yetiskinhasta ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    227            y          0    27497    brans 
   TABLE DATA           7   COPY public.brans (bransid, ad, branstipi) FROM stdin;
    public          postgres    false    214   �{       {          0    27501 
   cocukbrans 
   TABLE DATA           E   COPY public.cocukbrans (bransid, ad, branstipi, ekbilgi) FROM stdin;
    public          postgres    false    216   �{                 0    27513    cocukdoktoru 
   TABLE DATA           �   COPY public.cocukdoktoru (id, ad, soyad, tcno, kisitip, personelsifre, doktorturu, bransid, uzmanlikalani, bransad) FROM stdin;
    public          postgres    false    220   �{       �          0    27519 
   cocukhasta 
   TABLE DATA           W   COPY public.cocukhasta (id, ad, soyad, tcno, kisitip, hastasifre, telefon) FROM stdin;
    public          postgres    false    222   |       ~          0    27510    doktor 
   TABLE DATA           k   COPY public.doktor (id, ad, soyad, tcno, kisitip, personelsifre, doktorturu, bransid, bransad) FROM stdin;
    public          postgres    false    219   �|       �          0    27522    duyuru 
   TABLE DATA           U   COPY public.duyuru (duyuruid, duyuruicerik, tarih, sekreterid, doktorid) FROM stdin;
    public          postgres    false    223   �|       �          0    27529    fatura 
   TABLE DATA           Q   COPY public.fatura (id, kisiid, randevuid, toplamtutar, odemedurumu) FROM stdin;
    public          postgres    false    225   A}       �          0    27516    hasta 
   TABLE DATA           R   COPY public.hasta (id, ad, soyad, tcno, kisitip, hastasifre, telefon) FROM stdin;
    public          postgres    false    221   j}       |          0    27504    kisi 
   TABLE DATA           <   COPY public.kisi (id, ad, soyad, tcno, kisitip) FROM stdin;
    public          postgres    false    217   �}       }          0    27507    personel 
   TABLE DATA           O   COPY public.personel (id, ad, soyad, tcno, kisitip, personelsifre) FROM stdin;
    public          postgres    false    218   �}       �          0    27535 
   randevular 
   TABLE DATA           �   COPY public.randevular (randevuid, tarih, saat, bransid, id, hastatc, sekreterid, doktorad, randevudurum, hastasikayet, bransad) FROM stdin;
    public          postgres    false    228   �}       �          0    27539    sekreter 
   TABLE DATA           \   COPY public.sekreter (id, ad, soyad, tcno, kisitip, personelsifre, odemedurumu) FROM stdin;
    public          postgres    false    230   3~       �          0    27543    yetiskinbrans 
   TABLE DATA           H   COPY public.yetiskinbrans (bransid, ad, branstipi, ekbilgi) FROM stdin;
    public          postgres    false    231   �~       �          0    27546    yetiskindoktor 
   TABLE DATA           �   COPY public.yetiskindoktor (id, ad, soyad, tcno, kisitip, personelsifre, doktorturu, bransid, uzmanlikalani, bransad) FROM stdin;
    public          postgres    false    232   �~       �          0    27549    yetiskinhasta 
   TABLE DATA           Z   COPY public.yetiskinhasta (id, ad, soyad, tcno, kisitip, hastasifre, telefon) FROM stdin;
    public          postgres    false    233   |       �           0    0    brans_bransid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.brans_bransid_seq', 7, true);
          public          postgres    false    215            �           0    0    duyuru_duyuruid_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.duyuru_duyuruid_seq', 2, true);
          public          postgres    false    224            �           0    0    fatura_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.fatura_id_seq', 4, true);
          public          postgres    false    226            �           0    0    kisi_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.kisi_id_seq', 9, true);
          public          postgres    false    227            �           0    0    randevular_randevuid_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.randevular_randevuid_seq', 11, true);
          public          postgres    false    229            �           2606    27569    brans brans_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.brans
    ADD CONSTRAINT brans_pkey PRIMARY KEY (bransid);
 :   ALTER TABLE ONLY public.brans DROP CONSTRAINT brans_pkey;
       public            postgres    false    214            �           2606    27571    brans bransid_unique 
   CONSTRAINT     R   ALTER TABLE ONLY public.brans
    ADD CONSTRAINT bransid_unique UNIQUE (bransid);
 >   ALTER TABLE ONLY public.brans DROP CONSTRAINT bransid_unique;
       public            postgres    false    214            �           2606    27573    cocukbrans cocukbrans_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.cocukbrans
    ADD CONSTRAINT cocukbrans_pkey PRIMARY KEY (bransid);
 D   ALTER TABLE ONLY public.cocukbrans DROP CONSTRAINT cocukbrans_pkey;
       public            postgres    false    216            �           2606    27575    cocukdoktoru cocukdoktoru_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.cocukdoktoru
    ADD CONSTRAINT cocukdoktoru_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.cocukdoktoru DROP CONSTRAINT cocukdoktoru_pkey;
       public            postgres    false    220            �           2606    27577    cocukhasta cocukhasta_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.cocukhasta
    ADD CONSTRAINT cocukhasta_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.cocukhasta DROP CONSTRAINT cocukhasta_pkey;
       public            postgres    false    222            �           2606    27579    doktor doktor_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktor_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.doktor DROP CONSTRAINT doktor_pkey;
       public            postgres    false    219            �           2606    27581    duyuru duyuru_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.duyuru
    ADD CONSTRAINT duyuru_pkey PRIMARY KEY (duyuruid);
 <   ALTER TABLE ONLY public.duyuru DROP CONSTRAINT duyuru_pkey;
       public            postgres    false    223            �           2606    27583    fatura fatura_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.fatura
    ADD CONSTRAINT fatura_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.fatura DROP CONSTRAINT fatura_pkey;
       public            postgres    false    225            �           2606    27585    hasta hasta_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT hasta_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.hasta DROP CONSTRAINT hasta_pkey;
       public            postgres    false    221            �           2606    27587    kisi kisi_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT kisi_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.kisi DROP CONSTRAINT kisi_pkey;
       public            postgres    false    217            �           2606    27589    kisi kisi_tcno_key 
   CONSTRAINT     M   ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT kisi_tcno_key UNIQUE (tcno);
 <   ALTER TABLE ONLY public.kisi DROP CONSTRAINT kisi_tcno_key;
       public            postgres    false    217            �           2606    27591    personel personel_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.personel DROP CONSTRAINT personel_pkey;
       public            postgres    false    218            �           2606    27593    randevular randevular_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT randevular_pkey PRIMARY KEY (randevuid);
 D   ALTER TABLE ONLY public.randevular DROP CONSTRAINT randevular_pkey;
       public            postgres    false    228            �           2606    27595    sekreter sekreter_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.sekreter
    ADD CONSTRAINT sekreter_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.sekreter DROP CONSTRAINT sekreter_pkey;
       public            postgres    false    230            �           2606    27597 *   yetiskinbrans yetiskinbrans_bransid_unique 
   CONSTRAINT     h   ALTER TABLE ONLY public.yetiskinbrans
    ADD CONSTRAINT yetiskinbrans_bransid_unique UNIQUE (bransid);
 T   ALTER TABLE ONLY public.yetiskinbrans DROP CONSTRAINT yetiskinbrans_bransid_unique;
       public            postgres    false    231            �           2606    27599     yetiskinbrans yetiskinbrans_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.yetiskinbrans
    ADD CONSTRAINT yetiskinbrans_pkey PRIMARY KEY (bransid);
 J   ALTER TABLE ONLY public.yetiskinbrans DROP CONSTRAINT yetiskinbrans_pkey;
       public            postgres    false    231            �           2606    27601 "   yetiskindoktor yetiskindoktor_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.yetiskindoktor
    ADD CONSTRAINT yetiskindoktor_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.yetiskindoktor DROP CONSTRAINT yetiskindoktor_pkey;
       public            postgres    false    232            �           2606    27603     yetiskinhasta yetiskinhasta_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.yetiskinhasta
    ADD CONSTRAINT yetiskinhasta_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.yetiskinhasta DROP CONSTRAINT yetiskinhasta_pkey;
       public            postgres    false    233            �           1259    27665    fki_R    INDEX     <   CREATE INDEX "fki_R" ON public.randevular USING btree (id);
    DROP INDEX public."fki_R";
       public            postgres    false    228            �           2620    27604    brans brans_silme    TRIGGER     u   CREATE TRIGGER brans_silme BEFORE DELETE ON public.brans FOR EACH ROW EXECUTE FUNCTION public.brans_silme_engelle();
 *   DROP TRIGGER brans_silme ON public.brans;
       public          postgres    false    235    214            �           2620    27605    doktor check_unique_id_doktor    TRIGGER     �   CREATE TRIGGER check_unique_id_doktor BEFORE INSERT OR UPDATE ON public.doktor FOR EACH ROW EXECUTE FUNCTION public.ensure_unique_id();
 6   DROP TRIGGER check_unique_id_doktor ON public.doktor;
       public          postgres    false    237    219            �           2620    27606    hasta check_unique_id_hasta    TRIGGER     �   CREATE TRIGGER check_unique_id_hasta BEFORE INSERT OR UPDATE ON public.hasta FOR EACH ROW EXECUTE FUNCTION public.ensure_unique_id();
 4   DROP TRIGGER check_unique_id_hasta ON public.hasta;
       public          postgres    false    237    221            �           2620    27607    kisi check_unique_id_kisi    TRIGGER     �   CREATE TRIGGER check_unique_id_kisi BEFORE INSERT OR UPDATE ON public.kisi FOR EACH ROW EXECUTE FUNCTION public.ensure_unique_id();
 2   DROP TRIGGER check_unique_id_kisi ON public.kisi;
       public          postgres    false    237    217            �           2620    27608 !   personel check_unique_id_personel    TRIGGER     �   CREATE TRIGGER check_unique_id_personel BEFORE INSERT OR UPDATE ON public.personel FOR EACH ROW EXECUTE FUNCTION public.ensure_unique_id();
 :   DROP TRIGGER check_unique_id_personel ON public.personel;
       public          postgres    false    237    218            �           2620    27609    doktor doktor_randevu_iptal    TRIGGER     y   CREATE TRIGGER doktor_randevu_iptal BEFORE DELETE ON public.doktor FOR EACH ROW EXECUTE FUNCTION public.randevu_iptal();
 4   DROP TRIGGER doktor_randevu_iptal ON public.doktor;
       public          postgres    false    219    241            �           2620    27610    randevular randevu_fatura_sil    TRIGGER     w   CREATE TRIGGER randevu_fatura_sil AFTER DELETE ON public.randevular FOR EACH ROW EXECUTE FUNCTION public.fatura_sil();
 6   DROP TRIGGER randevu_fatura_sil ON public.randevular;
       public          postgres    false    228    238            �           2606    27671    randevular doktorid_fkey    FK CONSTRAINT     s   ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT doktorid_fkey FOREIGN KEY (id) REFERENCES public.doktor(id);
 B   ALTER TABLE ONLY public.randevular DROP CONSTRAINT doktorid_fkey;
       public          postgres    false    219    228    3273            �           2606    27611    duyuru duyuru_doktorid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.duyuru
    ADD CONSTRAINT duyuru_doktorid_fkey FOREIGN KEY (doktorid) REFERENCES public.kisi(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public.duyuru DROP CONSTRAINT duyuru_doktorid_fkey;
       public          postgres    false    3267    223    217            �           2606    27616    duyuru duyuru_sekreterid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.duyuru
    ADD CONSTRAINT duyuru_sekreterid_fkey FOREIGN KEY (sekreterid) REFERENCES public.kisi(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.duyuru DROP CONSTRAINT duyuru_sekreterid_fkey;
       public          postgres    false    3267    217    223            y   %   x�3��.�I�VH*-*�SH�?2?���p;W� ��	�      {      x������ � �            x������ � �      �   {   x�3�LL�,.�4426153��40��H,.I��".S���� f )\*93rSK8#�l��M�¢,�ijlaanabf`�e��
�s�=5'3����I����������.P҂+F��� z�.~      ~   6   x���tK,*��L��L��O�)�4E �?NC#c0�\32s2+S�b���� L�      �   J   x�3�,NL,Q04�30PHIT(I,I�����$&'f��X��������Y���id`d�kh�kh��D\1z\\\ �P      �      x�3�4A=��=... �       �   5   x�3�J���,>�''�271�����������Ԅ�#��$,������� oG�      |      x������ � �      }      x������ � �      �   :   x�3�40�"##SNC+#�?r��M-Q�<�1'7�
*撘���Y������ �\�      �   W   x�3�J�M�J��t:�����lN#Sc2�N�.J-I-�4155563�,�2�, �dsfdV�dr��[X!�9Ӹb���� �q�      �   E   x�3�tI���ɬL���N�)P(KU�<�\!#��$1����Ģ�D�̜�̜Լ�<��̢�\�=... �m�      �   }   x�3�t�<:?��;�(�����������Ј�%?�$���!��ię~x[g��1�ojFnj	���Ԝ�lN�Nc�Z�9�Ks�Az9�Z#�l��M�JEU����Ԣ�ČLN ��Y������ �>4(      �      x������ � �     