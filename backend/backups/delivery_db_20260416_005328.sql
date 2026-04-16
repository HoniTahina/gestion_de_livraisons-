--
-- PostgreSQL database dump
--

\restrict iGIZQM3OhDF6IRpNPMMwDegbHaXjNoqmR9TgS4d1FGR8QPuAGPTUq5z94sXrRi4

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
-- Name: enum_InvitationCodes_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_InvitationCodes_role" AS ENUM (
    'vendeur',
    'livreur'
);


ALTER TYPE public."enum_InvitationCodes_role" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Deliveries" (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'PENDING'::character varying,
    "deliveryPersonId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "OrderId" integer
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
    "ProductId" integer
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
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Data for Name: Deliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Deliveries" (id, status, "deliveryPersonId", "createdAt", "updatedAt", "OrderId") FROM stdin;
\.


--
-- Data for Name: InvitationCodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."InvitationCodes" (id, code, role, "isUsed", "usedBy", "expiresAt", "createdBy", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: OrderItems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."OrderItems" (id, quantity, price, "createdAt", "updatedAt", "OrderId", "ProductId") FROM stdin;
1	1	12.5	2026-04-16 00:30:15.918+02	2026-04-16 00:30:15.918+02	1	2
2	2	29.9	2026-04-16 00:30:15.935+02	2026-04-16 00:30:15.935+02	2	4
3	6	39.9	2026-04-16 00:30:15.941+02	2026-04-16 00:30:15.941+02	2	3
4	1	12.5	2026-04-16 00:30:25.09+02	2026-04-16 00:30:25.09+02	3	2
5	2	29.9	2026-04-16 00:30:25.105+02	2026-04-16 00:30:25.105+02	4	4
6	6	39.9	2026-04-16 00:30:25.112+02	2026-04-16 00:30:25.112+02	4	3
7	1	12.5	2026-04-16 00:38:46.967+02	2026-04-16 00:38:46.967+02	5	2
8	1	19.9	2026-04-16 00:38:46.996+02	2026-04-16 00:38:46.996+02	5	1
9	2	29.9	2026-04-16 00:38:47.093+02	2026-04-16 00:38:47.093+02	6	4
10	2	39.9	2026-04-16 00:38:47.126+02	2026-04-16 00:38:47.126+02	6	3
11	1	12.5	2026-04-16 00:43:15.433+02	2026-04-16 00:43:15.433+02	7	2
12	1	19.9	2026-04-16 00:43:15.441+02	2026-04-16 00:43:15.441+02	7	1
13	1	29.9	2026-04-16 00:43:15.457+02	2026-04-16 00:43:15.457+02	8	4
14	1	39.9	2026-04-16 00:43:15.465+02	2026-04-16 00:43:15.465+02	8	3
\.


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Orders" (id, status, total, commission, "vendorId", "createdAt", "updatedAt", "UserId") FROM stdin;
1	PENDING	12.5	0.63	2	2026-04-16 00:30:15.89+02	2026-04-16 00:30:15.929+02	6
2	PENDING	299.2	14.96	3	2026-04-16 00:30:15.932+02	2026-04-16 00:30:15.945+02	6
3	PENDING	12.5	0.63	2	2026-04-16 00:30:25.064+02	2026-04-16 00:30:25.097+02	6
4	PENDING	299.2	14.96	3	2026-04-16 00:30:25.102+02	2026-04-16 00:30:25.117+02	6
5	PENDING	32.4	1.62	2	2026-04-16 00:38:46.939+02	2026-04-16 00:38:47.037+02	6
6	PENDING	139.6	6.98	3	2026-04-16 00:38:47.059+02	2026-04-16 00:38:47.143+02	6
7	PENDING	32.4	1.62	2	2026-04-16 00:43:15.406+02	2026-04-16 00:43:15.45+02	6
8	PENDING	69.8	3.49	3	2026-04-16 00:43:15.453+02	2026-04-16 00:43:15.471+02	6
\.


--
-- Data for Name: Products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Products" (id, name, price, stock, category, "vendorId", "createdAt", "updatedAt") FROM stdin;
2	Casquette	12.5	21	Accessoires	2	2026-04-16 00:22:45.446+02	2026-04-16 00:43:15.437+02
1	T-shirt bleu	19.9	48	Mode	2	2026-04-16 00:22:45.446+02	2026-04-16 00:43:15.446+02
4	Lunettes de soleil	29.9	13	Mode	3	2026-04-16 00:22:45.446+02	2026-04-16 00:43:15.462+02
3	Sac à dos	39.9	0	Bagagerie	3	2026-04-16 00:22:45.446+02	2026-04-16 00:43:15.468+02
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
-- Name: InvitationCodes InvitationCodes_code_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key11" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key12" UNIQUE (code);


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
-- Name: InvitationCodes InvitationCodes_code_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key2" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key3" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key4" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key5" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key6" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key7" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key8" UNIQUE (code);


--
-- Name: InvitationCodes InvitationCodes_code_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvitationCodes"
    ADD CONSTRAINT "InvitationCodes_code_key9" UNIQUE (code);


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
-- Name: Users Users_email_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key11" UNIQUE (email);


--
-- Name: Users Users_email_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key12" UNIQUE (email);


--
-- Name: Users Users_email_key13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key13" UNIQUE (email);


--
-- Name: Users Users_email_key14; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key14" UNIQUE (email);


--
-- Name: Users Users_email_key15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key15" UNIQUE (email);


--
-- Name: Users Users_email_key16; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key16" UNIQUE (email);


--
-- Name: Users Users_email_key17; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key17" UNIQUE (email);


--
-- Name: Users Users_email_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key2" UNIQUE (email);


--
-- Name: Users Users_email_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key3" UNIQUE (email);


--
-- Name: Users Users_email_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key4" UNIQUE (email);


--
-- Name: Users Users_email_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key5" UNIQUE (email);


--
-- Name: Users Users_email_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key6" UNIQUE (email);


--
-- Name: Users Users_email_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key7" UNIQUE (email);


--
-- Name: Users Users_email_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key8" UNIQUE (email);


--
-- Name: Users Users_email_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key9" UNIQUE (email);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: Deliveries Deliveries_OrderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deliveries"
    ADD CONSTRAINT "Deliveries_OrderId_fkey" FOREIGN KEY ("OrderId") REFERENCES public."Orders"(id) ON UPDATE CASCADE ON DELETE SET NULL;


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
-- Name: Orders Orders_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Orders Orders_vendorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Products Products_vendorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products"
    ADD CONSTRAINT "Products_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict iGIZQM3OhDF6IRpNPMMwDegbHaXjNoqmR9TgS4d1FGR8QPuAGPTUq5z94sXrRi4

