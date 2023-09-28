--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Homebrew)
-- Dumped by pg_dump version 14.9 (Homebrew)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: shiguofeng
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO shiguofeng;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: shiguofeng
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_demouserstatus; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_demouserstatus (
    id bigint NOT NULL,
    in_use boolean NOT NULL,
    last_used timestamp with time zone NOT NULL,
    profile_id integer NOT NULL,
    db_file character varying(200) NOT NULL
);


ALTER TABLE public.api_demouserstatus OWNER TO tracer_api;

--
-- Name: api_demouserstatus_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_demouserstatus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_demouserstatus_id_seq OWNER TO tracer_api;

--
-- Name: api_demouserstatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_demouserstatus_id_seq OWNED BY public.api_demouserstatus.id;


--
-- Name: api_filerepository; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_filerepository (
    id bigint NOT NULL,
    file_type smallint NOT NULL,
    name character varying(32) NOT NULL,
    key character varying(128),
    file_size bigint,
    file_path character varying(255),
    update_datetime timestamp with time zone NOT NULL,
    parent_id bigint,
    project_id bigint NOT NULL,
    update_user_id integer NOT NULL
);


ALTER TABLE public.api_filerepository OWNER TO tracer_api;

--
-- Name: api_filerepository_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_filerepository_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_filerepository_id_seq OWNER TO tracer_api;

--
-- Name: api_filerepository_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_filerepository_id_seq OWNED BY public.api_filerepository.id;


--
-- Name: api_issues; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_issues (
    id bigint NOT NULL,
    subject character varying(80) NOT NULL,
    "desc" text NOT NULL,
    priority character varying(12) NOT NULL,
    status smallint NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    mode smallint NOT NULL,
    create_datetime timestamp with time zone NOT NULL,
    latest_update_datetime timestamp with time zone NOT NULL,
    assign_id integer,
    creator_id integer NOT NULL,
    issues_type_id bigint NOT NULL,
    module_id bigint,
    parent_id bigint,
    project_id bigint NOT NULL,
    project_issue_id integer NOT NULL,
    CONSTRAINT api_issues_project_issue_id_check CHECK ((project_issue_id >= 0))
);


ALTER TABLE public.api_issues OWNER TO tracer_api;

--
-- Name: api_issues_attention; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_issues_attention (
    id bigint NOT NULL,
    issues_id bigint NOT NULL,
    profile_id integer NOT NULL
);


ALTER TABLE public.api_issues_attention OWNER TO tracer_api;

--
-- Name: api_issues_attention_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_issues_attention_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_issues_attention_id_seq OWNER TO tracer_api;

--
-- Name: api_issues_attention_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_issues_attention_id_seq OWNED BY public.api_issues_attention.id;


--
-- Name: api_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_issues_id_seq OWNER TO tracer_api;

--
-- Name: api_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_issues_id_seq OWNED BY public.api_issues.id;


--
-- Name: api_issuesreply; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_issuesreply (
    id bigint NOT NULL,
    reply_type integer NOT NULL,
    content text NOT NULL,
    create_datetime timestamp with time zone NOT NULL,
    creator_id integer NOT NULL,
    issues_id bigint NOT NULL,
    reply_id bigint
);


ALTER TABLE public.api_issuesreply OWNER TO tracer_api;

--
-- Name: api_issuesreply_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_issuesreply_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_issuesreply_id_seq OWNER TO tracer_api;

--
-- Name: api_issuesreply_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_issuesreply_id_seq OWNED BY public.api_issuesreply.id;


--
-- Name: api_issuestype; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_issuestype (
    id bigint NOT NULL,
    title character varying(32) NOT NULL,
    project_id bigint NOT NULL
);


ALTER TABLE public.api_issuestype OWNER TO tracer_api;

--
-- Name: api_issuestype_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_issuestype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_issuestype_id_seq OWNER TO tracer_api;

--
-- Name: api_issuestype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_issuestype_id_seq OWNED BY public.api_issuestype.id;


--
-- Name: api_module; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_module (
    id bigint NOT NULL,
    title character varying(32) NOT NULL,
    project_id bigint NOT NULL
);


ALTER TABLE public.api_module OWNER TO tracer_api;

--
-- Name: api_module_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_module_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_module_id_seq OWNER TO tracer_api;

--
-- Name: api_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_module_id_seq OWNED BY public.api_module.id;


--
-- Name: api_pricepolicy; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_pricepolicy (
    id bigint NOT NULL,
    category smallint NOT NULL,
    title character varying(32) NOT NULL,
    price integer NOT NULL,
    project_num integer NOT NULL,
    project_member integer NOT NULL,
    project_space integer NOT NULL,
    per_file_size integer NOT NULL,
    create_datetime timestamp with time zone NOT NULL,
    CONSTRAINT api_pricepolicy_per_file_size_check CHECK ((per_file_size >= 0)),
    CONSTRAINT api_pricepolicy_price_check CHECK ((price >= 0)),
    CONSTRAINT api_pricepolicy_project_member_check CHECK ((project_member >= 0)),
    CONSTRAINT api_pricepolicy_project_num_check CHECK ((project_num >= 0)),
    CONSTRAINT api_pricepolicy_project_space_check CHECK ((project_space >= 0))
);


ALTER TABLE public.api_pricepolicy OWNER TO tracer_api;

--
-- Name: api_pricepolicy_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_pricepolicy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_pricepolicy_id_seq OWNER TO tracer_api;

--
-- Name: api_pricepolicy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_pricepolicy_id_seq OWNED BY public.api_pricepolicy.id;


--
-- Name: api_profile; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_profile (
    user_id integer NOT NULL,
    avatar smallint NOT NULL,
    price_policy_id bigint
);


ALTER TABLE public.api_profile OWNER TO tracer_api;

--
-- Name: api_project; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_project (
    id bigint NOT NULL,
    name character varying(32) NOT NULL,
    color smallint NOT NULL,
    "desc" character varying(255),
    use_space bigint NOT NULL,
    star boolean NOT NULL,
    join_count smallint NOT NULL,
    create_datetime timestamp with time zone NOT NULL,
    creator_id integer NOT NULL,
    next_issue_id integer NOT NULL,
    CONSTRAINT api_project_next_issue_id_check CHECK ((next_issue_id >= 0))
);


ALTER TABLE public.api_project OWNER TO tracer_api;

--
-- Name: api_project_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_project_id_seq OWNER TO tracer_api;

--
-- Name: api_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_project_id_seq OWNED BY public.api_project.id;


--
-- Name: api_projectinvite; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_projectinvite (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    count integer,
    use_count integer NOT NULL,
    period integer NOT NULL,
    create_datetime timestamp with time zone NOT NULL,
    creator_id integer NOT NULL,
    project_id bigint NOT NULL,
    CONSTRAINT api_projectinvite_count_check CHECK ((count >= 0)),
    CONSTRAINT api_projectinvite_use_count_check CHECK ((use_count >= 0))
);


ALTER TABLE public.api_projectinvite OWNER TO tracer_api;

--
-- Name: api_projectinvite_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_projectinvite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_projectinvite_id_seq OWNER TO tracer_api;

--
-- Name: api_projectinvite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_projectinvite_id_seq OWNED BY public.api_projectinvite.id;


--
-- Name: api_projectuser; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_projectuser (
    id bigint NOT NULL,
    star boolean NOT NULL,
    create_datetime timestamp with time zone NOT NULL,
    project_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.api_projectuser OWNER TO tracer_api;

--
-- Name: api_projectuser_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_projectuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_projectuser_id_seq OWNER TO tracer_api;

--
-- Name: api_projectuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_projectuser_id_seq OWNED BY public.api_projectuser.id;


--
-- Name: api_wiki; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.api_wiki (
    id bigint NOT NULL,
    title character varying(32) NOT NULL,
    content text NOT NULL,
    depth integer NOT NULL,
    parent_id bigint,
    project_id bigint NOT NULL
);


ALTER TABLE public.api_wiki OWNER TO tracer_api;

--
-- Name: api_wiki_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.api_wiki_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_wiki_id_seq OWNER TO tracer_api;

--
-- Name: api_wiki_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.api_wiki_id_seq OWNED BY public.api_wiki.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO tracer_api;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO tracer_api;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO tracer_api;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO tracer_api;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO tracer_api;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO tracer_api;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO tracer_api;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO tracer_api;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO tracer_api;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO tracer_api;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO tracer_api;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO tracer_api;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.authtoken_token OWNER TO tracer_api;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO tracer_api;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO tracer_api;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO tracer_api;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO tracer_api;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO tracer_api;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: tracer_api
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO tracer_api;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tracer_api
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: tracer_api
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO tracer_api;

--
-- Name: api_demouserstatus id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_demouserstatus ALTER COLUMN id SET DEFAULT nextval('public.api_demouserstatus_id_seq'::regclass);


--
-- Name: api_filerepository id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_filerepository ALTER COLUMN id SET DEFAULT nextval('public.api_filerepository_id_seq'::regclass);


--
-- Name: api_issues id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues ALTER COLUMN id SET DEFAULT nextval('public.api_issues_id_seq'::regclass);


--
-- Name: api_issues_attention id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues_attention ALTER COLUMN id SET DEFAULT nextval('public.api_issues_attention_id_seq'::regclass);


--
-- Name: api_issuesreply id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issuesreply ALTER COLUMN id SET DEFAULT nextval('public.api_issuesreply_id_seq'::regclass);


--
-- Name: api_issuestype id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issuestype ALTER COLUMN id SET DEFAULT nextval('public.api_issuestype_id_seq'::regclass);


--
-- Name: api_module id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_module ALTER COLUMN id SET DEFAULT nextval('public.api_module_id_seq'::regclass);


--
-- Name: api_pricepolicy id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_pricepolicy ALTER COLUMN id SET DEFAULT nextval('public.api_pricepolicy_id_seq'::regclass);


--
-- Name: api_project id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_project ALTER COLUMN id SET DEFAULT nextval('public.api_project_id_seq'::regclass);


--
-- Name: api_projectinvite id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectinvite ALTER COLUMN id SET DEFAULT nextval('public.api_projectinvite_id_seq'::regclass);


--
-- Name: api_projectuser id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectuser ALTER COLUMN id SET DEFAULT nextval('public.api_projectuser_id_seq'::regclass);


--
-- Name: api_wiki id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_wiki ALTER COLUMN id SET DEFAULT nextval('public.api_wiki_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Data for Name: api_demouserstatus; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_demouserstatus (id, in_use, last_used, profile_id, db_file) FROM stdin;
\.


--
-- Data for Name: api_filerepository; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_filerepository (id, file_type, name, key, file_size, file_path, update_datetime, parent_id, project_id, update_user_id) FROM stdin;
1	1	code.jpg	1/1/2023/09/19/01_39_57_-33cd8ba0_code.jpg	18529	https://sg-tracer.s3.amazonaws.com/1/1/2023/09/19/01_39_57_-33cd8ba0_code.jpg	2023-09-19 01:39:59.199698-06	\N	1	1
2	1	Tracer_Logo.png	2/4/2023/09/21/23_34_09_73121f98_Tracer_Logo.png	10089	https://sg-tracer.s3.amazonaws.com/2/4/2023/09/21/23_34_09_73121f98_Tracer_Logo.png	2023-09-20 23:34:11.019482-06	\N	4	2
3	2	File_System	\N	\N	\N	2023-09-20 23:35:20.708106-06	\N	4	2
4	1	file_model.py	2/4/2023/09/21/23_40_37_42052a51_file_model.py	1257	https://sg-tracer.s3.amazonaws.com/2/4/2023/09/21/23_40_37_42052a51_file_model.py	2023-09-20 23:40:38.018975-06	3	4	2
5	2	Requirements	\N	\N	\N	2023-09-20 23:45:15.905115-06	\N	4	2
6	1	requirements.txt	2/4/2023/09/21/23_45_27_16409012_requirements.txt	568	https://sg-tracer.s3.amazonaws.com/2/4/2023/09/21/23_45_27_16409012_requirements.txt	2023-09-20 23:45:28.417323-06	5	4	2
7	2	Docker	\N	\N	\N	2023-09-20 23:46:35.825434-06	5	4	2
9	2	Docker_container	\N	\N	\N	2023-09-20 23:47:04.52024-06	7	4	2
8	2	Docker_Images	\N	\N	\N	2023-09-20 23:47:11.800423-06	7	4	2
\.


--
-- Data for Name: api_issues; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_issues (id, subject, "desc", priority, status, start_date, end_date, mode, create_datetime, latest_update_datetime, assign_id, creator_id, issues_type_id, module_id, parent_id, project_id, project_issue_id) FROM stdin;
1	好饿呀111	12345	success	4	\N	\N	1	2023-09-19 01:39:01.472588-06	2023-09-19 01:39:10.652805-06	\N	1	1	\N	\N	1	1
2	起飞咯123	444	error	1	\N	\N	1	2023-09-19 01:39:26.941901-06	2023-09-19 01:39:26.941927-06	1	1	1	\N	\N	1	2
3	111	23333	success	4	\N	\N	2	2023-09-19 23:35:07.779496-06	2023-09-19 23:35:07.779512-06	\N	1	1	\N	\N	1	3
6	Data Migration	Transition data from SQLite to PostgreSQL using Django's `dumpdata` and `loaddata` commands.	success	3	\N	\N	1	2023-09-21 12:41:26.266311-06	2023-09-21 12:41:26.266412-06	2	2	10	1	\N	4	3
7	📂 Folders --  Creation and Management:	**Creation and Management**:\n\n- Users should be able to create new folders within a specified project.\n- Users should be able to enter and manage the contents of a folder.	warning	2	2023-09-26 00:00:00-06	\N	1	2023-09-21 12:44:00.92872-06	2023-09-21 12:44:58.802896-06	\N	2	11	\N	\N	4	4
8	📂 Folders --  Edit Name	- Users should be able to rename a folder.	success	2	\N	\N	1	2023-09-21 12:46:45.013038-06	2023-09-21 12:46:55.861503-06	2	2	11	\N	\N	4	5
9	📂 Folders -- Test Renaming	- User should be able to edit folder name after clicking "Edit" icon	error	1	\N	2023-09-23 00:00:00-06	1	2023-09-21 12:52:16.002071-06	2023-09-21 12:52:16.002094-06	\N	2	10	\N	\N	4	6
11	Demo User -- Test Download & Delete	![Uploaded Image](https://sg-tracer.s3.amazonaws.com/public_images/4/4/2023/09/21/21607f72b39b42aca61bd9ba3af3c7f0.png)\n\n- Demo user should be able to download and Delete File	success	7	2023-09-21 00:00:00-06	2023-09-30 00:00:00-06	1	2023-09-21 13:11:55.240899-06	2023-09-21 13:12:02.270978-06	4	4	10	1	5	4	8
5	Demo User -- Instant Access	- Implement a dedicated "Try as Demo User" button or link on the login page.	success	5	\N	\N	1	2023-09-21 12:37:15.275596-06	2023-09-21 13:13:38.880091-06	4	2	11	1	\N	4	2
4	Data Persistence Across Different User Sessions	### Issue:\nWhen a user (say User A) logs into the application, their data is fetched and displayed correctly. However, if User A logs out and another user (say User B) logs in subsequently, the application initially displays the data of User A instead of fetching and displaying User B's data. Currently, a browser refresh forces the application to fetch and display the correct data for User B.\n\n### Steps to Reproduce:\n1. Login as User A.\n2. Navigate through the app to fetch and display User A’s data.\n3. Logout User A.\n4. Login as User B without refreshing the browser.\n5. Observe that the application displays data of User A initially.\n\n### Expected Behavior:\nUpon logging in, User B should immediately see their own data, without any remnants of User A's session data appearing.	error	6	2023-09-22 00:00:00-06	\N	1	2023-09-21 12:32:28.005297-06	2023-09-21 13:14:11.262035-06	4	2	12	1	\N	4	1
10	📄 Files	- [ ] Users should be able to download a file.\n- [ ] The backend should facilitate this by providing the required key/path for the file stored in COS.	warning	3	2023-09-21 00:00:00-06	2023-09-23 00:00:00-06	1	2023-09-21 13:06:22.714688-06	2023-09-21 13:15:03.04562-06	4	4	11	2	7	4	7
12	Welcome	Welcome	success	1	\N	\N	1	2023-09-21 14:18:41.725782-06	2023-09-21 14:18:41.725838-06	\N	4	13	\N	\N	5	1
\.


--
-- Data for Name: api_issues_attention; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_issues_attention (id, issues_id, profile_id) FROM stdin;
1	2	1
2	4	2
3	5	2
4	5	4
5	11	2
\.


--
-- Data for Name: api_issuesreply; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_issuesreply (id, reply_type, content, create_datetime, creator_id, issues_id, reply_id) FROM stdin;
1	1	subject was updated from "好饿呀" to "好饿呀111";\npriority was updated from High to Low;\nstatus was updated from New to Ignored	2023-09-19 01:39:10.659352-06	1	1	\N
2	1	module was updated from None to Demo System	2023-09-21 12:35:33.234795-06	2	4	\N
3	1	subject was updated from "📂 Folders" to "📂 Folders --  Creation and Management:";\npriority was updated from High to Medium;\nstart_date was updated from "None" to "2023-09-26"	2023-09-21 12:44:58.813069-06	2	7	\N
4	1	issues_type was updated from Bug to Feature	2023-09-21 12:46:55.870793-06	2	8	\N
5	1	assign was updated from None to Demo;\nattention was updated from None to Demo	2023-09-21 12:48:26.250144-06	2	5	\N
6	1	status was updated from Awaiting Feedback to Ignored	2023-09-21 12:50:17.708537-06	2	5	\N
7	1	status was updated from New to In Progress;\nassign was updated from None to shiguo	2023-09-21 13:02:20.183073-06	4	4	\N
9	1	subject was updated from "Instant Access" to "Demo User Instant Access";\nstatus was updated from Ignored to Awaiting Feedback;\nassign was updated from Demo to shiguo;\nattention was updated from Demo to Demo, shiguo	2023-09-21 13:04:47.347555-06	4	5	\N
10	1	status was updated from In Progress to Closed	2023-09-21 13:08:41.235481-06	4	4	\N
11	1	priority was updated from Medium to Low	2023-09-21 13:12:02.278361-06	4	11	\N
12	2	Solved by clearing RTKQ cache before logging out.	2023-09-21 13:13:09.438804-06	4	4	10
13	1	subject was updated from "Demo User Instant Access" to "Demo User -- Instant Access"	2023-09-21 13:13:38.88813-06	4	5	\N
14	1	subject was updated from "Data Persistence Issue Across Different User Sessions in RTK Query" to "Data Persistence Across Different User Sessions"	2023-09-21 13:14:11.268656-06	4	4	\N
15	1	status was updated from In Progress to Resolved	2023-09-21 13:15:03.050753-06	4	10	\N
\.


--
-- Data for Name: api_issuestype; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_issuestype (id, title, project_id) FROM stdin;
1	Task	1
2	Feature	1
3	Bug	1
4	Task	2
5	Feature	2
6	Bug	2
7	Task	3
8	Feature	3
9	Bug	3
10	Task	4
11	Feature	4
12	Bug	4
13	Task	5
14	Feature	5
15	Bug	5
\.


--
-- Data for Name: api_module; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_module (id, title, project_id) FROM stdin;
1	Demo System	4
2	File System	4
\.


--
-- Data for Name: api_pricepolicy; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_pricepolicy (id, category, title, price, project_num, project_member, project_space, per_file_size, create_datetime) FROM stdin;
1	1	Free	0	3	2	5	5	2023-09-19 01:36:30.436007-06
\.


--
-- Data for Name: api_profile; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_profile (user_id, avatar, price_policy_id) FROM stdin;
1	5	1
3	1	1
2	6	1
4	1	1
\.


--
-- Data for Name: api_project; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_project (id, name, color, "desc", use_space, star, join_count, create_datetime, creator_id, next_issue_id) FROM stdin;
1	Issues	5	123	18529	f	1	2023-09-19 01:38:37.846656-06	1	4
2	Test	2	New Project in publc	0	f	1	2023-09-20 00:22:30.709888-06	1	1
3	123	4	444	0	f	1	2023-09-20 18:04:12.55128-06	3	1
5	Welcome to Tracer	3	Click the bottom right button in the card to explore	0	f	2	2023-09-21 14:18:14.805663-06	4	2
4	Issue Tracker	5	React-based Issue Tracker with DRF backend. Features: Cloud Object Storage, hierarchical document management, and efficient issue tracking.	11914	f	2	2023-09-20 20:59:32.269606-06	2	9
\.


--
-- Data for Name: api_projectinvite; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_projectinvite (id, code, count, use_count, period, create_datetime, creator_id, project_id) FROM stdin;
1	de4a3431-50d5-4f12-a860-a2f38f07df06	\N	0	1440	2023-09-21 12:52:51.345831-06	2	4
2	efe5951c-cfb7-4a22-ae21-381f4f41d925	\N	0	1440	2023-09-21 14:19:10.24972-06	4	5
\.


--
-- Data for Name: api_projectuser; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_projectuser (id, star, create_datetime, project_id, user_id) FROM stdin;
1	f	2023-09-21 12:58:19.16007-06	4	4
2	t	2023-09-21 14:19:33.11483-06	5	2
\.


--
-- Data for Name: api_wiki; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.api_wiki (id, title, content, depth, parent_id, project_id) FROM stdin;
1	1234	5555	1	\N	1
4	Key Features	### Key Features:\n\n1. **Instant Access**: Users should be able to access the demo without any registration process.\n\n2. **Pristine Database**: Each demo user should experience a clean, predefined database state.\n\n3. **Isolation**: Demo users' actions should not affect the real users or other demo users.\n\n4. **Auto-Reset**: Once a demo session ends (either by explicit logout or token expiration), the database state should reset to its original pristine state.\n\n5. File System Management\n\n   :\n\n   - Clean up any files the demo user uploaded during their session.\n   - Maintain a set of predefined files for demo purposes. If a demo user deletes any of these files, the system should detect this and ensure they are re-uploaded for the next session.\n\n### Detailed Requirements:\n\n#### 1. Instant Access:\n\n- Implement a dedicated "Try as Demo User" button or link on the login page.\n\n#### 2. Pristine Database:\n\n- Use PostgreSQL's schema capability to create an isolated environment for each demo user.\n- Pre-populate this schema with sample data to ensure the demo user has content to interact with from the start.\n\n#### 3. Isolation:\n\n- Ensure that the actions performed by a demo user (adding, editing, or deleting records) do not affect other schemas or the main application database.\n- Utilize JWT and manage database connections to direct all demo session queries to the appropriate schema in PostgreSQL.\n\n#### 4. Auto-Reset:\n\n- Implement a mechanism using Redis to manage and detect the end of a demo session. Utilize JWT as a unique identifier for each session. This approach should specifically cater to demo users without affecting regular users. Termination of a demo session can be identified either through a logout action or upon the expiration of Redis TTL (Time-To-Live).\n\n- Upon a new demo user's login, check Redis for available demo-user schemas (e.g., demo-user-1). If a schema is not currently in use (not marked as True), allocate that schema for the incoming demo user. Prior to the user's interaction, reset the corresponding database schema to ensure a fresh environment. This is accomplished by dropping and recreating the schema.\n\n#### 5. File System Management:\n\n- Track all files uploaded by a demo user during their session.\n- After the session ends, ensure all uploaded files are deleted from AWS cloud storage.\n- Maintain a set of predefined demo files:\n  - Check the existence of these files at the end of each session.\n  - If any are missing, re-upload them to ensure they are available for the next demo user.	2	2	4
5	File System	## 📁 File Repository System\n\n### 🌐 Overview\n\nThe File Repository System allows users to manage files and folders within a specified project. It facilitates the creation, update, and deletion of both files and folders.\n\n### 🛠 Model Definition\n\n#### 📝 FileRepository Model\n\n`project`: A reference to the associated project.\n\n`file_type`: Type of the repository item - can be a file or a folder.\n\n`name`: The name of the file or folder.\n\n`key`: The key under which the file is stored in COS (Cloud Object Storage).\n\n`file_size`: The size of the file (in bytes).\n\n`file_path`: The path where the file is stored in COS.\n\n`parent`: The parent directory of the file or folder (if it resides inside another folder).\n\n`update_user`: The user who last updated the file or folder.\n\n`update_datetime`: The timestamp when the file or folder was last updated.	1	\N	4
2	Demo User System	## Demo User Feature - Requirements Document\n\n### Objective:\n\nTo provide a seamless experience for potential users by offering a "Demo User" feature. This allows users to explore the system without the need for registration, ensuring they experience a pristine environment that's isolated from other users.	1	\N	4
6	📋 Folder Requirements	#### 📂 Folders:\n\n##### Frontend:\n\n1. **Display and Navigation**:\n   - [x] Show breadcrumbs to allow users to quickly navigate their file hierarchy.\n   - [x] Display a list view of the folders and files.\n   - [x] Show data sizes of files/folders.\n   - [x] Display the last updated date&users for each item.\n   \n2. **Actions**:\n   - [x] Provide an edit button for renaming and managing folder contents.\n   - [x] Provide a delete button for folders.\n   - [x] Upon clicking the delete button, a confirmation dialog should pop up to warn users about the deletion.\n\n##### Backend:\n\n1. **Creation and Management**:\n   - [x] Users should be able to create new folders within a specified project.\n   - [x] Users should be able to enter and manage the contents of a folder.\n   \n2. **Renaming**:\n   - [x] Users should be able to rename a folder.\n   \n3. **Deletion**:\n   - [x] Users should be able to delete a folder.\n   - [x] Upon deletion of a folder, all its contents (files and sub-folders) should also be deleted from the database.\n   - [x] Ensure that files associated with a deleted folder are also removed from cloud storage.	2	5	4
3	Database Choice	## Database Choices\n\n<div style="display: flex; justify-content: space-between;">\n    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Sqlite-square-icon.svg/2048px-Sqlite-square-icon.svg.png" alt="SQLite Logo" style="width:30%; margin-right: 5%;">\n    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Postgresql_elephant.svg/1200px-Postgresql_elephant.svg.png" alt="PostgreSQL Logo" style="width:30%;">\n</div>\n\n**SQLite**, while lightweight and excellent for development, has certain limitations when it comes to more complex features like handling dynamic databases or schemas. This challenge arises specifically when trying to provide isolated environments for multiple demo users. \n\n**PostgreSQL** offers a robust solution through its support for multiple schemas within a single database.\n\n## Why Migrate from SQLite to PostgreSQL?\n\n1. **Scalability**: PostgreSQL can handle larger datasets and concurrent users more efficiently.\n2. **Dynamic Schemas**: PostgreSQL supports multiple schemas in a single database, ideal for isolating demo user data.\n3. **Advanced Features**: PostgreSQL offers a broader set of features, including advanced indexing, full-text search, and more.\n4. **Production Ready**: While SQLite is great for development, PostgreSQL is more suited for production environments, especially when scaling is a concern.	2	2	4
7	📄 Files Requirements	#### 📄 Files:\n\n1. **Upload**:\n   - [x] Users should request temporary credentials from the backend for uploading files.\n   - [x] Upon successful file upload to COS, users should send a POST request to the backend, notifying of the successful upload and providing file details like size, name, path, etc. for storage in the database.\n\n2. **Download**:\n   - [x] Users should be able to download a file.\n   - [x] The backend should facilitate this by providing the required key/path for the file stored in COS.\n\n3. **Deletion**:\n   - [x] Users should be able to delete a file.\n   - [x] The backend should ensure the file is removed from both the database and the storage solution (like COS).	2	5	4
8	📌 Implementation Notes	📌 Implementation Notes\n\n- [x] The system should ensure that proper permissions are checked before allowing any file or folder operations.\n- [x] For performance considerations, the system should avoid making redundant calls to the database.\n- [ ] Error handling should be robust to guide users in case of any issues during file/folder operations.	3	6	4
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add Token	7	add_token
26	Can change Token	7	change_token
27	Can delete Token	7	delete_token
28	Can view Token	7	view_token
29	Can add token	8	add_tokenproxy
30	Can change token	8	change_tokenproxy
31	Can delete token	8	delete_tokenproxy
32	Can view token	8	view_tokenproxy
33	Can add price policy	9	add_pricepolicy
34	Can change price policy	9	change_pricepolicy
35	Can delete price policy	9	delete_pricepolicy
36	Can view price policy	9	view_pricepolicy
37	Can add profile	10	add_profile
38	Can change profile	10	change_profile
39	Can delete profile	10	delete_profile
40	Can view profile	10	view_profile
41	Can add project	11	add_project
42	Can change project	11	change_project
43	Can delete project	11	delete_project
44	Can view project	11	view_project
45	Can add wiki	12	add_wiki
46	Can change wiki	12	change_wiki
47	Can delete wiki	12	delete_wiki
48	Can view wiki	12	view_wiki
49	Can add project user	13	add_projectuser
50	Can change project user	13	change_projectuser
51	Can delete project user	13	delete_projectuser
52	Can view project user	13	view_projectuser
53	Can add file repository	14	add_filerepository
54	Can change file repository	14	change_filerepository
55	Can delete file repository	14	delete_filerepository
56	Can view file repository	14	view_filerepository
57	Can add issues	15	add_issues
58	Can change issues	15	change_issues
59	Can delete issues	15	delete_issues
60	Can view issues	15	view_issues
61	Can add module	16	add_module
62	Can change module	16	change_module
63	Can delete module	16	delete_module
64	Can view module	16	view_module
65	Can add issues type	17	add_issuestype
66	Can change issues type	17	change_issuestype
67	Can delete issues type	17	delete_issuestype
68	Can view issues type	17	view_issuestype
69	Can add issues reply	18	add_issuesreply
70	Can change issues reply	18	change_issuesreply
71	Can delete issues reply	18	delete_issuesreply
72	Can view issues reply	18	view_issuesreply
73	Can add project invite	19	add_projectinvite
74	Can change project invite	19	change_projectinvite
75	Can delete project invite	19	delete_projectinvite
76	Can view project invite	19	view_projectinvite
77	Can add demo user status	20	add_demouserstatus
78	Can change demo user status	20	change_demouserstatus
79	Can delete demo user status	20	delete_demouserstatus
80	Can view demo user status	20	view_demouserstatus
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$260000$HbsoSfFw8YnUdokfSyFMEF$6COJLUkzM+Dhod/hPz6bJJF5Y6h+PSWnDji4R/Atwuw=	\N	f	jerry001			lambert1006@outlook.com	f	t	2023-09-19 01:38:17.053605-06
2	pbkdf2_sha256$260000$9R9Tj5V7ZuY1lCRo7U9YF8$urTIwgLS3+7jLZUL2oz01d3wTMIiQ84It+/uympgejM=	\N	f	Demo			shiguo@ualberta.ca	f	t	2023-09-19 18:09:09.461375-06
3	pbkdf2_sha256$260000$9otooS5jUMM1lXpNntOsrL$sJ3sK+9Y7L2FiXT50M9/TU6S5y3IMRbYnl2HU4sXOFE=	\N	f	jerry002			lambert1006@outlook.com	f	t	2023-09-20 18:03:50.717777-06
4	pbkdf2_sha256$260000$b6g3c1O27hV7lSCWuwVoAH$wLEQvXSFbQyXqwafqNSrP+ka1Hp53albHLNSBftt76k=	\N	f	shiguo			shiguo@ualberta.ca	f	t	2023-09-21 12:57:57.013608-06
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.authtoken_token (key, created, user_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	authtoken	token
8	authtoken	tokenproxy
9	api	pricepolicy
10	api	profile
11	api	project
12	api	wiki
13	api	projectuser
14	api	filerepository
15	api	issues
16	api	module
17	api	issuestype
18	api	issuesreply
19	api	projectinvite
20	api	demouserstatus
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2023-09-19 01:26:41.088363-06
2	auth	0001_initial	2023-09-19 01:26:41.17146-06
3	admin	0001_initial	2023-09-19 01:26:41.183162-06
4	admin	0002_logentry_remove_auto_add	2023-09-19 01:26:41.188064-06
5	admin	0003_logentry_add_action_flag_choices	2023-09-19 01:26:41.192567-06
6	contenttypes	0002_remove_content_type_name	2023-09-19 01:26:41.205039-06
7	auth	0002_alter_permission_name_max_length	2023-09-19 01:26:41.209638-06
8	auth	0003_alter_user_email_max_length	2023-09-19 01:26:41.214412-06
9	auth	0004_alter_user_username_opts	2023-09-19 01:26:41.218621-06
10	auth	0005_alter_user_last_login_null	2023-09-19 01:26:41.223143-06
11	auth	0006_require_contenttypes_0002	2023-09-19 01:26:41.22473-06
12	auth	0007_alter_validators_add_error_messages	2023-09-19 01:26:41.228789-06
13	auth	0008_alter_user_username_max_length	2023-09-19 01:26:41.237668-06
14	auth	0009_alter_user_last_name_max_length	2023-09-19 01:26:41.242423-06
15	auth	0010_alter_group_name_max_length	2023-09-19 01:26:41.249641-06
16	auth	0011_update_proxy_permissions	2023-09-19 01:26:41.254398-06
17	auth	0012_alter_user_first_name_max_length	2023-09-19 01:26:41.259506-06
18	api	0001_initial	2023-09-19 01:26:41.310648-06
19	api	0002_filerepository	2023-09-19 01:26:41.325653-06
20	api	0003_auto_20230821_1916	2023-09-19 01:26:41.426123-06
21	api	0004_auto_20230822_0347	2023-09-19 01:26:41.437532-06
22	api	0005_auto_20230822_2245	2023-09-19 01:26:41.54245-06
23	api	0006_auto_20230824_0623	2023-09-19 01:26:41.56059-06
24	api	0007_auto_20230824_2151	2023-09-19 01:26:41.589039-06
25	api	0008_auto_20230827_0227	2023-09-19 01:26:41.62908-06
26	api	0009_auto_20230830_2257	2023-09-19 01:26:41.652212-06
27	api	0010_alter_profile_avatar	2023-09-19 01:26:41.664977-06
28	api	0011_auto_20230907_0408	2023-09-19 01:26:41.827329-06
29	api	0012_demouserstatus	2023-09-19 01:26:41.837096-06
30	api	0013_auto_20230918_0445	2023-09-19 01:26:41.849083-06
31	api	0014_demouserstatus_db_file	2023-09-19 01:26:41.858534-06
32	authtoken	0001_initial	2023-09-19 01:26:41.873908-06
33	authtoken	0002_auto_20160226_1747	2023-09-19 01:26:41.890117-06
34	authtoken	0003_tokenproxy	2023-09-19 01:26:41.892506-06
35	sessions	0001_initial	2023-09-19 01:26:41.901724-06
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: tracer_api
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Name: api_demouserstatus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_demouserstatus_id_seq', 1, false);


--
-- Name: api_filerepository_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_filerepository_id_seq', 10, true);


--
-- Name: api_issues_attention_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_issues_attention_id_seq', 5, true);


--
-- Name: api_issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_issues_id_seq', 12, true);


--
-- Name: api_issuesreply_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_issuesreply_id_seq', 15, true);


--
-- Name: api_issuestype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_issuestype_id_seq', 15, true);


--
-- Name: api_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_module_id_seq', 2, true);


--
-- Name: api_pricepolicy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_pricepolicy_id_seq', 1, true);


--
-- Name: api_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_project_id_seq', 5, true);


--
-- Name: api_projectinvite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_projectinvite_id_seq', 2, true);


--
-- Name: api_projectuser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_projectuser_id_seq', 2, true);


--
-- Name: api_wiki_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.api_wiki_id_seq', 8, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 80, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 4, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 20, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tracer_api
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 35, true);


--
-- Name: api_demouserstatus api_demouserstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_demouserstatus
    ADD CONSTRAINT api_demouserstatus_pkey PRIMARY KEY (id);


--
-- Name: api_demouserstatus api_demouserstatus_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_demouserstatus
    ADD CONSTRAINT api_demouserstatus_profile_id_key UNIQUE (profile_id);


--
-- Name: api_filerepository api_filerepository_name_project_id_parent_id_ad6b6dce_uniq; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_filerepository
    ADD CONSTRAINT api_filerepository_name_project_id_parent_id_ad6b6dce_uniq UNIQUE (name, project_id, parent_id);


--
-- Name: api_filerepository api_filerepository_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_filerepository
    ADD CONSTRAINT api_filerepository_pkey PRIMARY KEY (id);


--
-- Name: api_issues_attention api_issues_attention_issues_id_profile_id_3a56aa05_uniq; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues_attention
    ADD CONSTRAINT api_issues_attention_issues_id_profile_id_3a56aa05_uniq UNIQUE (issues_id, profile_id);


--
-- Name: api_issues_attention api_issues_attention_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues_attention
    ADD CONSTRAINT api_issues_attention_pkey PRIMARY KEY (id);


--
-- Name: api_issues api_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues
    ADD CONSTRAINT api_issues_pkey PRIMARY KEY (id);


--
-- Name: api_issuesreply api_issuesreply_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issuesreply
    ADD CONSTRAINT api_issuesreply_pkey PRIMARY KEY (id);


--
-- Name: api_issuestype api_issuestype_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issuestype
    ADD CONSTRAINT api_issuestype_pkey PRIMARY KEY (id);


--
-- Name: api_module api_module_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_module
    ADD CONSTRAINT api_module_pkey PRIMARY KEY (id);


--
-- Name: api_pricepolicy api_pricepolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_pricepolicy
    ADD CONSTRAINT api_pricepolicy_pkey PRIMARY KEY (id);


--
-- Name: api_profile api_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_profile
    ADD CONSTRAINT api_profile_pkey PRIMARY KEY (user_id);


--
-- Name: api_project api_project_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_project
    ADD CONSTRAINT api_project_pkey PRIMARY KEY (id);


--
-- Name: api_projectinvite api_projectinvite_code_key; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectinvite
    ADD CONSTRAINT api_projectinvite_code_key UNIQUE (code);


--
-- Name: api_projectinvite api_projectinvite_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectinvite
    ADD CONSTRAINT api_projectinvite_pkey PRIMARY KEY (id);


--
-- Name: api_projectuser api_projectuser_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectuser
    ADD CONSTRAINT api_projectuser_pkey PRIMARY KEY (id);


--
-- Name: api_wiki api_wiki_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_wiki
    ADD CONSTRAINT api_wiki_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: api_filerepository_parent_id_5c7700d0; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_filerepository_parent_id_5c7700d0 ON public.api_filerepository USING btree (parent_id);


--
-- Name: api_filerepository_project_id_725510ca; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_filerepository_project_id_725510ca ON public.api_filerepository USING btree (project_id);


--
-- Name: api_filerepository_update_user_id_1b79081b; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_filerepository_update_user_id_1b79081b ON public.api_filerepository USING btree (update_user_id);


--
-- Name: api_issues_assign_id_796dea5b; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issues_assign_id_796dea5b ON public.api_issues USING btree (assign_id);


--
-- Name: api_issues_attention_issues_id_7dc21606; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issues_attention_issues_id_7dc21606 ON public.api_issues_attention USING btree (issues_id);


--
-- Name: api_issues_attention_profile_id_9eba70b1; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issues_attention_profile_id_9eba70b1 ON public.api_issues_attention USING btree (profile_id);


--
-- Name: api_issues_creator_id_1143e3ec; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issues_creator_id_1143e3ec ON public.api_issues USING btree (creator_id);


--
-- Name: api_issues_issues_type_id_f545bbf0; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issues_issues_type_id_f545bbf0 ON public.api_issues USING btree (issues_type_id);


--
-- Name: api_issues_module_id_334655fc; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issues_module_id_334655fc ON public.api_issues USING btree (module_id);


--
-- Name: api_issues_parent_id_3a0ba721; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issues_parent_id_3a0ba721 ON public.api_issues USING btree (parent_id);


--
-- Name: api_issues_project_id_383bffc2; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issues_project_id_383bffc2 ON public.api_issues USING btree (project_id);


--
-- Name: api_issuesreply_creator_id_cc414ada; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issuesreply_creator_id_cc414ada ON public.api_issuesreply USING btree (creator_id);


--
-- Name: api_issuesreply_issues_id_7dd8e3e3; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issuesreply_issues_id_7dd8e3e3 ON public.api_issuesreply USING btree (issues_id);


--
-- Name: api_issuesreply_reply_id_b1905c8c; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issuesreply_reply_id_b1905c8c ON public.api_issuesreply USING btree (reply_id);


--
-- Name: api_issuestype_project_id_e9c54757; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_issuestype_project_id_e9c54757 ON public.api_issuestype USING btree (project_id);


--
-- Name: api_module_project_id_528bc9a0; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_module_project_id_528bc9a0 ON public.api_module USING btree (project_id);


--
-- Name: api_profile_price_policy_id_5ef95bc1; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_profile_price_policy_id_5ef95bc1 ON public.api_profile USING btree (price_policy_id);


--
-- Name: api_project_creator_id_808a1344; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_project_creator_id_808a1344 ON public.api_project USING btree (creator_id);


--
-- Name: api_projectinvite_code_86860177_like; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_projectinvite_code_86860177_like ON public.api_projectinvite USING btree (code varchar_pattern_ops);


--
-- Name: api_projectinvite_creator_id_a78aa716; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_projectinvite_creator_id_a78aa716 ON public.api_projectinvite USING btree (creator_id);


--
-- Name: api_projectinvite_project_id_7a1cb799; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_projectinvite_project_id_7a1cb799 ON public.api_projectinvite USING btree (project_id);


--
-- Name: api_projectuser_project_id_9032bad3; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_projectuser_project_id_9032bad3 ON public.api_projectuser USING btree (project_id);


--
-- Name: api_projectuser_user_id_e7468668; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_projectuser_user_id_e7468668 ON public.api_projectuser USING btree (user_id);


--
-- Name: api_wiki_parent_id_4d5fb7fa; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_wiki_parent_id_4d5fb7fa ON public.api_wiki USING btree (parent_id);


--
-- Name: api_wiki_project_id_0004abf3; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX api_wiki_project_id_0004abf3 ON public.api_wiki USING btree (project_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: tracer_api
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: api_demouserstatus api_demouserstatus_profile_id_f11df217_fk_api_profile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_demouserstatus
    ADD CONSTRAINT api_demouserstatus_profile_id_f11df217_fk_api_profile_user_id FOREIGN KEY (profile_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_filerepository api_filerepository_parent_id_5c7700d0_fk_api_filerepository_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_filerepository
    ADD CONSTRAINT api_filerepository_parent_id_5c7700d0_fk_api_filerepository_id FOREIGN KEY (parent_id) REFERENCES public.api_filerepository(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_filerepository api_filerepository_project_id_725510ca_fk_api_project_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_filerepository
    ADD CONSTRAINT api_filerepository_project_id_725510ca_fk_api_project_id FOREIGN KEY (project_id) REFERENCES public.api_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_filerepository api_filerepository_update_user_id_1b79081b_fk_api_profi; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_filerepository
    ADD CONSTRAINT api_filerepository_update_user_id_1b79081b_fk_api_profi FOREIGN KEY (update_user_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issues api_issues_assign_id_796dea5b_fk_api_profile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues
    ADD CONSTRAINT api_issues_assign_id_796dea5b_fk_api_profile_user_id FOREIGN KEY (assign_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issues_attention api_issues_attention_issues_id_7dc21606_fk_api_issues_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues_attention
    ADD CONSTRAINT api_issues_attention_issues_id_7dc21606_fk_api_issues_id FOREIGN KEY (issues_id) REFERENCES public.api_issues(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issues_attention api_issues_attention_profile_id_9eba70b1_fk_api_profile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues_attention
    ADD CONSTRAINT api_issues_attention_profile_id_9eba70b1_fk_api_profile_user_id FOREIGN KEY (profile_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issues api_issues_creator_id_1143e3ec_fk_api_profile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues
    ADD CONSTRAINT api_issues_creator_id_1143e3ec_fk_api_profile_user_id FOREIGN KEY (creator_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issues api_issues_issues_type_id_f545bbf0_fk_api_issuestype_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues
    ADD CONSTRAINT api_issues_issues_type_id_f545bbf0_fk_api_issuestype_id FOREIGN KEY (issues_type_id) REFERENCES public.api_issuestype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issues api_issues_module_id_334655fc_fk_api_module_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues
    ADD CONSTRAINT api_issues_module_id_334655fc_fk_api_module_id FOREIGN KEY (module_id) REFERENCES public.api_module(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issues api_issues_parent_id_3a0ba721_fk_api_issues_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues
    ADD CONSTRAINT api_issues_parent_id_3a0ba721_fk_api_issues_id FOREIGN KEY (parent_id) REFERENCES public.api_issues(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issues api_issues_project_id_383bffc2_fk_api_project_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issues
    ADD CONSTRAINT api_issues_project_id_383bffc2_fk_api_project_id FOREIGN KEY (project_id) REFERENCES public.api_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issuesreply api_issuesreply_creator_id_cc414ada_fk_api_profile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issuesreply
    ADD CONSTRAINT api_issuesreply_creator_id_cc414ada_fk_api_profile_user_id FOREIGN KEY (creator_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issuesreply api_issuesreply_issues_id_7dd8e3e3_fk_api_issues_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issuesreply
    ADD CONSTRAINT api_issuesreply_issues_id_7dd8e3e3_fk_api_issues_id FOREIGN KEY (issues_id) REFERENCES public.api_issues(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issuesreply api_issuesreply_reply_id_b1905c8c_fk_api_issuesreply_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issuesreply
    ADD CONSTRAINT api_issuesreply_reply_id_b1905c8c_fk_api_issuesreply_id FOREIGN KEY (reply_id) REFERENCES public.api_issuesreply(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_issuestype api_issuestype_project_id_e9c54757_fk_api_project_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_issuestype
    ADD CONSTRAINT api_issuestype_project_id_e9c54757_fk_api_project_id FOREIGN KEY (project_id) REFERENCES public.api_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_module api_module_project_id_528bc9a0_fk_api_project_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_module
    ADD CONSTRAINT api_module_project_id_528bc9a0_fk_api_project_id FOREIGN KEY (project_id) REFERENCES public.api_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_profile api_profile_price_policy_id_5ef95bc1_fk_api_pricepolicy_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_profile
    ADD CONSTRAINT api_profile_price_policy_id_5ef95bc1_fk_api_pricepolicy_id FOREIGN KEY (price_policy_id) REFERENCES public.api_pricepolicy(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_profile api_profile_user_id_41309820_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_profile
    ADD CONSTRAINT api_profile_user_id_41309820_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_project api_project_creator_id_808a1344_fk_api_profile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_project
    ADD CONSTRAINT api_project_creator_id_808a1344_fk_api_profile_user_id FOREIGN KEY (creator_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_projectinvite api_projectinvite_creator_id_a78aa716_fk_api_profile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectinvite
    ADD CONSTRAINT api_projectinvite_creator_id_a78aa716_fk_api_profile_user_id FOREIGN KEY (creator_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_projectinvite api_projectinvite_project_id_7a1cb799_fk_api_project_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectinvite
    ADD CONSTRAINT api_projectinvite_project_id_7a1cb799_fk_api_project_id FOREIGN KEY (project_id) REFERENCES public.api_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_projectuser api_projectuser_project_id_9032bad3_fk_api_project_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectuser
    ADD CONSTRAINT api_projectuser_project_id_9032bad3_fk_api_project_id FOREIGN KEY (project_id) REFERENCES public.api_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_projectuser api_projectuser_user_id_e7468668_fk_api_profile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_projectuser
    ADD CONSTRAINT api_projectuser_user_id_e7468668_fk_api_profile_user_id FOREIGN KEY (user_id) REFERENCES public.api_profile(user_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_wiki api_wiki_parent_id_4d5fb7fa_fk_api_wiki_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_wiki
    ADD CONSTRAINT api_wiki_parent_id_4d5fb7fa_fk_api_wiki_id FOREIGN KEY (parent_id) REFERENCES public.api_wiki(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_wiki api_wiki_project_id_0004abf3_fk_api_project_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.api_wiki
    ADD CONSTRAINT api_wiki_project_id_0004abf3_fk_api_project_id FOREIGN KEY (project_id) REFERENCES public.api_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: tracer_api
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

