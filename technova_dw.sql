--
-- PostgreSQL database dump
--

\restrict JicrdvhdYs4MDAK68jRrDTjrcD5IFbMyhTpf075jAHgOMFRqMp2ZWem2vehFFsl

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: technova_dw; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA technova_dw;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dim_time; Type: TABLE; Schema: technova_dw; Owner: -
--

CREATE TABLE technova_dw.dim_time (
    date_sk integer NOT NULL,
    date_complete date NOT NULL,
    jour smallint NOT NULL,
    nom_jour character varying(12),
    mois smallint NOT NULL,
    nom_mois character varying(12),
    trimestre smallint NOT NULL,
    annee smallint NOT NULL,
    mois_annee character(7) NOT NULL,
    semaine_annee smallint,
    est_weekend smallint DEFAULT 0,
    CONSTRAINT dim_time_est_weekend_check CHECK ((est_weekend = ANY (ARRAY[0, 1])))
);


--
-- Name: dim_user; Type: TABLE; Schema: technova_dw; Owner: -
--

CREATE TABLE technova_dw.dim_user (
    user_sk integer NOT NULL,
    user_id integer NOT NULL,
    nom character varying(100),
    prenom character varying(100),
    email character varying(150),
    sexe character varying(20),
    tranche_age character varying(10),
    date_inscription date,
    date_inscription_sk integer,
    source_acquisition character varying(30),
    pays character varying(60),
    ville character varying(80),
    region character varying(20),
    zone_eco character varying(10),
    plan character varying(20),
    prix_mensuel_tnd numeric(8,2),
    est_payant smallint,
    statut character varying(20),
    date_debut_validite date DEFAULT CURRENT_DATE,
    date_fin_validite date,
    est_courant smallint DEFAULT 1,
    CONSTRAINT dim_user_est_courant_check CHECK ((est_courant = ANY (ARRAY[0, 1]))),
    CONSTRAINT dim_user_est_payant_check CHECK ((est_payant = ANY (ARRAY[0, 1])))
);


--
-- Name: dim_user_user_sk_seq; Type: SEQUENCE; Schema: technova_dw; Owner: -
--

CREATE SEQUENCE technova_dw.dim_user_user_sk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_user_user_sk_seq; Type: SEQUENCE OWNED BY; Schema: technova_dw; Owner: -
--

ALTER SEQUENCE technova_dw.dim_user_user_sk_seq OWNED BY technova_dw.dim_user.user_sk;


--
-- Name: fact_serverperformance; Type: TABLE; Schema: technova_dw; Owner: -
--

CREATE TABLE technova_dw.fact_serverperformance (
    perf_sk bigint NOT NULL,
    perf_id integer NOT NULL,
    date_sk integer,
    heure smallint,
    temps_reponse_ms integer,
    taux_erreur_pct numeric(5,2),
    cpu_usage_pct numeric(5,2),
    ram_usage_pct numeric(5,2),
    nb_requetes integer,
    statut_serveur character varying(20),
    est_incident smallint,
    etl_loaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fact_serverperformance_est_incident_check CHECK ((est_incident = ANY (ARRAY[0, 1])))
);


--
-- Name: fact_serverperformance_perf_sk_seq; Type: SEQUENCE; Schema: technova_dw; Owner: -
--

CREATE SEQUENCE technova_dw.fact_serverperformance_perf_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fact_serverperformance_perf_sk_seq; Type: SEQUENCE OWNED BY; Schema: technova_dw; Owner: -
--

ALTER SEQUENCE technova_dw.fact_serverperformance_perf_sk_seq OWNED BY technova_dw.fact_serverperformance.perf_sk;


--
-- Name: fact_sessions; Type: TABLE; Schema: technova_dw; Owner: -
--

CREATE TABLE technova_dw.fact_sessions (
    session_sk bigint NOT NULL,
    session_id integer NOT NULL,
    user_sk integer,
    date_sk integer,
    device character varying(20),
    os character varying(20),
    navigateur character varying(20),
    duree_secondes integer,
    duree_minutes numeric(6,1),
    pages_visitees integer,
    bounce smallint,
    est_longue_session smallint,
    nb_achats integer DEFAULT 0,
    nb_upgrades integer DEFAULT 0,
    revenu_session_tnd numeric(10,2) DEFAULT 0,
    nb_evenements_total integer DEFAULT 0,
    top_page_url character varying(200),
    top_page_categorie character varying(40),
    etl_loaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fact_sessions_bounce_check CHECK ((bounce = ANY (ARRAY[0, 1]))),
    CONSTRAINT fact_sessions_est_longue_session_check CHECK ((est_longue_session = ANY (ARRAY[0, 1])))
);


--
-- Name: fact_sessions_session_sk_seq; Type: SEQUENCE; Schema: technova_dw; Owner: -
--

CREATE SEQUENCE technova_dw.fact_sessions_session_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fact_sessions_session_sk_seq; Type: SEQUENCE OWNED BY; Schema: technova_dw; Owner: -
--

ALTER SEQUENCE technova_dw.fact_sessions_session_sk_seq OWNED BY technova_dw.fact_sessions.session_sk;


--
-- Name: fact_subscriptions; Type: TABLE; Schema: technova_dw; Owner: -
--

CREATE TABLE technova_dw.fact_subscriptions (
    sub_sk bigint NOT NULL,
    abonnement_id integer NOT NULL,
    user_sk integer,
    date_debut_sk integer,
    date_fin_sk integer,
    nom_plan character varying(20),
    prix_mensuel_tnd numeric(8,2),
    niveau_plan smallint,
    montant_tnd numeric(10,2),
    nb_jours_contrat integer,
    mode_paiement character varying(20),
    statut character varying(20),
    est_actif smallint,
    est_churn smallint,
    est_renouvellement smallint,
    etl_loaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fact_subscriptions_est_actif_check CHECK ((est_actif = ANY (ARRAY[0, 1]))),
    CONSTRAINT fact_subscriptions_est_churn_check CHECK ((est_churn = ANY (ARRAY[0, 1]))),
    CONSTRAINT fact_subscriptions_est_renouvellement_check CHECK ((est_renouvellement = ANY (ARRAY[0, 1])))
);


--
-- Name: fact_subscriptions_sub_sk_seq; Type: SEQUENCE; Schema: technova_dw; Owner: -
--

CREATE SEQUENCE technova_dw.fact_subscriptions_sub_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fact_subscriptions_sub_sk_seq; Type: SEQUENCE OWNED BY; Schema: technova_dw; Owner: -
--

ALTER SEQUENCE technova_dw.fact_subscriptions_sub_sk_seq OWNED BY technova_dw.fact_subscriptions.sub_sk;


--
-- Name: fact_support; Type: TABLE; Schema: technova_dw; Owner: -
--

CREATE TABLE technova_dw.fact_support (
    ticket_sk bigint NOT NULL,
    ticket_id integer NOT NULL,
    user_sk integer,
    date_creation_sk integer,
    date_resolution_sk integer,
    categorie character varying(30),
    priorite character varying(20),
    sla_heures numeric(5,1),
    est_critique smallint,
    resolution_heures numeric(8,1),
    csat_score integer,
    est_resolu smallint,
    est_sla_respecte smallint,
    statut character varying(20),
    etl_loaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fact_support_est_critique_check CHECK ((est_critique = ANY (ARRAY[0, 1]))),
    CONSTRAINT fact_support_est_resolu_check CHECK ((est_resolu = ANY (ARRAY[0, 1]))),
    CONSTRAINT fact_support_est_sla_respecte_check CHECK ((est_sla_respecte = ANY (ARRAY[0, 1])))
);


--
-- Name: fact_support_ticket_sk_seq; Type: SEQUENCE; Schema: technova_dw; Owner: -
--

CREATE SEQUENCE technova_dw.fact_support_ticket_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fact_support_ticket_sk_seq; Type: SEQUENCE OWNED BY; Schema: technova_dw; Owner: -
--

ALTER SEQUENCE technova_dw.fact_support_ticket_sk_seq OWNED BY technova_dw.fact_support.ticket_sk;


--
-- Name: dim_user user_sk; Type: DEFAULT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.dim_user ALTER COLUMN user_sk SET DEFAULT nextval('technova_dw.dim_user_user_sk_seq'::regclass);


--
-- Name: fact_serverperformance perf_sk; Type: DEFAULT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_serverperformance ALTER COLUMN perf_sk SET DEFAULT nextval('technova_dw.fact_serverperformance_perf_sk_seq'::regclass);


--
-- Name: fact_sessions session_sk; Type: DEFAULT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_sessions ALTER COLUMN session_sk SET DEFAULT nextval('technova_dw.fact_sessions_session_sk_seq'::regclass);


--
-- Name: fact_subscriptions sub_sk; Type: DEFAULT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_subscriptions ALTER COLUMN sub_sk SET DEFAULT nextval('technova_dw.fact_subscriptions_sub_sk_seq'::regclass);


--
-- Name: fact_support ticket_sk; Type: DEFAULT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_support ALTER COLUMN ticket_sk SET DEFAULT nextval('technova_dw.fact_support_ticket_sk_seq'::regclass);


--
-- Data for Name: dim_time; Type: TABLE DATA; Schema: technova_dw; Owner: -
--

COPY technova_dw.dim_time (date_sk, date_complete, jour, nom_jour, mois, nom_mois, trimestre, annee, mois_annee, semaine_annee, est_weekend) FROM stdin;
20200101	2020-01-01	1	Wednesday	1	January	1	2020	2020-01	1	0
20200102	2020-01-02	2	Thursday	1	January	1	2020	2020-01	1	0
20200103	2020-01-03	3	Friday	1	January	1	2020	2020-01	1	0
20200104	2020-01-04	4	Saturday	1	January	1	2020	2020-01	1	1
20200105	2020-01-05	5	Sunday	1	January	1	2020	2020-01	1	1
20200106	2020-01-06	6	Monday	1	January	1	2020	2020-01	2	0
20200107	2020-01-07	7	Tuesday	1	January	1	2020	2020-01	2	0
20200108	2020-01-08	8	Wednesday	1	January	1	2020	2020-01	2	0
20200109	2020-01-09	9	Thursday	1	January	1	2020	2020-01	2	0
20200110	2020-01-10	10	Friday	1	January	1	2020	2020-01	2	0
20200111	2020-01-11	11	Saturday	1	January	1	2020	2020-01	2	1
20200112	2020-01-12	12	Sunday	1	January	1	2020	2020-01	2	1
20200113	2020-01-13	13	Monday	1	January	1	2020	2020-01	3	0
20200114	2020-01-14	14	Tuesday	1	January	1	2020	2020-01	3	0
20200115	2020-01-15	15	Wednesday	1	January	1	2020	2020-01	3	0
20200116	2020-01-16	16	Thursday	1	January	1	2020	2020-01	3	0
20200117	2020-01-17	17	Friday	1	January	1	2020	2020-01	3	0
20200118	2020-01-18	18	Saturday	1	January	1	2020	2020-01	3	1
20200119	2020-01-19	19	Sunday	1	January	1	2020	2020-01	3	1
20200120	2020-01-20	20	Monday	1	January	1	2020	2020-01	4	0
20200121	2020-01-21	21	Tuesday	1	January	1	2020	2020-01	4	0
20200122	2020-01-22	22	Wednesday	1	January	1	2020	2020-01	4	0
20200123	2020-01-23	23	Thursday	1	January	1	2020	2020-01	4	0
20200124	2020-01-24	24	Friday	1	January	1	2020	2020-01	4	0
20200125	2020-01-25	25	Saturday	1	January	1	2020	2020-01	4	1
20200126	2020-01-26	26	Sunday	1	January	1	2020	2020-01	4	1
20200127	2020-01-27	27	Monday	1	January	1	2020	2020-01	5	0
20200128	2020-01-28	28	Tuesday	1	January	1	2020	2020-01	5	0
20200129	2020-01-29	29	Wednesday	1	January	1	2020	2020-01	5	0
20200130	2020-01-30	30	Thursday	1	January	1	2020	2020-01	5	0
20200131	2020-01-31	31	Friday	1	January	1	2020	2020-01	5	0
20200201	2020-02-01	1	Saturday	2	February	1	2020	2020-02	5	1
20200202	2020-02-02	2	Sunday	2	February	1	2020	2020-02	5	1
20200203	2020-02-03	3	Monday	2	February	1	2020	2020-02	6	0
20200204	2020-02-04	4	Tuesday	2	February	1	2020	2020-02	6	0
20200205	2020-02-05	5	Wednesday	2	February	1	2020	2020-02	6	0
20200206	2020-02-06	6	Thursday	2	February	1	2020	2020-02	6	0
20200207	2020-02-07	7	Friday	2	February	1	2020	2020-02	6	0
20200208	2020-02-08	8	Saturday	2	February	1	2020	2020-02	6	1
20200209	2020-02-09	9	Sunday	2	February	1	2020	2020-02	6	1
20200210	2020-02-10	10	Monday	2	February	1	2020	2020-02	7	0
20200211	2020-02-11	11	Tuesday	2	February	1	2020	2020-02	7	0
20200212	2020-02-12	12	Wednesday	2	February	1	2020	2020-02	7	0
20200213	2020-02-13	13	Thursday	2	February	1	2020	2020-02	7	0
20200214	2020-02-14	14	Friday	2	February	1	2020	2020-02	7	0
20200215	2020-02-15	15	Saturday	2	February	1	2020	2020-02	7	1
20200216	2020-02-16	16	Sunday	2	February	1	2020	2020-02	7	1
20200217	2020-02-17	17	Monday	2	February	1	2020	2020-02	8	0
20200218	2020-02-18	18	Tuesday	2	February	1	2020	2020-02	8	0
20200219	2020-02-19	19	Wednesday	2	February	1	2020	2020-02	8	0
20200220	2020-02-20	20	Thursday	2	February	1	2020	2020-02	8	0
20200221	2020-02-21	21	Friday	2	February	1	2020	2020-02	8	0
20200222	2020-02-22	22	Saturday	2	February	1	2020	2020-02	8	1
20200223	2020-02-23	23	Sunday	2	February	1	2020	2020-02	8	1
20200224	2020-02-24	24	Monday	2	February	1	2020	2020-02	9	0
20200225	2020-02-25	25	Tuesday	2	February	1	2020	2020-02	9	0
20200226	2020-02-26	26	Wednesday	2	February	1	2020	2020-02	9	0
20200227	2020-02-27	27	Thursday	2	February	1	2020	2020-02	9	0
20200228	2020-02-28	28	Friday	2	February	1	2020	2020-02	9	0
20200229	2020-02-29	29	Saturday	2	February	1	2020	2020-02	9	1
20200301	2020-03-01	1	Sunday	3	March	1	2020	2020-03	9	1
20200302	2020-03-02	2	Monday	3	March	1	2020	2020-03	10	0
20200303	2020-03-03	3	Tuesday	3	March	1	2020	2020-03	10	0
20200304	2020-03-04	4	Wednesday	3	March	1	2020	2020-03	10	0
20200305	2020-03-05	5	Thursday	3	March	1	2020	2020-03	10	0
20200306	2020-03-06	6	Friday	3	March	1	2020	2020-03	10	0
20200307	2020-03-07	7	Saturday	3	March	1	2020	2020-03	10	1
20200308	2020-03-08	8	Sunday	3	March	1	2020	2020-03	10	1
20200309	2020-03-09	9	Monday	3	March	1	2020	2020-03	11	0
20200310	2020-03-10	10	Tuesday	3	March	1	2020	2020-03	11	0
20200311	2020-03-11	11	Wednesday	3	March	1	2020	2020-03	11	0
20200312	2020-03-12	12	Thursday	3	March	1	2020	2020-03	11	0
20200313	2020-03-13	13	Friday	3	March	1	2020	2020-03	11	0
20200314	2020-03-14	14	Saturday	3	March	1	2020	2020-03	11	1
20200315	2020-03-15	15	Sunday	3	March	1	2020	2020-03	11	1
20200316	2020-03-16	16	Monday	3	March	1	2020	2020-03	12	0
20200317	2020-03-17	17	Tuesday	3	March	1	2020	2020-03	12	0
20200318	2020-03-18	18	Wednesday	3	March	1	2020	2020-03	12	0
20200319	2020-03-19	19	Thursday	3	March	1	2020	2020-03	12	0
20200320	2020-03-20	20	Friday	3	March	1	2020	2020-03	12	0
20200321	2020-03-21	21	Saturday	3	March	1	2020	2020-03	12	1
20200322	2020-03-22	22	Sunday	3	March	1	2020	2020-03	12	1
20200323	2020-03-23	23	Monday	3	March	1	2020	2020-03	13	0
20200324	2020-03-24	24	Tuesday	3	March	1	2020	2020-03	13	0
20200325	2020-03-25	25	Wednesday	3	March	1	2020	2020-03	13	0
20200326	2020-03-26	26	Thursday	3	March	1	2020	2020-03	13	0
20200327	2020-03-27	27	Friday	3	March	1	2020	2020-03	13	0
20200328	2020-03-28	28	Saturday	3	March	1	2020	2020-03	13	1
20200329	2020-03-29	29	Sunday	3	March	1	2020	2020-03	13	1
20200330	2020-03-30	30	Monday	3	March	1	2020	2020-03	14	0
20200331	2020-03-31	31	Tuesday	3	March	1	2020	2020-03	14	0
20200401	2020-04-01	1	Wednesday	4	April	2	2020	2020-04	14	0
20200402	2020-04-02	2	Thursday	4	April	2	2020	2020-04	14	0
20200403	2020-04-03	3	Friday	4	April	2	2020	2020-04	14	0
20200404	2020-04-04	4	Saturday	4	April	2	2020	2020-04	14	1
20200405	2020-04-05	5	Sunday	4	April	2	2020	2020-04	14	1
20200406	2020-04-06	6	Monday	4	April	2	2020	2020-04	15	0
20200407	2020-04-07	7	Tuesday	4	April	2	2020	2020-04	15	0
20200408	2020-04-08	8	Wednesday	4	April	2	2020	2020-04	15	0
20200409	2020-04-09	9	Thursday	4	April	2	2020	2020-04	15	0
20200410	2020-04-10	10	Friday	4	April	2	2020	2020-04	15	0
20200411	2020-04-11	11	Saturday	4	April	2	2020	2020-04	15	1
20200412	2020-04-12	12	Sunday	4	April	2	2020	2020-04	15	1
20200413	2020-04-13	13	Monday	4	April	2	2020	2020-04	16	0
20200414	2020-04-14	14	Tuesday	4	April	2	2020	2020-04	16	0
20200415	2020-04-15	15	Wednesday	4	April	2	2020	2020-04	16	0
20200416	2020-04-16	16	Thursday	4	April	2	2020	2020-04	16	0
20200417	2020-04-17	17	Friday	4	April	2	2020	2020-04	16	0
20200418	2020-04-18	18	Saturday	4	April	2	2020	2020-04	16	1
20200419	2020-04-19	19	Sunday	4	April	2	2020	2020-04	16	1
20200420	2020-04-20	20	Monday	4	April	2	2020	2020-04	17	0
20200421	2020-04-21	21	Tuesday	4	April	2	2020	2020-04	17	0
20200422	2020-04-22	22	Wednesday	4	April	2	2020	2020-04	17	0
20200423	2020-04-23	23	Thursday	4	April	2	2020	2020-04	17	0
20200424	2020-04-24	24	Friday	4	April	2	2020	2020-04	17	0
20200425	2020-04-25	25	Saturday	4	April	2	2020	2020-04	17	1
20200426	2020-04-26	26	Sunday	4	April	2	2020	2020-04	17	1
20200427	2020-04-27	27	Monday	4	April	2	2020	2020-04	18	0
20200428	2020-04-28	28	Tuesday	4	April	2	2020	2020-04	18	0
20200429	2020-04-29	29	Wednesday	4	April	2	2020	2020-04	18	0
20200430	2020-04-30	30	Thursday	4	April	2	2020	2020-04	18	0
20200501	2020-05-01	1	Friday	5	May	2	2020	2020-05	18	0
20200502	2020-05-02	2	Saturday	5	May	2	2020	2020-05	18	1
20200503	2020-05-03	3	Sunday	5	May	2	2020	2020-05	18	1
20200504	2020-05-04	4	Monday	5	May	2	2020	2020-05	19	0
20200505	2020-05-05	5	Tuesday	5	May	2	2020	2020-05	19	0
20200506	2020-05-06	6	Wednesday	5	May	2	2020	2020-05	19	0
20200507	2020-05-07	7	Thursday	5	May	2	2020	2020-05	19	0
20200508	2020-05-08	8	Friday	5	May	2	2020	2020-05	19	0
20200509	2020-05-09	9	Saturday	5	May	2	2020	2020-05	19	1
20200510	2020-05-10	10	Sunday	5	May	2	2020	2020-05	19	1
20200511	2020-05-11	11	Monday	5	May	2	2020	2020-05	20	0
20200512	2020-05-12	12	Tuesday	5	May	2	2020	2020-05	20	0
20200513	2020-05-13	13	Wednesday	5	May	2	2020	2020-05	20	0
20200514	2020-05-14	14	Thursday	5	May	2	2020	2020-05	20	0
20200515	2020-05-15	15	Friday	5	May	2	2020	2020-05	20	0
20200516	2020-05-16	16	Saturday	5	May	2	2020	2020-05	20	1
20200517	2020-05-17	17	Sunday	5	May	2	2020	2020-05	20	1
20200518	2020-05-18	18	Monday	5	May	2	2020	2020-05	21	0
20200519	2020-05-19	19	Tuesday	5	May	2	2020	2020-05	21	0
20200520	2020-05-20	20	Wednesday	5	May	2	2020	2020-05	21	0
20200521	2020-05-21	21	Thursday	5	May	2	2020	2020-05	21	0
20200522	2020-05-22	22	Friday	5	May	2	2020	2020-05	21	0
20200523	2020-05-23	23	Saturday	5	May	2	2020	2020-05	21	1
20200524	2020-05-24	24	Sunday	5	May	2	2020	2020-05	21	1
20200525	2020-05-25	25	Monday	5	May	2	2020	2020-05	22	0
20200526	2020-05-26	26	Tuesday	5	May	2	2020	2020-05	22	0
20200527	2020-05-27	27	Wednesday	5	May	2	2020	2020-05	22	0
20200528	2020-05-28	28	Thursday	5	May	2	2020	2020-05	22	0
20200529	2020-05-29	29	Friday	5	May	2	2020	2020-05	22	0
20200530	2020-05-30	30	Saturday	5	May	2	2020	2020-05	22	1
20200531	2020-05-31	31	Sunday	5	May	2	2020	2020-05	22	1
20200601	2020-06-01	1	Monday	6	June	2	2020	2020-06	23	0
20200602	2020-06-02	2	Tuesday	6	June	2	2020	2020-06	23	0
20200603	2020-06-03	3	Wednesday	6	June	2	2020	2020-06	23	0
20200604	2020-06-04	4	Thursday	6	June	2	2020	2020-06	23	0
20200605	2020-06-05	5	Friday	6	June	2	2020	2020-06	23	0
20200606	2020-06-06	6	Saturday	6	June	2	2020	2020-06	23	1
20200607	2020-06-07	7	Sunday	6	June	2	2020	2020-06	23	1
20200608	2020-06-08	8	Monday	6	June	2	2020	2020-06	24	0
20200609	2020-06-09	9	Tuesday	6	June	2	2020	2020-06	24	0
20200610	2020-06-10	10	Wednesday	6	June	2	2020	2020-06	24	0
20200611	2020-06-11	11	Thursday	6	June	2	2020	2020-06	24	0
20200612	2020-06-12	12	Friday	6	June	2	2020	2020-06	24	0
20200613	2020-06-13	13	Saturday	6	June	2	2020	2020-06	24	1
20200614	2020-06-14	14	Sunday	6	June	2	2020	2020-06	24	1
20200615	2020-06-15	15	Monday	6	June	2	2020	2020-06	25	0
20200616	2020-06-16	16	Tuesday	6	June	2	2020	2020-06	25	0
20200617	2020-06-17	17	Wednesday	6	June	2	2020	2020-06	25	0
20200618	2020-06-18	18	Thursday	6	June	2	2020	2020-06	25	0
20200619	2020-06-19	19	Friday	6	June	2	2020	2020-06	25	0
20200620	2020-06-20	20	Saturday	6	June	2	2020	2020-06	25	1
20200621	2020-06-21	21	Sunday	6	June	2	2020	2020-06	25	1
20200622	2020-06-22	22	Monday	6	June	2	2020	2020-06	26	0
20200623	2020-06-23	23	Tuesday	6	June	2	2020	2020-06	26	0
20200624	2020-06-24	24	Wednesday	6	June	2	2020	2020-06	26	0
20200625	2020-06-25	25	Thursday	6	June	2	2020	2020-06	26	0
20200626	2020-06-26	26	Friday	6	June	2	2020	2020-06	26	0
20200627	2020-06-27	27	Saturday	6	June	2	2020	2020-06	26	1
20200628	2020-06-28	28	Sunday	6	June	2	2020	2020-06	26	1
20200629	2020-06-29	29	Monday	6	June	2	2020	2020-06	27	0
20200630	2020-06-30	30	Tuesday	6	June	2	2020	2020-06	27	0
20200701	2020-07-01	1	Wednesday	7	July	3	2020	2020-07	27	0
20200702	2020-07-02	2	Thursday	7	July	3	2020	2020-07	27	0
20200703	2020-07-03	3	Friday	7	July	3	2020	2020-07	27	0
20200704	2020-07-04	4	Saturday	7	July	3	2020	2020-07	27	1
20200705	2020-07-05	5	Sunday	7	July	3	2020	2020-07	27	1
20200706	2020-07-06	6	Monday	7	July	3	2020	2020-07	28	0
20200707	2020-07-07	7	Tuesday	7	July	3	2020	2020-07	28	0
20200708	2020-07-08	8	Wednesday	7	July	3	2020	2020-07	28	0
20200709	2020-07-09	9	Thursday	7	July	3	2020	2020-07	28	0
20200710	2020-07-10	10	Friday	7	July	3	2020	2020-07	28	0
20200711	2020-07-11	11	Saturday	7	July	3	2020	2020-07	28	1
20200712	2020-07-12	12	Sunday	7	July	3	2020	2020-07	28	1
20200713	2020-07-13	13	Monday	7	July	3	2020	2020-07	29	0
20200714	2020-07-14	14	Tuesday	7	July	3	2020	2020-07	29	0
20200715	2020-07-15	15	Wednesday	7	July	3	2020	2020-07	29	0
20200716	2020-07-16	16	Thursday	7	July	3	2020	2020-07	29	0
20200717	2020-07-17	17	Friday	7	July	3	2020	2020-07	29	0
20200718	2020-07-18	18	Saturday	7	July	3	2020	2020-07	29	1
20200719	2020-07-19	19	Sunday	7	July	3	2020	2020-07	29	1
20200720	2020-07-20	20	Monday	7	July	3	2020	2020-07	30	0
20200721	2020-07-21	21	Tuesday	7	July	3	2020	2020-07	30	0
20200722	2020-07-22	22	Wednesday	7	July	3	2020	2020-07	30	0
20200723	2020-07-23	23	Thursday	7	July	3	2020	2020-07	30	0
20200724	2020-07-24	24	Friday	7	July	3	2020	2020-07	30	0
20200725	2020-07-25	25	Saturday	7	July	3	2020	2020-07	30	1
20200726	2020-07-26	26	Sunday	7	July	3	2020	2020-07	30	1
20200727	2020-07-27	27	Monday	7	July	3	2020	2020-07	31	0
20200728	2020-07-28	28	Tuesday	7	July	3	2020	2020-07	31	0
20200729	2020-07-29	29	Wednesday	7	July	3	2020	2020-07	31	0
20200730	2020-07-30	30	Thursday	7	July	3	2020	2020-07	31	0
20200731	2020-07-31	31	Friday	7	July	3	2020	2020-07	31	0
20200801	2020-08-01	1	Saturday	8	August	3	2020	2020-08	31	1
20200802	2020-08-02	2	Sunday	8	August	3	2020	2020-08	31	1
20200803	2020-08-03	3	Monday	8	August	3	2020	2020-08	32	0
20200804	2020-08-04	4	Tuesday	8	August	3	2020	2020-08	32	0
20200805	2020-08-05	5	Wednesday	8	August	3	2020	2020-08	32	0
20200806	2020-08-06	6	Thursday	8	August	3	2020	2020-08	32	0
20200807	2020-08-07	7	Friday	8	August	3	2020	2020-08	32	0
20200808	2020-08-08	8	Saturday	8	August	3	2020	2020-08	32	1
20200809	2020-08-09	9	Sunday	8	August	3	2020	2020-08	32	1
20200810	2020-08-10	10	Monday	8	August	3	2020	2020-08	33	0
20200811	2020-08-11	11	Tuesday	8	August	3	2020	2020-08	33	0
20200812	2020-08-12	12	Wednesday	8	August	3	2020	2020-08	33	0
20200813	2020-08-13	13	Thursday	8	August	3	2020	2020-08	33	0
20200814	2020-08-14	14	Friday	8	August	3	2020	2020-08	33	0
20200815	2020-08-15	15	Saturday	8	August	3	2020	2020-08	33	1
20200816	2020-08-16	16	Sunday	8	August	3	2020	2020-08	33	1
20200817	2020-08-17	17	Monday	8	August	3	2020	2020-08	34	0
20200818	2020-08-18	18	Tuesday	8	August	3	2020	2020-08	34	0
20200819	2020-08-19	19	Wednesday	8	August	3	2020	2020-08	34	0
20200820	2020-08-20	20	Thursday	8	August	3	2020	2020-08	34	0
20200821	2020-08-21	21	Friday	8	August	3	2020	2020-08	34	0
20200822	2020-08-22	22	Saturday	8	August	3	2020	2020-08	34	1
20200823	2020-08-23	23	Sunday	8	August	3	2020	2020-08	34	1
20200824	2020-08-24	24	Monday	8	August	3	2020	2020-08	35	0
20200825	2020-08-25	25	Tuesday	8	August	3	2020	2020-08	35	0
20200826	2020-08-26	26	Wednesday	8	August	3	2020	2020-08	35	0
20200827	2020-08-27	27	Thursday	8	August	3	2020	2020-08	35	0
20200828	2020-08-28	28	Friday	8	August	3	2020	2020-08	35	0
20200829	2020-08-29	29	Saturday	8	August	3	2020	2020-08	35	1
20200830	2020-08-30	30	Sunday	8	August	3	2020	2020-08	35	1
20200831	2020-08-31	31	Monday	8	August	3	2020	2020-08	36	0
20200901	2020-09-01	1	Tuesday	9	September	3	2020	2020-09	36	0
20200902	2020-09-02	2	Wednesday	9	September	3	2020	2020-09	36	0
20200903	2020-09-03	3	Thursday	9	September	3	2020	2020-09	36	0
20200904	2020-09-04	4	Friday	9	September	3	2020	2020-09	36	0
20200905	2020-09-05	5	Saturday	9	September	3	2020	2020-09	36	1
20200906	2020-09-06	6	Sunday	9	September	3	2020	2020-09	36	1
20200907	2020-09-07	7	Monday	9	September	3	2020	2020-09	37	0
20200908	2020-09-08	8	Tuesday	9	September	3	2020	2020-09	37	0
20200909	2020-09-09	9	Wednesday	9	September	3	2020	2020-09	37	0
20200910	2020-09-10	10	Thursday	9	September	3	2020	2020-09	37	0
20200911	2020-09-11	11	Friday	9	September	3	2020	2020-09	37	0
20200912	2020-09-12	12	Saturday	9	September	3	2020	2020-09	37	1
20200913	2020-09-13	13	Sunday	9	September	3	2020	2020-09	37	1
20200914	2020-09-14	14	Monday	9	September	3	2020	2020-09	38	0
20200915	2020-09-15	15	Tuesday	9	September	3	2020	2020-09	38	0
20200916	2020-09-16	16	Wednesday	9	September	3	2020	2020-09	38	0
20200917	2020-09-17	17	Thursday	9	September	3	2020	2020-09	38	0
20200918	2020-09-18	18	Friday	9	September	3	2020	2020-09	38	0
20200919	2020-09-19	19	Saturday	9	September	3	2020	2020-09	38	1
20200920	2020-09-20	20	Sunday	9	September	3	2020	2020-09	38	1
20200921	2020-09-21	21	Monday	9	September	3	2020	2020-09	39	0
20200922	2020-09-22	22	Tuesday	9	September	3	2020	2020-09	39	0
20200923	2020-09-23	23	Wednesday	9	September	3	2020	2020-09	39	0
20200924	2020-09-24	24	Thursday	9	September	3	2020	2020-09	39	0
20200925	2020-09-25	25	Friday	9	September	3	2020	2020-09	39	0
20200926	2020-09-26	26	Saturday	9	September	3	2020	2020-09	39	1
20200927	2020-09-27	27	Sunday	9	September	3	2020	2020-09	39	1
20200928	2020-09-28	28	Monday	9	September	3	2020	2020-09	40	0
20200929	2020-09-29	29	Tuesday	9	September	3	2020	2020-09	40	0
20200930	2020-09-30	30	Wednesday	9	September	3	2020	2020-09	40	0
20201001	2020-10-01	1	Thursday	10	October	4	2020	2020-10	40	0
20201002	2020-10-02	2	Friday	10	October	4	2020	2020-10	40	0
20201003	2020-10-03	3	Saturday	10	October	4	2020	2020-10	40	1
20201004	2020-10-04	4	Sunday	10	October	4	2020	2020-10	40	1
20201005	2020-10-05	5	Monday	10	October	4	2020	2020-10	41	0
20201006	2020-10-06	6	Tuesday	10	October	4	2020	2020-10	41	0
20201007	2020-10-07	7	Wednesday	10	October	4	2020	2020-10	41	0
20201008	2020-10-08	8	Thursday	10	October	4	2020	2020-10	41	0
20201009	2020-10-09	9	Friday	10	October	4	2020	2020-10	41	0
20201010	2020-10-10	10	Saturday	10	October	4	2020	2020-10	41	1
20201011	2020-10-11	11	Sunday	10	October	4	2020	2020-10	41	1
20201012	2020-10-12	12	Monday	10	October	4	2020	2020-10	42	0
20201013	2020-10-13	13	Tuesday	10	October	4	2020	2020-10	42	0
20201014	2020-10-14	14	Wednesday	10	October	4	2020	2020-10	42	0
20201015	2020-10-15	15	Thursday	10	October	4	2020	2020-10	42	0
20201016	2020-10-16	16	Friday	10	October	4	2020	2020-10	42	0
20201017	2020-10-17	17	Saturday	10	October	4	2020	2020-10	42	1
20201018	2020-10-18	18	Sunday	10	October	4	2020	2020-10	42	1
20201019	2020-10-19	19	Monday	10	October	4	2020	2020-10	43	0
20201020	2020-10-20	20	Tuesday	10	October	4	2020	2020-10	43	0
20201021	2020-10-21	21	Wednesday	10	October	4	2020	2020-10	43	0
20201022	2020-10-22	22	Thursday	10	October	4	2020	2020-10	43	0
20201023	2020-10-23	23	Friday	10	October	4	2020	2020-10	43	0
20201024	2020-10-24	24	Saturday	10	October	4	2020	2020-10	43	1
20201025	2020-10-25	25	Sunday	10	October	4	2020	2020-10	43	1
20201026	2020-10-26	26	Monday	10	October	4	2020	2020-10	44	0
20201027	2020-10-27	27	Tuesday	10	October	4	2020	2020-10	44	0
20201028	2020-10-28	28	Wednesday	10	October	4	2020	2020-10	44	0
20201029	2020-10-29	29	Thursday	10	October	4	2020	2020-10	44	0
20201030	2020-10-30	30	Friday	10	October	4	2020	2020-10	44	0
20201031	2020-10-31	31	Saturday	10	October	4	2020	2020-10	44	1
20201101	2020-11-01	1	Sunday	11	November	4	2020	2020-11	44	1
20201102	2020-11-02	2	Monday	11	November	4	2020	2020-11	45	0
20201103	2020-11-03	3	Tuesday	11	November	4	2020	2020-11	45	0
20201104	2020-11-04	4	Wednesday	11	November	4	2020	2020-11	45	0
20201105	2020-11-05	5	Thursday	11	November	4	2020	2020-11	45	0
20201106	2020-11-06	6	Friday	11	November	4	2020	2020-11	45	0
20201107	2020-11-07	7	Saturday	11	November	4	2020	2020-11	45	1
20201108	2020-11-08	8	Sunday	11	November	4	2020	2020-11	45	1
20201109	2020-11-09	9	Monday	11	November	4	2020	2020-11	46	0
20201110	2020-11-10	10	Tuesday	11	November	4	2020	2020-11	46	0
20201111	2020-11-11	11	Wednesday	11	November	4	2020	2020-11	46	0
20201112	2020-11-12	12	Thursday	11	November	4	2020	2020-11	46	0
20201113	2020-11-13	13	Friday	11	November	4	2020	2020-11	46	0
20201114	2020-11-14	14	Saturday	11	November	4	2020	2020-11	46	1
20201115	2020-11-15	15	Sunday	11	November	4	2020	2020-11	46	1
20201116	2020-11-16	16	Monday	11	November	4	2020	2020-11	47	0
20201117	2020-11-17	17	Tuesday	11	November	4	2020	2020-11	47	0
20201118	2020-11-18	18	Wednesday	11	November	4	2020	2020-11	47	0
20201119	2020-11-19	19	Thursday	11	November	4	2020	2020-11	47	0
20201120	2020-11-20	20	Friday	11	November	4	2020	2020-11	47	0
20201121	2020-11-21	21	Saturday	11	November	4	2020	2020-11	47	1
20201122	2020-11-22	22	Sunday	11	November	4	2020	2020-11	47	1
20201123	2020-11-23	23	Monday	11	November	4	2020	2020-11	48	0
20201124	2020-11-24	24	Tuesday	11	November	4	2020	2020-11	48	0
20201125	2020-11-25	25	Wednesday	11	November	4	2020	2020-11	48	0
20201126	2020-11-26	26	Thursday	11	November	4	2020	2020-11	48	0
20201127	2020-11-27	27	Friday	11	November	4	2020	2020-11	48	0
20201128	2020-11-28	28	Saturday	11	November	4	2020	2020-11	48	1
20201129	2020-11-29	29	Sunday	11	November	4	2020	2020-11	48	1
20201130	2020-11-30	30	Monday	11	November	4	2020	2020-11	49	0
20201201	2020-12-01	1	Tuesday	12	December	4	2020	2020-12	49	0
20201202	2020-12-02	2	Wednesday	12	December	4	2020	2020-12	49	0
20201203	2020-12-03	3	Thursday	12	December	4	2020	2020-12	49	0
20201204	2020-12-04	4	Friday	12	December	4	2020	2020-12	49	0
20201205	2020-12-05	5	Saturday	12	December	4	2020	2020-12	49	1
20201206	2020-12-06	6	Sunday	12	December	4	2020	2020-12	49	1
20201207	2020-12-07	7	Monday	12	December	4	2020	2020-12	50	0
20201208	2020-12-08	8	Tuesday	12	December	4	2020	2020-12	50	0
20201209	2020-12-09	9	Wednesday	12	December	4	2020	2020-12	50	0
20201210	2020-12-10	10	Thursday	12	December	4	2020	2020-12	50	0
20201211	2020-12-11	11	Friday	12	December	4	2020	2020-12	50	0
20201212	2020-12-12	12	Saturday	12	December	4	2020	2020-12	50	1
20201213	2020-12-13	13	Sunday	12	December	4	2020	2020-12	50	1
20201214	2020-12-14	14	Monday	12	December	4	2020	2020-12	51	0
20201215	2020-12-15	15	Tuesday	12	December	4	2020	2020-12	51	0
20201216	2020-12-16	16	Wednesday	12	December	4	2020	2020-12	51	0
20201217	2020-12-17	17	Thursday	12	December	4	2020	2020-12	51	0
20201218	2020-12-18	18	Friday	12	December	4	2020	2020-12	51	0
20201219	2020-12-19	19	Saturday	12	December	4	2020	2020-12	51	1
20201220	2020-12-20	20	Sunday	12	December	4	2020	2020-12	51	1
20201221	2020-12-21	21	Monday	12	December	4	2020	2020-12	52	0
20201222	2020-12-22	22	Tuesday	12	December	4	2020	2020-12	52	0
20201223	2020-12-23	23	Wednesday	12	December	4	2020	2020-12	52	0
20201224	2020-12-24	24	Thursday	12	December	4	2020	2020-12	52	0
20201225	2020-12-25	25	Friday	12	December	4	2020	2020-12	52	0
20201226	2020-12-26	26	Saturday	12	December	4	2020	2020-12	52	1
20201227	2020-12-27	27	Sunday	12	December	4	2020	2020-12	52	1
20201228	2020-12-28	28	Monday	12	December	4	2020	2020-12	53	0
20201229	2020-12-29	29	Tuesday	12	December	4	2020	2020-12	53	0
20201230	2020-12-30	30	Wednesday	12	December	4	2020	2020-12	53	0
20201231	2020-12-31	31	Thursday	12	December	4	2020	2020-12	53	0
20210101	2021-01-01	1	Friday	1	January	1	2021	2021-01	53	0
20210102	2021-01-02	2	Saturday	1	January	1	2021	2021-01	53	1
20210103	2021-01-03	3	Sunday	1	January	1	2021	2021-01	53	1
20210104	2021-01-04	4	Monday	1	January	1	2021	2021-01	1	0
20210105	2021-01-05	5	Tuesday	1	January	1	2021	2021-01	1	0
20210106	2021-01-06	6	Wednesday	1	January	1	2021	2021-01	1	0
20210107	2021-01-07	7	Thursday	1	January	1	2021	2021-01	1	0
20210108	2021-01-08	8	Friday	1	January	1	2021	2021-01	1	0
20210109	2021-01-09	9	Saturday	1	January	1	2021	2021-01	1	1
20210110	2021-01-10	10	Sunday	1	January	1	2021	2021-01	1	1
20210111	2021-01-11	11	Monday	1	January	1	2021	2021-01	2	0
20210112	2021-01-12	12	Tuesday	1	January	1	2021	2021-01	2	0
20210113	2021-01-13	13	Wednesday	1	January	1	2021	2021-01	2	0
20210114	2021-01-14	14	Thursday	1	January	1	2021	2021-01	2	0
20210115	2021-01-15	15	Friday	1	January	1	2021	2021-01	2	0
20210116	2021-01-16	16	Saturday	1	January	1	2021	2021-01	2	1
20210117	2021-01-17	17	Sunday	1	January	1	2021	2021-01	2	1
20210118	2021-01-18	18	Monday	1	January	1	2021	2021-01	3	0
20210119	2021-01-19	19	Tuesday	1	January	1	2021	2021-01	3	0
20210120	2021-01-20	20	Wednesday	1	January	1	2021	2021-01	3	0
20210121	2021-01-21	21	Thursday	1	January	1	2021	2021-01	3	0
20210122	2021-01-22	22	Friday	1	January	1	2021	2021-01	3	0
20210123	2021-01-23	23	Saturday	1	January	1	2021	2021-01	3	1
20210124	2021-01-24	24	Sunday	1	January	1	2021	2021-01	3	1
20210125	2021-01-25	25	Monday	1	January	1	2021	2021-01	4	0
20210126	2021-01-26	26	Tuesday	1	January	1	2021	2021-01	4	0
20210127	2021-01-27	27	Wednesday	1	January	1	2021	2021-01	4	0
20210128	2021-01-28	28	Thursday	1	January	1	2021	2021-01	4	0
20210129	2021-01-29	29	Friday	1	January	1	2021	2021-01	4	0
20210130	2021-01-30	30	Saturday	1	January	1	2021	2021-01	4	1
20210131	2021-01-31	31	Sunday	1	January	1	2021	2021-01	4	1
20210201	2021-02-01	1	Monday	2	February	1	2021	2021-02	5	0
20210202	2021-02-02	2	Tuesday	2	February	1	2021	2021-02	5	0
20210203	2021-02-03	3	Wednesday	2	February	1	2021	2021-02	5	0
20210204	2021-02-04	4	Thursday	2	February	1	2021	2021-02	5	0
20210205	2021-02-05	5	Friday	2	February	1	2021	2021-02	5	0
20210206	2021-02-06	6	Saturday	2	February	1	2021	2021-02	5	1
20210207	2021-02-07	7	Sunday	2	February	1	2021	2021-02	5	1
20210208	2021-02-08	8	Monday	2	February	1	2021	2021-02	6	0
20210209	2021-02-09	9	Tuesday	2	February	1	2021	2021-02	6	0
20210210	2021-02-10	10	Wednesday	2	February	1	2021	2021-02	6	0
20210211	2021-02-11	11	Thursday	2	February	1	2021	2021-02	6	0
20210212	2021-02-12	12	Friday	2	February	1	2021	2021-02	6	0
20210213	2021-02-13	13	Saturday	2	February	1	2021	2021-02	6	1
20210214	2021-02-14	14	Sunday	2	February	1	2021	2021-02	6	1
20210215	2021-02-15	15	Monday	2	February	1	2021	2021-02	7	0
20210216	2021-02-16	16	Tuesday	2	February	1	2021	2021-02	7	0
20210217	2021-02-17	17	Wednesday	2	February	1	2021	2021-02	7	0
20210218	2021-02-18	18	Thursday	2	February	1	2021	2021-02	7	0
20210219	2021-02-19	19	Friday	2	February	1	2021	2021-02	7	0
20210220	2021-02-20	20	Saturday	2	February	1	2021	2021-02	7	1
20210221	2021-02-21	21	Sunday	2	February	1	2021	2021-02	7	1
20210222	2021-02-22	22	Monday	2	February	1	2021	2021-02	8	0
20210223	2021-02-23	23	Tuesday	2	February	1	2021	2021-02	8	0
20210224	2021-02-24	24	Wednesday	2	February	1	2021	2021-02	8	0
20210225	2021-02-25	25	Thursday	2	February	1	2021	2021-02	8	0
20210226	2021-02-26	26	Friday	2	February	1	2021	2021-02	8	0
20210227	2021-02-27	27	Saturday	2	February	1	2021	2021-02	8	1
20210228	2021-02-28	28	Sunday	2	February	1	2021	2021-02	8	1
20210301	2021-03-01	1	Monday	3	March	1	2021	2021-03	9	0
20210302	2021-03-02	2	Tuesday	3	March	1	2021	2021-03	9	0
20210303	2021-03-03	3	Wednesday	3	March	1	2021	2021-03	9	0
20210304	2021-03-04	4	Thursday	3	March	1	2021	2021-03	9	0
20210305	2021-03-05	5	Friday	3	March	1	2021	2021-03	9	0
20210306	2021-03-06	6	Saturday	3	March	1	2021	2021-03	9	1
20210307	2021-03-07	7	Sunday	3	March	1	2021	2021-03	9	1
20210308	2021-03-08	8	Monday	3	March	1	2021	2021-03	10	0
20210309	2021-03-09	9	Tuesday	3	March	1	2021	2021-03	10	0
20210310	2021-03-10	10	Wednesday	3	March	1	2021	2021-03	10	0
20210311	2021-03-11	11	Thursday	3	March	1	2021	2021-03	10	0
20210312	2021-03-12	12	Friday	3	March	1	2021	2021-03	10	0
20210313	2021-03-13	13	Saturday	3	March	1	2021	2021-03	10	1
20210314	2021-03-14	14	Sunday	3	March	1	2021	2021-03	10	1
20210315	2021-03-15	15	Monday	3	March	1	2021	2021-03	11	0
20210316	2021-03-16	16	Tuesday	3	March	1	2021	2021-03	11	0
20210317	2021-03-17	17	Wednesday	3	March	1	2021	2021-03	11	0
20210318	2021-03-18	18	Thursday	3	March	1	2021	2021-03	11	0
20210319	2021-03-19	19	Friday	3	March	1	2021	2021-03	11	0
20210320	2021-03-20	20	Saturday	3	March	1	2021	2021-03	11	1
20210321	2021-03-21	21	Sunday	3	March	1	2021	2021-03	11	1
20210322	2021-03-22	22	Monday	3	March	1	2021	2021-03	12	0
20210323	2021-03-23	23	Tuesday	3	March	1	2021	2021-03	12	0
20210324	2021-03-24	24	Wednesday	3	March	1	2021	2021-03	12	0
20210325	2021-03-25	25	Thursday	3	March	1	2021	2021-03	12	0
20210326	2021-03-26	26	Friday	3	March	1	2021	2021-03	12	0
20210327	2021-03-27	27	Saturday	3	March	1	2021	2021-03	12	1
20210328	2021-03-28	28	Sunday	3	March	1	2021	2021-03	12	1
20210329	2021-03-29	29	Monday	3	March	1	2021	2021-03	13	0
20210330	2021-03-30	30	Tuesday	3	March	1	2021	2021-03	13	0
20210331	2021-03-31	31	Wednesday	3	March	1	2021	2021-03	13	0
20210401	2021-04-01	1	Thursday	4	April	2	2021	2021-04	13	0
20210402	2021-04-02	2	Friday	4	April	2	2021	2021-04	13	0
20210403	2021-04-03	3	Saturday	4	April	2	2021	2021-04	13	1
20210404	2021-04-04	4	Sunday	4	April	2	2021	2021-04	13	1
20210405	2021-04-05	5	Monday	4	April	2	2021	2021-04	14	0
20210406	2021-04-06	6	Tuesday	4	April	2	2021	2021-04	14	0
20210407	2021-04-07	7	Wednesday	4	April	2	2021	2021-04	14	0
20210408	2021-04-08	8	Thursday	4	April	2	2021	2021-04	14	0
20210409	2021-04-09	9	Friday	4	April	2	2021	2021-04	14	0
20210410	2021-04-10	10	Saturday	4	April	2	2021	2021-04	14	1
20210411	2021-04-11	11	Sunday	4	April	2	2021	2021-04	14	1
20210412	2021-04-12	12	Monday	4	April	2	2021	2021-04	15	0
20210413	2021-04-13	13	Tuesday	4	April	2	2021	2021-04	15	0
20210414	2021-04-14	14	Wednesday	4	April	2	2021	2021-04	15	0
20210415	2021-04-15	15	Thursday	4	April	2	2021	2021-04	15	0
20210416	2021-04-16	16	Friday	4	April	2	2021	2021-04	15	0
20210417	2021-04-17	17	Saturday	4	April	2	2021	2021-04	15	1
20210418	2021-04-18	18	Sunday	4	April	2	2021	2021-04	15	1
20210419	2021-04-19	19	Monday	4	April	2	2021	2021-04	16	0
20210420	2021-04-20	20	Tuesday	4	April	2	2021	2021-04	16	0
20210421	2021-04-21	21	Wednesday	4	April	2	2021	2021-04	16	0
20210422	2021-04-22	22	Thursday	4	April	2	2021	2021-04	16	0
20210423	2021-04-23	23	Friday	4	April	2	2021	2021-04	16	0
20210424	2021-04-24	24	Saturday	4	April	2	2021	2021-04	16	1
20210425	2021-04-25	25	Sunday	4	April	2	2021	2021-04	16	1
20210426	2021-04-26	26	Monday	4	April	2	2021	2021-04	17	0
20210427	2021-04-27	27	Tuesday	4	April	2	2021	2021-04	17	0
20210428	2021-04-28	28	Wednesday	4	April	2	2021	2021-04	17	0
20210429	2021-04-29	29	Thursday	4	April	2	2021	2021-04	17	0
20210430	2021-04-30	30	Friday	4	April	2	2021	2021-04	17	0
20210501	2021-05-01	1	Saturday	5	May	2	2021	2021-05	17	1
20210502	2021-05-02	2	Sunday	5	May	2	2021	2021-05	17	1
20210503	2021-05-03	3	Monday	5	May	2	2021	2021-05	18	0
20210504	2021-05-04	4	Tuesday	5	May	2	2021	2021-05	18	0
20210505	2021-05-05	5	Wednesday	5	May	2	2021	2021-05	18	0
20210506	2021-05-06	6	Thursday	5	May	2	2021	2021-05	18	0
20210507	2021-05-07	7	Friday	5	May	2	2021	2021-05	18	0
20210508	2021-05-08	8	Saturday	5	May	2	2021	2021-05	18	1
20210509	2021-05-09	9	Sunday	5	May	2	2021	2021-05	18	1
20210510	2021-05-10	10	Monday	5	May	2	2021	2021-05	19	0
20210511	2021-05-11	11	Tuesday	5	May	2	2021	2021-05	19	0
20210512	2021-05-12	12	Wednesday	5	May	2	2021	2021-05	19	0
20210513	2021-05-13	13	Thursday	5	May	2	2021	2021-05	19	0
20210514	2021-05-14	14	Friday	5	May	2	2021	2021-05	19	0
20210515	2021-05-15	15	Saturday	5	May	2	2021	2021-05	19	1
20210516	2021-05-16	16	Sunday	5	May	2	2021	2021-05	19	1
20210517	2021-05-17	17	Monday	5	May	2	2021	2021-05	20	0
20210518	2021-05-18	18	Tuesday	5	May	2	2021	2021-05	20	0
20210519	2021-05-19	19	Wednesday	5	May	2	2021	2021-05	20	0
20210520	2021-05-20	20	Thursday	5	May	2	2021	2021-05	20	0
20210521	2021-05-21	21	Friday	5	May	2	2021	2021-05	20	0
20210522	2021-05-22	22	Saturday	5	May	2	2021	2021-05	20	1
20210523	2021-05-23	23	Sunday	5	May	2	2021	2021-05	20	1
20210524	2021-05-24	24	Monday	5	May	2	2021	2021-05	21	0
20210525	2021-05-25	25	Tuesday	5	May	2	2021	2021-05	21	0
20210526	2021-05-26	26	Wednesday	5	May	2	2021	2021-05	21	0
20210527	2021-05-27	27	Thursday	5	May	2	2021	2021-05	21	0
20210528	2021-05-28	28	Friday	5	May	2	2021	2021-05	21	0
20210529	2021-05-29	29	Saturday	5	May	2	2021	2021-05	21	1
20210530	2021-05-30	30	Sunday	5	May	2	2021	2021-05	21	1
20210531	2021-05-31	31	Monday	5	May	2	2021	2021-05	22	0
20210601	2021-06-01	1	Tuesday	6	June	2	2021	2021-06	22	0
20210602	2021-06-02	2	Wednesday	6	June	2	2021	2021-06	22	0
20210603	2021-06-03	3	Thursday	6	June	2	2021	2021-06	22	0
20210604	2021-06-04	4	Friday	6	June	2	2021	2021-06	22	0
20210605	2021-06-05	5	Saturday	6	June	2	2021	2021-06	22	1
20210606	2021-06-06	6	Sunday	6	June	2	2021	2021-06	22	1
20210607	2021-06-07	7	Monday	6	June	2	2021	2021-06	23	0
20210608	2021-06-08	8	Tuesday	6	June	2	2021	2021-06	23	0
20210609	2021-06-09	9	Wednesday	6	June	2	2021	2021-06	23	0
20210610	2021-06-10	10	Thursday	6	June	2	2021	2021-06	23	0
20210611	2021-06-11	11	Friday	6	June	2	2021	2021-06	23	0
20210612	2021-06-12	12	Saturday	6	June	2	2021	2021-06	23	1
20210613	2021-06-13	13	Sunday	6	June	2	2021	2021-06	23	1
20210614	2021-06-14	14	Monday	6	June	2	2021	2021-06	24	0
20210615	2021-06-15	15	Tuesday	6	June	2	2021	2021-06	24	0
20210616	2021-06-16	16	Wednesday	6	June	2	2021	2021-06	24	0
20210617	2021-06-17	17	Thursday	6	June	2	2021	2021-06	24	0
20210618	2021-06-18	18	Friday	6	June	2	2021	2021-06	24	0
20210619	2021-06-19	19	Saturday	6	June	2	2021	2021-06	24	1
20210620	2021-06-20	20	Sunday	6	June	2	2021	2021-06	24	1
20210621	2021-06-21	21	Monday	6	June	2	2021	2021-06	25	0
20210622	2021-06-22	22	Tuesday	6	June	2	2021	2021-06	25	0
20210623	2021-06-23	23	Wednesday	6	June	2	2021	2021-06	25	0
20210624	2021-06-24	24	Thursday	6	June	2	2021	2021-06	25	0
20210625	2021-06-25	25	Friday	6	June	2	2021	2021-06	25	0
20210626	2021-06-26	26	Saturday	6	June	2	2021	2021-06	25	1
20210627	2021-06-27	27	Sunday	6	June	2	2021	2021-06	25	1
20210628	2021-06-28	28	Monday	6	June	2	2021	2021-06	26	0
20210629	2021-06-29	29	Tuesday	6	June	2	2021	2021-06	26	0
20210630	2021-06-30	30	Wednesday	6	June	2	2021	2021-06	26	0
20210701	2021-07-01	1	Thursday	7	July	3	2021	2021-07	26	0
20210702	2021-07-02	2	Friday	7	July	3	2021	2021-07	26	0
20210703	2021-07-03	3	Saturday	7	July	3	2021	2021-07	26	1
20210704	2021-07-04	4	Sunday	7	July	3	2021	2021-07	26	1
20210705	2021-07-05	5	Monday	7	July	3	2021	2021-07	27	0
20210706	2021-07-06	6	Tuesday	7	July	3	2021	2021-07	27	0
20210707	2021-07-07	7	Wednesday	7	July	3	2021	2021-07	27	0
20210708	2021-07-08	8	Thursday	7	July	3	2021	2021-07	27	0
20210709	2021-07-09	9	Friday	7	July	3	2021	2021-07	27	0
20210710	2021-07-10	10	Saturday	7	July	3	2021	2021-07	27	1
20210711	2021-07-11	11	Sunday	7	July	3	2021	2021-07	27	1
20210712	2021-07-12	12	Monday	7	July	3	2021	2021-07	28	0
20210713	2021-07-13	13	Tuesday	7	July	3	2021	2021-07	28	0
20210714	2021-07-14	14	Wednesday	7	July	3	2021	2021-07	28	0
20210715	2021-07-15	15	Thursday	7	July	3	2021	2021-07	28	0
20210716	2021-07-16	16	Friday	7	July	3	2021	2021-07	28	0
20210717	2021-07-17	17	Saturday	7	July	3	2021	2021-07	28	1
20210718	2021-07-18	18	Sunday	7	July	3	2021	2021-07	28	1
20210719	2021-07-19	19	Monday	7	July	3	2021	2021-07	29	0
20210720	2021-07-20	20	Tuesday	7	July	3	2021	2021-07	29	0
20210721	2021-07-21	21	Wednesday	7	July	3	2021	2021-07	29	0
20210722	2021-07-22	22	Thursday	7	July	3	2021	2021-07	29	0
20210723	2021-07-23	23	Friday	7	July	3	2021	2021-07	29	0
20210724	2021-07-24	24	Saturday	7	July	3	2021	2021-07	29	1
20210725	2021-07-25	25	Sunday	7	July	3	2021	2021-07	29	1
20210726	2021-07-26	26	Monday	7	July	3	2021	2021-07	30	0
20210727	2021-07-27	27	Tuesday	7	July	3	2021	2021-07	30	0
20210728	2021-07-28	28	Wednesday	7	July	3	2021	2021-07	30	0
20210729	2021-07-29	29	Thursday	7	July	3	2021	2021-07	30	0
20210730	2021-07-30	30	Friday	7	July	3	2021	2021-07	30	0
20210731	2021-07-31	31	Saturday	7	July	3	2021	2021-07	30	1
20210801	2021-08-01	1	Sunday	8	August	3	2021	2021-08	30	1
20210802	2021-08-02	2	Monday	8	August	3	2021	2021-08	31	0
20210803	2021-08-03	3	Tuesday	8	August	3	2021	2021-08	31	0
20210804	2021-08-04	4	Wednesday	8	August	3	2021	2021-08	31	0
20210805	2021-08-05	5	Thursday	8	August	3	2021	2021-08	31	0
20210806	2021-08-06	6	Friday	8	August	3	2021	2021-08	31	0
20210807	2021-08-07	7	Saturday	8	August	3	2021	2021-08	31	1
20210808	2021-08-08	8	Sunday	8	August	3	2021	2021-08	31	1
20210809	2021-08-09	9	Monday	8	August	3	2021	2021-08	32	0
20210810	2021-08-10	10	Tuesday	8	August	3	2021	2021-08	32	0
20210811	2021-08-11	11	Wednesday	8	August	3	2021	2021-08	32	0
20210812	2021-08-12	12	Thursday	8	August	3	2021	2021-08	32	0
20210813	2021-08-13	13	Friday	8	August	3	2021	2021-08	32	0
20210814	2021-08-14	14	Saturday	8	August	3	2021	2021-08	32	1
20210815	2021-08-15	15	Sunday	8	August	3	2021	2021-08	32	1
20210816	2021-08-16	16	Monday	8	August	3	2021	2021-08	33	0
20210817	2021-08-17	17	Tuesday	8	August	3	2021	2021-08	33	0
20210818	2021-08-18	18	Wednesday	8	August	3	2021	2021-08	33	0
20210819	2021-08-19	19	Thursday	8	August	3	2021	2021-08	33	0
20210820	2021-08-20	20	Friday	8	August	3	2021	2021-08	33	0
20210821	2021-08-21	21	Saturday	8	August	3	2021	2021-08	33	1
20210822	2021-08-22	22	Sunday	8	August	3	2021	2021-08	33	1
20210823	2021-08-23	23	Monday	8	August	3	2021	2021-08	34	0
20210824	2021-08-24	24	Tuesday	8	August	3	2021	2021-08	34	0
20210825	2021-08-25	25	Wednesday	8	August	3	2021	2021-08	34	0
20210826	2021-08-26	26	Thursday	8	August	3	2021	2021-08	34	0
20210827	2021-08-27	27	Friday	8	August	3	2021	2021-08	34	0
20210828	2021-08-28	28	Saturday	8	August	3	2021	2021-08	34	1
20210829	2021-08-29	29	Sunday	8	August	3	2021	2021-08	34	1
20210830	2021-08-30	30	Monday	8	August	3	2021	2021-08	35	0
20210831	2021-08-31	31	Tuesday	8	August	3	2021	2021-08	35	0
20210901	2021-09-01	1	Wednesday	9	September	3	2021	2021-09	35	0
20210902	2021-09-02	2	Thursday	9	September	3	2021	2021-09	35	0
20210903	2021-09-03	3	Friday	9	September	3	2021	2021-09	35	0
20210904	2021-09-04	4	Saturday	9	September	3	2021	2021-09	35	1
20210905	2021-09-05	5	Sunday	9	September	3	2021	2021-09	35	1
20210906	2021-09-06	6	Monday	9	September	3	2021	2021-09	36	0
20210907	2021-09-07	7	Tuesday	9	September	3	2021	2021-09	36	0
20210908	2021-09-08	8	Wednesday	9	September	3	2021	2021-09	36	0
20210909	2021-09-09	9	Thursday	9	September	3	2021	2021-09	36	0
20210910	2021-09-10	10	Friday	9	September	3	2021	2021-09	36	0
20210911	2021-09-11	11	Saturday	9	September	3	2021	2021-09	36	1
20210912	2021-09-12	12	Sunday	9	September	3	2021	2021-09	36	1
20210913	2021-09-13	13	Monday	9	September	3	2021	2021-09	37	0
20210914	2021-09-14	14	Tuesday	9	September	3	2021	2021-09	37	0
20210915	2021-09-15	15	Wednesday	9	September	3	2021	2021-09	37	0
20210916	2021-09-16	16	Thursday	9	September	3	2021	2021-09	37	0
20210917	2021-09-17	17	Friday	9	September	3	2021	2021-09	37	0
20210918	2021-09-18	18	Saturday	9	September	3	2021	2021-09	37	1
20210919	2021-09-19	19	Sunday	9	September	3	2021	2021-09	37	1
20210920	2021-09-20	20	Monday	9	September	3	2021	2021-09	38	0
20210921	2021-09-21	21	Tuesday	9	September	3	2021	2021-09	38	0
20210922	2021-09-22	22	Wednesday	9	September	3	2021	2021-09	38	0
20210923	2021-09-23	23	Thursday	9	September	3	2021	2021-09	38	0
20210924	2021-09-24	24	Friday	9	September	3	2021	2021-09	38	0
20210925	2021-09-25	25	Saturday	9	September	3	2021	2021-09	38	1
20210926	2021-09-26	26	Sunday	9	September	3	2021	2021-09	38	1
20210927	2021-09-27	27	Monday	9	September	3	2021	2021-09	39	0
20210928	2021-09-28	28	Tuesday	9	September	3	2021	2021-09	39	0
20210929	2021-09-29	29	Wednesday	9	September	3	2021	2021-09	39	0
20210930	2021-09-30	30	Thursday	9	September	3	2021	2021-09	39	0
20211001	2021-10-01	1	Friday	10	October	4	2021	2021-10	39	0
20211002	2021-10-02	2	Saturday	10	October	4	2021	2021-10	39	1
20211003	2021-10-03	3	Sunday	10	October	4	2021	2021-10	39	1
20211004	2021-10-04	4	Monday	10	October	4	2021	2021-10	40	0
20211005	2021-10-05	5	Tuesday	10	October	4	2021	2021-10	40	0
20211006	2021-10-06	6	Wednesday	10	October	4	2021	2021-10	40	0
20211007	2021-10-07	7	Thursday	10	October	4	2021	2021-10	40	0
20211008	2021-10-08	8	Friday	10	October	4	2021	2021-10	40	0
20211009	2021-10-09	9	Saturday	10	October	4	2021	2021-10	40	1
20211010	2021-10-10	10	Sunday	10	October	4	2021	2021-10	40	1
20211011	2021-10-11	11	Monday	10	October	4	2021	2021-10	41	0
20211012	2021-10-12	12	Tuesday	10	October	4	2021	2021-10	41	0
20211013	2021-10-13	13	Wednesday	10	October	4	2021	2021-10	41	0
20211014	2021-10-14	14	Thursday	10	October	4	2021	2021-10	41	0
20211015	2021-10-15	15	Friday	10	October	4	2021	2021-10	41	0
20211016	2021-10-16	16	Saturday	10	October	4	2021	2021-10	41	1
20211017	2021-10-17	17	Sunday	10	October	4	2021	2021-10	41	1
20211018	2021-10-18	18	Monday	10	October	4	2021	2021-10	42	0
20211019	2021-10-19	19	Tuesday	10	October	4	2021	2021-10	42	0
20211020	2021-10-20	20	Wednesday	10	October	4	2021	2021-10	42	0
20211021	2021-10-21	21	Thursday	10	October	4	2021	2021-10	42	0
20211022	2021-10-22	22	Friday	10	October	4	2021	2021-10	42	0
20211023	2021-10-23	23	Saturday	10	October	4	2021	2021-10	42	1
20211024	2021-10-24	24	Sunday	10	October	4	2021	2021-10	42	1
20211025	2021-10-25	25	Monday	10	October	4	2021	2021-10	43	0
20211026	2021-10-26	26	Tuesday	10	October	4	2021	2021-10	43	0
20211027	2021-10-27	27	Wednesday	10	October	4	2021	2021-10	43	0
20211028	2021-10-28	28	Thursday	10	October	4	2021	2021-10	43	0
20211029	2021-10-29	29	Friday	10	October	4	2021	2021-10	43	0
20211030	2021-10-30	30	Saturday	10	October	4	2021	2021-10	43	1
20211031	2021-10-31	31	Sunday	10	October	4	2021	2021-10	43	1
20211101	2021-11-01	1	Monday	11	November	4	2021	2021-11	44	0
20211102	2021-11-02	2	Tuesday	11	November	4	2021	2021-11	44	0
20211103	2021-11-03	3	Wednesday	11	November	4	2021	2021-11	44	0
20211104	2021-11-04	4	Thursday	11	November	4	2021	2021-11	44	0
20211105	2021-11-05	5	Friday	11	November	4	2021	2021-11	44	0
20211106	2021-11-06	6	Saturday	11	November	4	2021	2021-11	44	1
20211107	2021-11-07	7	Sunday	11	November	4	2021	2021-11	44	1
20211108	2021-11-08	8	Monday	11	November	4	2021	2021-11	45	0
20211109	2021-11-09	9	Tuesday	11	November	4	2021	2021-11	45	0
20211110	2021-11-10	10	Wednesday	11	November	4	2021	2021-11	45	0
20211111	2021-11-11	11	Thursday	11	November	4	2021	2021-11	45	0
20211112	2021-11-12	12	Friday	11	November	4	2021	2021-11	45	0
20211113	2021-11-13	13	Saturday	11	November	4	2021	2021-11	45	1
20211114	2021-11-14	14	Sunday	11	November	4	2021	2021-11	45	1
20211115	2021-11-15	15	Monday	11	November	4	2021	2021-11	46	0
20211116	2021-11-16	16	Tuesday	11	November	4	2021	2021-11	46	0
20211117	2021-11-17	17	Wednesday	11	November	4	2021	2021-11	46	0
20211118	2021-11-18	18	Thursday	11	November	4	2021	2021-11	46	0
20211119	2021-11-19	19	Friday	11	November	4	2021	2021-11	46	0
20211120	2021-11-20	20	Saturday	11	November	4	2021	2021-11	46	1
20211121	2021-11-21	21	Sunday	11	November	4	2021	2021-11	46	1
20211122	2021-11-22	22	Monday	11	November	4	2021	2021-11	47	0
20211123	2021-11-23	23	Tuesday	11	November	4	2021	2021-11	47	0
20211124	2021-11-24	24	Wednesday	11	November	4	2021	2021-11	47	0
20211125	2021-11-25	25	Thursday	11	November	4	2021	2021-11	47	0
20211126	2021-11-26	26	Friday	11	November	4	2021	2021-11	47	0
20211127	2021-11-27	27	Saturday	11	November	4	2021	2021-11	47	1
20211128	2021-11-28	28	Sunday	11	November	4	2021	2021-11	47	1
20211129	2021-11-29	29	Monday	11	November	4	2021	2021-11	48	0
20211130	2021-11-30	30	Tuesday	11	November	4	2021	2021-11	48	0
20211201	2021-12-01	1	Wednesday	12	December	4	2021	2021-12	48	0
20211202	2021-12-02	2	Thursday	12	December	4	2021	2021-12	48	0
20211203	2021-12-03	3	Friday	12	December	4	2021	2021-12	48	0
20211204	2021-12-04	4	Saturday	12	December	4	2021	2021-12	48	1
20211205	2021-12-05	5	Sunday	12	December	4	2021	2021-12	48	1
20211206	2021-12-06	6	Monday	12	December	4	2021	2021-12	49	0
20211207	2021-12-07	7	Tuesday	12	December	4	2021	2021-12	49	0
20211208	2021-12-08	8	Wednesday	12	December	4	2021	2021-12	49	0
20211209	2021-12-09	9	Thursday	12	December	4	2021	2021-12	49	0
20211210	2021-12-10	10	Friday	12	December	4	2021	2021-12	49	0
20211211	2021-12-11	11	Saturday	12	December	4	2021	2021-12	49	1
20211212	2021-12-12	12	Sunday	12	December	4	2021	2021-12	49	1
20211213	2021-12-13	13	Monday	12	December	4	2021	2021-12	50	0
20211214	2021-12-14	14	Tuesday	12	December	4	2021	2021-12	50	0
20211215	2021-12-15	15	Wednesday	12	December	4	2021	2021-12	50	0
20211216	2021-12-16	16	Thursday	12	December	4	2021	2021-12	50	0
20211217	2021-12-17	17	Friday	12	December	4	2021	2021-12	50	0
20211218	2021-12-18	18	Saturday	12	December	4	2021	2021-12	50	1
20211219	2021-12-19	19	Sunday	12	December	4	2021	2021-12	50	1
20211220	2021-12-20	20	Monday	12	December	4	2021	2021-12	51	0
20211221	2021-12-21	21	Tuesday	12	December	4	2021	2021-12	51	0
20211222	2021-12-22	22	Wednesday	12	December	4	2021	2021-12	51	0
20211223	2021-12-23	23	Thursday	12	December	4	2021	2021-12	51	0
20211224	2021-12-24	24	Friday	12	December	4	2021	2021-12	51	0
20211225	2021-12-25	25	Saturday	12	December	4	2021	2021-12	51	1
20211226	2021-12-26	26	Sunday	12	December	4	2021	2021-12	51	1
20211227	2021-12-27	27	Monday	12	December	4	2021	2021-12	52	0
20211228	2021-12-28	28	Tuesday	12	December	4	2021	2021-12	52	0
20211229	2021-12-29	29	Wednesday	12	December	4	2021	2021-12	52	0
20211230	2021-12-30	30	Thursday	12	December	4	2021	2021-12	52	0
20211231	2021-12-31	31	Friday	12	December	4	2021	2021-12	52	0
20220101	2022-01-01	1	Saturday	1	January	1	2022	2022-01	52	1
20220102	2022-01-02	2	Sunday	1	January	1	2022	2022-01	52	1
20220103	2022-01-03	3	Monday	1	January	1	2022	2022-01	1	0
20220104	2022-01-04	4	Tuesday	1	January	1	2022	2022-01	1	0
20220105	2022-01-05	5	Wednesday	1	January	1	2022	2022-01	1	0
20220106	2022-01-06	6	Thursday	1	January	1	2022	2022-01	1	0
20220107	2022-01-07	7	Friday	1	January	1	2022	2022-01	1	0
20220108	2022-01-08	8	Saturday	1	January	1	2022	2022-01	1	1
20220109	2022-01-09	9	Sunday	1	January	1	2022	2022-01	1	1
20220110	2022-01-10	10	Monday	1	January	1	2022	2022-01	2	0
20220111	2022-01-11	11	Tuesday	1	January	1	2022	2022-01	2	0
20220112	2022-01-12	12	Wednesday	1	January	1	2022	2022-01	2	0
20220113	2022-01-13	13	Thursday	1	January	1	2022	2022-01	2	0
20220114	2022-01-14	14	Friday	1	January	1	2022	2022-01	2	0
20220115	2022-01-15	15	Saturday	1	January	1	2022	2022-01	2	1
20220116	2022-01-16	16	Sunday	1	January	1	2022	2022-01	2	1
20220117	2022-01-17	17	Monday	1	January	1	2022	2022-01	3	0
20220118	2022-01-18	18	Tuesday	1	January	1	2022	2022-01	3	0
20220119	2022-01-19	19	Wednesday	1	January	1	2022	2022-01	3	0
20220120	2022-01-20	20	Thursday	1	January	1	2022	2022-01	3	0
20220121	2022-01-21	21	Friday	1	January	1	2022	2022-01	3	0
20220122	2022-01-22	22	Saturday	1	January	1	2022	2022-01	3	1
20220123	2022-01-23	23	Sunday	1	January	1	2022	2022-01	3	1
20220124	2022-01-24	24	Monday	1	January	1	2022	2022-01	4	0
20220125	2022-01-25	25	Tuesday	1	January	1	2022	2022-01	4	0
20220126	2022-01-26	26	Wednesday	1	January	1	2022	2022-01	4	0
20220127	2022-01-27	27	Thursday	1	January	1	2022	2022-01	4	0
20220128	2022-01-28	28	Friday	1	January	1	2022	2022-01	4	0
20220129	2022-01-29	29	Saturday	1	January	1	2022	2022-01	4	1
20220130	2022-01-30	30	Sunday	1	January	1	2022	2022-01	4	1
20220131	2022-01-31	31	Monday	1	January	1	2022	2022-01	5	0
20220201	2022-02-01	1	Tuesday	2	February	1	2022	2022-02	5	0
20220202	2022-02-02	2	Wednesday	2	February	1	2022	2022-02	5	0
20220203	2022-02-03	3	Thursday	2	February	1	2022	2022-02	5	0
20220204	2022-02-04	4	Friday	2	February	1	2022	2022-02	5	0
20220205	2022-02-05	5	Saturday	2	February	1	2022	2022-02	5	1
20220206	2022-02-06	6	Sunday	2	February	1	2022	2022-02	5	1
20220207	2022-02-07	7	Monday	2	February	1	2022	2022-02	6	0
20220208	2022-02-08	8	Tuesday	2	February	1	2022	2022-02	6	0
20220209	2022-02-09	9	Wednesday	2	February	1	2022	2022-02	6	0
20220210	2022-02-10	10	Thursday	2	February	1	2022	2022-02	6	0
20220211	2022-02-11	11	Friday	2	February	1	2022	2022-02	6	0
20220212	2022-02-12	12	Saturday	2	February	1	2022	2022-02	6	1
20220213	2022-02-13	13	Sunday	2	February	1	2022	2022-02	6	1
20220214	2022-02-14	14	Monday	2	February	1	2022	2022-02	7	0
20220215	2022-02-15	15	Tuesday	2	February	1	2022	2022-02	7	0
20220216	2022-02-16	16	Wednesday	2	February	1	2022	2022-02	7	0
20220217	2022-02-17	17	Thursday	2	February	1	2022	2022-02	7	0
20220218	2022-02-18	18	Friday	2	February	1	2022	2022-02	7	0
20220219	2022-02-19	19	Saturday	2	February	1	2022	2022-02	7	1
20220220	2022-02-20	20	Sunday	2	February	1	2022	2022-02	7	1
20220221	2022-02-21	21	Monday	2	February	1	2022	2022-02	8	0
20220222	2022-02-22	22	Tuesday	2	February	1	2022	2022-02	8	0
20220223	2022-02-23	23	Wednesday	2	February	1	2022	2022-02	8	0
20220224	2022-02-24	24	Thursday	2	February	1	2022	2022-02	8	0
20220225	2022-02-25	25	Friday	2	February	1	2022	2022-02	8	0
20220226	2022-02-26	26	Saturday	2	February	1	2022	2022-02	8	1
20220227	2022-02-27	27	Sunday	2	February	1	2022	2022-02	8	1
20220228	2022-02-28	28	Monday	2	February	1	2022	2022-02	9	0
20220301	2022-03-01	1	Tuesday	3	March	1	2022	2022-03	9	0
20220302	2022-03-02	2	Wednesday	3	March	1	2022	2022-03	9	0
20220303	2022-03-03	3	Thursday	3	March	1	2022	2022-03	9	0
20220304	2022-03-04	4	Friday	3	March	1	2022	2022-03	9	0
20220305	2022-03-05	5	Saturday	3	March	1	2022	2022-03	9	1
20220306	2022-03-06	6	Sunday	3	March	1	2022	2022-03	9	1
20220307	2022-03-07	7	Monday	3	March	1	2022	2022-03	10	0
20220308	2022-03-08	8	Tuesday	3	March	1	2022	2022-03	10	0
20220309	2022-03-09	9	Wednesday	3	March	1	2022	2022-03	10	0
20220310	2022-03-10	10	Thursday	3	March	1	2022	2022-03	10	0
20220311	2022-03-11	11	Friday	3	March	1	2022	2022-03	10	0
20220312	2022-03-12	12	Saturday	3	March	1	2022	2022-03	10	1
20220313	2022-03-13	13	Sunday	3	March	1	2022	2022-03	10	1
20220314	2022-03-14	14	Monday	3	March	1	2022	2022-03	11	0
20220315	2022-03-15	15	Tuesday	3	March	1	2022	2022-03	11	0
20220316	2022-03-16	16	Wednesday	3	March	1	2022	2022-03	11	0
20220317	2022-03-17	17	Thursday	3	March	1	2022	2022-03	11	0
20220318	2022-03-18	18	Friday	3	March	1	2022	2022-03	11	0
20220319	2022-03-19	19	Saturday	3	March	1	2022	2022-03	11	1
20220320	2022-03-20	20	Sunday	3	March	1	2022	2022-03	11	1
20220321	2022-03-21	21	Monday	3	March	1	2022	2022-03	12	0
20220322	2022-03-22	22	Tuesday	3	March	1	2022	2022-03	12	0
20220323	2022-03-23	23	Wednesday	3	March	1	2022	2022-03	12	0
20220324	2022-03-24	24	Thursday	3	March	1	2022	2022-03	12	0
20220325	2022-03-25	25	Friday	3	March	1	2022	2022-03	12	0
20220326	2022-03-26	26	Saturday	3	March	1	2022	2022-03	12	1
20220327	2022-03-27	27	Sunday	3	March	1	2022	2022-03	12	1
20220328	2022-03-28	28	Monday	3	March	1	2022	2022-03	13	0
20220329	2022-03-29	29	Tuesday	3	March	1	2022	2022-03	13	0
20220330	2022-03-30	30	Wednesday	3	March	1	2022	2022-03	13	0
20220331	2022-03-31	31	Thursday	3	March	1	2022	2022-03	13	0
20220401	2022-04-01	1	Friday	4	April	2	2022	2022-04	13	0
20220402	2022-04-02	2	Saturday	4	April	2	2022	2022-04	13	1
20220403	2022-04-03	3	Sunday	4	April	2	2022	2022-04	13	1
20220404	2022-04-04	4	Monday	4	April	2	2022	2022-04	14	0
20220405	2022-04-05	5	Tuesday	4	April	2	2022	2022-04	14	0
20220406	2022-04-06	6	Wednesday	4	April	2	2022	2022-04	14	0
20220407	2022-04-07	7	Thursday	4	April	2	2022	2022-04	14	0
20220408	2022-04-08	8	Friday	4	April	2	2022	2022-04	14	0
20220409	2022-04-09	9	Saturday	4	April	2	2022	2022-04	14	1
20220410	2022-04-10	10	Sunday	4	April	2	2022	2022-04	14	1
20220411	2022-04-11	11	Monday	4	April	2	2022	2022-04	15	0
20220412	2022-04-12	12	Tuesday	4	April	2	2022	2022-04	15	0
20220413	2022-04-13	13	Wednesday	4	April	2	2022	2022-04	15	0
20220414	2022-04-14	14	Thursday	4	April	2	2022	2022-04	15	0
20220415	2022-04-15	15	Friday	4	April	2	2022	2022-04	15	0
20220416	2022-04-16	16	Saturday	4	April	2	2022	2022-04	15	1
20220417	2022-04-17	17	Sunday	4	April	2	2022	2022-04	15	1
20220418	2022-04-18	18	Monday	4	April	2	2022	2022-04	16	0
20220419	2022-04-19	19	Tuesday	4	April	2	2022	2022-04	16	0
20220420	2022-04-20	20	Wednesday	4	April	2	2022	2022-04	16	0
20220421	2022-04-21	21	Thursday	4	April	2	2022	2022-04	16	0
20220422	2022-04-22	22	Friday	4	April	2	2022	2022-04	16	0
20220423	2022-04-23	23	Saturday	4	April	2	2022	2022-04	16	1
20220424	2022-04-24	24	Sunday	4	April	2	2022	2022-04	16	1
20220425	2022-04-25	25	Monday	4	April	2	2022	2022-04	17	0
20220426	2022-04-26	26	Tuesday	4	April	2	2022	2022-04	17	0
20220427	2022-04-27	27	Wednesday	4	April	2	2022	2022-04	17	0
20220428	2022-04-28	28	Thursday	4	April	2	2022	2022-04	17	0
20220429	2022-04-29	29	Friday	4	April	2	2022	2022-04	17	0
20220430	2022-04-30	30	Saturday	4	April	2	2022	2022-04	17	1
20220501	2022-05-01	1	Sunday	5	May	2	2022	2022-05	17	1
20220502	2022-05-02	2	Monday	5	May	2	2022	2022-05	18	0
20220503	2022-05-03	3	Tuesday	5	May	2	2022	2022-05	18	0
20220504	2022-05-04	4	Wednesday	5	May	2	2022	2022-05	18	0
20220505	2022-05-05	5	Thursday	5	May	2	2022	2022-05	18	0
20220506	2022-05-06	6	Friday	5	May	2	2022	2022-05	18	0
20220507	2022-05-07	7	Saturday	5	May	2	2022	2022-05	18	1
20220508	2022-05-08	8	Sunday	5	May	2	2022	2022-05	18	1
20220509	2022-05-09	9	Monday	5	May	2	2022	2022-05	19	0
20220510	2022-05-10	10	Tuesday	5	May	2	2022	2022-05	19	0
20220511	2022-05-11	11	Wednesday	5	May	2	2022	2022-05	19	0
20220512	2022-05-12	12	Thursday	5	May	2	2022	2022-05	19	0
20220513	2022-05-13	13	Friday	5	May	2	2022	2022-05	19	0
20220514	2022-05-14	14	Saturday	5	May	2	2022	2022-05	19	1
20220515	2022-05-15	15	Sunday	5	May	2	2022	2022-05	19	1
20220516	2022-05-16	16	Monday	5	May	2	2022	2022-05	20	0
20220517	2022-05-17	17	Tuesday	5	May	2	2022	2022-05	20	0
20220518	2022-05-18	18	Wednesday	5	May	2	2022	2022-05	20	0
20220519	2022-05-19	19	Thursday	5	May	2	2022	2022-05	20	0
20220520	2022-05-20	20	Friday	5	May	2	2022	2022-05	20	0
20220521	2022-05-21	21	Saturday	5	May	2	2022	2022-05	20	1
20220522	2022-05-22	22	Sunday	5	May	2	2022	2022-05	20	1
20220523	2022-05-23	23	Monday	5	May	2	2022	2022-05	21	0
20220524	2022-05-24	24	Tuesday	5	May	2	2022	2022-05	21	0
20220525	2022-05-25	25	Wednesday	5	May	2	2022	2022-05	21	0
20220526	2022-05-26	26	Thursday	5	May	2	2022	2022-05	21	0
20220527	2022-05-27	27	Friday	5	May	2	2022	2022-05	21	0
20220528	2022-05-28	28	Saturday	5	May	2	2022	2022-05	21	1
20220529	2022-05-29	29	Sunday	5	May	2	2022	2022-05	21	1
20220530	2022-05-30	30	Monday	5	May	2	2022	2022-05	22	0
20220531	2022-05-31	31	Tuesday	5	May	2	2022	2022-05	22	0
20220601	2022-06-01	1	Wednesday	6	June	2	2022	2022-06	22	0
20220602	2022-06-02	2	Thursday	6	June	2	2022	2022-06	22	0
20220603	2022-06-03	3	Friday	6	June	2	2022	2022-06	22	0
20220604	2022-06-04	4	Saturday	6	June	2	2022	2022-06	22	1
20220605	2022-06-05	5	Sunday	6	June	2	2022	2022-06	22	1
20220606	2022-06-06	6	Monday	6	June	2	2022	2022-06	23	0
20220607	2022-06-07	7	Tuesday	6	June	2	2022	2022-06	23	0
20220608	2022-06-08	8	Wednesday	6	June	2	2022	2022-06	23	0
20220609	2022-06-09	9	Thursday	6	June	2	2022	2022-06	23	0
20220610	2022-06-10	10	Friday	6	June	2	2022	2022-06	23	0
20220611	2022-06-11	11	Saturday	6	June	2	2022	2022-06	23	1
20220612	2022-06-12	12	Sunday	6	June	2	2022	2022-06	23	1
20220613	2022-06-13	13	Monday	6	June	2	2022	2022-06	24	0
20220614	2022-06-14	14	Tuesday	6	June	2	2022	2022-06	24	0
20220615	2022-06-15	15	Wednesday	6	June	2	2022	2022-06	24	0
20220616	2022-06-16	16	Thursday	6	June	2	2022	2022-06	24	0
20220617	2022-06-17	17	Friday	6	June	2	2022	2022-06	24	0
20220618	2022-06-18	18	Saturday	6	June	2	2022	2022-06	24	1
20220619	2022-06-19	19	Sunday	6	June	2	2022	2022-06	24	1
20220620	2022-06-20	20	Monday	6	June	2	2022	2022-06	25	0
20220621	2022-06-21	21	Tuesday	6	June	2	2022	2022-06	25	0
20220622	2022-06-22	22	Wednesday	6	June	2	2022	2022-06	25	0
20220623	2022-06-23	23	Thursday	6	June	2	2022	2022-06	25	0
20220624	2022-06-24	24	Friday	6	June	2	2022	2022-06	25	0
20220625	2022-06-25	25	Saturday	6	June	2	2022	2022-06	25	1
20220626	2022-06-26	26	Sunday	6	June	2	2022	2022-06	25	1
20220627	2022-06-27	27	Monday	6	June	2	2022	2022-06	26	0
20220628	2022-06-28	28	Tuesday	6	June	2	2022	2022-06	26	0
20220629	2022-06-29	29	Wednesday	6	June	2	2022	2022-06	26	0
20220630	2022-06-30	30	Thursday	6	June	2	2022	2022-06	26	0
20220701	2022-07-01	1	Friday	7	July	3	2022	2022-07	26	0
20220702	2022-07-02	2	Saturday	7	July	3	2022	2022-07	26	1
20220703	2022-07-03	3	Sunday	7	July	3	2022	2022-07	26	1
20220704	2022-07-04	4	Monday	7	July	3	2022	2022-07	27	0
20220705	2022-07-05	5	Tuesday	7	July	3	2022	2022-07	27	0
20220706	2022-07-06	6	Wednesday	7	July	3	2022	2022-07	27	0
20220707	2022-07-07	7	Thursday	7	July	3	2022	2022-07	27	0
20220708	2022-07-08	8	Friday	7	July	3	2022	2022-07	27	0
20220709	2022-07-09	9	Saturday	7	July	3	2022	2022-07	27	1
20220710	2022-07-10	10	Sunday	7	July	3	2022	2022-07	27	1
20220711	2022-07-11	11	Monday	7	July	3	2022	2022-07	28	0
20220712	2022-07-12	12	Tuesday	7	July	3	2022	2022-07	28	0
20220713	2022-07-13	13	Wednesday	7	July	3	2022	2022-07	28	0
20220714	2022-07-14	14	Thursday	7	July	3	2022	2022-07	28	0
20220715	2022-07-15	15	Friday	7	July	3	2022	2022-07	28	0
20220716	2022-07-16	16	Saturday	7	July	3	2022	2022-07	28	1
20220717	2022-07-17	17	Sunday	7	July	3	2022	2022-07	28	1
20220718	2022-07-18	18	Monday	7	July	3	2022	2022-07	29	0
20220719	2022-07-19	19	Tuesday	7	July	3	2022	2022-07	29	0
20220720	2022-07-20	20	Wednesday	7	July	3	2022	2022-07	29	0
20220721	2022-07-21	21	Thursday	7	July	3	2022	2022-07	29	0
20220722	2022-07-22	22	Friday	7	July	3	2022	2022-07	29	0
20220723	2022-07-23	23	Saturday	7	July	3	2022	2022-07	29	1
20220724	2022-07-24	24	Sunday	7	July	3	2022	2022-07	29	1
20220725	2022-07-25	25	Monday	7	July	3	2022	2022-07	30	0
20220726	2022-07-26	26	Tuesday	7	July	3	2022	2022-07	30	0
20220727	2022-07-27	27	Wednesday	7	July	3	2022	2022-07	30	0
20220728	2022-07-28	28	Thursday	7	July	3	2022	2022-07	30	0
20220729	2022-07-29	29	Friday	7	July	3	2022	2022-07	30	0
20220730	2022-07-30	30	Saturday	7	July	3	2022	2022-07	30	1
20220731	2022-07-31	31	Sunday	7	July	3	2022	2022-07	30	1
20220801	2022-08-01	1	Monday	8	August	3	2022	2022-08	31	0
20220802	2022-08-02	2	Tuesday	8	August	3	2022	2022-08	31	0
20220803	2022-08-03	3	Wednesday	8	August	3	2022	2022-08	31	0
20220804	2022-08-04	4	Thursday	8	August	3	2022	2022-08	31	0
20220805	2022-08-05	5	Friday	8	August	3	2022	2022-08	31	0
20220806	2022-08-06	6	Saturday	8	August	3	2022	2022-08	31	1
20220807	2022-08-07	7	Sunday	8	August	3	2022	2022-08	31	1
20220808	2022-08-08	8	Monday	8	August	3	2022	2022-08	32	0
20220809	2022-08-09	9	Tuesday	8	August	3	2022	2022-08	32	0
20220810	2022-08-10	10	Wednesday	8	August	3	2022	2022-08	32	0
20220811	2022-08-11	11	Thursday	8	August	3	2022	2022-08	32	0
20220812	2022-08-12	12	Friday	8	August	3	2022	2022-08	32	0
20220813	2022-08-13	13	Saturday	8	August	3	2022	2022-08	32	1
20220814	2022-08-14	14	Sunday	8	August	3	2022	2022-08	32	1
20220815	2022-08-15	15	Monday	8	August	3	2022	2022-08	33	0
20220816	2022-08-16	16	Tuesday	8	August	3	2022	2022-08	33	0
20220817	2022-08-17	17	Wednesday	8	August	3	2022	2022-08	33	0
20220818	2022-08-18	18	Thursday	8	August	3	2022	2022-08	33	0
20220819	2022-08-19	19	Friday	8	August	3	2022	2022-08	33	0
20220820	2022-08-20	20	Saturday	8	August	3	2022	2022-08	33	1
20220821	2022-08-21	21	Sunday	8	August	3	2022	2022-08	33	1
20220822	2022-08-22	22	Monday	8	August	3	2022	2022-08	34	0
20220823	2022-08-23	23	Tuesday	8	August	3	2022	2022-08	34	0
20220824	2022-08-24	24	Wednesday	8	August	3	2022	2022-08	34	0
20220825	2022-08-25	25	Thursday	8	August	3	2022	2022-08	34	0
20220826	2022-08-26	26	Friday	8	August	3	2022	2022-08	34	0
20220827	2022-08-27	27	Saturday	8	August	3	2022	2022-08	34	1
20220828	2022-08-28	28	Sunday	8	August	3	2022	2022-08	34	1
20220829	2022-08-29	29	Monday	8	August	3	2022	2022-08	35	0
20220830	2022-08-30	30	Tuesday	8	August	3	2022	2022-08	35	0
20220831	2022-08-31	31	Wednesday	8	August	3	2022	2022-08	35	0
20220901	2022-09-01	1	Thursday	9	September	3	2022	2022-09	35	0
20220902	2022-09-02	2	Friday	9	September	3	2022	2022-09	35	0
20220903	2022-09-03	3	Saturday	9	September	3	2022	2022-09	35	1
20220904	2022-09-04	4	Sunday	9	September	3	2022	2022-09	35	1
20220905	2022-09-05	5	Monday	9	September	3	2022	2022-09	36	0
20220906	2022-09-06	6	Tuesday	9	September	3	2022	2022-09	36	0
20220907	2022-09-07	7	Wednesday	9	September	3	2022	2022-09	36	0
20220908	2022-09-08	8	Thursday	9	September	3	2022	2022-09	36	0
20220909	2022-09-09	9	Friday	9	September	3	2022	2022-09	36	0
20220910	2022-09-10	10	Saturday	9	September	3	2022	2022-09	36	1
20220911	2022-09-11	11	Sunday	9	September	3	2022	2022-09	36	1
20220912	2022-09-12	12	Monday	9	September	3	2022	2022-09	37	0
20220913	2022-09-13	13	Tuesday	9	September	3	2022	2022-09	37	0
20220914	2022-09-14	14	Wednesday	9	September	3	2022	2022-09	37	0
20220915	2022-09-15	15	Thursday	9	September	3	2022	2022-09	37	0
20220916	2022-09-16	16	Friday	9	September	3	2022	2022-09	37	0
20220917	2022-09-17	17	Saturday	9	September	3	2022	2022-09	37	1
20220918	2022-09-18	18	Sunday	9	September	3	2022	2022-09	37	1
20220919	2022-09-19	19	Monday	9	September	3	2022	2022-09	38	0
20220920	2022-09-20	20	Tuesday	9	September	3	2022	2022-09	38	0
20220921	2022-09-21	21	Wednesday	9	September	3	2022	2022-09	38	0
20220922	2022-09-22	22	Thursday	9	September	3	2022	2022-09	38	0
20220923	2022-09-23	23	Friday	9	September	3	2022	2022-09	38	0
20220924	2022-09-24	24	Saturday	9	September	3	2022	2022-09	38	1
20220925	2022-09-25	25	Sunday	9	September	3	2022	2022-09	38	1
20220926	2022-09-26	26	Monday	9	September	3	2022	2022-09	39	0
20220927	2022-09-27	27	Tuesday	9	September	3	2022	2022-09	39	0
20220928	2022-09-28	28	Wednesday	9	September	3	2022	2022-09	39	0
20220929	2022-09-29	29	Thursday	9	September	3	2022	2022-09	39	0
20220930	2022-09-30	30	Friday	9	September	3	2022	2022-09	39	0
20221001	2022-10-01	1	Saturday	10	October	4	2022	2022-10	39	1
20221002	2022-10-02	2	Sunday	10	October	4	2022	2022-10	39	1
20221003	2022-10-03	3	Monday	10	October	4	2022	2022-10	40	0
20221004	2022-10-04	4	Tuesday	10	October	4	2022	2022-10	40	0
20221005	2022-10-05	5	Wednesday	10	October	4	2022	2022-10	40	0
20221006	2022-10-06	6	Thursday	10	October	4	2022	2022-10	40	0
20221007	2022-10-07	7	Friday	10	October	4	2022	2022-10	40	0
20221008	2022-10-08	8	Saturday	10	October	4	2022	2022-10	40	1
20221009	2022-10-09	9	Sunday	10	October	4	2022	2022-10	40	1
20221010	2022-10-10	10	Monday	10	October	4	2022	2022-10	41	0
20221011	2022-10-11	11	Tuesday	10	October	4	2022	2022-10	41	0
20221012	2022-10-12	12	Wednesday	10	October	4	2022	2022-10	41	0
20221013	2022-10-13	13	Thursday	10	October	4	2022	2022-10	41	0
20221014	2022-10-14	14	Friday	10	October	4	2022	2022-10	41	0
20221015	2022-10-15	15	Saturday	10	October	4	2022	2022-10	41	1
20221016	2022-10-16	16	Sunday	10	October	4	2022	2022-10	41	1
20221017	2022-10-17	17	Monday	10	October	4	2022	2022-10	42	0
20221018	2022-10-18	18	Tuesday	10	October	4	2022	2022-10	42	0
20221019	2022-10-19	19	Wednesday	10	October	4	2022	2022-10	42	0
20221020	2022-10-20	20	Thursday	10	October	4	2022	2022-10	42	0
20221021	2022-10-21	21	Friday	10	October	4	2022	2022-10	42	0
20221022	2022-10-22	22	Saturday	10	October	4	2022	2022-10	42	1
20221023	2022-10-23	23	Sunday	10	October	4	2022	2022-10	42	1
20221024	2022-10-24	24	Monday	10	October	4	2022	2022-10	43	0
20221025	2022-10-25	25	Tuesday	10	October	4	2022	2022-10	43	0
20221026	2022-10-26	26	Wednesday	10	October	4	2022	2022-10	43	0
20221027	2022-10-27	27	Thursday	10	October	4	2022	2022-10	43	0
20221028	2022-10-28	28	Friday	10	October	4	2022	2022-10	43	0
20221029	2022-10-29	29	Saturday	10	October	4	2022	2022-10	43	1
20221030	2022-10-30	30	Sunday	10	October	4	2022	2022-10	43	1
20221031	2022-10-31	31	Monday	10	October	4	2022	2022-10	44	0
20221101	2022-11-01	1	Tuesday	11	November	4	2022	2022-11	44	0
20221102	2022-11-02	2	Wednesday	11	November	4	2022	2022-11	44	0
20221103	2022-11-03	3	Thursday	11	November	4	2022	2022-11	44	0
20221104	2022-11-04	4	Friday	11	November	4	2022	2022-11	44	0
20221105	2022-11-05	5	Saturday	11	November	4	2022	2022-11	44	1
20221106	2022-11-06	6	Sunday	11	November	4	2022	2022-11	44	1
20221107	2022-11-07	7	Monday	11	November	4	2022	2022-11	45	0
20221108	2022-11-08	8	Tuesday	11	November	4	2022	2022-11	45	0
20221109	2022-11-09	9	Wednesday	11	November	4	2022	2022-11	45	0
20221110	2022-11-10	10	Thursday	11	November	4	2022	2022-11	45	0
20221111	2022-11-11	11	Friday	11	November	4	2022	2022-11	45	0
20221112	2022-11-12	12	Saturday	11	November	4	2022	2022-11	45	1
20221113	2022-11-13	13	Sunday	11	November	4	2022	2022-11	45	1
20221114	2022-11-14	14	Monday	11	November	4	2022	2022-11	46	0
20221115	2022-11-15	15	Tuesday	11	November	4	2022	2022-11	46	0
20221116	2022-11-16	16	Wednesday	11	November	4	2022	2022-11	46	0
20221117	2022-11-17	17	Thursday	11	November	4	2022	2022-11	46	0
20221118	2022-11-18	18	Friday	11	November	4	2022	2022-11	46	0
20221119	2022-11-19	19	Saturday	11	November	4	2022	2022-11	46	1
20221120	2022-11-20	20	Sunday	11	November	4	2022	2022-11	46	1
20221121	2022-11-21	21	Monday	11	November	4	2022	2022-11	47	0
20221122	2022-11-22	22	Tuesday	11	November	4	2022	2022-11	47	0
20221123	2022-11-23	23	Wednesday	11	November	4	2022	2022-11	47	0
20221124	2022-11-24	24	Thursday	11	November	4	2022	2022-11	47	0
20221125	2022-11-25	25	Friday	11	November	4	2022	2022-11	47	0
20221126	2022-11-26	26	Saturday	11	November	4	2022	2022-11	47	1
20221127	2022-11-27	27	Sunday	11	November	4	2022	2022-11	47	1
20221128	2022-11-28	28	Monday	11	November	4	2022	2022-11	48	0
20221129	2022-11-29	29	Tuesday	11	November	4	2022	2022-11	48	0
20221130	2022-11-30	30	Wednesday	11	November	4	2022	2022-11	48	0
20221201	2022-12-01	1	Thursday	12	December	4	2022	2022-12	48	0
20221202	2022-12-02	2	Friday	12	December	4	2022	2022-12	48	0
20221203	2022-12-03	3	Saturday	12	December	4	2022	2022-12	48	1
20221204	2022-12-04	4	Sunday	12	December	4	2022	2022-12	48	1
20221205	2022-12-05	5	Monday	12	December	4	2022	2022-12	49	0
20221206	2022-12-06	6	Tuesday	12	December	4	2022	2022-12	49	0
20221207	2022-12-07	7	Wednesday	12	December	4	2022	2022-12	49	0
20221208	2022-12-08	8	Thursday	12	December	4	2022	2022-12	49	0
20221209	2022-12-09	9	Friday	12	December	4	2022	2022-12	49	0
20221210	2022-12-10	10	Saturday	12	December	4	2022	2022-12	49	1
20221211	2022-12-11	11	Sunday	12	December	4	2022	2022-12	49	1
20221212	2022-12-12	12	Monday	12	December	4	2022	2022-12	50	0
20221213	2022-12-13	13	Tuesday	12	December	4	2022	2022-12	50	0
20221214	2022-12-14	14	Wednesday	12	December	4	2022	2022-12	50	0
20221215	2022-12-15	15	Thursday	12	December	4	2022	2022-12	50	0
20221216	2022-12-16	16	Friday	12	December	4	2022	2022-12	50	0
20221217	2022-12-17	17	Saturday	12	December	4	2022	2022-12	50	1
20221218	2022-12-18	18	Sunday	12	December	4	2022	2022-12	50	1
20221219	2022-12-19	19	Monday	12	December	4	2022	2022-12	51	0
20221220	2022-12-20	20	Tuesday	12	December	4	2022	2022-12	51	0
20221221	2022-12-21	21	Wednesday	12	December	4	2022	2022-12	51	0
20221222	2022-12-22	22	Thursday	12	December	4	2022	2022-12	51	0
20221223	2022-12-23	23	Friday	12	December	4	2022	2022-12	51	0
20221224	2022-12-24	24	Saturday	12	December	4	2022	2022-12	51	1
20221225	2022-12-25	25	Sunday	12	December	4	2022	2022-12	51	1
20221226	2022-12-26	26	Monday	12	December	4	2022	2022-12	52	0
20221227	2022-12-27	27	Tuesday	12	December	4	2022	2022-12	52	0
20221228	2022-12-28	28	Wednesday	12	December	4	2022	2022-12	52	0
20221229	2022-12-29	29	Thursday	12	December	4	2022	2022-12	52	0
20221230	2022-12-30	30	Friday	12	December	4	2022	2022-12	52	0
20221231	2022-12-31	31	Saturday	12	December	4	2022	2022-12	52	1
20230101	2023-01-01	1	Sunday	1	January	1	2023	2023-01	52	1
20230102	2023-01-02	2	Monday	1	January	1	2023	2023-01	1	0
20230103	2023-01-03	3	Tuesday	1	January	1	2023	2023-01	1	0
20230104	2023-01-04	4	Wednesday	1	January	1	2023	2023-01	1	0
20230105	2023-01-05	5	Thursday	1	January	1	2023	2023-01	1	0
20230106	2023-01-06	6	Friday	1	January	1	2023	2023-01	1	0
20230107	2023-01-07	7	Saturday	1	January	1	2023	2023-01	1	1
20230108	2023-01-08	8	Sunday	1	January	1	2023	2023-01	1	1
20230109	2023-01-09	9	Monday	1	January	1	2023	2023-01	2	0
20230110	2023-01-10	10	Tuesday	1	January	1	2023	2023-01	2	0
20230111	2023-01-11	11	Wednesday	1	January	1	2023	2023-01	2	0
20230112	2023-01-12	12	Thursday	1	January	1	2023	2023-01	2	0
20230113	2023-01-13	13	Friday	1	January	1	2023	2023-01	2	0
20230114	2023-01-14	14	Saturday	1	January	1	2023	2023-01	2	1
20230115	2023-01-15	15	Sunday	1	January	1	2023	2023-01	2	1
20230116	2023-01-16	16	Monday	1	January	1	2023	2023-01	3	0
20230117	2023-01-17	17	Tuesday	1	January	1	2023	2023-01	3	0
20230118	2023-01-18	18	Wednesday	1	January	1	2023	2023-01	3	0
20230119	2023-01-19	19	Thursday	1	January	1	2023	2023-01	3	0
20230120	2023-01-20	20	Friday	1	January	1	2023	2023-01	3	0
20230121	2023-01-21	21	Saturday	1	January	1	2023	2023-01	3	1
20230122	2023-01-22	22	Sunday	1	January	1	2023	2023-01	3	1
20230123	2023-01-23	23	Monday	1	January	1	2023	2023-01	4	0
20230124	2023-01-24	24	Tuesday	1	January	1	2023	2023-01	4	0
20230125	2023-01-25	25	Wednesday	1	January	1	2023	2023-01	4	0
20230126	2023-01-26	26	Thursday	1	January	1	2023	2023-01	4	0
20230127	2023-01-27	27	Friday	1	January	1	2023	2023-01	4	0
20230128	2023-01-28	28	Saturday	1	January	1	2023	2023-01	4	1
20230129	2023-01-29	29	Sunday	1	January	1	2023	2023-01	4	1
20230130	2023-01-30	30	Monday	1	January	1	2023	2023-01	5	0
20230131	2023-01-31	31	Tuesday	1	January	1	2023	2023-01	5	0
20230201	2023-02-01	1	Wednesday	2	February	1	2023	2023-02	5	0
20230202	2023-02-02	2	Thursday	2	February	1	2023	2023-02	5	0
20230203	2023-02-03	3	Friday	2	February	1	2023	2023-02	5	0
20230204	2023-02-04	4	Saturday	2	February	1	2023	2023-02	5	1
20230205	2023-02-05	5	Sunday	2	February	1	2023	2023-02	5	1
20230206	2023-02-06	6	Monday	2	February	1	2023	2023-02	6	0
20230207	2023-02-07	7	Tuesday	2	February	1	2023	2023-02	6	0
20230208	2023-02-08	8	Wednesday	2	February	1	2023	2023-02	6	0
20230209	2023-02-09	9	Thursday	2	February	1	2023	2023-02	6	0
20230210	2023-02-10	10	Friday	2	February	1	2023	2023-02	6	0
20230211	2023-02-11	11	Saturday	2	February	1	2023	2023-02	6	1
20230212	2023-02-12	12	Sunday	2	February	1	2023	2023-02	6	1
20230213	2023-02-13	13	Monday	2	February	1	2023	2023-02	7	0
20230214	2023-02-14	14	Tuesday	2	February	1	2023	2023-02	7	0
20230215	2023-02-15	15	Wednesday	2	February	1	2023	2023-02	7	0
20230216	2023-02-16	16	Thursday	2	February	1	2023	2023-02	7	0
20230217	2023-02-17	17	Friday	2	February	1	2023	2023-02	7	0
20230218	2023-02-18	18	Saturday	2	February	1	2023	2023-02	7	1
20230219	2023-02-19	19	Sunday	2	February	1	2023	2023-02	7	1
20230220	2023-02-20	20	Monday	2	February	1	2023	2023-02	8	0
20230221	2023-02-21	21	Tuesday	2	February	1	2023	2023-02	8	0
20230222	2023-02-22	22	Wednesday	2	February	1	2023	2023-02	8	0
20230223	2023-02-23	23	Thursday	2	February	1	2023	2023-02	8	0
20230224	2023-02-24	24	Friday	2	February	1	2023	2023-02	8	0
20230225	2023-02-25	25	Saturday	2	February	1	2023	2023-02	8	1
20230226	2023-02-26	26	Sunday	2	February	1	2023	2023-02	8	1
20230227	2023-02-27	27	Monday	2	February	1	2023	2023-02	9	0
20230228	2023-02-28	28	Tuesday	2	February	1	2023	2023-02	9	0
20230301	2023-03-01	1	Wednesday	3	March	1	2023	2023-03	9	0
20230302	2023-03-02	2	Thursday	3	March	1	2023	2023-03	9	0
20230303	2023-03-03	3	Friday	3	March	1	2023	2023-03	9	0
20230304	2023-03-04	4	Saturday	3	March	1	2023	2023-03	9	1
20230305	2023-03-05	5	Sunday	3	March	1	2023	2023-03	9	1
20230306	2023-03-06	6	Monday	3	March	1	2023	2023-03	10	0
20230307	2023-03-07	7	Tuesday	3	March	1	2023	2023-03	10	0
20230308	2023-03-08	8	Wednesday	3	March	1	2023	2023-03	10	0
20230309	2023-03-09	9	Thursday	3	March	1	2023	2023-03	10	0
20230310	2023-03-10	10	Friday	3	March	1	2023	2023-03	10	0
20230311	2023-03-11	11	Saturday	3	March	1	2023	2023-03	10	1
20230312	2023-03-12	12	Sunday	3	March	1	2023	2023-03	10	1
20230313	2023-03-13	13	Monday	3	March	1	2023	2023-03	11	0
20230314	2023-03-14	14	Tuesday	3	March	1	2023	2023-03	11	0
20230315	2023-03-15	15	Wednesday	3	March	1	2023	2023-03	11	0
20230316	2023-03-16	16	Thursday	3	March	1	2023	2023-03	11	0
20230317	2023-03-17	17	Friday	3	March	1	2023	2023-03	11	0
20230318	2023-03-18	18	Saturday	3	March	1	2023	2023-03	11	1
20230319	2023-03-19	19	Sunday	3	March	1	2023	2023-03	11	1
20230320	2023-03-20	20	Monday	3	March	1	2023	2023-03	12	0
20230321	2023-03-21	21	Tuesday	3	March	1	2023	2023-03	12	0
20230322	2023-03-22	22	Wednesday	3	March	1	2023	2023-03	12	0
20230323	2023-03-23	23	Thursday	3	March	1	2023	2023-03	12	0
20230324	2023-03-24	24	Friday	3	March	1	2023	2023-03	12	0
20230325	2023-03-25	25	Saturday	3	March	1	2023	2023-03	12	1
20230326	2023-03-26	26	Sunday	3	March	1	2023	2023-03	12	1
20230327	2023-03-27	27	Monday	3	March	1	2023	2023-03	13	0
20230328	2023-03-28	28	Tuesday	3	March	1	2023	2023-03	13	0
20230329	2023-03-29	29	Wednesday	3	March	1	2023	2023-03	13	0
20230330	2023-03-30	30	Thursday	3	March	1	2023	2023-03	13	0
20230331	2023-03-31	31	Friday	3	March	1	2023	2023-03	13	0
20230401	2023-04-01	1	Saturday	4	April	2	2023	2023-04	13	1
20230402	2023-04-02	2	Sunday	4	April	2	2023	2023-04	13	1
20230403	2023-04-03	3	Monday	4	April	2	2023	2023-04	14	0
20230404	2023-04-04	4	Tuesday	4	April	2	2023	2023-04	14	0
20230405	2023-04-05	5	Wednesday	4	April	2	2023	2023-04	14	0
20230406	2023-04-06	6	Thursday	4	April	2	2023	2023-04	14	0
20230407	2023-04-07	7	Friday	4	April	2	2023	2023-04	14	0
20230408	2023-04-08	8	Saturday	4	April	2	2023	2023-04	14	1
20230409	2023-04-09	9	Sunday	4	April	2	2023	2023-04	14	1
20230410	2023-04-10	10	Monday	4	April	2	2023	2023-04	15	0
20230411	2023-04-11	11	Tuesday	4	April	2	2023	2023-04	15	0
20230412	2023-04-12	12	Wednesday	4	April	2	2023	2023-04	15	0
20230413	2023-04-13	13	Thursday	4	April	2	2023	2023-04	15	0
20230414	2023-04-14	14	Friday	4	April	2	2023	2023-04	15	0
20230415	2023-04-15	15	Saturday	4	April	2	2023	2023-04	15	1
20230416	2023-04-16	16	Sunday	4	April	2	2023	2023-04	15	1
20230417	2023-04-17	17	Monday	4	April	2	2023	2023-04	16	0
20230418	2023-04-18	18	Tuesday	4	April	2	2023	2023-04	16	0
20230419	2023-04-19	19	Wednesday	4	April	2	2023	2023-04	16	0
20230420	2023-04-20	20	Thursday	4	April	2	2023	2023-04	16	0
20230421	2023-04-21	21	Friday	4	April	2	2023	2023-04	16	0
20230422	2023-04-22	22	Saturday	4	April	2	2023	2023-04	16	1
20230423	2023-04-23	23	Sunday	4	April	2	2023	2023-04	16	1
20230424	2023-04-24	24	Monday	4	April	2	2023	2023-04	17	0
20230425	2023-04-25	25	Tuesday	4	April	2	2023	2023-04	17	0
20230426	2023-04-26	26	Wednesday	4	April	2	2023	2023-04	17	0
20230427	2023-04-27	27	Thursday	4	April	2	2023	2023-04	17	0
20230428	2023-04-28	28	Friday	4	April	2	2023	2023-04	17	0
20230429	2023-04-29	29	Saturday	4	April	2	2023	2023-04	17	1
20230430	2023-04-30	30	Sunday	4	April	2	2023	2023-04	17	1
20230501	2023-05-01	1	Monday	5	May	2	2023	2023-05	18	0
20230502	2023-05-02	2	Tuesday	5	May	2	2023	2023-05	18	0
20230503	2023-05-03	3	Wednesday	5	May	2	2023	2023-05	18	0
20230504	2023-05-04	4	Thursday	5	May	2	2023	2023-05	18	0
20230505	2023-05-05	5	Friday	5	May	2	2023	2023-05	18	0
20230506	2023-05-06	6	Saturday	5	May	2	2023	2023-05	18	1
20230507	2023-05-07	7	Sunday	5	May	2	2023	2023-05	18	1
20230508	2023-05-08	8	Monday	5	May	2	2023	2023-05	19	0
20230509	2023-05-09	9	Tuesday	5	May	2	2023	2023-05	19	0
20230510	2023-05-10	10	Wednesday	5	May	2	2023	2023-05	19	0
20230511	2023-05-11	11	Thursday	5	May	2	2023	2023-05	19	0
20230512	2023-05-12	12	Friday	5	May	2	2023	2023-05	19	0
20230513	2023-05-13	13	Saturday	5	May	2	2023	2023-05	19	1
20230514	2023-05-14	14	Sunday	5	May	2	2023	2023-05	19	1
20230515	2023-05-15	15	Monday	5	May	2	2023	2023-05	20	0
20230516	2023-05-16	16	Tuesday	5	May	2	2023	2023-05	20	0
20230517	2023-05-17	17	Wednesday	5	May	2	2023	2023-05	20	0
20230518	2023-05-18	18	Thursday	5	May	2	2023	2023-05	20	0
20230519	2023-05-19	19	Friday	5	May	2	2023	2023-05	20	0
20230520	2023-05-20	20	Saturday	5	May	2	2023	2023-05	20	1
20230521	2023-05-21	21	Sunday	5	May	2	2023	2023-05	20	1
20230522	2023-05-22	22	Monday	5	May	2	2023	2023-05	21	0
20230523	2023-05-23	23	Tuesday	5	May	2	2023	2023-05	21	0
20230524	2023-05-24	24	Wednesday	5	May	2	2023	2023-05	21	0
20230525	2023-05-25	25	Thursday	5	May	2	2023	2023-05	21	0
20230526	2023-05-26	26	Friday	5	May	2	2023	2023-05	21	0
20230527	2023-05-27	27	Saturday	5	May	2	2023	2023-05	21	1
20230528	2023-05-28	28	Sunday	5	May	2	2023	2023-05	21	1
20230529	2023-05-29	29	Monday	5	May	2	2023	2023-05	22	0
20230530	2023-05-30	30	Tuesday	5	May	2	2023	2023-05	22	0
20230531	2023-05-31	31	Wednesday	5	May	2	2023	2023-05	22	0
20230601	2023-06-01	1	Thursday	6	June	2	2023	2023-06	22	0
20230602	2023-06-02	2	Friday	6	June	2	2023	2023-06	22	0
20230603	2023-06-03	3	Saturday	6	June	2	2023	2023-06	22	1
20230604	2023-06-04	4	Sunday	6	June	2	2023	2023-06	22	1
20230605	2023-06-05	5	Monday	6	June	2	2023	2023-06	23	0
20230606	2023-06-06	6	Tuesday	6	June	2	2023	2023-06	23	0
20230607	2023-06-07	7	Wednesday	6	June	2	2023	2023-06	23	0
20230608	2023-06-08	8	Thursday	6	June	2	2023	2023-06	23	0
20230609	2023-06-09	9	Friday	6	June	2	2023	2023-06	23	0
20230610	2023-06-10	10	Saturday	6	June	2	2023	2023-06	23	1
20230611	2023-06-11	11	Sunday	6	June	2	2023	2023-06	23	1
20230612	2023-06-12	12	Monday	6	June	2	2023	2023-06	24	0
20230613	2023-06-13	13	Tuesday	6	June	2	2023	2023-06	24	0
20230614	2023-06-14	14	Wednesday	6	June	2	2023	2023-06	24	0
20230615	2023-06-15	15	Thursday	6	June	2	2023	2023-06	24	0
20230616	2023-06-16	16	Friday	6	June	2	2023	2023-06	24	0
20230617	2023-06-17	17	Saturday	6	June	2	2023	2023-06	24	1
20230618	2023-06-18	18	Sunday	6	June	2	2023	2023-06	24	1
20230619	2023-06-19	19	Monday	6	June	2	2023	2023-06	25	0
20230620	2023-06-20	20	Tuesday	6	June	2	2023	2023-06	25	0
20230621	2023-06-21	21	Wednesday	6	June	2	2023	2023-06	25	0
20230622	2023-06-22	22	Thursday	6	June	2	2023	2023-06	25	0
20230623	2023-06-23	23	Friday	6	June	2	2023	2023-06	25	0
20230624	2023-06-24	24	Saturday	6	June	2	2023	2023-06	25	1
20230625	2023-06-25	25	Sunday	6	June	2	2023	2023-06	25	1
20230626	2023-06-26	26	Monday	6	June	2	2023	2023-06	26	0
20230627	2023-06-27	27	Tuesday	6	June	2	2023	2023-06	26	0
20230628	2023-06-28	28	Wednesday	6	June	2	2023	2023-06	26	0
20230629	2023-06-29	29	Thursday	6	June	2	2023	2023-06	26	0
20230630	2023-06-30	30	Friday	6	June	2	2023	2023-06	26	0
20230701	2023-07-01	1	Saturday	7	July	3	2023	2023-07	26	1
20230702	2023-07-02	2	Sunday	7	July	3	2023	2023-07	26	1
20230703	2023-07-03	3	Monday	7	July	3	2023	2023-07	27	0
20230704	2023-07-04	4	Tuesday	7	July	3	2023	2023-07	27	0
20230705	2023-07-05	5	Wednesday	7	July	3	2023	2023-07	27	0
20230706	2023-07-06	6	Thursday	7	July	3	2023	2023-07	27	0
20230707	2023-07-07	7	Friday	7	July	3	2023	2023-07	27	0
20230708	2023-07-08	8	Saturday	7	July	3	2023	2023-07	27	1
20230709	2023-07-09	9	Sunday	7	July	3	2023	2023-07	27	1
20230710	2023-07-10	10	Monday	7	July	3	2023	2023-07	28	0
20230711	2023-07-11	11	Tuesday	7	July	3	2023	2023-07	28	0
20230712	2023-07-12	12	Wednesday	7	July	3	2023	2023-07	28	0
20230713	2023-07-13	13	Thursday	7	July	3	2023	2023-07	28	0
20230714	2023-07-14	14	Friday	7	July	3	2023	2023-07	28	0
20230715	2023-07-15	15	Saturday	7	July	3	2023	2023-07	28	1
20230716	2023-07-16	16	Sunday	7	July	3	2023	2023-07	28	1
20230717	2023-07-17	17	Monday	7	July	3	2023	2023-07	29	0
20230718	2023-07-18	18	Tuesday	7	July	3	2023	2023-07	29	0
20230719	2023-07-19	19	Wednesday	7	July	3	2023	2023-07	29	0
20230720	2023-07-20	20	Thursday	7	July	3	2023	2023-07	29	0
20230721	2023-07-21	21	Friday	7	July	3	2023	2023-07	29	0
20230722	2023-07-22	22	Saturday	7	July	3	2023	2023-07	29	1
20230723	2023-07-23	23	Sunday	7	July	3	2023	2023-07	29	1
20230724	2023-07-24	24	Monday	7	July	3	2023	2023-07	30	0
20230725	2023-07-25	25	Tuesday	7	July	3	2023	2023-07	30	0
20230726	2023-07-26	26	Wednesday	7	July	3	2023	2023-07	30	0
20230727	2023-07-27	27	Thursday	7	July	3	2023	2023-07	30	0
20230728	2023-07-28	28	Friday	7	July	3	2023	2023-07	30	0
20230729	2023-07-29	29	Saturday	7	July	3	2023	2023-07	30	1
20230730	2023-07-30	30	Sunday	7	July	3	2023	2023-07	30	1
20230731	2023-07-31	31	Monday	7	July	3	2023	2023-07	31	0
20230801	2023-08-01	1	Tuesday	8	August	3	2023	2023-08	31	0
20230802	2023-08-02	2	Wednesday	8	August	3	2023	2023-08	31	0
20230803	2023-08-03	3	Thursday	8	August	3	2023	2023-08	31	0
20230804	2023-08-04	4	Friday	8	August	3	2023	2023-08	31	0
20230805	2023-08-05	5	Saturday	8	August	3	2023	2023-08	31	1
20230806	2023-08-06	6	Sunday	8	August	3	2023	2023-08	31	1
20230807	2023-08-07	7	Monday	8	August	3	2023	2023-08	32	0
20230808	2023-08-08	8	Tuesday	8	August	3	2023	2023-08	32	0
20230809	2023-08-09	9	Wednesday	8	August	3	2023	2023-08	32	0
20230810	2023-08-10	10	Thursday	8	August	3	2023	2023-08	32	0
20230811	2023-08-11	11	Friday	8	August	3	2023	2023-08	32	0
20230812	2023-08-12	12	Saturday	8	August	3	2023	2023-08	32	1
20230813	2023-08-13	13	Sunday	8	August	3	2023	2023-08	32	1
20230814	2023-08-14	14	Monday	8	August	3	2023	2023-08	33	0
20230815	2023-08-15	15	Tuesday	8	August	3	2023	2023-08	33	0
20230816	2023-08-16	16	Wednesday	8	August	3	2023	2023-08	33	0
20230817	2023-08-17	17	Thursday	8	August	3	2023	2023-08	33	0
20230818	2023-08-18	18	Friday	8	August	3	2023	2023-08	33	0
20230819	2023-08-19	19	Saturday	8	August	3	2023	2023-08	33	1
20230820	2023-08-20	20	Sunday	8	August	3	2023	2023-08	33	1
20230821	2023-08-21	21	Monday	8	August	3	2023	2023-08	34	0
20230822	2023-08-22	22	Tuesday	8	August	3	2023	2023-08	34	0
20230823	2023-08-23	23	Wednesday	8	August	3	2023	2023-08	34	0
20230824	2023-08-24	24	Thursday	8	August	3	2023	2023-08	34	0
20230825	2023-08-25	25	Friday	8	August	3	2023	2023-08	34	0
20230826	2023-08-26	26	Saturday	8	August	3	2023	2023-08	34	1
20230827	2023-08-27	27	Sunday	8	August	3	2023	2023-08	34	1
20230828	2023-08-28	28	Monday	8	August	3	2023	2023-08	35	0
20230829	2023-08-29	29	Tuesday	8	August	3	2023	2023-08	35	0
20230830	2023-08-30	30	Wednesday	8	August	3	2023	2023-08	35	0
20230831	2023-08-31	31	Thursday	8	August	3	2023	2023-08	35	0
20230901	2023-09-01	1	Friday	9	September	3	2023	2023-09	35	0
20230902	2023-09-02	2	Saturday	9	September	3	2023	2023-09	35	1
20230903	2023-09-03	3	Sunday	9	September	3	2023	2023-09	35	1
20230904	2023-09-04	4	Monday	9	September	3	2023	2023-09	36	0
20230905	2023-09-05	5	Tuesday	9	September	3	2023	2023-09	36	0
20230906	2023-09-06	6	Wednesday	9	September	3	2023	2023-09	36	0
20230907	2023-09-07	7	Thursday	9	September	3	2023	2023-09	36	0
20230908	2023-09-08	8	Friday	9	September	3	2023	2023-09	36	0
20230909	2023-09-09	9	Saturday	9	September	3	2023	2023-09	36	1
20230910	2023-09-10	10	Sunday	9	September	3	2023	2023-09	36	1
20230911	2023-09-11	11	Monday	9	September	3	2023	2023-09	37	0
20230912	2023-09-12	12	Tuesday	9	September	3	2023	2023-09	37	0
20230913	2023-09-13	13	Wednesday	9	September	3	2023	2023-09	37	0
20230914	2023-09-14	14	Thursday	9	September	3	2023	2023-09	37	0
20230915	2023-09-15	15	Friday	9	September	3	2023	2023-09	37	0
20230916	2023-09-16	16	Saturday	9	September	3	2023	2023-09	37	1
20230917	2023-09-17	17	Sunday	9	September	3	2023	2023-09	37	1
20230918	2023-09-18	18	Monday	9	September	3	2023	2023-09	38	0
20230919	2023-09-19	19	Tuesday	9	September	3	2023	2023-09	38	0
20230920	2023-09-20	20	Wednesday	9	September	3	2023	2023-09	38	0
20230921	2023-09-21	21	Thursday	9	September	3	2023	2023-09	38	0
20230922	2023-09-22	22	Friday	9	September	3	2023	2023-09	38	0
20230923	2023-09-23	23	Saturday	9	September	3	2023	2023-09	38	1
20230924	2023-09-24	24	Sunday	9	September	3	2023	2023-09	38	1
20230925	2023-09-25	25	Monday	9	September	3	2023	2023-09	39	0
20230926	2023-09-26	26	Tuesday	9	September	3	2023	2023-09	39	0
20230927	2023-09-27	27	Wednesday	9	September	3	2023	2023-09	39	0
20230928	2023-09-28	28	Thursday	9	September	3	2023	2023-09	39	0
20230929	2023-09-29	29	Friday	9	September	3	2023	2023-09	39	0
20230930	2023-09-30	30	Saturday	9	September	3	2023	2023-09	39	1
20231001	2023-10-01	1	Sunday	10	October	4	2023	2023-10	39	1
20231002	2023-10-02	2	Monday	10	October	4	2023	2023-10	40	0
20231003	2023-10-03	3	Tuesday	10	October	4	2023	2023-10	40	0
20231004	2023-10-04	4	Wednesday	10	October	4	2023	2023-10	40	0
20231005	2023-10-05	5	Thursday	10	October	4	2023	2023-10	40	0
20231006	2023-10-06	6	Friday	10	October	4	2023	2023-10	40	0
20231007	2023-10-07	7	Saturday	10	October	4	2023	2023-10	40	1
20231008	2023-10-08	8	Sunday	10	October	4	2023	2023-10	40	1
20231009	2023-10-09	9	Monday	10	October	4	2023	2023-10	41	0
20231010	2023-10-10	10	Tuesday	10	October	4	2023	2023-10	41	0
20231011	2023-10-11	11	Wednesday	10	October	4	2023	2023-10	41	0
20231012	2023-10-12	12	Thursday	10	October	4	2023	2023-10	41	0
20231013	2023-10-13	13	Friday	10	October	4	2023	2023-10	41	0
20231014	2023-10-14	14	Saturday	10	October	4	2023	2023-10	41	1
20231015	2023-10-15	15	Sunday	10	October	4	2023	2023-10	41	1
20231016	2023-10-16	16	Monday	10	October	4	2023	2023-10	42	0
20231017	2023-10-17	17	Tuesday	10	October	4	2023	2023-10	42	0
20231018	2023-10-18	18	Wednesday	10	October	4	2023	2023-10	42	0
20231019	2023-10-19	19	Thursday	10	October	4	2023	2023-10	42	0
20231020	2023-10-20	20	Friday	10	October	4	2023	2023-10	42	0
20231021	2023-10-21	21	Saturday	10	October	4	2023	2023-10	42	1
20231022	2023-10-22	22	Sunday	10	October	4	2023	2023-10	42	1
20231023	2023-10-23	23	Monday	10	October	4	2023	2023-10	43	0
20231024	2023-10-24	24	Tuesday	10	October	4	2023	2023-10	43	0
20231025	2023-10-25	25	Wednesday	10	October	4	2023	2023-10	43	0
20231026	2023-10-26	26	Thursday	10	October	4	2023	2023-10	43	0
20231027	2023-10-27	27	Friday	10	October	4	2023	2023-10	43	0
20231028	2023-10-28	28	Saturday	10	October	4	2023	2023-10	43	1
20231029	2023-10-29	29	Sunday	10	October	4	2023	2023-10	43	1
20231030	2023-10-30	30	Monday	10	October	4	2023	2023-10	44	0
20231031	2023-10-31	31	Tuesday	10	October	4	2023	2023-10	44	0
20231101	2023-11-01	1	Wednesday	11	November	4	2023	2023-11	44	0
20231102	2023-11-02	2	Thursday	11	November	4	2023	2023-11	44	0
20231103	2023-11-03	3	Friday	11	November	4	2023	2023-11	44	0
20231104	2023-11-04	4	Saturday	11	November	4	2023	2023-11	44	1
20231105	2023-11-05	5	Sunday	11	November	4	2023	2023-11	44	1
20231106	2023-11-06	6	Monday	11	November	4	2023	2023-11	45	0
20231107	2023-11-07	7	Tuesday	11	November	4	2023	2023-11	45	0
20231108	2023-11-08	8	Wednesday	11	November	4	2023	2023-11	45	0
20231109	2023-11-09	9	Thursday	11	November	4	2023	2023-11	45	0
20231110	2023-11-10	10	Friday	11	November	4	2023	2023-11	45	0
20231111	2023-11-11	11	Saturday	11	November	4	2023	2023-11	45	1
20231112	2023-11-12	12	Sunday	11	November	4	2023	2023-11	45	1
20231113	2023-11-13	13	Monday	11	November	4	2023	2023-11	46	0
20231114	2023-11-14	14	Tuesday	11	November	4	2023	2023-11	46	0
20231115	2023-11-15	15	Wednesday	11	November	4	2023	2023-11	46	0
20231116	2023-11-16	16	Thursday	11	November	4	2023	2023-11	46	0
20231117	2023-11-17	17	Friday	11	November	4	2023	2023-11	46	0
20231118	2023-11-18	18	Saturday	11	November	4	2023	2023-11	46	1
20231119	2023-11-19	19	Sunday	11	November	4	2023	2023-11	46	1
20231120	2023-11-20	20	Monday	11	November	4	2023	2023-11	47	0
20231121	2023-11-21	21	Tuesday	11	November	4	2023	2023-11	47	0
20231122	2023-11-22	22	Wednesday	11	November	4	2023	2023-11	47	0
20231123	2023-11-23	23	Thursday	11	November	4	2023	2023-11	47	0
20231124	2023-11-24	24	Friday	11	November	4	2023	2023-11	47	0
20231125	2023-11-25	25	Saturday	11	November	4	2023	2023-11	47	1
20231126	2023-11-26	26	Sunday	11	November	4	2023	2023-11	47	1
20231127	2023-11-27	27	Monday	11	November	4	2023	2023-11	48	0
20231128	2023-11-28	28	Tuesday	11	November	4	2023	2023-11	48	0
20231129	2023-11-29	29	Wednesday	11	November	4	2023	2023-11	48	0
20231130	2023-11-30	30	Thursday	11	November	4	2023	2023-11	48	0
20231201	2023-12-01	1	Friday	12	December	4	2023	2023-12	48	0
20231202	2023-12-02	2	Saturday	12	December	4	2023	2023-12	48	1
20231203	2023-12-03	3	Sunday	12	December	4	2023	2023-12	48	1
20231204	2023-12-04	4	Monday	12	December	4	2023	2023-12	49	0
20231205	2023-12-05	5	Tuesday	12	December	4	2023	2023-12	49	0
20231206	2023-12-06	6	Wednesday	12	December	4	2023	2023-12	49	0
20231207	2023-12-07	7	Thursday	12	December	4	2023	2023-12	49	0
20231208	2023-12-08	8	Friday	12	December	4	2023	2023-12	49	0
20231209	2023-12-09	9	Saturday	12	December	4	2023	2023-12	49	1
20231210	2023-12-10	10	Sunday	12	December	4	2023	2023-12	49	1
20231211	2023-12-11	11	Monday	12	December	4	2023	2023-12	50	0
20231212	2023-12-12	12	Tuesday	12	December	4	2023	2023-12	50	0
20231213	2023-12-13	13	Wednesday	12	December	4	2023	2023-12	50	0
20231214	2023-12-14	14	Thursday	12	December	4	2023	2023-12	50	0
20231215	2023-12-15	15	Friday	12	December	4	2023	2023-12	50	0
20231216	2023-12-16	16	Saturday	12	December	4	2023	2023-12	50	1
20231217	2023-12-17	17	Sunday	12	December	4	2023	2023-12	50	1
20231218	2023-12-18	18	Monday	12	December	4	2023	2023-12	51	0
20231219	2023-12-19	19	Tuesday	12	December	4	2023	2023-12	51	0
20231220	2023-12-20	20	Wednesday	12	December	4	2023	2023-12	51	0
20231221	2023-12-21	21	Thursday	12	December	4	2023	2023-12	51	0
20231222	2023-12-22	22	Friday	12	December	4	2023	2023-12	51	0
20231223	2023-12-23	23	Saturday	12	December	4	2023	2023-12	51	1
20231224	2023-12-24	24	Sunday	12	December	4	2023	2023-12	51	1
20231225	2023-12-25	25	Monday	12	December	4	2023	2023-12	52	0
20231226	2023-12-26	26	Tuesday	12	December	4	2023	2023-12	52	0
20231227	2023-12-27	27	Wednesday	12	December	4	2023	2023-12	52	0
20231228	2023-12-28	28	Thursday	12	December	4	2023	2023-12	52	0
20231229	2023-12-29	29	Friday	12	December	4	2023	2023-12	52	0
20231230	2023-12-30	30	Saturday	12	December	4	2023	2023-12	52	1
20231231	2023-12-31	31	Sunday	12	December	4	2023	2023-12	52	1
20240101	2024-01-01	1	Monday	1	January	1	2024	2024-01	1	0
20240102	2024-01-02	2	Tuesday	1	January	1	2024	2024-01	1	0
20240103	2024-01-03	3	Wednesday	1	January	1	2024	2024-01	1	0
20240104	2024-01-04	4	Thursday	1	January	1	2024	2024-01	1	0
20240105	2024-01-05	5	Friday	1	January	1	2024	2024-01	1	0
20240106	2024-01-06	6	Saturday	1	January	1	2024	2024-01	1	1
20240107	2024-01-07	7	Sunday	1	January	1	2024	2024-01	1	1
20240108	2024-01-08	8	Monday	1	January	1	2024	2024-01	2	0
20240109	2024-01-09	9	Tuesday	1	January	1	2024	2024-01	2	0
20240110	2024-01-10	10	Wednesday	1	January	1	2024	2024-01	2	0
20240111	2024-01-11	11	Thursday	1	January	1	2024	2024-01	2	0
20240112	2024-01-12	12	Friday	1	January	1	2024	2024-01	2	0
20240113	2024-01-13	13	Saturday	1	January	1	2024	2024-01	2	1
20240114	2024-01-14	14	Sunday	1	January	1	2024	2024-01	2	1
20240115	2024-01-15	15	Monday	1	January	1	2024	2024-01	3	0
20240116	2024-01-16	16	Tuesday	1	January	1	2024	2024-01	3	0
20240117	2024-01-17	17	Wednesday	1	January	1	2024	2024-01	3	0
20240118	2024-01-18	18	Thursday	1	January	1	2024	2024-01	3	0
20240119	2024-01-19	19	Friday	1	January	1	2024	2024-01	3	0
20240120	2024-01-20	20	Saturday	1	January	1	2024	2024-01	3	1
20240121	2024-01-21	21	Sunday	1	January	1	2024	2024-01	3	1
20240122	2024-01-22	22	Monday	1	January	1	2024	2024-01	4	0
20240123	2024-01-23	23	Tuesday	1	January	1	2024	2024-01	4	0
20240124	2024-01-24	24	Wednesday	1	January	1	2024	2024-01	4	0
20240125	2024-01-25	25	Thursday	1	January	1	2024	2024-01	4	0
20240126	2024-01-26	26	Friday	1	January	1	2024	2024-01	4	0
20240127	2024-01-27	27	Saturday	1	January	1	2024	2024-01	4	1
20240128	2024-01-28	28	Sunday	1	January	1	2024	2024-01	4	1
20240129	2024-01-29	29	Monday	1	January	1	2024	2024-01	5	0
20240130	2024-01-30	30	Tuesday	1	January	1	2024	2024-01	5	0
20240131	2024-01-31	31	Wednesday	1	January	1	2024	2024-01	5	0
20240201	2024-02-01	1	Thursday	2	February	1	2024	2024-02	5	0
20240202	2024-02-02	2	Friday	2	February	1	2024	2024-02	5	0
20240203	2024-02-03	3	Saturday	2	February	1	2024	2024-02	5	1
20240204	2024-02-04	4	Sunday	2	February	1	2024	2024-02	5	1
20240205	2024-02-05	5	Monday	2	February	1	2024	2024-02	6	0
20240206	2024-02-06	6	Tuesday	2	February	1	2024	2024-02	6	0
20240207	2024-02-07	7	Wednesday	2	February	1	2024	2024-02	6	0
20240208	2024-02-08	8	Thursday	2	February	1	2024	2024-02	6	0
20240209	2024-02-09	9	Friday	2	February	1	2024	2024-02	6	0
20240210	2024-02-10	10	Saturday	2	February	1	2024	2024-02	6	1
20240211	2024-02-11	11	Sunday	2	February	1	2024	2024-02	6	1
20240212	2024-02-12	12	Monday	2	February	1	2024	2024-02	7	0
20240213	2024-02-13	13	Tuesday	2	February	1	2024	2024-02	7	0
20240214	2024-02-14	14	Wednesday	2	February	1	2024	2024-02	7	0
20240215	2024-02-15	15	Thursday	2	February	1	2024	2024-02	7	0
20240216	2024-02-16	16	Friday	2	February	1	2024	2024-02	7	0
20240217	2024-02-17	17	Saturday	2	February	1	2024	2024-02	7	1
20240218	2024-02-18	18	Sunday	2	February	1	2024	2024-02	7	1
20240219	2024-02-19	19	Monday	2	February	1	2024	2024-02	8	0
20240220	2024-02-20	20	Tuesday	2	February	1	2024	2024-02	8	0
20240221	2024-02-21	21	Wednesday	2	February	1	2024	2024-02	8	0
20240222	2024-02-22	22	Thursday	2	February	1	2024	2024-02	8	0
20240223	2024-02-23	23	Friday	2	February	1	2024	2024-02	8	0
20240224	2024-02-24	24	Saturday	2	February	1	2024	2024-02	8	1
20240225	2024-02-25	25	Sunday	2	February	1	2024	2024-02	8	1
20240226	2024-02-26	26	Monday	2	February	1	2024	2024-02	9	0
20240227	2024-02-27	27	Tuesday	2	February	1	2024	2024-02	9	0
20240228	2024-02-28	28	Wednesday	2	February	1	2024	2024-02	9	0
20240229	2024-02-29	29	Thursday	2	February	1	2024	2024-02	9	0
20240301	2024-03-01	1	Friday	3	March	1	2024	2024-03	9	0
20240302	2024-03-02	2	Saturday	3	March	1	2024	2024-03	9	1
20240303	2024-03-03	3	Sunday	3	March	1	2024	2024-03	9	1
20240304	2024-03-04	4	Monday	3	March	1	2024	2024-03	10	0
20240305	2024-03-05	5	Tuesday	3	March	1	2024	2024-03	10	0
20240306	2024-03-06	6	Wednesday	3	March	1	2024	2024-03	10	0
20240307	2024-03-07	7	Thursday	3	March	1	2024	2024-03	10	0
20240308	2024-03-08	8	Friday	3	March	1	2024	2024-03	10	0
20240309	2024-03-09	9	Saturday	3	March	1	2024	2024-03	10	1
20240310	2024-03-10	10	Sunday	3	March	1	2024	2024-03	10	1
20240311	2024-03-11	11	Monday	3	March	1	2024	2024-03	11	0
20240312	2024-03-12	12	Tuesday	3	March	1	2024	2024-03	11	0
20240313	2024-03-13	13	Wednesday	3	March	1	2024	2024-03	11	0
20240314	2024-03-14	14	Thursday	3	March	1	2024	2024-03	11	0
20240315	2024-03-15	15	Friday	3	March	1	2024	2024-03	11	0
20240316	2024-03-16	16	Saturday	3	March	1	2024	2024-03	11	1
20240317	2024-03-17	17	Sunday	3	March	1	2024	2024-03	11	1
20240318	2024-03-18	18	Monday	3	March	1	2024	2024-03	12	0
20240319	2024-03-19	19	Tuesday	3	March	1	2024	2024-03	12	0
20240320	2024-03-20	20	Wednesday	3	March	1	2024	2024-03	12	0
20240321	2024-03-21	21	Thursday	3	March	1	2024	2024-03	12	0
20240322	2024-03-22	22	Friday	3	March	1	2024	2024-03	12	0
20240323	2024-03-23	23	Saturday	3	March	1	2024	2024-03	12	1
20240324	2024-03-24	24	Sunday	3	March	1	2024	2024-03	12	1
20240325	2024-03-25	25	Monday	3	March	1	2024	2024-03	13	0
20240326	2024-03-26	26	Tuesday	3	March	1	2024	2024-03	13	0
20240327	2024-03-27	27	Wednesday	3	March	1	2024	2024-03	13	0
20240328	2024-03-28	28	Thursday	3	March	1	2024	2024-03	13	0
20240329	2024-03-29	29	Friday	3	March	1	2024	2024-03	13	0
20240330	2024-03-30	30	Saturday	3	March	1	2024	2024-03	13	1
20240331	2024-03-31	31	Sunday	3	March	1	2024	2024-03	13	1
20240401	2024-04-01	1	Monday	4	April	2	2024	2024-04	14	0
20240402	2024-04-02	2	Tuesday	4	April	2	2024	2024-04	14	0
20240403	2024-04-03	3	Wednesday	4	April	2	2024	2024-04	14	0
20240404	2024-04-04	4	Thursday	4	April	2	2024	2024-04	14	0
20240405	2024-04-05	5	Friday	4	April	2	2024	2024-04	14	0
20240406	2024-04-06	6	Saturday	4	April	2	2024	2024-04	14	1
20240407	2024-04-07	7	Sunday	4	April	2	2024	2024-04	14	1
20240408	2024-04-08	8	Monday	4	April	2	2024	2024-04	15	0
20240409	2024-04-09	9	Tuesday	4	April	2	2024	2024-04	15	0
20240410	2024-04-10	10	Wednesday	4	April	2	2024	2024-04	15	0
20240411	2024-04-11	11	Thursday	4	April	2	2024	2024-04	15	0
20240412	2024-04-12	12	Friday	4	April	2	2024	2024-04	15	0
20240413	2024-04-13	13	Saturday	4	April	2	2024	2024-04	15	1
20240414	2024-04-14	14	Sunday	4	April	2	2024	2024-04	15	1
20240415	2024-04-15	15	Monday	4	April	2	2024	2024-04	16	0
20240416	2024-04-16	16	Tuesday	4	April	2	2024	2024-04	16	0
20240417	2024-04-17	17	Wednesday	4	April	2	2024	2024-04	16	0
20240418	2024-04-18	18	Thursday	4	April	2	2024	2024-04	16	0
20240419	2024-04-19	19	Friday	4	April	2	2024	2024-04	16	0
20240420	2024-04-20	20	Saturday	4	April	2	2024	2024-04	16	1
20240421	2024-04-21	21	Sunday	4	April	2	2024	2024-04	16	1
20240422	2024-04-22	22	Monday	4	April	2	2024	2024-04	17	0
20240423	2024-04-23	23	Tuesday	4	April	2	2024	2024-04	17	0
20240424	2024-04-24	24	Wednesday	4	April	2	2024	2024-04	17	0
20240425	2024-04-25	25	Thursday	4	April	2	2024	2024-04	17	0
20240426	2024-04-26	26	Friday	4	April	2	2024	2024-04	17	0
20240427	2024-04-27	27	Saturday	4	April	2	2024	2024-04	17	1
20240428	2024-04-28	28	Sunday	4	April	2	2024	2024-04	17	1
20240429	2024-04-29	29	Monday	4	April	2	2024	2024-04	18	0
20240430	2024-04-30	30	Tuesday	4	April	2	2024	2024-04	18	0
20240501	2024-05-01	1	Wednesday	5	May	2	2024	2024-05	18	0
20240502	2024-05-02	2	Thursday	5	May	2	2024	2024-05	18	0
20240503	2024-05-03	3	Friday	5	May	2	2024	2024-05	18	0
20240504	2024-05-04	4	Saturday	5	May	2	2024	2024-05	18	1
20240505	2024-05-05	5	Sunday	5	May	2	2024	2024-05	18	1
20240506	2024-05-06	6	Monday	5	May	2	2024	2024-05	19	0
20240507	2024-05-07	7	Tuesday	5	May	2	2024	2024-05	19	0
20240508	2024-05-08	8	Wednesday	5	May	2	2024	2024-05	19	0
20240509	2024-05-09	9	Thursday	5	May	2	2024	2024-05	19	0
20240510	2024-05-10	10	Friday	5	May	2	2024	2024-05	19	0
20240511	2024-05-11	11	Saturday	5	May	2	2024	2024-05	19	1
20240512	2024-05-12	12	Sunday	5	May	2	2024	2024-05	19	1
20240513	2024-05-13	13	Monday	5	May	2	2024	2024-05	20	0
20240514	2024-05-14	14	Tuesday	5	May	2	2024	2024-05	20	0
20240515	2024-05-15	15	Wednesday	5	May	2	2024	2024-05	20	0
20240516	2024-05-16	16	Thursday	5	May	2	2024	2024-05	20	0
20240517	2024-05-17	17	Friday	5	May	2	2024	2024-05	20	0
20240518	2024-05-18	18	Saturday	5	May	2	2024	2024-05	20	1
20240519	2024-05-19	19	Sunday	5	May	2	2024	2024-05	20	1
20240520	2024-05-20	20	Monday	5	May	2	2024	2024-05	21	0
20240521	2024-05-21	21	Tuesday	5	May	2	2024	2024-05	21	0
20240522	2024-05-22	22	Wednesday	5	May	2	2024	2024-05	21	0
20240523	2024-05-23	23	Thursday	5	May	2	2024	2024-05	21	0
20240524	2024-05-24	24	Friday	5	May	2	2024	2024-05	21	0
20240525	2024-05-25	25	Saturday	5	May	2	2024	2024-05	21	1
20240526	2024-05-26	26	Sunday	5	May	2	2024	2024-05	21	1
20240527	2024-05-27	27	Monday	5	May	2	2024	2024-05	22	0
20240528	2024-05-28	28	Tuesday	5	May	2	2024	2024-05	22	0
20240529	2024-05-29	29	Wednesday	5	May	2	2024	2024-05	22	0
20240530	2024-05-30	30	Thursday	5	May	2	2024	2024-05	22	0
20240531	2024-05-31	31	Friday	5	May	2	2024	2024-05	22	0
20240601	2024-06-01	1	Saturday	6	June	2	2024	2024-06	22	1
20240602	2024-06-02	2	Sunday	6	June	2	2024	2024-06	22	1
20240603	2024-06-03	3	Monday	6	June	2	2024	2024-06	23	0
20240604	2024-06-04	4	Tuesday	6	June	2	2024	2024-06	23	0
20240605	2024-06-05	5	Wednesday	6	June	2	2024	2024-06	23	0
20240606	2024-06-06	6	Thursday	6	June	2	2024	2024-06	23	0
20240607	2024-06-07	7	Friday	6	June	2	2024	2024-06	23	0
20240608	2024-06-08	8	Saturday	6	June	2	2024	2024-06	23	1
20240609	2024-06-09	9	Sunday	6	June	2	2024	2024-06	23	1
20240610	2024-06-10	10	Monday	6	June	2	2024	2024-06	24	0
20240611	2024-06-11	11	Tuesday	6	June	2	2024	2024-06	24	0
20240612	2024-06-12	12	Wednesday	6	June	2	2024	2024-06	24	0
20240613	2024-06-13	13	Thursday	6	June	2	2024	2024-06	24	0
20240614	2024-06-14	14	Friday	6	June	2	2024	2024-06	24	0
20240615	2024-06-15	15	Saturday	6	June	2	2024	2024-06	24	1
20240616	2024-06-16	16	Sunday	6	June	2	2024	2024-06	24	1
20240617	2024-06-17	17	Monday	6	June	2	2024	2024-06	25	0
20240618	2024-06-18	18	Tuesday	6	June	2	2024	2024-06	25	0
20240619	2024-06-19	19	Wednesday	6	June	2	2024	2024-06	25	0
20240620	2024-06-20	20	Thursday	6	June	2	2024	2024-06	25	0
20240621	2024-06-21	21	Friday	6	June	2	2024	2024-06	25	0
20240622	2024-06-22	22	Saturday	6	June	2	2024	2024-06	25	1
20240623	2024-06-23	23	Sunday	6	June	2	2024	2024-06	25	1
20240624	2024-06-24	24	Monday	6	June	2	2024	2024-06	26	0
20240625	2024-06-25	25	Tuesday	6	June	2	2024	2024-06	26	0
20240626	2024-06-26	26	Wednesday	6	June	2	2024	2024-06	26	0
20240627	2024-06-27	27	Thursday	6	June	2	2024	2024-06	26	0
20240628	2024-06-28	28	Friday	6	June	2	2024	2024-06	26	0
20240629	2024-06-29	29	Saturday	6	June	2	2024	2024-06	26	1
20240630	2024-06-30	30	Sunday	6	June	2	2024	2024-06	26	1
20240701	2024-07-01	1	Monday	7	July	3	2024	2024-07	27	0
20240702	2024-07-02	2	Tuesday	7	July	3	2024	2024-07	27	0
20240703	2024-07-03	3	Wednesday	7	July	3	2024	2024-07	27	0
20240704	2024-07-04	4	Thursday	7	July	3	2024	2024-07	27	0
20240705	2024-07-05	5	Friday	7	July	3	2024	2024-07	27	0
20240706	2024-07-06	6	Saturday	7	July	3	2024	2024-07	27	1
20240707	2024-07-07	7	Sunday	7	July	3	2024	2024-07	27	1
20240708	2024-07-08	8	Monday	7	July	3	2024	2024-07	28	0
20240709	2024-07-09	9	Tuesday	7	July	3	2024	2024-07	28	0
20240710	2024-07-10	10	Wednesday	7	July	3	2024	2024-07	28	0
20240711	2024-07-11	11	Thursday	7	July	3	2024	2024-07	28	0
20240712	2024-07-12	12	Friday	7	July	3	2024	2024-07	28	0
20240713	2024-07-13	13	Saturday	7	July	3	2024	2024-07	28	1
20240714	2024-07-14	14	Sunday	7	July	3	2024	2024-07	28	1
20240715	2024-07-15	15	Monday	7	July	3	2024	2024-07	29	0
20240716	2024-07-16	16	Tuesday	7	July	3	2024	2024-07	29	0
20240717	2024-07-17	17	Wednesday	7	July	3	2024	2024-07	29	0
20240718	2024-07-18	18	Thursday	7	July	3	2024	2024-07	29	0
20240719	2024-07-19	19	Friday	7	July	3	2024	2024-07	29	0
20240720	2024-07-20	20	Saturday	7	July	3	2024	2024-07	29	1
20240721	2024-07-21	21	Sunday	7	July	3	2024	2024-07	29	1
20240722	2024-07-22	22	Monday	7	July	3	2024	2024-07	30	0
20240723	2024-07-23	23	Tuesday	7	July	3	2024	2024-07	30	0
20240724	2024-07-24	24	Wednesday	7	July	3	2024	2024-07	30	0
20240725	2024-07-25	25	Thursday	7	July	3	2024	2024-07	30	0
20240726	2024-07-26	26	Friday	7	July	3	2024	2024-07	30	0
20240727	2024-07-27	27	Saturday	7	July	3	2024	2024-07	30	1
20240728	2024-07-28	28	Sunday	7	July	3	2024	2024-07	30	1
20240729	2024-07-29	29	Monday	7	July	3	2024	2024-07	31	0
20240730	2024-07-30	30	Tuesday	7	July	3	2024	2024-07	31	0
20240731	2024-07-31	31	Wednesday	7	July	3	2024	2024-07	31	0
20240801	2024-08-01	1	Thursday	8	August	3	2024	2024-08	31	0
20240802	2024-08-02	2	Friday	8	August	3	2024	2024-08	31	0
20240803	2024-08-03	3	Saturday	8	August	3	2024	2024-08	31	1
20240804	2024-08-04	4	Sunday	8	August	3	2024	2024-08	31	1
20240805	2024-08-05	5	Monday	8	August	3	2024	2024-08	32	0
20240806	2024-08-06	6	Tuesday	8	August	3	2024	2024-08	32	0
20240807	2024-08-07	7	Wednesday	8	August	3	2024	2024-08	32	0
20240808	2024-08-08	8	Thursday	8	August	3	2024	2024-08	32	0
20240809	2024-08-09	9	Friday	8	August	3	2024	2024-08	32	0
20240810	2024-08-10	10	Saturday	8	August	3	2024	2024-08	32	1
20240811	2024-08-11	11	Sunday	8	August	3	2024	2024-08	32	1
20240812	2024-08-12	12	Monday	8	August	3	2024	2024-08	33	0
20240813	2024-08-13	13	Tuesday	8	August	3	2024	2024-08	33	0
20240814	2024-08-14	14	Wednesday	8	August	3	2024	2024-08	33	0
20240815	2024-08-15	15	Thursday	8	August	3	2024	2024-08	33	0
20240816	2024-08-16	16	Friday	8	August	3	2024	2024-08	33	0
20240817	2024-08-17	17	Saturday	8	August	3	2024	2024-08	33	1
20240818	2024-08-18	18	Sunday	8	August	3	2024	2024-08	33	1
20240819	2024-08-19	19	Monday	8	August	3	2024	2024-08	34	0
20240820	2024-08-20	20	Tuesday	8	August	3	2024	2024-08	34	0
20240821	2024-08-21	21	Wednesday	8	August	3	2024	2024-08	34	0
20240822	2024-08-22	22	Thursday	8	August	3	2024	2024-08	34	0
20240823	2024-08-23	23	Friday	8	August	3	2024	2024-08	34	0
20240824	2024-08-24	24	Saturday	8	August	3	2024	2024-08	34	1
20240825	2024-08-25	25	Sunday	8	August	3	2024	2024-08	34	1
20240826	2024-08-26	26	Monday	8	August	3	2024	2024-08	35	0
20240827	2024-08-27	27	Tuesday	8	August	3	2024	2024-08	35	0
20240828	2024-08-28	28	Wednesday	8	August	3	2024	2024-08	35	0
20240829	2024-08-29	29	Thursday	8	August	3	2024	2024-08	35	0
20240830	2024-08-30	30	Friday	8	August	3	2024	2024-08	35	0
20240831	2024-08-31	31	Saturday	8	August	3	2024	2024-08	35	1
20240901	2024-09-01	1	Sunday	9	September	3	2024	2024-09	35	1
20240902	2024-09-02	2	Monday	9	September	3	2024	2024-09	36	0
20240903	2024-09-03	3	Tuesday	9	September	3	2024	2024-09	36	0
20240904	2024-09-04	4	Wednesday	9	September	3	2024	2024-09	36	0
20240905	2024-09-05	5	Thursday	9	September	3	2024	2024-09	36	0
20240906	2024-09-06	6	Friday	9	September	3	2024	2024-09	36	0
20240907	2024-09-07	7	Saturday	9	September	3	2024	2024-09	36	1
20240908	2024-09-08	8	Sunday	9	September	3	2024	2024-09	36	1
20240909	2024-09-09	9	Monday	9	September	3	2024	2024-09	37	0
20240910	2024-09-10	10	Tuesday	9	September	3	2024	2024-09	37	0
20240911	2024-09-11	11	Wednesday	9	September	3	2024	2024-09	37	0
20240912	2024-09-12	12	Thursday	9	September	3	2024	2024-09	37	0
20240913	2024-09-13	13	Friday	9	September	3	2024	2024-09	37	0
20240914	2024-09-14	14	Saturday	9	September	3	2024	2024-09	37	1
20240915	2024-09-15	15	Sunday	9	September	3	2024	2024-09	37	1
20240916	2024-09-16	16	Monday	9	September	3	2024	2024-09	38	0
20240917	2024-09-17	17	Tuesday	9	September	3	2024	2024-09	38	0
20240918	2024-09-18	18	Wednesday	9	September	3	2024	2024-09	38	0
20240919	2024-09-19	19	Thursday	9	September	3	2024	2024-09	38	0
20240920	2024-09-20	20	Friday	9	September	3	2024	2024-09	38	0
20240921	2024-09-21	21	Saturday	9	September	3	2024	2024-09	38	1
20240922	2024-09-22	22	Sunday	9	September	3	2024	2024-09	38	1
20240923	2024-09-23	23	Monday	9	September	3	2024	2024-09	39	0
20240924	2024-09-24	24	Tuesday	9	September	3	2024	2024-09	39	0
20240925	2024-09-25	25	Wednesday	9	September	3	2024	2024-09	39	0
20240926	2024-09-26	26	Thursday	9	September	3	2024	2024-09	39	0
20240927	2024-09-27	27	Friday	9	September	3	2024	2024-09	39	0
20240928	2024-09-28	28	Saturday	9	September	3	2024	2024-09	39	1
20240929	2024-09-29	29	Sunday	9	September	3	2024	2024-09	39	1
20240930	2024-09-30	30	Monday	9	September	3	2024	2024-09	40	0
20241001	2024-10-01	1	Tuesday	10	October	4	2024	2024-10	40	0
20241002	2024-10-02	2	Wednesday	10	October	4	2024	2024-10	40	0
20241003	2024-10-03	3	Thursday	10	October	4	2024	2024-10	40	0
20241004	2024-10-04	4	Friday	10	October	4	2024	2024-10	40	0
20241005	2024-10-05	5	Saturday	10	October	4	2024	2024-10	40	1
20241006	2024-10-06	6	Sunday	10	October	4	2024	2024-10	40	1
20241007	2024-10-07	7	Monday	10	October	4	2024	2024-10	41	0
20241008	2024-10-08	8	Tuesday	10	October	4	2024	2024-10	41	0
20241009	2024-10-09	9	Wednesday	10	October	4	2024	2024-10	41	0
20241010	2024-10-10	10	Thursday	10	October	4	2024	2024-10	41	0
20241011	2024-10-11	11	Friday	10	October	4	2024	2024-10	41	0
20241012	2024-10-12	12	Saturday	10	October	4	2024	2024-10	41	1
20241013	2024-10-13	13	Sunday	10	October	4	2024	2024-10	41	1
20241014	2024-10-14	14	Monday	10	October	4	2024	2024-10	42	0
20241015	2024-10-15	15	Tuesday	10	October	4	2024	2024-10	42	0
20241016	2024-10-16	16	Wednesday	10	October	4	2024	2024-10	42	0
20241017	2024-10-17	17	Thursday	10	October	4	2024	2024-10	42	0
20241018	2024-10-18	18	Friday	10	October	4	2024	2024-10	42	0
20241019	2024-10-19	19	Saturday	10	October	4	2024	2024-10	42	1
20241020	2024-10-20	20	Sunday	10	October	4	2024	2024-10	42	1
20241021	2024-10-21	21	Monday	10	October	4	2024	2024-10	43	0
20241022	2024-10-22	22	Tuesday	10	October	4	2024	2024-10	43	0
20241023	2024-10-23	23	Wednesday	10	October	4	2024	2024-10	43	0
20241024	2024-10-24	24	Thursday	10	October	4	2024	2024-10	43	0
20241025	2024-10-25	25	Friday	10	October	4	2024	2024-10	43	0
20241026	2024-10-26	26	Saturday	10	October	4	2024	2024-10	43	1
20241027	2024-10-27	27	Sunday	10	October	4	2024	2024-10	43	1
20241028	2024-10-28	28	Monday	10	October	4	2024	2024-10	44	0
20241029	2024-10-29	29	Tuesday	10	October	4	2024	2024-10	44	0
20241030	2024-10-30	30	Wednesday	10	October	4	2024	2024-10	44	0
20241031	2024-10-31	31	Thursday	10	October	4	2024	2024-10	44	0
20241101	2024-11-01	1	Friday	11	November	4	2024	2024-11	44	0
20241102	2024-11-02	2	Saturday	11	November	4	2024	2024-11	44	1
20241103	2024-11-03	3	Sunday	11	November	4	2024	2024-11	44	1
20241104	2024-11-04	4	Monday	11	November	4	2024	2024-11	45	0
20241105	2024-11-05	5	Tuesday	11	November	4	2024	2024-11	45	0
20241106	2024-11-06	6	Wednesday	11	November	4	2024	2024-11	45	0
20241107	2024-11-07	7	Thursday	11	November	4	2024	2024-11	45	0
20241108	2024-11-08	8	Friday	11	November	4	2024	2024-11	45	0
20241109	2024-11-09	9	Saturday	11	November	4	2024	2024-11	45	1
20241110	2024-11-10	10	Sunday	11	November	4	2024	2024-11	45	1
20241111	2024-11-11	11	Monday	11	November	4	2024	2024-11	46	0
20241112	2024-11-12	12	Tuesday	11	November	4	2024	2024-11	46	0
20241113	2024-11-13	13	Wednesday	11	November	4	2024	2024-11	46	0
20241114	2024-11-14	14	Thursday	11	November	4	2024	2024-11	46	0
20241115	2024-11-15	15	Friday	11	November	4	2024	2024-11	46	0
20241116	2024-11-16	16	Saturday	11	November	4	2024	2024-11	46	1
20241117	2024-11-17	17	Sunday	11	November	4	2024	2024-11	46	1
20241118	2024-11-18	18	Monday	11	November	4	2024	2024-11	47	0
20241119	2024-11-19	19	Tuesday	11	November	4	2024	2024-11	47	0
20241120	2024-11-20	20	Wednesday	11	November	4	2024	2024-11	47	0
20241121	2024-11-21	21	Thursday	11	November	4	2024	2024-11	47	0
20241122	2024-11-22	22	Friday	11	November	4	2024	2024-11	47	0
20241123	2024-11-23	23	Saturday	11	November	4	2024	2024-11	47	1
20241124	2024-11-24	24	Sunday	11	November	4	2024	2024-11	47	1
20241125	2024-11-25	25	Monday	11	November	4	2024	2024-11	48	0
20241126	2024-11-26	26	Tuesday	11	November	4	2024	2024-11	48	0
20241127	2024-11-27	27	Wednesday	11	November	4	2024	2024-11	48	0
20241128	2024-11-28	28	Thursday	11	November	4	2024	2024-11	48	0
20241129	2024-11-29	29	Friday	11	November	4	2024	2024-11	48	0
20241130	2024-11-30	30	Saturday	11	November	4	2024	2024-11	48	1
20241201	2024-12-01	1	Sunday	12	December	4	2024	2024-12	48	1
20241202	2024-12-02	2	Monday	12	December	4	2024	2024-12	49	0
20241203	2024-12-03	3	Tuesday	12	December	4	2024	2024-12	49	0
20241204	2024-12-04	4	Wednesday	12	December	4	2024	2024-12	49	0
20241205	2024-12-05	5	Thursday	12	December	4	2024	2024-12	49	0
20241206	2024-12-06	6	Friday	12	December	4	2024	2024-12	49	0
20241207	2024-12-07	7	Saturday	12	December	4	2024	2024-12	49	1
20241208	2024-12-08	8	Sunday	12	December	4	2024	2024-12	49	1
20241209	2024-12-09	9	Monday	12	December	4	2024	2024-12	50	0
20241210	2024-12-10	10	Tuesday	12	December	4	2024	2024-12	50	0
20241211	2024-12-11	11	Wednesday	12	December	4	2024	2024-12	50	0
20241212	2024-12-12	12	Thursday	12	December	4	2024	2024-12	50	0
20241213	2024-12-13	13	Friday	12	December	4	2024	2024-12	50	0
20241214	2024-12-14	14	Saturday	12	December	4	2024	2024-12	50	1
20241215	2024-12-15	15	Sunday	12	December	4	2024	2024-12	50	1
20241216	2024-12-16	16	Monday	12	December	4	2024	2024-12	51	0
20241217	2024-12-17	17	Tuesday	12	December	4	2024	2024-12	51	0
20241218	2024-12-18	18	Wednesday	12	December	4	2024	2024-12	51	0
20241219	2024-12-19	19	Thursday	12	December	4	2024	2024-12	51	0
20241220	2024-12-20	20	Friday	12	December	4	2024	2024-12	51	0
20241221	2024-12-21	21	Saturday	12	December	4	2024	2024-12	51	1
20241222	2024-12-22	22	Sunday	12	December	4	2024	2024-12	51	1
20241223	2024-12-23	23	Monday	12	December	4	2024	2024-12	52	0
20241224	2024-12-24	24	Tuesday	12	December	4	2024	2024-12	52	0
20241225	2024-12-25	25	Wednesday	12	December	4	2024	2024-12	52	0
20241226	2024-12-26	26	Thursday	12	December	4	2024	2024-12	52	0
20241227	2024-12-27	27	Friday	12	December	4	2024	2024-12	52	0
20241228	2024-12-28	28	Saturday	12	December	4	2024	2024-12	52	1
20241229	2024-12-29	29	Sunday	12	December	4	2024	2024-12	52	1
20241230	2024-12-30	30	Monday	12	December	4	2024	2024-12	1	0
20241231	2024-12-31	31	Tuesday	12	December	4	2024	2024-12	1	0
20250101	2025-01-01	1	Wednesday	1	January	1	2025	2025-01	1	0
20250102	2025-01-02	2	Thursday	1	January	1	2025	2025-01	1	0
20250103	2025-01-03	3	Friday	1	January	1	2025	2025-01	1	0
20250104	2025-01-04	4	Saturday	1	January	1	2025	2025-01	1	1
20250105	2025-01-05	5	Sunday	1	January	1	2025	2025-01	1	1
20250106	2025-01-06	6	Monday	1	January	1	2025	2025-01	2	0
20250107	2025-01-07	7	Tuesday	1	January	1	2025	2025-01	2	0
20250108	2025-01-08	8	Wednesday	1	January	1	2025	2025-01	2	0
20250109	2025-01-09	9	Thursday	1	January	1	2025	2025-01	2	0
20250110	2025-01-10	10	Friday	1	January	1	2025	2025-01	2	0
20250111	2025-01-11	11	Saturday	1	January	1	2025	2025-01	2	1
20250112	2025-01-12	12	Sunday	1	January	1	2025	2025-01	2	1
20250113	2025-01-13	13	Monday	1	January	1	2025	2025-01	3	0
20250114	2025-01-14	14	Tuesday	1	January	1	2025	2025-01	3	0
20250115	2025-01-15	15	Wednesday	1	January	1	2025	2025-01	3	0
20250116	2025-01-16	16	Thursday	1	January	1	2025	2025-01	3	0
20250117	2025-01-17	17	Friday	1	January	1	2025	2025-01	3	0
20250118	2025-01-18	18	Saturday	1	January	1	2025	2025-01	3	1
20250119	2025-01-19	19	Sunday	1	January	1	2025	2025-01	3	1
20250120	2025-01-20	20	Monday	1	January	1	2025	2025-01	4	0
20250121	2025-01-21	21	Tuesday	1	January	1	2025	2025-01	4	0
20250122	2025-01-22	22	Wednesday	1	January	1	2025	2025-01	4	0
20250123	2025-01-23	23	Thursday	1	January	1	2025	2025-01	4	0
20250124	2025-01-24	24	Friday	1	January	1	2025	2025-01	4	0
20250125	2025-01-25	25	Saturday	1	January	1	2025	2025-01	4	1
20250126	2025-01-26	26	Sunday	1	January	1	2025	2025-01	4	1
20250127	2025-01-27	27	Monday	1	January	1	2025	2025-01	5	0
20250128	2025-01-28	28	Tuesday	1	January	1	2025	2025-01	5	0
20250129	2025-01-29	29	Wednesday	1	January	1	2025	2025-01	5	0
20250130	2025-01-30	30	Thursday	1	January	1	2025	2025-01	5	0
20250131	2025-01-31	31	Friday	1	January	1	2025	2025-01	5	0
20250201	2025-02-01	1	Saturday	2	February	1	2025	2025-02	5	1
20250202	2025-02-02	2	Sunday	2	February	1	2025	2025-02	5	1
20250203	2025-02-03	3	Monday	2	February	1	2025	2025-02	6	0
20250204	2025-02-04	4	Tuesday	2	February	1	2025	2025-02	6	0
20250205	2025-02-05	5	Wednesday	2	February	1	2025	2025-02	6	0
20250206	2025-02-06	6	Thursday	2	February	1	2025	2025-02	6	0
20250207	2025-02-07	7	Friday	2	February	1	2025	2025-02	6	0
20250208	2025-02-08	8	Saturday	2	February	1	2025	2025-02	6	1
20250209	2025-02-09	9	Sunday	2	February	1	2025	2025-02	6	1
20250210	2025-02-10	10	Monday	2	February	1	2025	2025-02	7	0
20250211	2025-02-11	11	Tuesday	2	February	1	2025	2025-02	7	0
20250212	2025-02-12	12	Wednesday	2	February	1	2025	2025-02	7	0
20250213	2025-02-13	13	Thursday	2	February	1	2025	2025-02	7	0
20250214	2025-02-14	14	Friday	2	February	1	2025	2025-02	7	0
20250215	2025-02-15	15	Saturday	2	February	1	2025	2025-02	7	1
20250216	2025-02-16	16	Sunday	2	February	1	2025	2025-02	7	1
20250217	2025-02-17	17	Monday	2	February	1	2025	2025-02	8	0
20250218	2025-02-18	18	Tuesday	2	February	1	2025	2025-02	8	0
20250219	2025-02-19	19	Wednesday	2	February	1	2025	2025-02	8	0
20250220	2025-02-20	20	Thursday	2	February	1	2025	2025-02	8	0
20250221	2025-02-21	21	Friday	2	February	1	2025	2025-02	8	0
20250222	2025-02-22	22	Saturday	2	February	1	2025	2025-02	8	1
20250223	2025-02-23	23	Sunday	2	February	1	2025	2025-02	8	1
20250224	2025-02-24	24	Monday	2	February	1	2025	2025-02	9	0
20250225	2025-02-25	25	Tuesday	2	February	1	2025	2025-02	9	0
20250226	2025-02-26	26	Wednesday	2	February	1	2025	2025-02	9	0
20250227	2025-02-27	27	Thursday	2	February	1	2025	2025-02	9	0
20250228	2025-02-28	28	Friday	2	February	1	2025	2025-02	9	0
20250301	2025-03-01	1	Saturday	3	March	1	2025	2025-03	9	1
20250302	2025-03-02	2	Sunday	3	March	1	2025	2025-03	9	1
20250303	2025-03-03	3	Monday	3	March	1	2025	2025-03	10	0
20250304	2025-03-04	4	Tuesday	3	March	1	2025	2025-03	10	0
20250305	2025-03-05	5	Wednesday	3	March	1	2025	2025-03	10	0
20250306	2025-03-06	6	Thursday	3	March	1	2025	2025-03	10	0
20250307	2025-03-07	7	Friday	3	March	1	2025	2025-03	10	0
20250308	2025-03-08	8	Saturday	3	March	1	2025	2025-03	10	1
20250309	2025-03-09	9	Sunday	3	March	1	2025	2025-03	10	1
20250310	2025-03-10	10	Monday	3	March	1	2025	2025-03	11	0
20250311	2025-03-11	11	Tuesday	3	March	1	2025	2025-03	11	0
20250312	2025-03-12	12	Wednesday	3	March	1	2025	2025-03	11	0
20250313	2025-03-13	13	Thursday	3	March	1	2025	2025-03	11	0
20250314	2025-03-14	14	Friday	3	March	1	2025	2025-03	11	0
20250315	2025-03-15	15	Saturday	3	March	1	2025	2025-03	11	1
20250316	2025-03-16	16	Sunday	3	March	1	2025	2025-03	11	1
20250317	2025-03-17	17	Monday	3	March	1	2025	2025-03	12	0
20250318	2025-03-18	18	Tuesday	3	March	1	2025	2025-03	12	0
20250319	2025-03-19	19	Wednesday	3	March	1	2025	2025-03	12	0
20250320	2025-03-20	20	Thursday	3	March	1	2025	2025-03	12	0
20250321	2025-03-21	21	Friday	3	March	1	2025	2025-03	12	0
20250322	2025-03-22	22	Saturday	3	March	1	2025	2025-03	12	1
20250323	2025-03-23	23	Sunday	3	March	1	2025	2025-03	12	1
20250324	2025-03-24	24	Monday	3	March	1	2025	2025-03	13	0
20250325	2025-03-25	25	Tuesday	3	March	1	2025	2025-03	13	0
20250326	2025-03-26	26	Wednesday	3	March	1	2025	2025-03	13	0
20250327	2025-03-27	27	Thursday	3	March	1	2025	2025-03	13	0
20250328	2025-03-28	28	Friday	3	March	1	2025	2025-03	13	0
20250329	2025-03-29	29	Saturday	3	March	1	2025	2025-03	13	1
20250330	2025-03-30	30	Sunday	3	March	1	2025	2025-03	13	1
20250331	2025-03-31	31	Monday	3	March	1	2025	2025-03	14	0
20250401	2025-04-01	1	Tuesday	4	April	2	2025	2025-04	14	0
20250402	2025-04-02	2	Wednesday	4	April	2	2025	2025-04	14	0
20250403	2025-04-03	3	Thursday	4	April	2	2025	2025-04	14	0
20250404	2025-04-04	4	Friday	4	April	2	2025	2025-04	14	0
20250405	2025-04-05	5	Saturday	4	April	2	2025	2025-04	14	1
20250406	2025-04-06	6	Sunday	4	April	2	2025	2025-04	14	1
20250407	2025-04-07	7	Monday	4	April	2	2025	2025-04	15	0
20250408	2025-04-08	8	Tuesday	4	April	2	2025	2025-04	15	0
20250409	2025-04-09	9	Wednesday	4	April	2	2025	2025-04	15	0
20250410	2025-04-10	10	Thursday	4	April	2	2025	2025-04	15	0
20250411	2025-04-11	11	Friday	4	April	2	2025	2025-04	15	0
20250412	2025-04-12	12	Saturday	4	April	2	2025	2025-04	15	1
20250413	2025-04-13	13	Sunday	4	April	2	2025	2025-04	15	1
20250414	2025-04-14	14	Monday	4	April	2	2025	2025-04	16	0
20250415	2025-04-15	15	Tuesday	4	April	2	2025	2025-04	16	0
20250416	2025-04-16	16	Wednesday	4	April	2	2025	2025-04	16	0
20250417	2025-04-17	17	Thursday	4	April	2	2025	2025-04	16	0
20250418	2025-04-18	18	Friday	4	April	2	2025	2025-04	16	0
20250419	2025-04-19	19	Saturday	4	April	2	2025	2025-04	16	1
20250420	2025-04-20	20	Sunday	4	April	2	2025	2025-04	16	1
20250421	2025-04-21	21	Monday	4	April	2	2025	2025-04	17	0
20250422	2025-04-22	22	Tuesday	4	April	2	2025	2025-04	17	0
20250423	2025-04-23	23	Wednesday	4	April	2	2025	2025-04	17	0
20250424	2025-04-24	24	Thursday	4	April	2	2025	2025-04	17	0
20250425	2025-04-25	25	Friday	4	April	2	2025	2025-04	17	0
20250426	2025-04-26	26	Saturday	4	April	2	2025	2025-04	17	1
20250427	2025-04-27	27	Sunday	4	April	2	2025	2025-04	17	1
20250428	2025-04-28	28	Monday	4	April	2	2025	2025-04	18	0
20250429	2025-04-29	29	Tuesday	4	April	2	2025	2025-04	18	0
20250430	2025-04-30	30	Wednesday	4	April	2	2025	2025-04	18	0
20250501	2025-05-01	1	Thursday	5	May	2	2025	2025-05	18	0
20250502	2025-05-02	2	Friday	5	May	2	2025	2025-05	18	0
20250503	2025-05-03	3	Saturday	5	May	2	2025	2025-05	18	1
20250504	2025-05-04	4	Sunday	5	May	2	2025	2025-05	18	1
20250505	2025-05-05	5	Monday	5	May	2	2025	2025-05	19	0
20250506	2025-05-06	6	Tuesday	5	May	2	2025	2025-05	19	0
20250507	2025-05-07	7	Wednesday	5	May	2	2025	2025-05	19	0
20250508	2025-05-08	8	Thursday	5	May	2	2025	2025-05	19	0
20250509	2025-05-09	9	Friday	5	May	2	2025	2025-05	19	0
20250510	2025-05-10	10	Saturday	5	May	2	2025	2025-05	19	1
20250511	2025-05-11	11	Sunday	5	May	2	2025	2025-05	19	1
20250512	2025-05-12	12	Monday	5	May	2	2025	2025-05	20	0
20250513	2025-05-13	13	Tuesday	5	May	2	2025	2025-05	20	0
20250514	2025-05-14	14	Wednesday	5	May	2	2025	2025-05	20	0
20250515	2025-05-15	15	Thursday	5	May	2	2025	2025-05	20	0
20250516	2025-05-16	16	Friday	5	May	2	2025	2025-05	20	0
20250517	2025-05-17	17	Saturday	5	May	2	2025	2025-05	20	1
20250518	2025-05-18	18	Sunday	5	May	2	2025	2025-05	20	1
20250519	2025-05-19	19	Monday	5	May	2	2025	2025-05	21	0
20250520	2025-05-20	20	Tuesday	5	May	2	2025	2025-05	21	0
20250521	2025-05-21	21	Wednesday	5	May	2	2025	2025-05	21	0
20250522	2025-05-22	22	Thursday	5	May	2	2025	2025-05	21	0
20250523	2025-05-23	23	Friday	5	May	2	2025	2025-05	21	0
20250524	2025-05-24	24	Saturday	5	May	2	2025	2025-05	21	1
20250525	2025-05-25	25	Sunday	5	May	2	2025	2025-05	21	1
20250526	2025-05-26	26	Monday	5	May	2	2025	2025-05	22	0
20250527	2025-05-27	27	Tuesday	5	May	2	2025	2025-05	22	0
20250528	2025-05-28	28	Wednesday	5	May	2	2025	2025-05	22	0
20250529	2025-05-29	29	Thursday	5	May	2	2025	2025-05	22	0
20250530	2025-05-30	30	Friday	5	May	2	2025	2025-05	22	0
20250531	2025-05-31	31	Saturday	5	May	2	2025	2025-05	22	1
20250601	2025-06-01	1	Sunday	6	June	2	2025	2025-06	22	1
20250602	2025-06-02	2	Monday	6	June	2	2025	2025-06	23	0
20250603	2025-06-03	3	Tuesday	6	June	2	2025	2025-06	23	0
20250604	2025-06-04	4	Wednesday	6	June	2	2025	2025-06	23	0
20250605	2025-06-05	5	Thursday	6	June	2	2025	2025-06	23	0
20250606	2025-06-06	6	Friday	6	June	2	2025	2025-06	23	0
20250607	2025-06-07	7	Saturday	6	June	2	2025	2025-06	23	1
20250608	2025-06-08	8	Sunday	6	June	2	2025	2025-06	23	1
20250609	2025-06-09	9	Monday	6	June	2	2025	2025-06	24	0
20250610	2025-06-10	10	Tuesday	6	June	2	2025	2025-06	24	0
20250611	2025-06-11	11	Wednesday	6	June	2	2025	2025-06	24	0
20250612	2025-06-12	12	Thursday	6	June	2	2025	2025-06	24	0
20250613	2025-06-13	13	Friday	6	June	2	2025	2025-06	24	0
20250614	2025-06-14	14	Saturday	6	June	2	2025	2025-06	24	1
20250615	2025-06-15	15	Sunday	6	June	2	2025	2025-06	24	1
20250616	2025-06-16	16	Monday	6	June	2	2025	2025-06	25	0
20250617	2025-06-17	17	Tuesday	6	June	2	2025	2025-06	25	0
20250618	2025-06-18	18	Wednesday	6	June	2	2025	2025-06	25	0
20250619	2025-06-19	19	Thursday	6	June	2	2025	2025-06	25	0
20250620	2025-06-20	20	Friday	6	June	2	2025	2025-06	25	0
20250621	2025-06-21	21	Saturday	6	June	2	2025	2025-06	25	1
20250622	2025-06-22	22	Sunday	6	June	2	2025	2025-06	25	1
20250623	2025-06-23	23	Monday	6	June	2	2025	2025-06	26	0
20250624	2025-06-24	24	Tuesday	6	June	2	2025	2025-06	26	0
20250625	2025-06-25	25	Wednesday	6	June	2	2025	2025-06	26	0
20250626	2025-06-26	26	Thursday	6	June	2	2025	2025-06	26	0
20250627	2025-06-27	27	Friday	6	June	2	2025	2025-06	26	0
20250628	2025-06-28	28	Saturday	6	June	2	2025	2025-06	26	1
20250629	2025-06-29	29	Sunday	6	June	2	2025	2025-06	26	1
20250630	2025-06-30	30	Monday	6	June	2	2025	2025-06	27	0
20250701	2025-07-01	1	Tuesday	7	July	3	2025	2025-07	27	0
20250702	2025-07-02	2	Wednesday	7	July	3	2025	2025-07	27	0
20250703	2025-07-03	3	Thursday	7	July	3	2025	2025-07	27	0
20250704	2025-07-04	4	Friday	7	July	3	2025	2025-07	27	0
20250705	2025-07-05	5	Saturday	7	July	3	2025	2025-07	27	1
20250706	2025-07-06	6	Sunday	7	July	3	2025	2025-07	27	1
20250707	2025-07-07	7	Monday	7	July	3	2025	2025-07	28	0
20250708	2025-07-08	8	Tuesday	7	July	3	2025	2025-07	28	0
20250709	2025-07-09	9	Wednesday	7	July	3	2025	2025-07	28	0
20250710	2025-07-10	10	Thursday	7	July	3	2025	2025-07	28	0
20250711	2025-07-11	11	Friday	7	July	3	2025	2025-07	28	0
20250712	2025-07-12	12	Saturday	7	July	3	2025	2025-07	28	1
20250713	2025-07-13	13	Sunday	7	July	3	2025	2025-07	28	1
20250714	2025-07-14	14	Monday	7	July	3	2025	2025-07	29	0
20250715	2025-07-15	15	Tuesday	7	July	3	2025	2025-07	29	0
20250716	2025-07-16	16	Wednesday	7	July	3	2025	2025-07	29	0
20250717	2025-07-17	17	Thursday	7	July	3	2025	2025-07	29	0
20250718	2025-07-18	18	Friday	7	July	3	2025	2025-07	29	0
20250719	2025-07-19	19	Saturday	7	July	3	2025	2025-07	29	1
20250720	2025-07-20	20	Sunday	7	July	3	2025	2025-07	29	1
20250721	2025-07-21	21	Monday	7	July	3	2025	2025-07	30	0
20250722	2025-07-22	22	Tuesday	7	July	3	2025	2025-07	30	0
20250723	2025-07-23	23	Wednesday	7	July	3	2025	2025-07	30	0
20250724	2025-07-24	24	Thursday	7	July	3	2025	2025-07	30	0
20250725	2025-07-25	25	Friday	7	July	3	2025	2025-07	30	0
20250726	2025-07-26	26	Saturday	7	July	3	2025	2025-07	30	1
20250727	2025-07-27	27	Sunday	7	July	3	2025	2025-07	30	1
20250728	2025-07-28	28	Monday	7	July	3	2025	2025-07	31	0
20250729	2025-07-29	29	Tuesday	7	July	3	2025	2025-07	31	0
20250730	2025-07-30	30	Wednesday	7	July	3	2025	2025-07	31	0
20250731	2025-07-31	31	Thursday	7	July	3	2025	2025-07	31	0
20250801	2025-08-01	1	Friday	8	August	3	2025	2025-08	31	0
20250802	2025-08-02	2	Saturday	8	August	3	2025	2025-08	31	1
20250803	2025-08-03	3	Sunday	8	August	3	2025	2025-08	31	1
20250804	2025-08-04	4	Monday	8	August	3	2025	2025-08	32	0
20250805	2025-08-05	5	Tuesday	8	August	3	2025	2025-08	32	0
20250806	2025-08-06	6	Wednesday	8	August	3	2025	2025-08	32	0
20250807	2025-08-07	7	Thursday	8	August	3	2025	2025-08	32	0
20250808	2025-08-08	8	Friday	8	August	3	2025	2025-08	32	0
20250809	2025-08-09	9	Saturday	8	August	3	2025	2025-08	32	1
20250810	2025-08-10	10	Sunday	8	August	3	2025	2025-08	32	1
20250811	2025-08-11	11	Monday	8	August	3	2025	2025-08	33	0
20250812	2025-08-12	12	Tuesday	8	August	3	2025	2025-08	33	0
20250813	2025-08-13	13	Wednesday	8	August	3	2025	2025-08	33	0
20250814	2025-08-14	14	Thursday	8	August	3	2025	2025-08	33	0
20250815	2025-08-15	15	Friday	8	August	3	2025	2025-08	33	0
20250816	2025-08-16	16	Saturday	8	August	3	2025	2025-08	33	1
20250817	2025-08-17	17	Sunday	8	August	3	2025	2025-08	33	1
20250818	2025-08-18	18	Monday	8	August	3	2025	2025-08	34	0
20250819	2025-08-19	19	Tuesday	8	August	3	2025	2025-08	34	0
20250820	2025-08-20	20	Wednesday	8	August	3	2025	2025-08	34	0
20250821	2025-08-21	21	Thursday	8	August	3	2025	2025-08	34	0
20250822	2025-08-22	22	Friday	8	August	3	2025	2025-08	34	0
20250823	2025-08-23	23	Saturday	8	August	3	2025	2025-08	34	1
20250824	2025-08-24	24	Sunday	8	August	3	2025	2025-08	34	1
20250825	2025-08-25	25	Monday	8	August	3	2025	2025-08	35	0
20250826	2025-08-26	26	Tuesday	8	August	3	2025	2025-08	35	0
20250827	2025-08-27	27	Wednesday	8	August	3	2025	2025-08	35	0
20250828	2025-08-28	28	Thursday	8	August	3	2025	2025-08	35	0
20250829	2025-08-29	29	Friday	8	August	3	2025	2025-08	35	0
20250830	2025-08-30	30	Saturday	8	August	3	2025	2025-08	35	1
20250831	2025-08-31	31	Sunday	8	August	3	2025	2025-08	35	1
20250901	2025-09-01	1	Monday	9	September	3	2025	2025-09	36	0
20250902	2025-09-02	2	Tuesday	9	September	3	2025	2025-09	36	0
20250903	2025-09-03	3	Wednesday	9	September	3	2025	2025-09	36	0
20250904	2025-09-04	4	Thursday	9	September	3	2025	2025-09	36	0
20250905	2025-09-05	5	Friday	9	September	3	2025	2025-09	36	0
20250906	2025-09-06	6	Saturday	9	September	3	2025	2025-09	36	1
20250907	2025-09-07	7	Sunday	9	September	3	2025	2025-09	36	1
20250908	2025-09-08	8	Monday	9	September	3	2025	2025-09	37	0
20250909	2025-09-09	9	Tuesday	9	September	3	2025	2025-09	37	0
20250910	2025-09-10	10	Wednesday	9	September	3	2025	2025-09	37	0
20250911	2025-09-11	11	Thursday	9	September	3	2025	2025-09	37	0
20250912	2025-09-12	12	Friday	9	September	3	2025	2025-09	37	0
20250913	2025-09-13	13	Saturday	9	September	3	2025	2025-09	37	1
20250914	2025-09-14	14	Sunday	9	September	3	2025	2025-09	37	1
20250915	2025-09-15	15	Monday	9	September	3	2025	2025-09	38	0
20250916	2025-09-16	16	Tuesday	9	September	3	2025	2025-09	38	0
20250917	2025-09-17	17	Wednesday	9	September	3	2025	2025-09	38	0
20250918	2025-09-18	18	Thursday	9	September	3	2025	2025-09	38	0
20250919	2025-09-19	19	Friday	9	September	3	2025	2025-09	38	0
20250920	2025-09-20	20	Saturday	9	September	3	2025	2025-09	38	1
20250921	2025-09-21	21	Sunday	9	September	3	2025	2025-09	38	1
20250922	2025-09-22	22	Monday	9	September	3	2025	2025-09	39	0
20250923	2025-09-23	23	Tuesday	9	September	3	2025	2025-09	39	0
20250924	2025-09-24	24	Wednesday	9	September	3	2025	2025-09	39	0
20250925	2025-09-25	25	Thursday	9	September	3	2025	2025-09	39	0
20250926	2025-09-26	26	Friday	9	September	3	2025	2025-09	39	0
20250927	2025-09-27	27	Saturday	9	September	3	2025	2025-09	39	1
20250928	2025-09-28	28	Sunday	9	September	3	2025	2025-09	39	1
20250929	2025-09-29	29	Monday	9	September	3	2025	2025-09	40	0
20250930	2025-09-30	30	Tuesday	9	September	3	2025	2025-09	40	0
20251001	2025-10-01	1	Wednesday	10	October	4	2025	2025-10	40	0
20251002	2025-10-02	2	Thursday	10	October	4	2025	2025-10	40	0
20251003	2025-10-03	3	Friday	10	October	4	2025	2025-10	40	0
20251004	2025-10-04	4	Saturday	10	October	4	2025	2025-10	40	1
20251005	2025-10-05	5	Sunday	10	October	4	2025	2025-10	40	1
20251006	2025-10-06	6	Monday	10	October	4	2025	2025-10	41	0
20251007	2025-10-07	7	Tuesday	10	October	4	2025	2025-10	41	0
20251008	2025-10-08	8	Wednesday	10	October	4	2025	2025-10	41	0
20251009	2025-10-09	9	Thursday	10	October	4	2025	2025-10	41	0
20251010	2025-10-10	10	Friday	10	October	4	2025	2025-10	41	0
20251011	2025-10-11	11	Saturday	10	October	4	2025	2025-10	41	1
20251012	2025-10-12	12	Sunday	10	October	4	2025	2025-10	41	1
20251013	2025-10-13	13	Monday	10	October	4	2025	2025-10	42	0
20251014	2025-10-14	14	Tuesday	10	October	4	2025	2025-10	42	0
20251015	2025-10-15	15	Wednesday	10	October	4	2025	2025-10	42	0
20251016	2025-10-16	16	Thursday	10	October	4	2025	2025-10	42	0
20251017	2025-10-17	17	Friday	10	October	4	2025	2025-10	42	0
20251018	2025-10-18	18	Saturday	10	October	4	2025	2025-10	42	1
20251019	2025-10-19	19	Sunday	10	October	4	2025	2025-10	42	1
20251020	2025-10-20	20	Monday	10	October	4	2025	2025-10	43	0
20251021	2025-10-21	21	Tuesday	10	October	4	2025	2025-10	43	0
20251022	2025-10-22	22	Wednesday	10	October	4	2025	2025-10	43	0
20251023	2025-10-23	23	Thursday	10	October	4	2025	2025-10	43	0
20251024	2025-10-24	24	Friday	10	October	4	2025	2025-10	43	0
20251025	2025-10-25	25	Saturday	10	October	4	2025	2025-10	43	1
20251026	2025-10-26	26	Sunday	10	October	4	2025	2025-10	43	1
20251027	2025-10-27	27	Monday	10	October	4	2025	2025-10	44	0
20251028	2025-10-28	28	Tuesday	10	October	4	2025	2025-10	44	0
20251029	2025-10-29	29	Wednesday	10	October	4	2025	2025-10	44	0
20251030	2025-10-30	30	Thursday	10	October	4	2025	2025-10	44	0
20251031	2025-10-31	31	Friday	10	October	4	2025	2025-10	44	0
20251101	2025-11-01	1	Saturday	11	November	4	2025	2025-11	44	1
20251102	2025-11-02	2	Sunday	11	November	4	2025	2025-11	44	1
20251103	2025-11-03	3	Monday	11	November	4	2025	2025-11	45	0
20251104	2025-11-04	4	Tuesday	11	November	4	2025	2025-11	45	0
20251105	2025-11-05	5	Wednesday	11	November	4	2025	2025-11	45	0
20251106	2025-11-06	6	Thursday	11	November	4	2025	2025-11	45	0
20251107	2025-11-07	7	Friday	11	November	4	2025	2025-11	45	0
20251108	2025-11-08	8	Saturday	11	November	4	2025	2025-11	45	1
20251109	2025-11-09	9	Sunday	11	November	4	2025	2025-11	45	1
20251110	2025-11-10	10	Monday	11	November	4	2025	2025-11	46	0
20251111	2025-11-11	11	Tuesday	11	November	4	2025	2025-11	46	0
20251112	2025-11-12	12	Wednesday	11	November	4	2025	2025-11	46	0
20251113	2025-11-13	13	Thursday	11	November	4	2025	2025-11	46	0
20251114	2025-11-14	14	Friday	11	November	4	2025	2025-11	46	0
20251115	2025-11-15	15	Saturday	11	November	4	2025	2025-11	46	1
20251116	2025-11-16	16	Sunday	11	November	4	2025	2025-11	46	1
20251117	2025-11-17	17	Monday	11	November	4	2025	2025-11	47	0
20251118	2025-11-18	18	Tuesday	11	November	4	2025	2025-11	47	0
20251119	2025-11-19	19	Wednesday	11	November	4	2025	2025-11	47	0
20251120	2025-11-20	20	Thursday	11	November	4	2025	2025-11	47	0
20251121	2025-11-21	21	Friday	11	November	4	2025	2025-11	47	0
20251122	2025-11-22	22	Saturday	11	November	4	2025	2025-11	47	1
20251123	2025-11-23	23	Sunday	11	November	4	2025	2025-11	47	1
20251124	2025-11-24	24	Monday	11	November	4	2025	2025-11	48	0
20251125	2025-11-25	25	Tuesday	11	November	4	2025	2025-11	48	0
20251126	2025-11-26	26	Wednesday	11	November	4	2025	2025-11	48	0
20251127	2025-11-27	27	Thursday	11	November	4	2025	2025-11	48	0
20251128	2025-11-28	28	Friday	11	November	4	2025	2025-11	48	0
20251129	2025-11-29	29	Saturday	11	November	4	2025	2025-11	48	1
20251130	2025-11-30	30	Sunday	11	November	4	2025	2025-11	48	1
20251201	2025-12-01	1	Monday	12	December	4	2025	2025-12	49	0
20251202	2025-12-02	2	Tuesday	12	December	4	2025	2025-12	49	0
20251203	2025-12-03	3	Wednesday	12	December	4	2025	2025-12	49	0
20251204	2025-12-04	4	Thursday	12	December	4	2025	2025-12	49	0
20251205	2025-12-05	5	Friday	12	December	4	2025	2025-12	49	0
20251206	2025-12-06	6	Saturday	12	December	4	2025	2025-12	49	1
20251207	2025-12-07	7	Sunday	12	December	4	2025	2025-12	49	1
20251208	2025-12-08	8	Monday	12	December	4	2025	2025-12	50	0
20251209	2025-12-09	9	Tuesday	12	December	4	2025	2025-12	50	0
20251210	2025-12-10	10	Wednesday	12	December	4	2025	2025-12	50	0
20251211	2025-12-11	11	Thursday	12	December	4	2025	2025-12	50	0
20251212	2025-12-12	12	Friday	12	December	4	2025	2025-12	50	0
20251213	2025-12-13	13	Saturday	12	December	4	2025	2025-12	50	1
20251214	2025-12-14	14	Sunday	12	December	4	2025	2025-12	50	1
20251215	2025-12-15	15	Monday	12	December	4	2025	2025-12	51	0
20251216	2025-12-16	16	Tuesday	12	December	4	2025	2025-12	51	0
20251217	2025-12-17	17	Wednesday	12	December	4	2025	2025-12	51	0
20251218	2025-12-18	18	Thursday	12	December	4	2025	2025-12	51	0
20251219	2025-12-19	19	Friday	12	December	4	2025	2025-12	51	0
20251220	2025-12-20	20	Saturday	12	December	4	2025	2025-12	51	1
20251221	2025-12-21	21	Sunday	12	December	4	2025	2025-12	51	1
20251222	2025-12-22	22	Monday	12	December	4	2025	2025-12	52	0
20251223	2025-12-23	23	Tuesday	12	December	4	2025	2025-12	52	0
20251224	2025-12-24	24	Wednesday	12	December	4	2025	2025-12	52	0
20251225	2025-12-25	25	Thursday	12	December	4	2025	2025-12	52	0
20251226	2025-12-26	26	Friday	12	December	4	2025	2025-12	52	0
20251227	2025-12-27	27	Saturday	12	December	4	2025	2025-12	52	1
20251228	2025-12-28	28	Sunday	12	December	4	2025	2025-12	52	1
20251229	2025-12-29	29	Monday	12	December	4	2025	2025-12	1	0
20251230	2025-12-30	30	Tuesday	12	December	4	2025	2025-12	1	0
20251231	2025-12-31	31	Wednesday	12	December	4	2025	2025-12	1	0
20260101	2026-01-01	1	Thursday	1	January	1	2026	2026-01	1	0
20260102	2026-01-02	2	Friday	1	January	1	2026	2026-01	1	0
20260103	2026-01-03	3	Saturday	1	January	1	2026	2026-01	1	1
20260104	2026-01-04	4	Sunday	1	January	1	2026	2026-01	1	1
20260105	2026-01-05	5	Monday	1	January	1	2026	2026-01	2	0
20260106	2026-01-06	6	Tuesday	1	January	1	2026	2026-01	2	0
20260107	2026-01-07	7	Wednesday	1	January	1	2026	2026-01	2	0
20260108	2026-01-08	8	Thursday	1	January	1	2026	2026-01	2	0
20260109	2026-01-09	9	Friday	1	January	1	2026	2026-01	2	0
20260110	2026-01-10	10	Saturday	1	January	1	2026	2026-01	2	1
20260111	2026-01-11	11	Sunday	1	January	1	2026	2026-01	2	1
20260112	2026-01-12	12	Monday	1	January	1	2026	2026-01	3	0
20260113	2026-01-13	13	Tuesday	1	January	1	2026	2026-01	3	0
20260114	2026-01-14	14	Wednesday	1	January	1	2026	2026-01	3	0
20260115	2026-01-15	15	Thursday	1	January	1	2026	2026-01	3	0
20260116	2026-01-16	16	Friday	1	January	1	2026	2026-01	3	0
20260117	2026-01-17	17	Saturday	1	January	1	2026	2026-01	3	1
20260118	2026-01-18	18	Sunday	1	January	1	2026	2026-01	3	1
20260119	2026-01-19	19	Monday	1	January	1	2026	2026-01	4	0
20260120	2026-01-20	20	Tuesday	1	January	1	2026	2026-01	4	0
20260121	2026-01-21	21	Wednesday	1	January	1	2026	2026-01	4	0
20260122	2026-01-22	22	Thursday	1	January	1	2026	2026-01	4	0
20260123	2026-01-23	23	Friday	1	January	1	2026	2026-01	4	0
20260124	2026-01-24	24	Saturday	1	January	1	2026	2026-01	4	1
20260125	2026-01-25	25	Sunday	1	January	1	2026	2026-01	4	1
20260126	2026-01-26	26	Monday	1	January	1	2026	2026-01	5	0
20260127	2026-01-27	27	Tuesday	1	January	1	2026	2026-01	5	0
20260128	2026-01-28	28	Wednesday	1	January	1	2026	2026-01	5	0
20260129	2026-01-29	29	Thursday	1	January	1	2026	2026-01	5	0
20260130	2026-01-30	30	Friday	1	January	1	2026	2026-01	5	0
20260131	2026-01-31	31	Saturday	1	January	1	2026	2026-01	5	1
20260201	2026-02-01	1	Sunday	2	February	1	2026	2026-02	5	1
20260202	2026-02-02	2	Monday	2	February	1	2026	2026-02	6	0
20260203	2026-02-03	3	Tuesday	2	February	1	2026	2026-02	6	0
20260204	2026-02-04	4	Wednesday	2	February	1	2026	2026-02	6	0
20260205	2026-02-05	5	Thursday	2	February	1	2026	2026-02	6	0
20260206	2026-02-06	6	Friday	2	February	1	2026	2026-02	6	0
20260207	2026-02-07	7	Saturday	2	February	1	2026	2026-02	6	1
20260208	2026-02-08	8	Sunday	2	February	1	2026	2026-02	6	1
20260209	2026-02-09	9	Monday	2	February	1	2026	2026-02	7	0
20260210	2026-02-10	10	Tuesday	2	February	1	2026	2026-02	7	0
20260211	2026-02-11	11	Wednesday	2	February	1	2026	2026-02	7	0
20260212	2026-02-12	12	Thursday	2	February	1	2026	2026-02	7	0
20260213	2026-02-13	13	Friday	2	February	1	2026	2026-02	7	0
20260214	2026-02-14	14	Saturday	2	February	1	2026	2026-02	7	1
20260215	2026-02-15	15	Sunday	2	February	1	2026	2026-02	7	1
20260216	2026-02-16	16	Monday	2	February	1	2026	2026-02	8	0
20260217	2026-02-17	17	Tuesday	2	February	1	2026	2026-02	8	0
20260218	2026-02-18	18	Wednesday	2	February	1	2026	2026-02	8	0
20260219	2026-02-19	19	Thursday	2	February	1	2026	2026-02	8	0
20260220	2026-02-20	20	Friday	2	February	1	2026	2026-02	8	0
20260221	2026-02-21	21	Saturday	2	February	1	2026	2026-02	8	1
20260222	2026-02-22	22	Sunday	2	February	1	2026	2026-02	8	1
20260223	2026-02-23	23	Monday	2	February	1	2026	2026-02	9	0
20260224	2026-02-24	24	Tuesday	2	February	1	2026	2026-02	9	0
20260225	2026-02-25	25	Wednesday	2	February	1	2026	2026-02	9	0
20260226	2026-02-26	26	Thursday	2	February	1	2026	2026-02	9	0
20260227	2026-02-27	27	Friday	2	February	1	2026	2026-02	9	0
20260228	2026-02-28	28	Saturday	2	February	1	2026	2026-02	9	1
20260301	2026-03-01	1	Sunday	3	March	1	2026	2026-03	9	1
20260302	2026-03-02	2	Monday	3	March	1	2026	2026-03	10	0
20260303	2026-03-03	3	Tuesday	3	March	1	2026	2026-03	10	0
20260304	2026-03-04	4	Wednesday	3	March	1	2026	2026-03	10	0
20260305	2026-03-05	5	Thursday	3	March	1	2026	2026-03	10	0
20260306	2026-03-06	6	Friday	3	March	1	2026	2026-03	10	0
20260307	2026-03-07	7	Saturday	3	March	1	2026	2026-03	10	1
20260308	2026-03-08	8	Sunday	3	March	1	2026	2026-03	10	1
20260309	2026-03-09	9	Monday	3	March	1	2026	2026-03	11	0
20260310	2026-03-10	10	Tuesday	3	March	1	2026	2026-03	11	0
20260311	2026-03-11	11	Wednesday	3	March	1	2026	2026-03	11	0
20260312	2026-03-12	12	Thursday	3	March	1	2026	2026-03	11	0
20260313	2026-03-13	13	Friday	3	March	1	2026	2026-03	11	0
20260314	2026-03-14	14	Saturday	3	March	1	2026	2026-03	11	1
20260315	2026-03-15	15	Sunday	3	March	1	2026	2026-03	11	1
20260316	2026-03-16	16	Monday	3	March	1	2026	2026-03	12	0
20260317	2026-03-17	17	Tuesday	3	March	1	2026	2026-03	12	0
20260318	2026-03-18	18	Wednesday	3	March	1	2026	2026-03	12	0
20260319	2026-03-19	19	Thursday	3	March	1	2026	2026-03	12	0
20260320	2026-03-20	20	Friday	3	March	1	2026	2026-03	12	0
20260321	2026-03-21	21	Saturday	3	March	1	2026	2026-03	12	1
20260322	2026-03-22	22	Sunday	3	March	1	2026	2026-03	12	1
20260323	2026-03-23	23	Monday	3	March	1	2026	2026-03	13	0
20260324	2026-03-24	24	Tuesday	3	March	1	2026	2026-03	13	0
20260325	2026-03-25	25	Wednesday	3	March	1	2026	2026-03	13	0
20260326	2026-03-26	26	Thursday	3	March	1	2026	2026-03	13	0
20260327	2026-03-27	27	Friday	3	March	1	2026	2026-03	13	0
20260328	2026-03-28	28	Saturday	3	March	1	2026	2026-03	13	1
20260329	2026-03-29	29	Sunday	3	March	1	2026	2026-03	13	1
20260330	2026-03-30	30	Monday	3	March	1	2026	2026-03	14	0
20260331	2026-03-31	31	Tuesday	3	March	1	2026	2026-03	14	0
20260401	2026-04-01	1	Wednesday	4	April	2	2026	2026-04	14	0
20260402	2026-04-02	2	Thursday	4	April	2	2026	2026-04	14	0
20260403	2026-04-03	3	Friday	4	April	2	2026	2026-04	14	0
20260404	2026-04-04	4	Saturday	4	April	2	2026	2026-04	14	1
20260405	2026-04-05	5	Sunday	4	April	2	2026	2026-04	14	1
20260406	2026-04-06	6	Monday	4	April	2	2026	2026-04	15	0
20260407	2026-04-07	7	Tuesday	4	April	2	2026	2026-04	15	0
20260408	2026-04-08	8	Wednesday	4	April	2	2026	2026-04	15	0
20260409	2026-04-09	9	Thursday	4	April	2	2026	2026-04	15	0
20260410	2026-04-10	10	Friday	4	April	2	2026	2026-04	15	0
20260411	2026-04-11	11	Saturday	4	April	2	2026	2026-04	15	1
20260412	2026-04-12	12	Sunday	4	April	2	2026	2026-04	15	1
20260413	2026-04-13	13	Monday	4	April	2	2026	2026-04	16	0
20260414	2026-04-14	14	Tuesday	4	April	2	2026	2026-04	16	0
20260415	2026-04-15	15	Wednesday	4	April	2	2026	2026-04	16	0
20260416	2026-04-16	16	Thursday	4	April	2	2026	2026-04	16	0
20260417	2026-04-17	17	Friday	4	April	2	2026	2026-04	16	0
20260418	2026-04-18	18	Saturday	4	April	2	2026	2026-04	16	1
20260419	2026-04-19	19	Sunday	4	April	2	2026	2026-04	16	1
20260420	2026-04-20	20	Monday	4	April	2	2026	2026-04	17	0
20260421	2026-04-21	21	Tuesday	4	April	2	2026	2026-04	17	0
20260422	2026-04-22	22	Wednesday	4	April	2	2026	2026-04	17	0
20260423	2026-04-23	23	Thursday	4	April	2	2026	2026-04	17	0
20260424	2026-04-24	24	Friday	4	April	2	2026	2026-04	17	0
20260425	2026-04-25	25	Saturday	4	April	2	2026	2026-04	17	1
20260426	2026-04-26	26	Sunday	4	April	2	2026	2026-04	17	1
20260427	2026-04-27	27	Monday	4	April	2	2026	2026-04	18	0
20260428	2026-04-28	28	Tuesday	4	April	2	2026	2026-04	18	0
20260429	2026-04-29	29	Wednesday	4	April	2	2026	2026-04	18	0
20260430	2026-04-30	30	Thursday	4	April	2	2026	2026-04	18	0
20260501	2026-05-01	1	Friday	5	May	2	2026	2026-05	18	0
20260502	2026-05-02	2	Saturday	5	May	2	2026	2026-05	18	1
20260503	2026-05-03	3	Sunday	5	May	2	2026	2026-05	18	1
20260504	2026-05-04	4	Monday	5	May	2	2026	2026-05	19	0
20260505	2026-05-05	5	Tuesday	5	May	2	2026	2026-05	19	0
20260506	2026-05-06	6	Wednesday	5	May	2	2026	2026-05	19	0
20260507	2026-05-07	7	Thursday	5	May	2	2026	2026-05	19	0
20260508	2026-05-08	8	Friday	5	May	2	2026	2026-05	19	0
20260509	2026-05-09	9	Saturday	5	May	2	2026	2026-05	19	1
20260510	2026-05-10	10	Sunday	5	May	2	2026	2026-05	19	1
20260511	2026-05-11	11	Monday	5	May	2	2026	2026-05	20	0
20260512	2026-05-12	12	Tuesday	5	May	2	2026	2026-05	20	0
20260513	2026-05-13	13	Wednesday	5	May	2	2026	2026-05	20	0
20260514	2026-05-14	14	Thursday	5	May	2	2026	2026-05	20	0
20260515	2026-05-15	15	Friday	5	May	2	2026	2026-05	20	0
20260516	2026-05-16	16	Saturday	5	May	2	2026	2026-05	20	1
20260517	2026-05-17	17	Sunday	5	May	2	2026	2026-05	20	1
20260518	2026-05-18	18	Monday	5	May	2	2026	2026-05	21	0
20260519	2026-05-19	19	Tuesday	5	May	2	2026	2026-05	21	0
20260520	2026-05-20	20	Wednesday	5	May	2	2026	2026-05	21	0
20260521	2026-05-21	21	Thursday	5	May	2	2026	2026-05	21	0
20260522	2026-05-22	22	Friday	5	May	2	2026	2026-05	21	0
20260523	2026-05-23	23	Saturday	5	May	2	2026	2026-05	21	1
20260524	2026-05-24	24	Sunday	5	May	2	2026	2026-05	21	1
20260525	2026-05-25	25	Monday	5	May	2	2026	2026-05	22	0
20260526	2026-05-26	26	Tuesday	5	May	2	2026	2026-05	22	0
20260527	2026-05-27	27	Wednesday	5	May	2	2026	2026-05	22	0
20260528	2026-05-28	28	Thursday	5	May	2	2026	2026-05	22	0
20260529	2026-05-29	29	Friday	5	May	2	2026	2026-05	22	0
20260530	2026-05-30	30	Saturday	5	May	2	2026	2026-05	22	1
20260531	2026-05-31	31	Sunday	5	May	2	2026	2026-05	22	1
20260601	2026-06-01	1	Monday	6	June	2	2026	2026-06	23	0
20260602	2026-06-02	2	Tuesday	6	June	2	2026	2026-06	23	0
20260603	2026-06-03	3	Wednesday	6	June	2	2026	2026-06	23	0
20260604	2026-06-04	4	Thursday	6	June	2	2026	2026-06	23	0
20260605	2026-06-05	5	Friday	6	June	2	2026	2026-06	23	0
20260606	2026-06-06	6	Saturday	6	June	2	2026	2026-06	23	1
20260607	2026-06-07	7	Sunday	6	June	2	2026	2026-06	23	1
20260608	2026-06-08	8	Monday	6	June	2	2026	2026-06	24	0
20260609	2026-06-09	9	Tuesday	6	June	2	2026	2026-06	24	0
20260610	2026-06-10	10	Wednesday	6	June	2	2026	2026-06	24	0
20260611	2026-06-11	11	Thursday	6	June	2	2026	2026-06	24	0
20260612	2026-06-12	12	Friday	6	June	2	2026	2026-06	24	0
20260613	2026-06-13	13	Saturday	6	June	2	2026	2026-06	24	1
20260614	2026-06-14	14	Sunday	6	June	2	2026	2026-06	24	1
20260615	2026-06-15	15	Monday	6	June	2	2026	2026-06	25	0
20260616	2026-06-16	16	Tuesday	6	June	2	2026	2026-06	25	0
20260617	2026-06-17	17	Wednesday	6	June	2	2026	2026-06	25	0
20260618	2026-06-18	18	Thursday	6	June	2	2026	2026-06	25	0
20260619	2026-06-19	19	Friday	6	June	2	2026	2026-06	25	0
20260620	2026-06-20	20	Saturday	6	June	2	2026	2026-06	25	1
20260621	2026-06-21	21	Sunday	6	June	2	2026	2026-06	25	1
20260622	2026-06-22	22	Monday	6	June	2	2026	2026-06	26	0
20260623	2026-06-23	23	Tuesday	6	June	2	2026	2026-06	26	0
20260624	2026-06-24	24	Wednesday	6	June	2	2026	2026-06	26	0
20260625	2026-06-25	25	Thursday	6	June	2	2026	2026-06	26	0
20260626	2026-06-26	26	Friday	6	June	2	2026	2026-06	26	0
20260627	2026-06-27	27	Saturday	6	June	2	2026	2026-06	26	1
20260628	2026-06-28	28	Sunday	6	June	2	2026	2026-06	26	1
20260629	2026-06-29	29	Monday	6	June	2	2026	2026-06	27	0
20260630	2026-06-30	30	Tuesday	6	June	2	2026	2026-06	27	0
20260701	2026-07-01	1	Wednesday	7	July	3	2026	2026-07	27	0
20260702	2026-07-02	2	Thursday	7	July	3	2026	2026-07	27	0
20260703	2026-07-03	3	Friday	7	July	3	2026	2026-07	27	0
20260704	2026-07-04	4	Saturday	7	July	3	2026	2026-07	27	1
20260705	2026-07-05	5	Sunday	7	July	3	2026	2026-07	27	1
20260706	2026-07-06	6	Monday	7	July	3	2026	2026-07	28	0
20260707	2026-07-07	7	Tuesday	7	July	3	2026	2026-07	28	0
20260708	2026-07-08	8	Wednesday	7	July	3	2026	2026-07	28	0
20260709	2026-07-09	9	Thursday	7	July	3	2026	2026-07	28	0
20260710	2026-07-10	10	Friday	7	July	3	2026	2026-07	28	0
20260711	2026-07-11	11	Saturday	7	July	3	2026	2026-07	28	1
20260712	2026-07-12	12	Sunday	7	July	3	2026	2026-07	28	1
20260713	2026-07-13	13	Monday	7	July	3	2026	2026-07	29	0
20260714	2026-07-14	14	Tuesday	7	July	3	2026	2026-07	29	0
20260715	2026-07-15	15	Wednesday	7	July	3	2026	2026-07	29	0
20260716	2026-07-16	16	Thursday	7	July	3	2026	2026-07	29	0
20260717	2026-07-17	17	Friday	7	July	3	2026	2026-07	29	0
20260718	2026-07-18	18	Saturday	7	July	3	2026	2026-07	29	1
20260719	2026-07-19	19	Sunday	7	July	3	2026	2026-07	29	1
20260720	2026-07-20	20	Monday	7	July	3	2026	2026-07	30	0
20260721	2026-07-21	21	Tuesday	7	July	3	2026	2026-07	30	0
20260722	2026-07-22	22	Wednesday	7	July	3	2026	2026-07	30	0
20260723	2026-07-23	23	Thursday	7	July	3	2026	2026-07	30	0
20260724	2026-07-24	24	Friday	7	July	3	2026	2026-07	30	0
20260725	2026-07-25	25	Saturday	7	July	3	2026	2026-07	30	1
20260726	2026-07-26	26	Sunday	7	July	3	2026	2026-07	30	1
20260727	2026-07-27	27	Monday	7	July	3	2026	2026-07	31	0
20260728	2026-07-28	28	Tuesday	7	July	3	2026	2026-07	31	0
20260729	2026-07-29	29	Wednesday	7	July	3	2026	2026-07	31	0
20260730	2026-07-30	30	Thursday	7	July	3	2026	2026-07	31	0
20260731	2026-07-31	31	Friday	7	July	3	2026	2026-07	31	0
20260801	2026-08-01	1	Saturday	8	August	3	2026	2026-08	31	1
20260802	2026-08-02	2	Sunday	8	August	3	2026	2026-08	31	1
20260803	2026-08-03	3	Monday	8	August	3	2026	2026-08	32	0
20260804	2026-08-04	4	Tuesday	8	August	3	2026	2026-08	32	0
20260805	2026-08-05	5	Wednesday	8	August	3	2026	2026-08	32	0
20260806	2026-08-06	6	Thursday	8	August	3	2026	2026-08	32	0
20260807	2026-08-07	7	Friday	8	August	3	2026	2026-08	32	0
20260808	2026-08-08	8	Saturday	8	August	3	2026	2026-08	32	1
20260809	2026-08-09	9	Sunday	8	August	3	2026	2026-08	32	1
20260810	2026-08-10	10	Monday	8	August	3	2026	2026-08	33	0
20260811	2026-08-11	11	Tuesday	8	August	3	2026	2026-08	33	0
20260812	2026-08-12	12	Wednesday	8	August	3	2026	2026-08	33	0
20260813	2026-08-13	13	Thursday	8	August	3	2026	2026-08	33	0
20260814	2026-08-14	14	Friday	8	August	3	2026	2026-08	33	0
20260815	2026-08-15	15	Saturday	8	August	3	2026	2026-08	33	1
20260816	2026-08-16	16	Sunday	8	August	3	2026	2026-08	33	1
20260817	2026-08-17	17	Monday	8	August	3	2026	2026-08	34	0
20260818	2026-08-18	18	Tuesday	8	August	3	2026	2026-08	34	0
20260819	2026-08-19	19	Wednesday	8	August	3	2026	2026-08	34	0
20260820	2026-08-20	20	Thursday	8	August	3	2026	2026-08	34	0
20260821	2026-08-21	21	Friday	8	August	3	2026	2026-08	34	0
20260822	2026-08-22	22	Saturday	8	August	3	2026	2026-08	34	1
20260823	2026-08-23	23	Sunday	8	August	3	2026	2026-08	34	1
20260824	2026-08-24	24	Monday	8	August	3	2026	2026-08	35	0
20260825	2026-08-25	25	Tuesday	8	August	3	2026	2026-08	35	0
20260826	2026-08-26	26	Wednesday	8	August	3	2026	2026-08	35	0
20260827	2026-08-27	27	Thursday	8	August	3	2026	2026-08	35	0
20260828	2026-08-28	28	Friday	8	August	3	2026	2026-08	35	0
20260829	2026-08-29	29	Saturday	8	August	3	2026	2026-08	35	1
20260830	2026-08-30	30	Sunday	8	August	3	2026	2026-08	35	1
20260831	2026-08-31	31	Monday	8	August	3	2026	2026-08	36	0
20260901	2026-09-01	1	Tuesday	9	September	3	2026	2026-09	36	0
20260902	2026-09-02	2	Wednesday	9	September	3	2026	2026-09	36	0
20260903	2026-09-03	3	Thursday	9	September	3	2026	2026-09	36	0
20260904	2026-09-04	4	Friday	9	September	3	2026	2026-09	36	0
20260905	2026-09-05	5	Saturday	9	September	3	2026	2026-09	36	1
20260906	2026-09-06	6	Sunday	9	September	3	2026	2026-09	36	1
20260907	2026-09-07	7	Monday	9	September	3	2026	2026-09	37	0
20260908	2026-09-08	8	Tuesday	9	September	3	2026	2026-09	37	0
20260909	2026-09-09	9	Wednesday	9	September	3	2026	2026-09	37	0
20260910	2026-09-10	10	Thursday	9	September	3	2026	2026-09	37	0
20260911	2026-09-11	11	Friday	9	September	3	2026	2026-09	37	0
20260912	2026-09-12	12	Saturday	9	September	3	2026	2026-09	37	1
20260913	2026-09-13	13	Sunday	9	September	3	2026	2026-09	37	1
20260914	2026-09-14	14	Monday	9	September	3	2026	2026-09	38	0
20260915	2026-09-15	15	Tuesday	9	September	3	2026	2026-09	38	0
20260916	2026-09-16	16	Wednesday	9	September	3	2026	2026-09	38	0
20260917	2026-09-17	17	Thursday	9	September	3	2026	2026-09	38	0
20260918	2026-09-18	18	Friday	9	September	3	2026	2026-09	38	0
20260919	2026-09-19	19	Saturday	9	September	3	2026	2026-09	38	1
20260920	2026-09-20	20	Sunday	9	September	3	2026	2026-09	38	1
20260921	2026-09-21	21	Monday	9	September	3	2026	2026-09	39	0
20260922	2026-09-22	22	Tuesday	9	September	3	2026	2026-09	39	0
20260923	2026-09-23	23	Wednesday	9	September	3	2026	2026-09	39	0
20260924	2026-09-24	24	Thursday	9	September	3	2026	2026-09	39	0
20260925	2026-09-25	25	Friday	9	September	3	2026	2026-09	39	0
20260926	2026-09-26	26	Saturday	9	September	3	2026	2026-09	39	1
20260927	2026-09-27	27	Sunday	9	September	3	2026	2026-09	39	1
20260928	2026-09-28	28	Monday	9	September	3	2026	2026-09	40	0
20260929	2026-09-29	29	Tuesday	9	September	3	2026	2026-09	40	0
20260930	2026-09-30	30	Wednesday	9	September	3	2026	2026-09	40	0
20261001	2026-10-01	1	Thursday	10	October	4	2026	2026-10	40	0
20261002	2026-10-02	2	Friday	10	October	4	2026	2026-10	40	0
20261003	2026-10-03	3	Saturday	10	October	4	2026	2026-10	40	1
20261004	2026-10-04	4	Sunday	10	October	4	2026	2026-10	40	1
20261005	2026-10-05	5	Monday	10	October	4	2026	2026-10	41	0
20261006	2026-10-06	6	Tuesday	10	October	4	2026	2026-10	41	0
20261007	2026-10-07	7	Wednesday	10	October	4	2026	2026-10	41	0
20261008	2026-10-08	8	Thursday	10	October	4	2026	2026-10	41	0
20261009	2026-10-09	9	Friday	10	October	4	2026	2026-10	41	0
20261010	2026-10-10	10	Saturday	10	October	4	2026	2026-10	41	1
20261011	2026-10-11	11	Sunday	10	October	4	2026	2026-10	41	1
20261012	2026-10-12	12	Monday	10	October	4	2026	2026-10	42	0
20261013	2026-10-13	13	Tuesday	10	October	4	2026	2026-10	42	0
20261014	2026-10-14	14	Wednesday	10	October	4	2026	2026-10	42	0
20261015	2026-10-15	15	Thursday	10	October	4	2026	2026-10	42	0
20261016	2026-10-16	16	Friday	10	October	4	2026	2026-10	42	0
20261017	2026-10-17	17	Saturday	10	October	4	2026	2026-10	42	1
20261018	2026-10-18	18	Sunday	10	October	4	2026	2026-10	42	1
20261019	2026-10-19	19	Monday	10	October	4	2026	2026-10	43	0
20261020	2026-10-20	20	Tuesday	10	October	4	2026	2026-10	43	0
20261021	2026-10-21	21	Wednesday	10	October	4	2026	2026-10	43	0
20261022	2026-10-22	22	Thursday	10	October	4	2026	2026-10	43	0
20261023	2026-10-23	23	Friday	10	October	4	2026	2026-10	43	0
20261024	2026-10-24	24	Saturday	10	October	4	2026	2026-10	43	1
20261025	2026-10-25	25	Sunday	10	October	4	2026	2026-10	43	1
20261026	2026-10-26	26	Monday	10	October	4	2026	2026-10	44	0
20261027	2026-10-27	27	Tuesday	10	October	4	2026	2026-10	44	0
20261028	2026-10-28	28	Wednesday	10	October	4	2026	2026-10	44	0
20261029	2026-10-29	29	Thursday	10	October	4	2026	2026-10	44	0
20261030	2026-10-30	30	Friday	10	October	4	2026	2026-10	44	0
20261031	2026-10-31	31	Saturday	10	October	4	2026	2026-10	44	1
20261101	2026-11-01	1	Sunday	11	November	4	2026	2026-11	44	1
20261102	2026-11-02	2	Monday	11	November	4	2026	2026-11	45	0
20261103	2026-11-03	3	Tuesday	11	November	4	2026	2026-11	45	0
20261104	2026-11-04	4	Wednesday	11	November	4	2026	2026-11	45	0
20261105	2026-11-05	5	Thursday	11	November	4	2026	2026-11	45	0
20261106	2026-11-06	6	Friday	11	November	4	2026	2026-11	45	0
20261107	2026-11-07	7	Saturday	11	November	4	2026	2026-11	45	1
20261108	2026-11-08	8	Sunday	11	November	4	2026	2026-11	45	1
20261109	2026-11-09	9	Monday	11	November	4	2026	2026-11	46	0
20261110	2026-11-10	10	Tuesday	11	November	4	2026	2026-11	46	0
20261111	2026-11-11	11	Wednesday	11	November	4	2026	2026-11	46	0
20261112	2026-11-12	12	Thursday	11	November	4	2026	2026-11	46	0
20261113	2026-11-13	13	Friday	11	November	4	2026	2026-11	46	0
20261114	2026-11-14	14	Saturday	11	November	4	2026	2026-11	46	1
20261115	2026-11-15	15	Sunday	11	November	4	2026	2026-11	46	1
20261116	2026-11-16	16	Monday	11	November	4	2026	2026-11	47	0
20261117	2026-11-17	17	Tuesday	11	November	4	2026	2026-11	47	0
20261118	2026-11-18	18	Wednesday	11	November	4	2026	2026-11	47	0
20261119	2026-11-19	19	Thursday	11	November	4	2026	2026-11	47	0
20261120	2026-11-20	20	Friday	11	November	4	2026	2026-11	47	0
20261121	2026-11-21	21	Saturday	11	November	4	2026	2026-11	47	1
20261122	2026-11-22	22	Sunday	11	November	4	2026	2026-11	47	1
20261123	2026-11-23	23	Monday	11	November	4	2026	2026-11	48	0
20261124	2026-11-24	24	Tuesday	11	November	4	2026	2026-11	48	0
20261125	2026-11-25	25	Wednesday	11	November	4	2026	2026-11	48	0
20261126	2026-11-26	26	Thursday	11	November	4	2026	2026-11	48	0
20261127	2026-11-27	27	Friday	11	November	4	2026	2026-11	48	0
20261128	2026-11-28	28	Saturday	11	November	4	2026	2026-11	48	1
20261129	2026-11-29	29	Sunday	11	November	4	2026	2026-11	48	1
20261130	2026-11-30	30	Monday	11	November	4	2026	2026-11	49	0
20261201	2026-12-01	1	Tuesday	12	December	4	2026	2026-12	49	0
20261202	2026-12-02	2	Wednesday	12	December	4	2026	2026-12	49	0
20261203	2026-12-03	3	Thursday	12	December	4	2026	2026-12	49	0
20261204	2026-12-04	4	Friday	12	December	4	2026	2026-12	49	0
20261205	2026-12-05	5	Saturday	12	December	4	2026	2026-12	49	1
20261206	2026-12-06	6	Sunday	12	December	4	2026	2026-12	49	1
20261207	2026-12-07	7	Monday	12	December	4	2026	2026-12	50	0
20261208	2026-12-08	8	Tuesday	12	December	4	2026	2026-12	50	0
20261209	2026-12-09	9	Wednesday	12	December	4	2026	2026-12	50	0
20261210	2026-12-10	10	Thursday	12	December	4	2026	2026-12	50	0
20261211	2026-12-11	11	Friday	12	December	4	2026	2026-12	50	0
20261212	2026-12-12	12	Saturday	12	December	4	2026	2026-12	50	1
20261213	2026-12-13	13	Sunday	12	December	4	2026	2026-12	50	1
20261214	2026-12-14	14	Monday	12	December	4	2026	2026-12	51	0
20261215	2026-12-15	15	Tuesday	12	December	4	2026	2026-12	51	0
20261216	2026-12-16	16	Wednesday	12	December	4	2026	2026-12	51	0
20261217	2026-12-17	17	Thursday	12	December	4	2026	2026-12	51	0
20261218	2026-12-18	18	Friday	12	December	4	2026	2026-12	51	0
20261219	2026-12-19	19	Saturday	12	December	4	2026	2026-12	51	1
20261220	2026-12-20	20	Sunday	12	December	4	2026	2026-12	51	1
20261221	2026-12-21	21	Monday	12	December	4	2026	2026-12	52	0
20261222	2026-12-22	22	Tuesday	12	December	4	2026	2026-12	52	0
20261223	2026-12-23	23	Wednesday	12	December	4	2026	2026-12	52	0
20261224	2026-12-24	24	Thursday	12	December	4	2026	2026-12	52	0
20261225	2026-12-25	25	Friday	12	December	4	2026	2026-12	52	0
20261226	2026-12-26	26	Saturday	12	December	4	2026	2026-12	52	1
20261227	2026-12-27	27	Sunday	12	December	4	2026	2026-12	52	1
20261228	2026-12-28	28	Monday	12	December	4	2026	2026-12	53	0
20261229	2026-12-29	29	Tuesday	12	December	4	2026	2026-12	53	0
20261230	2026-12-30	30	Wednesday	12	December	4	2026	2026-12	53	0
20261231	2026-12-31	31	Thursday	12	December	4	2026	2026-12	53	0
20270101	2027-01-01	1	Friday	1	January	1	2027	2027-01	53	0
20270102	2027-01-02	2	Saturday	1	January	1	2027	2027-01	53	1
20270103	2027-01-03	3	Sunday	1	January	1	2027	2027-01	53	1
20270104	2027-01-04	4	Monday	1	January	1	2027	2027-01	1	0
20270105	2027-01-05	5	Tuesday	1	January	1	2027	2027-01	1	0
20270106	2027-01-06	6	Wednesday	1	January	1	2027	2027-01	1	0
20270107	2027-01-07	7	Thursday	1	January	1	2027	2027-01	1	0
20270108	2027-01-08	8	Friday	1	January	1	2027	2027-01	1	0
20270109	2027-01-09	9	Saturday	1	January	1	2027	2027-01	1	1
20270110	2027-01-10	10	Sunday	1	January	1	2027	2027-01	1	1
20270111	2027-01-11	11	Monday	1	January	1	2027	2027-01	2	0
20270112	2027-01-12	12	Tuesday	1	January	1	2027	2027-01	2	0
20270113	2027-01-13	13	Wednesday	1	January	1	2027	2027-01	2	0
20270114	2027-01-14	14	Thursday	1	January	1	2027	2027-01	2	0
20270115	2027-01-15	15	Friday	1	January	1	2027	2027-01	2	0
20270116	2027-01-16	16	Saturday	1	January	1	2027	2027-01	2	1
20270117	2027-01-17	17	Sunday	1	January	1	2027	2027-01	2	1
20270118	2027-01-18	18	Monday	1	January	1	2027	2027-01	3	0
20270119	2027-01-19	19	Tuesday	1	January	1	2027	2027-01	3	0
20270120	2027-01-20	20	Wednesday	1	January	1	2027	2027-01	3	0
20270121	2027-01-21	21	Thursday	1	January	1	2027	2027-01	3	0
20270122	2027-01-22	22	Friday	1	January	1	2027	2027-01	3	0
20270123	2027-01-23	23	Saturday	1	January	1	2027	2027-01	3	1
20270124	2027-01-24	24	Sunday	1	January	1	2027	2027-01	3	1
20270125	2027-01-25	25	Monday	1	January	1	2027	2027-01	4	0
20270126	2027-01-26	26	Tuesday	1	January	1	2027	2027-01	4	0
20270127	2027-01-27	27	Wednesday	1	January	1	2027	2027-01	4	0
20270128	2027-01-28	28	Thursday	1	January	1	2027	2027-01	4	0
20270129	2027-01-29	29	Friday	1	January	1	2027	2027-01	4	0
20270130	2027-01-30	30	Saturday	1	January	1	2027	2027-01	4	1
20270131	2027-01-31	31	Sunday	1	January	1	2027	2027-01	4	1
20270201	2027-02-01	1	Monday	2	February	1	2027	2027-02	5	0
20270202	2027-02-02	2	Tuesday	2	February	1	2027	2027-02	5	0
20270203	2027-02-03	3	Wednesday	2	February	1	2027	2027-02	5	0
20270204	2027-02-04	4	Thursday	2	February	1	2027	2027-02	5	0
20270205	2027-02-05	5	Friday	2	February	1	2027	2027-02	5	0
20270206	2027-02-06	6	Saturday	2	February	1	2027	2027-02	5	1
20270207	2027-02-07	7	Sunday	2	February	1	2027	2027-02	5	1
20270208	2027-02-08	8	Monday	2	February	1	2027	2027-02	6	0
20270209	2027-02-09	9	Tuesday	2	February	1	2027	2027-02	6	0
20270210	2027-02-10	10	Wednesday	2	February	1	2027	2027-02	6	0
20270211	2027-02-11	11	Thursday	2	February	1	2027	2027-02	6	0
20270212	2027-02-12	12	Friday	2	February	1	2027	2027-02	6	0
20270213	2027-02-13	13	Saturday	2	February	1	2027	2027-02	6	1
20270214	2027-02-14	14	Sunday	2	February	1	2027	2027-02	6	1
20270215	2027-02-15	15	Monday	2	February	1	2027	2027-02	7	0
20270216	2027-02-16	16	Tuesday	2	February	1	2027	2027-02	7	0
20270217	2027-02-17	17	Wednesday	2	February	1	2027	2027-02	7	0
20270218	2027-02-18	18	Thursday	2	February	1	2027	2027-02	7	0
20270219	2027-02-19	19	Friday	2	February	1	2027	2027-02	7	0
20270220	2027-02-20	20	Saturday	2	February	1	2027	2027-02	7	1
20270221	2027-02-21	21	Sunday	2	February	1	2027	2027-02	7	1
20270222	2027-02-22	22	Monday	2	February	1	2027	2027-02	8	0
20270223	2027-02-23	23	Tuesday	2	February	1	2027	2027-02	8	0
20270224	2027-02-24	24	Wednesday	2	February	1	2027	2027-02	8	0
20270225	2027-02-25	25	Thursday	2	February	1	2027	2027-02	8	0
20270226	2027-02-26	26	Friday	2	February	1	2027	2027-02	8	0
20270227	2027-02-27	27	Saturday	2	February	1	2027	2027-02	8	1
20270228	2027-02-28	28	Sunday	2	February	1	2027	2027-02	8	1
20270301	2027-03-01	1	Monday	3	March	1	2027	2027-03	9	0
20270302	2027-03-02	2	Tuesday	3	March	1	2027	2027-03	9	0
20270303	2027-03-03	3	Wednesday	3	March	1	2027	2027-03	9	0
20270304	2027-03-04	4	Thursday	3	March	1	2027	2027-03	9	0
20270305	2027-03-05	5	Friday	3	March	1	2027	2027-03	9	0
20270306	2027-03-06	6	Saturday	3	March	1	2027	2027-03	9	1
20270307	2027-03-07	7	Sunday	3	March	1	2027	2027-03	9	1
20270308	2027-03-08	8	Monday	3	March	1	2027	2027-03	10	0
20270309	2027-03-09	9	Tuesday	3	March	1	2027	2027-03	10	0
20270310	2027-03-10	10	Wednesday	3	March	1	2027	2027-03	10	0
20270311	2027-03-11	11	Thursday	3	March	1	2027	2027-03	10	0
20270312	2027-03-12	12	Friday	3	March	1	2027	2027-03	10	0
20270313	2027-03-13	13	Saturday	3	March	1	2027	2027-03	10	1
20270314	2027-03-14	14	Sunday	3	March	1	2027	2027-03	10	1
20270315	2027-03-15	15	Monday	3	March	1	2027	2027-03	11	0
20270316	2027-03-16	16	Tuesday	3	March	1	2027	2027-03	11	0
20270317	2027-03-17	17	Wednesday	3	March	1	2027	2027-03	11	0
20270318	2027-03-18	18	Thursday	3	March	1	2027	2027-03	11	0
20270319	2027-03-19	19	Friday	3	March	1	2027	2027-03	11	0
20270320	2027-03-20	20	Saturday	3	March	1	2027	2027-03	11	1
20270321	2027-03-21	21	Sunday	3	March	1	2027	2027-03	11	1
20270322	2027-03-22	22	Monday	3	March	1	2027	2027-03	12	0
20270323	2027-03-23	23	Tuesday	3	March	1	2027	2027-03	12	0
20270324	2027-03-24	24	Wednesday	3	March	1	2027	2027-03	12	0
20270325	2027-03-25	25	Thursday	3	March	1	2027	2027-03	12	0
20270326	2027-03-26	26	Friday	3	March	1	2027	2027-03	12	0
20270327	2027-03-27	27	Saturday	3	March	1	2027	2027-03	12	1
20270328	2027-03-28	28	Sunday	3	March	1	2027	2027-03	12	1
20270329	2027-03-29	29	Monday	3	March	1	2027	2027-03	13	0
20270330	2027-03-30	30	Tuesday	3	March	1	2027	2027-03	13	0
20270331	2027-03-31	31	Wednesday	3	March	1	2027	2027-03	13	0
20270401	2027-04-01	1	Thursday	4	April	2	2027	2027-04	13	0
20270402	2027-04-02	2	Friday	4	April	2	2027	2027-04	13	0
20270403	2027-04-03	3	Saturday	4	April	2	2027	2027-04	13	1
20270404	2027-04-04	4	Sunday	4	April	2	2027	2027-04	13	1
20270405	2027-04-05	5	Monday	4	April	2	2027	2027-04	14	0
20270406	2027-04-06	6	Tuesday	4	April	2	2027	2027-04	14	0
20270407	2027-04-07	7	Wednesday	4	April	2	2027	2027-04	14	0
20270408	2027-04-08	8	Thursday	4	April	2	2027	2027-04	14	0
20270409	2027-04-09	9	Friday	4	April	2	2027	2027-04	14	0
20270410	2027-04-10	10	Saturday	4	April	2	2027	2027-04	14	1
20270411	2027-04-11	11	Sunday	4	April	2	2027	2027-04	14	1
20270412	2027-04-12	12	Monday	4	April	2	2027	2027-04	15	0
20270413	2027-04-13	13	Tuesday	4	April	2	2027	2027-04	15	0
20270414	2027-04-14	14	Wednesday	4	April	2	2027	2027-04	15	0
20270415	2027-04-15	15	Thursday	4	April	2	2027	2027-04	15	0
20270416	2027-04-16	16	Friday	4	April	2	2027	2027-04	15	0
20270417	2027-04-17	17	Saturday	4	April	2	2027	2027-04	15	1
20270418	2027-04-18	18	Sunday	4	April	2	2027	2027-04	15	1
20270419	2027-04-19	19	Monday	4	April	2	2027	2027-04	16	0
20270420	2027-04-20	20	Tuesday	4	April	2	2027	2027-04	16	0
20270421	2027-04-21	21	Wednesday	4	April	2	2027	2027-04	16	0
20270422	2027-04-22	22	Thursday	4	April	2	2027	2027-04	16	0
20270423	2027-04-23	23	Friday	4	April	2	2027	2027-04	16	0
20270424	2027-04-24	24	Saturday	4	April	2	2027	2027-04	16	1
20270425	2027-04-25	25	Sunday	4	April	2	2027	2027-04	16	1
20270426	2027-04-26	26	Monday	4	April	2	2027	2027-04	17	0
20270427	2027-04-27	27	Tuesday	4	April	2	2027	2027-04	17	0
20270428	2027-04-28	28	Wednesday	4	April	2	2027	2027-04	17	0
20270429	2027-04-29	29	Thursday	4	April	2	2027	2027-04	17	0
20270430	2027-04-30	30	Friday	4	April	2	2027	2027-04	17	0
20270501	2027-05-01	1	Saturday	5	May	2	2027	2027-05	17	1
20270502	2027-05-02	2	Sunday	5	May	2	2027	2027-05	17	1
20270503	2027-05-03	3	Monday	5	May	2	2027	2027-05	18	0
20270504	2027-05-04	4	Tuesday	5	May	2	2027	2027-05	18	0
20270505	2027-05-05	5	Wednesday	5	May	2	2027	2027-05	18	0
20270506	2027-05-06	6	Thursday	5	May	2	2027	2027-05	18	0
20270507	2027-05-07	7	Friday	5	May	2	2027	2027-05	18	0
20270508	2027-05-08	8	Saturday	5	May	2	2027	2027-05	18	1
20270509	2027-05-09	9	Sunday	5	May	2	2027	2027-05	18	1
20270510	2027-05-10	10	Monday	5	May	2	2027	2027-05	19	0
20270511	2027-05-11	11	Tuesday	5	May	2	2027	2027-05	19	0
20270512	2027-05-12	12	Wednesday	5	May	2	2027	2027-05	19	0
20270513	2027-05-13	13	Thursday	5	May	2	2027	2027-05	19	0
20270514	2027-05-14	14	Friday	5	May	2	2027	2027-05	19	0
20270515	2027-05-15	15	Saturday	5	May	2	2027	2027-05	19	1
20270516	2027-05-16	16	Sunday	5	May	2	2027	2027-05	19	1
20270517	2027-05-17	17	Monday	5	May	2	2027	2027-05	20	0
20270518	2027-05-18	18	Tuesday	5	May	2	2027	2027-05	20	0
20270519	2027-05-19	19	Wednesday	5	May	2	2027	2027-05	20	0
20270520	2027-05-20	20	Thursday	5	May	2	2027	2027-05	20	0
20270521	2027-05-21	21	Friday	5	May	2	2027	2027-05	20	0
20270522	2027-05-22	22	Saturday	5	May	2	2027	2027-05	20	1
20270523	2027-05-23	23	Sunday	5	May	2	2027	2027-05	20	1
20270524	2027-05-24	24	Monday	5	May	2	2027	2027-05	21	0
20270525	2027-05-25	25	Tuesday	5	May	2	2027	2027-05	21	0
20270526	2027-05-26	26	Wednesday	5	May	2	2027	2027-05	21	0
20270527	2027-05-27	27	Thursday	5	May	2	2027	2027-05	21	0
20270528	2027-05-28	28	Friday	5	May	2	2027	2027-05	21	0
20270529	2027-05-29	29	Saturday	5	May	2	2027	2027-05	21	1
20270530	2027-05-30	30	Sunday	5	May	2	2027	2027-05	21	1
20270531	2027-05-31	31	Monday	5	May	2	2027	2027-05	22	0
20270601	2027-06-01	1	Tuesday	6	June	2	2027	2027-06	22	0
20270602	2027-06-02	2	Wednesday	6	June	2	2027	2027-06	22	0
20270603	2027-06-03	3	Thursday	6	June	2	2027	2027-06	22	0
20270604	2027-06-04	4	Friday	6	June	2	2027	2027-06	22	0
20270605	2027-06-05	5	Saturday	6	June	2	2027	2027-06	22	1
20270606	2027-06-06	6	Sunday	6	June	2	2027	2027-06	22	1
20270607	2027-06-07	7	Monday	6	June	2	2027	2027-06	23	0
20270608	2027-06-08	8	Tuesday	6	June	2	2027	2027-06	23	0
20270609	2027-06-09	9	Wednesday	6	June	2	2027	2027-06	23	0
20270610	2027-06-10	10	Thursday	6	June	2	2027	2027-06	23	0
20270611	2027-06-11	11	Friday	6	June	2	2027	2027-06	23	0
20270612	2027-06-12	12	Saturday	6	June	2	2027	2027-06	23	1
20270613	2027-06-13	13	Sunday	6	June	2	2027	2027-06	23	1
20270614	2027-06-14	14	Monday	6	June	2	2027	2027-06	24	0
20270615	2027-06-15	15	Tuesday	6	June	2	2027	2027-06	24	0
20270616	2027-06-16	16	Wednesday	6	June	2	2027	2027-06	24	0
20270617	2027-06-17	17	Thursday	6	June	2	2027	2027-06	24	0
20270618	2027-06-18	18	Friday	6	June	2	2027	2027-06	24	0
20270619	2027-06-19	19	Saturday	6	June	2	2027	2027-06	24	1
20270620	2027-06-20	20	Sunday	6	June	2	2027	2027-06	24	1
20270621	2027-06-21	21	Monday	6	June	2	2027	2027-06	25	0
20270622	2027-06-22	22	Tuesday	6	June	2	2027	2027-06	25	0
20270623	2027-06-23	23	Wednesday	6	June	2	2027	2027-06	25	0
20270624	2027-06-24	24	Thursday	6	June	2	2027	2027-06	25	0
20270625	2027-06-25	25	Friday	6	June	2	2027	2027-06	25	0
20270626	2027-06-26	26	Saturday	6	June	2	2027	2027-06	25	1
20270627	2027-06-27	27	Sunday	6	June	2	2027	2027-06	25	1
20270628	2027-06-28	28	Monday	6	June	2	2027	2027-06	26	0
20270629	2027-06-29	29	Tuesday	6	June	2	2027	2027-06	26	0
20270630	2027-06-30	30	Wednesday	6	June	2	2027	2027-06	26	0
20270701	2027-07-01	1	Thursday	7	July	3	2027	2027-07	26	0
20270702	2027-07-02	2	Friday	7	July	3	2027	2027-07	26	0
20270703	2027-07-03	3	Saturday	7	July	3	2027	2027-07	26	1
20270704	2027-07-04	4	Sunday	7	July	3	2027	2027-07	26	1
20270705	2027-07-05	5	Monday	7	July	3	2027	2027-07	27	0
20270706	2027-07-06	6	Tuesday	7	July	3	2027	2027-07	27	0
20270707	2027-07-07	7	Wednesday	7	July	3	2027	2027-07	27	0
20270708	2027-07-08	8	Thursday	7	July	3	2027	2027-07	27	0
20270709	2027-07-09	9	Friday	7	July	3	2027	2027-07	27	0
20270710	2027-07-10	10	Saturday	7	July	3	2027	2027-07	27	1
20270711	2027-07-11	11	Sunday	7	July	3	2027	2027-07	27	1
20270712	2027-07-12	12	Monday	7	July	3	2027	2027-07	28	0
20270713	2027-07-13	13	Tuesday	7	July	3	2027	2027-07	28	0
20270714	2027-07-14	14	Wednesday	7	July	3	2027	2027-07	28	0
20270715	2027-07-15	15	Thursday	7	July	3	2027	2027-07	28	0
20270716	2027-07-16	16	Friday	7	July	3	2027	2027-07	28	0
20270717	2027-07-17	17	Saturday	7	July	3	2027	2027-07	28	1
20270718	2027-07-18	18	Sunday	7	July	3	2027	2027-07	28	1
20270719	2027-07-19	19	Monday	7	July	3	2027	2027-07	29	0
20270720	2027-07-20	20	Tuesday	7	July	3	2027	2027-07	29	0
20270721	2027-07-21	21	Wednesday	7	July	3	2027	2027-07	29	0
20270722	2027-07-22	22	Thursday	7	July	3	2027	2027-07	29	0
20270723	2027-07-23	23	Friday	7	July	3	2027	2027-07	29	0
20270724	2027-07-24	24	Saturday	7	July	3	2027	2027-07	29	1
20270725	2027-07-25	25	Sunday	7	July	3	2027	2027-07	29	1
20270726	2027-07-26	26	Monday	7	July	3	2027	2027-07	30	0
20270727	2027-07-27	27	Tuesday	7	July	3	2027	2027-07	30	0
20270728	2027-07-28	28	Wednesday	7	July	3	2027	2027-07	30	0
20270729	2027-07-29	29	Thursday	7	July	3	2027	2027-07	30	0
20270730	2027-07-30	30	Friday	7	July	3	2027	2027-07	30	0
20270731	2027-07-31	31	Saturday	7	July	3	2027	2027-07	30	1
20270801	2027-08-01	1	Sunday	8	August	3	2027	2027-08	30	1
20270802	2027-08-02	2	Monday	8	August	3	2027	2027-08	31	0
20270803	2027-08-03	3	Tuesday	8	August	3	2027	2027-08	31	0
20270804	2027-08-04	4	Wednesday	8	August	3	2027	2027-08	31	0
20270805	2027-08-05	5	Thursday	8	August	3	2027	2027-08	31	0
20270806	2027-08-06	6	Friday	8	August	3	2027	2027-08	31	0
20270807	2027-08-07	7	Saturday	8	August	3	2027	2027-08	31	1
20270808	2027-08-08	8	Sunday	8	August	3	2027	2027-08	31	1
20270809	2027-08-09	9	Monday	8	August	3	2027	2027-08	32	0
20270810	2027-08-10	10	Tuesday	8	August	3	2027	2027-08	32	0
20270811	2027-08-11	11	Wednesday	8	August	3	2027	2027-08	32	0
20270812	2027-08-12	12	Thursday	8	August	3	2027	2027-08	32	0
20270813	2027-08-13	13	Friday	8	August	3	2027	2027-08	32	0
20270814	2027-08-14	14	Saturday	8	August	3	2027	2027-08	32	1
20270815	2027-08-15	15	Sunday	8	August	3	2027	2027-08	32	1
20270816	2027-08-16	16	Monday	8	August	3	2027	2027-08	33	0
20270817	2027-08-17	17	Tuesday	8	August	3	2027	2027-08	33	0
20270818	2027-08-18	18	Wednesday	8	August	3	2027	2027-08	33	0
20270819	2027-08-19	19	Thursday	8	August	3	2027	2027-08	33	0
20270820	2027-08-20	20	Friday	8	August	3	2027	2027-08	33	0
20270821	2027-08-21	21	Saturday	8	August	3	2027	2027-08	33	1
20270822	2027-08-22	22	Sunday	8	August	3	2027	2027-08	33	1
20270823	2027-08-23	23	Monday	8	August	3	2027	2027-08	34	0
20270824	2027-08-24	24	Tuesday	8	August	3	2027	2027-08	34	0
20270825	2027-08-25	25	Wednesday	8	August	3	2027	2027-08	34	0
20270826	2027-08-26	26	Thursday	8	August	3	2027	2027-08	34	0
20270827	2027-08-27	27	Friday	8	August	3	2027	2027-08	34	0
20270828	2027-08-28	28	Saturday	8	August	3	2027	2027-08	34	1
20270829	2027-08-29	29	Sunday	8	August	3	2027	2027-08	34	1
20270830	2027-08-30	30	Monday	8	August	3	2027	2027-08	35	0
20270831	2027-08-31	31	Tuesday	8	August	3	2027	2027-08	35	0
20270901	2027-09-01	1	Wednesday	9	September	3	2027	2027-09	35	0
20270902	2027-09-02	2	Thursday	9	September	3	2027	2027-09	35	0
20270903	2027-09-03	3	Friday	9	September	3	2027	2027-09	35	0
20270904	2027-09-04	4	Saturday	9	September	3	2027	2027-09	35	1
20270905	2027-09-05	5	Sunday	9	September	3	2027	2027-09	35	1
20270906	2027-09-06	6	Monday	9	September	3	2027	2027-09	36	0
20270907	2027-09-07	7	Tuesday	9	September	3	2027	2027-09	36	0
20270908	2027-09-08	8	Wednesday	9	September	3	2027	2027-09	36	0
20270909	2027-09-09	9	Thursday	9	September	3	2027	2027-09	36	0
20270910	2027-09-10	10	Friday	9	September	3	2027	2027-09	36	0
20270911	2027-09-11	11	Saturday	9	September	3	2027	2027-09	36	1
20270912	2027-09-12	12	Sunday	9	September	3	2027	2027-09	36	1
20270913	2027-09-13	13	Monday	9	September	3	2027	2027-09	37	0
20270914	2027-09-14	14	Tuesday	9	September	3	2027	2027-09	37	0
20270915	2027-09-15	15	Wednesday	9	September	3	2027	2027-09	37	0
20270916	2027-09-16	16	Thursday	9	September	3	2027	2027-09	37	0
20270917	2027-09-17	17	Friday	9	September	3	2027	2027-09	37	0
20270918	2027-09-18	18	Saturday	9	September	3	2027	2027-09	37	1
20270919	2027-09-19	19	Sunday	9	September	3	2027	2027-09	37	1
20270920	2027-09-20	20	Monday	9	September	3	2027	2027-09	38	0
20270921	2027-09-21	21	Tuesday	9	September	3	2027	2027-09	38	0
20270922	2027-09-22	22	Wednesday	9	September	3	2027	2027-09	38	0
20270923	2027-09-23	23	Thursday	9	September	3	2027	2027-09	38	0
20270924	2027-09-24	24	Friday	9	September	3	2027	2027-09	38	0
20270925	2027-09-25	25	Saturday	9	September	3	2027	2027-09	38	1
20270926	2027-09-26	26	Sunday	9	September	3	2027	2027-09	38	1
20270927	2027-09-27	27	Monday	9	September	3	2027	2027-09	39	0
20270928	2027-09-28	28	Tuesday	9	September	3	2027	2027-09	39	0
20270929	2027-09-29	29	Wednesday	9	September	3	2027	2027-09	39	0
20270930	2027-09-30	30	Thursday	9	September	3	2027	2027-09	39	0
20271001	2027-10-01	1	Friday	10	October	4	2027	2027-10	39	0
20271002	2027-10-02	2	Saturday	10	October	4	2027	2027-10	39	1
20271003	2027-10-03	3	Sunday	10	October	4	2027	2027-10	39	1
20271004	2027-10-04	4	Monday	10	October	4	2027	2027-10	40	0
20271005	2027-10-05	5	Tuesday	10	October	4	2027	2027-10	40	0
20271006	2027-10-06	6	Wednesday	10	October	4	2027	2027-10	40	0
20271007	2027-10-07	7	Thursday	10	October	4	2027	2027-10	40	0
20271008	2027-10-08	8	Friday	10	October	4	2027	2027-10	40	0
20271009	2027-10-09	9	Saturday	10	October	4	2027	2027-10	40	1
20271010	2027-10-10	10	Sunday	10	October	4	2027	2027-10	40	1
20271011	2027-10-11	11	Monday	10	October	4	2027	2027-10	41	0
20271012	2027-10-12	12	Tuesday	10	October	4	2027	2027-10	41	0
20271013	2027-10-13	13	Wednesday	10	October	4	2027	2027-10	41	0
20271014	2027-10-14	14	Thursday	10	October	4	2027	2027-10	41	0
20271015	2027-10-15	15	Friday	10	October	4	2027	2027-10	41	0
20271016	2027-10-16	16	Saturday	10	October	4	2027	2027-10	41	1
20271017	2027-10-17	17	Sunday	10	October	4	2027	2027-10	41	1
20271018	2027-10-18	18	Monday	10	October	4	2027	2027-10	42	0
20271019	2027-10-19	19	Tuesday	10	October	4	2027	2027-10	42	0
20271020	2027-10-20	20	Wednesday	10	October	4	2027	2027-10	42	0
20271021	2027-10-21	21	Thursday	10	October	4	2027	2027-10	42	0
20271022	2027-10-22	22	Friday	10	October	4	2027	2027-10	42	0
20271023	2027-10-23	23	Saturday	10	October	4	2027	2027-10	42	1
20271024	2027-10-24	24	Sunday	10	October	4	2027	2027-10	42	1
20271025	2027-10-25	25	Monday	10	October	4	2027	2027-10	43	0
20271026	2027-10-26	26	Tuesday	10	October	4	2027	2027-10	43	0
20271027	2027-10-27	27	Wednesday	10	October	4	2027	2027-10	43	0
20271028	2027-10-28	28	Thursday	10	October	4	2027	2027-10	43	0
20271029	2027-10-29	29	Friday	10	October	4	2027	2027-10	43	0
20271030	2027-10-30	30	Saturday	10	October	4	2027	2027-10	43	1
20271031	2027-10-31	31	Sunday	10	October	4	2027	2027-10	43	1
20271101	2027-11-01	1	Monday	11	November	4	2027	2027-11	44	0
20271102	2027-11-02	2	Tuesday	11	November	4	2027	2027-11	44	0
20271103	2027-11-03	3	Wednesday	11	November	4	2027	2027-11	44	0
20271104	2027-11-04	4	Thursday	11	November	4	2027	2027-11	44	0
20271105	2027-11-05	5	Friday	11	November	4	2027	2027-11	44	0
20271106	2027-11-06	6	Saturday	11	November	4	2027	2027-11	44	1
20271107	2027-11-07	7	Sunday	11	November	4	2027	2027-11	44	1
20271108	2027-11-08	8	Monday	11	November	4	2027	2027-11	45	0
20271109	2027-11-09	9	Tuesday	11	November	4	2027	2027-11	45	0
20271110	2027-11-10	10	Wednesday	11	November	4	2027	2027-11	45	0
20271111	2027-11-11	11	Thursday	11	November	4	2027	2027-11	45	0
20271112	2027-11-12	12	Friday	11	November	4	2027	2027-11	45	0
20271113	2027-11-13	13	Saturday	11	November	4	2027	2027-11	45	1
20271114	2027-11-14	14	Sunday	11	November	4	2027	2027-11	45	1
20271115	2027-11-15	15	Monday	11	November	4	2027	2027-11	46	0
20271116	2027-11-16	16	Tuesday	11	November	4	2027	2027-11	46	0
20271117	2027-11-17	17	Wednesday	11	November	4	2027	2027-11	46	0
20271118	2027-11-18	18	Thursday	11	November	4	2027	2027-11	46	0
20271119	2027-11-19	19	Friday	11	November	4	2027	2027-11	46	0
20271120	2027-11-20	20	Saturday	11	November	4	2027	2027-11	46	1
20271121	2027-11-21	21	Sunday	11	November	4	2027	2027-11	46	1
20271122	2027-11-22	22	Monday	11	November	4	2027	2027-11	47	0
20271123	2027-11-23	23	Tuesday	11	November	4	2027	2027-11	47	0
20271124	2027-11-24	24	Wednesday	11	November	4	2027	2027-11	47	0
20271125	2027-11-25	25	Thursday	11	November	4	2027	2027-11	47	0
20271126	2027-11-26	26	Friday	11	November	4	2027	2027-11	47	0
20271127	2027-11-27	27	Saturday	11	November	4	2027	2027-11	47	1
20271128	2027-11-28	28	Sunday	11	November	4	2027	2027-11	47	1
20271129	2027-11-29	29	Monday	11	November	4	2027	2027-11	48	0
20271130	2027-11-30	30	Tuesday	11	November	4	2027	2027-11	48	0
20271201	2027-12-01	1	Wednesday	12	December	4	2027	2027-12	48	0
20271202	2027-12-02	2	Thursday	12	December	4	2027	2027-12	48	0
20271203	2027-12-03	3	Friday	12	December	4	2027	2027-12	48	0
20271204	2027-12-04	4	Saturday	12	December	4	2027	2027-12	48	1
20271205	2027-12-05	5	Sunday	12	December	4	2027	2027-12	48	1
20271206	2027-12-06	6	Monday	12	December	4	2027	2027-12	49	0
20271207	2027-12-07	7	Tuesday	12	December	4	2027	2027-12	49	0
20271208	2027-12-08	8	Wednesday	12	December	4	2027	2027-12	49	0
20271209	2027-12-09	9	Thursday	12	December	4	2027	2027-12	49	0
20271210	2027-12-10	10	Friday	12	December	4	2027	2027-12	49	0
20271211	2027-12-11	11	Saturday	12	December	4	2027	2027-12	49	1
20271212	2027-12-12	12	Sunday	12	December	4	2027	2027-12	49	1
20271213	2027-12-13	13	Monday	12	December	4	2027	2027-12	50	0
20271214	2027-12-14	14	Tuesday	12	December	4	2027	2027-12	50	0
20271215	2027-12-15	15	Wednesday	12	December	4	2027	2027-12	50	0
20271216	2027-12-16	16	Thursday	12	December	4	2027	2027-12	50	0
20271217	2027-12-17	17	Friday	12	December	4	2027	2027-12	50	0
20271218	2027-12-18	18	Saturday	12	December	4	2027	2027-12	50	1
20271219	2027-12-19	19	Sunday	12	December	4	2027	2027-12	50	1
20271220	2027-12-20	20	Monday	12	December	4	2027	2027-12	51	0
20271221	2027-12-21	21	Tuesday	12	December	4	2027	2027-12	51	0
20271222	2027-12-22	22	Wednesday	12	December	4	2027	2027-12	51	0
20271223	2027-12-23	23	Thursday	12	December	4	2027	2027-12	51	0
20271224	2027-12-24	24	Friday	12	December	4	2027	2027-12	51	0
20271225	2027-12-25	25	Saturday	12	December	4	2027	2027-12	51	1
20271226	2027-12-26	26	Sunday	12	December	4	2027	2027-12	51	1
20271227	2027-12-27	27	Monday	12	December	4	2027	2027-12	52	0
20271228	2027-12-28	28	Tuesday	12	December	4	2027	2027-12	52	0
20271229	2027-12-29	29	Wednesday	12	December	4	2027	2027-12	52	0
20271230	2027-12-30	30	Thursday	12	December	4	2027	2027-12	52	0
20271231	2027-12-31	31	Friday	12	December	4	2027	2027-12	52	0
20280101	2028-01-01	1	Saturday	1	January	1	2028	2028-01	52	1
20280102	2028-01-02	2	Sunday	1	January	1	2028	2028-01	52	1
20280103	2028-01-03	3	Monday	1	January	1	2028	2028-01	1	0
20280104	2028-01-04	4	Tuesday	1	January	1	2028	2028-01	1	0
20280105	2028-01-05	5	Wednesday	1	January	1	2028	2028-01	1	0
20280106	2028-01-06	6	Thursday	1	January	1	2028	2028-01	1	0
20280107	2028-01-07	7	Friday	1	January	1	2028	2028-01	1	0
20280108	2028-01-08	8	Saturday	1	January	1	2028	2028-01	1	1
20280109	2028-01-09	9	Sunday	1	January	1	2028	2028-01	1	1
20280110	2028-01-10	10	Monday	1	January	1	2028	2028-01	2	0
20280111	2028-01-11	11	Tuesday	1	January	1	2028	2028-01	2	0
20280112	2028-01-12	12	Wednesday	1	January	1	2028	2028-01	2	0
20280113	2028-01-13	13	Thursday	1	January	1	2028	2028-01	2	0
20280114	2028-01-14	14	Friday	1	January	1	2028	2028-01	2	0
20280115	2028-01-15	15	Saturday	1	January	1	2028	2028-01	2	1
20280116	2028-01-16	16	Sunday	1	January	1	2028	2028-01	2	1
20280117	2028-01-17	17	Monday	1	January	1	2028	2028-01	3	0
20280118	2028-01-18	18	Tuesday	1	January	1	2028	2028-01	3	0
20280119	2028-01-19	19	Wednesday	1	January	1	2028	2028-01	3	0
20280120	2028-01-20	20	Thursday	1	January	1	2028	2028-01	3	0
20280121	2028-01-21	21	Friday	1	January	1	2028	2028-01	3	0
20280122	2028-01-22	22	Saturday	1	January	1	2028	2028-01	3	1
20280123	2028-01-23	23	Sunday	1	January	1	2028	2028-01	3	1
20280124	2028-01-24	24	Monday	1	January	1	2028	2028-01	4	0
20280125	2028-01-25	25	Tuesday	1	January	1	2028	2028-01	4	0
20280126	2028-01-26	26	Wednesday	1	January	1	2028	2028-01	4	0
20280127	2028-01-27	27	Thursday	1	January	1	2028	2028-01	4	0
20280128	2028-01-28	28	Friday	1	January	1	2028	2028-01	4	0
20280129	2028-01-29	29	Saturday	1	January	1	2028	2028-01	4	1
20280130	2028-01-30	30	Sunday	1	January	1	2028	2028-01	4	1
20280131	2028-01-31	31	Monday	1	January	1	2028	2028-01	5	0
20280201	2028-02-01	1	Tuesday	2	February	1	2028	2028-02	5	0
20280202	2028-02-02	2	Wednesday	2	February	1	2028	2028-02	5	0
20280203	2028-02-03	3	Thursday	2	February	1	2028	2028-02	5	0
20280204	2028-02-04	4	Friday	2	February	1	2028	2028-02	5	0
20280205	2028-02-05	5	Saturday	2	February	1	2028	2028-02	5	1
20280206	2028-02-06	6	Sunday	2	February	1	2028	2028-02	5	1
20280207	2028-02-07	7	Monday	2	February	1	2028	2028-02	6	0
20280208	2028-02-08	8	Tuesday	2	February	1	2028	2028-02	6	0
20280209	2028-02-09	9	Wednesday	2	February	1	2028	2028-02	6	0
20280210	2028-02-10	10	Thursday	2	February	1	2028	2028-02	6	0
20280211	2028-02-11	11	Friday	2	February	1	2028	2028-02	6	0
20280212	2028-02-12	12	Saturday	2	February	1	2028	2028-02	6	1
20280213	2028-02-13	13	Sunday	2	February	1	2028	2028-02	6	1
20280214	2028-02-14	14	Monday	2	February	1	2028	2028-02	7	0
20280215	2028-02-15	15	Tuesday	2	February	1	2028	2028-02	7	0
20280216	2028-02-16	16	Wednesday	2	February	1	2028	2028-02	7	0
20280217	2028-02-17	17	Thursday	2	February	1	2028	2028-02	7	0
20280218	2028-02-18	18	Friday	2	February	1	2028	2028-02	7	0
20280219	2028-02-19	19	Saturday	2	February	1	2028	2028-02	7	1
20280220	2028-02-20	20	Sunday	2	February	1	2028	2028-02	7	1
20280221	2028-02-21	21	Monday	2	February	1	2028	2028-02	8	0
20280222	2028-02-22	22	Tuesday	2	February	1	2028	2028-02	8	0
20280223	2028-02-23	23	Wednesday	2	February	1	2028	2028-02	8	0
20280224	2028-02-24	24	Thursday	2	February	1	2028	2028-02	8	0
20280225	2028-02-25	25	Friday	2	February	1	2028	2028-02	8	0
20280226	2028-02-26	26	Saturday	2	February	1	2028	2028-02	8	1
20280227	2028-02-27	27	Sunday	2	February	1	2028	2028-02	8	1
20280228	2028-02-28	28	Monday	2	February	1	2028	2028-02	9	0
20280229	2028-02-29	29	Tuesday	2	February	1	2028	2028-02	9	0
20280301	2028-03-01	1	Wednesday	3	March	1	2028	2028-03	9	0
20280302	2028-03-02	2	Thursday	3	March	1	2028	2028-03	9	0
20280303	2028-03-03	3	Friday	3	March	1	2028	2028-03	9	0
20280304	2028-03-04	4	Saturday	3	March	1	2028	2028-03	9	1
20280305	2028-03-05	5	Sunday	3	March	1	2028	2028-03	9	1
20280306	2028-03-06	6	Monday	3	March	1	2028	2028-03	10	0
20280307	2028-03-07	7	Tuesday	3	March	1	2028	2028-03	10	0
20280308	2028-03-08	8	Wednesday	3	March	1	2028	2028-03	10	0
20280309	2028-03-09	9	Thursday	3	March	1	2028	2028-03	10	0
20280310	2028-03-10	10	Friday	3	March	1	2028	2028-03	10	0
20280311	2028-03-11	11	Saturday	3	March	1	2028	2028-03	10	1
20280312	2028-03-12	12	Sunday	3	March	1	2028	2028-03	10	1
20280313	2028-03-13	13	Monday	3	March	1	2028	2028-03	11	0
20280314	2028-03-14	14	Tuesday	3	March	1	2028	2028-03	11	0
20280315	2028-03-15	15	Wednesday	3	March	1	2028	2028-03	11	0
20280316	2028-03-16	16	Thursday	3	March	1	2028	2028-03	11	0
20280317	2028-03-17	17	Friday	3	March	1	2028	2028-03	11	0
20280318	2028-03-18	18	Saturday	3	March	1	2028	2028-03	11	1
20280319	2028-03-19	19	Sunday	3	March	1	2028	2028-03	11	1
20280320	2028-03-20	20	Monday	3	March	1	2028	2028-03	12	0
20280321	2028-03-21	21	Tuesday	3	March	1	2028	2028-03	12	0
20280322	2028-03-22	22	Wednesday	3	March	1	2028	2028-03	12	0
20280323	2028-03-23	23	Thursday	3	March	1	2028	2028-03	12	0
20280324	2028-03-24	24	Friday	3	March	1	2028	2028-03	12	0
20280325	2028-03-25	25	Saturday	3	March	1	2028	2028-03	12	1
20280326	2028-03-26	26	Sunday	3	March	1	2028	2028-03	12	1
20280327	2028-03-27	27	Monday	3	March	1	2028	2028-03	13	0
20280328	2028-03-28	28	Tuesday	3	March	1	2028	2028-03	13	0
20280329	2028-03-29	29	Wednesday	3	March	1	2028	2028-03	13	0
20280330	2028-03-30	30	Thursday	3	March	1	2028	2028-03	13	0
20280331	2028-03-31	31	Friday	3	March	1	2028	2028-03	13	0
20280401	2028-04-01	1	Saturday	4	April	2	2028	2028-04	13	1
20280402	2028-04-02	2	Sunday	4	April	2	2028	2028-04	13	1
20280403	2028-04-03	3	Monday	4	April	2	2028	2028-04	14	0
20280404	2028-04-04	4	Tuesday	4	April	2	2028	2028-04	14	0
20280405	2028-04-05	5	Wednesday	4	April	2	2028	2028-04	14	0
20280406	2028-04-06	6	Thursday	4	April	2	2028	2028-04	14	0
20280407	2028-04-07	7	Friday	4	April	2	2028	2028-04	14	0
20280408	2028-04-08	8	Saturday	4	April	2	2028	2028-04	14	1
20280409	2028-04-09	9	Sunday	4	April	2	2028	2028-04	14	1
20280410	2028-04-10	10	Monday	4	April	2	2028	2028-04	15	0
20280411	2028-04-11	11	Tuesday	4	April	2	2028	2028-04	15	0
20280412	2028-04-12	12	Wednesday	4	April	2	2028	2028-04	15	0
20280413	2028-04-13	13	Thursday	4	April	2	2028	2028-04	15	0
20280414	2028-04-14	14	Friday	4	April	2	2028	2028-04	15	0
20280415	2028-04-15	15	Saturday	4	April	2	2028	2028-04	15	1
20280416	2028-04-16	16	Sunday	4	April	2	2028	2028-04	15	1
20280417	2028-04-17	17	Monday	4	April	2	2028	2028-04	16	0
20280418	2028-04-18	18	Tuesday	4	April	2	2028	2028-04	16	0
20280419	2028-04-19	19	Wednesday	4	April	2	2028	2028-04	16	0
20280420	2028-04-20	20	Thursday	4	April	2	2028	2028-04	16	0
20280421	2028-04-21	21	Friday	4	April	2	2028	2028-04	16	0
20280422	2028-04-22	22	Saturday	4	April	2	2028	2028-04	16	1
20280423	2028-04-23	23	Sunday	4	April	2	2028	2028-04	16	1
20280424	2028-04-24	24	Monday	4	April	2	2028	2028-04	17	0
20280425	2028-04-25	25	Tuesday	4	April	2	2028	2028-04	17	0
20280426	2028-04-26	26	Wednesday	4	April	2	2028	2028-04	17	0
20280427	2028-04-27	27	Thursday	4	April	2	2028	2028-04	17	0
20280428	2028-04-28	28	Friday	4	April	2	2028	2028-04	17	0
20280429	2028-04-29	29	Saturday	4	April	2	2028	2028-04	17	1
20280430	2028-04-30	30	Sunday	4	April	2	2028	2028-04	17	1
20280501	2028-05-01	1	Monday	5	May	2	2028	2028-05	18	0
20280502	2028-05-02	2	Tuesday	5	May	2	2028	2028-05	18	0
20280503	2028-05-03	3	Wednesday	5	May	2	2028	2028-05	18	0
20280504	2028-05-04	4	Thursday	5	May	2	2028	2028-05	18	0
20280505	2028-05-05	5	Friday	5	May	2	2028	2028-05	18	0
20280506	2028-05-06	6	Saturday	5	May	2	2028	2028-05	18	1
20280507	2028-05-07	7	Sunday	5	May	2	2028	2028-05	18	1
20280508	2028-05-08	8	Monday	5	May	2	2028	2028-05	19	0
20280509	2028-05-09	9	Tuesday	5	May	2	2028	2028-05	19	0
20280510	2028-05-10	10	Wednesday	5	May	2	2028	2028-05	19	0
20280511	2028-05-11	11	Thursday	5	May	2	2028	2028-05	19	0
20280512	2028-05-12	12	Friday	5	May	2	2028	2028-05	19	0
20280513	2028-05-13	13	Saturday	5	May	2	2028	2028-05	19	1
20280514	2028-05-14	14	Sunday	5	May	2	2028	2028-05	19	1
20280515	2028-05-15	15	Monday	5	May	2	2028	2028-05	20	0
20280516	2028-05-16	16	Tuesday	5	May	2	2028	2028-05	20	0
20280517	2028-05-17	17	Wednesday	5	May	2	2028	2028-05	20	0
20280518	2028-05-18	18	Thursday	5	May	2	2028	2028-05	20	0
20280519	2028-05-19	19	Friday	5	May	2	2028	2028-05	20	0
20280520	2028-05-20	20	Saturday	5	May	2	2028	2028-05	20	1
20280521	2028-05-21	21	Sunday	5	May	2	2028	2028-05	20	1
20280522	2028-05-22	22	Monday	5	May	2	2028	2028-05	21	0
20280523	2028-05-23	23	Tuesday	5	May	2	2028	2028-05	21	0
20280524	2028-05-24	24	Wednesday	5	May	2	2028	2028-05	21	0
20280525	2028-05-25	25	Thursday	5	May	2	2028	2028-05	21	0
20280526	2028-05-26	26	Friday	5	May	2	2028	2028-05	21	0
20280527	2028-05-27	27	Saturday	5	May	2	2028	2028-05	21	1
20280528	2028-05-28	28	Sunday	5	May	2	2028	2028-05	21	1
20280529	2028-05-29	29	Monday	5	May	2	2028	2028-05	22	0
20280530	2028-05-30	30	Tuesday	5	May	2	2028	2028-05	22	0
20280531	2028-05-31	31	Wednesday	5	May	2	2028	2028-05	22	0
20280601	2028-06-01	1	Thursday	6	June	2	2028	2028-06	22	0
20280602	2028-06-02	2	Friday	6	June	2	2028	2028-06	22	0
20280603	2028-06-03	3	Saturday	6	June	2	2028	2028-06	22	1
20280604	2028-06-04	4	Sunday	6	June	2	2028	2028-06	22	1
20280605	2028-06-05	5	Monday	6	June	2	2028	2028-06	23	0
20280606	2028-06-06	6	Tuesday	6	June	2	2028	2028-06	23	0
20280607	2028-06-07	7	Wednesday	6	June	2	2028	2028-06	23	0
20280608	2028-06-08	8	Thursday	6	June	2	2028	2028-06	23	0
20280609	2028-06-09	9	Friday	6	June	2	2028	2028-06	23	0
20280610	2028-06-10	10	Saturday	6	June	2	2028	2028-06	23	1
20280611	2028-06-11	11	Sunday	6	June	2	2028	2028-06	23	1
20280612	2028-06-12	12	Monday	6	June	2	2028	2028-06	24	0
20280613	2028-06-13	13	Tuesday	6	June	2	2028	2028-06	24	0
20280614	2028-06-14	14	Wednesday	6	June	2	2028	2028-06	24	0
20280615	2028-06-15	15	Thursday	6	June	2	2028	2028-06	24	0
20280616	2028-06-16	16	Friday	6	June	2	2028	2028-06	24	0
20280617	2028-06-17	17	Saturday	6	June	2	2028	2028-06	24	1
20280618	2028-06-18	18	Sunday	6	June	2	2028	2028-06	24	1
20280619	2028-06-19	19	Monday	6	June	2	2028	2028-06	25	0
20280620	2028-06-20	20	Tuesday	6	June	2	2028	2028-06	25	0
20280621	2028-06-21	21	Wednesday	6	June	2	2028	2028-06	25	0
20280622	2028-06-22	22	Thursday	6	June	2	2028	2028-06	25	0
20280623	2028-06-23	23	Friday	6	June	2	2028	2028-06	25	0
20280624	2028-06-24	24	Saturday	6	June	2	2028	2028-06	25	1
20280625	2028-06-25	25	Sunday	6	June	2	2028	2028-06	25	1
20280626	2028-06-26	26	Monday	6	June	2	2028	2028-06	26	0
20280627	2028-06-27	27	Tuesday	6	June	2	2028	2028-06	26	0
20280628	2028-06-28	28	Wednesday	6	June	2	2028	2028-06	26	0
20280629	2028-06-29	29	Thursday	6	June	2	2028	2028-06	26	0
20280630	2028-06-30	30	Friday	6	June	2	2028	2028-06	26	0
20280701	2028-07-01	1	Saturday	7	July	3	2028	2028-07	26	1
20280702	2028-07-02	2	Sunday	7	July	3	2028	2028-07	26	1
20280703	2028-07-03	3	Monday	7	July	3	2028	2028-07	27	0
20280704	2028-07-04	4	Tuesday	7	July	3	2028	2028-07	27	0
20280705	2028-07-05	5	Wednesday	7	July	3	2028	2028-07	27	0
20280706	2028-07-06	6	Thursday	7	July	3	2028	2028-07	27	0
20280707	2028-07-07	7	Friday	7	July	3	2028	2028-07	27	0
20280708	2028-07-08	8	Saturday	7	July	3	2028	2028-07	27	1
20280709	2028-07-09	9	Sunday	7	July	3	2028	2028-07	27	1
20280710	2028-07-10	10	Monday	7	July	3	2028	2028-07	28	0
20280711	2028-07-11	11	Tuesday	7	July	3	2028	2028-07	28	0
20280712	2028-07-12	12	Wednesday	7	July	3	2028	2028-07	28	0
20280713	2028-07-13	13	Thursday	7	July	3	2028	2028-07	28	0
20280714	2028-07-14	14	Friday	7	July	3	2028	2028-07	28	0
20280715	2028-07-15	15	Saturday	7	July	3	2028	2028-07	28	1
20280716	2028-07-16	16	Sunday	7	July	3	2028	2028-07	28	1
20280717	2028-07-17	17	Monday	7	July	3	2028	2028-07	29	0
20280718	2028-07-18	18	Tuesday	7	July	3	2028	2028-07	29	0
20280719	2028-07-19	19	Wednesday	7	July	3	2028	2028-07	29	0
20280720	2028-07-20	20	Thursday	7	July	3	2028	2028-07	29	0
20280721	2028-07-21	21	Friday	7	July	3	2028	2028-07	29	0
20280722	2028-07-22	22	Saturday	7	July	3	2028	2028-07	29	1
20280723	2028-07-23	23	Sunday	7	July	3	2028	2028-07	29	1
20280724	2028-07-24	24	Monday	7	July	3	2028	2028-07	30	0
20280725	2028-07-25	25	Tuesday	7	July	3	2028	2028-07	30	0
20280726	2028-07-26	26	Wednesday	7	July	3	2028	2028-07	30	0
20280727	2028-07-27	27	Thursday	7	July	3	2028	2028-07	30	0
20280728	2028-07-28	28	Friday	7	July	3	2028	2028-07	30	0
20280729	2028-07-29	29	Saturday	7	July	3	2028	2028-07	30	1
20280730	2028-07-30	30	Sunday	7	July	3	2028	2028-07	30	1
20280731	2028-07-31	31	Monday	7	July	3	2028	2028-07	31	0
20280801	2028-08-01	1	Tuesday	8	August	3	2028	2028-08	31	0
20280802	2028-08-02	2	Wednesday	8	August	3	2028	2028-08	31	0
20280803	2028-08-03	3	Thursday	8	August	3	2028	2028-08	31	0
20280804	2028-08-04	4	Friday	8	August	3	2028	2028-08	31	0
20280805	2028-08-05	5	Saturday	8	August	3	2028	2028-08	31	1
20280806	2028-08-06	6	Sunday	8	August	3	2028	2028-08	31	1
20280807	2028-08-07	7	Monday	8	August	3	2028	2028-08	32	0
20280808	2028-08-08	8	Tuesday	8	August	3	2028	2028-08	32	0
20280809	2028-08-09	9	Wednesday	8	August	3	2028	2028-08	32	0
20280810	2028-08-10	10	Thursday	8	August	3	2028	2028-08	32	0
20280811	2028-08-11	11	Friday	8	August	3	2028	2028-08	32	0
20280812	2028-08-12	12	Saturday	8	August	3	2028	2028-08	32	1
20280813	2028-08-13	13	Sunday	8	August	3	2028	2028-08	32	1
20280814	2028-08-14	14	Monday	8	August	3	2028	2028-08	33	0
20280815	2028-08-15	15	Tuesday	8	August	3	2028	2028-08	33	0
20280816	2028-08-16	16	Wednesday	8	August	3	2028	2028-08	33	0
20280817	2028-08-17	17	Thursday	8	August	3	2028	2028-08	33	0
20280818	2028-08-18	18	Friday	8	August	3	2028	2028-08	33	0
20280819	2028-08-19	19	Saturday	8	August	3	2028	2028-08	33	1
20280820	2028-08-20	20	Sunday	8	August	3	2028	2028-08	33	1
20280821	2028-08-21	21	Monday	8	August	3	2028	2028-08	34	0
20280822	2028-08-22	22	Tuesday	8	August	3	2028	2028-08	34	0
20280823	2028-08-23	23	Wednesday	8	August	3	2028	2028-08	34	0
20280824	2028-08-24	24	Thursday	8	August	3	2028	2028-08	34	0
20280825	2028-08-25	25	Friday	8	August	3	2028	2028-08	34	0
20280826	2028-08-26	26	Saturday	8	August	3	2028	2028-08	34	1
20280827	2028-08-27	27	Sunday	8	August	3	2028	2028-08	34	1
20280828	2028-08-28	28	Monday	8	August	3	2028	2028-08	35	0
20280829	2028-08-29	29	Tuesday	8	August	3	2028	2028-08	35	0
20280830	2028-08-30	30	Wednesday	8	August	3	2028	2028-08	35	0
20280831	2028-08-31	31	Thursday	8	August	3	2028	2028-08	35	0
20280901	2028-09-01	1	Friday	9	September	3	2028	2028-09	35	0
20280902	2028-09-02	2	Saturday	9	September	3	2028	2028-09	35	1
20280903	2028-09-03	3	Sunday	9	September	3	2028	2028-09	35	1
20280904	2028-09-04	4	Monday	9	September	3	2028	2028-09	36	0
20280905	2028-09-05	5	Tuesday	9	September	3	2028	2028-09	36	0
20280906	2028-09-06	6	Wednesday	9	September	3	2028	2028-09	36	0
20280907	2028-09-07	7	Thursday	9	September	3	2028	2028-09	36	0
20280908	2028-09-08	8	Friday	9	September	3	2028	2028-09	36	0
20280909	2028-09-09	9	Saturday	9	September	3	2028	2028-09	36	1
20280910	2028-09-10	10	Sunday	9	September	3	2028	2028-09	36	1
20280911	2028-09-11	11	Monday	9	September	3	2028	2028-09	37	0
20280912	2028-09-12	12	Tuesday	9	September	3	2028	2028-09	37	0
20280913	2028-09-13	13	Wednesday	9	September	3	2028	2028-09	37	0
20280914	2028-09-14	14	Thursday	9	September	3	2028	2028-09	37	0
20280915	2028-09-15	15	Friday	9	September	3	2028	2028-09	37	0
20280916	2028-09-16	16	Saturday	9	September	3	2028	2028-09	37	1
20280917	2028-09-17	17	Sunday	9	September	3	2028	2028-09	37	1
20280918	2028-09-18	18	Monday	9	September	3	2028	2028-09	38	0
20280919	2028-09-19	19	Tuesday	9	September	3	2028	2028-09	38	0
20280920	2028-09-20	20	Wednesday	9	September	3	2028	2028-09	38	0
20280921	2028-09-21	21	Thursday	9	September	3	2028	2028-09	38	0
20280922	2028-09-22	22	Friday	9	September	3	2028	2028-09	38	0
20280923	2028-09-23	23	Saturday	9	September	3	2028	2028-09	38	1
20280924	2028-09-24	24	Sunday	9	September	3	2028	2028-09	38	1
20280925	2028-09-25	25	Monday	9	September	3	2028	2028-09	39	0
20280926	2028-09-26	26	Tuesday	9	September	3	2028	2028-09	39	0
20280927	2028-09-27	27	Wednesday	9	September	3	2028	2028-09	39	0
20280928	2028-09-28	28	Thursday	9	September	3	2028	2028-09	39	0
20280929	2028-09-29	29	Friday	9	September	3	2028	2028-09	39	0
20280930	2028-09-30	30	Saturday	9	September	3	2028	2028-09	39	1
20281001	2028-10-01	1	Sunday	10	October	4	2028	2028-10	39	1
20281002	2028-10-02	2	Monday	10	October	4	2028	2028-10	40	0
20281003	2028-10-03	3	Tuesday	10	October	4	2028	2028-10	40	0
20281004	2028-10-04	4	Wednesday	10	October	4	2028	2028-10	40	0
20281005	2028-10-05	5	Thursday	10	October	4	2028	2028-10	40	0
20281006	2028-10-06	6	Friday	10	October	4	2028	2028-10	40	0
20281007	2028-10-07	7	Saturday	10	October	4	2028	2028-10	40	1
20281008	2028-10-08	8	Sunday	10	October	4	2028	2028-10	40	1
20281009	2028-10-09	9	Monday	10	October	4	2028	2028-10	41	0
20281010	2028-10-10	10	Tuesday	10	October	4	2028	2028-10	41	0
20281011	2028-10-11	11	Wednesday	10	October	4	2028	2028-10	41	0
20281012	2028-10-12	12	Thursday	10	October	4	2028	2028-10	41	0
20281013	2028-10-13	13	Friday	10	October	4	2028	2028-10	41	0
20281014	2028-10-14	14	Saturday	10	October	4	2028	2028-10	41	1
20281015	2028-10-15	15	Sunday	10	October	4	2028	2028-10	41	1
20281016	2028-10-16	16	Monday	10	October	4	2028	2028-10	42	0
20281017	2028-10-17	17	Tuesday	10	October	4	2028	2028-10	42	0
20281018	2028-10-18	18	Wednesday	10	October	4	2028	2028-10	42	0
20281019	2028-10-19	19	Thursday	10	October	4	2028	2028-10	42	0
20281020	2028-10-20	20	Friday	10	October	4	2028	2028-10	42	0
20281021	2028-10-21	21	Saturday	10	October	4	2028	2028-10	42	1
20281022	2028-10-22	22	Sunday	10	October	4	2028	2028-10	42	1
20281023	2028-10-23	23	Monday	10	October	4	2028	2028-10	43	0
20281024	2028-10-24	24	Tuesday	10	October	4	2028	2028-10	43	0
20281025	2028-10-25	25	Wednesday	10	October	4	2028	2028-10	43	0
20281026	2028-10-26	26	Thursday	10	October	4	2028	2028-10	43	0
20281027	2028-10-27	27	Friday	10	October	4	2028	2028-10	43	0
20281028	2028-10-28	28	Saturday	10	October	4	2028	2028-10	43	1
20281029	2028-10-29	29	Sunday	10	October	4	2028	2028-10	43	1
20281030	2028-10-30	30	Monday	10	October	4	2028	2028-10	44	0
20281031	2028-10-31	31	Tuesday	10	October	4	2028	2028-10	44	0
20281101	2028-11-01	1	Wednesday	11	November	4	2028	2028-11	44	0
20281102	2028-11-02	2	Thursday	11	November	4	2028	2028-11	44	0
20281103	2028-11-03	3	Friday	11	November	4	2028	2028-11	44	0
20281104	2028-11-04	4	Saturday	11	November	4	2028	2028-11	44	1
20281105	2028-11-05	5	Sunday	11	November	4	2028	2028-11	44	1
20281106	2028-11-06	6	Monday	11	November	4	2028	2028-11	45	0
20281107	2028-11-07	7	Tuesday	11	November	4	2028	2028-11	45	0
20281108	2028-11-08	8	Wednesday	11	November	4	2028	2028-11	45	0
20281109	2028-11-09	9	Thursday	11	November	4	2028	2028-11	45	0
20281110	2028-11-10	10	Friday	11	November	4	2028	2028-11	45	0
20281111	2028-11-11	11	Saturday	11	November	4	2028	2028-11	45	1
20281112	2028-11-12	12	Sunday	11	November	4	2028	2028-11	45	1
20281113	2028-11-13	13	Monday	11	November	4	2028	2028-11	46	0
20281114	2028-11-14	14	Tuesday	11	November	4	2028	2028-11	46	0
20281115	2028-11-15	15	Wednesday	11	November	4	2028	2028-11	46	0
20281116	2028-11-16	16	Thursday	11	November	4	2028	2028-11	46	0
20281117	2028-11-17	17	Friday	11	November	4	2028	2028-11	46	0
20281118	2028-11-18	18	Saturday	11	November	4	2028	2028-11	46	1
20281119	2028-11-19	19	Sunday	11	November	4	2028	2028-11	46	1
20281120	2028-11-20	20	Monday	11	November	4	2028	2028-11	47	0
20281121	2028-11-21	21	Tuesday	11	November	4	2028	2028-11	47	0
20281122	2028-11-22	22	Wednesday	11	November	4	2028	2028-11	47	0
20281123	2028-11-23	23	Thursday	11	November	4	2028	2028-11	47	0
20281124	2028-11-24	24	Friday	11	November	4	2028	2028-11	47	0
20281125	2028-11-25	25	Saturday	11	November	4	2028	2028-11	47	1
20281126	2028-11-26	26	Sunday	11	November	4	2028	2028-11	47	1
20281127	2028-11-27	27	Monday	11	November	4	2028	2028-11	48	0
20281128	2028-11-28	28	Tuesday	11	November	4	2028	2028-11	48	0
20281129	2028-11-29	29	Wednesday	11	November	4	2028	2028-11	48	0
20281130	2028-11-30	30	Thursday	11	November	4	2028	2028-11	48	0
20281201	2028-12-01	1	Friday	12	December	4	2028	2028-12	48	0
20281202	2028-12-02	2	Saturday	12	December	4	2028	2028-12	48	1
20281203	2028-12-03	3	Sunday	12	December	4	2028	2028-12	48	1
20281204	2028-12-04	4	Monday	12	December	4	2028	2028-12	49	0
20281205	2028-12-05	5	Tuesday	12	December	4	2028	2028-12	49	0
20281206	2028-12-06	6	Wednesday	12	December	4	2028	2028-12	49	0
20281207	2028-12-07	7	Thursday	12	December	4	2028	2028-12	49	0
20281208	2028-12-08	8	Friday	12	December	4	2028	2028-12	49	0
20281209	2028-12-09	9	Saturday	12	December	4	2028	2028-12	49	1
20281210	2028-12-10	10	Sunday	12	December	4	2028	2028-12	49	1
20281211	2028-12-11	11	Monday	12	December	4	2028	2028-12	50	0
20281212	2028-12-12	12	Tuesday	12	December	4	2028	2028-12	50	0
20281213	2028-12-13	13	Wednesday	12	December	4	2028	2028-12	50	0
20281214	2028-12-14	14	Thursday	12	December	4	2028	2028-12	50	0
20281215	2028-12-15	15	Friday	12	December	4	2028	2028-12	50	0
20281216	2028-12-16	16	Saturday	12	December	4	2028	2028-12	50	1
20281217	2028-12-17	17	Sunday	12	December	4	2028	2028-12	50	1
20281218	2028-12-18	18	Monday	12	December	4	2028	2028-12	51	0
20281219	2028-12-19	19	Tuesday	12	December	4	2028	2028-12	51	0
20281220	2028-12-20	20	Wednesday	12	December	4	2028	2028-12	51	0
20281221	2028-12-21	21	Thursday	12	December	4	2028	2028-12	51	0
20281222	2028-12-22	22	Friday	12	December	4	2028	2028-12	51	0
20281223	2028-12-23	23	Saturday	12	December	4	2028	2028-12	51	1
20281224	2028-12-24	24	Sunday	12	December	4	2028	2028-12	51	1
20281225	2028-12-25	25	Monday	12	December	4	2028	2028-12	52	0
20281226	2028-12-26	26	Tuesday	12	December	4	2028	2028-12	52	0
20281227	2028-12-27	27	Wednesday	12	December	4	2028	2028-12	52	0
20281228	2028-12-28	28	Thursday	12	December	4	2028	2028-12	52	0
20281229	2028-12-29	29	Friday	12	December	4	2028	2028-12	52	0
20281230	2028-12-30	30	Saturday	12	December	4	2028	2028-12	52	1
20281231	2028-12-31	31	Sunday	12	December	4	2028	2028-12	52	1
20290101	2029-01-01	1	Monday	1	January	1	2029	2029-01	1	0
20290102	2029-01-02	2	Tuesday	1	January	1	2029	2029-01	1	0
20290103	2029-01-03	3	Wednesday	1	January	1	2029	2029-01	1	0
20290104	2029-01-04	4	Thursday	1	January	1	2029	2029-01	1	0
20290105	2029-01-05	5	Friday	1	January	1	2029	2029-01	1	0
20290106	2029-01-06	6	Saturday	1	January	1	2029	2029-01	1	1
20290107	2029-01-07	7	Sunday	1	January	1	2029	2029-01	1	1
20290108	2029-01-08	8	Monday	1	January	1	2029	2029-01	2	0
20290109	2029-01-09	9	Tuesday	1	January	1	2029	2029-01	2	0
20290110	2029-01-10	10	Wednesday	1	January	1	2029	2029-01	2	0
20290111	2029-01-11	11	Thursday	1	January	1	2029	2029-01	2	0
20290112	2029-01-12	12	Friday	1	January	1	2029	2029-01	2	0
20290113	2029-01-13	13	Saturday	1	January	1	2029	2029-01	2	1
20290114	2029-01-14	14	Sunday	1	January	1	2029	2029-01	2	1
20290115	2029-01-15	15	Monday	1	January	1	2029	2029-01	3	0
20290116	2029-01-16	16	Tuesday	1	January	1	2029	2029-01	3	0
20290117	2029-01-17	17	Wednesday	1	January	1	2029	2029-01	3	0
20290118	2029-01-18	18	Thursday	1	January	1	2029	2029-01	3	0
20290119	2029-01-19	19	Friday	1	January	1	2029	2029-01	3	0
20290120	2029-01-20	20	Saturday	1	January	1	2029	2029-01	3	1
20290121	2029-01-21	21	Sunday	1	January	1	2029	2029-01	3	1
20290122	2029-01-22	22	Monday	1	January	1	2029	2029-01	4	0
20290123	2029-01-23	23	Tuesday	1	January	1	2029	2029-01	4	0
20290124	2029-01-24	24	Wednesday	1	January	1	2029	2029-01	4	0
20290125	2029-01-25	25	Thursday	1	January	1	2029	2029-01	4	0
20290126	2029-01-26	26	Friday	1	January	1	2029	2029-01	4	0
20290127	2029-01-27	27	Saturday	1	January	1	2029	2029-01	4	1
20290128	2029-01-28	28	Sunday	1	January	1	2029	2029-01	4	1
20290129	2029-01-29	29	Monday	1	January	1	2029	2029-01	5	0
20290130	2029-01-30	30	Tuesday	1	January	1	2029	2029-01	5	0
20290131	2029-01-31	31	Wednesday	1	January	1	2029	2029-01	5	0
20290201	2029-02-01	1	Thursday	2	February	1	2029	2029-02	5	0
20290202	2029-02-02	2	Friday	2	February	1	2029	2029-02	5	0
20290203	2029-02-03	3	Saturday	2	February	1	2029	2029-02	5	1
20290204	2029-02-04	4	Sunday	2	February	1	2029	2029-02	5	1
20290205	2029-02-05	5	Monday	2	February	1	2029	2029-02	6	0
20290206	2029-02-06	6	Tuesday	2	February	1	2029	2029-02	6	0
20290207	2029-02-07	7	Wednesday	2	February	1	2029	2029-02	6	0
20290208	2029-02-08	8	Thursday	2	February	1	2029	2029-02	6	0
20290209	2029-02-09	9	Friday	2	February	1	2029	2029-02	6	0
20290210	2029-02-10	10	Saturday	2	February	1	2029	2029-02	6	1
20290211	2029-02-11	11	Sunday	2	February	1	2029	2029-02	6	1
20290212	2029-02-12	12	Monday	2	February	1	2029	2029-02	7	0
20290213	2029-02-13	13	Tuesday	2	February	1	2029	2029-02	7	0
20290214	2029-02-14	14	Wednesday	2	February	1	2029	2029-02	7	0
20290215	2029-02-15	15	Thursday	2	February	1	2029	2029-02	7	0
20290216	2029-02-16	16	Friday	2	February	1	2029	2029-02	7	0
20290217	2029-02-17	17	Saturday	2	February	1	2029	2029-02	7	1
20290218	2029-02-18	18	Sunday	2	February	1	2029	2029-02	7	1
20290219	2029-02-19	19	Monday	2	February	1	2029	2029-02	8	0
20290220	2029-02-20	20	Tuesday	2	February	1	2029	2029-02	8	0
20290221	2029-02-21	21	Wednesday	2	February	1	2029	2029-02	8	0
20290222	2029-02-22	22	Thursday	2	February	1	2029	2029-02	8	0
20290223	2029-02-23	23	Friday	2	February	1	2029	2029-02	8	0
20290224	2029-02-24	24	Saturday	2	February	1	2029	2029-02	8	1
20290225	2029-02-25	25	Sunday	2	February	1	2029	2029-02	8	1
20290226	2029-02-26	26	Monday	2	February	1	2029	2029-02	9	0
20290227	2029-02-27	27	Tuesday	2	February	1	2029	2029-02	9	0
20290228	2029-02-28	28	Wednesday	2	February	1	2029	2029-02	9	0
20290301	2029-03-01	1	Thursday	3	March	1	2029	2029-03	9	0
20290302	2029-03-02	2	Friday	3	March	1	2029	2029-03	9	0
20290303	2029-03-03	3	Saturday	3	March	1	2029	2029-03	9	1
20290304	2029-03-04	4	Sunday	3	March	1	2029	2029-03	9	1
20290305	2029-03-05	5	Monday	3	March	1	2029	2029-03	10	0
20290306	2029-03-06	6	Tuesday	3	March	1	2029	2029-03	10	0
20290307	2029-03-07	7	Wednesday	3	March	1	2029	2029-03	10	0
20290308	2029-03-08	8	Thursday	3	March	1	2029	2029-03	10	0
20290309	2029-03-09	9	Friday	3	March	1	2029	2029-03	10	0
20290310	2029-03-10	10	Saturday	3	March	1	2029	2029-03	10	1
20290311	2029-03-11	11	Sunday	3	March	1	2029	2029-03	10	1
20290312	2029-03-12	12	Monday	3	March	1	2029	2029-03	11	0
20290313	2029-03-13	13	Tuesday	3	March	1	2029	2029-03	11	0
20290314	2029-03-14	14	Wednesday	3	March	1	2029	2029-03	11	0
20290315	2029-03-15	15	Thursday	3	March	1	2029	2029-03	11	0
20290316	2029-03-16	16	Friday	3	March	1	2029	2029-03	11	0
20290317	2029-03-17	17	Saturday	3	March	1	2029	2029-03	11	1
20290318	2029-03-18	18	Sunday	3	March	1	2029	2029-03	11	1
20290319	2029-03-19	19	Monday	3	March	1	2029	2029-03	12	0
20290320	2029-03-20	20	Tuesday	3	March	1	2029	2029-03	12	0
20290321	2029-03-21	21	Wednesday	3	March	1	2029	2029-03	12	0
20290322	2029-03-22	22	Thursday	3	March	1	2029	2029-03	12	0
20290323	2029-03-23	23	Friday	3	March	1	2029	2029-03	12	0
20290324	2029-03-24	24	Saturday	3	March	1	2029	2029-03	12	1
20290325	2029-03-25	25	Sunday	3	March	1	2029	2029-03	12	1
20290326	2029-03-26	26	Monday	3	March	1	2029	2029-03	13	0
20290327	2029-03-27	27	Tuesday	3	March	1	2029	2029-03	13	0
20290328	2029-03-28	28	Wednesday	3	March	1	2029	2029-03	13	0
20290329	2029-03-29	29	Thursday	3	March	1	2029	2029-03	13	0
20290330	2029-03-30	30	Friday	3	March	1	2029	2029-03	13	0
20290331	2029-03-31	31	Saturday	3	March	1	2029	2029-03	13	1
20290401	2029-04-01	1	Sunday	4	April	2	2029	2029-04	13	1
20290402	2029-04-02	2	Monday	4	April	2	2029	2029-04	14	0
20290403	2029-04-03	3	Tuesday	4	April	2	2029	2029-04	14	0
20290404	2029-04-04	4	Wednesday	4	April	2	2029	2029-04	14	0
20290405	2029-04-05	5	Thursday	4	April	2	2029	2029-04	14	0
20290406	2029-04-06	6	Friday	4	April	2	2029	2029-04	14	0
20290407	2029-04-07	7	Saturday	4	April	2	2029	2029-04	14	1
20290408	2029-04-08	8	Sunday	4	April	2	2029	2029-04	14	1
20290409	2029-04-09	9	Monday	4	April	2	2029	2029-04	15	0
20290410	2029-04-10	10	Tuesday	4	April	2	2029	2029-04	15	0
20290411	2029-04-11	11	Wednesday	4	April	2	2029	2029-04	15	0
20290412	2029-04-12	12	Thursday	4	April	2	2029	2029-04	15	0
20290413	2029-04-13	13	Friday	4	April	2	2029	2029-04	15	0
20290414	2029-04-14	14	Saturday	4	April	2	2029	2029-04	15	1
20290415	2029-04-15	15	Sunday	4	April	2	2029	2029-04	15	1
20290416	2029-04-16	16	Monday	4	April	2	2029	2029-04	16	0
20290417	2029-04-17	17	Tuesday	4	April	2	2029	2029-04	16	0
20290418	2029-04-18	18	Wednesday	4	April	2	2029	2029-04	16	0
20290419	2029-04-19	19	Thursday	4	April	2	2029	2029-04	16	0
20290420	2029-04-20	20	Friday	4	April	2	2029	2029-04	16	0
20290421	2029-04-21	21	Saturday	4	April	2	2029	2029-04	16	1
20290422	2029-04-22	22	Sunday	4	April	2	2029	2029-04	16	1
20290423	2029-04-23	23	Monday	4	April	2	2029	2029-04	17	0
20290424	2029-04-24	24	Tuesday	4	April	2	2029	2029-04	17	0
20290425	2029-04-25	25	Wednesday	4	April	2	2029	2029-04	17	0
20290426	2029-04-26	26	Thursday	4	April	2	2029	2029-04	17	0
20290427	2029-04-27	27	Friday	4	April	2	2029	2029-04	17	0
20290428	2029-04-28	28	Saturday	4	April	2	2029	2029-04	17	1
20290429	2029-04-29	29	Sunday	4	April	2	2029	2029-04	17	1
20290430	2029-04-30	30	Monday	4	April	2	2029	2029-04	18	0
20290501	2029-05-01	1	Tuesday	5	May	2	2029	2029-05	18	0
20290502	2029-05-02	2	Wednesday	5	May	2	2029	2029-05	18	0
20290503	2029-05-03	3	Thursday	5	May	2	2029	2029-05	18	0
20290504	2029-05-04	4	Friday	5	May	2	2029	2029-05	18	0
20290505	2029-05-05	5	Saturday	5	May	2	2029	2029-05	18	1
20290506	2029-05-06	6	Sunday	5	May	2	2029	2029-05	18	1
20290507	2029-05-07	7	Monday	5	May	2	2029	2029-05	19	0
20290508	2029-05-08	8	Tuesday	5	May	2	2029	2029-05	19	0
20290509	2029-05-09	9	Wednesday	5	May	2	2029	2029-05	19	0
20290510	2029-05-10	10	Thursday	5	May	2	2029	2029-05	19	0
20290511	2029-05-11	11	Friday	5	May	2	2029	2029-05	19	0
20290512	2029-05-12	12	Saturday	5	May	2	2029	2029-05	19	1
20290513	2029-05-13	13	Sunday	5	May	2	2029	2029-05	19	1
20290514	2029-05-14	14	Monday	5	May	2	2029	2029-05	20	0
20290515	2029-05-15	15	Tuesday	5	May	2	2029	2029-05	20	0
20290516	2029-05-16	16	Wednesday	5	May	2	2029	2029-05	20	0
20290517	2029-05-17	17	Thursday	5	May	2	2029	2029-05	20	0
20290518	2029-05-18	18	Friday	5	May	2	2029	2029-05	20	0
20290519	2029-05-19	19	Saturday	5	May	2	2029	2029-05	20	1
20290520	2029-05-20	20	Sunday	5	May	2	2029	2029-05	20	1
20290521	2029-05-21	21	Monday	5	May	2	2029	2029-05	21	0
20290522	2029-05-22	22	Tuesday	5	May	2	2029	2029-05	21	0
20290523	2029-05-23	23	Wednesday	5	May	2	2029	2029-05	21	0
20290524	2029-05-24	24	Thursday	5	May	2	2029	2029-05	21	0
20290525	2029-05-25	25	Friday	5	May	2	2029	2029-05	21	0
20290526	2029-05-26	26	Saturday	5	May	2	2029	2029-05	21	1
20290527	2029-05-27	27	Sunday	5	May	2	2029	2029-05	21	1
20290528	2029-05-28	28	Monday	5	May	2	2029	2029-05	22	0
20290529	2029-05-29	29	Tuesday	5	May	2	2029	2029-05	22	0
20290530	2029-05-30	30	Wednesday	5	May	2	2029	2029-05	22	0
20290531	2029-05-31	31	Thursday	5	May	2	2029	2029-05	22	0
20290601	2029-06-01	1	Friday	6	June	2	2029	2029-06	22	0
20290602	2029-06-02	2	Saturday	6	June	2	2029	2029-06	22	1
20290603	2029-06-03	3	Sunday	6	June	2	2029	2029-06	22	1
20290604	2029-06-04	4	Monday	6	June	2	2029	2029-06	23	0
20290605	2029-06-05	5	Tuesday	6	June	2	2029	2029-06	23	0
20290606	2029-06-06	6	Wednesday	6	June	2	2029	2029-06	23	0
20290607	2029-06-07	7	Thursday	6	June	2	2029	2029-06	23	0
20290608	2029-06-08	8	Friday	6	June	2	2029	2029-06	23	0
20290609	2029-06-09	9	Saturday	6	June	2	2029	2029-06	23	1
20290610	2029-06-10	10	Sunday	6	June	2	2029	2029-06	23	1
20290611	2029-06-11	11	Monday	6	June	2	2029	2029-06	24	0
20290612	2029-06-12	12	Tuesday	6	June	2	2029	2029-06	24	0
20290613	2029-06-13	13	Wednesday	6	June	2	2029	2029-06	24	0
20290614	2029-06-14	14	Thursday	6	June	2	2029	2029-06	24	0
20290615	2029-06-15	15	Friday	6	June	2	2029	2029-06	24	0
20290616	2029-06-16	16	Saturday	6	June	2	2029	2029-06	24	1
20290617	2029-06-17	17	Sunday	6	June	2	2029	2029-06	24	1
20290618	2029-06-18	18	Monday	6	June	2	2029	2029-06	25	0
20290619	2029-06-19	19	Tuesday	6	June	2	2029	2029-06	25	0
20290620	2029-06-20	20	Wednesday	6	June	2	2029	2029-06	25	0
20290621	2029-06-21	21	Thursday	6	June	2	2029	2029-06	25	0
20290622	2029-06-22	22	Friday	6	June	2	2029	2029-06	25	0
20290623	2029-06-23	23	Saturday	6	June	2	2029	2029-06	25	1
20290624	2029-06-24	24	Sunday	6	June	2	2029	2029-06	25	1
20290625	2029-06-25	25	Monday	6	June	2	2029	2029-06	26	0
20290626	2029-06-26	26	Tuesday	6	June	2	2029	2029-06	26	0
20290627	2029-06-27	27	Wednesday	6	June	2	2029	2029-06	26	0
20290628	2029-06-28	28	Thursday	6	June	2	2029	2029-06	26	0
20290629	2029-06-29	29	Friday	6	June	2	2029	2029-06	26	0
20290630	2029-06-30	30	Saturday	6	June	2	2029	2029-06	26	1
20290701	2029-07-01	1	Sunday	7	July	3	2029	2029-07	26	1
20290702	2029-07-02	2	Monday	7	July	3	2029	2029-07	27	0
20290703	2029-07-03	3	Tuesday	7	July	3	2029	2029-07	27	0
20290704	2029-07-04	4	Wednesday	7	July	3	2029	2029-07	27	0
20290705	2029-07-05	5	Thursday	7	July	3	2029	2029-07	27	0
20290706	2029-07-06	6	Friday	7	July	3	2029	2029-07	27	0
20290707	2029-07-07	7	Saturday	7	July	3	2029	2029-07	27	1
20290708	2029-07-08	8	Sunday	7	July	3	2029	2029-07	27	1
20290709	2029-07-09	9	Monday	7	July	3	2029	2029-07	28	0
20290710	2029-07-10	10	Tuesday	7	July	3	2029	2029-07	28	0
20290711	2029-07-11	11	Wednesday	7	July	3	2029	2029-07	28	0
20290712	2029-07-12	12	Thursday	7	July	3	2029	2029-07	28	0
20290713	2029-07-13	13	Friday	7	July	3	2029	2029-07	28	0
20290714	2029-07-14	14	Saturday	7	July	3	2029	2029-07	28	1
20290715	2029-07-15	15	Sunday	7	July	3	2029	2029-07	28	1
20290716	2029-07-16	16	Monday	7	July	3	2029	2029-07	29	0
20290717	2029-07-17	17	Tuesday	7	July	3	2029	2029-07	29	0
20290718	2029-07-18	18	Wednesday	7	July	3	2029	2029-07	29	0
20290719	2029-07-19	19	Thursday	7	July	3	2029	2029-07	29	0
20290720	2029-07-20	20	Friday	7	July	3	2029	2029-07	29	0
20290721	2029-07-21	21	Saturday	7	July	3	2029	2029-07	29	1
20290722	2029-07-22	22	Sunday	7	July	3	2029	2029-07	29	1
20290723	2029-07-23	23	Monday	7	July	3	2029	2029-07	30	0
20290724	2029-07-24	24	Tuesday	7	July	3	2029	2029-07	30	0
20290725	2029-07-25	25	Wednesday	7	July	3	2029	2029-07	30	0
20290726	2029-07-26	26	Thursday	7	July	3	2029	2029-07	30	0
20290727	2029-07-27	27	Friday	7	July	3	2029	2029-07	30	0
20290728	2029-07-28	28	Saturday	7	July	3	2029	2029-07	30	1
20290729	2029-07-29	29	Sunday	7	July	3	2029	2029-07	30	1
20290730	2029-07-30	30	Monday	7	July	3	2029	2029-07	31	0
20290731	2029-07-31	31	Tuesday	7	July	3	2029	2029-07	31	0
20290801	2029-08-01	1	Wednesday	8	August	3	2029	2029-08	31	0
20290802	2029-08-02	2	Thursday	8	August	3	2029	2029-08	31	0
20290803	2029-08-03	3	Friday	8	August	3	2029	2029-08	31	0
20290804	2029-08-04	4	Saturday	8	August	3	2029	2029-08	31	1
20290805	2029-08-05	5	Sunday	8	August	3	2029	2029-08	31	1
20290806	2029-08-06	6	Monday	8	August	3	2029	2029-08	32	0
20290807	2029-08-07	7	Tuesday	8	August	3	2029	2029-08	32	0
20290808	2029-08-08	8	Wednesday	8	August	3	2029	2029-08	32	0
20290809	2029-08-09	9	Thursday	8	August	3	2029	2029-08	32	0
20290810	2029-08-10	10	Friday	8	August	3	2029	2029-08	32	0
20290811	2029-08-11	11	Saturday	8	August	3	2029	2029-08	32	1
20290812	2029-08-12	12	Sunday	8	August	3	2029	2029-08	32	1
20290813	2029-08-13	13	Monday	8	August	3	2029	2029-08	33	0
20290814	2029-08-14	14	Tuesday	8	August	3	2029	2029-08	33	0
20290815	2029-08-15	15	Wednesday	8	August	3	2029	2029-08	33	0
20290816	2029-08-16	16	Thursday	8	August	3	2029	2029-08	33	0
20290817	2029-08-17	17	Friday	8	August	3	2029	2029-08	33	0
20290818	2029-08-18	18	Saturday	8	August	3	2029	2029-08	33	1
20290819	2029-08-19	19	Sunday	8	August	3	2029	2029-08	33	1
20290820	2029-08-20	20	Monday	8	August	3	2029	2029-08	34	0
20290821	2029-08-21	21	Tuesday	8	August	3	2029	2029-08	34	0
20290822	2029-08-22	22	Wednesday	8	August	3	2029	2029-08	34	0
20290823	2029-08-23	23	Thursday	8	August	3	2029	2029-08	34	0
20290824	2029-08-24	24	Friday	8	August	3	2029	2029-08	34	0
20290825	2029-08-25	25	Saturday	8	August	3	2029	2029-08	34	1
20290826	2029-08-26	26	Sunday	8	August	3	2029	2029-08	34	1
20290827	2029-08-27	27	Monday	8	August	3	2029	2029-08	35	0
20290828	2029-08-28	28	Tuesday	8	August	3	2029	2029-08	35	0
20290829	2029-08-29	29	Wednesday	8	August	3	2029	2029-08	35	0
20290830	2029-08-30	30	Thursday	8	August	3	2029	2029-08	35	0
20290831	2029-08-31	31	Friday	8	August	3	2029	2029-08	35	0
20290901	2029-09-01	1	Saturday	9	September	3	2029	2029-09	35	1
20290902	2029-09-02	2	Sunday	9	September	3	2029	2029-09	35	1
20290903	2029-09-03	3	Monday	9	September	3	2029	2029-09	36	0
20290904	2029-09-04	4	Tuesday	9	September	3	2029	2029-09	36	0
20290905	2029-09-05	5	Wednesday	9	September	3	2029	2029-09	36	0
20290906	2029-09-06	6	Thursday	9	September	3	2029	2029-09	36	0
20290907	2029-09-07	7	Friday	9	September	3	2029	2029-09	36	0
20290908	2029-09-08	8	Saturday	9	September	3	2029	2029-09	36	1
20290909	2029-09-09	9	Sunday	9	September	3	2029	2029-09	36	1
20290910	2029-09-10	10	Monday	9	September	3	2029	2029-09	37	0
20290911	2029-09-11	11	Tuesday	9	September	3	2029	2029-09	37	0
20290912	2029-09-12	12	Wednesday	9	September	3	2029	2029-09	37	0
20290913	2029-09-13	13	Thursday	9	September	3	2029	2029-09	37	0
20290914	2029-09-14	14	Friday	9	September	3	2029	2029-09	37	0
20290915	2029-09-15	15	Saturday	9	September	3	2029	2029-09	37	1
20290916	2029-09-16	16	Sunday	9	September	3	2029	2029-09	37	1
20290917	2029-09-17	17	Monday	9	September	3	2029	2029-09	38	0
20290918	2029-09-18	18	Tuesday	9	September	3	2029	2029-09	38	0
20290919	2029-09-19	19	Wednesday	9	September	3	2029	2029-09	38	0
20290920	2029-09-20	20	Thursday	9	September	3	2029	2029-09	38	0
20290921	2029-09-21	21	Friday	9	September	3	2029	2029-09	38	0
20290922	2029-09-22	22	Saturday	9	September	3	2029	2029-09	38	1
20290923	2029-09-23	23	Sunday	9	September	3	2029	2029-09	38	1
20290924	2029-09-24	24	Monday	9	September	3	2029	2029-09	39	0
20290925	2029-09-25	25	Tuesday	9	September	3	2029	2029-09	39	0
20290926	2029-09-26	26	Wednesday	9	September	3	2029	2029-09	39	0
20290927	2029-09-27	27	Thursday	9	September	3	2029	2029-09	39	0
20290928	2029-09-28	28	Friday	9	September	3	2029	2029-09	39	0
20290929	2029-09-29	29	Saturday	9	September	3	2029	2029-09	39	1
20290930	2029-09-30	30	Sunday	9	September	3	2029	2029-09	39	1
20291001	2029-10-01	1	Monday	10	October	4	2029	2029-10	40	0
20291002	2029-10-02	2	Tuesday	10	October	4	2029	2029-10	40	0
20291003	2029-10-03	3	Wednesday	10	October	4	2029	2029-10	40	0
20291004	2029-10-04	4	Thursday	10	October	4	2029	2029-10	40	0
20291005	2029-10-05	5	Friday	10	October	4	2029	2029-10	40	0
20291006	2029-10-06	6	Saturday	10	October	4	2029	2029-10	40	1
20291007	2029-10-07	7	Sunday	10	October	4	2029	2029-10	40	1
20291008	2029-10-08	8	Monday	10	October	4	2029	2029-10	41	0
20291009	2029-10-09	9	Tuesday	10	October	4	2029	2029-10	41	0
20291010	2029-10-10	10	Wednesday	10	October	4	2029	2029-10	41	0
20291011	2029-10-11	11	Thursday	10	October	4	2029	2029-10	41	0
20291012	2029-10-12	12	Friday	10	October	4	2029	2029-10	41	0
20291013	2029-10-13	13	Saturday	10	October	4	2029	2029-10	41	1
20291014	2029-10-14	14	Sunday	10	October	4	2029	2029-10	41	1
20291015	2029-10-15	15	Monday	10	October	4	2029	2029-10	42	0
20291016	2029-10-16	16	Tuesday	10	October	4	2029	2029-10	42	0
20291017	2029-10-17	17	Wednesday	10	October	4	2029	2029-10	42	0
20291018	2029-10-18	18	Thursday	10	October	4	2029	2029-10	42	0
20291019	2029-10-19	19	Friday	10	October	4	2029	2029-10	42	0
20291020	2029-10-20	20	Saturday	10	October	4	2029	2029-10	42	1
20291021	2029-10-21	21	Sunday	10	October	4	2029	2029-10	42	1
20291022	2029-10-22	22	Monday	10	October	4	2029	2029-10	43	0
20291023	2029-10-23	23	Tuesday	10	October	4	2029	2029-10	43	0
20291024	2029-10-24	24	Wednesday	10	October	4	2029	2029-10	43	0
20291025	2029-10-25	25	Thursday	10	October	4	2029	2029-10	43	0
20291026	2029-10-26	26	Friday	10	October	4	2029	2029-10	43	0
20291027	2029-10-27	27	Saturday	10	October	4	2029	2029-10	43	1
20291028	2029-10-28	28	Sunday	10	October	4	2029	2029-10	43	1
20291029	2029-10-29	29	Monday	10	October	4	2029	2029-10	44	0
20291030	2029-10-30	30	Tuesday	10	October	4	2029	2029-10	44	0
20291031	2029-10-31	31	Wednesday	10	October	4	2029	2029-10	44	0
20291101	2029-11-01	1	Thursday	11	November	4	2029	2029-11	44	0
20291102	2029-11-02	2	Friday	11	November	4	2029	2029-11	44	0
20291103	2029-11-03	3	Saturday	11	November	4	2029	2029-11	44	1
20291104	2029-11-04	4	Sunday	11	November	4	2029	2029-11	44	1
20291105	2029-11-05	5	Monday	11	November	4	2029	2029-11	45	0
20291106	2029-11-06	6	Tuesday	11	November	4	2029	2029-11	45	0
20291107	2029-11-07	7	Wednesday	11	November	4	2029	2029-11	45	0
20291108	2029-11-08	8	Thursday	11	November	4	2029	2029-11	45	0
20291109	2029-11-09	9	Friday	11	November	4	2029	2029-11	45	0
20291110	2029-11-10	10	Saturday	11	November	4	2029	2029-11	45	1
20291111	2029-11-11	11	Sunday	11	November	4	2029	2029-11	45	1
20291112	2029-11-12	12	Monday	11	November	4	2029	2029-11	46	0
20291113	2029-11-13	13	Tuesday	11	November	4	2029	2029-11	46	0
20291114	2029-11-14	14	Wednesday	11	November	4	2029	2029-11	46	0
20291115	2029-11-15	15	Thursday	11	November	4	2029	2029-11	46	0
20291116	2029-11-16	16	Friday	11	November	4	2029	2029-11	46	0
20291117	2029-11-17	17	Saturday	11	November	4	2029	2029-11	46	1
20291118	2029-11-18	18	Sunday	11	November	4	2029	2029-11	46	1
20291119	2029-11-19	19	Monday	11	November	4	2029	2029-11	47	0
20291120	2029-11-20	20	Tuesday	11	November	4	2029	2029-11	47	0
20291121	2029-11-21	21	Wednesday	11	November	4	2029	2029-11	47	0
20291122	2029-11-22	22	Thursday	11	November	4	2029	2029-11	47	0
20291123	2029-11-23	23	Friday	11	November	4	2029	2029-11	47	0
20291124	2029-11-24	24	Saturday	11	November	4	2029	2029-11	47	1
20291125	2029-11-25	25	Sunday	11	November	4	2029	2029-11	47	1
20291126	2029-11-26	26	Monday	11	November	4	2029	2029-11	48	0
20291127	2029-11-27	27	Tuesday	11	November	4	2029	2029-11	48	0
20291128	2029-11-28	28	Wednesday	11	November	4	2029	2029-11	48	0
20291129	2029-11-29	29	Thursday	11	November	4	2029	2029-11	48	0
20291130	2029-11-30	30	Friday	11	November	4	2029	2029-11	48	0
20291201	2029-12-01	1	Saturday	12	December	4	2029	2029-12	48	1
20291202	2029-12-02	2	Sunday	12	December	4	2029	2029-12	48	1
20291203	2029-12-03	3	Monday	12	December	4	2029	2029-12	49	0
20291204	2029-12-04	4	Tuesday	12	December	4	2029	2029-12	49	0
20291205	2029-12-05	5	Wednesday	12	December	4	2029	2029-12	49	0
20291206	2029-12-06	6	Thursday	12	December	4	2029	2029-12	49	0
20291207	2029-12-07	7	Friday	12	December	4	2029	2029-12	49	0
20291208	2029-12-08	8	Saturday	12	December	4	2029	2029-12	49	1
20291209	2029-12-09	9	Sunday	12	December	4	2029	2029-12	49	1
20291210	2029-12-10	10	Monday	12	December	4	2029	2029-12	50	0
20291211	2029-12-11	11	Tuesday	12	December	4	2029	2029-12	50	0
20291212	2029-12-12	12	Wednesday	12	December	4	2029	2029-12	50	0
20291213	2029-12-13	13	Thursday	12	December	4	2029	2029-12	50	0
20291214	2029-12-14	14	Friday	12	December	4	2029	2029-12	50	0
20291215	2029-12-15	15	Saturday	12	December	4	2029	2029-12	50	1
20291216	2029-12-16	16	Sunday	12	December	4	2029	2029-12	50	1
20291217	2029-12-17	17	Monday	12	December	4	2029	2029-12	51	0
20291218	2029-12-18	18	Tuesday	12	December	4	2029	2029-12	51	0
20291219	2029-12-19	19	Wednesday	12	December	4	2029	2029-12	51	0
20291220	2029-12-20	20	Thursday	12	December	4	2029	2029-12	51	0
20291221	2029-12-21	21	Friday	12	December	4	2029	2029-12	51	0
20291222	2029-12-22	22	Saturday	12	December	4	2029	2029-12	51	1
20291223	2029-12-23	23	Sunday	12	December	4	2029	2029-12	51	1
20291224	2029-12-24	24	Monday	12	December	4	2029	2029-12	52	0
20291225	2029-12-25	25	Tuesday	12	December	4	2029	2029-12	52	0
20291226	2029-12-26	26	Wednesday	12	December	4	2029	2029-12	52	0
20291227	2029-12-27	27	Thursday	12	December	4	2029	2029-12	52	0
20291228	2029-12-28	28	Friday	12	December	4	2029	2029-12	52	0
20291229	2029-12-29	29	Saturday	12	December	4	2029	2029-12	52	1
20291230	2029-12-30	30	Sunday	12	December	4	2029	2029-12	52	1
20291231	2029-12-31	31	Monday	12	December	4	2029	2029-12	1	0
20300101	2030-01-01	1	Tuesday	1	January	1	2030	2030-01	1	0
20300102	2030-01-02	2	Wednesday	1	January	1	2030	2030-01	1	0
20300103	2030-01-03	3	Thursday	1	January	1	2030	2030-01	1	0
20300104	2030-01-04	4	Friday	1	January	1	2030	2030-01	1	0
20300105	2030-01-05	5	Saturday	1	January	1	2030	2030-01	1	1
20300106	2030-01-06	6	Sunday	1	January	1	2030	2030-01	1	1
20300107	2030-01-07	7	Monday	1	January	1	2030	2030-01	2	0
20300108	2030-01-08	8	Tuesday	1	January	1	2030	2030-01	2	0
20300109	2030-01-09	9	Wednesday	1	January	1	2030	2030-01	2	0
20300110	2030-01-10	10	Thursday	1	January	1	2030	2030-01	2	0
20300111	2030-01-11	11	Friday	1	January	1	2030	2030-01	2	0
20300112	2030-01-12	12	Saturday	1	January	1	2030	2030-01	2	1
20300113	2030-01-13	13	Sunday	1	January	1	2030	2030-01	2	1
20300114	2030-01-14	14	Monday	1	January	1	2030	2030-01	3	0
20300115	2030-01-15	15	Tuesday	1	January	1	2030	2030-01	3	0
20300116	2030-01-16	16	Wednesday	1	January	1	2030	2030-01	3	0
20300117	2030-01-17	17	Thursday	1	January	1	2030	2030-01	3	0
20300118	2030-01-18	18	Friday	1	January	1	2030	2030-01	3	0
20300119	2030-01-19	19	Saturday	1	January	1	2030	2030-01	3	1
20300120	2030-01-20	20	Sunday	1	January	1	2030	2030-01	3	1
20300121	2030-01-21	21	Monday	1	January	1	2030	2030-01	4	0
20300122	2030-01-22	22	Tuesday	1	January	1	2030	2030-01	4	0
20300123	2030-01-23	23	Wednesday	1	January	1	2030	2030-01	4	0
20300124	2030-01-24	24	Thursday	1	January	1	2030	2030-01	4	0
20300125	2030-01-25	25	Friday	1	January	1	2030	2030-01	4	0
20300126	2030-01-26	26	Saturday	1	January	1	2030	2030-01	4	1
20300127	2030-01-27	27	Sunday	1	January	1	2030	2030-01	4	1
20300128	2030-01-28	28	Monday	1	January	1	2030	2030-01	5	0
20300129	2030-01-29	29	Tuesday	1	January	1	2030	2030-01	5	0
20300130	2030-01-30	30	Wednesday	1	January	1	2030	2030-01	5	0
20300131	2030-01-31	31	Thursday	1	January	1	2030	2030-01	5	0
20300201	2030-02-01	1	Friday	2	February	1	2030	2030-02	5	0
20300202	2030-02-02	2	Saturday	2	February	1	2030	2030-02	5	1
20300203	2030-02-03	3	Sunday	2	February	1	2030	2030-02	5	1
20300204	2030-02-04	4	Monday	2	February	1	2030	2030-02	6	0
20300205	2030-02-05	5	Tuesday	2	February	1	2030	2030-02	6	0
20300206	2030-02-06	6	Wednesday	2	February	1	2030	2030-02	6	0
20300207	2030-02-07	7	Thursday	2	February	1	2030	2030-02	6	0
20300208	2030-02-08	8	Friday	2	February	1	2030	2030-02	6	0
20300209	2030-02-09	9	Saturday	2	February	1	2030	2030-02	6	1
20300210	2030-02-10	10	Sunday	2	February	1	2030	2030-02	6	1
20300211	2030-02-11	11	Monday	2	February	1	2030	2030-02	7	0
20300212	2030-02-12	12	Tuesday	2	February	1	2030	2030-02	7	0
20300213	2030-02-13	13	Wednesday	2	February	1	2030	2030-02	7	0
20300214	2030-02-14	14	Thursday	2	February	1	2030	2030-02	7	0
20300215	2030-02-15	15	Friday	2	February	1	2030	2030-02	7	0
20300216	2030-02-16	16	Saturday	2	February	1	2030	2030-02	7	1
20300217	2030-02-17	17	Sunday	2	February	1	2030	2030-02	7	1
20300218	2030-02-18	18	Monday	2	February	1	2030	2030-02	8	0
20300219	2030-02-19	19	Tuesday	2	February	1	2030	2030-02	8	0
20300220	2030-02-20	20	Wednesday	2	February	1	2030	2030-02	8	0
20300221	2030-02-21	21	Thursday	2	February	1	2030	2030-02	8	0
20300222	2030-02-22	22	Friday	2	February	1	2030	2030-02	8	0
20300223	2030-02-23	23	Saturday	2	February	1	2030	2030-02	8	1
20300224	2030-02-24	24	Sunday	2	February	1	2030	2030-02	8	1
20300225	2030-02-25	25	Monday	2	February	1	2030	2030-02	9	0
20300226	2030-02-26	26	Tuesday	2	February	1	2030	2030-02	9	0
20300227	2030-02-27	27	Wednesday	2	February	1	2030	2030-02	9	0
20300228	2030-02-28	28	Thursday	2	February	1	2030	2030-02	9	0
20300301	2030-03-01	1	Friday	3	March	1	2030	2030-03	9	0
20300302	2030-03-02	2	Saturday	3	March	1	2030	2030-03	9	1
20300303	2030-03-03	3	Sunday	3	March	1	2030	2030-03	9	1
20300304	2030-03-04	4	Monday	3	March	1	2030	2030-03	10	0
20300305	2030-03-05	5	Tuesday	3	March	1	2030	2030-03	10	0
20300306	2030-03-06	6	Wednesday	3	March	1	2030	2030-03	10	0
20300307	2030-03-07	7	Thursday	3	March	1	2030	2030-03	10	0
20300308	2030-03-08	8	Friday	3	March	1	2030	2030-03	10	0
20300309	2030-03-09	9	Saturday	3	March	1	2030	2030-03	10	1
20300310	2030-03-10	10	Sunday	3	March	1	2030	2030-03	10	1
20300311	2030-03-11	11	Monday	3	March	1	2030	2030-03	11	0
20300312	2030-03-12	12	Tuesday	3	March	1	2030	2030-03	11	0
20300313	2030-03-13	13	Wednesday	3	March	1	2030	2030-03	11	0
20300314	2030-03-14	14	Thursday	3	March	1	2030	2030-03	11	0
20300315	2030-03-15	15	Friday	3	March	1	2030	2030-03	11	0
20300316	2030-03-16	16	Saturday	3	March	1	2030	2030-03	11	1
20300317	2030-03-17	17	Sunday	3	March	1	2030	2030-03	11	1
20300318	2030-03-18	18	Monday	3	March	1	2030	2030-03	12	0
20300319	2030-03-19	19	Tuesday	3	March	1	2030	2030-03	12	0
20300320	2030-03-20	20	Wednesday	3	March	1	2030	2030-03	12	0
20300321	2030-03-21	21	Thursday	3	March	1	2030	2030-03	12	0
20300322	2030-03-22	22	Friday	3	March	1	2030	2030-03	12	0
20300323	2030-03-23	23	Saturday	3	March	1	2030	2030-03	12	1
20300324	2030-03-24	24	Sunday	3	March	1	2030	2030-03	12	1
20300325	2030-03-25	25	Monday	3	March	1	2030	2030-03	13	0
20300326	2030-03-26	26	Tuesday	3	March	1	2030	2030-03	13	0
20300327	2030-03-27	27	Wednesday	3	March	1	2030	2030-03	13	0
20300328	2030-03-28	28	Thursday	3	March	1	2030	2030-03	13	0
20300329	2030-03-29	29	Friday	3	March	1	2030	2030-03	13	0
20300330	2030-03-30	30	Saturday	3	March	1	2030	2030-03	13	1
20300331	2030-03-31	31	Sunday	3	March	1	2030	2030-03	13	1
20300401	2030-04-01	1	Monday	4	April	2	2030	2030-04	14	0
20300402	2030-04-02	2	Tuesday	4	April	2	2030	2030-04	14	0
20300403	2030-04-03	3	Wednesday	4	April	2	2030	2030-04	14	0
20300404	2030-04-04	4	Thursday	4	April	2	2030	2030-04	14	0
20300405	2030-04-05	5	Friday	4	April	2	2030	2030-04	14	0
20300406	2030-04-06	6	Saturday	4	April	2	2030	2030-04	14	1
20300407	2030-04-07	7	Sunday	4	April	2	2030	2030-04	14	1
20300408	2030-04-08	8	Monday	4	April	2	2030	2030-04	15	0
20300409	2030-04-09	9	Tuesday	4	April	2	2030	2030-04	15	0
20300410	2030-04-10	10	Wednesday	4	April	2	2030	2030-04	15	0
20300411	2030-04-11	11	Thursday	4	April	2	2030	2030-04	15	0
20300412	2030-04-12	12	Friday	4	April	2	2030	2030-04	15	0
20300413	2030-04-13	13	Saturday	4	April	2	2030	2030-04	15	1
20300414	2030-04-14	14	Sunday	4	April	2	2030	2030-04	15	1
20300415	2030-04-15	15	Monday	4	April	2	2030	2030-04	16	0
20300416	2030-04-16	16	Tuesday	4	April	2	2030	2030-04	16	0
20300417	2030-04-17	17	Wednesday	4	April	2	2030	2030-04	16	0
20300418	2030-04-18	18	Thursday	4	April	2	2030	2030-04	16	0
20300419	2030-04-19	19	Friday	4	April	2	2030	2030-04	16	0
20300420	2030-04-20	20	Saturday	4	April	2	2030	2030-04	16	1
20300421	2030-04-21	21	Sunday	4	April	2	2030	2030-04	16	1
20300422	2030-04-22	22	Monday	4	April	2	2030	2030-04	17	0
20300423	2030-04-23	23	Tuesday	4	April	2	2030	2030-04	17	0
20300424	2030-04-24	24	Wednesday	4	April	2	2030	2030-04	17	0
20300425	2030-04-25	25	Thursday	4	April	2	2030	2030-04	17	0
20300426	2030-04-26	26	Friday	4	April	2	2030	2030-04	17	0
20300427	2030-04-27	27	Saturday	4	April	2	2030	2030-04	17	1
20300428	2030-04-28	28	Sunday	4	April	2	2030	2030-04	17	1
20300429	2030-04-29	29	Monday	4	April	2	2030	2030-04	18	0
20300430	2030-04-30	30	Tuesday	4	April	2	2030	2030-04	18	0
20300501	2030-05-01	1	Wednesday	5	May	2	2030	2030-05	18	0
20300502	2030-05-02	2	Thursday	5	May	2	2030	2030-05	18	0
20300503	2030-05-03	3	Friday	5	May	2	2030	2030-05	18	0
20300504	2030-05-04	4	Saturday	5	May	2	2030	2030-05	18	1
20300505	2030-05-05	5	Sunday	5	May	2	2030	2030-05	18	1
20300506	2030-05-06	6	Monday	5	May	2	2030	2030-05	19	0
20300507	2030-05-07	7	Tuesday	5	May	2	2030	2030-05	19	0
20300508	2030-05-08	8	Wednesday	5	May	2	2030	2030-05	19	0
20300509	2030-05-09	9	Thursday	5	May	2	2030	2030-05	19	0
20300510	2030-05-10	10	Friday	5	May	2	2030	2030-05	19	0
20300511	2030-05-11	11	Saturday	5	May	2	2030	2030-05	19	1
20300512	2030-05-12	12	Sunday	5	May	2	2030	2030-05	19	1
20300513	2030-05-13	13	Monday	5	May	2	2030	2030-05	20	0
20300514	2030-05-14	14	Tuesday	5	May	2	2030	2030-05	20	0
20300515	2030-05-15	15	Wednesday	5	May	2	2030	2030-05	20	0
20300516	2030-05-16	16	Thursday	5	May	2	2030	2030-05	20	0
20300517	2030-05-17	17	Friday	5	May	2	2030	2030-05	20	0
20300518	2030-05-18	18	Saturday	5	May	2	2030	2030-05	20	1
20300519	2030-05-19	19	Sunday	5	May	2	2030	2030-05	20	1
20300520	2030-05-20	20	Monday	5	May	2	2030	2030-05	21	0
20300521	2030-05-21	21	Tuesday	5	May	2	2030	2030-05	21	0
20300522	2030-05-22	22	Wednesday	5	May	2	2030	2030-05	21	0
20300523	2030-05-23	23	Thursday	5	May	2	2030	2030-05	21	0
20300524	2030-05-24	24	Friday	5	May	2	2030	2030-05	21	0
20300525	2030-05-25	25	Saturday	5	May	2	2030	2030-05	21	1
20300526	2030-05-26	26	Sunday	5	May	2	2030	2030-05	21	1
20300527	2030-05-27	27	Monday	5	May	2	2030	2030-05	22	0
20300528	2030-05-28	28	Tuesday	5	May	2	2030	2030-05	22	0
20300529	2030-05-29	29	Wednesday	5	May	2	2030	2030-05	22	0
20300530	2030-05-30	30	Thursday	5	May	2	2030	2030-05	22	0
20300531	2030-05-31	31	Friday	5	May	2	2030	2030-05	22	0
20300601	2030-06-01	1	Saturday	6	June	2	2030	2030-06	22	1
20300602	2030-06-02	2	Sunday	6	June	2	2030	2030-06	22	1
20300603	2030-06-03	3	Monday	6	June	2	2030	2030-06	23	0
20300604	2030-06-04	4	Tuesday	6	June	2	2030	2030-06	23	0
20300605	2030-06-05	5	Wednesday	6	June	2	2030	2030-06	23	0
20300606	2030-06-06	6	Thursday	6	June	2	2030	2030-06	23	0
20300607	2030-06-07	7	Friday	6	June	2	2030	2030-06	23	0
20300608	2030-06-08	8	Saturday	6	June	2	2030	2030-06	23	1
20300609	2030-06-09	9	Sunday	6	June	2	2030	2030-06	23	1
20300610	2030-06-10	10	Monday	6	June	2	2030	2030-06	24	0
20300611	2030-06-11	11	Tuesday	6	June	2	2030	2030-06	24	0
20300612	2030-06-12	12	Wednesday	6	June	2	2030	2030-06	24	0
20300613	2030-06-13	13	Thursday	6	June	2	2030	2030-06	24	0
20300614	2030-06-14	14	Friday	6	June	2	2030	2030-06	24	0
20300615	2030-06-15	15	Saturday	6	June	2	2030	2030-06	24	1
20300616	2030-06-16	16	Sunday	6	June	2	2030	2030-06	24	1
20300617	2030-06-17	17	Monday	6	June	2	2030	2030-06	25	0
20300618	2030-06-18	18	Tuesday	6	June	2	2030	2030-06	25	0
20300619	2030-06-19	19	Wednesday	6	June	2	2030	2030-06	25	0
20300620	2030-06-20	20	Thursday	6	June	2	2030	2030-06	25	0
20300621	2030-06-21	21	Friday	6	June	2	2030	2030-06	25	0
20300622	2030-06-22	22	Saturday	6	June	2	2030	2030-06	25	1
20300623	2030-06-23	23	Sunday	6	June	2	2030	2030-06	25	1
20300624	2030-06-24	24	Monday	6	June	2	2030	2030-06	26	0
20300625	2030-06-25	25	Tuesday	6	June	2	2030	2030-06	26	0
20300626	2030-06-26	26	Wednesday	6	June	2	2030	2030-06	26	0
20300627	2030-06-27	27	Thursday	6	June	2	2030	2030-06	26	0
20300628	2030-06-28	28	Friday	6	June	2	2030	2030-06	26	0
20300629	2030-06-29	29	Saturday	6	June	2	2030	2030-06	26	1
20300630	2030-06-30	30	Sunday	6	June	2	2030	2030-06	26	1
20300701	2030-07-01	1	Monday	7	July	3	2030	2030-07	27	0
20300702	2030-07-02	2	Tuesday	7	July	3	2030	2030-07	27	0
20300703	2030-07-03	3	Wednesday	7	July	3	2030	2030-07	27	0
20300704	2030-07-04	4	Thursday	7	July	3	2030	2030-07	27	0
20300705	2030-07-05	5	Friday	7	July	3	2030	2030-07	27	0
20300706	2030-07-06	6	Saturday	7	July	3	2030	2030-07	27	1
20300707	2030-07-07	7	Sunday	7	July	3	2030	2030-07	27	1
20300708	2030-07-08	8	Monday	7	July	3	2030	2030-07	28	0
20300709	2030-07-09	9	Tuesday	7	July	3	2030	2030-07	28	0
20300710	2030-07-10	10	Wednesday	7	July	3	2030	2030-07	28	0
20300711	2030-07-11	11	Thursday	7	July	3	2030	2030-07	28	0
20300712	2030-07-12	12	Friday	7	July	3	2030	2030-07	28	0
20300713	2030-07-13	13	Saturday	7	July	3	2030	2030-07	28	1
20300714	2030-07-14	14	Sunday	7	July	3	2030	2030-07	28	1
20300715	2030-07-15	15	Monday	7	July	3	2030	2030-07	29	0
20300716	2030-07-16	16	Tuesday	7	July	3	2030	2030-07	29	0
20300717	2030-07-17	17	Wednesday	7	July	3	2030	2030-07	29	0
20300718	2030-07-18	18	Thursday	7	July	3	2030	2030-07	29	0
20300719	2030-07-19	19	Friday	7	July	3	2030	2030-07	29	0
20300720	2030-07-20	20	Saturday	7	July	3	2030	2030-07	29	1
20300721	2030-07-21	21	Sunday	7	July	3	2030	2030-07	29	1
20300722	2030-07-22	22	Monday	7	July	3	2030	2030-07	30	0
20300723	2030-07-23	23	Tuesday	7	July	3	2030	2030-07	30	0
20300724	2030-07-24	24	Wednesday	7	July	3	2030	2030-07	30	0
20300725	2030-07-25	25	Thursday	7	July	3	2030	2030-07	30	0
20300726	2030-07-26	26	Friday	7	July	3	2030	2030-07	30	0
20300727	2030-07-27	27	Saturday	7	July	3	2030	2030-07	30	1
20300728	2030-07-28	28	Sunday	7	July	3	2030	2030-07	30	1
20300729	2030-07-29	29	Monday	7	July	3	2030	2030-07	31	0
20300730	2030-07-30	30	Tuesday	7	July	3	2030	2030-07	31	0
20300731	2030-07-31	31	Wednesday	7	July	3	2030	2030-07	31	0
20300801	2030-08-01	1	Thursday	8	August	3	2030	2030-08	31	0
20300802	2030-08-02	2	Friday	8	August	3	2030	2030-08	31	0
20300803	2030-08-03	3	Saturday	8	August	3	2030	2030-08	31	1
20300804	2030-08-04	4	Sunday	8	August	3	2030	2030-08	31	1
20300805	2030-08-05	5	Monday	8	August	3	2030	2030-08	32	0
20300806	2030-08-06	6	Tuesday	8	August	3	2030	2030-08	32	0
20300807	2030-08-07	7	Wednesday	8	August	3	2030	2030-08	32	0
20300808	2030-08-08	8	Thursday	8	August	3	2030	2030-08	32	0
20300809	2030-08-09	9	Friday	8	August	3	2030	2030-08	32	0
20300810	2030-08-10	10	Saturday	8	August	3	2030	2030-08	32	1
20300811	2030-08-11	11	Sunday	8	August	3	2030	2030-08	32	1
20300812	2030-08-12	12	Monday	8	August	3	2030	2030-08	33	0
20300813	2030-08-13	13	Tuesday	8	August	3	2030	2030-08	33	0
20300814	2030-08-14	14	Wednesday	8	August	3	2030	2030-08	33	0
20300815	2030-08-15	15	Thursday	8	August	3	2030	2030-08	33	0
20300816	2030-08-16	16	Friday	8	August	3	2030	2030-08	33	0
20300817	2030-08-17	17	Saturday	8	August	3	2030	2030-08	33	1
20300818	2030-08-18	18	Sunday	8	August	3	2030	2030-08	33	1
20300819	2030-08-19	19	Monday	8	August	3	2030	2030-08	34	0
20300820	2030-08-20	20	Tuesday	8	August	3	2030	2030-08	34	0
20300821	2030-08-21	21	Wednesday	8	August	3	2030	2030-08	34	0
20300822	2030-08-22	22	Thursday	8	August	3	2030	2030-08	34	0
20300823	2030-08-23	23	Friday	8	August	3	2030	2030-08	34	0
20300824	2030-08-24	24	Saturday	8	August	3	2030	2030-08	34	1
20300825	2030-08-25	25	Sunday	8	August	3	2030	2030-08	34	1
20300826	2030-08-26	26	Monday	8	August	3	2030	2030-08	35	0
20300827	2030-08-27	27	Tuesday	8	August	3	2030	2030-08	35	0
20300828	2030-08-28	28	Wednesday	8	August	3	2030	2030-08	35	0
20300829	2030-08-29	29	Thursday	8	August	3	2030	2030-08	35	0
20300830	2030-08-30	30	Friday	8	August	3	2030	2030-08	35	0
20300831	2030-08-31	31	Saturday	8	August	3	2030	2030-08	35	1
20300901	2030-09-01	1	Sunday	9	September	3	2030	2030-09	35	1
20300902	2030-09-02	2	Monday	9	September	3	2030	2030-09	36	0
20300903	2030-09-03	3	Tuesday	9	September	3	2030	2030-09	36	0
20300904	2030-09-04	4	Wednesday	9	September	3	2030	2030-09	36	0
20300905	2030-09-05	5	Thursday	9	September	3	2030	2030-09	36	0
20300906	2030-09-06	6	Friday	9	September	3	2030	2030-09	36	0
20300907	2030-09-07	7	Saturday	9	September	3	2030	2030-09	36	1
20300908	2030-09-08	8	Sunday	9	September	3	2030	2030-09	36	1
20300909	2030-09-09	9	Monday	9	September	3	2030	2030-09	37	0
20300910	2030-09-10	10	Tuesday	9	September	3	2030	2030-09	37	0
20300911	2030-09-11	11	Wednesday	9	September	3	2030	2030-09	37	0
20300912	2030-09-12	12	Thursday	9	September	3	2030	2030-09	37	0
20300913	2030-09-13	13	Friday	9	September	3	2030	2030-09	37	0
20300914	2030-09-14	14	Saturday	9	September	3	2030	2030-09	37	1
20300915	2030-09-15	15	Sunday	9	September	3	2030	2030-09	37	1
20300916	2030-09-16	16	Monday	9	September	3	2030	2030-09	38	0
20300917	2030-09-17	17	Tuesday	9	September	3	2030	2030-09	38	0
20300918	2030-09-18	18	Wednesday	9	September	3	2030	2030-09	38	0
20300919	2030-09-19	19	Thursday	9	September	3	2030	2030-09	38	0
20300920	2030-09-20	20	Friday	9	September	3	2030	2030-09	38	0
20300921	2030-09-21	21	Saturday	9	September	3	2030	2030-09	38	1
20300922	2030-09-22	22	Sunday	9	September	3	2030	2030-09	38	1
20300923	2030-09-23	23	Monday	9	September	3	2030	2030-09	39	0
20300924	2030-09-24	24	Tuesday	9	September	3	2030	2030-09	39	0
20300925	2030-09-25	25	Wednesday	9	September	3	2030	2030-09	39	0
20300926	2030-09-26	26	Thursday	9	September	3	2030	2030-09	39	0
20300927	2030-09-27	27	Friday	9	September	3	2030	2030-09	39	0
20300928	2030-09-28	28	Saturday	9	September	3	2030	2030-09	39	1
20300929	2030-09-29	29	Sunday	9	September	3	2030	2030-09	39	1
20300930	2030-09-30	30	Monday	9	September	3	2030	2030-09	40	0
20301001	2030-10-01	1	Tuesday	10	October	4	2030	2030-10	40	0
20301002	2030-10-02	2	Wednesday	10	October	4	2030	2030-10	40	0
20301003	2030-10-03	3	Thursday	10	October	4	2030	2030-10	40	0
20301004	2030-10-04	4	Friday	10	October	4	2030	2030-10	40	0
20301005	2030-10-05	5	Saturday	10	October	4	2030	2030-10	40	1
20301006	2030-10-06	6	Sunday	10	October	4	2030	2030-10	40	1
20301007	2030-10-07	7	Monday	10	October	4	2030	2030-10	41	0
20301008	2030-10-08	8	Tuesday	10	October	4	2030	2030-10	41	0
20301009	2030-10-09	9	Wednesday	10	October	4	2030	2030-10	41	0
20301010	2030-10-10	10	Thursday	10	October	4	2030	2030-10	41	0
20301011	2030-10-11	11	Friday	10	October	4	2030	2030-10	41	0
20301012	2030-10-12	12	Saturday	10	October	4	2030	2030-10	41	1
20301013	2030-10-13	13	Sunday	10	October	4	2030	2030-10	41	1
20301014	2030-10-14	14	Monday	10	October	4	2030	2030-10	42	0
20301015	2030-10-15	15	Tuesday	10	October	4	2030	2030-10	42	0
20301016	2030-10-16	16	Wednesday	10	October	4	2030	2030-10	42	0
20301017	2030-10-17	17	Thursday	10	October	4	2030	2030-10	42	0
20301018	2030-10-18	18	Friday	10	October	4	2030	2030-10	42	0
20301019	2030-10-19	19	Saturday	10	October	4	2030	2030-10	42	1
20301020	2030-10-20	20	Sunday	10	October	4	2030	2030-10	42	1
20301021	2030-10-21	21	Monday	10	October	4	2030	2030-10	43	0
20301022	2030-10-22	22	Tuesday	10	October	4	2030	2030-10	43	0
20301023	2030-10-23	23	Wednesday	10	October	4	2030	2030-10	43	0
20301024	2030-10-24	24	Thursday	10	October	4	2030	2030-10	43	0
20301025	2030-10-25	25	Friday	10	October	4	2030	2030-10	43	0
20301026	2030-10-26	26	Saturday	10	October	4	2030	2030-10	43	1
20301027	2030-10-27	27	Sunday	10	October	4	2030	2030-10	43	1
20301028	2030-10-28	28	Monday	10	October	4	2030	2030-10	44	0
20301029	2030-10-29	29	Tuesday	10	October	4	2030	2030-10	44	0
20301030	2030-10-30	30	Wednesday	10	October	4	2030	2030-10	44	0
20301031	2030-10-31	31	Thursday	10	October	4	2030	2030-10	44	0
20301101	2030-11-01	1	Friday	11	November	4	2030	2030-11	44	0
20301102	2030-11-02	2	Saturday	11	November	4	2030	2030-11	44	1
20301103	2030-11-03	3	Sunday	11	November	4	2030	2030-11	44	1
20301104	2030-11-04	4	Monday	11	November	4	2030	2030-11	45	0
20301105	2030-11-05	5	Tuesday	11	November	4	2030	2030-11	45	0
20301106	2030-11-06	6	Wednesday	11	November	4	2030	2030-11	45	0
20301107	2030-11-07	7	Thursday	11	November	4	2030	2030-11	45	0
20301108	2030-11-08	8	Friday	11	November	4	2030	2030-11	45	0
20301109	2030-11-09	9	Saturday	11	November	4	2030	2030-11	45	1
20301110	2030-11-10	10	Sunday	11	November	4	2030	2030-11	45	1
20301111	2030-11-11	11	Monday	11	November	4	2030	2030-11	46	0
20301112	2030-11-12	12	Tuesday	11	November	4	2030	2030-11	46	0
20301113	2030-11-13	13	Wednesday	11	November	4	2030	2030-11	46	0
20301114	2030-11-14	14	Thursday	11	November	4	2030	2030-11	46	0
20301115	2030-11-15	15	Friday	11	November	4	2030	2030-11	46	0
20301116	2030-11-16	16	Saturday	11	November	4	2030	2030-11	46	1
20301117	2030-11-17	17	Sunday	11	November	4	2030	2030-11	46	1
20301118	2030-11-18	18	Monday	11	November	4	2030	2030-11	47	0
20301119	2030-11-19	19	Tuesday	11	November	4	2030	2030-11	47	0
20301120	2030-11-20	20	Wednesday	11	November	4	2030	2030-11	47	0
20301121	2030-11-21	21	Thursday	11	November	4	2030	2030-11	47	0
20301122	2030-11-22	22	Friday	11	November	4	2030	2030-11	47	0
20301123	2030-11-23	23	Saturday	11	November	4	2030	2030-11	47	1
20301124	2030-11-24	24	Sunday	11	November	4	2030	2030-11	47	1
20301125	2030-11-25	25	Monday	11	November	4	2030	2030-11	48	0
20301126	2030-11-26	26	Tuesday	11	November	4	2030	2030-11	48	0
20301127	2030-11-27	27	Wednesday	11	November	4	2030	2030-11	48	0
20301128	2030-11-28	28	Thursday	11	November	4	2030	2030-11	48	0
20301129	2030-11-29	29	Friday	11	November	4	2030	2030-11	48	0
20301130	2030-11-30	30	Saturday	11	November	4	2030	2030-11	48	1
20301201	2030-12-01	1	Sunday	12	December	4	2030	2030-12	48	1
20301202	2030-12-02	2	Monday	12	December	4	2030	2030-12	49	0
20301203	2030-12-03	3	Tuesday	12	December	4	2030	2030-12	49	0
20301204	2030-12-04	4	Wednesday	12	December	4	2030	2030-12	49	0
20301205	2030-12-05	5	Thursday	12	December	4	2030	2030-12	49	0
20301206	2030-12-06	6	Friday	12	December	4	2030	2030-12	49	0
20301207	2030-12-07	7	Saturday	12	December	4	2030	2030-12	49	1
20301208	2030-12-08	8	Sunday	12	December	4	2030	2030-12	49	1
20301209	2030-12-09	9	Monday	12	December	4	2030	2030-12	50	0
20301210	2030-12-10	10	Tuesday	12	December	4	2030	2030-12	50	0
20301211	2030-12-11	11	Wednesday	12	December	4	2030	2030-12	50	0
20301212	2030-12-12	12	Thursday	12	December	4	2030	2030-12	50	0
20301213	2030-12-13	13	Friday	12	December	4	2030	2030-12	50	0
20301214	2030-12-14	14	Saturday	12	December	4	2030	2030-12	50	1
20301215	2030-12-15	15	Sunday	12	December	4	2030	2030-12	50	1
20301216	2030-12-16	16	Monday	12	December	4	2030	2030-12	51	0
20301217	2030-12-17	17	Tuesday	12	December	4	2030	2030-12	51	0
20301218	2030-12-18	18	Wednesday	12	December	4	2030	2030-12	51	0
20301219	2030-12-19	19	Thursday	12	December	4	2030	2030-12	51	0
20301220	2030-12-20	20	Friday	12	December	4	2030	2030-12	51	0
20301221	2030-12-21	21	Saturday	12	December	4	2030	2030-12	51	1
20301222	2030-12-22	22	Sunday	12	December	4	2030	2030-12	51	1
20301223	2030-12-23	23	Monday	12	December	4	2030	2030-12	52	0
20301224	2030-12-24	24	Tuesday	12	December	4	2030	2030-12	52	0
20301225	2030-12-25	25	Wednesday	12	December	4	2030	2030-12	52	0
20301226	2030-12-26	26	Thursday	12	December	4	2030	2030-12	52	0
20301227	2030-12-27	27	Friday	12	December	4	2030	2030-12	52	0
20301228	2030-12-28	28	Saturday	12	December	4	2030	2030-12	52	1
20301229	2030-12-29	29	Sunday	12	December	4	2030	2030-12	52	1
20301230	2030-12-30	30	Monday	12	December	4	2030	2030-12	1	0
20301231	2030-12-31	31	Tuesday	12	December	4	2030	2030-12	1	0
\.


--
-- Data for Name: dim_user; Type: TABLE DATA; Schema: technova_dw; Owner: -
--

COPY technova_dw.dim_user (user_sk, user_id, nom, prenom, email, sexe, tranche_age, date_inscription, date_inscription_sk, source_acquisition, pays, ville, region, zone_eco, plan, prix_mensuel_tnd, est_payant, statut, date_debut_validite, date_fin_validite, est_courant) FROM stdin;
-1	-1	Inconnu	Inconnu	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-22	\N	1
1	1	Mansouri	Mohamed	user1@technova.tn	Homme	26-35	2021-07-29	20210729	Referral	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
2	2	Trabelsi	Mohamed	user2@technova.tn	Homme	46+	2022-02-12	20220212	Referral	France	Paris	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
3	3	Zouari	Sonia	user3@technova.tn	Femme	36-45	2021-11-15	20211115	LinkedIn	France	Marseille	Europe	UE	Gratuit	0.00	0	Banni	2026-05-22	\N	1
4	4	Miled	Ahmed	user4@technova.tn	Homme	36-45	2021-03-30	20210330	Referral	Tunisie	Sousse	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
5	5	Jebali	Amine	user5@technova.tn	Homme	18-25	2022-04-12	20220412	Facebook	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Banni	2026-05-22	\N	1
6	6	Jebali	Bilel	user6@technova.tn	Homme	26-35	2022-03-06	20220306	Email	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
7	7	Boughanmi	Nabil	user7@technova.tn	Homme	26-35	2023-02-17	20230217	Email	France	Marseille	Europe	UE	Gratuit	0.00	0	Banni	2026-05-22	\N	1
8	8	Rekik	Sami	user8@technova.tn	Homme	18-25	2023-04-02	20230402	Direct	Tunisie	Sfax	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
9	9	Boughanmi	Fatma	user9@technova.tn	Femme	46+	2022-06-27	20220627	Direct	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
10	10	Miled	Rania	user10@technova.tn	Femme	26-35	2021-10-11	20211011	Google	Maroc	Rabat	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
11	11	Boughanmi	Karim	user11@technova.tn	Homme	36-45	2023-02-28	20230228	Referral	France	Marseille	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
12	12	Rekik	Meriem	user12@technova.tn	Femme	46+	2022-11-28	20221128	Facebook	Tunisie	Tunis	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
13	13	Mansouri	Sonia	user13@technova.tn	Femme	46+	2022-09-04	20220904	Facebook	Algérie	Alger	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
14	14	Karray	Nadia	user14@technova.tn	Femme	36-45	2021-08-18	20210818	LinkedIn	Tunisie	Nabeul	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
15	15	Hamdi	Mohamed	user15@technova.tn	Homme	46+	2023-12-27	20231227	Referral	Tunisie	Tunis	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
16	16	Karray	Omar	user16@technova.tn	Homme	46+	2022-02-16	20220216	Email	Maroc	Casablanca	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
17	17	Chebbi	Leila	user17@technova.tn	Femme	26-35	2022-11-24	20221124	Facebook	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
18	18	Trabelsi	Mohamed	user18@technova.tn	Homme	18-25	2022-11-08	20221108	LinkedIn	Tunisie	Sfax	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
19	19	Karray	Fatma	user19@technova.tn	Femme	46+	2022-05-13	20220513	Facebook	France	Marseille	Europe	UE	Standard	49.00	1	Inactif	2026-05-22	\N	1
20	20	Boughanmi	Ahmed	user20@technova.tn	Homme	36-45	2021-04-21	20210421	Email	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
21	21	Hamdi	Rim	user21@technova.tn	Femme	46+	2023-05-15	20230515	Facebook	France	Paris	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
22	22	Zouari	Hedi	user22@technova.tn	Homme	46+	2021-01-31	20210131	Facebook	Tunisie	Tunis	Maghreb	MENA	Entreprise	199.00	1	Inactif	2026-05-22	\N	1
23	23	Chaabane	Bilel	user23@technova.tn	Homme	36-45	2021-12-04	20211204	Referral	Maroc	Casablanca	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
24	24	Jebali	Leila	user24@technova.tn	Femme	26-35	2022-03-22	20220322	Direct	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
25	25	Ben Ali	Sami	user25@technova.tn	Homme	46+	2023-12-24	20231224	Direct	Tunisie	Nabeul	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
26	26	Trabelsi	Karim	user26@technova.tn	Homme	36-45	2022-05-20	20220520	Direct	Tunisie	Sfax	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
27	27	Boughanmi	Bilel	user27@technova.tn	Homme	26-35	2022-10-06	20221006	Facebook	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
28	28	Sassi	Leila	user28@technova.tn	Femme	46+	2021-07-24	20210724	Direct	Tunisie	Tunis	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
29	29	Chebbi	Nadia	user29@technova.tn	Femme	26-35	2021-11-20	20211120	Email	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
30	30	Zouari	Rania	user30@technova.tn	Femme	36-45	2021-08-01	20210801	Google	Tunisie	Nabeul	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
31	31	Jebali	Omar	user31@technova.tn	Homme	36-45	2022-06-25	20220625	Google	France	Marseille	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
32	32	Rekik	Bilel	user32@technova.tn	Homme	18-25	2021-09-25	20210925	Referral	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
33	33	Ben Ali	Meriem	user33@technova.tn	Femme	26-35	2023-01-27	20230127	Referral	Tunisie	Tunis	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
34	34	Jebali	Mohamed	user34@technova.tn	Homme	36-45	2022-05-27	20220527	Direct	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
35	35	Mansouri	Rania	user35@technova.tn	Femme	26-35	2021-12-29	20211229	Email	France	Paris	Europe	UE	Entreprise	199.00	1	Actif	2026-05-22	\N	1
36	36	Zouari	Amira	user36@technova.tn	Femme	26-35	2021-08-10	20210810	Referral	France	Lyon	Europe	UE	Premium	99.00	1	Inactif	2026-05-22	\N	1
37	37	Rekik	Yassine	user37@technova.tn	Homme	36-45	2022-04-12	20220412	Facebook	Maroc	Rabat	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
38	38	Jebali	Ines	user38@technova.tn	Femme	36-45	2023-03-30	20230330	Google	Tunisie	Sousse	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
39	39	Gharbi	Omar	user39@technova.tn	Homme	18-25	2022-12-09	20221209	Direct	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
40	40	Chebbi	Bilel	user40@technova.tn	Homme	18-25	2021-01-04	20210104	Direct	France	Lyon	Europe	UE	Standard	49.00	1	Inactif	2026-05-22	\N	1
41	41	Miled	Sami	user41@technova.tn	Homme	46+	2021-09-13	20210913	Email	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
42	42	Miled	Ines	user42@technova.tn	Femme	26-35	2023-02-16	20230216	LinkedIn	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
43	43	Rekik	Meriem	user43@technova.tn	Femme	36-45	2022-10-22	20221022	Email	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
44	44	Chaabane	Amine	user44@technova.tn	Homme	18-25	2022-11-18	20221118	Facebook	France	Marseille	Europe	UE	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
45	45	Zouari	Fatma	user45@technova.tn	Femme	18-25	2023-09-01	20230901	Email	France	Paris	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
46	46	Chaabane	Bilel	user46@technova.tn	Homme	26-35	2021-01-12	20210112	Facebook	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
47	47	Chaabane	Amine	user47@technova.tn	Homme	26-35	2021-09-06	20210906	Referral	Tunisie	Nabeul	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
48	48	Dridi	Leila	user48@technova.tn	Femme	26-35	2023-08-31	20230831	Facebook	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
49	49	Chaabane	Meriem	user49@technova.tn	Femme	46+	2022-08-09	20220809	LinkedIn	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
50	50	Gharbi	Karim	user50@technova.tn	Homme	26-35	2021-05-12	20210512	Direct	France	Lyon	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
51	51	Ben Ali	Amira	user51@technova.tn	Femme	36-45	2021-02-10	20210210	Google	France	Lyon	Europe	UE	Entreprise	199.00	1	Actif	2026-05-22	\N	1
52	52	Zouari	Salma	user52@technova.tn	Femme	46+	2022-03-28	20220328	Referral	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
53	53	Miled	Sonia	user53@technova.tn	Femme	26-35	2021-09-19	20210919	Referral	Algérie	Oran	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
54	54	Boughanmi	Ahmed	user54@technova.tn	Homme	46+	2022-06-17	20220617	Referral	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
55	55	Zouari	Ines	user55@technova.tn	Femme	36-45	2021-06-17	20210617	Direct	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
56	56	Hamdi	Sami	user56@technova.tn	Homme	18-25	2022-02-13	20220213	Facebook	Tunisie	Tunis	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
57	57	Boughanmi	Hedi	user57@technova.tn	Homme	26-35	2022-06-09	20220609	Direct	Tunisie	Nabeul	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
58	58	Jebali	Karim	user58@technova.tn	Homme	18-25	2023-02-08	20230208	Facebook	Tunisie	Nabeul	Maghreb	MENA	Entreprise	199.00	1	Inactif	2026-05-22	\N	1
59	59	Mansouri	Nabil	user59@technova.tn	Homme	36-45	2021-09-05	20210905	LinkedIn	France	Paris	Europe	UE	Premium	99.00	1	Inactif	2026-05-22	\N	1
60	60	Trabelsi	Ines	user60@technova.tn	Femme	36-45	2021-08-05	20210805	Email	Algérie	Alger	Maghreb	MENA	Premium	99.00	1	Banni	2026-05-22	\N	1
61	61	Miled	Nadia	user61@technova.tn	Femme	46+	2022-07-08	20220708	Referral	France	Marseille	Europe	UE	Entreprise	199.00	1	Inactif	2026-05-22	\N	1
62	62	Jebali	Rania	user62@technova.tn	Femme	18-25	2023-07-13	20230713	Direct	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
63	63	Ben Ali	Ines	user63@technova.tn	Femme	26-35	2022-12-28	20221228	Direct	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
64	64	Ben Ali	Meriem	user64@technova.tn	Femme	26-35	2023-09-28	20230928	Email	France	Paris	Europe	UE	Standard	49.00	1	Inactif	2026-05-22	\N	1
65	65	Chaabane	Leila	user65@technova.tn	Femme	36-45	2022-05-14	20220514	LinkedIn	Tunisie	Tunis	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
66	66	Karray	Meriem	user66@technova.tn	Femme	46+	2023-07-19	20230719	Facebook	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
67	67	Sassi	Yassine	user67@technova.tn	Homme	26-35	2023-09-19	20230919	Direct	Tunisie	Nabeul	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
68	68	Rekik	Rim	user68@technova.tn	Femme	26-35	2022-09-12	20220912	Facebook	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
69	69	Ben Ali	Sonia	user69@technova.tn	Femme	46+	2023-10-03	20231003	Direct	Algérie	Alger	Maghreb	MENA	Premium	99.00	1	Inactif	2026-05-22	\N	1
70	70	Chaabane	Leila	user70@technova.tn	Femme	26-35	2022-06-02	20220602	Google	Maroc	Rabat	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
71	71	Trabelsi	Leila	user71@technova.tn	Femme	26-35	2022-09-15	20220915	Google	Tunisie	Sfax	Maghreb	MENA	Premium	99.00	1	Banni	2026-05-22	\N	1
72	72	Dridi	Rania	user72@technova.tn	Femme	36-45	2023-06-26	20230626	Referral	France	Marseille	Europe	UE	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
73	73	Dridi	Rania	user73@technova.tn	Femme	18-25	2022-03-02	20220302	Google	Tunisie	Nabeul	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
74	74	Gharbi	Yassine	user74@technova.tn	Homme	18-25	2023-08-21	20230821	LinkedIn	Tunisie	Sfax	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
75	75	Trabelsi	Leila	user75@technova.tn	Femme	46+	2022-02-10	20220210	Facebook	France	Lyon	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
76	76	Rekik	Omar	user76@technova.tn	Homme	18-25	2022-09-22	20220922	Referral	France	Paris	Europe	UE	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
77	77	Mansouri	Hedi	user77@technova.tn	Homme	26-35	2023-10-09	20231009	Google	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
78	78	Dridi	Ines	user78@technova.tn	Femme	18-25	2021-02-12	20210212	Facebook	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
79	79	Boughanmi	Meriem	user79@technova.tn	Femme	26-35	2023-06-12	20230612	Referral	Maroc	Rabat	Maghreb	MENA	Entreprise	199.00	1	Banni	2026-05-22	\N	1
80	80	Sassi	Amira	user80@technova.tn	Femme	26-35	2023-10-12	20231012	Referral	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
81	81	Trabelsi	Hedi	user81@technova.tn	Homme	36-45	2023-04-08	20230408	Google	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
82	82	Ben Ali	Amira	user82@technova.tn	Femme	36-45	2023-10-18	20231018	Facebook	France	Marseille	Europe	UE	Standard	49.00	1	Inactif	2026-05-22	\N	1
83	83	Gharbi	Meriem	user83@technova.tn	Femme	46+	2022-05-06	20220506	Google	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
84	84	Hamdi	Rim	user84@technova.tn	Femme	18-25	2021-11-12	20211112	LinkedIn	Tunisie	Bizerte	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
85	85	Rekik	Amira	user85@technova.tn	Femme	26-35	2021-10-24	20211024	Direct	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
86	86	Jebali	Ahmed	user86@technova.tn	Homme	46+	2021-01-06	20210106	Direct	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
87	87	Chaabane	Nadia	user87@technova.tn	Femme	36-45	2023-02-12	20230212	Facebook	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
88	88	Miled	Nabil	user88@technova.tn	Homme	18-25	2023-08-27	20230827	Email	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
89	89	Ben Ali	Hedi	user89@technova.tn	Homme	46+	2021-07-25	20210725	Referral	France	Marseille	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
90	90	Miled	Karim	user90@technova.tn	Homme	46+	2022-06-27	20220627	Referral	France	Paris	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
91	91	Rekik	Sami	user91@technova.tn	Homme	46+	2023-09-27	20230927	Google	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
92	92	Hamdi	Omar	user92@technova.tn	Homme	18-25	2021-07-25	20210725	LinkedIn	Tunisie	Bizerte	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
93	93	Sassi	Mohamed	user93@technova.tn	Homme	36-45	2021-10-26	20211026	Direct	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
94	94	Gharbi	Karim	user94@technova.tn	Homme	36-45	2022-05-09	20220509	Facebook	Tunisie	Nabeul	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
95	95	Boughanmi	Hedi	user95@technova.tn	Homme	26-35	2023-08-11	20230811	Facebook	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
96	96	Sassi	Hedi	user96@technova.tn	Homme	26-35	2022-09-11	20220911	Referral	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Banni	2026-05-22	\N	1
97	97	Miled	Yassine	user97@technova.tn	Homme	36-45	2023-03-22	20230322	Email	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
98	98	Mansouri	Nabil	user98@technova.tn	Homme	26-35	2022-12-23	20221223	Direct	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
99	99	Boughanmi	Nadia	user99@technova.tn	Femme	36-45	2021-03-10	20210310	Facebook	Tunisie	Tunis	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
100	100	Sassi	Omar	user100@technova.tn	Homme	26-35	2023-01-20	20230120	LinkedIn	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
101	101	Chebbi	Omar	user101@technova.tn	Homme	36-45	2023-08-18	20230818	Facebook	Maroc	Rabat	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
102	102	Sassi	Meriem	user102@technova.tn	Femme	18-25	2021-09-11	20210911	Email	Tunisie	Bizerte	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
103	103	Miled	Rania	user103@technova.tn	Femme	26-35	2022-11-03	20221103	Email	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
104	104	Boughanmi	Salma	user104@technova.tn	Femme	26-35	2021-03-18	20210318	Google	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Banni	2026-05-22	\N	1
105	105	Chebbi	Yassine	user105@technova.tn	Homme	46+	2023-05-09	20230509	Email	France	Lyon	Europe	UE	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
106	106	Dridi	Hedi	user106@technova.tn	Homme	18-25	2022-03-21	20220321	Facebook	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
107	107	Boughanmi	Rim	user107@technova.tn	Femme	18-25	2022-01-24	20220124	Referral	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
108	108	Boughanmi	Yassine	user108@technova.tn	Homme	36-45	2021-09-15	20210915	Direct	Tunisie	Tunis	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
109	109	Hamdi	Nabil	user109@technova.tn	Homme	26-35	2021-01-06	20210106	Facebook	France	Lyon	Europe	UE	Premium	99.00	1	Inactif	2026-05-22	\N	1
110	110	Jebali	Amine	user110@technova.tn	Homme	46+	2021-09-27	20210927	Facebook	France	Paris	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
111	111	Gharbi	Sonia	user111@technova.tn	Femme	26-35	2023-12-14	20231214	Referral	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
112	112	Karray	Ines	user112@technova.tn	Femme	46+	2021-03-30	20210330	Email	Tunisie	Bizerte	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
113	113	Chaabane	Mohamed	user113@technova.tn	Homme	18-25	2023-06-28	20230628	LinkedIn	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
114	114	Gharbi	Ahmed	user114@technova.tn	Homme	36-45	2023-12-23	20231223	Direct	Algérie	Oran	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
115	115	Zouari	Rim	user115@technova.tn	Femme	26-35	2022-04-13	20220413	Referral	Tunisie	Nabeul	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
116	116	Mansouri	Amira	user116@technova.tn	Femme	36-45	2022-06-07	20220607	Email	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Banni	2026-05-22	\N	1
117	117	Trabelsi	Rim	user117@technova.tn	Femme	36-45	2023-02-03	20230203	Direct	Tunisie	Tunis	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
118	118	Miled	Rim	user118@technova.tn	Femme	18-25	2022-10-02	20221002	Direct	Algérie	Oran	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
119	119	Boughanmi	Karim	user119@technova.tn	Homme	18-25	2023-01-23	20230123	Direct	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
120	120	Rekik	Bilel	user120@technova.tn	Homme	46+	2022-07-02	20220702	Email	Tunisie	Nabeul	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
121	121	Sassi	Ines	user121@technova.tn	Femme	26-35	2023-04-01	20230401	Email	Tunisie	Sfax	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
122	122	Mansouri	Ahmed	user122@technova.tn	Homme	36-45	2021-11-19	20211119	LinkedIn	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
123	123	Gharbi	Mohamed	user123@technova.tn	Homme	18-25	2022-07-12	20220712	Referral	France	Marseille	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
124	124	Jebali	Amira	user124@technova.tn	Femme	18-25	2021-08-16	20210816	Direct	France	Marseille	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
125	125	Boughanmi	Meriem	user125@technova.tn	Femme	26-35	2021-04-23	20210423	Facebook	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
126	126	Jebali	Omar	user126@technova.tn	Homme	18-25	2023-06-01	20230601	Direct	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
127	127	Karray	Amine	user127@technova.tn	Homme	36-45	2021-03-28	20210328	Google	Algérie	Alger	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
128	128	Miled	Rania	user128@technova.tn	Femme	36-45	2021-02-12	20210212	Direct	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
129	129	Trabelsi	Ines	user129@technova.tn	Femme	26-35	2023-04-01	20230401	LinkedIn	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
130	130	Sassi	Fatma	user130@technova.tn	Femme	46+	2023-12-23	20231223	LinkedIn	France	Paris	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
131	131	Hamdi	Nadia	user131@technova.tn	Femme	26-35	2021-11-10	20211110	Email	Tunisie	Sfax	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
132	132	Zouari	Leila	user132@technova.tn	Femme	46+	2023-06-20	20230620	Email	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
133	133	Dridi	Salma	user133@technova.tn	Femme	46+	2023-08-04	20230804	LinkedIn	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
134	134	Boughanmi	Rim	user134@technova.tn	Femme	46+	2023-08-06	20230806	Email	Tunisie	Nabeul	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
135	135	Chebbi	Hedi	user135@technova.tn	Homme	46+	2021-11-05	20211105	LinkedIn	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
136	136	Boughanmi	Amine	user136@technova.tn	Homme	26-35	2023-06-19	20230619	Facebook	France	Paris	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
137	137	Chebbi	Ines	user137@technova.tn	Femme	36-45	2021-04-18	20210418	Google	Algérie	Oran	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
138	138	Jebali	Salma	user138@technova.tn	Femme	18-25	2021-10-17	20211017	Email	France	Lyon	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
139	139	Dridi	Nadia	user139@technova.tn	Femme	46+	2022-11-04	20221104	Email	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
140	140	Karray	Bilel	user140@technova.tn	Homme	36-45	2022-03-15	20220315	Referral	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
141	141	Gharbi	Yassine	user141@technova.tn	Homme	36-45	2021-07-27	20210727	Email	France	Paris	Europe	UE	Premium	99.00	1	Inactif	2026-05-22	\N	1
142	142	Chebbi	Sami	user142@technova.tn	Homme	36-45	2022-01-06	20220106	Google	France	Marseille	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
143	143	Boughanmi	Ines	user143@technova.tn	Femme	46+	2023-07-09	20230709	LinkedIn	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
144	144	Sassi	Fatma	user144@technova.tn	Femme	36-45	2023-10-27	20231027	Facebook	Maroc	Rabat	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
145	145	Gharbi	Nabil	user145@technova.tn	Homme	46+	2023-01-31	20230131	Email	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
146	146	Trabelsi	Omar	user146@technova.tn	Homme	46+	2021-10-29	20211029	Facebook	France	Lyon	Europe	UE	Entreprise	199.00	1	Actif	2026-05-22	\N	1
147	147	Chebbi	Ines	user147@technova.tn	Femme	18-25	2023-02-05	20230205	Google	Tunisie	Bizerte	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
148	148	Ben Ali	Fatma	user148@technova.tn	Femme	46+	2021-10-27	20211027	Referral	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
149	149	Chaabane	Hedi	user149@technova.tn	Homme	18-25	2021-11-03	20211103	Direct	Tunisie	Tunis	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
150	150	Zouari	Rim	user150@technova.tn	Femme	36-45	2022-05-04	20220504	Direct	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
151	151	Trabelsi	Rim	user151@technova.tn	Femme	46+	2022-05-11	20220511	Google	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
152	152	Dridi	Fatma	user152@technova.tn	Femme	46+	2023-12-09	20231209	Direct	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
153	153	Rekik	Bilel	user153@technova.tn	Homme	46+	2023-02-04	20230204	LinkedIn	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
154	154	Hamdi	Sami	user154@technova.tn	Homme	36-45	2022-12-23	20221223	Email	Tunisie	Nabeul	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
155	155	Mansouri	Hedi	user155@technova.tn	Homme	26-35	2023-07-27	20230727	Google	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
156	156	Sassi	Mohamed	user156@technova.tn	Homme	46+	2021-03-16	20210316	Google	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
157	157	Trabelsi	Salma	user157@technova.tn	Femme	36-45	2023-03-03	20230303	Referral	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Banni	2026-05-22	\N	1
158	158	Chebbi	Ines	user158@technova.tn	Femme	36-45	2022-01-05	20220105	Google	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
159	159	Boughanmi	Sami	user159@technova.tn	Homme	46+	2023-05-23	20230523	LinkedIn	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
160	160	Mansouri	Sonia	user160@technova.tn	Femme	26-35	2021-04-28	20210428	Referral	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
161	161	Zouari	Meriem	user161@technova.tn	Femme	26-35	2023-06-17	20230617	Facebook	France	Paris	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
162	162	Miled	Ines	user162@technova.tn	Femme	26-35	2023-01-30	20230130	Google	Tunisie	Nabeul	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
163	163	Sassi	Amine	user163@technova.tn	Homme	46+	2021-08-21	20210821	Referral	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
164	164	Trabelsi	Meriem	user164@technova.tn	Femme	46+	2022-08-08	20220808	Facebook	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
165	165	Gharbi	Hedi	user165@technova.tn	Homme	36-45	2021-05-13	20210513	LinkedIn	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
166	166	Zouari	Karim	user166@technova.tn	Homme	18-25	2021-10-12	20211012	Google	Algérie	Alger	Maghreb	MENA	Entreprise	199.00	1	Inactif	2026-05-22	\N	1
167	167	Dridi	Meriem	user167@technova.tn	Femme	46+	2021-06-26	20210626	Email	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
168	168	Miled	Meriem	user168@technova.tn	Femme	26-35	2021-06-01	20210601	Direct	Maroc	Casablanca	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
169	169	Chebbi	Nadia	user169@technova.tn	Femme	36-45	2021-04-24	20210424	LinkedIn	France	Paris	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
170	170	Sassi	Karim	user170@technova.tn	Homme	46+	2021-06-11	20210611	Direct	France	Lyon	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
171	171	Boughanmi	Nadia	user171@technova.tn	Femme	46+	2021-11-12	20211112	Email	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
172	172	Ben Ali	Rania	user172@technova.tn	Femme	18-25	2022-06-27	20220627	Referral	Tunisie	Tunis	Maghreb	MENA	Entreprise	199.00	1	Inactif	2026-05-22	\N	1
173	173	Chebbi	Hedi	user173@technova.tn	Homme	46+	2023-04-12	20230412	Email	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
174	174	Chaabane	Karim	user174@technova.tn	Homme	46+	2021-10-22	20211022	LinkedIn	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
175	175	Gharbi	Amira	user175@technova.tn	Femme	36-45	2021-09-08	20210908	Facebook	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
176	176	Jebali	Mohamed	user176@technova.tn	Homme	26-35	2021-11-24	20211124	Email	Maroc	Rabat	Maghreb	MENA	Entreprise	199.00	1	Inactif	2026-05-22	\N	1
177	177	Zouari	Fatma	user177@technova.tn	Femme	46+	2022-09-24	20220924	Referral	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
178	178	Hamdi	Fatma	user178@technova.tn	Femme	18-25	2023-08-22	20230822	Google	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
179	179	Chebbi	Nadia	user179@technova.tn	Femme	36-45	2023-04-01	20230401	Facebook	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
180	180	Jebali	Meriem	user180@technova.tn	Femme	46+	2022-07-27	20220727	Google	Tunisie	Bizerte	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
181	181	Zouari	Ines	user181@technova.tn	Femme	26-35	2023-11-09	20231109	Google	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
182	182	Mansouri	Karim	user182@technova.tn	Homme	46+	2023-11-22	20231122	Direct	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
183	183	Miled	Nadia	user183@technova.tn	Femme	46+	2023-12-27	20231227	LinkedIn	Algérie	Oran	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
184	184	Sassi	Sonia	user184@technova.tn	Femme	36-45	2021-02-24	20210224	Email	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
185	185	Dridi	Mohamed	user185@technova.tn	Homme	46+	2023-02-18	20230218	Facebook	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
186	186	Mansouri	Nabil	user186@technova.tn	Homme	18-25	2023-05-08	20230508	Facebook	Tunisie	Sfax	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
187	187	Zouari	Meriem	user187@technova.tn	Femme	26-35	2022-10-28	20221028	LinkedIn	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
188	188	Chebbi	Hedi	user188@technova.tn	Homme	46+	2022-06-26	20220626	Facebook	Algérie	Oran	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
189	189	Jebali	Meriem	user189@technova.tn	Femme	36-45	2023-09-29	20230929	Direct	France	Lyon	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
190	190	Trabelsi	Salma	user190@technova.tn	Femme	36-45	2021-10-27	20211027	Email	Maroc	Rabat	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
191	191	Chebbi	Sami	user191@technova.tn	Homme	46+	2022-07-10	20220710	Facebook	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
192	192	Mansouri	Nabil	user192@technova.tn	Homme	18-25	2023-12-24	20231224	Google	France	Paris	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
193	193	Sassi	Bilel	user193@technova.tn	Homme	26-35	2021-11-20	20211120	Referral	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
194	194	Zouari	Fatma	user194@technova.tn	Femme	36-45	2021-07-03	20210703	Email	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
195	195	Miled	Karim	user195@technova.tn	Homme	36-45	2022-01-17	20220117	Google	France	Paris	Europe	UE	Premium	99.00	1	Inactif	2026-05-22	\N	1
196	196	Dridi	Rania	user196@technova.tn	Femme	36-45	2023-12-10	20231210	Facebook	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
197	197	Hamdi	Salma	user197@technova.tn	Femme	26-35	2022-06-11	20220611	LinkedIn	Tunisie	Sousse	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
198	198	Boughanmi	Rania	user198@technova.tn	Femme	46+	2023-04-11	20230411	Google	France	Paris	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
199	199	Gharbi	Rim	user199@technova.tn	Femme	36-45	2021-01-14	20210114	Referral	France	Lyon	Europe	UE	Entreprise	199.00	1	Actif	2026-05-22	\N	1
200	200	Jebali	Ines	user200@technova.tn	Femme	46+	2022-04-29	20220429	Referral	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
201	201	Miled	Nadia	user201@technova.tn	Femme	46+	2022-08-28	20220828	Facebook	Algérie	Alger	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
202	202	Gharbi	Hedi	user202@technova.tn	Homme	36-45	2023-08-23	20230823	Facebook	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
203	203	Rekik	Nabil	user203@technova.tn	Homme	46+	2023-01-11	20230111	Google	Tunisie	Nabeul	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
204	204	Chebbi	Amine	user204@technova.tn	Homme	46+	2022-11-03	20221103	Email	France	Marseille	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
205	205	Chaabane	Nabil	user205@technova.tn	Homme	46+	2023-07-18	20230718	Referral	Tunisie	Nabeul	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
206	206	Chaabane	Amine	user206@technova.tn	Homme	36-45	2021-01-07	20210107	Google	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
207	207	Mansouri	Ines	user207@technova.tn	Femme	18-25	2021-05-22	20210522	Referral	Tunisie	Nabeul	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
208	208	Zouari	Karim	user208@technova.tn	Homme	36-45	2023-02-13	20230213	Email	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
209	209	Trabelsi	Sami	user209@technova.tn	Homme	36-45	2022-04-02	20220402	LinkedIn	France	Marseille	Europe	UE	Standard	49.00	1	Inactif	2026-05-22	\N	1
210	210	Miled	Meriem	user210@technova.tn	Femme	26-35	2021-11-14	20211114	Email	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
211	211	Zouari	Mohamed	user211@technova.tn	Homme	26-35	2021-07-26	20210726	Email	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
212	212	Mansouri	Yassine	user212@technova.tn	Homme	46+	2022-03-21	20220321	LinkedIn	Tunisie	Bizerte	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
213	213	Sassi	Nabil	user213@technova.tn	Homme	36-45	2023-12-04	20231204	LinkedIn	Algérie	Alger	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
214	214	Dridi	Amine	user214@technova.tn	Homme	36-45	2021-04-07	20210407	Email	France	Marseille	Europe	UE	Standard	49.00	1	Inactif	2026-05-22	\N	1
215	215	Sassi	Meriem	user215@technova.tn	Femme	26-35	2022-01-12	20220112	Facebook	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
216	216	Zouari	Nadia	user216@technova.tn	Femme	46+	2023-05-04	20230504	Referral	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
217	217	Hamdi	Omar	user217@technova.tn	Homme	46+	2021-07-09	20210709	Facebook	Algérie	Alger	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
218	218	Miled	Omar	user218@technova.tn	Homme	26-35	2022-03-21	20220321	LinkedIn	Tunisie	Tunis	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
219	219	Hamdi	Sonia	user219@technova.tn	Femme	18-25	2023-09-08	20230908	Email	France	Marseille	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
220	220	Chebbi	Bilel	user220@technova.tn	Homme	36-45	2023-02-19	20230219	LinkedIn	France	Marseille	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
221	221	Sassi	Salma	user221@technova.tn	Femme	18-25	2023-08-20	20230820	LinkedIn	Maroc	Rabat	Maghreb	MENA	Premium	99.00	1	Inactif	2026-05-22	\N	1
222	222	Ben Ali	Amira	user222@technova.tn	Femme	26-35	2023-05-06	20230506	LinkedIn	France	Marseille	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
223	223	Dridi	Bilel	user223@technova.tn	Homme	46+	2022-11-23	20221123	Referral	France	Lyon	Europe	UE	Standard	49.00	1	Inactif	2026-05-22	\N	1
224	224	Gharbi	Leila	user224@technova.tn	Femme	26-35	2023-09-28	20230928	Direct	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
225	225	Ben Ali	Amine	user225@technova.tn	Homme	18-25	2022-04-19	20220419	Google	Tunisie	Tunis	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
226	226	Chaabane	Amine	user226@technova.tn	Homme	46+	2023-09-17	20230917	Direct	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
227	227	Ben Ali	Sonia	user227@technova.tn	Femme	18-25	2023-06-01	20230601	Google	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
228	228	Hamdi	Yassine	user228@technova.tn	Homme	26-35	2021-06-11	20210611	Referral	Algérie	Oran	Maghreb	MENA	Premium	99.00	1	Banni	2026-05-22	\N	1
229	229	Jebali	Yassine	user229@technova.tn	Homme	18-25	2023-02-12	20230212	Email	Tunisie	Tunis	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
230	230	Trabelsi	Karim	user230@technova.tn	Homme	46+	2021-07-15	20210715	Facebook	Maroc	Rabat	Maghreb	MENA	Premium	99.00	1	Inactif	2026-05-22	\N	1
231	231	Chaabane	Nabil	user231@technova.tn	Homme	18-25	2022-07-29	20220729	Google	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
232	232	Ben Ali	Sami	user232@technova.tn	Homme	26-35	2023-03-27	20230327	Direct	France	Marseille	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
233	233	Rekik	Nabil	user233@technova.tn	Homme	36-45	2021-10-14	20211014	LinkedIn	Maroc	Rabat	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
234	234	Miled	Ahmed	user234@technova.tn	Homme	36-45	2023-03-24	20230324	LinkedIn	France	Paris	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
235	235	Hamdi	Leila	user235@technova.tn	Femme	36-45	2023-02-18	20230218	LinkedIn	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
236	236	Trabelsi	Ahmed	user236@technova.tn	Homme	36-45	2021-11-12	20211112	Google	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
237	237	Jebali	Mohamed	user237@technova.tn	Homme	26-35	2021-06-28	20210628	Direct	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
238	238	Ben Ali	Rim	user238@technova.tn	Femme	46+	2022-10-27	20221027	Referral	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
239	239	Mansouri	Rim	user239@technova.tn	Femme	46+	2023-02-19	20230219	LinkedIn	France	Marseille	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
240	240	Gharbi	Leila	user240@technova.tn	Femme	36-45	2022-09-06	20220906	LinkedIn	Tunisie	Sfax	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
241	241	Mansouri	Fatma	user241@technova.tn	Femme	46+	2022-09-16	20220916	LinkedIn	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
242	242	Chaabane	Ines	user242@technova.tn	Femme	46+	2021-10-06	20211006	Email	Algérie	Oran	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
243	243	Sassi	Hedi	user243@technova.tn	Homme	36-45	2023-10-03	20231003	LinkedIn	France	Lyon	Europe	UE	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
244	244	Rekik	Salma	user244@technova.tn	Femme	18-25	2022-02-14	20220214	Direct	Maroc	Rabat	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
245	245	Mansouri	Hedi	user245@technova.tn	Homme	36-45	2021-05-22	20210522	Facebook	France	Lyon	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
246	246	Jebali	Fatma	user246@technova.tn	Femme	36-45	2021-06-01	20210601	Referral	France	Marseille	Europe	UE	Premium	99.00	1	Banni	2026-05-22	\N	1
247	247	Karray	Meriem	user247@technova.tn	Femme	36-45	2021-06-24	20210624	Email	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
248	248	Boughanmi	Nadia	user248@technova.tn	Femme	46+	2023-03-30	20230330	Referral	Tunisie	Nabeul	Maghreb	MENA	Standard	49.00	1	Banni	2026-05-22	\N	1
249	249	Trabelsi	Mohamed	user249@technova.tn	Homme	46+	2022-03-29	20220329	Referral	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
250	250	Ben Ali	Sami	user250@technova.tn	Homme	36-45	2021-06-25	20210625	Email	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
251	251	Jebali	Sami	user251@technova.tn	Homme	26-35	2022-12-15	20221215	Email	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
252	252	Trabelsi	Ines	user252@technova.tn	Femme	18-25	2022-12-04	20221204	Facebook	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
253	253	Gharbi	Amine	user253@technova.tn	Homme	46+	2023-08-05	20230805	Email	France	Lyon	Europe	UE	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
254	254	Boughanmi	Karim	user254@technova.tn	Homme	18-25	2022-02-09	20220209	Referral	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
255	255	Hamdi	Yassine	user255@technova.tn	Homme	46+	2022-01-18	20220118	Referral	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
256	256	Boughanmi	Omar	user256@technova.tn	Homme	46+	2023-03-15	20230315	Referral	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
257	257	Chebbi	Omar	user257@technova.tn	Homme	36-45	2022-09-18	20220918	Email	Tunisie	Sfax	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
258	258	Miled	Amine	user258@technova.tn	Homme	46+	2022-01-16	20220116	Email	Maroc	Casablanca	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
259	259	Gharbi	Amine	user259@technova.tn	Homme	26-35	2023-07-13	20230713	Google	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
260	260	Hamdi	Nadia	user260@technova.tn	Femme	36-45	2023-05-02	20230502	Google	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
261	261	Jebali	Yassine	user261@technova.tn	Homme	26-35	2021-12-11	20211211	Referral	Tunisie	Sousse	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
262	262	Trabelsi	Nabil	user262@technova.tn	Homme	46+	2021-03-27	20210327	Referral	Algérie	Oran	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
263	263	Jebali	Yassine	user263@technova.tn	Homme	26-35	2021-06-28	20210628	Google	Tunisie	Bizerte	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
264	264	Zouari	Yassine	user264@technova.tn	Homme	26-35	2022-02-28	20220228	Direct	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
265	265	Jebali	Meriem	user265@technova.tn	Femme	36-45	2022-07-02	20220702	Email	France	Lyon	Europe	UE	Gratuit	0.00	0	Banni	2026-05-22	\N	1
266	266	Zouari	Karim	user266@technova.tn	Homme	26-35	2021-09-17	20210917	Email	Maroc	Casablanca	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
267	267	Zouari	Fatma	user267@technova.tn	Femme	26-35	2022-07-05	20220705	Google	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
268	268	Karray	Bilel	user268@technova.tn	Homme	46+	2022-11-02	20221102	Email	Algérie	Oran	Maghreb	MENA	Entreprise	199.00	1	Actif	2026-05-22	\N	1
269	269	Boughanmi	Hedi	user269@technova.tn	Homme	46+	2023-05-30	20230530	LinkedIn	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
270	270	Karray	Ines	user270@technova.tn	Femme	46+	2021-04-10	20210410	Referral	France	Marseille	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
271	271	Chebbi	Ahmed	user271@technova.tn	Homme	46+	2023-05-27	20230527	Facebook	France	Lyon	Europe	UE	Gratuit	0.00	0	Banni	2026-05-22	\N	1
272	272	Rekik	Nadia	user272@technova.tn	Femme	46+	2021-06-18	20210618	Email	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
273	273	Miled	Mohamed	user273@technova.tn	Homme	36-45	2021-07-14	20210714	Google	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
274	274	Hamdi	Nabil	user274@technova.tn	Homme	18-25	2021-09-04	20210904	Referral	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
275	275	Miled	Yassine	user275@technova.tn	Homme	18-25	2022-09-05	20220905	Facebook	Tunisie	Tunis	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
276	276	Karray	Ahmed	user276@technova.tn	Homme	46+	2022-12-21	20221221	Facebook	Tunisie	Nabeul	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
277	277	Boughanmi	Rania	user277@technova.tn	Femme	18-25	2021-10-14	20211014	Referral	Maroc	Casablanca	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
278	278	Sassi	Amira	user278@technova.tn	Femme	26-35	2022-05-24	20220524	Email	France	Paris	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
279	279	Rekik	Sonia	user279@technova.tn	Femme	46+	2022-01-22	20220122	Google	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
280	280	Miled	Hedi	user280@technova.tn	Homme	46+	2021-05-26	20210526	Google	Tunisie	Sfax	Maghreb	MENA	Standard	49.00	1	Inactif	2026-05-22	\N	1
281	281	Gharbi	Ines	user281@technova.tn	Femme	36-45	2021-12-20	20211220	Google	Maroc	Rabat	Maghreb	MENA	Standard	49.00	1	Banni	2026-05-22	\N	1
282	282	Trabelsi	Nabil	user282@technova.tn	Homme	26-35	2021-05-04	20210504	Email	Tunisie	Sousse	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
283	283	Mansouri	Amira	user283@technova.tn	Femme	46+	2021-11-09	20211109	Google	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
284	284	Karray	Karim	user284@technova.tn	Homme	46+	2021-05-16	20210516	Email	Algérie	Oran	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
285	285	Hamdi	Mohamed	user285@technova.tn	Homme	18-25	2021-04-23	20210423	Email	Tunisie	Bizerte	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
286	286	Ben Ali	Ahmed	user286@technova.tn	Homme	18-25	2022-12-12	20221212	Email	France	Marseille	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
287	287	Sassi	Nadia	user287@technova.tn	Femme	26-35	2021-08-30	20210830	Referral	France	Marseille	Europe	UE	Standard	49.00	1	Actif	2026-05-22	\N	1
288	288	Trabelsi	Meriem	user288@technova.tn	Femme	46+	2023-01-08	20230108	Direct	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
289	289	Gharbi	Sami	user289@technova.tn	Homme	46+	2021-08-25	20210825	Google	Algérie	Alger	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
290	290	Hamdi	Mohamed	user290@technova.tn	Homme	36-45	2021-11-04	20211104	Google	Tunisie	Bizerte	Maghreb	MENA	Gratuit	0.00	0	Inactif	2026-05-22	\N	1
291	291	Sassi	Fatma	user291@technova.tn	Femme	36-45	2021-06-09	20210609	Direct	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
292	292	Hamdi	Karim	user292@technova.tn	Homme	18-25	2022-08-02	20220802	Direct	Tunisie	Bizerte	Maghreb	MENA	Premium	99.00	1	Actif	2026-05-22	\N	1
293	293	Sassi	Sonia	user293@technova.tn	Femme	46+	2022-05-12	20220512	Referral	France	Lyon	Europe	UE	Premium	99.00	1	Actif	2026-05-22	\N	1
294	294	Zouari	Amine	user294@technova.tn	Homme	18-25	2021-02-18	20210218	Email	France	Paris	Europe	UE	Entreprise	199.00	1	Actif	2026-05-22	\N	1
295	295	Ben Ali	Sami	user295@technova.tn	Homme	18-25	2022-05-03	20220503	Google	Maroc	Rabat	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
296	296	Trabelsi	Omar	user296@technova.tn	Homme	46+	2023-02-02	20230202	Google	Tunisie	Sfax	Maghreb	MENA	Gratuit	0.00	0	Banni	2026-05-22	\N	1
297	297	Gharbi	Amine	user297@technova.tn	Homme	46+	2023-06-10	20230610	LinkedIn	Maroc	Casablanca	Maghreb	MENA	Standard	49.00	1	Actif	2026-05-22	\N	1
298	298	Mansouri	Amira	user298@technova.tn	Femme	46+	2021-06-02	20210602	Direct	Algérie	Oran	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
299	299	Trabelsi	Karim	user299@technova.tn	Homme	46+	2021-09-05	20210905	Facebook	France	Lyon	Europe	UE	Gratuit	0.00	0	Actif	2026-05-22	\N	1
300	300	Chaabane	Salma	user300@technova.tn	Femme	18-25	2022-09-16	20220916	LinkedIn	Algérie	Alger	Maghreb	MENA	Gratuit	0.00	0	Actif	2026-05-22	\N	1
\.


--
-- Data for Name: fact_serverperformance; Type: TABLE DATA; Schema: technova_dw; Owner: -
--

COPY technova_dw.fact_serverperformance (perf_sk, perf_id, date_sk, heure, temps_reponse_ms, taux_erreur_pct, cpu_usage_pct, ram_usage_pct, nb_requetes, statut_serveur, est_incident, etl_loaded_at) FROM stdin;
63	63	20220222	0	945	0.17	75.45	30.71	40607	OK	0	2026-05-22 23:28:36.880998
1	1	20221204	0	161	12.05	64.97	33.63	7204	OK	0	2026-05-22 23:28:36.880998
2	2	20220802	0	209	5.44	76.20	43.48	15797	OK	0	2026-05-22 23:28:36.880998
3	3	20230801	0	383	8.12	15.55	61.80	49679	OK	0	2026-05-22 23:28:36.880998
4	4	20230926	0	434	8.28	64.26	22.27	17740	OK	0	2026-05-22 23:28:36.880998
5	5	20220624	0	1217	8.47	57.92	75.32	3093	OK	0	2026-05-22 23:28:36.880998
6	6	20220409	0	694	1.40	36.23	88.64	49362	OK	0	2026-05-22 23:28:36.880998
7	7	20230802	0	865	7.50	36.73	47.34	23420	OK	0	2026-05-22 23:28:36.880998
8	8	20220923	0	1489	10.12	38.16	82.76	33102	OK	0	2026-05-22 23:28:36.880998
9	9	20220726	0	1078	12.11	22.77	61.10	25142	OK	0	2026-05-22 23:28:36.880998
10	10	20240903	0	1250	13.03	13.18	31.29	44820	OK	0	2026-05-22 23:28:36.880998
11	11	20240806	0	211	13.28	17.93	70.29	14232	OK	0	2026-05-22 23:28:36.880998
12	12	20221016	0	1624	10.78	94.44	55.11	47857	OK	0	2026-05-22 23:28:36.880998
13	13	20241207	0	1955	11.53	48.04	29.18	19160	OK	0	2026-05-22 23:28:36.880998
14	14	20240108	0	1326	12.84	46.63	82.35	44852	OK	0	2026-05-22 23:28:36.880998
15	15	20240304	0	539	3.13	61.88	25.25	10087	OK	0	2026-05-22 23:28:36.880998
16	16	20241015	0	249	12.07	22.12	80.93	35957	OK	0	2026-05-22 23:28:36.880998
17	17	20220628	0	1071	1.41	36.67	85.38	10682	OK	0	2026-05-22 23:28:36.880998
18	18	20220520	0	623	8.65	40.04	24.98	46673	OK	0	2026-05-22 23:28:36.880998
19	19	20240801	0	578	14.79	93.17	73.42	29069	OK	0	2026-05-22 23:28:36.880998
20	20	20221015	0	1974	1.86	58.34	22.77	18884	OK	0	2026-05-22 23:28:36.880998
21	21	20240401	0	887	12.86	87.96	29.03	24134	OK	0	2026-05-22 23:28:36.880998
22	22	20241115	0	1780	9.37	36.66	25.84	27179	OK	0	2026-05-22 23:28:36.880998
23	23	20241102	0	971	3.94	84.42	67.78	40772	OK	0	2026-05-22 23:28:36.880998
24	24	20220427	0	1567	11.86	69.48	59.26	10229	Dégradé	1	2026-05-22 23:28:36.880998
25	25	20220804	0	645	5.64	58.46	79.77	14717	OK	0	2026-05-22 23:28:36.880998
26	26	20240306	0	1840	6.93	17.95	52.61	42205	OK	0	2026-05-22 23:28:36.880998
27	27	20241231	0	1893	12.27	19.28	32.62	7200	OK	0	2026-05-22 23:28:36.880998
28	28	20240323	0	1623	6.50	44.13	24.51	22541	OK	0	2026-05-22 23:28:36.880998
29	29	20240922	0	485	10.53	50.48	39.49	2608	OK	0	2026-05-22 23:28:36.880998
30	30	20221115	0	1992	7.05	64.42	42.41	2152	OK	0	2026-05-22 23:28:36.880998
31	31	20240218	0	177	14.05	40.73	50.11	31125	OK	0	2026-05-22 23:28:36.880998
32	32	20230314	0	160	3.17	11.95	73.10	27816	OK	0	2026-05-22 23:28:36.880998
33	33	20230707	0	566	9.54	17.11	24.85	26646	OK	0	2026-05-22 23:28:36.880998
34	34	20220617	0	660	13.11	48.37	49.38	14131	OK	0	2026-05-22 23:28:36.880998
35	35	20230616	0	426	12.46	17.86	83.11	22514	OK	0	2026-05-22 23:28:36.880998
36	36	20230901	0	386	2.98	90.07	53.71	35194	OK	0	2026-05-22 23:28:36.880998
37	37	20221126	0	1476	6.55	87.57	59.92	750	OK	0	2026-05-22 23:28:36.880998
38	38	20230211	0	209	10.84	59.17	30.12	43620	OK	0	2026-05-22 23:28:36.880998
39	39	20231011	0	79	2.26	48.99	30.32	20836	OK	0	2026-05-22 23:28:36.880998
40	40	20220821	0	1672	14.55	44.54	56.45	340	OK	0	2026-05-22 23:28:36.880998
41	41	20240711	0	1981	12.49	20.69	51.45	38004	OK	0	2026-05-22 23:28:36.880998
42	42	20220719	0	124	3.28	93.22	49.41	35888	OK	0	2026-05-22 23:28:36.880998
43	43	20221207	0	1280	5.66	39.59	86.67	44640	OK	0	2026-05-22 23:28:36.880998
44	44	20220130	0	808	12.21	11.38	82.77	33004	OK	0	2026-05-22 23:28:36.880998
45	45	20220913	0	1482	7.49	94.92	48.98	23150	OK	0	2026-05-22 23:28:36.880998
46	46	20231223	0	1746	8.14	54.47	73.56	7530	OK	0	2026-05-22 23:28:36.880998
47	47	20221227	0	989	6.43	25.04	61.64	35670	OK	0	2026-05-22 23:28:36.880998
48	48	20240611	0	831	4.28	66.07	67.62	41656	OK	0	2026-05-22 23:28:36.880998
49	49	20230804	0	1487	9.31	88.64	79.99	5842	OK	0	2026-05-22 23:28:36.880998
50	50	20220801	0	233	9.74	62.38	48.79	32632	OK	0	2026-05-22 23:28:36.880998
51	51	20220724	0	1347	6.66	59.40	22.28	19099	OK	0	2026-05-22 23:28:36.880998
52	52	20240511	0	483	3.34	48.64	46.68	12916	OK	0	2026-05-22 23:28:36.880998
53	53	20240819	0	1996	1.87	92.25	83.98	27162	OK	0	2026-05-22 23:28:36.880998
54	54	20240321	0	65	14.09	76.49	55.53	17638	OK	0	2026-05-22 23:28:36.880998
55	55	20230626	0	679	12.58	77.59	49.03	15930	OK	0	2026-05-22 23:28:36.880998
56	56	20220109	0	1893	13.64	12.78	21.84	24637	OK	0	2026-05-22 23:28:36.880998
57	57	20241128	0	1729	11.12	36.99	31.93	37598	OK	0	2026-05-22 23:28:36.880998
58	58	20240530	0	545	8.34	43.27	63.14	25876	OK	0	2026-05-22 23:28:36.880998
59	59	20220416	0	1691	13.98	46.47	85.76	25686	OK	0	2026-05-22 23:28:36.880998
60	60	20221222	0	875	13.56	53.97	50.62	6625	OK	0	2026-05-22 23:28:36.880998
61	61	20220916	0	1082	1.78	59.04	47.44	41211	OK	0	2026-05-22 23:28:36.880998
62	62	20230617	0	1764	8.29	90.64	34.26	6212	OK	0	2026-05-22 23:28:36.880998
64	64	20220611	0	1221	5.74	73.10	29.14	29834	OK	0	2026-05-22 23:28:36.880998
65	65	20240104	0	432	3.60	86.32	40.78	35189	OK	0	2026-05-22 23:28:36.880998
66	66	20230518	0	1537	11.70	76.81	73.93	43305	OK	0	2026-05-22 23:28:36.880998
67	67	20220416	0	613	1.24	22.22	21.62	38068	OK	0	2026-05-22 23:28:36.880998
68	68	20220731	0	277	6.89	60.65	27.50	18611	OK	0	2026-05-22 23:28:36.880998
69	69	20230621	0	1882	2.71	16.58	79.12	13729	OK	0	2026-05-22 23:28:36.880998
70	70	20240311	0	256	7.37	11.87	25.15	41104	OK	0	2026-05-22 23:28:36.880998
71	71	20220606	0	480	10.31	41.90	41.95	29648	OK	0	2026-05-22 23:28:36.880998
72	72	20221126	0	418	4.48	86.81	66.18	41467	OK	0	2026-05-22 23:28:36.880998
73	73	20220306	0	290	14.64	94.47	53.87	40339	OK	0	2026-05-22 23:28:36.880998
74	74	20220111	0	374	7.83	31.63	28.51	39822	OK	0	2026-05-22 23:28:36.880998
75	75	20220302	0	1147	0.35	53.50	30.66	24013	OK	0	2026-05-22 23:28:36.880998
76	76	20220824	0	1890	3.25	37.84	35.38	47793	OK	0	2026-05-22 23:28:36.880998
77	77	20220917	0	598	4.10	26.94	26.44	46504	OK	0	2026-05-22 23:28:36.880998
78	78	20230826	0	1006	11.18	52.14	55.89	26310	OK	0	2026-05-22 23:28:36.880998
79	79	20230131	0	562	2.59	68.40	82.11	18521	OK	0	2026-05-22 23:28:36.880998
80	80	20240315	0	260	8.75	75.15	41.81	13589	OK	0	2026-05-22 23:28:36.880998
81	81	20240926	0	937	13.24	46.02	72.30	20989	OK	0	2026-05-22 23:28:36.880998
82	82	20220809	0	1293	5.75	26.98	44.70	41564	OK	0	2026-05-22 23:28:36.880998
83	83	20220512	0	970	2.51	12.87	55.79	38561	OK	0	2026-05-22 23:28:36.880998
84	84	20240419	0	651	9.06	84.57	86.53	34866	OK	0	2026-05-22 23:28:36.880998
85	85	20231223	0	865	0.45	25.29	42.59	12284	OK	0	2026-05-22 23:28:36.880998
86	86	20240103	0	552	1.09	65.84	46.04	20707	OK	0	2026-05-22 23:28:36.880998
87	87	20220908	0	69	4.78	10.93	43.02	30598	OK	0	2026-05-22 23:28:36.880998
88	88	20231021	0	1890	3.49	15.63	39.85	14005	OK	0	2026-05-22 23:28:36.880998
89	89	20241215	0	495	1.54	33.63	62.55	44097	OK	0	2026-05-22 23:28:36.880998
90	90	20220603	0	1225	13.39	45.85	72.93	20926	OK	0	2026-05-22 23:28:36.880998
91	91	20231018	0	455	2.96	78.23	54.91	18084	OK	0	2026-05-22 23:28:36.880998
92	92	20240512	0	294	1.86	24.55	42.88	25190	OK	0	2026-05-22 23:28:36.880998
93	93	20230430	0	1230	0.32	11.52	74.83	37832	OK	0	2026-05-22 23:28:36.880998
94	94	20220110	0	1917	6.93	21.14	87.68	2525	OK	0	2026-05-22 23:28:36.880998
95	95	20241228	0	1930	7.91	38.68	21.14	30894	OK	0	2026-05-22 23:28:36.880998
96	96	20220714	0	1749	12.04	71.48	39.23	49493	OK	0	2026-05-22 23:28:36.880998
97	97	20231210	0	869	1.20	75.84	54.57	3184	OK	0	2026-05-22 23:28:36.880998
98	98	20240316	0	661	10.45	48.64	79.41	8056	OK	0	2026-05-22 23:28:36.880998
99	99	20240205	0	1970	9.27	12.49	23.35	781	OK	0	2026-05-22 23:28:36.880998
100	100	20221012	0	265	14.90	83.22	70.70	14933	OK	0	2026-05-22 23:28:36.880998
101	101	20221215	0	230	2.87	86.69	45.82	35329	OK	0	2026-05-22 23:28:36.880998
102	102	20220111	0	1963	10.32	14.46	81.83	2923	OK	0	2026-05-22 23:28:36.880998
103	103	20220815	0	148	14.21	16.38	43.05	40257	OK	0	2026-05-22 23:28:36.880998
104	104	20240217	0	602	10.48	88.61	60.84	7957	OK	0	2026-05-22 23:28:36.880998
105	105	20220916	0	703	12.93	74.01	82.15	27185	OK	0	2026-05-22 23:28:36.880998
106	106	20240704	0	1418	1.84	54.85	60.45	43436	OK	0	2026-05-22 23:28:36.880998
107	107	20240930	0	624	4.83	72.12	35.81	17389	OK	0	2026-05-22 23:28:36.880998
108	108	20230830	0	1506	1.24	57.47	81.10	43319	OK	0	2026-05-22 23:28:36.880998
109	109	20230226	0	1473	1.17	92.60	24.22	960	OK	0	2026-05-22 23:28:36.880998
110	110	20230319	0	1008	12.28	25.97	27.32	13774	OK	0	2026-05-22 23:28:36.880998
111	111	20241216	0	1102	12.88	74.64	41.83	29854	OK	0	2026-05-22 23:28:36.880998
112	112	20221112	0	1786	7.57	87.70	35.31	23931	OK	0	2026-05-22 23:28:36.880998
113	113	20240229	0	976	13.02	53.64	74.60	12417	OK	0	2026-05-22 23:28:36.880998
114	114	20220521	0	619	6.35	68.33	86.60	37930	OK	0	2026-05-22 23:28:36.880998
115	115	20220729	0	351	6.91	19.11	27.71	1187	OK	0	2026-05-22 23:28:36.880998
116	116	20240801	0	433	4.00	50.48	57.16	23165	OK	0	2026-05-22 23:28:36.880998
117	117	20230628	0	292	13.90	17.15	50.20	9971	OK	0	2026-05-22 23:28:36.880998
118	118	20240323	0	1078	6.46	38.37	50.89	24333	OK	0	2026-05-22 23:28:36.880998
119	119	20220720	0	150	9.73	72.22	49.58	19367	OK	0	2026-05-22 23:28:36.880998
120	120	20230123	0	874	2.65	33.45	62.52	34088	OK	0	2026-05-22 23:28:36.880998
121	121	20240606	0	273	10.22	64.94	87.13	14490	OK	0	2026-05-22 23:28:36.880998
122	122	20220824	0	158	13.43	58.89	36.71	34973	OK	0	2026-05-22 23:28:36.880998
123	123	20220726	0	614	3.40	62.72	70.11	25784	OK	0	2026-05-22 23:28:36.880998
124	124	20240315	0	257	3.30	80.05	68.42	32551	OK	0	2026-05-22 23:28:36.880998
125	125	20230226	0	400	11.79	39.55	40.16	39179	OK	0	2026-05-22 23:28:36.880998
126	126	20230813	0	1552	0.05	25.73	83.54	40871	OK	0	2026-05-22 23:28:36.880998
127	127	20240903	0	1563	4.58	87.07	36.70	20751	OK	0	2026-05-22 23:28:36.880998
128	128	20220523	0	391	2.81	86.49	29.93	934	OK	0	2026-05-22 23:28:36.880998
129	129	20240829	0	926	5.01	25.09	38.47	5144	OK	0	2026-05-22 23:28:36.880998
130	130	20221216	0	1441	11.40	10.83	44.65	31152	OK	0	2026-05-22 23:28:36.880998
131	131	20220103	0	1050	13.10	50.17	23.16	1239	OK	0	2026-05-22 23:28:36.880998
132	132	20230819	0	1760	3.42	52.77	72.85	6254	En panne	1	2026-05-22 23:28:36.880998
133	133	20220724	0	673	12.06	38.53	54.35	23088	OK	0	2026-05-22 23:28:36.880998
134	134	20230612	0	1408	7.30	40.96	20.95	23209	OK	0	2026-05-22 23:28:36.880998
135	135	20230909	0	1504	5.01	54.02	66.48	39142	OK	0	2026-05-22 23:28:36.880998
136	136	20240918	0	280	4.05	54.14	64.79	9792	OK	0	2026-05-22 23:28:36.880998
137	137	20240420	0	1803	3.30	94.50	45.00	2125	OK	0	2026-05-22 23:28:36.880998
138	138	20230516	0	1232	11.12	92.73	45.16	48882	OK	0	2026-05-22 23:28:36.880998
139	139	20220702	0	446	13.81	42.11	27.56	18051	OK	0	2026-05-22 23:28:36.880998
140	140	20240709	0	1844	7.90	32.55	67.53	21805	OK	0	2026-05-22 23:28:36.880998
141	141	20240311	0	1256	6.26	94.49	41.65	2793	OK	0	2026-05-22 23:28:36.880998
142	142	20241201	0	1487	5.15	62.05	50.34	29920	OK	0	2026-05-22 23:28:36.880998
143	143	20231212	0	640	1.65	10.71	84.91	9742	OK	0	2026-05-22 23:28:36.880998
144	144	20240813	0	1444	2.25	92.17	63.67	43636	OK	0	2026-05-22 23:28:36.880998
145	145	20221130	0	671	7.30	15.49	40.63	29844	OK	0	2026-05-22 23:28:36.880998
146	146	20220325	0	495	4.25	60.41	23.72	20142	OK	0	2026-05-22 23:28:36.880998
147	147	20220111	0	931	5.28	80.90	23.49	9125	OK	0	2026-05-22 23:28:36.880998
148	148	20231219	0	1849	4.25	83.02	66.57	36849	OK	0	2026-05-22 23:28:36.880998
149	149	20221114	0	226	10.70	22.12	71.31	28414	OK	0	2026-05-22 23:28:36.880998
150	150	20220615	0	645	3.28	50.22	44.82	44566	OK	0	2026-05-22 23:28:36.880998
151	151	20240302	0	915	5.99	86.85	82.51	19893	OK	0	2026-05-22 23:28:36.880998
152	152	20230929	0	404	8.46	67.71	42.57	37990	OK	0	2026-05-22 23:28:36.880998
153	153	20221013	0	1449	11.51	31.25	49.14	13175	OK	0	2026-05-22 23:28:36.880998
154	154	20230909	0	674	1.28	58.17	63.98	35871	OK	0	2026-05-22 23:28:36.880998
155	155	20230111	0	819	11.74	80.88	26.72	34609	OK	0	2026-05-22 23:28:36.880998
156	156	20240624	0	1471	4.70	89.46	69.88	30795	OK	0	2026-05-22 23:28:36.880998
157	157	20231227	0	925	7.00	91.72	52.29	36728	Dégradé	1	2026-05-22 23:28:36.880998
158	158	20220224	0	1620	6.31	74.25	63.06	19917	OK	0	2026-05-22 23:28:36.880998
159	159	20230512	0	1238	7.68	20.82	58.03	37165	OK	0	2026-05-22 23:28:36.880998
160	160	20230824	0	159	11.33	43.38	48.21	490	OK	0	2026-05-22 23:28:36.880998
161	161	20240805	0	1703	11.44	54.03	78.74	5648	OK	0	2026-05-22 23:28:36.880998
162	162	20220423	0	603	12.45	65.24	43.34	6483	OK	0	2026-05-22 23:28:36.880998
163	163	20230819	0	1208	7.22	38.16	24.26	48627	OK	0	2026-05-22 23:28:36.880998
164	164	20241112	0	1564	10.75	69.63	56.14	36934	OK	0	2026-05-22 23:28:36.880998
165	165	20241011	0	329	3.35	67.43	79.66	19819	OK	0	2026-05-22 23:28:36.880998
166	166	20230929	0	1522	14.84	10.55	53.95	45174	OK	0	2026-05-22 23:28:36.880998
167	167	20230216	0	284	1.01	23.01	81.59	34167	OK	0	2026-05-22 23:28:36.880998
168	168	20220718	0	556	3.06	50.27	78.29	29185	OK	0	2026-05-22 23:28:36.880998
169	169	20240311	0	163	13.89	35.49	53.86	12161	OK	0	2026-05-22 23:28:36.880998
170	170	20230427	0	1773	12.72	32.12	62.89	28878	OK	0	2026-05-22 23:28:36.880998
171	171	20220910	0	935	2.19	11.84	29.92	48898	OK	0	2026-05-22 23:28:36.880998
172	172	20230508	0	399	7.67	69.47	34.02	31587	OK	0	2026-05-22 23:28:36.880998
173	173	20230817	0	642	10.01	91.52	54.51	43858	OK	0	2026-05-22 23:28:36.880998
174	174	20230718	0	851	5.79	77.99	52.48	27941	OK	0	2026-05-22 23:28:36.880998
175	175	20221031	0	107	4.25	20.21	47.26	38146	OK	0	2026-05-22 23:28:36.880998
176	176	20230913	0	119	9.68	85.92	63.39	2893	OK	0	2026-05-22 23:28:36.880998
177	177	20231228	0	335	7.02	71.46	39.38	10475	OK	0	2026-05-22 23:28:36.880998
178	178	20240103	0	1075	12.84	52.77	44.42	46383	OK	0	2026-05-22 23:28:36.880998
179	179	20241211	0	849	7.70	24.83	30.60	43087	OK	0	2026-05-22 23:28:36.880998
180	180	20231126	0	991	10.73	76.87	39.48	43251	OK	0	2026-05-22 23:28:36.880998
181	181	20230913	0	1941	5.91	87.87	65.16	24775	OK	0	2026-05-22 23:28:36.880998
182	182	20240824	0	1290	9.88	58.96	84.92	43282	OK	0	2026-05-22 23:28:36.880998
183	183	20241212	0	580	1.94	37.55	86.86	22912	OK	0	2026-05-22 23:28:36.880998
184	184	20240406	0	188	0.67	82.42	31.14	6426	OK	0	2026-05-22 23:28:36.880998
185	185	20220806	0	1072	14.01	50.50	73.19	48114	OK	0	2026-05-22 23:28:36.880998
186	186	20230430	0	265	13.50	24.79	82.47	49633	OK	0	2026-05-22 23:28:36.880998
187	187	20240510	0	1939	0.97	62.01	28.01	49247	OK	0	2026-05-22 23:28:36.880998
188	188	20220530	0	954	11.45	61.56	78.85	11507	OK	0	2026-05-22 23:28:36.880998
189	189	20231020	0	270	10.48	42.10	89.22	37703	OK	0	2026-05-22 23:28:36.880998
190	190	20230214	0	450	3.79	47.19	40.03	13285	OK	0	2026-05-22 23:28:36.880998
191	191	20221128	0	938	12.21	78.74	33.46	38249	OK	0	2026-05-22 23:28:36.880998
192	192	20220219	0	1338	14.40	18.18	22.33	9311	OK	0	2026-05-22 23:28:36.880998
193	193	20220111	0	786	11.62	58.31	80.51	22428	OK	0	2026-05-22 23:28:36.880998
194	194	20230115	0	1447	10.95	87.43	64.96	32617	OK	0	2026-05-22 23:28:36.880998
195	195	20230125	0	1754	3.11	80.34	55.06	23462	OK	0	2026-05-22 23:28:36.880998
196	196	20221010	0	1691	1.01	46.34	46.33	4744	OK	0	2026-05-22 23:28:36.880998
197	197	20220610	0	310	11.74	35.35	28.25	15210	OK	0	2026-05-22 23:28:36.880998
198	198	20220416	0	1281	8.11	11.92	77.49	19098	OK	0	2026-05-22 23:28:36.880998
199	199	20230530	0	849	10.55	15.78	81.00	18978	OK	0	2026-05-22 23:28:36.880998
200	200	20220603	0	1144	8.63	82.52	85.23	32871	OK	0	2026-05-22 23:28:36.880998
201	201	20231002	0	867	9.28	56.41	82.43	38292	OK	0	2026-05-22 23:28:36.880998
202	202	20240822	0	1968	13.76	32.36	22.10	22254	OK	0	2026-05-22 23:28:36.880998
203	203	20240513	0	584	3.01	85.48	24.16	13484	OK	0	2026-05-22 23:28:36.880998
204	204	20231107	0	1942	11.36	87.55	24.36	32445	OK	0	2026-05-22 23:28:36.880998
205	205	20220530	0	1699	14.22	86.87	69.22	2417	OK	0	2026-05-22 23:28:36.880998
206	206	20231210	0	194	14.25	60.84	62.87	5381	OK	0	2026-05-22 23:28:36.880998
207	207	20240907	0	1988	1.94	71.48	27.28	32644	OK	0	2026-05-22 23:28:36.880998
208	208	20241105	0	511	9.76	46.68	41.24	15026	OK	0	2026-05-22 23:28:36.880998
209	209	20220213	0	1957	0.83	75.76	76.80	35108	OK	0	2026-05-22 23:28:36.880998
210	210	20240216	0	1446	10.25	11.54	53.75	25470	OK	0	2026-05-22 23:28:36.880998
211	211	20240212	0	1474	1.88	69.61	58.47	7674	OK	0	2026-05-22 23:28:36.880998
212	212	20240615	0	291	13.46	93.52	45.74	12790	OK	0	2026-05-22 23:28:36.880998
213	213	20231204	0	944	13.77	30.24	26.44	758	OK	0	2026-05-22 23:28:36.880998
214	214	20230411	0	895	11.21	85.51	75.52	37327	OK	0	2026-05-22 23:28:36.880998
215	215	20220404	0	1692	0.22	71.19	76.88	5120	OK	0	2026-05-22 23:28:36.880998
216	216	20220427	0	309	6.58	34.02	41.99	39579	OK	0	2026-05-22 23:28:36.880998
217	217	20230516	0	648	1.95	43.81	66.03	43130	OK	0	2026-05-22 23:28:36.880998
218	218	20220607	0	206	3.75	56.21	54.65	48283	OK	0	2026-05-22 23:28:36.880998
219	219	20240102	0	1888	13.73	28.72	69.92	24147	OK	0	2026-05-22 23:28:36.880998
220	220	20230823	0	1829	9.80	54.78	38.73	45829	OK	0	2026-05-22 23:28:36.880998
221	221	20241028	0	263	0.81	86.54	69.39	40854	OK	0	2026-05-22 23:28:36.880998
222	222	20240922	0	622	1.18	87.52	78.90	34243	OK	0	2026-05-22 23:28:36.880998
223	223	20230418	0	674	11.13	27.92	46.07	9403	OK	0	2026-05-22 23:28:36.880998
224	224	20220315	0	531	10.48	65.24	51.76	7586	OK	0	2026-05-22 23:28:36.880998
225	225	20220213	0	1071	12.54	32.98	61.18	19787	OK	0	2026-05-22 23:28:36.880998
226	226	20220623	0	172	4.19	61.83	54.68	25173	OK	0	2026-05-22 23:28:36.880998
227	227	20240227	0	959	0.67	27.49	32.91	28351	OK	0	2026-05-22 23:28:36.880998
228	228	20241226	0	157	9.91	12.66	73.41	1803	OK	0	2026-05-22 23:28:36.880998
229	229	20231120	0	1939	12.42	32.32	72.73	14291	OK	0	2026-05-22 23:28:36.880998
230	230	20220226	0	748	10.89	62.83	80.60	47890	OK	0	2026-05-22 23:28:36.880998
231	231	20220427	0	1703	1.64	42.99	70.49	44531	OK	0	2026-05-22 23:28:36.880998
232	232	20230812	0	1808	14.86	55.45	49.67	47234	OK	0	2026-05-22 23:28:36.880998
233	233	20241128	0	582	2.44	42.41	72.19	15712	OK	0	2026-05-22 23:28:36.880998
234	234	20220928	0	1908	0.23	77.97	86.57	5705	OK	0	2026-05-22 23:28:36.880998
235	235	20230527	0	1629	8.14	38.69	47.62	40440	OK	0	2026-05-22 23:28:36.880998
236	236	20230716	0	790	4.03	31.29	65.71	39945	OK	0	2026-05-22 23:28:36.880998
237	237	20220126	0	304	4.60	66.17	78.52	11816	OK	0	2026-05-22 23:28:36.880998
238	238	20240627	0	997	0.26	10.75	22.59	23609	OK	0	2026-05-22 23:28:36.880998
239	239	20240910	0	1356	12.66	28.52	24.10	5313	OK	0	2026-05-22 23:28:36.880998
240	240	20230721	0	1887	9.15	36.69	24.48	11883	OK	0	2026-05-22 23:28:36.880998
241	241	20230613	0	1618	11.80	32.06	54.65	15004	OK	0	2026-05-22 23:28:36.880998
242	242	20221224	0	350	13.07	65.76	36.29	42999	OK	0	2026-05-22 23:28:36.880998
243	243	20220320	0	427	10.27	83.15	60.59	2849	OK	0	2026-05-22 23:28:36.880998
244	244	20230412	0	174	14.28	94.32	88.27	1156	OK	0	2026-05-22 23:28:36.880998
245	245	20231225	0	1156	10.77	61.05	44.48	5177	OK	0	2026-05-22 23:28:36.880998
246	246	20241104	0	958	1.70	16.58	34.28	37479	OK	0	2026-05-22 23:28:36.880998
247	247	20240131	0	1748	12.34	45.36	64.93	18652	OK	0	2026-05-22 23:28:36.880998
248	248	20221021	0	100	4.90	76.99	43.45	26847	OK	0	2026-05-22 23:28:36.880998
249	249	20240207	0	1013	14.14	35.00	22.18	24237	OK	0	2026-05-22 23:28:36.880998
250	250	20220402	0	645	13.95	87.51	21.79	40013	OK	0	2026-05-22 23:28:36.880998
251	251	20230310	0	1704	4.70	70.84	71.94	38208	OK	0	2026-05-22 23:28:36.880998
252	252	20231206	0	1974	3.22	80.61	22.28	47696	OK	0	2026-05-22 23:28:36.880998
253	253	20221104	0	830	11.44	65.18	86.86	14818	OK	0	2026-05-22 23:28:36.880998
254	254	20241028	0	1226	9.45	72.39	57.73	8045	OK	0	2026-05-22 23:28:36.880998
255	255	20241216	0	1684	0.77	50.15	56.71	29002	En panne	1	2026-05-22 23:28:36.880998
256	256	20231012	0	601	2.93	58.90	83.77	21640	OK	0	2026-05-22 23:28:36.880998
257	257	20230513	0	1686	11.51	40.77	51.91	49133	OK	0	2026-05-22 23:28:36.880998
258	258	20220825	0	1469	3.62	72.29	81.62	23816	OK	0	2026-05-22 23:28:36.880998
259	259	20220613	0	770	8.41	16.50	45.36	31829	OK	0	2026-05-22 23:28:36.880998
260	260	20230417	0	969	11.79	29.53	77.95	8310	OK	0	2026-05-22 23:28:36.880998
261	261	20230517	0	1640	13.64	67.30	66.61	39785	OK	0	2026-05-22 23:28:36.880998
262	262	20230618	0	1679	4.30	36.68	25.71	27692	OK	0	2026-05-22 23:28:36.880998
263	263	20241031	0	353	8.64	63.77	74.09	11890	OK	0	2026-05-22 23:28:36.880998
264	264	20240718	0	81	2.50	45.58	73.59	46721	OK	0	2026-05-22 23:28:36.880998
265	265	20240820	0	1571	1.51	83.90	78.37	1668	OK	0	2026-05-22 23:28:36.880998
266	266	20221208	0	199	1.99	83.68	84.30	27779	OK	0	2026-05-22 23:28:36.880998
267	267	20231227	0	311	6.03	57.34	69.84	7900	OK	0	2026-05-22 23:28:36.880998
268	268	20231121	0	1887	12.37	38.61	62.61	7162	OK	0	2026-05-22 23:28:36.880998
269	269	20220403	0	201	11.08	40.17	51.42	26896	OK	0	2026-05-22 23:28:36.880998
270	270	20240710	0	1566	12.52	34.59	53.40	8921	OK	0	2026-05-22 23:28:36.880998
271	271	20230111	0	1532	11.49	87.89	85.56	5591	OK	0	2026-05-22 23:28:36.880998
272	272	20221108	0	1884	0.12	60.41	67.17	29822	OK	0	2026-05-22 23:28:36.880998
273	273	20240216	0	706	6.58	53.24	61.17	6450	OK	0	2026-05-22 23:28:36.880998
274	274	20230421	0	658	7.40	14.10	56.24	34519	OK	0	2026-05-22 23:28:36.880998
275	275	20241106	0	1778	13.92	34.25	46.88	49730	OK	0	2026-05-22 23:28:36.880998
276	276	20230101	0	343	0.63	90.33	81.77	48005	OK	0	2026-05-22 23:28:36.880998
277	277	20230308	0	931	7.79	58.89	63.08	6618	OK	0	2026-05-22 23:28:36.880998
278	278	20231213	0	633	2.48	34.47	54.06	14756	OK	0	2026-05-22 23:28:36.880998
279	279	20221213	0	640	14.09	32.05	62.43	7054	OK	0	2026-05-22 23:28:36.880998
280	280	20230420	0	1414	4.18	18.16	58.65	33438	OK	0	2026-05-22 23:28:36.880998
281	281	20221212	0	106	8.98	13.38	82.35	35352	OK	0	2026-05-22 23:28:36.880998
282	282	20230204	0	63	7.33	79.90	45.87	18570	OK	0	2026-05-22 23:28:36.880998
283	283	20240523	0	1549	6.67	20.73	51.77	7283	OK	0	2026-05-22 23:28:36.880998
284	284	20220903	0	960	13.33	51.93	26.08	9066	OK	0	2026-05-22 23:28:36.880998
285	285	20230725	0	1548	10.03	92.32	76.25	48876	OK	0	2026-05-22 23:28:36.880998
286	286	20230401	0	1539	1.12	23.32	43.47	29818	OK	0	2026-05-22 23:28:36.880998
287	287	20241116	0	1426	11.66	70.08	42.04	2613	OK	0	2026-05-22 23:28:36.880998
288	288	20240606	0	255	13.99	77.51	42.23	36680	OK	0	2026-05-22 23:28:36.880998
289	289	20220314	0	1993	9.52	10.68	29.58	24755	En panne	1	2026-05-22 23:28:36.880998
290	290	20230327	0	1429	2.94	49.96	53.92	12362	OK	0	2026-05-22 23:28:36.880998
291	291	20241014	0	628	1.98	63.96	26.21	33936	OK	0	2026-05-22 23:28:36.880998
292	292	20230315	0	56	6.51	51.71	62.79	46629	OK	0	2026-05-22 23:28:36.880998
293	293	20221231	0	129	6.27	32.36	46.62	38366	OK	0	2026-05-22 23:28:36.880998
294	294	20230426	0	1356	5.23	55.09	86.80	19767	OK	0	2026-05-22 23:28:36.880998
295	295	20230420	0	1842	4.38	51.23	75.77	25803	OK	0	2026-05-22 23:28:36.880998
296	296	20240102	0	1162	7.21	18.21	27.87	49577	OK	0	2026-05-22 23:28:36.880998
297	297	20230812	0	909	14.54	37.66	66.37	7690	OK	0	2026-05-22 23:28:36.880998
298	298	20221227	0	1001	14.34	66.15	44.33	26189	OK	0	2026-05-22 23:28:36.880998
299	299	20220920	0	1634	13.23	81.41	80.48	39490	OK	0	2026-05-22 23:28:36.880998
300	300	20240423	0	1457	3.52	34.73	55.52	26904	OK	0	2026-05-22 23:28:36.880998
301	301	20220505	0	1201	11.58	32.24	42.23	25749	OK	0	2026-05-22 23:28:36.880998
302	302	20240624	0	920	5.98	87.55	38.78	47822	OK	0	2026-05-22 23:28:36.880998
303	303	20230325	0	745	9.54	13.88	51.33	14603	OK	0	2026-05-22 23:28:36.880998
304	304	20221208	0	1147	3.09	63.15	86.35	40293	OK	0	2026-05-22 23:28:36.880998
305	305	20231107	0	314	9.07	11.69	70.56	24950	OK	0	2026-05-22 23:28:36.880998
306	306	20220704	0	1648	10.57	87.54	73.68	36334	OK	0	2026-05-22 23:28:36.880998
307	307	20220510	0	1391	0.74	27.89	57.48	10388	OK	0	2026-05-22 23:28:36.880998
308	308	20240321	0	1810	10.77	34.67	31.30	24602	OK	0	2026-05-22 23:28:36.880998
309	309	20231110	0	896	3.23	72.33	85.80	2464	OK	0	2026-05-22 23:28:36.880998
310	310	20220211	0	1596	14.11	18.71	47.86	31878	OK	0	2026-05-22 23:28:36.880998
311	311	20220328	0	371	4.25	12.06	64.21	45193	OK	0	2026-05-22 23:28:36.880998
312	312	20230522	0	119	4.09	20.51	74.88	43044	OK	0	2026-05-22 23:28:36.880998
313	313	20240331	0	318	12.27	84.51	80.34	5115	OK	0	2026-05-22 23:28:36.880998
314	314	20220601	0	1083	10.83	74.80	49.08	1066	OK	0	2026-05-22 23:28:36.880998
315	315	20221107	0	245	11.04	77.37	33.60	39794	OK	0	2026-05-22 23:28:36.880998
316	316	20231002	0	1657	4.86	53.55	21.64	18060	OK	0	2026-05-22 23:28:36.880998
317	317	20240728	0	465	1.50	92.39	60.33	24779	OK	0	2026-05-22 23:28:36.880998
318	318	20230820	0	929	1.40	92.19	59.27	31776	OK	0	2026-05-22 23:28:36.880998
319	319	20230806	0	1908	10.54	53.06	46.77	32673	OK	0	2026-05-22 23:28:36.880998
320	320	20240317	0	1998	5.59	56.46	27.58	14784	OK	0	2026-05-22 23:28:36.880998
321	321	20220220	0	863	11.57	48.00	53.38	7240	OK	0	2026-05-22 23:28:36.880998
322	322	20230929	0	730	2.16	63.54	25.85	36858	OK	0	2026-05-22 23:28:36.880998
323	323	20221213	0	475	12.97	51.63	37.50	9362	OK	0	2026-05-22 23:28:36.880998
324	324	20240405	0	1312	12.57	54.49	78.78	49945	OK	0	2026-05-22 23:28:36.880998
325	325	20230422	0	170	11.51	31.42	41.80	22242	OK	0	2026-05-22 23:28:36.880998
326	326	20221105	0	124	4.82	58.05	48.46	465	OK	0	2026-05-22 23:28:36.880998
327	327	20230704	0	1463	3.14	57.80	54.21	32855	OK	0	2026-05-22 23:28:36.880998
328	328	20231004	0	1385	3.54	49.22	53.81	36459	OK	0	2026-05-22 23:28:36.880998
329	329	20220616	0	1936	1.58	69.44	46.30	49703	OK	0	2026-05-22 23:28:36.880998
330	330	20220128	0	381	7.80	20.33	33.82	7549	OK	0	2026-05-22 23:28:36.880998
331	331	20220321	0	1863	6.36	24.51	76.22	32028	OK	0	2026-05-22 23:28:36.880998
332	332	20221014	0	1583	13.11	45.54	20.65	7805	OK	0	2026-05-22 23:28:36.880998
333	333	20240610	0	652	10.80	84.82	38.98	21227	OK	0	2026-05-22 23:28:36.880998
334	334	20240201	0	1204	9.75	22.03	56.63	13499	OK	0	2026-05-22 23:28:36.880998
335	335	20240131	0	1113	9.07	50.13	34.74	21738	OK	0	2026-05-22 23:28:36.880998
336	336	20221005	0	386	7.87	80.50	20.69	27382	OK	0	2026-05-22 23:28:36.880998
337	337	20230103	0	357	7.06	94.43	20.39	46071	OK	0	2026-05-22 23:28:36.880998
338	338	20230120	0	458	10.41	55.71	43.17	4104	OK	0	2026-05-22 23:28:36.880998
339	339	20240817	0	1267	2.35	39.79	59.14	14913	OK	0	2026-05-22 23:28:36.880998
340	340	20231208	0	1337	0.21	26.37	39.89	28029	OK	0	2026-05-22 23:28:36.880998
341	341	20230919	0	802	9.37	44.28	37.83	35556	OK	0	2026-05-22 23:28:36.880998
342	342	20230219	0	208	8.89	18.75	35.15	11786	OK	0	2026-05-22 23:28:36.880998
343	343	20230623	0	1204	1.53	77.74	61.11	25196	OK	0	2026-05-22 23:28:36.880998
344	344	20231108	0	1228	11.58	60.33	39.41	48417	OK	0	2026-05-22 23:28:36.880998
345	345	20240827	0	478	2.52	76.59	89.24	6085	OK	0	2026-05-22 23:28:36.880998
346	346	20221028	0	343	2.47	84.34	42.63	3520	OK	0	2026-05-22 23:28:36.880998
347	347	20221008	0	1097	12.11	46.16	53.02	19928	OK	0	2026-05-22 23:28:36.880998
348	348	20241021	0	1606	1.76	57.61	46.41	25366	OK	0	2026-05-22 23:28:36.880998
349	349	20240829	0	777	4.68	54.37	57.15	39774	OK	0	2026-05-22 23:28:36.880998
350	350	20230315	0	390	14.18	80.86	69.79	28755	OK	0	2026-05-22 23:28:36.880998
351	351	20240623	0	1053	10.43	31.30	28.42	28635	OK	0	2026-05-22 23:28:36.880998
352	352	20231215	0	414	0.38	41.08	52.63	44011	OK	0	2026-05-22 23:28:36.880998
353	353	20231210	0	1541	6.36	62.44	81.34	12616	OK	0	2026-05-22 23:28:36.880998
354	354	20240223	0	816	2.69	73.55	20.75	29072	OK	0	2026-05-22 23:28:36.880998
355	355	20240110	0	1127	2.92	59.83	42.99	24274	OK	0	2026-05-22 23:28:36.880998
356	356	20230604	0	1079	13.82	61.58	22.35	18119	OK	0	2026-05-22 23:28:36.880998
357	357	20240907	0	865	0.66	69.12	37.71	41077	OK	0	2026-05-22 23:28:36.880998
358	358	20220428	0	1221	12.35	83.37	84.93	39916	OK	0	2026-05-22 23:28:36.880998
359	359	20240719	0	1054	2.61	73.74	65.33	35855	OK	0	2026-05-22 23:28:36.880998
360	360	20220801	0	128	5.54	62.10	69.93	46344	OK	0	2026-05-22 23:28:36.880998
361	361	20221229	0	1833	12.76	17.04	78.38	7926	OK	0	2026-05-22 23:28:36.880998
362	362	20220425	0	958	9.56	15.30	26.82	35757	OK	0	2026-05-22 23:28:36.880998
363	363	20230723	0	1796	2.91	62.19	21.17	44139	OK	0	2026-05-22 23:28:36.880998
364	364	20231011	0	1888	10.64	86.99	61.08	24102	OK	0	2026-05-22 23:28:36.880998
365	365	20241123	0	79	14.11	44.27	78.64	43985	OK	0	2026-05-22 23:28:36.880998
366	366	20220506	0	183	2.89	74.71	30.33	17574	OK	0	2026-05-22 23:28:36.880998
367	367	20220621	0	403	6.65	33.42	33.91	33226	OK	0	2026-05-22 23:28:36.880998
368	368	20240418	0	404	9.53	81.58	85.88	20492	OK	0	2026-05-22 23:28:36.880998
369	369	20230715	0	1198	5.26	39.02	59.77	45732	OK	0	2026-05-22 23:28:36.880998
370	370	20220626	0	1209	13.95	17.49	84.26	12060	OK	0	2026-05-22 23:28:36.880998
371	371	20220626	0	430	4.76	63.26	21.41	11197	OK	0	2026-05-22 23:28:36.880998
372	372	20220122	0	495	9.57	49.13	81.40	16269	OK	0	2026-05-22 23:28:36.880998
373	373	20230923	0	1764	10.21	90.13	80.52	49082	OK	0	2026-05-22 23:28:36.880998
374	374	20220929	0	685	0.80	70.00	32.46	9302	OK	0	2026-05-22 23:28:36.880998
375	375	20231009	0	897	3.39	26.00	81.85	11707	OK	0	2026-05-22 23:28:36.880998
376	376	20230828	0	581	10.46	32.49	54.29	38025	OK	0	2026-05-22 23:28:36.880998
377	377	20240115	0	764	11.59	54.46	78.07	45125	OK	0	2026-05-22 23:28:36.880998
378	378	20221216	0	125	14.24	59.74	30.90	37371	OK	0	2026-05-22 23:28:36.880998
379	379	20230308	0	1488	6.51	64.91	67.74	19019	OK	0	2026-05-22 23:28:36.880998
380	380	20230301	0	750	10.49	52.82	78.09	17725	OK	0	2026-05-22 23:28:36.880998
381	381	20220705	0	1101	11.60	31.95	52.74	2160	Dégradé	1	2026-05-22 23:28:36.880998
382	382	20220825	0	1108	9.87	25.85	29.79	38557	OK	0	2026-05-22 23:28:36.880998
383	383	20231024	0	812	8.46	65.96	83.09	21226	En panne	1	2026-05-22 23:28:36.880998
384	384	20220803	0	1339	5.38	86.59	31.11	31262	OK	0	2026-05-22 23:28:36.880998
385	385	20231117	0	739	9.72	18.52	83.92	20172	OK	0	2026-05-22 23:28:36.880998
386	386	20221130	0	1006	8.20	73.92	50.73	40510	OK	0	2026-05-22 23:28:36.880998
387	387	20240723	0	1265	8.64	46.97	47.95	16063	OK	0	2026-05-22 23:28:36.880998
388	388	20230602	0	1531	5.60	38.72	67.50	19772	OK	0	2026-05-22 23:28:36.880998
389	389	20220324	0	1952	13.16	74.87	83.06	33324	OK	0	2026-05-22 23:28:36.880998
390	390	20220809	0	912	6.39	32.90	60.42	38967	OK	0	2026-05-22 23:28:36.880998
391	391	20220228	0	385	7.68	88.40	82.06	45819	OK	0	2026-05-22 23:28:36.880998
392	392	20241209	0	456	14.27	58.28	29.77	43577	OK	0	2026-05-22 23:28:36.880998
393	393	20231114	0	1664	14.40	92.48	41.65	9370	OK	0	2026-05-22 23:28:36.880998
394	394	20231210	0	989	5.94	49.15	66.10	13233	OK	0	2026-05-22 23:28:36.880998
395	395	20221219	0	667	4.61	25.69	80.04	28709	OK	0	2026-05-22 23:28:36.880998
396	396	20220704	0	1533	3.67	68.20	79.20	24627	OK	0	2026-05-22 23:28:36.880998
397	397	20220111	0	1027	2.39	18.49	58.49	25924	OK	0	2026-05-22 23:28:36.880998
398	398	20230312	0	1919	7.08	41.98	52.44	16008	OK	0	2026-05-22 23:28:36.880998
399	399	20220716	0	843	1.93	74.86	29.35	21537	OK	0	2026-05-22 23:28:36.880998
400	400	20230803	0	1728	10.12	84.18	61.79	35103	OK	0	2026-05-22 23:28:36.880998
\.


--
-- Data for Name: fact_sessions; Type: TABLE DATA; Schema: technova_dw; Owner: -
--

COPY technova_dw.fact_sessions (session_sk, session_id, user_sk, date_sk, device, os, navigateur, duree_secondes, duree_minutes, pages_visitees, bounce, est_longue_session, nb_achats, nb_upgrades, revenu_session_tnd, nb_evenements_total, top_page_url, top_page_categorie, etl_loaded_at) FROM stdin;
1	1	76	20220706	Tablet	Android	Chrome	2922	48.7	8	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
2	2	134	20221223	Mobile	iOS	Firefox	137	2.3	13	0	0	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
3	3	49	20240804	Desktop	Windows	Safari	427	7.1	5	0	1	0	0	0.00	4	/profil	Profil	2026-05-22 23:28:36.880998
4	4	67	20230210	Desktop	Windows	Chrome	3383	56.4	13	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
5	5	39	20220214	Tablet	Android	Safari	274	4.6	7	0	0	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
6	6	170	20220908	Desktop	iOS	Chrome	184	3.1	15	0	0	0	1	40.90	1	\N	\N	2026-05-22 23:28:36.880998
7	7	255	20220302	Desktop	MacOS	Edge	1577	26.3	14	0	1	0	0	0.00	2	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
8	8	144	20240702	Mobile	iOS	Chrome	618	10.3	2	0	1	0	0	0.00	3	\N	\N	2026-05-22 23:28:36.880998
9	9	256	20240423	Desktop	Linux	Chrome	2265	37.8	16	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
10	10	103	20241212	Mobile	Android	Safari	1030	17.2	18	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
11	11	246	20240919	Desktop	Android	Chrome	1419	23.7	19	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
12	12	164	20230325	Desktop	Android	Chrome	130	2.2	9	0	0	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
13	13	82	20220725	Desktop	Windows	Safari	1025	17.1	8	0	1	0	2	428.73	2	\N	\N	2026-05-22 23:28:36.880998
14	14	295	20240306	Desktop	iOS	Chrome	1463	24.4	6	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
15	15	15	20231222	Desktop	MacOS	Safari	2335	38.9	19	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
16	16	278	20230925	Desktop	Windows	Chrome	729	12.2	16	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
17	17	11	20241214	Desktop	iOS	Chrome	1967	32.8	1	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
18	18	175	20221230	Desktop	MacOS	Chrome	3296	54.9	11	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
19	19	57	20241213	Tablet	Linux	Firefox	3535	58.9	12	0	1	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
20	20	52	20231121	Desktop	MacOS	Firefox	1246	20.8	11	0	1	1	0	137.48	1	\N	\N	2026-05-22 23:28:36.880998
21	21	250	20231012	Mobile	iOS	Safari	723	12.1	18	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
22	22	90	20240214	Desktop	Windows	Edge	1266	21.1	10	0	1	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
23	23	291	20220308	Desktop	iOS	Chrome	755	12.6	20	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
24	24	255	20221016	Desktop	Linux	Chrome	1366	22.8	3	0	1	0	0	0.00	1	/support	Support	2026-05-22 23:28:36.880998
25	25	172	20240703	Desktop	Windows	Chrome	56	0.9	9	0	0	0	0	0.00	2	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
26	26	1	20220409	Mobile	MacOS	Edge	1590	26.5	15	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
27	27	194	20231221	Desktop	Android	Safari	2246	37.4	13	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
28	28	84	20240713	Desktop	Linux	Chrome	311	5.2	2	0	1	0	0	0.00	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
29	29	38	20231202	Desktop	Windows	Chrome	706	11.8	13	0	1	1	0	24.33	2	\N	\N	2026-05-22 23:28:36.880998
30	30	174	20240915	Desktop	MacOS	Firefox	2895	48.3	1	0	1	0	0	0.00	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
31	31	81	20220420	Desktop	MacOS	Chrome	424	7.1	11	0	1	0	1	87.07	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
32	32	145	20230902	Desktop	iOS	Chrome	982	16.4	4	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
33	33	79	20220422	Desktop	Linux	Safari	1487	24.8	1	0	1	0	1	479.85	2	/blog	Blog	2026-05-22 23:28:36.880998
34	34	103	20220718	Desktop	Linux	Opera	115	1.9	7	0	0	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
35	35	60	20230924	Desktop	Linux	Chrome	3224	53.7	13	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
36	36	95	20240130	Desktop	Windows	Chrome	1572	26.2	12	0	1	0	0	0.00	1	/support	Support	2026-05-22 23:28:36.880998
37	37	135	20230409	Mobile	MacOS	Safari	3438	57.3	9	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
38	38	44	20231206	Desktop	iOS	Chrome	3320	55.3	18	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
39	39	199	20241206	Mobile	Android	Chrome	1724	28.7	18	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
40	40	244	20230905	Tablet	Windows	Chrome	333	5.6	13	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
41	41	62	20240708	Tablet	MacOS	Chrome	718	12.0	6	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
42	42	41	20240610	Mobile	Linux	Chrome	837	14.0	5	0	1	1	0	185.73	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
43	43	45	20240305	Mobile	Linux	Chrome	2288	38.1	13	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
44	44	268	20240509	Desktop	iOS	Chrome	470	7.8	14	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
45	45	55	20220726	Mobile	Linux	Edge	3228	53.8	10	0	1	1	1	575.11	2	/blog	Blog	2026-05-22 23:28:36.880998
46	46	197	20240921	Desktop	MacOS	Chrome	2353	39.2	20	0	1	0	0	0.00	2	/contact	Contact	2026-05-22 23:28:36.880998
47	47	206	20220321	Mobile	Windows	Firefox	1631	27.2	11	0	1	0	0	0.00	1	/dashboard	Dashboard	2026-05-22 23:28:36.880998
48	48	191	20220211	Desktop	Android	Edge	1393	23.2	10	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
49	49	117	20221003	Mobile	Linux	Chrome	1240	20.7	15	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
50	50	46	20230120	Tablet	Android	Firefox	1819	30.3	7	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
51	51	29	20241121	Desktop	iOS	Chrome	3251	54.2	6	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
52	52	89	20230130	Mobile	MacOS	Chrome	3594	59.9	7	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
53	53	185	20230212	Mobile	iOS	Chrome	1132	18.9	12	0	1	0	1	58.09	1	\N	\N	2026-05-22 23:28:36.880998
54	54	16	20230511	Mobile	MacOS	Opera	1535	25.6	16	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
55	55	283	20231218	Mobile	Linux	Firefox	1420	23.7	6	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
56	56	146	20220226	Desktop	iOS	Safari	1593	26.6	2	0	1	0	0	0.00	1	/support	Support	2026-05-22 23:28:36.880998
57	57	114	20230407	Desktop	Android	Chrome	2785	46.4	7	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
58	58	243	20220928	Mobile	Windows	Chrome	2661	44.4	6	0	1	0	0	0.00	2	/dashboard	Dashboard	2026-05-22 23:28:36.880998
59	59	141	20240517	Desktop	MacOS	Chrome	1552	25.9	12	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
60	60	300	20220729	Tablet	Linux	Chrome	40	0.7	17	0	0	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
243	243	165	20220510	Mobile	MacOS	Chrome	2706	45.1	18	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
61	61	153	20220810	Desktop	Linux	Firefox	1983	33.1	3	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
62	62	134	20230904	Desktop	MacOS	Edge	781	13.0	5	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
63	63	164	20221014	Mobile	Linux	Chrome	2964	49.4	1	0	1	0	0	0.00	1	/support	Support	2026-05-22 23:28:36.880998
64	64	208	20240306	Mobile	iOS	Safari	3027	50.5	2	0	1	0	1	489.92	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
65	65	114	20241230	Tablet	Linux	Chrome	2624	43.7	16	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
66	66	286	20230106	Desktop	Linux	Firefox	1213	20.2	4	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
67	67	172	20220702	Desktop	Linux	Chrome	920	15.3	12	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
68	68	191	20230618	Desktop	Windows	Chrome	2408	40.1	10	0	1	0	0	0.00	2	/support	Support	2026-05-22 23:28:36.880998
69	69	242	20230203	Mobile	Android	Chrome	2059	34.3	4	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
70	70	28	20221105	Desktop	iOS	Edge	572	9.5	7	0	1	0	1	70.13	3	\N	\N	2026-05-22 23:28:36.880998
71	71	74	20231010	Mobile	Android	Chrome	3542	59.0	6	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
72	72	161	20220429	Desktop	MacOS	Chrome	29	0.5	15	1	0	0	0	0.00	2	/produits/erp	Produit	2026-05-22 23:28:36.880998
73	73	251	20220630	Desktop	Android	Chrome	540	9.0	20	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
74	74	197	20220110	Desktop	Linux	Opera	164	2.7	18	0	0	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
75	75	272	20230126	Mobile	MacOS	Chrome	83	1.4	1	0	0	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
76	76	160	20220922	Desktop	Linux	Chrome	430	7.2	13	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
77	77	153	20230819	Mobile	Linux	Chrome	1877	31.3	17	0	1	0	0	0.00	1	/support	Support	2026-05-22 23:28:36.880998
78	78	176	20240930	Desktop	Android	Chrome	1481	24.7	7	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
79	79	68	20230309	Mobile	MacOS	Chrome	3016	50.3	1	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
80	80	193	20230608	Mobile	iOS	Opera	3169	52.8	18	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
81	81	11	20220409	Desktop	Android	Chrome	2835	47.3	4	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
82	82	243	20221110	Desktop	Windows	Firefox	851	14.2	1	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
83	83	71	20240507	Desktop	iOS	Chrome	3412	56.9	4	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
84	84	55	20241016	Desktop	Linux	Safari	823	13.7	20	0	1	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
85	85	184	20240419	Desktop	Android	Edge	1219	20.3	6	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
86	86	170	20230426	Mobile	Windows	Safari	21	0.4	1	1	0	1	0	128.65	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
87	87	77	20220704	Desktop	Windows	Edge	3202	53.4	17	0	1	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
88	88	234	20230830	Desktop	MacOS	Edge	1091	18.2	15	0	1	1	0	379.84	2	/produits/crm	Produit	2026-05-22 23:28:36.880998
89	89	185	20231003	Desktop	Windows	Chrome	1754	29.2	4	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
90	90	88	20231105	Tablet	Linux	Edge	1474	24.6	15	0	1	0	0	0.00	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
91	91	191	20231203	Desktop	Android	Chrome	759	12.7	4	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
92	92	245	20240513	Desktop	Windows	Opera	2667	44.5	6	0	1	0	0	0.00	2	/profil	Profil	2026-05-22 23:28:36.880998
93	93	54	20240502	Mobile	Android	Chrome	2429	40.5	16	0	1	0	0	0.00	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
94	94	184	20220301	Desktop	Android	Chrome	3543	59.1	5	0	1	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
95	95	226	20220405	Mobile	Windows	Firefox	269	4.5	9	0	0	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
96	96	174	20241129	Desktop	MacOS	Chrome	2152	35.9	20	0	1	0	0	0.00	2	/tarifs	Tarifs	2026-05-22 23:28:36.880998
97	97	77	20220422	Desktop	Android	Edge	57	1.0	6	0	0	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
98	98	39	20241003	Desktop	Linux	Chrome	1323	22.1	8	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
99	99	282	20240215	Desktop	Android	Safari	1661	27.7	8	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
100	100	46	20241017	Desktop	Android	Firefox	1841	30.7	11	0	1	0	0	0.00	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
101	101	53	20240406	Mobile	Windows	Safari	1698	28.3	2	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
102	102	261	20230228	Tablet	Linux	Safari	2691	44.9	15	0	1	1	0	446.51	1	/contact	Contact	2026-05-22 23:28:36.880998
103	103	233	20231111	Mobile	Linux	Firefox	2304	38.4	20	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
104	104	50	20230331	Desktop	Linux	Chrome	18	0.3	11	1	0	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
105	105	55	20220404	Desktop	Android	Chrome	682	11.4	16	0	1	1	0	479.52	1	\N	\N	2026-05-22 23:28:36.880998
106	106	97	20220905	Desktop	MacOS	Firefox	3500	58.3	13	0	1	1	0	496.28	2	/produits/crm	Produit	2026-05-22 23:28:36.880998
107	107	213	20220406	Desktop	Android	Chrome	2603	43.4	19	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
108	108	256	20220109	Mobile	Android	Safari	2182	36.4	2	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
109	109	261	20221229	Desktop	MacOS	Chrome	2843	47.4	19	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
110	110	259	20240227	Tablet	MacOS	Chrome	1724	28.7	20	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
111	111	151	20240716	Desktop	iOS	Firefox	3306	55.1	5	0	1	0	1	416.26	2	/tarifs	Tarifs	2026-05-22 23:28:36.880998
112	112	281	20231005	Mobile	MacOS	Chrome	2925	48.8	18	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
113	113	177	20220929	Desktop	Linux	Firefox	2919	48.7	6	0	1	0	0	0.00	3	\N	\N	2026-05-22 23:28:36.880998
114	114	288	20240910	Tablet	Android	Firefox	2397	40.0	19	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
115	115	217	20220127	Desktop	MacOS	Chrome	2151	35.9	4	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
116	116	103	20230701	Tablet	Linux	Chrome	3082	51.4	6	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
117	117	152	20230222	Desktop	Android	Chrome	3096	51.6	18	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
118	118	288	20240307	Mobile	Linux	Firefox	983	16.4	17	0	1	1	1	171.23	2	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
119	119	196	20240304	Tablet	Windows	Chrome	1716	28.6	11	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
120	120	104	20240626	Tablet	Linux	Safari	3409	56.8	8	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
121	121	100	20230826	Tablet	Windows	Chrome	1848	30.8	6	0	1	1	0	277.36	1	/support	Support	2026-05-22 23:28:36.880998
122	122	264	20220902	Desktop	iOS	Chrome	1555	25.9	2	0	1	1	0	95.84	2	/support	Support	2026-05-22 23:28:36.880998
123	123	300	20230607	Desktop	MacOS	Chrome	33	0.6	11	0	0	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
124	124	27	20230909	Mobile	Windows	Safari	2019	33.7	19	0	1	0	1	178.29	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
125	125	270	20230327	Desktop	iOS	Chrome	763	12.7	17	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
126	126	48	20231217	Mobile	Linux	Chrome	916	15.3	7	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
127	127	272	20240830	Desktop	Linux	Chrome	2309	38.5	1	0	1	0	0	0.00	2	/tarifs	Tarifs	2026-05-22 23:28:36.880998
128	128	21	20231020	Desktop	iOS	Firefox	1572	26.2	4	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
129	129	265	20240207	Desktop	Windows	Chrome	2116	35.3	17	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
130	130	165	20241118	Desktop	iOS	Chrome	347	5.8	4	0	1	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
131	131	108	20230313	Mobile	MacOS	Chrome	3552	59.2	14	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
132	132	37	20221111	Mobile	Windows	Chrome	107	1.8	15	0	0	1	0	466.78	1	\N	\N	2026-05-22 23:28:36.880998
133	133	92	20230531	Mobile	MacOS	Edge	2295	38.3	3	0	1	0	0	0.00	2	/support	Support	2026-05-22 23:28:36.880998
134	134	199	20240712	Desktop	Windows	Chrome	2591	43.2	13	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
135	135	274	20220113	Desktop	iOS	Chrome	2637	44.0	20	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
136	136	184	20241026	Mobile	Linux	Firefox	444	7.4	10	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
137	137	225	20240221	Desktop	iOS	Chrome	1628	27.1	1	0	1	0	0	0.00	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
138	138	280	20230828	Desktop	Linux	Opera	2607	43.5	5	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
139	139	284	20221017	Desktop	iOS	Chrome	514	8.6	2	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
140	140	157	20230307	Desktop	iOS	Chrome	3075	51.3	12	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
141	141	114	20230602	Desktop	iOS	Edge	805	13.4	4	0	1	0	0	0.00	2	/dashboard	Dashboard	2026-05-22 23:28:36.880998
142	142	282	20220530	Desktop	MacOS	Firefox	1200	20.0	3	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
143	143	170	20240102	Desktop	iOS	Chrome	535	8.9	8	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
144	144	163	20240922	Mobile	Linux	Firefox	1855	30.9	11	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
145	145	290	20240117	Tablet	MacOS	Chrome	3318	55.3	11	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
146	146	114	20240612	Desktop	Linux	Edge	1143	19.1	12	0	1	0	1	301.07	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
147	147	229	20240105	Desktop	Windows	Chrome	3183	53.1	10	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
148	148	144	20221014	Desktop	Windows	Firefox	2216	36.9	7	0	1	1	0	355.58	1	/blog	Blog	2026-05-22 23:28:36.880998
149	149	260	20220305	Mobile	iOS	Chrome	3338	55.6	19	0	1	0	1	409.59	2	/produits	Produit	2026-05-22 23:28:36.880998
150	150	283	20230618	Desktop	MacOS	Chrome	2236	37.3	18	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
151	151	149	20221002	Desktop	Android	Chrome	1913	31.9	17	0	1	1	1	305.61	4	/profil	Profil	2026-05-22 23:28:36.880998
152	152	123	20221206	Desktop	MacOS	Chrome	3111	51.9	17	0	1	1	0	436.69	3	\N	\N	2026-05-22 23:28:36.880998
153	153	248	20240105	Mobile	MacOS	Chrome	175	2.9	8	0	0	0	0	0.00	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
154	154	120	20220329	Desktop	Linux	Chrome	2748	45.8	7	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
155	155	24	20220323	Desktop	iOS	Firefox	2666	44.4	11	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
156	156	135	20221223	Desktop	Windows	Chrome	1552	25.9	13	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
157	157	115	20241123	Mobile	Linux	Chrome	1672	27.9	12	0	1	1	0	140.57	1	\N	\N	2026-05-22 23:28:36.880998
158	158	4	20241024	Desktop	Windows	Chrome	579	9.7	15	0	1	0	0	0.00	2	/dashboard	Dashboard	2026-05-22 23:28:36.880998
159	159	109	20221104	Desktop	Windows	Firefox	775	12.9	6	0	1	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
160	160	170	20220821	Desktop	iOS	Chrome	1982	33.0	16	0	1	1	0	283.78	2	/	Accueil	2026-05-22 23:28:36.880998
161	161	12	20230515	Mobile	MacOS	Chrome	186	3.1	5	0	0	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
162	162	294	20221028	Desktop	MacOS	Chrome	239	4.0	6	0	0	1	0	70.64	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
163	163	289	20220208	Tablet	MacOS	Chrome	2957	49.3	10	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
164	164	247	20221216	Mobile	iOS	Safari	908	15.1	14	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
165	165	262	20230626	Tablet	iOS	Chrome	696	11.6	11	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
166	166	194	20240229	Desktop	iOS	Edge	551	9.2	4	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
167	167	77	20220717	Tablet	iOS	Chrome	736	12.3	16	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
168	168	48	20240914	Tablet	iOS	Safari	2710	45.2	5	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
169	169	268	20240511	Mobile	Android	Chrome	1527	25.5	2	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
170	170	196	20231219	Desktop	MacOS	Chrome	2422	40.4	19	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
171	171	43	20230804	Desktop	MacOS	Chrome	2460	41.0	18	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
172	172	296	20241206	Desktop	MacOS	Firefox	492	8.2	17	0	1	0	0	0.00	2	/tarifs	Tarifs	2026-05-22 23:28:36.880998
173	173	210	20240112	Desktop	iOS	Chrome	446	7.4	5	0	1	0	1	37.56	2	/profil	Profil	2026-05-22 23:28:36.880998
174	174	290	20240119	Tablet	Android	Safari	2516	41.9	9	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
175	175	283	20240915	Mobile	Android	Chrome	742	12.4	12	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
176	176	296	20231207	Mobile	Windows	Firefox	3181	53.0	13	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
177	177	83	20220725	Desktop	Linux	Safari	888	14.8	17	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
178	178	83	20240307	Mobile	MacOS	Chrome	2614	43.6	1	0	1	1	0	198.20	3	\N	\N	2026-05-22 23:28:36.880998
179	179	46	20220512	Desktop	iOS	Chrome	1087	18.1	8	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
180	180	206	20241203	Desktop	MacOS	Firefox	1183	19.7	20	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
181	181	6	20230218	Desktop	Windows	Safari	3493	58.2	17	0	1	1	0	99.01	2	\N	\N	2026-05-22 23:28:36.880998
182	182	87	20220315	Mobile	MacOS	Chrome	1483	24.7	8	0	1	0	0	0.00	1	/dashboard	Dashboard	2026-05-22 23:28:36.880998
183	183	205	20231225	Desktop	MacOS	Chrome	2752	45.9	13	0	1	0	0	0.00	3	\N	\N	2026-05-22 23:28:36.880998
184	184	47	20230806	Tablet	Linux	Chrome	2984	49.7	18	0	1	0	1	322.68	3	/blog	Blog	2026-05-22 23:28:36.880998
185	185	116	20230203	Mobile	Linux	Chrome	1872	31.2	13	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
186	186	287	20220529	Desktop	Windows	Safari	2070	34.5	10	0	1	1	0	94.43	1	\N	\N	2026-05-22 23:28:36.880998
187	187	276	20230528	Tablet	iOS	Chrome	2853	47.6	15	0	1	0	0	0.00	2	/	Accueil	2026-05-22 23:28:36.880998
188	188	174	20240728	Mobile	Windows	Chrome	2801	46.7	15	0	1	0	0	0.00	2	/produits	Produit	2026-05-22 23:28:36.880998
189	189	35	20240223	Mobile	MacOS	Safari	2605	43.4	8	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
190	190	181	20241123	Mobile	Linux	Chrome	2204	36.7	1	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
191	191	205	20231202	Tablet	Android	Chrome	321	5.4	18	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
192	192	294	20230706	Desktop	MacOS	Chrome	758	12.6	7	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
193	193	136	20230228	Mobile	iOS	Chrome	948	15.8	7	0	1	1	0	213.20	2	/produits/erp	Produit	2026-05-22 23:28:36.880998
194	194	62	20220610	Mobile	iOS	Opera	2778	46.3	16	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
195	195	191	20231008	Mobile	Android	Chrome	2026	33.8	19	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
196	196	204	20230331	Desktop	iOS	Safari	3082	51.4	19	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
197	197	277	20220308	Desktop	MacOS	Chrome	2068	34.5	12	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
198	198	266	20240731	Desktop	MacOS	Chrome	1302	21.7	1	0	1	1	0	410.78	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
199	199	167	20240111	Desktop	Linux	Chrome	2519	42.0	9	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
200	200	176	20240120	Desktop	Android	Firefox	763	12.7	16	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
201	201	187	20240331	Desktop	MacOS	Opera	1155	19.3	15	0	1	0	1	170.78	2	/blog	Blog	2026-05-22 23:28:36.880998
202	202	52	20230707	Mobile	Android	Chrome	3303	55.1	8	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
203	203	243	20220120	Desktop	iOS	Chrome	733	12.2	14	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
204	204	250	20230907	Mobile	Windows	Chrome	1037	17.3	18	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
205	205	31	20230318	Desktop	Windows	Chrome	3343	55.7	9	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
206	206	134	20240110	Mobile	Linux	Chrome	1485	24.8	18	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
207	207	63	20231221	Desktop	iOS	Firefox	3562	59.4	20	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
208	208	146	20231229	Desktop	Android	Edge	1341	22.4	17	0	1	0	1	254.31	1	/produits	Produit	2026-05-22 23:28:36.880998
209	209	147	20240807	Mobile	Linux	Chrome	2597	43.3	5	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
210	210	37	20220612	Desktop	Linux	Firefox	673	11.2	11	0	1	0	0	0.00	2	/tarifs	Tarifs	2026-05-22 23:28:36.880998
211	211	203	20230710	Mobile	iOS	Opera	1832	30.5	12	0	1	0	0	0.00	3	\N	\N	2026-05-22 23:28:36.880998
212	212	86	20230112	Desktop	MacOS	Firefox	3508	58.5	1	0	1	0	1	216.10	1	\N	\N	2026-05-22 23:28:36.880998
213	213	108	20221208	Desktop	Android	Chrome	1636	27.3	4	0	1	0	1	431.58	2	/	Accueil	2026-05-22 23:28:36.880998
214	214	204	20241209	Desktop	iOS	Chrome	3143	52.4	3	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
215	215	159	20230415	Desktop	MacOS	Chrome	1023	17.1	10	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
216	216	15	20220313	Mobile	Linux	Edge	2727	45.5	12	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
217	217	277	20230712	Desktop	iOS	Chrome	2256	37.6	15	0	1	0	0	0.00	2	/tarifs	Tarifs	2026-05-22 23:28:36.880998
218	218	289	20240609	Desktop	Linux	Chrome	2154	35.9	18	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
219	219	46	20240623	Desktop	MacOS	Chrome	1271	21.2	12	0	1	0	0	0.00	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
220	220	268	20221007	Desktop	Windows	Firefox	1418	23.6	10	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
221	221	245	20230906	Mobile	iOS	Chrome	47	0.8	14	0	0	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
222	222	281	20240205	Mobile	Android	Chrome	782	13.0	14	0	1	0	0	0.00	2	/blog/article-2	Blog	2026-05-22 23:28:36.880998
223	223	200	20240214	Desktop	MacOS	Chrome	913	15.2	9	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
224	224	146	20241225	Desktop	Windows	Chrome	3322	55.4	9	0	1	0	0	0.00	2	/support	Support	2026-05-22 23:28:36.880998
225	225	57	20240721	Desktop	iOS	Chrome	2540	42.3	15	0	1	0	1	233.27	1	\N	\N	2026-05-22 23:28:36.880998
226	226	10	20221108	Desktop	Windows	Chrome	213	3.6	18	0	0	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
227	227	225	20220117	Desktop	Android	Chrome	963	16.1	3	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
228	228	160	20241017	Mobile	Windows	Chrome	1531	25.5	15	0	1	0	0	0.00	2	/blog	Blog	2026-05-22 23:28:36.880998
229	229	29	20230630	Desktop	Android	Chrome	3187	53.1	13	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
230	230	196	20220126	Desktop	Android	Chrome	509	8.5	8	0	1	0	1	19.55	1	\N	\N	2026-05-22 23:28:36.880998
231	231	102	20240801	Desktop	MacOS	Chrome	3021	50.4	4	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
232	232	166	20221121	Mobile	iOS	Chrome	2587	43.1	2	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
233	233	247	20230904	Mobile	MacOS	Opera	823	13.7	12	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
234	234	223	20231027	Mobile	iOS	Chrome	71	1.2	6	0	0	0	0	0.00	2	/profil	Profil	2026-05-22 23:28:36.880998
235	235	5	20220328	Mobile	MacOS	Chrome	2390	39.8	16	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
236	236	128	20221119	Mobile	Linux	Edge	2057	34.3	3	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
237	237	31	20231230	Mobile	Windows	Chrome	2650	44.2	5	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
238	238	163	20231213	Mobile	Windows	Firefox	3309	55.2	15	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
239	239	69	20230529	Mobile	iOS	Chrome	171	2.9	16	0	0	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
240	240	98	20230118	Desktop	Android	Chrome	2236	37.3	12	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
241	241	36	20241223	Desktop	Linux	Chrome	644	10.7	15	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
242	242	1	20241102	Mobile	iOS	Edge	1562	26.0	6	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
244	244	283	20221112	Desktop	Linux	Chrome	2521	42.0	10	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
245	245	23	20220923	Desktop	Android	Chrome	741	12.4	2	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
246	246	293	20240306	Desktop	iOS	Chrome	2704	45.1	16	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
247	247	114	20220526	Mobile	Windows	Chrome	63	1.1	7	0	0	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
248	248	185	20240501	Mobile	Windows	Safari	3377	56.3	12	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
249	249	271	20220325	Mobile	Windows	Edge	3017	50.3	3	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
250	250	52	20230419	Desktop	iOS	Firefox	2187	36.5	13	0	1	1	0	52.73	1	\N	\N	2026-05-22 23:28:36.880998
251	251	286	20240430	Mobile	iOS	Chrome	3066	51.1	4	0	1	0	1	394.79	2	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
252	252	219	20220802	Desktop	iOS	Chrome	693	11.6	6	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
253	253	274	20240626	Mobile	Linux	Safari	1453	24.2	11	0	1	1	0	284.12	1	/contact	Contact	2026-05-22 23:28:36.880998
254	254	221	20231025	Mobile	MacOS	Chrome	2502	41.7	8	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
255	255	185	20240715	Desktop	Windows	Opera	1842	30.7	13	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
256	256	266	20221004	Desktop	MacOS	Chrome	1246	20.8	1	0	1	1	0	155.40	1	\N	\N	2026-05-22 23:28:36.880998
257	257	12	20230720	Mobile	iOS	Chrome	2277	38.0	17	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
258	258	236	20231230	Desktop	iOS	Chrome	649	10.8	5	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
259	259	154	20220708	Mobile	MacOS	Firefox	2346	39.1	13	0	1	0	0	0.00	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
260	260	248	20221221	Mobile	Windows	Chrome	2009	33.5	19	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
261	261	20	20240221	Tablet	Linux	Chrome	331	5.5	2	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
262	262	214	20220904	Mobile	iOS	Edge	3572	59.5	8	0	1	1	0	476.08	1	\N	\N	2026-05-22 23:28:36.880998
263	263	28	20230917	Desktop	iOS	Chrome	2157	36.0	2	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
264	264	79	20220414	Tablet	iOS	Chrome	2769	46.2	13	0	1	0	1	110.32	1	/contact	Contact	2026-05-22 23:28:36.880998
265	265	114	20240603	Desktop	Linux	Chrome	1196	19.9	13	0	1	0	0	0.00	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
266	266	281	20240328	Desktop	Android	Safari	1085	18.1	3	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
267	267	70	20240911	Desktop	iOS	Chrome	2300	38.3	7	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
268	268	125	20220527	Desktop	iOS	Chrome	1100	18.3	14	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
269	269	217	20240119	Desktop	iOS	Firefox	1436	23.9	7	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
270	270	87	20231218	Mobile	Android	Chrome	2534	42.2	15	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
271	271	103	20240205	Desktop	Windows	Chrome	648	10.8	3	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
272	272	148	20220129	Desktop	Android	Chrome	1416	23.6	4	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
273	273	276	20230310	Desktop	Linux	Chrome	844	14.1	18	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
274	274	10	20240211	Desktop	MacOS	Chrome	2397	40.0	17	0	1	0	0	0.00	2	/profil	Profil	2026-05-22 23:28:36.880998
275	275	139	20220419	Desktop	Linux	Firefox	1914	31.9	1	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
276	276	56	20220209	Desktop	Android	Chrome	1208	20.1	13	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
277	277	162	20240919	Desktop	MacOS	Chrome	3560	59.3	20	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
278	278	288	20220214	Tablet	Linux	Chrome	172	2.9	8	0	0	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
279	279	81	20220207	Desktop	Linux	Chrome	1430	23.8	12	0	1	1	0	80.00	2	/	Accueil	2026-05-22 23:28:36.880998
280	280	32	20230612	Tablet	Linux	Chrome	1595	26.6	1	0	1	0	1	4.93	3	\N	\N	2026-05-22 23:28:36.880998
281	281	202	20221009	Desktop	iOS	Edge	369	6.2	13	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
282	282	214	20230508	Desktop	Linux	Edge	2356	39.3	5	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
283	283	230	20220927	Mobile	MacOS	Edge	856	14.3	5	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
284	284	269	20221004	Mobile	iOS	Edge	1771	29.5	5	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
285	285	35	20241227	Desktop	MacOS	Firefox	2956	49.3	4	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
286	286	212	20240422	Mobile	Linux	Chrome	1252	20.9	15	0	1	1	0	303.49	2	/dashboard	Dashboard	2026-05-22 23:28:36.880998
287	287	55	20220927	Mobile	iOS	Firefox	766	12.8	1	0	1	0	0	0.00	2	/produits/erp	Produit	2026-05-22 23:28:36.880998
288	288	119	20230418	Desktop	Android	Chrome	2825	47.1	1	0	1	0	1	98.04	3	/blog/article-1	Blog	2026-05-22 23:28:36.880998
289	289	192	20230112	Desktop	MacOS	Chrome	3500	58.3	13	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
290	290	17	20240416	Tablet	Android	Chrome	3141	52.4	1	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
291	291	105	20220516	Mobile	Android	Firefox	735	12.3	15	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
292	292	127	20240525	Mobile	Android	Firefox	1668	27.8	2	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
293	293	293	20241211	Desktop	Android	Chrome	2637	44.0	2	0	1	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
294	294	126	20241128	Tablet	Windows	Chrome	2213	36.9	13	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
295	295	98	20230820	Mobile	Linux	Chrome	1810	30.2	13	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
296	296	151	20220422	Tablet	Android	Safari	2836	47.3	17	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
297	297	47	20241022	Mobile	iOS	Chrome	473	7.9	6	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
298	298	166	20240712	Desktop	MacOS	Edge	112	1.9	6	0	0	0	1	21.95	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
299	299	129	20231026	Mobile	Windows	Chrome	2843	47.4	6	0	1	0	1	402.18	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
300	300	186	20220624	Mobile	iOS	Firefox	2155	35.9	13	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
301	301	194	20240219	Tablet	iOS	Edge	189	3.2	6	0	0	1	0	438.12	1	\N	\N	2026-05-22 23:28:36.880998
302	302	84	20221024	Desktop	Linux	Firefox	742	12.4	2	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
303	303	148	20230106	Tablet	Windows	Firefox	491	8.2	5	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
304	304	7	20240728	Desktop	Windows	Firefox	2048	34.1	16	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
305	305	122	20230321	Desktop	Android	Chrome	2421	40.4	16	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
306	306	126	20230724	Mobile	MacOS	Chrome	2548	42.5	18	0	1	1	0	488.55	1	/profil	Profil	2026-05-22 23:28:36.880998
307	307	29	20231216	Mobile	iOS	Safari	160	2.7	5	0	0	0	0	0.00	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
308	308	170	20220629	Desktop	MacOS	Chrome	210	3.5	4	0	0	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
309	309	294	20221230	Desktop	Windows	Chrome	1875	31.3	19	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
310	310	166	20240125	Mobile	iOS	Chrome	1562	26.0	3	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
311	311	69	20220907	Desktop	Android	Chrome	2855	47.6	9	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
312	312	30	20220812	Tablet	Android	Firefox	2350	39.2	17	0	1	0	0	0.00	2	/produits/crm	Produit	2026-05-22 23:28:36.880998
313	313	219	20231011	Mobile	iOS	Chrome	1073	17.9	17	0	1	0	2	814.30	3	/	Accueil	2026-05-22 23:28:36.880998
314	314	289	20241013	Desktop	MacOS	Edge	2138	35.6	16	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
315	315	149	20230201	Desktop	Windows	Firefox	16	0.3	4	1	0	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
316	316	213	20240427	Desktop	MacOS	Chrome	196	3.3	11	0	0	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
317	317	145	20230606	Desktop	iOS	Chrome	3246	54.1	3	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
318	318	59	20231114	Mobile	iOS	Opera	1408	23.5	13	0	1	1	0	343.68	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
319	319	100	20231108	Tablet	Android	Edge	3425	57.1	11	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
320	320	70	20240913	Mobile	iOS	Edge	646	10.8	15	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
321	321	212	20220425	Desktop	Linux	Chrome	3430	57.2	17	0	1	1	0	459.56	2	\N	\N	2026-05-22 23:28:36.880998
322	322	107	20231111	Desktop	MacOS	Chrome	3284	54.7	12	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
323	323	174	20240208	Mobile	iOS	Firefox	2576	42.9	18	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
324	324	60	20230924	Mobile	Linux	Chrome	2898	48.3	11	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
325	325	122	20240201	Desktop	Linux	Chrome	1861	31.0	10	0	1	0	0	0.00	2	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
326	326	20	20230218	Desktop	Android	Edge	389	6.5	15	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
327	327	98	20231128	Desktop	Linux	Chrome	1990	33.2	17	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
328	328	265	20220929	Desktop	iOS	Chrome	850	14.2	2	0	1	2	0	332.14	2	\N	\N	2026-05-22 23:28:36.880998
329	329	23	20220628	Mobile	Windows	Chrome	1375	22.9	15	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
330	330	12	20231002	Desktop	MacOS	Chrome	2626	43.8	7	0	1	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
331	331	226	20220829	Desktop	Windows	Chrome	1126	18.8	5	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
332	332	106	20231219	Desktop	Linux	Chrome	2260	37.7	11	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
333	333	37	20230930	Desktop	Windows	Chrome	2521	42.0	11	0	1	1	0	87.67	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
334	334	26	20220805	Desktop	Android	Chrome	1581	26.4	2	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
335	335	183	20231002	Mobile	iOS	Chrome	1371	22.9	7	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
336	336	291	20220927	Desktop	Linux	Firefox	390	6.5	15	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
337	337	241	20230420	Mobile	iOS	Chrome	926	15.4	5	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
338	338	201	20230111	Mobile	Linux	Chrome	2875	47.9	11	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
339	339	34	20240831	Desktop	MacOS	Chrome	472	7.9	12	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
340	340	295	20220918	Desktop	Windows	Chrome	2090	34.8	4	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
341	341	155	20241227	Mobile	MacOS	Firefox	1898	31.6	13	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
342	342	247	20240226	Desktop	iOS	Chrome	280	4.7	11	0	0	0	2	597.20	3	\N	\N	2026-05-22 23:28:36.880998
343	343	291	20231202	Desktop	Windows	Firefox	2240	37.3	8	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
344	344	59	20240806	Desktop	Android	Chrome	1342	22.4	18	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
345	345	36	20220811	Mobile	Android	Chrome	2817	47.0	20	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
346	346	47	20230322	Mobile	Windows	Safari	3356	55.9	5	0	1	0	0	0.00	2	/	Accueil	2026-05-22 23:28:36.880998
347	347	232	20241224	Mobile	Android	Chrome	1203	20.1	13	0	1	1	0	122.50	1	/blog	Blog	2026-05-22 23:28:36.880998
348	348	154	20230916	Tablet	iOS	Chrome	1790	29.8	12	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
349	349	66	20230826	Tablet	Windows	Chrome	265	4.4	12	0	0	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
350	350	57	20230801	Desktop	iOS	Chrome	3555	59.3	1	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
351	351	196	20240411	Desktop	MacOS	Chrome	1572	26.2	14	0	1	0	1	242.60	1	/profil	Profil	2026-05-22 23:28:36.880998
352	352	285	20240227	Mobile	MacOS	Chrome	3464	57.7	12	0	1	0	1	332.54	1	/profil	Profil	2026-05-22 23:28:36.880998
353	353	69	20220124	Desktop	Android	Firefox	303	5.1	1	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
354	354	44	20221009	Mobile	iOS	Edge	2640	44.0	14	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
355	355	233	20241109	Mobile	Android	Chrome	1747	29.1	18	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
356	356	218	20220116	Mobile	MacOS	Firefox	2377	39.6	16	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
357	357	211	20240122	Mobile	Linux	Chrome	147	2.5	2	0	0	0	0	0.00	1	/dashboard	Dashboard	2026-05-22 23:28:36.880998
358	358	41	20221018	Tablet	Linux	Chrome	3000	50.0	17	0	1	1	0	230.19	1	/dashboard	Dashboard	2026-05-22 23:28:36.880998
359	359	268	20220701	Mobile	Windows	Firefox	1014	16.9	16	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
360	360	28	20231205	Desktop	iOS	Edge	2201	36.7	1	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
361	361	216	20231224	Desktop	Windows	Firefox	3279	54.7	10	0	1	0	1	331.31	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
362	362	289	20230618	Mobile	iOS	Chrome	261	4.4	16	0	0	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
363	363	14	20230811	Desktop	Windows	Edge	1995	33.3	3	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
364	364	130	20220929	Desktop	Linux	Chrome	2532	42.2	9	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
365	365	90	20221106	Desktop	MacOS	Chrome	2709	45.2	15	0	1	0	0	0.00	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
366	366	249	20230106	Mobile	Linux	Opera	3284	54.7	17	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
367	367	79	20241012	Mobile	MacOS	Firefox	3093	51.6	14	0	1	1	0	62.38	2	/support	Support	2026-05-22 23:28:36.880998
368	368	108	20231208	Mobile	Windows	Chrome	232	3.9	9	0	0	0	0	0.00	1	/support	Support	2026-05-22 23:28:36.880998
369	369	205	20240902	Mobile	iOS	Chrome	1244	20.7	16	0	1	0	1	98.32	1	/contact	Contact	2026-05-22 23:28:36.880998
370	370	243	20230622	Mobile	Windows	Chrome	604	10.1	17	0	1	0	0	0.00	1	/dashboard	Dashboard	2026-05-22 23:28:36.880998
371	371	196	20231009	Desktop	iOS	Firefox	2181	36.4	2	0	1	1	0	302.72	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
372	372	140	20231118	Mobile	Linux	Firefox	1117	18.6	9	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
373	373	237	20230511	Mobile	iOS	Chrome	3017	50.3	19	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
374	374	161	20220122	Mobile	Windows	Chrome	2765	46.1	1	0	1	1	0	54.35	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
375	375	229	20231221	Desktop	Windows	Chrome	908	15.1	10	0	1	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
376	376	30	20230321	Mobile	Windows	Chrome	2465	41.1	4	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
377	377	193	20230114	Desktop	Android	Firefox	464	7.7	6	0	1	0	0	0.00	1	/dashboard	Dashboard	2026-05-22 23:28:36.880998
378	378	233	20230721	Mobile	Linux	Chrome	3161	52.7	14	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
379	379	142	20220508	Desktop	Windows	Chrome	1577	26.3	13	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
380	380	92	20240621	Tablet	MacOS	Firefox	294	4.9	16	0	0	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
381	381	252	20220811	Mobile	MacOS	Firefox	599	10.0	18	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
382	382	227	20230615	Desktop	iOS	Firefox	433	7.2	2	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
383	383	10	20241016	Tablet	Android	Chrome	619	10.3	1	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
384	384	201	20220108	Desktop	Android	Safari	2121	35.4	16	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
385	385	277	20230408	Tablet	Android	Chrome	23	0.4	13	1	0	0	0	0.00	2	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
386	386	171	20230913	Mobile	Windows	Chrome	1650	27.5	2	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
387	387	42	20240730	Mobile	MacOS	Chrome	3124	52.1	10	0	1	2	0	379.64	7	/dashboard	Dashboard	2026-05-22 23:28:36.880998
388	388	98	20230905	Mobile	Linux	Chrome	2860	47.7	13	0	1	0	0	0.00	2	/contact	Contact	2026-05-22 23:28:36.880998
389	389	98	20221014	Desktop	iOS	Chrome	156	2.6	7	0	0	0	0	0.00	1	/dashboard	Dashboard	2026-05-22 23:28:36.880998
390	390	33	20230923	Tablet	Android	Opera	2056	34.3	18	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
391	391	19	20231126	Mobile	Windows	Chrome	239	4.0	11	0	0	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
392	392	268	20240727	Desktop	iOS	Chrome	2787	46.5	18	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
393	393	19	20221017	Desktop	iOS	Chrome	2012	33.5	1	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
394	394	8	20221219	Tablet	Windows	Chrome	2601	43.4	2	0	1	0	0	0.00	4	/blog	Blog	2026-05-22 23:28:36.880998
395	395	33	20220806	Mobile	iOS	Chrome	477	8.0	16	0	1	0	1	238.86	1	\N	\N	2026-05-22 23:28:36.880998
396	396	219	20231122	Desktop	iOS	Chrome	3333	55.6	13	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
397	397	110	20220404	Desktop	Windows	Chrome	2439	40.7	6	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
398	398	87	20240128	Desktop	iOS	Chrome	2276	37.9	6	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
399	399	193	20221120	Desktop	Windows	Chrome	74	1.2	16	0	0	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
400	400	146	20240502	Mobile	MacOS	Chrome	2850	47.5	16	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
401	401	268	20240711	Tablet	iOS	Firefox	1697	28.3	8	0	1	0	0	0.00	3	/dashboard	Dashboard	2026-05-22 23:28:36.880998
402	402	256	20220630	Desktop	Windows	Chrome	2578	43.0	10	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
403	403	61	20241221	Desktop	iOS	Chrome	401	6.7	20	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
404	404	107	20230721	Desktop	MacOS	Firefox	227	3.8	7	0	0	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
405	405	255	20221228	Desktop	Linux	Chrome	664	11.1	2	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
406	406	129	20231116	Desktop	Windows	Edge	2536	42.3	15	0	1	0	0	0.00	2	/contact	Contact	2026-05-22 23:28:36.880998
407	407	81	20220301	Desktop	MacOS	Firefox	1996	33.3	17	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
408	408	215	20230212	Desktop	Windows	Chrome	3070	51.2	11	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
409	409	122	20240424	Desktop	MacOS	Chrome	3573	59.6	7	0	1	0	0	0.00	2	/contact	Contact	2026-05-22 23:28:36.880998
410	410	28	20240611	Tablet	Android	Chrome	603	10.1	7	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
411	411	70	20240726	Mobile	Linux	Chrome	2958	49.3	7	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
412	412	17	20220503	Desktop	Android	Chrome	1159	19.3	5	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
413	413	176	20230327	Desktop	iOS	Edge	1218	20.3	20	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
414	414	45	20240423	Desktop	MacOS	Chrome	3520	58.7	17	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
415	415	143	20220130	Mobile	MacOS	Chrome	3000	50.0	14	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
416	416	297	20230401	Tablet	Windows	Chrome	2433	40.6	5	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
417	417	21	20240821	Desktop	iOS	Chrome	3014	50.2	17	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
418	418	232	20241011	Mobile	Windows	Firefox	995	16.6	3	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
419	419	112	20220929	Desktop	Windows	Chrome	1478	24.6	10	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
420	420	83	20240729	Mobile	Windows	Opera	3524	58.7	19	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
421	421	71	20240410	Mobile	Windows	Edge	767	12.8	12	0	1	1	0	64.57	2	/	Accueil	2026-05-22 23:28:36.880998
422	422	198	20231113	Desktop	Linux	Firefox	2184	36.4	2	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
423	423	42	20231119	Desktop	Linux	Edge	3023	50.4	2	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
424	424	197	20240119	Desktop	Linux	Chrome	1916	31.9	20	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
425	425	288	20230224	Desktop	Windows	Firefox	576	9.6	11	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
426	426	116	20231019	Desktop	Android	Chrome	1454	24.2	9	0	1	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
427	427	191	20231209	Desktop	Windows	Chrome	1863	31.1	16	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
428	428	232	20240124	Desktop	Android	Chrome	3286	54.8	3	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
429	429	92	20230814	Desktop	Windows	Firefox	325	5.4	4	0	1	1	0	493.12	3	\N	\N	2026-05-22 23:28:36.880998
430	430	78	20230223	Desktop	iOS	Edge	2142	35.7	1	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
431	431	178	20240510	Desktop	Windows	Chrome	1828	30.5	1	0	1	0	0	0.00	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
432	432	267	20231119	Desktop	Linux	Chrome	1696	28.3	19	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
433	433	235	20230915	Mobile	Linux	Chrome	2333	38.9	5	0	1	0	0	0.00	4	/produits	Produit	2026-05-22 23:28:36.880998
434	434	117	20240918	Mobile	Windows	Chrome	1533	25.6	10	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
435	435	234	20221207	Mobile	Linux	Chrome	2543	42.4	6	0	1	1	0	248.90	1	\N	\N	2026-05-22 23:28:36.880998
436	436	79	20221127	Desktop	Linux	Chrome	984	16.4	4	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
437	437	134	20240128	Mobile	Windows	Firefox	765	12.8	7	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
438	438	76	20240203	Tablet	iOS	Chrome	1846	30.8	18	0	1	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
439	439	208	20241019	Tablet	Linux	Chrome	3157	52.6	5	0	1	0	1	317.82	3	/dashboard	Dashboard	2026-05-22 23:28:36.880998
440	440	152	20240828	Mobile	iOS	Firefox	1197	20.0	19	0	1	0	1	224.99	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
441	441	174	20220819	Tablet	MacOS	Firefox	3006	50.1	16	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
442	442	158	20220220	Mobile	Android	Chrome	1655	27.6	20	0	1	0	1	264.55	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
443	443	29	20230204	Desktop	Linux	Chrome	2399	40.0	17	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
444	444	276	20240701	Tablet	Android	Chrome	2783	46.4	3	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
445	445	262	20220425	Desktop	Android	Chrome	2741	45.7	12	0	1	1	0	162.61	3	\N	\N	2026-05-22 23:28:36.880998
446	446	7	20230806	Desktop	Android	Edge	1422	23.7	12	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
447	447	111	20240628	Mobile	Linux	Chrome	3047	50.8	14	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
448	448	213	20221013	Mobile	MacOS	Chrome	3432	57.2	19	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
449	449	269	20231118	Mobile	Windows	Chrome	280	4.7	19	0	0	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
450	450	213	20221225	Mobile	MacOS	Chrome	2286	38.1	15	0	1	1	0	176.87	2	\N	\N	2026-05-22 23:28:36.880998
451	451	149	20241001	Mobile	Linux	Chrome	182	3.0	10	0	0	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
452	452	115	20220224	Desktop	Linux	Opera	3250	54.2	1	0	1	1	0	146.56	1	/	Accueil	2026-05-22 23:28:36.880998
453	453	64	20230813	Desktop	MacOS	Chrome	1718	28.6	6	0	1	0	0	0.00	2	/produits	Produit	2026-05-22 23:28:36.880998
454	454	253	20220517	Mobile	iOS	Chrome	2463	41.1	12	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
455	455	244	20220902	Mobile	Windows	Safari	1538	25.6	17	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
456	456	298	20220430	Desktop	MacOS	Chrome	608	10.1	11	0	1	0	1	398.51	3	\N	\N	2026-05-22 23:28:36.880998
457	457	140	20240110	Desktop	Linux	Chrome	1728	28.8	12	0	1	0	1	186.65	3	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
458	458	264	20230201	Mobile	iOS	Safari	3149	52.5	6	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
459	459	162	20230909	Desktop	iOS	Chrome	1121	18.7	12	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
460	460	7	20221008	Desktop	Android	Chrome	2132	35.5	10	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
461	461	53	20230323	Desktop	MacOS	Safari	643	10.7	17	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
462	462	214	20240801	Mobile	Windows	Chrome	322	5.4	4	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
463	463	186	20221012	Mobile	iOS	Chrome	3356	55.9	15	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
464	464	89	20230916	Desktop	MacOS	Firefox	127	2.1	4	0	0	0	1	170.81	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
465	465	65	20230306	Desktop	Windows	Chrome	543	9.1	3	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
466	466	221	20220329	Desktop	iOS	Chrome	814	13.6	4	0	1	0	0	0.00	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
467	467	61	20230603	Desktop	Windows	Safari	187	3.1	3	0	0	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
468	468	106	20230214	Desktop	MacOS	Safari	766	12.8	12	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
469	469	297	20231214	Mobile	iOS	Chrome	1452	24.2	6	0	1	1	0	347.98	1	\N	\N	2026-05-22 23:28:36.880998
470	470	51	20220129	Mobile	Linux	Chrome	2176	36.3	7	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
471	471	51	20230315	Desktop	iOS	Chrome	2075	34.6	16	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
472	472	93	20231228	Desktop	MacOS	Chrome	1564	26.1	14	0	1	0	0	0.00	3	/profil	Profil	2026-05-22 23:28:36.880998
473	473	64	20240812	Desktop	Linux	Firefox	461	7.7	17	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
474	474	43	20231103	Desktop	Android	Firefox	2032	33.9	4	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
475	475	228	20230408	Desktop	Android	Chrome	2278	38.0	14	0	1	0	0	0.00	2	/blog/article-2	Blog	2026-05-22 23:28:36.880998
476	476	244	20240123	Tablet	Android	Firefox	744	12.4	1	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
477	477	225	20241206	Desktop	Android	Chrome	2707	45.1	3	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
478	478	87	20220513	Desktop	iOS	Safari	1499	25.0	7	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
479	479	63	20230422	Mobile	Linux	Safari	3442	57.4	14	0	1	1	0	122.46	1	/	Accueil	2026-05-22 23:28:36.880998
480	480	205	20231231	Tablet	Android	Chrome	1958	32.6	20	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
481	481	233	20220810	Desktop	MacOS	Firefox	510	8.5	9	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
482	482	16	20220723	Mobile	Android	Firefox	3032	50.5	2	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
483	483	196	20231101	Mobile	Windows	Safari	635	10.6	10	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
484	484	239	20230218	Desktop	Linux	Chrome	1212	20.2	16	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
485	485	17	20240531	Desktop	Android	Chrome	497	8.3	13	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
486	486	17	20221229	Mobile	MacOS	Chrome	2290	38.2	10	0	1	1	0	63.92	1	/support	Support	2026-05-22 23:28:36.880998
487	487	160	20240307	Mobile	Android	Firefox	2006	33.4	4	0	1	0	0	0.00	2	/blog/article-2	Blog	2026-05-22 23:28:36.880998
488	488	244	20221117	Desktop	Android	Chrome	2085	34.8	2	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
489	489	181	20230806	Desktop	Windows	Chrome	1322	22.0	2	0	1	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
490	490	179	20220225	Desktop	Android	Chrome	3144	52.4	11	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
491	491	211	20231221	Desktop	Linux	Chrome	241	4.0	8	0	0	0	1	271.76	2	/dashboard	Dashboard	2026-05-22 23:28:36.880998
492	492	157	20220823	Desktop	Linux	Chrome	1392	23.2	6	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
493	493	291	20241120	Desktop	Android	Chrome	1735	28.9	9	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
494	494	194	20240310	Desktop	Android	Chrome	1330	22.2	19	0	1	0	0	0.00	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
495	495	173	20241014	Desktop	Linux	Chrome	2069	34.5	11	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
496	496	104	20241014	Mobile	iOS	Chrome	2612	43.5	3	0	1	0	0	0.00	0	/blog/article-2	Blog	2026-05-22 23:28:36.880998
497	497	25	20230901	Mobile	iOS	Firefox	2359	39.3	13	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
498	498	297	20220714	Desktop	iOS	Safari	2434	40.6	11	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
499	499	219	20230306	Mobile	Linux	Chrome	1432	23.9	3	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
500	500	222	20231004	Desktop	iOS	Chrome	829	13.8	14	0	1	0	0	0.00	2	\N	\N	2026-05-22 23:28:36.880998
501	501	10	20241123	Mobile	MacOS	Firefox	3543	59.1	6	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
502	502	138	20241227	Mobile	Android	Edge	3323	55.4	20	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
503	503	268	20230215	Desktop	MacOS	Firefox	1502	25.0	15	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
504	504	223	20240420	Mobile	Android	Chrome	1315	21.9	3	0	1	0	0	0.00	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
505	505	83	20230610	Desktop	MacOS	Chrome	2823	47.1	20	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
506	506	15	20230518	Desktop	iOS	Opera	3274	54.6	10	0	1	0	1	32.68	2	/blog/article-2	Blog	2026-05-22 23:28:36.880998
507	507	19	20230218	Desktop	Linux	Safari	662	11.0	9	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
508	508	282	20221227	Tablet	Android	Safari	2649	44.2	2	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
509	509	43	20231005	Mobile	Android	Edge	2474	41.2	10	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
510	510	204	20221015	Mobile	iOS	Edge	976	16.3	4	0	1	0	0	0.00	1	/contact	Contact	2026-05-22 23:28:36.880998
511	511	255	20220704	Desktop	Linux	Chrome	985	16.4	20	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
512	512	121	20240516	Desktop	MacOS	Opera	902	15.0	5	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
513	513	210	20230605	Desktop	iOS	Chrome	3544	59.1	19	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
514	514	163	20240517	Tablet	MacOS	Chrome	1955	32.6	8	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
515	515	158	20220213	Desktop	Windows	Firefox	2653	44.2	20	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
516	516	130	20240227	Tablet	Windows	Chrome	1276	21.3	12	0	1	1	0	348.35	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
517	517	227	20240306	Tablet	Linux	Chrome	42	0.7	13	0	0	1	0	398.41	3	/tarifs	Tarifs	2026-05-22 23:28:36.880998
518	518	153	20230307	Tablet	Linux	Edge	3530	58.8	6	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
519	519	18	20230716	Mobile	Android	Chrome	3558	59.3	3	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
520	520	171	20240515	Mobile	Linux	Chrome	3369	56.2	4	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
521	521	216	20231101	Mobile	MacOS	Firefox	1866	31.1	1	0	1	0	0	0.00	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
522	522	2	20240331	Desktop	Windows	Chrome	829	13.8	10	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
523	523	265	20220924	Mobile	Linux	Chrome	3479	58.0	20	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
524	524	134	20221222	Mobile	Linux	Chrome	2825	47.1	19	0	1	1	0	456.08	2	\N	\N	2026-05-22 23:28:36.880998
525	525	189	20230108	Tablet	iOS	Chrome	1621	27.0	13	0	1	0	0	0.00	1	/blog/article-1	Blog	2026-05-22 23:28:36.880998
526	526	286	20230414	Desktop	MacOS	Chrome	374	6.2	15	0	1	1	0	375.36	3	\N	\N	2026-05-22 23:28:36.880998
527	527	134	20221102	Desktop	iOS	Chrome	374	6.2	12	0	1	0	0	0.00	0	/profil	Profil	2026-05-22 23:28:36.880998
528	528	233	20241009	Mobile	MacOS	Edge	495	8.3	8	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
529	529	148	20241009	Desktop	MacOS	Firefox	1574	26.2	5	0	1	0	0	0.00	1	/	Accueil	2026-05-22 23:28:36.880998
530	530	97	20240506	Mobile	Windows	Chrome	748	12.5	14	0	1	0	1	138.97	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
531	531	121	20240712	Mobile	Android	Chrome	1027	17.1	12	0	1	1	0	429.85	3	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
532	532	69	20231025	Mobile	Android	Firefox	2848	47.5	13	0	1	1	0	356.24	3	\N	\N	2026-05-22 23:28:36.880998
533	533	38	20220715	Desktop	MacOS	Chrome	2291	38.2	2	0	1	0	0	0.00	1	/blog	Blog	2026-05-22 23:28:36.880998
534	534	24	20220111	Mobile	Linux	Opera	1048	17.5	17	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
535	535	68	20220326	Desktop	iOS	Chrome	2387	39.8	6	0	1	0	0	0.00	1	/produits/crm	Produit	2026-05-22 23:28:36.880998
536	536	240	20220928	Mobile	Android	Chrome	377	6.3	11	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
537	537	161	20220401	Mobile	Linux	Firefox	533	8.9	16	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
538	538	145	20230624	Desktop	Android	Edge	2520	42.0	9	0	1	0	1	168.09	2	/contact	Contact	2026-05-22 23:28:36.880998
539	539	252	20221106	Desktop	MacOS	Chrome	2286	38.1	15	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
540	540	19	20240821	Mobile	Android	Chrome	1075	17.9	6	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
541	541	21	20240623	Desktop	Android	Chrome	1470	24.5	18	0	1	0	0	0.00	1	\N	\N	2026-05-22 23:28:36.880998
542	542	64	20231217	Mobile	MacOS	Safari	393	6.6	7	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
543	543	289	20230311	Desktop	iOS	Chrome	2400	40.0	1	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
544	544	127	20241017	Mobile	Windows	Chrome	2782	46.4	4	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
545	545	202	20240205	Mobile	MacOS	Chrome	2428	40.5	4	0	1	0	0	0.00	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
546	546	246	20240718	Mobile	Windows	Chrome	2583	43.1	9	0	1	0	0	0.00	2	/blog/article-2	Blog	2026-05-22 23:28:36.880998
547	547	232	20231028	Desktop	Windows	Safari	3006	50.1	19	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
548	548	166	20220424	Desktop	iOS	Chrome	3056	50.9	3	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
549	549	131	20221231	Desktop	MacOS	Chrome	993	16.6	13	0	1	0	0	0.00	1	/profil	Profil	2026-05-22 23:28:36.880998
550	550	146	20221112	Desktop	Android	Firefox	503	8.4	10	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
551	551	68	20240106	Mobile	iOS	Chrome	2735	45.6	4	0	1	0	0	0.00	2	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
552	552	199	20240902	Mobile	Windows	Safari	1109	18.5	19	0	1	0	0	0.00	2	/produits/crm	Produit	2026-05-22 23:28:36.880998
553	553	96	20240608	Desktop	iOS	Chrome	2593	43.2	14	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
554	554	115	20221114	Mobile	iOS	Chrome	2038	34.0	17	0	1	0	0	0.00	0	/produits/erp	Produit	2026-05-22 23:28:36.880998
555	555	224	20220612	Desktop	MacOS	Firefox	3293	54.9	16	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
556	556	128	20241207	Mobile	iOS	Chrome	1761	29.4	10	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
557	557	263	20220809	Desktop	Android	Firefox	2101	35.0	14	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
558	558	182	20230606	Mobile	Windows	Chrome	2408	40.1	3	0	1	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
559	559	92	20230109	Desktop	Android	Edge	3462	57.7	13	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
560	560	161	20240720	Mobile	Linux	Chrome	3112	51.9	15	0	1	0	0	0.00	0	/dashboard	Dashboard	2026-05-22 23:28:36.880998
561	561	109	20230115	Desktop	Windows	Chrome	330	5.5	20	0	1	0	0	0.00	0	/	Accueil	2026-05-22 23:28:36.880998
562	562	3	20240319	Desktop	Android	Chrome	487	8.1	1	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
563	563	250	20230913	Desktop	Android	Safari	2543	42.4	20	0	1	1	1	488.25	2	/support	Support	2026-05-22 23:28:36.880998
564	564	65	20221004	Desktop	Windows	Firefox	66	1.1	7	0	0	1	0	375.54	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
565	565	14	20230305	Mobile	Android	Safari	1980	33.0	5	0	1	0	1	413.91	2	/tarifs	Tarifs	2026-05-22 23:28:36.880998
566	566	45	20230909	Desktop	Android	Chrome	3162	52.7	15	0	1	0	0	0.00	1	/produits	Produit	2026-05-22 23:28:36.880998
567	567	79	20240630	Desktop	Android	Chrome	1996	33.3	16	0	1	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
568	568	151	20240313	Desktop	Android	Opera	218	3.6	11	0	0	0	0	0.00	0	/blog	Blog	2026-05-22 23:28:36.880998
569	569	297	20230819	Desktop	iOS	Chrome	161	2.7	16	0	0	0	0	0.00	0	/blog/article-1	Blog	2026-05-22 23:28:36.880998
570	570	119	20220505	Desktop	Linux	Chrome	2173	36.2	1	0	1	0	0	0.00	1	/blog/article-2	Blog	2026-05-22 23:28:36.880998
571	571	214	20240827	Mobile	Linux	Chrome	488	8.1	16	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
572	572	11	20221127	Desktop	Android	Chrome	1189	19.8	7	0	1	1	0	29.79	2	/blog/article-1	Blog	2026-05-22 23:28:36.880998
573	573	174	20240817	Mobile	Android	Opera	547	9.1	10	0	1	0	1	478.65	3	/contact	Contact	2026-05-22 23:28:36.880998
574	574	242	20221128	Desktop	Windows	Firefox	2557	42.6	7	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
575	575	89	20230213	Desktop	Android	Edge	650	10.8	20	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
576	576	156	20230426	Desktop	Windows	Chrome	867	14.5	18	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
577	577	183	20221121	Desktop	Windows	Chrome	725	12.1	17	0	1	0	0	0.00	0	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
578	578	117	20220905	Desktop	Linux	Safari	2311	38.5	8	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
579	579	286	20230702	Mobile	Windows	Firefox	629	10.5	17	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
580	580	235	20220816	Mobile	Windows	Safari	443	7.4	20	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
581	581	260	20220804	Mobile	Linux	Chrome	694	11.6	4	0	1	1	0	29.49	1	/profil	Profil	2026-05-22 23:28:36.880998
582	582	227	20241102	Desktop	Linux	Chrome	2051	34.2	4	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
583	583	63	20230218	Mobile	Windows	Chrome	1808	30.1	14	0	1	0	0	0.00	0	/produits/crm	Produit	2026-05-22 23:28:36.880998
584	584	175	20230811	Desktop	Linux	Firefox	2078	34.6	6	0	1	0	0	0.00	0	/support	Support	2026-05-22 23:28:36.880998
585	585	185	20230518	Desktop	MacOS	Chrome	630	10.5	17	0	1	0	0	0.00	0	/tarifs	Tarifs	2026-05-22 23:28:36.880998
586	586	212	20240418	Mobile	Linux	Edge	1889	31.5	17	0	1	0	1	478.89	1	/produits/erp	Produit	2026-05-22 23:28:36.880998
587	587	75	20220121	Tablet	Windows	Chrome	2949	49.2	17	0	1	0	0	0.00	1	/support	Support	2026-05-22 23:28:36.880998
588	588	85	20240607	Mobile	MacOS	Edge	261	4.4	13	0	0	0	1	145.75	1	/tarifs/premium	Tarifs	2026-05-22 23:28:36.880998
589	589	267	20230829	Mobile	iOS	Edge	1727	28.8	13	0	1	1	0	281.25	1	/profil	Profil	2026-05-22 23:28:36.880998
590	590	177	20220117	Tablet	iOS	Edge	3397	56.6	9	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
591	591	229	20230225	Mobile	Android	Firefox	2239	37.3	20	0	1	0	1	431.21	2	/produits/erp	Produit	2026-05-22 23:28:36.880998
592	592	102	20230910	Desktop	Android	Firefox	355	5.9	2	0	1	0	0	0.00	1	/tarifs	Tarifs	2026-05-22 23:28:36.880998
593	593	267	20230805	Desktop	Linux	Chrome	885	14.8	3	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
594	594	12	20220227	Mobile	MacOS	Safari	3272	54.5	18	0	1	0	0	0.00	0	/contact	Contact	2026-05-22 23:28:36.880998
595	595	217	20241031	Mobile	Linux	Firefox	462	7.7	2	0	1	0	1	117.60	1	/contact	Contact	2026-05-22 23:28:36.880998
596	596	64	20220408	Desktop	iOS	Firefox	3108	51.8	4	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
597	597	174	20230429	Mobile	iOS	Safari	3308	55.1	19	0	1	0	0	0.00	0	\N	\N	2026-05-22 23:28:36.880998
598	598	180	20230905	Mobile	Android	Chrome	1175	19.6	19	0	1	0	0	0.00	1	/support	Support	2026-05-22 23:28:36.880998
599	599	54	20231103	Desktop	Linux	Chrome	2125	35.4	19	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
600	600	218	20240423	Desktop	MacOS	Chrome	345	5.8	3	0	1	0	0	0.00	0	/produits	Produit	2026-05-22 23:28:36.880998
\.


--
-- Data for Name: fact_subscriptions; Type: TABLE DATA; Schema: technova_dw; Owner: -
--

COPY technova_dw.fact_subscriptions (sub_sk, abonnement_id, user_sk, date_debut_sk, date_fin_sk, nom_plan, prix_mensuel_tnd, niveau_plan, montant_tnd, nb_jours_contrat, mode_paiement, statut, est_actif, est_churn, est_renouvellement, etl_loaded_at) FROM stdin;
1	1	37	20230928	20240927	Premium	99.00	2	1188.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
2	2	114	20211231	20221231	Entreprise	199.00	3	299.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
3	3	257	20230327	20240326	Standard	49.00	1	49.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
4	4	256	20210401	20220401	Standard	49.00	1	49.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
5	5	174	20220104	20230104	Premium	99.00	2	594.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
6	6	199	20230912	20240911	Entreprise	199.00	3	299.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
7	7	92	20230327	20240326	Standard	49.00	1	588.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
8	8	239	20221211	20231211	Standard	49.00	1	588.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
9	9	7	20221016	20231016	Standard	49.00	1	49.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
10	10	233	20230923	20240922	Standard	49.00	1	588.00	365	Chèque	Remboursé	0	1	0	2026-05-22 23:28:36.880998
11	11	217	20220913	20230913	Standard	49.00	1	294.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
12	12	231	20230203	20240203	Entreprise	199.00	3	1794.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
13	13	58	20230519	20240518	Standard	49.00	1	588.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
14	14	77	20221122	20231122	Standard	49.00	1	588.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
15	15	264	20230721	20240720	Entreprise	199.00	3	1794.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
16	16	21	20230930	20240929	Standard	49.00	1	294.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
17	17	130	20221123	20231123	Premium	99.00	2	1188.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
18	18	278	20220102	20230102	Premium	99.00	2	594.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
19	19	229	20220902	20230902	Premium	99.00	2	1188.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
20	20	183	20210316	20220316	Entreprise	199.00	3	3588.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
21	21	90	20210713	20220713	Standard	49.00	1	49.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
22	22	221	20221209	20231209	Premium	99.00	2	594.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
23	23	269	20230728	20240727	Entreprise	199.00	3	299.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
24	24	20	20210727	20220727	Standard	49.00	1	294.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
25	25	173	20220911	20230911	Entreprise	199.00	3	1794.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
26	26	132	20210612	20220612	Entreprise	199.00	3	1794.00	365	Virement	Remboursé	0	1	0	2026-05-22 23:28:36.880998
27	27	293	20220913	20230913	Premium	99.00	2	1188.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
28	28	26	20230827	20240826	Premium	99.00	2	99.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
29	29	141	20220116	20230116	Entreprise	199.00	3	1794.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
30	30	205	20220807	20230807	Standard	49.00	1	294.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
31	31	10	20210923	20220923	Premium	99.00	2	594.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
32	32	50	20220406	20230406	Standard	49.00	1	49.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
33	33	33	20220813	20230813	Entreprise	199.00	3	3588.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
34	34	216	20221105	20231105	Entreprise	199.00	3	3588.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
35	35	176	20221017	20231017	Premium	99.00	2	594.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
36	36	237	20231019	20241018	Entreprise	199.00	3	299.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
37	37	200	20230406	20240405	Premium	99.00	2	99.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
38	38	250	20221209	20231209	Entreprise	199.00	3	299.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
39	39	156	20221008	20231008	Premium	99.00	2	594.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
40	40	80	20211208	20221208	Entreprise	199.00	3	3588.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
41	41	213	20220805	20230805	Standard	49.00	1	588.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
42	42	193	20210927	20220927	Entreprise	199.00	3	1794.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
43	43	50	20220324	20230324	Premium	99.00	2	99.00	365	PayPal	Remboursé	0	1	0	2026-05-22 23:28:36.880998
44	44	92	20230402	20240401	Standard	49.00	1	588.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
45	45	215	20220726	20230726	Entreprise	199.00	3	1794.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
46	46	163	20231227	20241226	Entreprise	199.00	3	1794.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
47	47	254	20220810	20230810	Premium	99.00	2	594.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
48	48	205	20210107	20220107	Premium	99.00	2	1188.00	365	Chèque	Annulé	0	1	0	2026-05-22 23:28:36.880998
49	49	89	20210721	20220721	Entreprise	199.00	3	1794.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
50	50	215	20220122	20230122	Premium	99.00	2	1188.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
51	51	71	20231028	20241027	Entreprise	199.00	3	299.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
52	52	12	20220527	20230527	Premium	99.00	2	99.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
53	53	47	20210216	20220216	Premium	99.00	2	1188.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
54	54	283	20220131	20230131	Entreprise	199.00	3	299.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
55	55	90	20220214	20230214	Premium	99.00	2	594.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
56	56	16	20230803	20240802	Standard	49.00	1	294.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
57	57	124	20230803	20240802	Standard	49.00	1	588.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
58	58	82	20230805	20240804	Standard	49.00	1	588.00	365	Carte	Remboursé	0	1	0	2026-05-22 23:28:36.880998
59	59	17	20230413	20240412	Entreprise	199.00	3	3588.00	365	Chèque	Remboursé	0	1	0	2026-05-22 23:28:36.880998
60	60	37	20220617	20230617	Premium	99.00	2	1188.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
61	61	225	20210503	20220503	Premium	99.00	2	594.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
62	62	187	20231114	20241113	Premium	99.00	2	1188.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
63	63	64	20211026	20221026	Standard	49.00	1	294.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
64	64	87	20230426	20240425	Premium	99.00	2	1188.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
65	65	248	20220626	20230626	Standard	49.00	1	49.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
66	66	235	20231004	20241003	Entreprise	199.00	3	299.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
67	67	152	20230630	20240629	Entreprise	199.00	3	1794.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
68	68	291	20210315	20220315	Premium	99.00	2	99.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
69	69	14	20230130	20240130	Standard	49.00	1	588.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
70	70	158	20211121	20221121	Entreprise	199.00	3	3588.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
71	71	226	20220827	20230827	Entreprise	199.00	3	299.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
72	72	76	20220822	20230822	Entreprise	199.00	3	1794.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
73	73	15	20220913	20230913	Standard	49.00	1	49.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
74	74	187	20231108	20241107	Entreprise	199.00	3	3588.00	365	Chèque	Annulé	0	1	0	2026-05-22 23:28:36.880998
75	75	245	20211215	20221215	Entreprise	199.00	3	1794.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
76	76	268	20230214	20240214	Premium	99.00	2	594.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
77	77	90	20230217	20240217	Premium	99.00	2	99.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
78	78	176	20220926	20230926	Standard	49.00	1	49.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
79	79	62	20220208	20230208	Entreprise	199.00	3	1794.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
80	80	269	20220219	20230219	Standard	49.00	1	294.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
81	81	51	20231106	20241105	Premium	99.00	2	99.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
82	82	29	20231207	20241206	Premium	99.00	2	99.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
83	83	126	20230724	20240723	Standard	49.00	1	49.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
84	84	283	20210707	20220707	Premium	99.00	2	1188.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
85	85	68	20220913	20230913	Entreprise	199.00	3	299.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
86	86	300	20230905	20240904	Entreprise	199.00	3	1794.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
87	87	164	20210530	20220530	Entreprise	199.00	3	299.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
88	88	43	20220209	20230209	Premium	99.00	2	99.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
89	89	250	20210120	20220120	Premium	99.00	2	1188.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
90	90	227	20220203	20230203	Entreprise	199.00	3	3588.00	365	Chèque	Annulé	0	1	0	2026-05-22 23:28:36.880998
91	91	1	20230414	20240413	Premium	99.00	2	1188.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
92	92	169	20230917	20240916	Entreprise	199.00	3	3588.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
93	93	136	20220525	20230525	Entreprise	199.00	3	1794.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
94	94	226	20220109	20230109	Standard	49.00	1	294.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
95	95	254	20220102	20230102	Standard	49.00	1	49.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
96	96	49	20221203	20231203	Premium	99.00	2	1188.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
97	97	100	20220420	20230420	Standard	49.00	1	49.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
98	98	164	20230825	20240824	Entreprise	199.00	3	299.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
99	99	293	20211113	20221113	Entreprise	199.00	3	1794.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
100	100	88	20211118	20221118	Standard	49.00	1	294.00	365	Chèque	Remboursé	0	1	0	2026-05-22 23:28:36.880998
101	101	214	20220706	20230706	Entreprise	199.00	3	299.00	365	Chèque	Annulé	0	1	0	2026-05-22 23:28:36.880998
102	102	156	20211024	20221024	Premium	99.00	2	594.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
103	103	162	20220923	20230923	Premium	99.00	2	594.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
104	104	3	20210424	20220424	Premium	99.00	2	594.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
105	105	234	20210209	20220209	Premium	99.00	2	1188.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
106	106	151	20210218	20220218	Premium	99.00	2	594.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
107	107	167	20220213	20230213	Entreprise	199.00	3	299.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
108	108	141	20210602	20220602	Standard	49.00	1	49.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
109	109	241	20230310	20240309	Standard	49.00	1	588.00	365	Chèque	Remboursé	0	1	0	2026-05-22 23:28:36.880998
110	110	128	20230208	20240208	Premium	99.00	2	99.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
111	111	142	20230127	20240127	Entreprise	199.00	3	1794.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
112	112	242	20210601	20220601	Standard	49.00	1	294.00	365	Chèque	Remboursé	0	1	0	2026-05-22 23:28:36.880998
113	113	78	20220905	20230905	Standard	49.00	1	588.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
114	114	225	20221103	20231103	Standard	49.00	1	588.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
115	115	286	20220820	20230820	Entreprise	199.00	3	3588.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
116	116	161	20230703	20240702	Premium	99.00	2	1188.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
117	117	165	20220412	20230412	Premium	99.00	2	594.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
118	118	133	20210217	20220217	Premium	99.00	2	99.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
119	119	219	20230924	20240923	Premium	99.00	2	99.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
120	120	263	20210203	20220203	Premium	99.00	2	1188.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
121	121	259	20231005	20241004	Premium	99.00	2	594.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
122	122	39	20210708	20220708	Entreprise	199.00	3	3588.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
123	123	263	20230818	20240817	Standard	49.00	1	588.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
124	124	38	20230602	20240601	Entreprise	199.00	3	1794.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
125	125	170	20220108	20230108	Standard	49.00	1	588.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
126	126	271	20230605	20240604	Entreprise	199.00	3	299.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
127	127	4	20230310	20240309	Entreprise	199.00	3	299.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
128	128	219	20220615	20230615	Standard	49.00	1	49.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
129	129	273	20220215	20230215	Premium	99.00	2	1188.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
130	130	97	20220227	20230227	Standard	49.00	1	294.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
131	131	274	20210322	20220322	Entreprise	199.00	3	299.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
132	132	168	20220417	20230417	Premium	99.00	2	1188.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
133	133	84	20220710	20230710	Premium	99.00	2	99.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
134	134	182	20211009	20221009	Standard	49.00	1	294.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
135	135	14	20220304	20230304	Premium	99.00	2	594.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
136	136	205	20220226	20230226	Standard	49.00	1	294.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
137	137	48	20231104	20241103	Standard	49.00	1	588.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
138	138	84	20210904	20220904	Standard	49.00	1	294.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
139	139	163	20220127	20230127	Premium	99.00	2	99.00	365	PayPal	Remboursé	0	1	0	2026-05-22 23:28:36.880998
140	140	245	20231108	20241107	Premium	99.00	2	99.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
141	141	4	20230511	20240510	Premium	99.00	2	594.00	365	Carte	Remboursé	0	1	0	2026-05-22 23:28:36.880998
142	142	182	20220927	20230927	Premium	99.00	2	99.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
143	143	118	20210622	20220622	Entreprise	199.00	3	3588.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
144	144	242	20220717	20230717	Standard	49.00	1	588.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
145	145	24	20220525	20230525	Standard	49.00	1	49.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
146	146	266	20211015	20221015	Standard	49.00	1	588.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
147	147	32	20220306	20230306	Entreprise	199.00	3	3588.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
148	148	213	20230509	20240508	Standard	49.00	1	49.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
149	149	93	20210813	20220813	Premium	99.00	2	99.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
150	150	157	20230204	20240204	Premium	99.00	2	594.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
151	151	14	20210228	20220228	Premium	99.00	2	594.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
152	152	209	20230212	20240212	Standard	49.00	1	588.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
153	153	81	20210131	20220131	Standard	49.00	1	294.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
154	154	215	20210819	20220819	Standard	49.00	1	294.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
155	155	275	20211003	20221003	Premium	99.00	2	1188.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
156	156	160	20230820	20240819	Premium	99.00	2	594.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
157	157	50	20231007	20241006	Premium	99.00	2	1188.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
158	158	65	20231121	20241120	Standard	49.00	1	49.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
159	159	116	20210618	20220618	Entreprise	199.00	3	3588.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
160	160	145	20210804	20220804	Entreprise	199.00	3	299.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
161	161	155	20230805	20240804	Premium	99.00	2	1188.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
162	162	68	20230515	20240514	Premium	99.00	2	594.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
163	163	198	20210409	20220409	Entreprise	199.00	3	299.00	365	Carte	Remboursé	0	1	0	2026-05-22 23:28:36.880998
164	164	74	20210311	20220311	Entreprise	199.00	3	299.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
165	165	6	20230912	20240911	Entreprise	199.00	3	1794.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
166	166	296	20230715	20240714	Premium	99.00	2	99.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
167	167	280	20210830	20220830	Premium	99.00	2	1188.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
168	168	173	20220607	20230607	Standard	49.00	1	294.00	365	Chèque	Annulé	0	1	0	2026-05-22 23:28:36.880998
169	169	282	20210717	20220717	Premium	99.00	2	1188.00	365	PayPal	Annulé	0	1	0	2026-05-22 23:28:36.880998
170	170	33	20230524	20240523	Premium	99.00	2	1188.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
171	171	49	20230726	20240725	Standard	49.00	1	49.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
172	172	65	20220921	20230921	Premium	99.00	2	594.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
173	173	259	20230326	20240325	Standard	49.00	1	588.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
174	174	9	20221226	20231226	Standard	49.00	1	588.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
175	175	289	20231212	20241211	Entreprise	199.00	3	299.00	365	PayPal	Annulé	0	1	0	2026-05-22 23:28:36.880998
176	176	277	20231224	20241223	Standard	49.00	1	49.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
177	177	85	20220409	20230409	Entreprise	199.00	3	3588.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
178	178	104	20210411	20220411	Premium	99.00	2	594.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
179	179	244	20221022	20231022	Premium	99.00	2	99.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
180	180	1	20220530	20230530	Standard	49.00	1	588.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
181	181	107	20210517	20220517	Entreprise	199.00	3	299.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
182	182	74	20211125	20221125	Premium	99.00	2	99.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
183	183	215	20220201	20230201	Premium	99.00	2	99.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
184	184	116	20211015	20221015	Premium	99.00	2	594.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
185	185	106	20211019	20221019	Premium	99.00	2	1188.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
186	186	6	20210829	20220829	Entreprise	199.00	3	3588.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
187	187	242	20230617	20240616	Standard	49.00	1	294.00	365	Chèque	Annulé	0	1	0	2026-05-22 23:28:36.880998
188	188	79	20221201	20231201	Standard	49.00	1	294.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
189	189	196	20210820	20220820	Premium	99.00	2	1188.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
190	190	250	20220406	20230406	Premium	99.00	2	1188.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
191	191	124	20231010	20241009	Entreprise	199.00	3	3588.00	365	Chèque	Remboursé	0	1	0	2026-05-22 23:28:36.880998
192	192	30	20210804	20220804	Entreprise	199.00	3	1794.00	365	PayPal	Annulé	0	1	0	2026-05-22 23:28:36.880998
193	193	129	20231107	20241106	Entreprise	199.00	3	1794.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
194	194	183	20210127	20220127	Standard	49.00	1	49.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
195	195	125	20231011	20241010	Entreprise	199.00	3	299.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
196	196	54	20230927	20240926	Entreprise	199.00	3	3588.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
197	197	266	20230223	20240223	Entreprise	199.00	3	299.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
198	198	295	20210829	20220829	Standard	49.00	1	49.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
199	199	202	20210323	20220323	Entreprise	199.00	3	1794.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
200	200	236	20231207	20241206	Entreprise	199.00	3	299.00	365	Chèque	Annulé	0	1	0	2026-05-22 23:28:36.880998
201	201	14	20220106	20230106	Standard	49.00	1	49.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
202	202	51	20230425	20240424	Premium	99.00	2	99.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
203	203	184	20221206	20231206	Entreprise	199.00	3	1794.00	365	Virement	Remboursé	0	1	0	2026-05-22 23:28:36.880998
204	204	142	20210408	20220408	Premium	99.00	2	594.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
205	205	83	20221022	20231022	Standard	49.00	1	588.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
206	206	89	20210702	20220702	Premium	99.00	2	594.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
207	207	163	20210727	20220727	Premium	99.00	2	1188.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
208	208	161	20231016	20241015	Entreprise	199.00	3	3588.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
209	209	104	20230922	20240921	Premium	99.00	2	594.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
210	210	186	20211212	20221212	Standard	49.00	1	294.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
211	211	298	20231103	20241102	Premium	99.00	2	1188.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
212	212	287	20211231	20221231	Entreprise	199.00	3	1794.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
213	213	102	20210705	20220705	Standard	49.00	1	588.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
214	214	135	20221128	20231128	Standard	49.00	1	588.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
215	215	198	20220825	20230825	Standard	49.00	1	588.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
216	216	166	20230626	20240625	Standard	49.00	1	49.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
217	217	141	20231010	20241009	Standard	49.00	1	49.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
218	218	126	20230621	20240620	Standard	49.00	1	588.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
219	219	7	20220515	20230515	Premium	99.00	2	99.00	365	Chèque	Annulé	0	1	0	2026-05-22 23:28:36.880998
220	220	225	20220129	20230129	Premium	99.00	2	594.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
221	221	295	20220620	20230620	Premium	99.00	2	1188.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
222	222	135	20230129	20240129	Premium	99.00	2	594.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
223	223	164	20230102	20240102	Entreprise	199.00	3	299.00	365	Virement	Remboursé	0	1	0	2026-05-22 23:28:36.880998
224	224	165	20220521	20230521	Entreprise	199.00	3	3588.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
225	225	260	20230902	20240901	Entreprise	199.00	3	3588.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
226	226	179	20220404	20230404	Entreprise	199.00	3	1794.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
227	227	236	20230616	20240615	Entreprise	199.00	3	1794.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
228	228	88	20230708	20240707	Standard	49.00	1	588.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
229	229	245	20211030	20221030	Entreprise	199.00	3	299.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
230	230	142	20220601	20230601	Entreprise	199.00	3	3588.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
231	231	221	20211001	20221001	Entreprise	199.00	3	1794.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
232	232	159	20220916	20230916	Entreprise	199.00	3	1794.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
233	233	74	20221007	20231007	Entreprise	199.00	3	299.00	365	Carte	Remboursé	0	1	0	2026-05-22 23:28:36.880998
234	234	184	20210903	20220903	Entreprise	199.00	3	299.00	365	Chèque	Expiré	0	1	0	2026-05-22 23:28:36.880998
235	235	83	20220203	20230203	Entreprise	199.00	3	299.00	365	Virement	Remboursé	0	1	0	2026-05-22 23:28:36.880998
236	236	93	20231011	20241010	Standard	49.00	1	588.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
237	237	49	20230305	20240304	Premium	99.00	2	594.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
238	238	71	20220110	20230110	Premium	99.00	2	99.00	365	Virement	Actif	1	0	0	2026-05-22 23:28:36.880998
239	239	221	20231021	20241020	Premium	99.00	2	99.00	365	Chèque	Actif	1	0	0	2026-05-22 23:28:36.880998
240	240	103	20221221	20231221	Standard	49.00	1	588.00	365	PayPal	Expiré	0	1	0	2026-05-22 23:28:36.880998
241	241	232	20231209	20241208	Standard	49.00	1	294.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
242	242	286	20230204	20240204	Standard	49.00	1	49.00	365	Carte	Actif	1	0	0	2026-05-22 23:28:36.880998
243	243	3	20230227	20240227	Premium	99.00	2	594.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
244	244	36	20220122	20230122	Standard	49.00	1	588.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
245	245	275	20221209	20231209	Standard	49.00	1	49.00	365	Virement	Annulé	0	1	0	2026-05-22 23:28:36.880998
246	246	192	20211229	20221229	Entreprise	199.00	3	1794.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
247	247	260	20230701	20240630	Standard	49.00	1	49.00	365	Carte	Expiré	0	1	0	2026-05-22 23:28:36.880998
248	248	160	20210809	20220809	Premium	99.00	2	594.00	365	Virement	Expiré	0	1	0	2026-05-22 23:28:36.880998
249	249	52	20220131	20230131	Premium	99.00	2	1188.00	365	PayPal	Actif	1	0	0	2026-05-22 23:28:36.880998
250	250	233	20230308	20240307	Entreprise	199.00	3	1794.00	365	Carte	Annulé	0	1	0	2026-05-22 23:28:36.880998
\.


--
-- Data for Name: fact_support; Type: TABLE DATA; Schema: technova_dw; Owner: -
--

COPY technova_dw.fact_support (ticket_sk, ticket_id, user_sk, date_creation_sk, date_resolution_sk, categorie, priorite, sla_heures, est_critique, resolution_heures, csat_score, est_resolu, est_sla_respecte, statut, etl_loaded_at) FROM stdin;
75	71	41	20220630	20220711	Bug	Basse	72.0	0	264.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
1	251	185	20220106	20220110	Sécurité	Moyenne	8.0	0	96.0	5	1	0	Résolu	2026-05-22 23:28:36.880998
2	106	19	20220115	20220127	Performance	Moyenne	24.0	0	288.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
3	285	127	20220801	20220802	Facturation	Haute	12.0	0	24.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
4	120	297	20240909	20240912	Facturation	Critique	4.0	1	72.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
5	264	159	20220906	20220907	Bug	Basse	72.0	0	24.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
6	209	13	20220202	20220209	Fonctionnalité	Haute	16.0	0	168.0	2	1	0	Résolu	2026-05-22 23:28:36.880998
7	276	20	20221008	20221017	Bug	Basse	72.0	0	216.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
8	151	255	20241211	20241223	Autre	Moyenne	48.0	0	288.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
9	253	101	20240720	20240808	Autre	Basse	96.0	0	456.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
10	119	62	20220819	20220822	Fonctionnalité	Haute	16.0	0	72.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
11	270	54	20240917	20241006	Performance	Haute	8.0	0	456.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
12	268	45	20221125	20221212	Performance	Haute	8.0	0	408.0	5	1	1	Fermé	2026-05-22 23:28:36.880998
13	214	263	20240908	20240911	Bug	Basse	72.0	0	72.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
14	101	206	20240321	20240326	Sécurité	Moyenne	8.0	0	120.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
15	20	118	20220519	20220527	Fonctionnalité	Haute	16.0	0	192.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
16	82	158	20240528	20240617	Facturation	Moyenne	24.0	0	480.0	2	0	0	En cours	2026-05-22 23:28:36.880998
17	25	13	20241218	20241228	Bug	Basse	72.0	0	240.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
18	213	180	20240606	20240609	Fonctionnalité	Basse	96.0	0	72.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
19	26	281	20220514	20220528	Bug	Haute	8.0	0	336.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
20	137	13	20230301	20230307	Bug	Haute	8.0	0	144.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
21	265	139	20231123	20231127	Bug	Moyenne	24.0	0	96.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
22	292	112	20230307	20230311	Bug	Moyenne	24.0	0	96.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
23	168	33	20230710	20230720	Autre	Haute	16.0	0	240.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
24	136	157	20230305	20230323	Fonctionnalité	Haute	16.0	0	432.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
25	218	64	20241118	20241120	Fonctionnalité	Moyenne	48.0	0	48.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
26	196	48	20230607	20230622	Facturation	Critique	4.0	1	360.0	2	0	0	En cours	2026-05-22 23:28:36.880998
27	238	1	20241001	20241005	Performance	Basse	72.0	0	96.0	3	0	0	En cours	2026-05-22 23:28:36.880998
28	27	87	20220801	20220809	Facturation	Critique	4.0	1	192.0	1	0	0	Ouvert	2026-05-22 23:28:36.880998
29	230	215	20221129	20221219	Facturation	Critique	4.0	1	480.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
30	149	193	20231128	20231217	Facturation	Haute	12.0	0	456.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
31	93	74	20240513	20240516	Bug	Critique	4.0	1	72.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
32	191	119	20220219	20220310	Sécurité	Basse	24.0	0	456.0	1	0	0	En cours	2026-05-22 23:28:36.880998
33	295	75	20230513	20230529	Fonctionnalité	Moyenne	48.0	0	384.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
34	11	8	20220827	20220906	Fonctionnalité	Haute	16.0	0	240.0	2	0	0	Ouvert	2026-05-22 23:28:36.880998
35	228	27	20221031	20221118	Facturation	Haute	12.0	0	432.0	2	0	0	En cours	2026-05-22 23:28:36.880998
36	135	80	20241030	20241103	Autre	Critique	8.0	1	96.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
37	252	104	20241031	20241109	Performance	Haute	8.0	0	216.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
38	39	283	20241125	20241209	Autre	Moyenne	48.0	0	336.0	4	0	0	En cours	2026-05-22 23:28:36.880998
39	131	294	20240322	20240325	Performance	Basse	72.0	0	72.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
40	178	186	20230723	20230727	Bug	Basse	72.0	0	96.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
41	255	243	20230418	20230429	Fonctionnalité	Basse	96.0	0	264.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
42	241	84	20241108	20241118	Fonctionnalité	Moyenne	48.0	0	240.0	4	0	0	En cours	2026-05-22 23:28:36.880998
43	17	35	20230610	20230623	Sécurité	Haute	4.0	0	312.0	3	0	0	En cours	2026-05-22 23:28:36.880998
44	142	20	20220708	20220711	Bug	Moyenne	24.0	0	72.0	1	0	0	En cours	2026-05-22 23:28:36.880998
45	66	41	20230123	20230127	Performance	Haute	8.0	0	96.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
46	160	245	20240426	20240508	Sécurité	Haute	4.0	0	288.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
47	89	142	20220501	20220517	Facturation	Basse	48.0	0	384.0	1	0	0	En cours	2026-05-22 23:28:36.880998
48	284	241	20230626	20230702	Fonctionnalité	Moyenne	48.0	0	144.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
49	33	22	20230410	20230423	Fonctionnalité	Moyenne	48.0	0	312.0	3	0	0	En cours	2026-05-22 23:28:36.880998
50	109	202	20220301	20220316	Autre	Haute	16.0	0	360.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
51	57	193	20240519	20240602	Facturation	Basse	48.0	0	336.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
52	239	270	20220514	20220529	Sécurité	Haute	4.0	0	360.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
53	288	177	20240422	20240511	Fonctionnalité	Basse	96.0	0	456.0	2	0	0	En cours	2026-05-22 23:28:36.880998
54	31	246	20240108	20240116	Fonctionnalité	Moyenne	48.0	0	192.0	2	0	0	En cours	2026-05-22 23:28:36.880998
55	34	107	20240801	20240816	Fonctionnalité	Basse	96.0	0	360.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
56	296	224	20240807	20240813	Facturation	Critique	4.0	1	144.0	1	0	0	Ouvert	2026-05-22 23:28:36.880998
57	12	170	20240201	20240214	Fonctionnalité	Basse	96.0	0	312.0	2	0	0	Ouvert	2026-05-22 23:28:36.880998
58	282	207	20240510	20240513	Facturation	Basse	48.0	0	72.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
59	10	114	20241011	20241018	Bug	Moyenne	24.0	0	168.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
60	18	146	20240319	20240326	Bug	Moyenne	24.0	0	168.0	5	1	1	Fermé	2026-05-22 23:28:36.880998
61	146	275	20241124	20241210	Facturation	Moyenne	24.0	0	384.0	4	0	0	En cours	2026-05-22 23:28:36.880998
62	139	154	20230915	20230929	Fonctionnalité	Moyenne	48.0	0	336.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
63	143	233	20240819	20240821	Autre	Haute	16.0	0	48.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
64	98	18	20220322	20220408	Facturation	Moyenne	24.0	0	408.0	2	0	0	Ouvert	2026-05-22 23:28:36.880998
65	193	229	20231215	20231223	Bug	Moyenne	24.0	0	192.0	3	0	0	En cours	2026-05-22 23:28:36.880998
66	243	19	20220830	20220904	Bug	Moyenne	24.0	0	120.0	4	0	0	En cours	2026-05-22 23:28:36.880998
67	167	294	20240929	20241010	Fonctionnalité	Haute	16.0	0	264.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
68	250	123	20230105	20230119	Facturation	Basse	48.0	0	336.0	1	0	0	Ouvert	2026-05-22 23:28:36.880998
69	64	108	20231019	20231105	Autre	Critique	8.0	1	408.0	2	0	0	En cours	2026-05-22 23:28:36.880998
70	145	260	20240806	20240815	Bug	Moyenne	24.0	0	216.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
71	198	48	20221227	20230106	Sécurité	Moyenne	8.0	0	240.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
72	104	120	20231024	20231106	Performance	Moyenne	24.0	0	312.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
73	163	209	20230813	20230829	Performance	Moyenne	24.0	0	384.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
74	102	107	20230619	20230627	Performance	Haute	8.0	0	192.0	5	0	0	En cours	2026-05-22 23:28:36.880998
76	2	184	20220722	20220808	Fonctionnalité	Basse	96.0	0	408.0	3	0	0	Ouvert	2026-05-22 23:28:36.880998
77	72	34	20240712	20240724	Autre	Basse	96.0	0	288.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
78	234	173	20240211	20240214	Sécurité	Haute	4.0	0	72.0	1	0	0	En cours	2026-05-22 23:28:36.880998
79	186	229	20220617	20220701	Performance	Haute	8.0	0	336.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
80	177	251	20231004	20231008	Fonctionnalité	Moyenne	48.0	0	96.0	1	0	0	En cours	2026-05-22 23:28:36.880998
81	280	94	20230420	20230422	Sécurité	Basse	24.0	0	48.0	5	0	0	En cours	2026-05-22 23:28:36.880998
82	297	235	20230812	20230817	Performance	Moyenne	24.0	0	120.0	2	0	0	En cours	2026-05-22 23:28:36.880998
83	274	267	20241009	20241027	Sécurité	Haute	4.0	0	432.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
84	47	283	20230526	20230530	Autre	Basse	96.0	0	96.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
85	211	225	20240810	20240822	Fonctionnalité	Moyenne	48.0	0	288.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
86	46	82	20241226	20250115	Performance	Moyenne	24.0	0	480.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
87	83	272	20220920	20221002	Facturation	Moyenne	24.0	0	288.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
88	15	250	20240320	20240322	Sécurité	Critique	2.0	1	48.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
89	125	287	20220407	20220417	Performance	Moyenne	24.0	0	240.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
90	77	89	20230321	20230325	Sécurité	Basse	24.0	0	96.0	4	0	0	Ouvert	2026-05-22 23:28:36.880998
91	140	22	20231221	20231222	Bug	Moyenne	24.0	0	24.0	4	0	0	En cours	2026-05-22 23:28:36.880998
92	153	184	20230514	20230519	Fonctionnalité	Moyenne	48.0	0	120.0	2	0	0	En cours	2026-05-22 23:28:36.880998
93	73	190	20231004	20231022	Facturation	Moyenne	24.0	0	432.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
94	182	163	20240224	20240302	Performance	Basse	72.0	0	168.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
95	56	10	20240820	20240902	Fonctionnalité	Haute	16.0	0	312.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
96	40	13	20221219	20221228	Fonctionnalité	Moyenne	48.0	0	216.0	5	1	1	Fermé	2026-05-22 23:28:36.880998
97	277	144	20241223	20250104	Fonctionnalité	Basse	96.0	0	288.0	3	0	0	Ouvert	2026-05-22 23:28:36.880998
98	261	288	20230215	20230216	Performance	Moyenne	24.0	0	24.0	1	1	0	Résolu	2026-05-22 23:28:36.880998
99	123	145	20220219	20220228	Performance	Basse	72.0	0	216.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
100	189	227	20220608	20220628	Facturation	Haute	12.0	0	480.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
101	233	110	20230810	20230818	Fonctionnalité	Basse	96.0	0	192.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
102	226	267	20230518	20230526	Sécurité	Moyenne	8.0	0	192.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
103	13	127	20230927	20231004	Fonctionnalité	Moyenne	48.0	0	168.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
104	91	161	20220904	20220914	Autre	Haute	16.0	0	240.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
105	293	212	20221023	20221028	Facturation	Haute	12.0	0	120.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
106	287	253	20240306	20240313	Bug	Moyenne	24.0	0	168.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
107	165	144	20231201	20231211	Autre	Basse	96.0	0	240.0	5	1	1	Fermé	2026-05-22 23:28:36.880998
108	21	225	20220326	20220412	Fonctionnalité	Moyenne	48.0	0	408.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
109	152	215	20240514	20240517	Bug	Haute	8.0	0	72.0	3	0	0	Ouvert	2026-05-22 23:28:36.880998
110	281	278	20230901	20230919	Autre	Moyenne	48.0	0	432.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
111	5	165	20241016	20241026	Sécurité	Moyenne	8.0	0	240.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
112	181	113	20230430	20230505	Sécurité	Moyenne	8.0	0	120.0	5	0	0	Ouvert	2026-05-22 23:28:36.880998
113	298	219	20241220	20241223	Fonctionnalité	Moyenne	48.0	0	72.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
114	254	234	20240414	20240503	Facturation	Haute	12.0	0	456.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
115	112	291	20230927	20230928	Performance	Moyenne	24.0	0	24.0	2	0	0	En cours	2026-05-22 23:28:36.880998
116	96	166	20231031	20231118	Bug	Critique	4.0	1	432.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
117	107	189	20220116	20220205	Fonctionnalité	Haute	16.0	0	480.0	5	0	0	En cours	2026-05-22 23:28:36.880998
118	221	202	20220125	20220130	Bug	Critique	4.0	1	120.0	5	0	0	En cours	2026-05-22 23:28:36.880998
119	258	123	20220605	20220614	Bug	Moyenne	24.0	0	216.0	5	1	0	Résolu	2026-05-22 23:28:36.880998
120	108	192	20230609	20230620	Performance	Basse	72.0	0	264.0	3	0	0	En cours	2026-05-22 23:28:36.880998
121	19	255	20220315	20220331	Performance	Moyenne	24.0	0	384.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
122	215	159	20221026	20221113	Bug	Basse	72.0	0	432.0	1	0	0	En cours	2026-05-22 23:28:36.880998
123	65	254	20220506	20220521	Fonctionnalité	Haute	16.0	0	360.0	1	0	0	En cours	2026-05-22 23:28:36.880998
124	52	182	20240505	20240511	Bug	Moyenne	24.0	0	144.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
125	37	281	20230314	20230327	Facturation	Moyenne	24.0	0	312.0	1	0	0	En cours	2026-05-22 23:28:36.880998
126	85	161	20231110	20231117	Facturation	Moyenne	24.0	0	168.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
127	32	199	20220212	20220226	Performance	Moyenne	24.0	0	336.0	2	1	0	Fermé	2026-05-22 23:28:36.880998
128	164	16	20221026	20221028	Bug	Moyenne	24.0	0	48.0	4	1	0	Résolu	2026-05-22 23:28:36.880998
129	78	77	20241015	20241028	Facturation	Haute	12.0	0	312.0	5	0	0	En cours	2026-05-22 23:28:36.880998
130	278	154	20230807	20230818	Bug	Critique	4.0	1	264.0	1	0	0	En cours	2026-05-22 23:28:36.880998
131	289	64	20241016	20241017	Facturation	Moyenne	24.0	0	24.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
132	133	117	20240204	20240222	Fonctionnalité	Haute	16.0	0	432.0	5	1	1	Fermé	2026-05-22 23:28:36.880998
133	279	71	20230626	20230707	Facturation	Haute	12.0	0	264.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
134	100	48	20240425	20240506	Facturation	Haute	12.0	0	264.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
135	232	171	20240923	20241009	Bug	Haute	8.0	0	384.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
136	158	110	20240907	20240914	Autre	Moyenne	48.0	0	168.0	4	0	0	Ouvert	2026-05-22 23:28:36.880998
137	172	267	20230820	20230828	Bug	Moyenne	24.0	0	192.0	3	0	0	En cours	2026-05-22 23:28:36.880998
138	113	171	20240306	20240317	Fonctionnalité	Basse	96.0	0	264.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
139	184	209	20221206	20221212	Performance	Moyenne	24.0	0	144.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
140	24	259	20230203	20230214	Performance	Haute	8.0	0	264.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
141	170	266	20240518	20240525	Facturation	Haute	12.0	0	168.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
142	55	235	20220925	20221015	Facturation	Moyenne	24.0	0	480.0	5	0	0	Ouvert	2026-05-22 23:28:36.880998
143	68	152	20230323	20230406	Sécurité	Moyenne	8.0	0	336.0	3	0	0	En cours	2026-05-22 23:28:36.880998
144	244	65	20231113	20231124	Autre	Critique	8.0	1	264.0	4	1	0	Résolu	2026-05-22 23:28:36.880998
145	128	240	20241009	20241027	Facturation	Haute	12.0	0	432.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
146	38	278	20240424	20240426	Facturation	Basse	48.0	0	48.0	3	0	0	En cours	2026-05-22 23:28:36.880998
147	300	83	20221001	20221002	Performance	Moyenne	24.0	0	24.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
148	256	231	20220321	20220329	Facturation	Basse	48.0	0	192.0	5	1	0	Résolu	2026-05-22 23:28:36.880998
149	216	261	20220219	20220306	Autre	Moyenne	48.0	0	360.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
150	202	11	20220410	20220426	Fonctionnalité	Haute	16.0	0	384.0	2	0	0	En cours	2026-05-22 23:28:36.880998
151	266	239	20230724	20230727	Fonctionnalité	Moyenne	48.0	0	72.0	1	1	0	Résolu	2026-05-22 23:28:36.880998
152	195	19	20230414	20230417	Facturation	Critique	4.0	1	72.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
153	129	45	20240105	20240120	Performance	Haute	8.0	0	360.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
154	8	198	20220418	20220502	Facturation	Basse	48.0	0	336.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
155	80	250	20220518	20220529	Facturation	Basse	48.0	0	264.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
156	179	66	20230224	20230226	Autre	Moyenne	48.0	0	48.0	5	1	1	Fermé	2026-05-22 23:28:36.880998
157	110	208	20240304	20240308	Performance	Haute	8.0	0	96.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
158	175	282	20230606	20230622	Bug	Critique	4.0	1	384.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
159	99	255	20220729	20220815	Bug	Haute	8.0	0	408.0	2	0	0	En cours	2026-05-22 23:28:36.880998
160	48	228	20240220	20240307	Bug	Haute	8.0	0	384.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
161	28	289	20220903	20220911	Fonctionnalité	Moyenne	48.0	0	192.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
162	262	169	20220923	20221002	Fonctionnalité	Critique	4.0	1	216.0	3	0	0	En cours	2026-05-22 23:28:36.880998
163	94	229	20240628	20240709	Sécurité	Haute	4.0	0	264.0	3	0	0	En cours	2026-05-22 23:28:36.880998
164	204	128	20220328	20220331	Autre	Moyenne	48.0	0	72.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
165	162	201	20230406	20230411	Sécurité	Basse	24.0	0	120.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
166	30	199	20241001	20241021	Autre	Haute	16.0	0	480.0	4	0	0	En cours	2026-05-22 23:28:36.880998
167	299	156	20230719	20230804	Fonctionnalité	Haute	16.0	0	384.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
168	95	234	20240717	20240727	Performance	Moyenne	24.0	0	240.0	2	0	0	En cours	2026-05-22 23:28:36.880998
169	122	212	20220401	20220404	Bug	Moyenne	24.0	0	72.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
170	62	236	20220907	20220909	Autre	Haute	16.0	0	48.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
171	180	31	20230722	20230801	Bug	Haute	8.0	0	240.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
172	127	75	20240413	20240419	Autre	Moyenne	48.0	0	144.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
173	117	98	20220605	20220614	Autre	Basse	96.0	0	216.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
174	185	55	20240610	20240629	Performance	Moyenne	24.0	0	456.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
175	286	87	20241207	20241216	Fonctionnalité	Critique	4.0	1	216.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
176	155	95	20230421	20230428	Bug	Moyenne	24.0	0	168.0	2	0	0	En cours	2026-05-22 23:28:36.880998
177	97	162	20240608	20240619	Sécurité	Critique	2.0	1	264.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
178	205	1	20240930	20241013	Fonctionnalité	Moyenne	48.0	0	312.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
179	197	224	20231001	20231007	Performance	Haute	8.0	0	144.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
180	187	77	20220217	20220307	Sécurité	Moyenne	8.0	0	432.0	2	1	0	Résolu	2026-05-22 23:28:36.880998
181	114	85	20230808	20230816	Fonctionnalité	Moyenne	48.0	0	192.0	1	0	0	Ouvert	2026-05-22 23:28:36.880998
182	156	201	20220125	20220129	Facturation	Critique	4.0	1	96.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
183	269	100	20231128	20231211	Autre	Moyenne	48.0	0	312.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
184	249	129	20231117	20231122	Bug	Moyenne	24.0	0	120.0	2	0	0	Ouvert	2026-05-22 23:28:36.880998
185	194	246	20241125	20241215	Performance	Haute	8.0	0	480.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
186	126	189	20240204	20240216	Fonctionnalité	Moyenne	48.0	0	288.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
187	132	257	20220109	20220118	Sécurité	Haute	4.0	0	216.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
188	67	97	20230412	20230418	Facturation	Moyenne	24.0	0	144.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
189	224	253	20231203	20231223	Bug	Moyenne	24.0	0	480.0	3	1	0	Résolu	2026-05-22 23:28:36.880998
190	50	291	20240128	20240131	Facturation	Basse	48.0	0	72.0	5	0	0	En cours	2026-05-22 23:28:36.880998
191	51	154	20230208	20230219	Performance	Haute	8.0	0	264.0	1	0	0	En cours	2026-05-22 23:28:36.880998
192	76	72	20221102	20221115	Fonctionnalité	Basse	96.0	0	312.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
193	69	124	20230531	20230610	Autre	Basse	96.0	0	240.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
194	203	124	20240805	20240813	Sécurité	Moyenne	8.0	0	192.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
195	219	290	20240213	20240224	Performance	Basse	72.0	0	264.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
196	81	149	20241009	20241016	Performance	Moyenne	24.0	0	168.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
197	273	174	20231008	20231023	Autre	Basse	96.0	0	360.0	1	0	0	Ouvert	2026-05-22 23:28:36.880998
198	79	143	20241019	20241102	Performance	Moyenne	24.0	0	336.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
199	42	126	20241222	20241224	Fonctionnalité	Haute	16.0	0	48.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
200	90	168	20221027	20221105	Sécurité	Moyenne	8.0	0	216.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
201	134	202	20240415	20240419	Sécurité	Moyenne	8.0	0	96.0	4	0	0	En cours	2026-05-22 23:28:36.880998
202	59	44	20220217	20220222	Sécurité	Basse	24.0	0	120.0	1	1	0	Fermé	2026-05-22 23:28:36.880998
203	192	232	20240107	20240120	Fonctionnalité	Moyenne	48.0	0	312.0	4	0	0	Ouvert	2026-05-22 23:28:36.880998
204	271	117	20240304	20240315	Sécurité	Moyenne	8.0	0	264.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
205	116	228	20221123	20221127	Autre	Moyenne	48.0	0	96.0	2	0	0	Ouvert	2026-05-22 23:28:36.880998
206	235	5	20220709	20220714	Sécurité	Moyenne	8.0	0	120.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
207	248	217	20230112	20230113	Sécurité	Basse	24.0	0	24.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
208	84	33	20230520	20230527	Fonctionnalité	Moyenne	48.0	0	168.0	2	1	0	Fermé	2026-05-22 23:28:36.880998
209	207	129	20241020	20241025	Performance	Moyenne	24.0	0	120.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
210	74	117	20240419	20240504	Bug	Moyenne	24.0	0	360.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
211	6	271	20230921	20231010	Performance	Basse	72.0	0	456.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
212	246	187	20220516	20220518	Fonctionnalité	Haute	16.0	0	48.0	3	0	0	Ouvert	2026-05-22 23:28:36.880998
213	29	289	20240902	20240921	Bug	Moyenne	24.0	0	456.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
214	159	284	20241110	20241115	Performance	Moyenne	24.0	0	120.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
215	267	181	20230528	20230529	Fonctionnalité	Basse	96.0	0	24.0	5	1	1	Fermé	2026-05-22 23:28:36.880998
216	41	80	20230210	20230215	Sécurité	Moyenne	8.0	0	120.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
217	141	197	20231220	20240105	Fonctionnalité	Moyenne	48.0	0	384.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
218	171	152	20231020	20231027	Autre	Moyenne	48.0	0	168.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
219	227	248	20230908	20230924	Facturation	Basse	48.0	0	384.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
220	247	200	20240325	20240405	Fonctionnalité	Moyenne	48.0	0	264.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
221	242	215	20230308	20230316	Facturation	Moyenne	24.0	0	192.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
222	138	35	20240514	20240526	Fonctionnalité	Basse	96.0	0	288.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
223	190	87	20231225	20240107	Performance	Haute	8.0	0	312.0	3	0	0	En cours	2026-05-22 23:28:36.880998
224	16	66	20220825	20220831	Bug	Moyenne	24.0	0	144.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
225	54	27	20240708	20240722	Autre	Haute	16.0	0	336.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
226	103	13	20230407	20230423	Autre	Basse	96.0	0	384.0	2	0	0	Ouvert	2026-05-22 23:28:36.880998
227	115	1	20220123	20220201	Sécurité	Critique	2.0	1	216.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
228	236	242	20240122	20240203	Bug	Haute	8.0	0	288.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
229	148	40	20220112	20220125	Fonctionnalité	Moyenne	48.0	0	312.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
230	208	38	20240424	20240507	Facturation	Haute	12.0	0	312.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
231	294	189	20241128	20241207	Fonctionnalité	Moyenne	48.0	0	216.0	2	1	0	Résolu	2026-05-22 23:28:36.880998
232	36	126	20230203	20230223	Autre	Haute	16.0	0	480.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
233	174	276	20220528	20220606	Performance	Haute	8.0	0	216.0	4	0	0	En cours	2026-05-22 23:28:36.880998
234	4	150	20220618	20220704	Fonctionnalité	Moyenne	48.0	0	384.0	1	0	0	Ouvert	2026-05-22 23:28:36.880998
235	257	131	20230415	20230417	Facturation	Critique	4.0	1	48.0	4	0	0	En cours	2026-05-22 23:28:36.880998
236	200	52	20240805	20240823	Performance	Moyenne	24.0	0	432.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
237	53	99	20220218	20220306	Sécurité	Basse	24.0	0	384.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
238	222	100	20230607	20230614	Performance	Moyenne	24.0	0	168.0	1	0	0	Ouvert	2026-05-22 23:28:36.880998
239	275	62	20231002	20231020	Autre	Haute	16.0	0	432.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
240	92	269	20240516	20240517	Performance	Moyenne	24.0	0	24.0	2	0	0	En cours	2026-05-22 23:28:36.880998
241	23	90	20220426	20220509	Fonctionnalité	Haute	16.0	0	312.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
242	44	183	20230313	20230323	Autre	Haute	16.0	0	240.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
243	58	178	20230731	20230809	Sécurité	Haute	4.0	0	216.0	4	0	0	Ouvert	2026-05-22 23:28:36.880998
244	1	174	20241002	20241009	Facturation	Haute	12.0	0	168.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
245	290	98	20230113	20230201	Autre	Haute	16.0	0	456.0	2	0	0	En cours	2026-05-22 23:28:36.880998
246	206	269	20231226	20240115	Autre	Basse	96.0	0	480.0	4	1	0	Résolu	2026-05-22 23:28:36.880998
247	111	103	20230914	20230926	Autre	Moyenne	48.0	0	288.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
248	237	21	20220321	20220409	Facturation	Haute	12.0	0	456.0	1	0	0	Ouvert	2026-05-22 23:28:36.880998
249	86	294	20230501	20230509	Autre	Moyenne	48.0	0	192.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
250	49	11	20230108	20230123	Fonctionnalité	Moyenne	48.0	0	360.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
251	22	108	20221109	20221120	Bug	Moyenne	24.0	0	264.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
252	70	32	20220504	20220524	Fonctionnalité	Haute	16.0	0	480.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
253	45	162	20221225	20230104	Fonctionnalité	Haute	16.0	0	240.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
254	225	241	20231109	20231120	Sécurité	Moyenne	8.0	0	264.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
255	199	86	20230205	20230225	Bug	Basse	72.0	0	480.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
256	60	125	20221112	20221201	Performance	Moyenne	24.0	0	456.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
257	105	10	20240429	20240517	Fonctionnalité	Critique	4.0	1	432.0	2	0	0	Ouvert	2026-05-22 23:28:36.880998
258	75	207	20221018	20221031	Fonctionnalité	Moyenne	48.0	0	312.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
259	124	121	20220401	20220420	Bug	Basse	72.0	0	456.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
260	229	128	20241101	20241113	Performance	Basse	72.0	0	288.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
261	245	223	20230912	20230919	Bug	Basse	72.0	0	168.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
262	43	44	20220419	20220430	Bug	Basse	72.0	0	264.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
263	220	137	20230207	20230210	Performance	Moyenne	24.0	0	72.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
264	259	214	20230920	20231010	Sécurité	Basse	24.0	0	480.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
265	166	168	20240301	20240320	Fonctionnalité	Moyenne	48.0	0	456.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
266	291	68	20220406	20220409	Performance	Basse	72.0	0	72.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
267	3	270	20230802	20230813	Sécurité	Moyenne	8.0	0	264.0	2	0	0	En cours	2026-05-22 23:28:36.880998
268	201	79	20231029	20231104	Performance	Moyenne	24.0	0	144.0	5	1	1	Résolu	2026-05-22 23:28:36.880998
269	61	39	20231130	20231220	Autre	Critique	8.0	1	480.0	5	0	0	Ouvert	2026-05-22 23:28:36.880998
270	176	299	20230212	20230221	Sécurité	Moyenne	8.0	0	216.0	4	0	0	Ouvert	2026-05-22 23:28:36.880998
271	87	10	20240226	20240302	Sécurité	Basse	24.0	0	120.0	1	1	0	Résolu	2026-05-22 23:28:36.880998
272	169	161	20231215	20231225	Performance	Moyenne	24.0	0	240.0	3	0	0	En cours	2026-05-22 23:28:36.880998
273	14	210	20240212	20240221	Fonctionnalité	Basse	96.0	0	216.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
274	147	151	20231110	20231124	Bug	Haute	8.0	0	336.0	2	0	0	En cours	2026-05-22 23:28:36.880998
275	121	111	20220303	20220305	Fonctionnalité	Moyenne	48.0	0	48.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
276	210	231	20240322	20240330	Autre	Moyenne	48.0	0	192.0	2	0	0	En cours	2026-05-22 23:28:36.880998
277	161	209	20231019	20231101	Fonctionnalité	Critique	4.0	1	312.0	3	0	0	Ouvert	2026-05-22 23:28:36.880998
278	157	300	20221008	20221019	Facturation	Basse	48.0	0	264.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
279	154	45	20240204	20240222	Autre	Haute	16.0	0	432.0	1	0	0	En cours	2026-05-22 23:28:36.880998
280	35	238	20240327	20240401	Facturation	Haute	12.0	0	120.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
281	173	94	20240918	20240927	Facturation	Haute	12.0	0	216.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
282	188	252	20220212	20220228	Sécurité	Haute	4.0	0	384.0	4	1	1	Résolu	2026-05-22 23:28:36.880998
283	150	228	20220928	20221018	Bug	Haute	8.0	0	480.0	4	1	0	Résolu	2026-05-22 23:28:36.880998
284	63	42	20220707	20220708	Bug	Moyenne	24.0	0	24.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
285	183	83	20230707	20230723	Sécurité	Moyenne	8.0	0	384.0	2	0	0	En cours	2026-05-22 23:28:36.880998
286	9	92	20230316	20230320	Autre	Moyenne	48.0	0	96.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
287	260	298	20230812	20230816	Sécurité	Moyenne	8.0	0	96.0	4	1	1	Fermé	2026-05-22 23:28:36.880998
288	118	153	20230623	20230708	Bug	Haute	8.0	0	360.0	2	1	1	Fermé	2026-05-22 23:28:36.880998
289	88	271	20230629	20230702	Fonctionnalité	Moyenne	48.0	0	72.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
290	272	22	20231229	20231230	Fonctionnalité	Haute	16.0	0	24.0	3	1	1	Fermé	2026-05-22 23:28:36.880998
291	130	85	20221025	20221114	Facturation	Moyenne	24.0	0	480.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
292	240	81	20230805	20230807	Fonctionnalité	Moyenne	48.0	0	48.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
293	223	84	20220516	20220524	Facturation	Moyenne	24.0	0	192.0	2	1	1	Résolu	2026-05-22 23:28:36.880998
294	283	27	20220109	20220113	Bug	Critique	4.0	1	96.0	1	1	1	Fermé	2026-05-22 23:28:36.880998
295	231	161	20240604	20240609	Fonctionnalité	Moyenne	48.0	0	120.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
296	217	236	20240124	20240126	Sécurité	Haute	4.0	0	48.0	5	1	1	Fermé	2026-05-22 23:28:36.880998
297	212	67	20221026	20221030	Bug	Haute	8.0	0	96.0	1	0	0	En cours	2026-05-22 23:28:36.880998
298	263	132	20230222	20230228	Performance	Basse	72.0	0	144.0	3	1	1	Résolu	2026-05-22 23:28:36.880998
299	144	232	20220122	20220127	Sécurité	Moyenne	8.0	0	120.0	1	1	1	Résolu	2026-05-22 23:28:36.880998
300	7	278	20220409	20220427	Autre	Haute	16.0	0	432.0	3	0	0	Ouvert	2026-05-22 23:28:36.880998
\.


--
-- Name: dim_user_user_sk_seq; Type: SEQUENCE SET; Schema: technova_dw; Owner: -
--

SELECT pg_catalog.setval('technova_dw.dim_user_user_sk_seq', 300, true);


--
-- Name: fact_serverperformance_perf_sk_seq; Type: SEQUENCE SET; Schema: technova_dw; Owner: -
--

SELECT pg_catalog.setval('technova_dw.fact_serverperformance_perf_sk_seq', 400, true);


--
-- Name: fact_sessions_session_sk_seq; Type: SEQUENCE SET; Schema: technova_dw; Owner: -
--

SELECT pg_catalog.setval('technova_dw.fact_sessions_session_sk_seq', 600, true);


--
-- Name: fact_subscriptions_sub_sk_seq; Type: SEQUENCE SET; Schema: technova_dw; Owner: -
--

SELECT pg_catalog.setval('technova_dw.fact_subscriptions_sub_sk_seq', 250, true);


--
-- Name: fact_support_ticket_sk_seq; Type: SEQUENCE SET; Schema: technova_dw; Owner: -
--

SELECT pg_catalog.setval('technova_dw.fact_support_ticket_sk_seq', 300, true);


--
-- Name: dim_time dim_time_date_complete_key; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.dim_time
    ADD CONSTRAINT dim_time_date_complete_key UNIQUE (date_complete);


--
-- Name: dim_time dim_time_pkey; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.dim_time
    ADD CONSTRAINT dim_time_pkey PRIMARY KEY (date_sk);


--
-- Name: dim_user dim_user_pkey; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.dim_user
    ADD CONSTRAINT dim_user_pkey PRIMARY KEY (user_sk);


--
-- Name: fact_serverperformance fact_serverperformance_perf_id_key; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_serverperformance
    ADD CONSTRAINT fact_serverperformance_perf_id_key UNIQUE (perf_id);


--
-- Name: fact_serverperformance fact_serverperformance_pkey; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_serverperformance
    ADD CONSTRAINT fact_serverperformance_pkey PRIMARY KEY (perf_sk);


--
-- Name: fact_sessions fact_sessions_pkey; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_sessions
    ADD CONSTRAINT fact_sessions_pkey PRIMARY KEY (session_sk);


--
-- Name: fact_sessions fact_sessions_session_id_key; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_sessions
    ADD CONSTRAINT fact_sessions_session_id_key UNIQUE (session_id);


--
-- Name: fact_subscriptions fact_subscriptions_abonnement_id_key; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_subscriptions
    ADD CONSTRAINT fact_subscriptions_abonnement_id_key UNIQUE (abonnement_id);


--
-- Name: fact_subscriptions fact_subscriptions_pkey; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_subscriptions
    ADD CONSTRAINT fact_subscriptions_pkey PRIMARY KEY (sub_sk);


--
-- Name: fact_support fact_support_pkey; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_support
    ADD CONSTRAINT fact_support_pkey PRIMARY KEY (ticket_sk);


--
-- Name: fact_support fact_support_ticket_id_key; Type: CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_support
    ADD CONSTRAINT fact_support_ticket_id_key UNIQUE (ticket_id);


--
-- Name: idx_du_courant; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_du_courant ON technova_dw.dim_user USING btree (user_id, est_courant);


--
-- Name: idx_du_pays; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_du_pays ON technova_dw.dim_user USING btree (pays) WHERE (est_courant = 1);


--
-- Name: idx_du_plan; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_du_plan ON technova_dw.dim_user USING btree (plan) WHERE (est_courant = 1);


--
-- Name: idx_du_user; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_du_user ON technova_dw.dim_user USING btree (user_id);


--
-- Name: idx_fperf_date; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fperf_date ON technova_dw.fact_serverperformance USING btree (date_sk);


--
-- Name: idx_fperf_inc; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fperf_inc ON technova_dw.fact_serverperformance USING btree (est_incident);


--
-- Name: idx_fs_cat; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fs_cat ON technova_dw.fact_sessions USING btree (top_page_categorie);


--
-- Name: idx_fs_date; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fs_date ON technova_dw.fact_sessions USING btree (date_sk);


--
-- Name: idx_fs_user; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fs_user ON technova_dw.fact_sessions USING btree (user_sk);


--
-- Name: idx_fsub_deb; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fsub_deb ON technova_dw.fact_subscriptions USING btree (date_debut_sk);


--
-- Name: idx_fsub_fin; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fsub_fin ON technova_dw.fact_subscriptions USING btree (date_fin_sk);


--
-- Name: idx_fsub_plan; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fsub_plan ON technova_dw.fact_subscriptions USING btree (nom_plan);


--
-- Name: idx_fsub_user; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fsub_user ON technova_dw.fact_subscriptions USING btree (user_sk);


--
-- Name: idx_fsup_cat; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fsup_cat ON technova_dw.fact_support USING btree (categorie, priorite);


--
-- Name: idx_fsup_date; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fsup_date ON technova_dw.fact_support USING btree (date_creation_sk);


--
-- Name: idx_fsup_user; Type: INDEX; Schema: technova_dw; Owner: -
--

CREATE INDEX idx_fsup_user ON technova_dw.fact_support USING btree (user_sk);


--
-- Name: dim_user dim_user_date_inscription_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.dim_user
    ADD CONSTRAINT dim_user_date_inscription_sk_fkey FOREIGN KEY (date_inscription_sk) REFERENCES technova_dw.dim_time(date_sk);


--
-- Name: fact_serverperformance fact_serverperformance_date_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_serverperformance
    ADD CONSTRAINT fact_serverperformance_date_sk_fkey FOREIGN KEY (date_sk) REFERENCES technova_dw.dim_time(date_sk);


--
-- Name: fact_sessions fact_sessions_date_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_sessions
    ADD CONSTRAINT fact_sessions_date_sk_fkey FOREIGN KEY (date_sk) REFERENCES technova_dw.dim_time(date_sk);


--
-- Name: fact_sessions fact_sessions_user_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_sessions
    ADD CONSTRAINT fact_sessions_user_sk_fkey FOREIGN KEY (user_sk) REFERENCES technova_dw.dim_user(user_sk);


--
-- Name: fact_subscriptions fact_subscriptions_date_debut_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_subscriptions
    ADD CONSTRAINT fact_subscriptions_date_debut_sk_fkey FOREIGN KEY (date_debut_sk) REFERENCES technova_dw.dim_time(date_sk);


--
-- Name: fact_subscriptions fact_subscriptions_date_fin_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_subscriptions
    ADD CONSTRAINT fact_subscriptions_date_fin_sk_fkey FOREIGN KEY (date_fin_sk) REFERENCES technova_dw.dim_time(date_sk);


--
-- Name: fact_subscriptions fact_subscriptions_user_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_subscriptions
    ADD CONSTRAINT fact_subscriptions_user_sk_fkey FOREIGN KEY (user_sk) REFERENCES technova_dw.dim_user(user_sk);


--
-- Name: fact_support fact_support_date_creation_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_support
    ADD CONSTRAINT fact_support_date_creation_sk_fkey FOREIGN KEY (date_creation_sk) REFERENCES technova_dw.dim_time(date_sk);


--
-- Name: fact_support fact_support_date_resolution_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_support
    ADD CONSTRAINT fact_support_date_resolution_sk_fkey FOREIGN KEY (date_resolution_sk) REFERENCES technova_dw.dim_time(date_sk);


--
-- Name: fact_support fact_support_user_sk_fkey; Type: FK CONSTRAINT; Schema: technova_dw; Owner: -
--

ALTER TABLE ONLY technova_dw.fact_support
    ADD CONSTRAINT fact_support_user_sk_fkey FOREIGN KEY (user_sk) REFERENCES technova_dw.dim_user(user_sk);


--
-- PostgreSQL database dump complete
--

\unrestrict JicrdvhdYs4MDAK68jRrDTjrcD5IFbMyhTpf075jAHgOMFRqMp2ZWem2vehFFsl

