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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_migrations (
    version character varying NOT NULL
);


--
-- Name: event_organizers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_organizers (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: event_organizers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_organizers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_organizers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_organizers_id_seq OWNED BY public.event_organizers.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    title character varying NOT NULL,
    description text NOT NULL,
    start_time timestamp(6) without time zone NOT NULL,
    end_time timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_rails_2d23c98cce CHECK (((end_time IS NULL) OR (end_time > start_time)))
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: offline_meetings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offline_meetings (
    id bigint NOT NULL,
    title character varying NOT NULL,
    start_time timestamp(6) without time zone NOT NULL,
    end_time timestamp(6) without time zone,
    event_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_rails_538f471a96 CHECK (((end_time IS NULL) OR (end_time > start_time)))
);


--
-- Name: offline_meetings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offline_meetings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offline_meetings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offline_meetings_id_seq OWNED BY public.offline_meetings.id;


--
-- Name: online_meetings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.online_meetings (
    id bigint NOT NULL,
    title character varying NOT NULL,
    start_time timestamp(6) without time zone NOT NULL,
    end_time timestamp(6) without time zone,
    event_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_rails_d12176be61 CHECK (((end_time IS NULL) OR (end_time > start_time)))
);


--
-- Name: online_meetings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.online_meetings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: online_meetings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.online_meetings_id_seq OWNED BY public.online_meetings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    full_name character varying GENERATED ALWAYS AS (((TRIM(BOTH FROM first_name) || ' '::text) || TRIM(BOTH FROM last_name))) STORED,
    status smallint DEFAULT 0 NOT NULL,
    archival_reason text,
    preferences jsonb DEFAULT '{}'::jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: event_organizers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_organizers ALTER COLUMN id SET DEFAULT nextval('public.event_organizers_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: offline_meetings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_meetings ALTER COLUMN id SET DEFAULT nextval('public.offline_meetings_id_seq'::regclass);


--
-- Name: online_meetings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.online_meetings ALTER COLUMN id SET DEFAULT nextval('public.online_meetings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (version);


--
-- Name: event_organizers event_organizers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_organizers
    ADD CONSTRAINT event_organizers_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: offline_meetings offline_meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_meetings
    ADD CONSTRAINT offline_meetings_pkey PRIMARY KEY (id);


--
-- Name: online_meetings online_meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.online_meetings
    ADD CONSTRAINT online_meetings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_event_organizers_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_organizers_on_event_id ON public.event_organizers USING btree (event_id);


--
-- Name: index_event_organizers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_organizers_on_user_id ON public.event_organizers USING btree (user_id);


--
-- Name: index_event_organizers_on_user_id_and_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_event_organizers_on_user_id_and_event_id ON public.event_organizers USING btree (user_id, event_id);


--
-- Name: index_events_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_start_time ON public.events USING btree (start_time);


--
-- Name: index_offline_meetings_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offline_meetings_on_event_id ON public.offline_meetings USING btree (event_id);


--
-- Name: index_offline_meetings_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offline_meetings_on_start_time ON public.offline_meetings USING btree (start_time);


--
-- Name: index_on_users_fulltext_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_users_fulltext_search ON public.users USING gin ((((lower((full_name)::text) || ' '::text) || lower((email)::text))) public.gin_trgm_ops);


--
-- Name: index_online_meetings_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_online_meetings_on_event_id ON public.online_meetings USING btree (event_id);


--
-- Name: index_online_meetings_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_online_meetings_on_start_time ON public.online_meetings USING btree (start_time);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_email_lower; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email_lower ON public.users USING btree (lower((email)::text));


--
-- Name: index_users_on_full_name_lower; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_full_name_lower ON public.users USING btree (lower((full_name)::text));


--
-- Name: offline_meetings fk_rails_48c6c7bedf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_meetings
    ADD CONSTRAINT fk_rails_48c6c7bedf FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: event_organizers fk_rails_b1c2c61554; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_organizers
    ADD CONSTRAINT fk_rails_b1c2c61554 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: event_organizers fk_rails_c1e082c91e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_organizers
    ADD CONSTRAINT fk_rails_c1e082c91e FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: online_meetings fk_rails_fe030377eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.online_meetings
    ADD CONSTRAINT fk_rails_fe030377eb FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20241001203231'),
('20241001203225'),
('20241001203219'),
('20241001203203'),
('20240905145741'),
('20240905145657'),
('20240905105914');

