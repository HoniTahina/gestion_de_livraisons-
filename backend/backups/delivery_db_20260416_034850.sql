--
-- PostgreSQL database dump
--

\restrict RFSgj7GewragfdRsi5txRJdUvTj8Li5Q0kxTulGYpCi4aVwRZpzF0Taa8iqzFKk

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
-- Name: enum_Deliveries_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_Deliveries_status" AS ENUM (
    'ASSIGNED',
    'IN_TRANSIT',
    'DONE'
);


ALTER TYPE public."enum_Deliveries_status" OWNER TO postgres;

--
-- Name: enum_InvitationCodes_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_InvitationCodes_role" AS ENUM (
    'vendeur',
    'livreur'
);


ALTER TYPE public."enum_InvitationCodes_role" OWNER TO postgres;

--
-- Name: enum_SubOrders_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_SubOrders_status" AS ENUM (
    'PENDING',
    'SHIPPED',
    'DELIVERED'
);


ALTER TYPE public."enum_SubOrders_status" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Deliveries" (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'ASSIGNED'::character varying,
    "deliveryPersonId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "trackingToken" character varying(255) NOT NULL,
    "SubOrderId" integer
);


ALTER TABLE public."Deliveries" OWNER TO postgres;

--
-- Name: Deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Deliveries_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Deliveries_id_seq" OWNER TO postgres;

--
-- Name: Deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Deliveries_id_seq" OWNED BY public."Deliveries".id;


--
-- Name: InvitationCodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."InvitationCodes" (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    role public."enum_InvitationCodes_role" NOT NULL,
    "isUsed" boolean DEFAULT false,
    "usedBy" integer,
    "expiresAt" timestamp with time zone,
    "createdBy" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."InvitationCodes" OWNER TO postgres;

--
-- Name: InvitationCodes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."InvitationCodes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."InvitationCodes_id_seq" OWNER TO postgres;

--
-- Name: InvitationCodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."InvitationCodes_id_seq" OWNED BY public."InvitationCodes".id;


--
-- Name: OrderItems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."OrderItems" (
    id integer NOT NULL,
    quantity integer,
    price double precision,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "OrderId" integer,
    "ProductId" integer,
    "SubOrderId" integer
);


ALTER TABLE public."OrderItems" OWNER TO postgres;

--
-- Name: OrderItems_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."OrderItems_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."OrderItems_id_seq" OWNER TO postgres;

--
-- Name: OrderItems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."OrderItems_id_seq" OWNED BY public."OrderItems".id;


--
-- Name: Orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Orders" (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'PENDING'::character varying,
    total double precision DEFAULT '0'::double precision,
    commission double precision DEFAULT '0'::double precision,
    "vendorId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "UserId" integer
);


ALTER TABLE public."Orders" OWNER TO postgres;

--
-- Name: Orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Orders_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Orders_id_seq" OWNER TO postgres;

--
-- Name: Orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Orders_id_seq" OWNED BY public."Orders".id;


--
-- Name: Products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Products" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    price double precision NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    category character varying(255) DEFAULT 'Autre'::character varying NOT NULL,
    "vendorId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Products" OWNER TO postgres;

--
-- Name: Products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Products_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Products_id_seq" OWNER TO postgres;

--
-- Name: Products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Products_id_seq" OWNED BY public."Products".id;


--
-- Name: SubOrders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SubOrders" (
    id integer NOT NULL,
    "vendorId" integer NOT NULL,
    subtotal double precision DEFAULT '0'::double precision,
    status public."enum_SubOrders_status" DEFAULT 'PENDING'::public."enum_SubOrders_status",
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "OrderId" integer
);


ALTER TABLE public."SubOrders" OWNER TO postgres;

--
-- Name: SubOrders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SubOrders_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."SubOrders_id_seq" OWNER TO postgres;

--
-- Name: SubOrders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."SubOrders_id_seq" OWNED BY public."SubOrders".id;


--
-- Name: Users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(255) DEFAULT 'client'::character varying NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Users" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Users_id_seq" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;


--
-- Name: Deliveries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deliveries" ALTER COLUMN id SET DEFAULT nextval('public."Deliveries_id_seq"'::regclass);


--
-- Name: InvitationCodes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes" ALTER COLUMN id SET DEFAULT nextval('public."InvitationCodes_id_seq"'::regclass);


--
-- Name: OrderItems id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItems" ALTER COLUMN id SET DEFAULT nextval('public."OrderItems_id_seq"'::regclass);


--
-- Name: Orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders" ALTER COLUMN id SET DEFAULT nextval('public."Orders_id_seq"'::regclass);


--
-- Name: Products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products" ALTER COLUMN id SET DEFAULT nextval('public."Products_id_seq"'::regclass);


--
-- Name: SubOrders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SubOrders" ALTER COLUMN id SET DEFAULT nextval('public."SubOrders_id_seq"'::regclass);


--
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Data for Name: Deliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Deliveries" (id, status, "deliveryPersonId", "createdAt", "updatedAt", "trackingToken", "SubOrderId") FROM stdin;
\.


--
-- Data for Name: InvitationCodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."InvitationCodes" (id, code, role, "isUsed", "usedBy", "expiresAt", "createdBy", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: OrderItems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."OrderItems" (id, quantity, price, "createdAt", "updatedAt", "OrderId", "ProductId", "SubOrderId") FROM stdin;
1	1	12.5	2026-04-16 00:30:15.918+02	2026-04-16 00:30:15.918+02	1	2	\N
2	2	29.9	2026-04-16 00:30:15.935+02	2026-04-16 00:30:15.935+02	2	4	\N
3	6	39.9	2026-04-16 00:30:15.941+02	2026-04-16 00:30:15.941+02	2	3	\N
4	1	12.5	2026-04-16 00:30:25.09+02	2026-04-16 00:30:25.09+02	3	2	\N
5	2	29.9	2026-04-16 00:30:25.105+02	2026-04-16 00:30:25.105+02	4	4	\N
6	6	39.9	2026-04-16 00:30:25.112+02	2026-04-16 00:30:25.112+02	4	3	\N
7	1	12.5	2026-04-16 00:38:46.967+02	2026-04-16 00:38:46.967+02	5	2	\N
8	1	19.9	2026-04-16 00:38:46.996+02	2026-04-16 00:38:46.996+02	5	1	\N
9	2	29.9	2026-04-16 00:38:47.093+02	2026-04-16 00:38:47.093+02	6	4	\N
10	2	39.9	2026-04-16 00:38:47.126+02	2026-04-16 00:38:47.126+02	6	3	\N
11	1	12.5	2026-04-16 00:43:15.433+02	2026-04-16 00:43:15.433+02	7	2	\N
12	1	19.9	2026-04-16 00:43:15.441+02	2026-04-16 00:43:15.441+02	7	1	\N
13	1	29.9	2026-04-16 00:43:15.457+02	2026-04-16 00:43:15.457+02	8	4	\N
14	1	39.9	2026-04-16 00:43:15.465+02	2026-04-16 00:43:15.465+02	8	3	\N
\.


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Orders" (id, status, total, commission, "vendorId", "createdAt", "updatedAt", "UserId") FROM stdin;
1	PAID	12.5	0.63	2	2026-04-16 00:30:15.89+02	2026-04-16 03:34:13.277+02	6
2	PAID	299.2	14.96	3	2026-04-16 00:30:15.932+02	2026-04-16 03:34:15.391+02	6
8	PAID	69.8	3.49	3	2026-04-16 00:43:15.453+02	2026-04-16 03:34:20.601+02	6
7	PAID	32.4	1.62	2	2026-04-16 00:43:15.406+02	2026-04-16 03:36:02.894+02	6
6	PAID	139.6	6.98	3	2026-04-16 00:38:47.059+02	2026-04-16 03:36:05.184+02	6
5	PAID	32.4	1.62	2	2026-04-16 00:38:46.939+02	2026-04-16 03:36:12.528+02	6
4	PAID	299.2	14.96	3	2026-04-16 00:30:25.102+02	2026-04-16 03:36:14.758+02	6
3	PAID	12.5	0.63	2	2026-04-16 00:30:25.064+02	2026-04-16 03:36:16.942+02	6
\.


--
-- Data for Name: Products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Products" (id, name, price, stock, category, "vendorId", "createdAt", "updatedAt") FROM stdin;
2	Casquette	12.5	21	Accessoires	2	2026-04-16 00:22:45.446+02	2026-04-16 00:43:15.437+02
1	T-shirt bleu	19.9	48	Mode	2	2026-04-16 00:22:45.446+02	2026-04-16 00:43:15.446+02
4	Lunettes de soleil	29.9	13	Mode	3	2026-04-16 00:22:45.446+02	2026-04-16 00:43:15.462+02
3	Sac à dos	39.9	20	Bagagerie	3	2026-04-16 00:22:45.446+02	2026-04-16 00:58:36.832+02
\.


--
-- Data for Name: SubOrders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."SubOrders" (id, "vendorId", subtotal, status, "createdAt", "updatedAt", "OrderId") FROM stdin;
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users" (id, name, email, password, role, "createdAt", "updatedAt") FROM stdin;
1	Admin	admin@platform.com	$2a$10$irvA9KJ0QUdKfxlIOxun8edU.wTy97awLwD0CaaaV94vp6/8COpCi	admin	2026-04-16 00:22:45.39+02	2026-04-16 00:22:45.39+02
2	Vendeur 1	seller1@platform.com	$2a$10$irvA9KJ0QUdKfxlIOxun8edU.wTy97awLwD0CaaaV94vp6/8COpCi	vendeur	2026-04-16 00:22:45.391+02	2026-04-16 00:22:45.391+02
3	Vendeur 2	seller2@platform.com	$2a$10$irvA9KJ0QUdKfxlIOxun8edU.wTy97awLwD0CaaaV94vp6/8COpCi	vendeur	2026-04-16 00:22:45.391+02	2026-04-16 00:22:45.391+02
4	Livreur 1	driver1@platform.com	$2a$10$irvA9KJ0QUdKfxlIOxun8edU.wTy97awLwD0CaaaV94vp6/8COpCi	livreur	2026-04-16 00:22:45.391+02	2026-04-16 00:22:45.391+02
5	Client 1	client1@platform.com	$2a$10$irvA9KJ0QUdKfxlIOxun8edU.wTy97awLwD0CaaaV94vp6/8COpCi	client	2026-04-16 00:22:45.391+02	2026-04-16 00:22:45.391+02
6	Houda Ouadah	houdaouadah61@gmail.com	$2a$10$1jLUxZkBec5JwfeEyn7ibOQO1azfrDADEegN23B/VzGrDJASIzrCC	client	2026-04-16 00:24:20.06+02	2026-04-16 00:24:20.06+02
\.


--
-- Name: Deliveries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Deliveries_id_seq"', 1, false);


--
-- Name: InvitationCodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."InvitationCodes_id_seq"', 1, false);


--
-- Name: OrderItems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."OrderItems_id_seq"', 14, true);


--
-- Name: Orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Orders_id_seq"', 8, true);


--
-- Name: Products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Products_id_seq"', 4, true);


--
-- Name: SubOrders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."SubOrders_id_seq"', 1, false);


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_id_seq"', 6, true);


--
-- Name: Deliveries Deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deliveries"
    ADD CONSTRAINT "Deliveries_pkey" PRIMARY KEY (id);


--
-- Name: InvitationCodes InvitationCodes_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key1" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key10" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key100; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key100" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key101; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key101" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key102; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key102" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key103; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key103" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key104; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key104" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key105; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key105" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key106; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key106" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key107; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key107" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key108; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key108" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key109; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key109" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key11" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key110; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key110" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key111; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key111" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key112; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key112" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key113; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key113" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key114; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key114" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key115; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key115" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key116; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key116" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key117; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key117" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key118; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key118" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key119; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key119" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key12" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key120; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key120" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key121; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key121" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key122; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key122" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key123; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key123" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key124; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key124" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key125; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key125" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key126; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key126" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key127; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key127" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key128; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key128" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key129; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key129" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key13" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key14; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key14" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key15" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key16; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key16" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key17; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key17" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key18" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key19; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key19" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key2" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key20; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key20" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key21; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key21" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key22; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key22" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key23; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key23" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key24; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key24" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key25; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key25" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key26; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key26" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key27; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key27" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key28; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key28" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key29; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key29" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key3" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key30; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key30" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key31; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key31" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key32; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key32" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key33; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key33" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key34; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key34" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key35; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key35" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key36; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key36" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key37; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key37" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key38; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key38" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key39; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key39" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key4" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key40; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key40" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key41; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key41" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key42; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key42" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key43; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key43" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key44; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key44" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key45; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key45" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key46; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key46" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key47; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key47" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key48; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key48" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key49; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key49" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key5" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key50; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key50" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key51; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key51" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key52; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key52" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key53; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key53" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key54; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key54" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key55; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key55" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key56; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key56" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key57; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key57" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key58; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key58" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key59; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key59" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key6" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key60; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key60" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key61; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key61" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key62; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key62" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key63; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key63" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key64; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key64" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key65; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key65" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key66; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key66" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key67; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key67" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key68; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key68" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key69; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key69" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key7" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key70; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key70" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key71; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key71" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key72; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key72" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key73; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key73" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key74; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key74" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key75; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key75" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key76; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key76" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key77; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key77" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key78; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key78" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key79; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key79" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key8" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key80; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key80" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key81; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key81" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key82; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key82" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key83; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key83" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key84; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key84" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key85; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key85" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key86; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key86" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key87; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key87" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key88; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key88" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key89; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key89" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key9" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key90; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key90" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key91; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key91" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key92; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key92" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key93; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key93" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key94; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key94" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key95; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key95" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key96; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key96" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key97; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key97" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key98; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key98" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key99; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key99" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_pkey" PRIMARY KEY (id);


--
-- Name: OrderItems OrderItems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItems"
    ADD CONSTRAINT "OrderItems_pkey" PRIMARY KEY (id);


--
-- Name: Orders Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- Name: Products Products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products"
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (id);


--
-- Name: SubOrders SubOrders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SubOrders"
    ADD CONSTRAINT "SubOrders_pkey" PRIMARY KEY (id);


--
-- Name: Users Users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key" UNIQUE (email);


--
-- Name: Users Users_email_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key1" UNIQUE (email);


--
-- Name: Users Users_email_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key10" UNIQUE (email);


--
-- Name: Users Users_email_key100; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key100" UNIQUE (email);


--
-- Name: Users Users_email_key101; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key101" UNIQUE (email);


--
-- Name: Users Users_email_key102; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key102" UNIQUE (email);


--
-- Name: Users Users_email_key103; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key103" UNIQUE (email);


--
-- Name: Users Users_email_key104; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key104" UNIQUE (email);


--
-- Name: Users Users_email_key105; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key105" UNIQUE (email);


--
-- Name: Users Users_email_key106; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key106" UNIQUE (email);


--
-- Name: Users Users_email_key107; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key107" UNIQUE (email);


--
-- Name: Users Users_email_key108; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key108" UNIQUE (email);


--
-- Name: Users Users_email_key109; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key109" UNIQUE (email);


--
-- Name: Users Users_email_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key11" UNIQUE (email);


--
-- Name: Users Users_email_key110; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key110" UNIQUE (email);


--
-- Name: Users Users_email_key111; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key111" UNIQUE (email);


--
-- Name: Users Users_email_key112; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key112" UNIQUE (email);


--
-- Name: Users Users_email_key113; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key113" UNIQUE (email);


--
-- Name: Users Users_email_key114; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key114" UNIQUE (email);


--
-- Name: Users Users_email_key115; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key115" UNIQUE (email);


--
-- Name: Users Users_email_key116; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key116" UNIQUE (email);


--
-- Name: Users Users_email_key117; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key117" UNIQUE (email);


--
-- Name: Users Users_email_key118; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key118" UNIQUE (email);


--
-- Name: Users Users_email_key119; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key119" UNIQUE (email);


--
-- Name: Users Users_email_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key12" UNIQUE (email);


--
-- Name: Users Users_email_key120; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key120" UNIQUE (email);


--
-- Name: Users Users_email_key121; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key121" UNIQUE (email);


--
-- Name: Users Users_email_key122; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key122" UNIQUE (email);


--
-- Name: Users Users_email_key123; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key123" UNIQUE (email);


--
-- Name: Users Users_email_key124; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key124" UNIQUE (email);


--
-- Name: Users Users_email_key125; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key125" UNIQUE (email);


--
-- Name: Users Users_email_key126; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key126" UNIQUE (email);


--
-- Name: Users Users_email_key127; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key127" UNIQUE (email);


--
-- Name: Users Users_email_key128; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key128" UNIQUE (email);


--
-- Name: Users Users_email_key129; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key129" UNIQUE (email);


--
-- Name: Users Users_email_key13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key13" UNIQUE (email);


--
-- Name: Users Users_email_key130; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key130" UNIQUE (email);


--
-- Name: Users Users_email_key131; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key131" UNIQUE (email);


--
-- Name: Users Users_email_key132; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key132" UNIQUE (email);


--
-- Name: Users Users_email_key133; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key133" UNIQUE (email);


--
-- Name: Users Users_email_key134; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key134" UNIQUE (email);


--
-- Name: Users Users_email_key135; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key135" UNIQUE (email);


--
-- Name: Users Users_email_key136; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key136" UNIQUE (email);


--
-- Name: Users Users_email_key137; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key137" UNIQUE (email);


--
-- Name: Users Users_email_key138; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key138" UNIQUE (email);


--
-- Name: Users Users_email_key139; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key139" UNIQUE (email);


--
-- Name: Users Users_email_key14; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key14" UNIQUE (email);


--
-- Name: Users Users_email_key140; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key140" UNIQUE (email);


--
-- Name: Users Users_email_key141; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key141" UNIQUE (email);


--
-- Name: Users Users_email_key142; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key142" UNIQUE (email);


--
-- Name: Users Users_email_key143; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key143" UNIQUE (email);


--
-- Name: Users Users_email_key144; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key144" UNIQUE (email);


--
-- Name: Users Users_email_key145; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key145" UNIQUE (email);


--
-- Name: Users Users_email_key146; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key146" UNIQUE (email);


--
-- Name: Users Users_email_key147; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key147" UNIQUE (email);


--
-- Name: Users Users_email_key148; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key148" UNIQUE (email);


--
-- Name: Users Users_email_key149; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key149" UNIQUE (email);


--
-- Name: Users Users_email_key15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key15" UNIQUE (email);


--
-- Name: Users Users_email_key150; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key150" UNIQUE (email);


--
-- Name: Users Users_email_key151; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key151" UNIQUE (email);


--
-- Name: Users Users_email_key152; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key152" UNIQUE (email);


--
-- Name: Users Users_email_key153; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key153" UNIQUE (email);


--
-- Name: Users Users_email_key154; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key154" UNIQUE (email);


--
-- Name: Users Users_email_key155; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key155" UNIQUE (email);


--
-- Name: Users Users_email_key156; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key156" UNIQUE (email);


--
-- Name: Users Users_email_key157; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key157" UNIQUE (email);


--
-- Name: Users Users_email_key158; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key158" UNIQUE (email);


--
-- Name: Users Users_email_key159; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key159" UNIQUE (email);


--
-- Name: Users Users_email_key16; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key16" UNIQUE (email);


--
-- Name: Users Users_email_key160; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key160" UNIQUE (email);


--
-- Name: Users Users_email_key161; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key161" UNIQUE (email);


--
-- Name: Users Users_email_key162; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key162" UNIQUE (email);


--
-- Name: Users Users_email_key163; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key163" UNIQUE (email);


--
-- Name: Users Users_email_key164; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key164" UNIQUE (email);


--
-- Name: Users Users_email_key165; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key165" UNIQUE (email);


--
-- Name: Users Users_email_key166; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key166" UNIQUE (email);


--
-- Name: Users Users_email_key167; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key167" UNIQUE (email);


--
-- Name: Users Users_email_key168; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key168" UNIQUE (email);


--
-- Name: Users Users_email_key169; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key169" UNIQUE (email);


--
-- Name: Users Users_email_key17; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key17" UNIQUE (email);


--
-- Name: Users Users_email_key170; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key170" UNIQUE (email);


--
-- Name: Users Users_email_key171; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key171" UNIQUE (email);


--
-- Name: Users Users_email_key172; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key172" UNIQUE (email);


--
-- Name: Users Users_email_key173; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key173" UNIQUE (email);


--
-- Name: Users Users_email_key174; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key174" UNIQUE (email);


--
-- Name: Users Users_email_key175; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key175" UNIQUE (email);


--
-- Name: Users Users_email_key176; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key176" UNIQUE (email);


--
-- Name: Users Users_email_key177; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key177" UNIQUE (email);


--
-- Name: Users Users_email_key178; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key178" UNIQUE (email);


--
-- Name: Users Users_email_key179; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key179" UNIQUE (email);


--
-- Name: Users Users_email_key18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key18" UNIQUE (email);


--
-- Name: Users Users_email_key180; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key180" UNIQUE (email);


--
-- Name: Users Users_email_key181; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key181" UNIQUE (email);


--
-- Name: Users Users_email_key182; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key182" UNIQUE (email);


--
-- Name: Users Users_email_key183; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key183" UNIQUE (email);


--
-- Name: Users Users_email_key184; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key184" UNIQUE (email);


--
-- Name: Users Users_email_key185; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key185" UNIQUE (email);


--
-- Name: Users Users_email_key186; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key186" UNIQUE (email);


--
-- Name: Users Users_email_key187; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key187" UNIQUE (email);


--
-- Name: Users Users_email_key188; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key188" UNIQUE (email);


--
-- Name: Users Users_email_key189; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key189" UNIQUE (email);


--
-- Name: Users Users_email_key19; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key19" UNIQUE (email);


--
-- Name: Users Users_email_key190; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key190" UNIQUE (email);


--
-- Name: Users Users_email_key191; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key191" UNIQUE (email);


--
-- Name: Users Users_email_key192; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key192" UNIQUE (email);


--
-- Name: Users Users_email_key193; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key193" UNIQUE (email);


--
-- Name: Users Users_email_key194; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key194" UNIQUE (email);


--
-- Name: Users Users_email_key195; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key195" UNIQUE (email);


--
-- Name: Users Users_email_key196; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key196" UNIQUE (email);


--
-- Name: Users Users_email_key197; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key197" UNIQUE (email);


--
-- Name: Users Users_email_key198; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key198" UNIQUE (email);


--
-- Name: Users Users_email_key199; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key199" UNIQUE (email);


--
-- Name: Users Users_email_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key2" UNIQUE (email);


--
-- Name: Users Users_email_key20; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key20" UNIQUE (email);


--
-- Name: Users Users_email_key200; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key200" UNIQUE (email);


--
-- Name: Users Users_email_key201; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key201" UNIQUE (email);


--
-- Name: Users Users_email_key202; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key202" UNIQUE (email);


--
-- Name: Users Users_email_key203; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key203" UNIQUE (email);


--
-- Name: Users Users_email_key204; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key204" UNIQUE (email);


--
-- Name: Users Users_email_key205; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key205" UNIQUE (email);


--
-- Name: Users Users_email_key206; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key206" UNIQUE (email);


--
-- Name: Users Users_email_key207; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key207" UNIQUE (email);


--
-- Name: Users Users_email_key208; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key208" UNIQUE (email);


--
-- Name: Users Users_email_key209; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key209" UNIQUE (email);


--
-- Name: Users Users_email_key21; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key21" UNIQUE (email);


--
-- Name: Users Users_email_key210; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key210" UNIQUE (email);


--
-- Name: Users Users_email_key211; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key211" UNIQUE (email);


--
-- Name: Users Users_email_key212; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key212" UNIQUE (email);


--
-- Name: Users Users_email_key213; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key213" UNIQUE (email);


--
-- Name: Users Users_email_key214; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key214" UNIQUE (email);


--
-- Name: Users Users_email_key215; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key215" UNIQUE (email);


--
-- Name: Users Users_email_key216; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key216" UNIQUE (email);


--
-- Name: Users Users_email_key217; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key217" UNIQUE (email);


--
-- Name: Users Users_email_key218; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key218" UNIQUE (email);


--
-- Name: Users Users_email_key219; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key219" UNIQUE (email);


--
-- Name: Users Users_email_key22; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key22" UNIQUE (email);


--
-- Name: Users Users_email_key220; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key220" UNIQUE (email);


--
-- Name: Users Users_email_key221; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key221" UNIQUE (email);


--
-- Name: Users Users_email_key222; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key222" UNIQUE (email);


--
-- Name: Users Users_email_key223; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key223" UNIQUE (email);


--
-- Name: Users Users_email_key224; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key224" UNIQUE (email);


--
-- Name: Users Users_email_key225; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key225" UNIQUE (email);


--
-- Name: Users Users_email_key226; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key226" UNIQUE (email);


--
-- Name: Users Users_email_key227; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key227" UNIQUE (email);


--
-- Name: Users Users_email_key228; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key228" UNIQUE (email);


--
-- Name: Users Users_email_key229; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key229" UNIQUE (email);


--
-- Name: Users Users_email_key23; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key23" UNIQUE (email);


--
-- Name: Users Users_email_key230; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key230" UNIQUE (email);


--
-- Name: Users Users_email_key231; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key231" UNIQUE (email);


--
-- Name: Users Users_email_key232; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key232" UNIQUE (email);


--
-- Name: Users Users_email_key233; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key233" UNIQUE (email);


--
-- Name: Users Users_email_key24; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key24" UNIQUE (email);


--
-- Name: Users Users_email_key25; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key25" UNIQUE (email);


--
-- Name: Users Users_email_key26; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key26" UNIQUE (email);


--
-- Name: Users Users_email_key27; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key27" UNIQUE (email);


--
-- Name: Users Users_email_key28; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key28" UNIQUE (email);


--
-- Name: Users Users_email_key29; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key29" UNIQUE (email);


--
-- Name: Users Users_email_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key3" UNIQUE (email);


--
-- Name: Users Users_email_key30; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key30" UNIQUE (email);


--
-- Name: Users Users_email_key31; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key31" UNIQUE (email);


--
-- Name: Users Users_email_key32; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key32" UNIQUE (email);


--
-- Name: Users Users_email_key33; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key33" UNIQUE (email);


--
-- Name: Users Users_email_key34; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key34" UNIQUE (email);


--
-- Name: Users Users_email_key35; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key35" UNIQUE (email);


--
-- Name: Users Users_email_key36; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key36" UNIQUE (email);


--
-- Name: Users Users_email_key37; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key37" UNIQUE (email);


--
-- Name: Users Users_email_key38; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key38" UNIQUE (email);


--
-- Name: Users Users_email_key39; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key39" UNIQUE (email);


--
-- Name: Users Users_email_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key4" UNIQUE (email);


--
-- Name: Users Users_email_key40; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key40" UNIQUE (email);


--
-- Name: Users Users_email_key41; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key41" UNIQUE (email);


--
-- Name: Users Users_email_key42; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key42" UNIQUE (email);


--
-- Name: Users Users_email_key43; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key43" UNIQUE (email);


--
-- Name: Users Users_email_key44; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key44" UNIQUE (email);


--
-- Name: Users Users_email_key45; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key45" UNIQUE (email);


--
-- Name: Users Users_email_key46; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key46" UNIQUE (email);


--
-- Name: Users Users_email_key47; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key47" UNIQUE (email);


--
-- Name: Users Users_email_key48; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key48" UNIQUE (email);


--
-- Name: Users Users_email_key49; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key49" UNIQUE (email);


--
-- Name: Users Users_email_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key5" UNIQUE (email);


--
-- Name: Users Users_email_key50; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key50" UNIQUE (email);


--
-- Name: Users Users_email_key51; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key51" UNIQUE (email);


--
-- Name: Users Users_email_key52; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key52" UNIQUE (email);


--
-- Name: Users Users_email_key53; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key53" UNIQUE (email);


--
-- Name: Users Users_email_key54; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key54" UNIQUE (email);


--
-- Name: Users Users_email_key55; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key55" UNIQUE (email);


--
-- Name: Users Users_email_key56; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key56" UNIQUE (email);


--
-- Name: Users Users_email_key57; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key57" UNIQUE (email);


--
-- Name: Users Users_email_key58; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key58" UNIQUE (email);


--
-- Name: Users Users_email_key59; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key59" UNIQUE (email);


--
-- Name: Users Users_email_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key6" UNIQUE (email);


--
-- Name: Users Users_email_key60; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key60" UNIQUE (email);


--
-- Name: Users Users_email_key61; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key61" UNIQUE (email);


--
-- Name: Users Users_email_key62; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key62" UNIQUE (email);


--
-- Name: Users Users_email_key63; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key63" UNIQUE (email);


--
-- Name: Users Users_email_key64; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key64" UNIQUE (email);


--
-- Name: Users Users_email_key65; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key65" UNIQUE (email);


--
-- Name: Users Users_email_key66; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key66" UNIQUE (email);


--
-- Name: Users Users_email_key67; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key67" UNIQUE (email);


--
-- Name: Users Users_email_key68; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key68" UNIQUE (email);


--
-- Name: Users Users_email_key69; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key69" UNIQUE (email);


--
-- Name: Users Users_email_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key7" UNIQUE (email);


--
-- Name: Users Users_email_key70; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key70" UNIQUE (email);


--
-- Name: Users Users_email_key71; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key71" UNIQUE (email);


--
-- Name: Users Users_email_key72; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key72" UNIQUE (email);


--
-- Name: Users Users_email_key73; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key73" UNIQUE (email);


--
-- Name: Users Users_email_key74; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key74" UNIQUE (email);


--
-- Name: Users Users_email_key75; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key75" UNIQUE (email);


--
-- Name: Users Users_email_key76; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key76" UNIQUE (email);


--
-- Name: Users Users_email_key77; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key77" UNIQUE (email);


--
-- Name: Users Users_email_key78; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key78" UNIQUE (email);


--
-- Name: Users Users_email_key79; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key79" UNIQUE (email);


--
-- Name: Users Users_email_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key8" UNIQUE (email);


--
-- Name: Users Users_email_key80; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key80" UNIQUE (email);


--
-- Name: Users Users_email_key81; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key81" UNIQUE (email);


--
-- Name: Users Users_email_key82; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key82" UNIQUE (email);


--
-- Name: Users Users_email_key83; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key83" UNIQUE (email);


--
-- Name: Users Users_email_key84; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key84" UNIQUE (email);


--
-- Name: Users Users_email_key85; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key85" UNIQUE (email);


--
-- Name: Users Users_email_key86; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key86" UNIQUE (email);


--
-- Name: Users Users_email_key87; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key87" UNIQUE (email);


--
-- Name: Users Users_email_key88; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key88" UNIQUE (email);


--
-- Name: Users Users_email_key89; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key89" UNIQUE (email);


--
-- Name: Users Users_email_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key9" UNIQUE (email);


--
-- Name: Users Users_email_key90; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key90" UNIQUE (email);


--
-- Name: Users Users_email_key91; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key91" UNIQUE (email);


--
-- Name: Users Users_email_key92; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key92" UNIQUE (email);


--
-- Name: Users Users_email_key93; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key93" UNIQUE (email);


--
-- Name: Users Users_email_key94; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key94" UNIQUE (email);


--
-- Name: Users Users_email_key95; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key95" UNIQUE (email);


--
-- Name: Users Users_email_key96; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key96" UNIQUE (email);


--
-- Name: Users Users_email_key97; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key97" UNIQUE (email);


--
-- Name: Users Users_email_key98; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key98" UNIQUE (email);


--
-- Name: Users Users_email_key99; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key99" UNIQUE (email);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: Deliveries Deliveries_SubOrderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deliveries"
    ADD CONSTRAINT "Deliveries_SubOrderId_fkey" FOREIGN KEY ("SubOrderId") REFERENCES public."SubOrders"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Deliveries Deliveries_deliveryPersonId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deliveries"
    ADD CONSTRAINT "Deliveries_deliveryPersonId_fkey" FOREIGN KEY ("deliveryPersonId") REFERENCES public."Users"(id) ON UPDATE CASCADE;


--
-- Name: InvitationCodes InvitationCodes_createdBy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: InvitationCodes InvitationCodes_usedBy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_usedBy_fkey" FOREIGN KEY ("usedBy") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: OrderItems OrderItems_OrderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItems"
    ADD CONSTRAINT "OrderItems_OrderId_fkey" FOREIGN KEY ("OrderId") REFERENCES public."Orders"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: OrderItems OrderItems_ProductId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItems"
    ADD CONSTRAINT "OrderItems_ProductId_fkey" FOREIGN KEY ("ProductId") REFERENCES public."Products"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: OrderItems OrderItems_SubOrderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItems"
    ADD CONSTRAINT "OrderItems_SubOrderId_fkey" FOREIGN KEY ("SubOrderId") REFERENCES public."SubOrders"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Orders Orders_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Orders Orders_vendorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Products Products_vendorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products"
    ADD CONSTRAINT "Products_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SubOrders SubOrders_OrderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SubOrders"
    ADD CONSTRAINT "SubOrders_OrderId_fkey" FOREIGN KEY ("OrderId") REFERENCES public."Orders"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SubOrders SubOrders_vendorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SubOrders"
    ADD CONSTRAINT "SubOrders_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict RFSgj7GewragfdRsi5txRJdUvTj8Li5Q0kxTulGYpCi4aVwRZpzF0Taa8iqzFKk

