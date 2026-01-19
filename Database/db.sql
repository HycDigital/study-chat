-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.chat_quizzes (
  quiz_json jsonb NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  id bigint NOT NULL DEFAULT nextval('chat_quizzes_id_seq'::regclass),
  chat_id bigint NOT NULL,
  CONSTRAINT chat_quizzes_pkey PRIMARY KEY (id),
  CONSTRAINT fk_chat_quiz_chat FOREIGN KEY (chat_id) REFERENCES public.chats(id)
);
CREATE TABLE public.chat_summaries (
  summary_text text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  id bigint NOT NULL DEFAULT nextval('chat_summaries_id_seq'::regclass),
  chat_id bigint NOT NULL,
  CONSTRAINT chat_summaries_pkey PRIMARY KEY (id),
  CONSTRAINT fk_chat_summary_chat FOREIGN KEY (chat_id) REFERENCES public.chats(id)
);
CREATE TABLE public.chats (
  name text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  id bigint NOT NULL DEFAULT nextval('chats_id_seq'::regclass),
  user_id bigint NOT NULL,
  session_id bigint,
  CONSTRAINT chats_pkey PRIMARY KEY (id),
  CONSTRAINT chats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT chats_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id)
);
CREATE TABLE public.customize (
  id bigint NOT NULL DEFAULT nextval('customize_id_seq'::regclass),
  user_id bigint NOT NULL UNIQUE,
  text character varying NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT customize_pkey PRIMARY KEY (id),
  CONSTRAINT fk_customize_user FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.messages (
  id bigint NOT NULL DEFAULT nextval('messages_id_seq'::regclass),
  content text NOT NULL,
  tool_tag text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  sender_id bigint,
  chat_id bigint NOT NULL,
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id)
);
CREATE TABLE public.sessions (
  title text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  ended_at timestamp with time zone,
  id bigint NOT NULL DEFAULT nextval('sessions_id_seq'::regclass),
  user_id bigint,
  session_id character varying NOT NULL UNIQUE,
  ip_address character varying,
  user_agent character varying,
  last_accessed_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT sessions_pkey PRIMARY KEY (id),
  CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.users (
  full_name text,
  email text UNIQUE,
  profile_image_path text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  password_hash text,
  google_sub text,
  email_verified boolean NOT NULL DEFAULT false,
  last_login_at timestamp with time zone,
  is_active boolean NOT NULL DEFAULT true,
  id bigint NOT NULL DEFAULT nextval('users_id_seq'::regclass),
  auth_provider character varying NOT NULL DEFAULT 'local'::character varying,
  CONSTRAINT users_pkey PRIMARY KEY (id)
);
