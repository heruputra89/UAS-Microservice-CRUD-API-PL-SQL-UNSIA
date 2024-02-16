--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2024-02-16 17:31:42

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 219 (class 1255 OID 24599)
-- Name: user_log_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_log_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO public.user_log (action, user_id, new_data)
        VALUES ('INSERT', NEW.id, row_to_json(NEW));
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO public.user_log (action, user_id, old_data, new_data)
        VALUES ('UPDATE', NEW.id, row_to_json(OLD), row_to_json(NEW));
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO public.user_log (action, user_id, old_data)
        VALUES ('DELETE', OLD.id, row_to_json(OLD));
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.user_log_trigger() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 24590)
-- Name: user_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_log (
    log_id integer NOT NULL,
    action character varying(20) NOT NULL,
    user_id integer NOT NULL,
    old_data jsonb,
    new_data jsonb,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_log OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24589)
-- Name: user_log_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_log_log_id_seq OWNER TO postgres;

--
-- TOC entry 4804 (class 0 OID 0)
-- Dependencies: 217
-- Name: user_log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_log_log_id_seq OWNED BY public.user_log.log_id;


--
-- TOC entry 216 (class 1259 OID 16407)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password text NOT NULL,
    email character varying(100) NOT NULL,
    encrypted_data character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16406)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4641 (class 2604 OID 24593)
-- Name: user_log log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_log ALTER COLUMN log_id SET DEFAULT nextval('public.user_log_log_id_seq'::regclass);


--
-- TOC entry 4640 (class 2604 OID 16410)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4798 (class 0 OID 24590)
-- Dependencies: 218
-- Data for Name: user_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_log (log_id, action, user_id, old_data, new_data, "timestamp") FROM stdin;
1	INSERT	7	\N	{"id": 7, "email": "john.doe1@example.com", "password": "secure_password1", "username": "john_doe1", "encrypted_data": "df0+vTyolZf5BMfQXNxUxVrKgojI"}	2024-02-16 15:58:36.147627
2	INSERT	8	\N	{"id": 8, "email": "john.doe12@example.com", "password": "secure_password11", "username": "john_doe111", "encrypted_data": "QWXeagnLu6Pz1BIvGZMBB8Iq4IoI"}	2024-02-16 16:41:49.878852
3	UPDATE	4	{"id": 4, "email": "newuse222@example.com", "password": "securepassword123422", "username": "newuser122", "encrypted_data": "DxYfVcN22E+aeg8TyXeTQdf1xVgf7RfaRqI="}	{"id": 4, "email": "newuse222@example.com", "password": "securepassword123422", "username": "newuser122", "encrypted_data": "DGcGgSyZomYGlu3SHptUo1CQMpxUonBbuQWGOGX25V10SucZHdjCH2UMIcoxWWQR5izzUe2GfGPtZyyRIAqxdbeTDKRJ6Wjs9ZaLlOBVCKacKwkqLamitBBr"}	2024-02-16 17:17:35.0996
4	UPDATE	4	{"id": 4, "email": "newuse222@example.com", "password": "securepassword123422", "username": "newuser122", "encrypted_data": "DGcGgSyZomYGlu3SHptUo1CQMpxUonBbuQWGOGX25V10SucZHdjCH2UMIcoxWWQR5izzUe2GfGPtZyyRIAqxdbeTDKRJ6Wjs9ZaLlOBVCKacKwkqLamitBBr"}	{"id": 4, "email": "newuse222@example.com", "password": "securepassword123422", "username": "newuser122", "encrypted_data": "C95H5o7goCvWsfAWvTIuug+1cxOcUVCC4YVL+k2laltujMIs4Sl6BPjAqCGWvPiDH8yAuiJji5+EF4DEaM68JorqDrSCVPjUDNAuEW6ck//hP7thqQKHPymj"}	2024-02-16 17:18:20.867512
5	DELETE	4	{"id": 4, "email": "newuse222@example.com", "password": "securepassword123422", "username": "newuser122", "encrypted_data": "C95H5o7goCvWsfAWvTIuug+1cxOcUVCC4YVL+k2laltujMIs4Sl6BPjAqCGWvPiDH8yAuiJji5+EF4DEaM68JorqDrSCVPjUDNAuEW6ck//hP7thqQKHPymj"}	\N	2024-02-16 17:23:07.417875
\.


--
-- TOC entry 4796 (class 0 OID 16407)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email, encrypted_data) FROM stdin;
5	newuser12442	securepassword1234422	newuse2224@example.com	hLGKCAsmoxt/414SblODjF0J1dPwCSlAa5k=
7	john_doe1	secure_password1	john.doe1@example.com	df0+vTyolZf5BMfQXNxUxVrKgojI
8	john_doe111	secure_password11	john.doe12@example.com	QWXeagnLu6Pz1BIvGZMBB8Iq4IoI
\.


--
-- TOC entry 4806 (class 0 OID 0)
-- Dependencies: 217
-- Name: user_log_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_log_log_id_seq', 5, true);


--
-- TOC entry 4807 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- TOC entry 4650 (class 2606 OID 24598)
-- Name: user_log user_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_log
    ADD CONSTRAINT user_log_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4644 (class 2606 OID 16418)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4646 (class 2606 OID 16414)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4648 (class 2606 OID 16416)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4651 (class 2620 OID 24600)
-- Name: users users_log_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER users_log_trigger AFTER INSERT OR DELETE OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.user_log_trigger();


-- Completed on 2024-02-16 17:31:43

--
-- PostgreSQL database dump complete
--

