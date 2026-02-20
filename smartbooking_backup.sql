--
-- PostgreSQL database dump
--

\restrict K7QeJ9yzsAbht4db7Fx36tL5POzSrelsCiC4KsXSTks3YmNa4SRfBCRxJoFm2ln

-- Dumped from database version 15.16 (Debian 15.16-1.pgdg13+1)
-- Dumped by pg_dump version 15.16 (Debian 15.16-1.pgdg13+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: MediaAsset; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public."MediaAsset" (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    folder character varying,
    storage_path character varying NOT NULL,
    url character varying NOT NULL,
    thumbnail_url character varying,
    filename character varying NOT NULL,
    original_filename character varying,
    mime_type character varying NOT NULL,
    size integer NOT NULL,
    width integer,
    height integer,
    asset_type character varying NOT NULL,
    tags character varying[] NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."MediaAsset" OWNER TO roompilot;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.accounts (
    id character varying NOT NULL,
    user_id character varying NOT NULL,
    type character varying NOT NULL,
    provider character varying NOT NULL,
    provider_account_id character varying NOT NULL,
    refresh_token character varying,
    access_token character varying,
    expires_at integer,
    token_type character varying,
    scope character varying,
    id_token character varying,
    session_state character varying
);


ALTER TABLE public.accounts OWNER TO roompilot;

--
-- Name: TABLE accounts; Type: COMMENT; Schema: public; Owner: roompilot
--

COMMENT ON TABLE public.accounts IS 'OAuth account links for users';


--
-- Name: activities; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.activities (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    name_translations json,
    description text,
    description_translations json,
    image character varying,
    price double precision,
    currency character varying NOT NULL,
    duration integer,
    location character varying,
    category character varying,
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.activities OWNER TO roompilot;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO roompilot;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.bookings (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    property_id character varying NOT NULL,
    room_id character varying,
    unit_id character varying,
    customer_id character varying,
    price_plan_id character varying,
    package_id character varying,
    guest_first_name character varying,
    guest_last_name character varying,
    guest_name character varying NOT NULL,
    guest_email character varying NOT NULL,
    guest_phone character varying,
    guest_country character varying,
    guest_county character varying,
    guest_city character varying,
    guest_address character varying,
    guest_cnp character varying,
    check_in timestamp without time zone NOT NULL,
    check_out timestamp without time zone NOT NULL,
    number_of_guests integer NOT NULL,
    status character varying NOT NULL,
    total_price double precision NOT NULL,
    advance_amount double precision,
    advance_required double precision,
    advance_paid boolean NOT NULL,
    notes text,
    invoice_number character varying,
    invoice_series_name character varying,
    invoice_link character varying,
    google_event_id character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    coupon_code character varying,
    coupon_discount double precision,
    short_booking_id character varying
);


ALTER TABLE public.bookings OWNER TO roompilot;

--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.campaigns (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    type character varying NOT NULL,
    status character varying NOT NULL,
    subject character varying,
    content text NOT NULL,
    template_id character varying,
    target_audience character varying NOT NULL,
    custom_filters text,
    scheduled_at timestamp without time zone,
    sent_at timestamp without time zone,
    total_recipients integer NOT NULL,
    delivered integer NOT NULL,
    opened integer NOT NULL,
    clicked integer NOT NULL,
    bounced integer NOT NULL,
    unsubscribed integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.campaigns OWNER TO roompilot;

--
-- Name: coupon_usages; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.coupon_usages (
    id character varying NOT NULL,
    coupon_id character varying NOT NULL,
    customer_id character varying NOT NULL,
    booking_id character varying,
    discount_amount double precision NOT NULL,
    original_amount double precision NOT NULL,
    final_amount double precision NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.coupon_usages OWNER TO roompilot;

--
-- Name: coupons; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.coupons (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    description character varying,
    type character varying NOT NULL,
    value double precision NOT NULL,
    min_amount double precision,
    max_discount double precision,
    usage_limit integer,
    usage_count integer NOT NULL,
    per_customer integer NOT NULL,
    valid_from timestamp without time zone NOT NULL,
    valid_until timestamp without time zone,
    applicable_units character varying[],
    customer_labels character varying[],
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.coupons OWNER TO roompilot;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.customers (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    email character varying,
    first_name character varying,
    last_name character varying,
    phone character varying,
    status character varying NOT NULL,
    labels character varying[],
    sources character varying[],
    email_opt_in boolean NOT NULL,
    sms_opt_in boolean NOT NULL,
    total_bookings integer NOT NULL,
    total_spent double precision NOT NULL,
    last_booking timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customers OWNER TO roompilot;

--
-- Name: demo_requests; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.demo_requests (
    id character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying NOT NULL,
    preferred_at timestamp without time zone NOT NULL,
    message text,
    status character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.demo_requests OWNER TO roompilot;

--
-- Name: domain_requests; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.domain_requests (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    domain character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    tenant_id_associated character varying,
    notes character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.domain_requests OWNER TO roompilot;

--
-- Name: email_templates; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.email_templates (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    type character varying NOT NULL,
    subject character varying NOT NULL,
    html_content text NOT NULL,
    text_content text,
    variables text,
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.email_templates OWNER TO roompilot;

--
-- Name: event_tickets; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.event_tickets (
    id character varying NOT NULL,
    event_id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    guest_name character varying NOT NULL,
    guest_email character varying NOT NULL,
    guest_phone character varying,
    quantity integer DEFAULT 1 NOT NULL,
    total_price numeric(10,2) NOT NULL,
    currency character varying DEFAULT 'RON'::character varying NOT NULL,
    ticket_code character varying NOT NULL,
    status character varying DEFAULT 'registered'::character varying NOT NULL,
    message text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.event_tickets OWNER TO roompilot;

--
-- Name: events; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.events (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    title character varying NOT NULL,
    description text,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone,
    location character varying,
    image character varying,
    category character varying,
    status character varying NOT NULL,
    active boolean NOT NULL,
    event_metadata json,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.events OWNER TO roompilot;

--
-- Name: facilities; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.facilities (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    name_translations json,
    icon character varying,
    category character varying,
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    metadata json
);


ALTER TABLE public.facilities OWNER TO roompilot;

--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.feedbacks (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    booking_id character varying,
    guest_name character varying NOT NULL,
    guest_email character varying NOT NULL,
    rating integer NOT NULL,
    comment text,
    category character varying,
    status character varying NOT NULL,
    is_public boolean NOT NULL,
    response text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.feedbacks OWNER TO roompilot;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.invoices (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    booking_id character varying,
    invoice_number character varying NOT NULL,
    invoice_type character varying NOT NULL,
    status character varying NOT NULL,
    issue_date timestamp without time zone DEFAULT now() NOT NULL,
    due_date timestamp without time zone NOT NULL,
    paid_date timestamp without time zone,
    subtotal double precision NOT NULL,
    tax_amount double precision NOT NULL,
    total_amount double precision NOT NULL,
    paid_amount double precision NOT NULL,
    remaining_amount double precision NOT NULL,
    client_name character varying NOT NULL,
    client_email character varying NOT NULL,
    client_phone character varying,
    client_address character varying,
    client_cui character varying,
    company_name character varying NOT NULL,
    company_address character varying NOT NULL,
    company_phone character varying NOT NULL,
    company_email character varying NOT NULL,
    company_cui character varying,
    company_iban character varying,
    description text NOT NULL,
    items text,
    notes text,
    external_id character varying,
    external_url character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    external_status character varying,
    pdf_path character varying,
    html_content text,
    email_sent integer DEFAULT 0 NOT NULL,
    email_sent_at timestamp without time zone,
    email_opened integer DEFAULT 0 NOT NULL,
    email_opened_at timestamp without time zone,
    payment_method character varying,
    payment_reference character varying,
    payment_notes text
);


ALTER TABLE public.invoices OWNER TO roompilot;

--
-- Name: languages; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.languages (
    id character varying NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    flag character varying,
    is_active boolean DEFAULT true NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_platform_public boolean DEFAULT false NOT NULL,
    is_platform_admin boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.languages OWNER TO roompilot;

--
-- Name: legal_entities; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.legal_entities (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    cui character varying NOT NULL,
    name character varying NOT NULL,
    address character varying NOT NULL,
    city character varying NOT NULL,
    county character varying NOT NULL,
    country character varying NOT NULL,
    phone character varying,
    email character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.legal_entities OWNER TO roompilot;

--
-- Name: package_inclusions; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.package_inclusions (
    id character varying NOT NULL,
    package_id character varying NOT NULL,
    inclusion_type character varying NOT NULL,
    title character varying NOT NULL,
    description character varying,
    icon character varying,
    "order" integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.package_inclusions OWNER TO roompilot;

--
-- Name: package_windows; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.package_windows (
    id character varying NOT NULL,
    package_id character varying NOT NULL,
    type character varying NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    window_start timestamp without time zone,
    window_end timestamp without time zone,
    min_nights integer,
    max_nights integer,
    allowed_weekdays integer,
    blackout_dates json,
    "order" integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.package_windows OWNER TO roompilot;

--
-- Name: packages; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.packages (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    title character varying NOT NULL,
    title_translations json,
    slug character varying NOT NULL,
    subtitle character varying,
    subtitle_translations json,
    description text,
    description_translations json,
    hero_image character varying,
    gallery json,
    price double precision NOT NULL,
    currency character varying NOT NULL,
    status character varying NOT NULL,
    booking_mode character varying NOT NULL,
    published_from timestamp without time zone,
    published_to timestamp without time zone,
    is_featured boolean NOT NULL,
    cta_label character varying,
    cta_description character varying,
    package_metadata json,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.packages OWNER TO roompilot;

--
-- Name: price_plans; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.price_plans (
    id character varying NOT NULL,
    room_id character varying NOT NULL,
    name character varying NOT NULL,
    description character varying,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    weekday_price double precision NOT NULL,
    weekend_price double precision NOT NULL,
    min_weekday_nights integer NOT NULL,
    min_weekend_nights integer NOT NULL,
    channel_manager_markup double precision NOT NULL,
    advance_payment double precision,
    advance_payment_type character varying,
    sms_limit integer,
    active boolean NOT NULL,
    extra_guest_prices character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.price_plans OWNER TO roompilot;

--
-- Name: properties; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.properties (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    description character varying,
    address character varying,
    phone character varying,
    email character varying,
    check_in_time character varying NOT NULL,
    check_out_time character varying NOT NULL,
    google_calendar_id character varying,
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.properties OWNER TO roompilot;

--
-- Name: restaurant_menu_categories; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.restaurant_menu_categories (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    restaurant_id character varying NOT NULL,
    name character varying NOT NULL,
    name_translations jsonb,
    slug character varying,
    description text,
    description_translations jsonb,
    display_order integer DEFAULT 0 NOT NULL,
    is_visible boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.restaurant_menu_categories OWNER TO roompilot;

--
-- Name: restaurant_menu_items; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.restaurant_menu_items (
    id character varying NOT NULL,
    restaurant_id character varying NOT NULL,
    name character varying NOT NULL,
    description text,
    price double precision NOT NULL,
    currency character varying NOT NULL,
    category character varying,
    image character varying,
    is_available boolean NOT NULL,
    dietary_tags json,
    allergens json,
    "order" integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.restaurant_menu_items OWNER TO roompilot;

--
-- Name: restaurant_reservations; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.restaurant_reservations (
    id character varying NOT NULL,
    restaurant_id character varying NOT NULL,
    guest_name character varying NOT NULL,
    guest_email character varying,
    guest_phone character varying,
    reservation_date timestamp without time zone NOT NULL,
    number_of_guests integer NOT NULL,
    special_requests text,
    status character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    tenant_id character varying NOT NULL,
    table_id character varying,
    duration_minutes integer DEFAULT 90 NOT NULL,
    source character varying DEFAULT 'in_house'::character varying NOT NULL,
    integration_provider character varying,
    integration_reference character varying,
    notes text
);


ALTER TABLE public.restaurant_reservations OWNER TO roompilot;

--
-- Name: restaurant_tables; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.restaurant_tables (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    restaurant_id character varying NOT NULL,
    table_number character varying NOT NULL,
    capacity integer NOT NULL,
    area character varying,
    is_reservable boolean DEFAULT true NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.restaurant_tables OWNER TO roompilot;

--
-- Name: restaurants; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.restaurants (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    description text,
    hero_image character varying,
    contact_email character varying,
    contact_phone character varying,
    opening_hours json,
    reservations_enabled boolean NOT NULL,
    allow_walk_ins boolean NOT NULL,
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name_translations jsonb,
    slug character varying,
    description_translations jsonb,
    gallery jsonb,
    reservation_type character varying DEFAULT 'in_house'::character varying NOT NULL,
    open_table_url character varying,
    seat_management_enabled boolean DEFAULT false NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    publish_status character varying DEFAULT 'draft'::character varying NOT NULL,
    menu_configuration jsonb
);


ALTER TABLE public.restaurants OWNER TO roompilot;

--
-- Name: rooms; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.rooms (
    id character varying NOT NULL,
    property_id character varying NOT NULL,
    unit_type character varying NOT NULL,
    name character varying NOT NULL,
    description character varying,
    capacity integer NOT NULL,
    standard_guests integer NOT NULL,
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rooms OWNER TO roompilot;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.sessions (
    id character varying NOT NULL,
    session_token character varying NOT NULL,
    user_id character varying NOT NULL,
    expires timestamp without time zone NOT NULL
);


ALTER TABLE public.sessions OWNER TO roompilot;

--
-- Name: site_configs; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.site_configs (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    site_name character varying NOT NULL,
    site_slug character varying,
    custom_domain character varying,
    site_description character varying,
    logo character varying,
    hero_image character varying,
    hero_image1 character varying,
    hero_image2 character varying,
    hero_image3 character varying,
    primary_color character varying NOT NULL,
    hero_text_color character varying NOT NULL,
    font_family character varying NOT NULL,
    currency character varying NOT NULL,
    language character varying NOT NULL,
    timezone character varying NOT NULL,
    theme character varying NOT NULL,
    contact_address character varying,
    contact_phone character varying,
    contact_email character varying,
    contact_facebook character varying,
    contact_instagram character varying,
    contact_tiktok character varying,
    contact_whatsapp character varying,
    contact_latitude character varying,
    contact_longitude character varying,
    email_from character varying,
    email_reply_to character varying,
    email_booking_subject character varying,
    email_booking_body character varying,
    email_confirm_subject character varying,
    email_confirm_body character varying,
    settings character varying,
    automation_settings character varying,
    email_templates character varying,
    homepage_config character varying,
    billing_system character varying,
    oblio_config character varying,
    smartbill_config character varying,
    facilities character varying,
    url_config character varying,
    fgo_config character varying,
    bank_accounts character varying,
    stripe_config character varying,
    netopia_config character varying,
    facebook_config character varying,
    instagram_config character varying,
    whatsapp_config character varying,
    tiktok_config character varying,
    chat_widget_config character varying,
    auto_replies character varying,
    nearby_points character varying,
    chat_provider character varying,
    chat_enabled boolean NOT NULL,
    tawk_property_id character varying,
    tawk_widget_id character varying,
    spa_enabled boolean NOT NULL,
    spa_description character varying,
    spa_services character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.site_configs OWNER TO roompilot;

--
-- Name: sms_templates; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.sms_templates (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    type character varying NOT NULL,
    content text NOT NULL,
    variables text,
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sms_templates OWNER TO roompilot;

--
-- Name: subscription_plans; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.subscription_plans (
    id character varying NOT NULL,
    name character varying NOT NULL,
    description character varying,
    monthly_price double precision NOT NULL,
    yearly_price double precision NOT NULL,
    currency character varying NOT NULL,
    max_properties integer NOT NULL,
    max_units integer NOT NULL,
    max_bookings integer NOT NULL,
    features character varying,
    benefits character varying,
    is_active boolean NOT NULL,
    stripe_monthly_price_id character varying,
    stripe_yearly_price_id character varying,
    includes_onsite_onboard boolean NOT NULL,
    includes_24h_support boolean NOT NULL,
    trial_months integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.subscription_plans OWNER TO roompilot;

--
-- Name: super_admin_mailgun_config; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.super_admin_mailgun_config (
    id character varying NOT NULL,
    api_base_url character varying NOT NULL,
    api_key character varying NOT NULL,
    default_domain character varying,
    default_from_name character varying,
    webhook_signing_key character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.super_admin_mailgun_config OWNER TO roompilot;

--
-- Name: super_admin_sms_configs; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.super_admin_sms_configs (
    id character varying NOT NULL,
    twilio_account_sid character varying NOT NULL,
    twilio_auth_token character varying NOT NULL,
    twilio_phone_number character varying NOT NULL,
    enabled boolean NOT NULL,
    booking_template character varying NOT NULL,
    total_sms_sent integer NOT NULL,
    last_sms_sent_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.super_admin_sms_configs OWNER TO roompilot;

--
-- Name: tenants; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.tenants (
    id character varying NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    domain character varying,
    status character varying NOT NULL,
    subscription_plan character varying NOT NULL,
    subscription_ends_at timestamp without time zone,
    max_properties integer NOT NULL,
    max_units integer NOT NULL,
    max_bookings integer NOT NULL,
    is_active boolean NOT NULL,
    onboarding_completed boolean NOT NULL,
    settings character varying,
    custom_domain character varying,
    subdomain character varying,
    is_custom_domain_active boolean NOT NULL,
    is_subdomain_active boolean NOT NULL,
    dns_configured boolean NOT NULL,
    last_dns_check timestamp without time zone,
    is_demo boolean NOT NULL,
    demo_expires_at timestamp without time zone,
    phone_number character varying,
    sms_notifications_enabled boolean NOT NULL,
    business_email_provider character varying,
    business_email_status character varying,
    email_api_key character varying,
    email_configured boolean NOT NULL,
    email_from_email character varying,
    email_from_name character varying,
    email_provider character varying,
    email_verified_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tenants OWNER TO roompilot;

--
-- Name: translations; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.translations (
    id character varying NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL,
    language_id character varying NOT NULL,
    tenant_language_id character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.translations OWNER TO roompilot;

--
-- Name: units; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.units (
    id character varying NOT NULL,
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    type character varying NOT NULL,
    description text,
    images json,
    main_image character varying,
    bedrooms integer NOT NULL,
    bathrooms integer NOT NULL,
    kitchen boolean NOT NULL,
    living boolean NOT NULL,
    capacity integer NOT NULL,
    individual_rooms json,
    facilities json,
    base_price double precision NOT NULL,
    currency character varying NOT NULL,
    weekend_pricing json,
    extra_person_pricing json,
    min_nights json,
    seasonal_pricing json,
    name_translations json,
    description_translations json,
    active boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    property_id character varying
);


ALTER TABLE public.units OWNER TO roompilot;

--
-- Name: users; Type: TABLE; Schema: public; Owner: roompilot
--

CREATE TABLE public.users (
    id character varying NOT NULL,
    name character varying,
    email character varying NOT NULL,
    password character varying NOT NULL,
    role character varying NOT NULL,
    tenant_id character varying,
    is_active boolean NOT NULL,
    email_verified boolean NOT NULL,
    email_verification_token character varying,
    email_verification_expires timestamp without time zone,
    reset_password_token character varying,
    reset_password_expires timestamp without time zone,
    last_login_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO roompilot;

--
-- Data for Name: MediaAsset; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public."MediaAsset" (id, tenant_id, folder, storage_path, url, thumbnail_url, filename, original_filename, mime_type, size, width, height, asset_type, tags, metadata, created_at, updated_at) FROM stdin;
84158086-9a93-44b0-943c-cc3a7278b133	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-2-c00eeed16b704bc2-1771158022830.jpeg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-2-c00eeed16b704bc2-1771158022830.jpeg	\N	whatsapp-image-2026-02-15-at-14-18-20-2-c00eeed16b704bc2-1771158022830.jpeg	WhatsApp Image 2026-02-15 at 14.18.20-2.jpeg	image/jpeg	263736	1024	1536	image	{}	null	2026-02-15 12:20:22.827364+00	2026-02-15 12:20:22.827364+00
8b837133-9adc-419c-8117-2c9a72e5b787	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-3-be5545f5d3329c0d-1771158022974.jpeg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-3-be5545f5d3329c0d-1771158022974.jpeg	\N	whatsapp-image-2026-02-15-at-14-18-20-3-be5545f5d3329c0d-1771158022974.jpeg	WhatsApp Image 2026-02-15 at 14.18.20-3.jpeg	image/jpeg	272947	1024	1536	image	{}	null	2026-02-15 12:20:22.971115+00	2026-02-15 12:20:22.971115+00
f594cac6-9370-43cf-a222-e6ef4ac2ffd2	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg	\N	whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg	WhatsApp Image 2026-02-15 at 14.18.20.jpeg	image/jpeg	261714	1024	1536	image	{}	null	2026-02-15 12:20:23.015885+00	2026-02-15 12:20:23.015885+00
c076d713-e3c9-4a5f-9c80-444dac337486	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763804189456-o1ipbrcgf7h-ac424857c615c13c-1771267828653.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763804189456-o1ipbrcgf7h-ac424857c615c13c-1771267828653.jpg	\N	1763804189456-o1ipbrcgf7h-ac424857c615c13c-1771267828653.jpg	1763804189456-o1ipbrcgf7h.jpg	image/jpeg	763722	1200	1600	image	{}	null	2026-02-16 18:50:28.651533+00	2026-02-16 18:50:28.651533+00
38c5cb66-5529-4086-86e8-d9225b8573a2	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763803434122-781o4nf9i36-171d76b41549541c-1771267828782.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763803434122-781o4nf9i36-171d76b41549541c-1771267828782.jpg	\N	1763803434122-781o4nf9i36-171d76b41549541c-1771267828782.jpg	1763803434122-781o4nf9i36.jpg	image/jpeg	760638	1343	1791	image	{}	null	2026-02-16 18:50:28.779031+00	2026-02-16 18:50:28.779031+00
765c90ce-dffd-404d-b0bf-e2b562aed317	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268299016.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268299016.jpg	\N	1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268299016.jpg	1763806509240-354i2k74f2o (1).jpg	image/jpeg	427288	720	960	image	{}	null	2026-02-16 18:58:19.014388+00	2026-02-16 18:58:19.014388+00
b032059a-d5f5-4c6f-b346-cbfadb8ec3e2	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268335642.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268335642.jpg	\N	1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268335642.jpg	1763806509240-354i2k74f2o (1).jpg	image/jpeg	427288	720	960	image	{}	null	2026-02-16 18:58:55.641111+00	2026-02-16 18:58:55.641111+00
b2c69a18-6d74-4853-af98-5f1b64d82cb9	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807137109-ds9x79d6op-34a29b074802c87b-1771268339958.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807137109-ds9x79d6op-34a29b074802c87b-1771268339958.jpg	\N	1763807137109-ds9x79d6op-34a29b074802c87b-1771268339958.jpg	1763807137109-ds9x79d6op.jpg	image/jpeg	5243478	2922	3896	image	{}	null	2026-02-16 18:58:59.943798+00	2026-02-16 18:58:59.943798+00
eda6f5cc-5a0b-43b7-a0c0-ad873dced82d	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807541808-vih81urygqi-c609db02f5c73991-1771268420744.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807541808-vih81urygqi-c609db02f5c73991-1771268420744.jpg	\N	1763807541808-vih81urygqi-c609db02f5c73991-1771268420744.jpg	1763807541808-vih81urygqi.jpg	image/jpeg	719692	1152	1536	image	{}	null	2026-02-16 19:00:20.742092+00	2026-02-16 19:00:20.742092+00
0fe9bd12-ea00-4e85-bed4-45c98f693770	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763804189456-o1ipbrcgf7h-ac424857c615c13c-1771341238732.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763804189456-o1ipbrcgf7h-ac424857c615c13c-1771341238732.jpg	\N	1763804189456-o1ipbrcgf7h-ac424857c615c13c-1771341238732.jpg	1763804189456-o1ipbrcgf7h.jpg	image/jpeg	763722	1200	1600	image	{}	null	2026-02-17 15:13:58.729112+00	2026-02-17 15:13:58.729112+00
d268ba86-bd6a-44e3-8daf-564de8e489f4	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341256419.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341256419.jpg	\N	1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341256419.jpg	1763806509240-354i2k74f2o (1).jpg	image/jpeg	427288	720	960	image	{}	null	2026-02-17 15:14:16.416469+00	2026-02-17 15:14:16.416469+00
c702ec5a-68ce-47f3-a63d-8e9855be89d1	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341286205.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341286205.jpg	\N	1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341286205.jpg	1763806509240-354i2k74f2o (1).jpg	image/jpeg	427288	720	960	image	{}	null	2026-02-17 15:14:46.202944+00	2026-02-17 15:14:46.202944+00
0a030dd3-38dc-4283-96e1-4877fa93e04b	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807541808-vih81urygqi-c609db02f5c73991-1771341396933.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807541808-vih81urygqi-c609db02f5c73991-1771341396933.jpg	\N	1763807541808-vih81urygqi-c609db02f5c73991-1771341396933.jpg	1763807541808-vih81urygqi.jpg	image/jpeg	719692	1152	1536	image	{}	null	2026-02-17 15:16:36.92956+00	2026-02-17 15:16:36.92956+00
dd8b9d0d-a4f0-4313-8247-5727c968fdae	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341464666.jpg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341464666.jpg	\N	1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341464666.jpg	1763806509240-354i2k74f2o (1).jpg	image/jpeg	427288	720	960	image	{}	null	2026-02-17 15:17:44.664899+00	2026-02-17 15:17:44.664899+00
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.accounts (id, user_id, type, provider, provider_account_id, refresh_token, access_token, expires_at, token_type, scope, id_token, session_state) FROM stdin;
\.


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.activities (id, tenant_id, name, name_translations, description, description_translations, image, price, currency, duration, location, category, active, created_at, updated_at, metadata) FROM stdin;
cab3732d-9002-45b8-92d0-1bbf04e75c77	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Drumeții Montane	{"ro": "Drumeții Montane"}	Trasee montane în Munții Țarcu – Aventură, liniște și natură sălbatică	\N	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268299016.jpg	\N	RON	\N	\N	\N	t	2026-02-16 18:53:19.459556	2026-02-16 18:58:21.158395	{"icon": "⛰️", "slug": "drumeii-montane", "order": 0, "thumbnail_image": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268299016.jpg", "show_on_homepage": true, "short_description": "Trasee montane în Munții Țarcu – Aventură, liniște și natură sălbatică"}
7cfea651-5a7c-475b-bdc7-f8a6668d64bc	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Caiac	{"ro": "Caiac"}	Caiac	\N	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807137109-ds9x79d6op-34a29b074802c87b-1771268339958.jpg	\N	RON	\N	\N	\N	t	2026-02-16 18:59:01.646032	2026-02-16 18:59:01.646032	{"icon": "⛰️", "slug": "caiac", "order": 1, "thumbnail_image": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807137109-ds9x79d6op-34a29b074802c87b-1771268339958.jpg", "full_description": "Caiac", "show_on_homepage": true, "short_description": "Caiac"}
2f26f672-9654-490f-886d-b52697f0e980	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	MTB & E-Bike în Poiana Mărului	{"ro": "MTB & E-Bike în Poiana Mărului"}	MTB & E-Bike în Poiana Mărului – Libertate pe două roți în Munții Țarcu	\N	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807541808-vih81urygqi-c609db02f5c73991-1771268420744.jpg	\N	RON	\N	\N	\N	t	2026-02-16 19:00:11.769659	2026-02-16 19:00:24.536031	{"icon": "🚴‍♂️⚡", "slug": "mtb-e-bike-n-poiana-mrului", "order": 2, "thumbnail_image": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807541808-vih81urygqi-c609db02f5c73991-1771268420744.jpg", "full_description": "Descriere\\n🔸 1. Poiana Mărului – Zănoaga – Măgura (traseu ușor/mediu)\\nUn traseu perfect pentru o tură relaxată, cu drumuri forestiere, poieni largi și porțiuni line. Ideal pentru familii sau pentru cei care vor o plimbare de câteva ore în natură.\\nDificultate: ușor – mediu\\nPriveliști superbe spre culmile Țarcului\\n🔸 2. Poiana Mărului – Șaua Jigorei – Culmea Pleșu (mediu)\\nO rută superbă pentru MTB, cu zone umbrite, poteci curate și panorame largi. Traseu ideal pentru cei care vor o tură activă, dar nu foarte solicitantă.\\nDrum forestier bine conturat\\nPerfect pentru E-bike datorită urcărilor blânde\\n🔸 3. Poiana Mărului – Căleanu (avansați)\\nPentru cicliștii pregătiți, această rută oferă o adevărată provocare. Diferențe mari de nivel și porțiuni mai tehnice. E-bike-urile pot oferi un avantaj semnificativ pe zonele de urcare.\\nDificultate: ridicată\\nRecomandat doar celor cu experiență\\nPriveliști spectaculoase spre întreg masivul Țarcu–Godeanu\\n🔸 4. Poiana Mărului – Muntele Mic (mediu/avansat)\\nUn traseu foarte căutat de cicliști, cu drum forestier până în zona alpină. O combinație excelentă de urcare, panorame și coborâre lungă.\\nDificultate: medie spre avansată\\nPotrivit pentru MTB și E-bike\\nIdeal pentru o tură de o zi\\nDe ce merită să explorezi zona pe MTB sau E-bike?\\nDrumuri forestiere și poteci variate, potrivite pentru toate nivelurile\\nPeisaje superbe care combină păduri, poieni și zone alpine\\nAer curat și liniște, fără aglomerație\\nPosibilitatea de a combina traseele cu drumeții, picnic sau fotografie\\nE-bike-urile fac accesibil și traseele mai lungi, pentru oricine vrea să se bucure de natură fără efort intens", "show_on_homepage": true, "short_description": "MTB & E-Bike în Poiana Mărului – Libertate pe două roți în Munții Țarcu"}
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.alembic_version (version_num) FROM stdin;
g8h9i0j1k2l3
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.bookings (id, tenant_id, property_id, room_id, unit_id, customer_id, price_plan_id, package_id, guest_first_name, guest_last_name, guest_name, guest_email, guest_phone, guest_country, guest_county, guest_city, guest_address, guest_cnp, check_in, check_out, number_of_guests, status, total_price, advance_amount, advance_required, advance_paid, notes, invoice_number, invoice_series_name, invoice_link, google_event_id, created_at, updated_at, coupon_code, coupon_discount, short_booking_id) FROM stdin;
3962918d-b63e-4dc6-b019-1441b84f0ae5	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	b34367ec-a8e7-4019-bc88-38df5b8791ca	873f033f-1eed-4344-99e1-de2b1df9eb68	79af607c-0966-467a-aede-afab3505af1f	\N	\N	\N	ovidiu	bistrian	ovidiu bistrian	ovidiubistrian@gmail.com	0737347981	România	Caras-Severin	Caransebes	asdsadfa	1821023114092	2026-02-15 00:00:00	2026-02-18 00:00:00	4	pending	3900	0	0	t	Rezervare în așteptare - necesită confirmare	PF-2026-000001	PROFORMA	http://localhost:5173/admin/invoices/71533a57-322e-4c1c-984a-f04dfaf65a56	\N	2026-02-15 15:38:02.466316	2026-02-15 15:38:02.534457	\N	\N	REZ-260215-RK3V
99ad154f-4520-4171-b2fb-a14338314797	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	b34367ec-a8e7-4019-bc88-38df5b8791ca	873f033f-1eed-4344-99e1-de2b1df9eb68	79af607c-0966-467a-aede-afab3505af1f	\N	\N	\N	Ovidiu	Bistrian	Ovidiu Bistrian	ovidiubistrian@gmail.com	07302870147	Romania	caras-severin	Glimboca	fd 98	1821023114092	2026-02-19 00:00:00	2026-02-21 00:00:00	4	confirmed	2600	0	0	t		PF-2026-000002	PROFORMA	http://localhost:5173/admin/invoices/778468d1-def1-4f49-bea8-8d03e506c103	\N	2026-02-15 15:39:15.842872	2026-02-15 17:21:16.461271	\N	0	REZ-260215-7WBZ
c6f12365-80bd-415b-b10c-3a765eb94672	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	b34367ec-a8e7-4019-bc88-38df5b8791ca	873f033f-1eed-4344-99e1-de2b1df9eb68	79af607c-0966-467a-aede-afab3505af1f	\N	\N	\N	ovidiu	bistrian	ovidiu bistrian	ovidiubistrian@gmail.com	0730287017	Romania	caras-severin	GLimboca	fs 98	1821023114092	2026-02-23 00:00:00	2026-02-27 00:00:00	2	confirmed	5200	0	0	t		PF-2026-000003	PROFORMA	http://localhost:5173/admin/invoices/eda786c2-71b6-4b0b-88a9-3d675e28c61d	\N	2026-02-15 17:33:52.8694	2026-02-15 17:35:44.603635	\N	0	REZ-260215-TBEA
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.campaigns (id, tenant_id, name, type, status, subject, content, template_id, target_audience, custom_filters, scheduled_at, sent_at, total_recipients, delivered, opened, clicked, bounced, unsubscribed, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: coupon_usages; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.coupon_usages (id, coupon_id, customer_id, booking_id, discount_amount, original_amount, final_amount, created_at) FROM stdin;
\.


--
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.coupons (id, tenant_id, code, name, description, type, value, min_amount, max_discount, usage_limit, usage_count, per_customer, valid_from, valid_until, applicable_units, customer_labels, active, created_at, updated_at) FROM stdin;
14ac8d18-fbc2-44a2-8b7d-87eba0cdca0c	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	BFW19VX8	Vara2026	\N	percentage	10	\N	\N	1	0	1	2026-02-16 00:00:00	\N	{}	{}	t	2026-02-16 15:27:53.518743	2026-02-16 15:27:53.518745
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.customers (id, tenant_id, email, first_name, last_name, phone, status, labels, sources, email_opt_in, sms_opt_in, total_bookings, total_spent, last_booking, created_at, updated_at) FROM stdin;
b67d51e1-e503-4a70-867e-cade017efbe3	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	ovidiubistrian@gmail.com	ovidiu	bistrian	0737347981	active	{}	{booking}	t	f	1	3900	2026-02-15 15:38:02.550531	2026-02-15 15:38:02.543546	2026-02-15 15:38:02.543546
\.


--
-- Data for Name: demo_requests; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.demo_requests (id, first_name, last_name, email, phone, preferred_at, message, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: domain_requests; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.domain_requests (id, tenant_id, domain, is_active, status, tenant_id_associated, notes, created_at, updated_at) FROM stdin;
e0a4cbf7-9a86-42b2-a05b-d6a6fd53e026	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	marius.ro	t	pending	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	\N	2026-02-17 16:33:52.041884	2026-02-17 16:33:52.041884
\.


--
-- Data for Name: email_templates; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.email_templates (id, tenant_id, name, type, subject, html_content, text_content, variables, active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: event_tickets; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.event_tickets (id, event_id, tenant_id, guest_name, guest_email, guest_phone, quantity, total_price, currency, ticket_code, status, message, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.events (id, tenant_id, title, description, start_date, end_date, location, image, category, status, active, event_metadata, created_at, updated_at) FROM stdin;
11beeabd-ba01-4aed-bf59-dd86eb9d793e	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Festivalul Gulasului	📢 Festivalul „Maestrul Gulașului” – 1 Martie 2025 🍲🏔️🎶	2026-02-21 21:03:00	2026-02-22 19:01:00	Poiana Marului	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771268335642.jpg	gastronomic	active	t	\N	2026-02-16 19:02:02.134196	2026-02-16 19:02:02.134198
\.


--
-- Data for Name: facilities; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.facilities (id, tenant_id, name, name_translations, icon, category, active, created_at, updated_at, metadata) FROM stdin;
f1726712-87d1-4687-af1e-20c606d85851	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Piscina 	{"ro": "Piscina "}	🏊	\N	t	2026-02-16 18:37:30.331543	2026-02-16 18:37:30.331545	{"slug": "piscina", "carousel_images": ["/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg"], "short_description": "Piscina Exterioara 8/4 ", "full_description": "Piscina Exterioara 8/4", "price_info": "INclus in pret", "schedule": "Non-Stop", "capacity": "8 persoane", "show_on_homepage": true}
8782a8ae-87ca-4d40-aae4-955b522363af	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	jacuzzi	{"ro": "jacuzzi"}	🏊	\N	t	2026-02-16 18:50:40.208321	2026-02-16 18:50:40.208323	{"slug": "jacuzzi", "carousel_images": ["/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763803434122-781o4nf9i36-171d76b41549541c-1771267828782.jpg"], "short_description": "jacuzzi", "full_description": "jacuzzi", "price_info": "Inclus in pret", "schedule": "nonstop", "capacity": "6", "order": 1, "show_on_homepage": true}
9d8376a2-bd2a-4f71-8997-fb6e83e68748	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Inchiriat ATV	{"ro": "Inchiriat ATV"}	🏊	\N	t	2026-02-16 18:50:52.921222	2026-02-16 18:50:52.921224	{"slug": "inchiriat-atv", "carousel_images": ["/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763804189456-o1ipbrcgf7h-ac424857c615c13c-1771267828653.jpg"], "short_description": "Inchiriat ATV", "full_description": "Inchiriat ATV", "order": 2, "show_on_homepage": true}
\.


--
-- Data for Name: feedbacks; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.feedbacks (id, tenant_id, booking_id, guest_name, guest_email, rating, comment, category, status, is_public, response, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.invoices (id, tenant_id, booking_id, invoice_number, invoice_type, status, issue_date, due_date, paid_date, subtotal, tax_amount, total_amount, paid_amount, remaining_amount, client_name, client_email, client_phone, client_address, client_cui, company_name, company_address, company_phone, company_email, company_cui, company_iban, description, items, notes, external_id, external_url, created_at, updated_at, external_status, pdf_path, html_content, email_sent, email_sent_at, email_opened, email_opened_at, payment_method, payment_reference, payment_notes) FROM stdin;
71533a57-322e-4c1c-984a-f04dfaf65a56	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	3962918d-b63e-4dc6-b019-1441b84f0ae5	PF-2026-000001	proforma	draft	2026-02-15 15:38:02.49229	2026-02-22 15:38:02.52374	\N	3900	0	3900	0	3900	ovidiu bistrian	ovidiubistrian@gmail.com	0737347981	asdsadfa	\N	Pine HIll	fs 98	Telefon nu este setat	Email nu este setat	\N	\N	Cazare Default Property - Pine HIll 1	\N	\N	\N	\N	2026-02-15 15:38:02.49229	2026-02-15 15:38:02.49229	\N	\N	\N	0	\N	0	\N	\N	\N	\N
eda786c2-71b6-4b0b-88a9-3d675e28c61d	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	c6f12365-80bd-415b-b10c-3a765eb94672	PF-2026-000003	proforma	draft	2026-02-15 17:35:44.574545	2026-02-22 17:35:44.595024	\N	5200	0	5200	0	5200	ovidiu bistrian	ovidiubistrian@gmail.com	0730287017	fs 98	\N	Pine HIll	fs 98	Telefon nu este setat	Email nu este setat	\N	\N	Cazare Default Property - Pine HIll 1	\N	\N	\N	\N	2026-02-15 17:35:44.574545	2026-02-15 17:35:44.574545	\N	\N	\N	0	\N	0	\N	\N	\N	\N
\.


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.languages (id, code, name, flag, is_active, is_default, is_platform_public, is_platform_admin, sort_order, created_at, updated_at) FROM stdin;
1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	ro	Română	🇷🇴	t	t	t	t	0	2026-02-17 16:40:26.858633	2026-02-17 16:40:26.858633
\.


--
-- Data for Name: legal_entities; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.legal_entities (id, tenant_id, cui, name, address, city, county, country, phone, email, created_at, updated_at) FROM stdin;
15914b5a-465f-4609-8621-003baa56c82c	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Ro41664154	Pine HIll	fs 98	Glimboca	Caras-Severin	Romania	\N	\N	2026-02-15 12:04:17.653174	2026-02-15 12:04:48.71292
\.


--
-- Data for Name: package_inclusions; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.package_inclusions (id, package_id, inclusion_type, title, description, icon, "order", created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: package_windows; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.package_windows (id, package_id, type, start_date, end_date, window_start, window_end, min_nights, max_nights, allowed_weekdays, blackout_dates, "order", created_at, updated_at) FROM stdin;
703f5b8e-6e85-4902-a80e-c8b2b3fd8d8f	aa3f98e5-61e2-4ecc-ae51-69ecebf732ab	fixed	2026-02-20 00:00:00	2026-02-17 23:59:59	\N	\N	\N	\N	\N	\N	0	2026-02-15 17:07:46.573798	2026-02-15 17:07:46.573799
2f44d3ae-1f7a-4d0e-91e6-ed0734cddddc	4dedcda8-a3c4-4e6e-884b-28cea6528c38	fixed	2026-02-22 00:00:00	2026-02-28 23:59:59	\N	\N	\N	\N	\N	\N	0	2026-02-15 17:08:35.229546	2026-02-15 17:08:35.229548
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.packages (id, tenant_id, title, title_translations, slug, subtitle, subtitle_translations, description, description_translations, hero_image, gallery, price, currency, status, booking_mode, published_from, published_to, is_featured, cta_label, cta_description, package_metadata, created_at, updated_at) FROM stdin;
aa3f98e5-61e2-4ecc-ae51-69ecebf732ab	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Paster	null	paster-1	Paster	null	\N	null	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg	null	4000	RON	published	fixed_window	\N	\N	f	Rezervă acum	\N	null	2026-02-15 17:07:24.994077	2026-02-15 17:07:46.57387
4dedcda8-a3c4-4e6e-884b-28cea6528c38	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Craciun	null	craciun	Craciun	null	\N	null	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg	null	4000	RON	published	fixed_window	\N	\N	f	Rezervă acum	\N	null	2026-02-15 17:01:48.408134	2026-02-15 17:08:35.229658
\.


--
-- Data for Name: price_plans; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.price_plans (id, room_id, name, description, start_date, end_date, weekday_price, weekend_price, min_weekday_nights, min_weekend_nights, channel_manager_markup, advance_payment, advance_payment_type, sms_limit, active, extra_guest_prices, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.properties (id, tenant_id, name, description, address, phone, email, check_in_time, check_out_time, google_calendar_id, active, created_at, updated_at) FROM stdin;
b34367ec-a8e7-4019-bc88-38df5b8791ca	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Default Property	Default property created automatically	\N	\N	\N	14:00	12:00	\N	t	2026-02-15 15:38:02.421558	2026-02-15 15:38:02.421558
\.


--
-- Data for Name: restaurant_menu_categories; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.restaurant_menu_categories (id, tenant_id, restaurant_id, name, name_translations, slug, description, description_translations, display_order, is_visible, created_at, updated_at) FROM stdin;
cb5db2eb-2f03-4fe1-ac59-a07c7dc9afb0	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Gustări & Aperitive	\N	gust-ri-aperitive	Plating modern, combinații fresh și gusturi surprinzătoare pentru începutul perfect.	\N	0	t	2026-02-14 18:52:36.717636	2026-02-14 18:52:36.717637
e6dc7de8-6594-48c0-a60a-eaf6ce786743	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Supe & Creme	\N	supe-creme	Preparatele calde care încălzesc și pregătesc papilele gustative.	\N	1	t	2026-02-14 18:52:36.739987	2026-02-14 18:52:36.739989
d1a04ebe-4ea3-4066-b1e5-82dbab53c1b2	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Feluri principale	\N	feluri-principale	Selecție de preparate principale cu ingrediente locale, reinterpretate creativ.	\N	2	t	2026-02-14 18:52:36.752317	2026-02-14 18:52:36.752318
a1e1428a-9aaf-4f3f-9539-0f26aab6bb64	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Deserturi	\N	deserturi	Final dulce care surprinde prin plating și aromele delicate.	\N	3	t	2026-02-14 18:52:36.768202	2026-02-14 18:52:36.768203
d187be01-5455-4616-b3da-612ec050a1dc	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Mic dejun	\N	mic-dejun	Opțiuni fresh pentru începutul zilei.	\N	4	t	2026-02-14 18:52:58.063703	2026-02-14 18:52:58.063705
603516ef-7da0-45d8-9c16-b594b79a589f	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Starter	\N	starter	Aperitive ușoare și creative.	\N	5	t	2026-02-14 18:52:58.063891	2026-02-14 18:52:58.063892
00b0ac6e-264e-417d-9b67-49e959a8bb05	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Specialități	\N	specialit-ti	Recomandările bucătarului șef.	\N	6	t	2026-02-14 18:52:58.063965	2026-02-14 18:52:58.063965
d3ee10bb-a066-4e09-b06f-60557dd4b2fd	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Desert	\N	desert	Dulciuri artizanale și delicii.	\N	7	t	2026-02-14 18:52:58.064069	2026-02-14 18:52:58.064069
0dea41bc-5706-4064-b014-4dda965ae87a	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Băuturi	\N	b-uturi	Selecție de băuturi alcoolice și non-alcoolice.	\N	8	t	2026-02-14 18:52:58.064139	2026-02-14 18:52:58.06414
\.


--
-- Data for Name: restaurant_menu_items; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.restaurant_menu_items (id, restaurant_id, name, description, price, currency, category, image, is_available, dietary_tags, allergens, "order", created_at, updated_at) FROM stdin;
77765eda-d638-4513-87c6-3ce4879940eb	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Păstrăv la jar cu sos de brad	File de păstrăv, unt afumat, sos de lastari de brad, piure de păstârnac.	92	RON	Feluri principale	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-3-be5545f5d3329c0d-1771158022974.jpeg	t	[]	[]	0	2026-02-14 18:52:36.757007	2026-02-15 15:21:15.908063
787b5cb7-d339-4362-afc3-40af80221677	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Tartă de mere caramelizate	Mere din livada locală, sos de caramel sărat, înghețată de scorțișoară.	42	RON	Deserturi	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-2-c00eeed16b704bc2-1771158022830.jpeg	t	[]	[]	1	2026-02-14 18:52:36.777406	2026-02-15 15:27:37.863828
f05725a6-f371-4bca-95f1-cd635b39ee25	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Mousse de ciocolată cu molid	Ciocolată 70%, frișcă infuzată cu muguri de molid, crumble de cacao.	45	RON	Deserturi	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg	t	[]	[]	0	2026-02-14 18:52:36.773344	2026-02-15 15:33:54.461981
cac1d245-6aaa-43d8-8217-aa7e95687b58	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Muşchi de cerb cu ciuperci sălbatice	Cerb de pădure, reducție de vin roșu, ciuperci hribi, polentă cremoasă.	135	RON	Feluri principale	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-2-c00eeed16b704bc2-1771158022830.jpeg	t	[]	[]	1	2026-02-14 18:52:36.760749	2026-02-15 15:34:01.604398
a10e9ada-d88b-40a8-a358-71d3fd7b35f0	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Ciorbă de păstrăv cu leuștean	Inspirată din rețetele montane, servită cu smântână de casă.	39	RON	Supe & Creme	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg	t	[]	[]	1	2026-02-14 18:52:36.748535	2026-02-15 15:34:10.14411
da5cb227-45bd-46cd-ba1e-ad01b418e1e3	0e569d66-b936-4f19-8dec-44bbdc7bdd24	Supă cremă de sfeclă și măr	Sfeclă bio, mere Granny Smith, iaurt fermentat, chips de kale.	38	RON	Supe & Creme	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-3-be5545f5d3329c0d-1771158022974.jpeg	t	["vegetarian"]	[]	0	2026-02-14 18:52:36.745028	2026-02-15 15:34:16.888612
\.


--
-- Data for Name: restaurant_reservations; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.restaurant_reservations (id, restaurant_id, guest_name, guest_email, guest_phone, reservation_date, number_of_guests, special_requests, status, created_at, updated_at, tenant_id, table_id, duration_minutes, source, integration_provider, integration_reference, notes) FROM stdin;
\.


--
-- Data for Name: restaurant_tables; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.restaurant_tables (id, tenant_id, restaurant_id, table_number, capacity, area, is_reservable, notes, created_at, updated_at) FROM stdin;
cee35a66-1271-46b2-866e-348a76dd6531	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	1	2	Terasa	t	\N	2026-02-14 18:52:36.782528	2026-02-14 18:52:36.782529
3566a3b1-e85b-420b-a246-637c1905e5af	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	2	4	Sala principală	t	\N	2026-02-14 18:52:36.788756	2026-02-14 18:52:36.788757
25fd2368-b32c-42d3-b4da-5476a4c438c1	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	3	4	Sala principală	t	\N	2026-02-14 18:52:36.794082	2026-02-14 18:52:36.794083
cc13e744-e8bd-4138-b0c8-792d984c24ac	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	4	6	Sala principală	t	\N	2026-02-14 18:52:36.798948	2026-02-14 18:52:36.798948
269c0066-6a97-405b-bb87-2da24aa9650c	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	0e569d66-b936-4f19-8dec-44bbdc7bdd24	5	8	Sala de evenimente	t	\N	2026-02-14 18:52:36.803598	2026-02-14 18:52:36.803599
\.


--
-- Data for Name: restaurants; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.restaurants (id, tenant_id, name, description, hero_image, contact_email, contact_phone, opening_hours, reservations_enabled, allow_walk_ins, active, created_at, updated_at, name_translations, slug, description_translations, gallery, reservation_type, open_table_url, seat_management_enabled, is_published, publish_status, menu_configuration) FROM stdin;
0e569d66-b936-4f19-8dec-44bbdc7bdd24	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Pine Hill Restaurant	\N	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-2-c00eeed16b704bc2-1771158022830.jpeg	\N	\N	{"friday": {"end": "23:00", "start": "10:00", "enabled": true}, "monday": {"end": "22:00", "start": "10:00", "enabled": true}, "sunday": {"end": "21:00", "start": "10:00", "enabled": true}, "tuesday": {"end": "22:00", "start": "10:00", "enabled": true}, "saturday": {"end": "23:00", "start": "10:00", "enabled": true}, "thursday": {"end": "22:00", "start": "10:00", "enabled": true}, "wednesday": {"end": "22:00", "start": "10:00", "enabled": true}}	t	t	t	2026-02-14 18:52:36.706481	2026-02-15 17:37:53.595082	\N	pine-hill-restaurant	\N	\N	in_house	\N	f	t	published	\N
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.rooms (id, property_id, unit_type, name, description, capacity, standard_guests, active, created_at, updated_at) FROM stdin;
873f033f-1eed-4344-99e1-de2b1df9eb68	b34367ec-a8e7-4019-bc88-38df5b8791ca	apartment	Pine HIll 1	Pine Hill I – pentru cupluri, familii mici sau escapade romantice\n2 dormitoare: pat king size (180 cm) la parter și pat queen size (160 cm) la etaj\n\n2 băi complet utilate\nLiving spațios cu bucătărie open space\nSuprafață: 120 m²\nCapacitate: 4–6 persoane (pat suplimentar disponibil la cerere)	4	4	t	2026-02-15 15:38:02.452122	2026-02-15 15:38:02.452122
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.sessions (id, session_token, user_id, expires) FROM stdin;
\.


--
-- Data for Name: site_configs; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.site_configs (id, tenant_id, site_name, site_slug, custom_domain, site_description, logo, hero_image, hero_image1, hero_image2, hero_image3, primary_color, hero_text_color, font_family, currency, language, timezone, theme, contact_address, contact_phone, contact_email, contact_facebook, contact_instagram, contact_tiktok, contact_whatsapp, contact_latitude, contact_longitude, email_from, email_reply_to, email_booking_subject, email_booking_body, email_confirm_subject, email_confirm_body, settings, automation_settings, email_templates, homepage_config, billing_system, oblio_config, smartbill_config, facilities, url_config, fgo_config, bank_accounts, stripe_config, netopia_config, facebook_config, instagram_config, whatsapp_config, tiktok_config, chat_widget_config, auto_replies, nearby_points, chat_provider, chat_enabled, tawk_property_id, tawk_widget_id, spa_enabled, spa_description, spa_services, created_at, updated_at) FROM stdin;
d748e7f1-04de-4d4d-9d0f-a0f8856a3741	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Pensiune	\N	marius.ro	\N	\N	\N	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-3-be5545f5d3329c0d-1771158022974.jpeg	/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-2-c00eeed16b704bc2-1771158022830.jpeg	#1d6796	#ffffff	Inter	RON	ro	Europe/Bucharest	pine-hill	Poiana Marului, Caras-Severin, Principala 87 H	0730287017	contact@pinehill.ro	\N	\N	\N	0730287017	\N	\N	\N	\N	\N	\N	\N	\N	{"about_title": "Pine HIll", "about_description": "asfsafaf", "about_image": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg", "gallery_images": [{"id": "c1ae5a50-07b3-45b6-a766-f09b3c8ea578", "url": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763804189456-o1ipbrcgf7h-ac424857c615c13c-1771341238732.jpg", "order": 0, "createdAt": "2026-02-17T15:13:58.865949"}, {"id": "e95c8204-d223-4566-9fb2-aa4246a08ce2", "url": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg", "order": 1, "createdAt": "2026-02-17T15:14:06.860143"}, {"id": "38743e0c-f118-414d-8135-286feb64059f", "url": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341256419.jpg", "order": 2, "createdAt": "2026-02-17T15:14:16.448890"}, {"id": "9825fbf6-8f1a-40a4-8169-01dfda504f44", "url": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341286205.jpg", "order": 3, "createdAt": "2026-02-17T15:14:46.235674"}, {"id": "74f547ee-63f7-4c7e-8147-9c48eb2b0636", "url": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763807541808-vih81urygqi-c609db02f5c73991-1771341396933.jpg", "order": 4, "createdAt": "2026-02-17T15:16:36.968520"}, {"id": "f49be64d-afc4-4f15-ba67-6efd8ad1d9fe", "url": "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/1763806509240-354i2k74f2o--1-e9845a2a2214e979-1771341464666.jpg", "order": 5, "createdAt": "2026-02-17T15:17:44.777722"}]}	\N	\N	\N	proforma	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	none	f	\N	\N	f	\N	\N	2026-02-14 18:52:05.915966	2026-02-17 16:33:52.041884
\.


--
-- Data for Name: sms_templates; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.sms_templates (id, tenant_id, name, type, content, variables, active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: subscription_plans; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.subscription_plans (id, name, description, monthly_price, yearly_price, currency, max_properties, max_units, max_bookings, features, benefits, is_active, stripe_monthly_price_id, stripe_yearly_price_id, includes_onsite_onboard, includes_24h_support, trial_months, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: super_admin_mailgun_config; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.super_admin_mailgun_config (id, api_base_url, api_key, default_domain, default_from_name, webhook_signing_key, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: super_admin_sms_configs; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.super_admin_sms_configs (id, twilio_account_sid, twilio_auth_token, twilio_phone_number, enabled, booking_template, total_sms_sent, last_sms_sent_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.tenants (id, name, slug, domain, status, subscription_plan, subscription_ends_at, max_properties, max_units, max_bookings, is_active, onboarding_completed, settings, custom_domain, subdomain, is_custom_domain_active, is_subdomain_active, dns_configured, last_dns_check, is_demo, demo_expires_at, phone_number, sms_notifications_enabled, business_email_provider, business_email_status, email_api_key, email_configured, email_from_email, email_from_name, email_provider, email_verified_at, created_at, updated_at) FROM stdin;
b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Pine HIll	pine-hill	\N	trial	free	2026-02-28 18:52:00.188789	1	5	100	t	f	{'businessType': 'ressort', 'theme': 'pine-hill', 'currency': 'RON', 'language': 'ro'}	marius.ro	\N	t	t	f	\N	f	\N	\N	f	\N	\N	\N	f	\N	\N	\N	\N	2026-02-14 18:51:59.981449	2026-02-17 16:33:52.041884
\.


--
-- Data for Name: translations; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.translations (id, key, value, language_id, tenant_language_id, created_at, updated_at) FROM stdin;
b42c650b-bda4-47af-8a66-c6314d1bc743	homepage.title	Bun venit	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
312e55bc-7404-4fb3-b36c-57e07e432bea	homepage.subtitle	Rezervări online pentru pensiuni	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
9f380ae2-0e33-4d5d-8901-5b929e4efefd	navigation.home	Acasă	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
f7fd8a04-6352-4322-8262-bbdf995fbb36	navigation.about	Despre Noi	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
6058d343-be23-41b8-bdc0-8caeaebabfee	navigation.contact	Contact	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
6d09f724-7355-4214-89d5-19011e211570	common.save	Salvează	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
1b94f06b-700c-468d-9501-16b53d6166a9	common.cancel	Anulează	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
ab05f69f-07fe-47c2-a4e3-1f8e68bdd2aa	common.delete	Șterge	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
b9db9757-4cb6-4365-8124-2b0bd79cfb8d	common.edit	Editează	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
e3664c90-bec0-4e86-b850-6e80ffd7a20b	booking.title	Rezervări	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
882172e1-192f-4c10-959b-3d3ef0867d1b	booking.create	Creează rezervare	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
b5bd5b77-bc09-4ca8-b9be-874df7750311	booking_success.title	Rezervare confirmată!	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
d4bf146e-48d2-4fcb-9c5b-c583f879dcd8	booking_success.message	Rezervarea dvs. a fost trimisă cu succes. Veți primi în curând un email de confirmare.	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
8136af2a-6628-4375-a288-a7737a5b9705	booking_success.back_to_home	Înapoi la pagina principală	1dc3684c-0749-4c7e-a5d7-c5d773d24c4e	\N	2026-02-17 16:40:26.898688	2026-02-17 16:40:26.898688
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.units (id, tenant_id, name, slug, type, description, images, main_image, bedrooms, bathrooms, kitchen, living, capacity, individual_rooms, facilities, base_price, currency, weekend_pricing, extra_person_pricing, min_nights, seasonal_pricing, name_translations, description_translations, active, created_at, updated_at, property_id) FROM stdin;
79af607c-0966-467a-aede-afab3505af1f	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	Pine HIll 1	pine-hill-1	apartment	Pine Hill I – pentru cupluri, familii mici sau escapade romantice\n2 dormitoare: pat king size (180 cm) la parter și pat queen size (160 cm) la etaj\n\n2 băi complet utilate\nLiving spațios cu bucătărie open space\nSuprafață: 120 m²\nCapacitate: 4–6 persoane (pat suplimentar disponibil la cerere)	["/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-a8fc92c94ceae1f1-1771158023017.jpeg", "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-3-be5545f5d3329c0d-1771158022974.jpeg", "/uploads/images-b12b93c6-cfbf-4e1b-a248-c933f3ff11aa/whatsapp-image-2026-02-15-at-14-18-20-2-c00eeed16b704bc2-1771158022830.jpeg"]	\N	1	1	f	f	4	[{"id": "room-1771158295978-mr4ajmp6z", "name": "Dormitor Principal", "type": "bedroom", "description": "", "images": [], "amenities": [], "capacity": 2, "bedroomConfig": {"bedCount": 1, "beds": [{"id": "room-1771158295978-mr4ajmp6z-bed-1", "bedType": "king", "bedNumber": 1}], "hasTV": false, "hasAirConditioning": false, "hasPrivateBathroom": false, "hasBalcony": false, "hasWardrobe": false, "hasDesk": false, "hasSofa": false, "hasMinibar": false, "hasSafe": false}}, {"id": "room-1771158310625-jq9cdxkxg", "name": "Dormitor Etaj", "type": "bedroom", "description": "", "images": [], "amenities": [], "capacity": 2, "bedroomConfig": {"bedCount": 1, "beds": [{"id": "room-1771158310625-jq9cdxkxg-bed-1", "bedType": "queen", "bedNumber": 1}], "hasTV": false, "hasAirConditioning": false, "hasPrivateBathroom": false, "hasBalcony": false, "hasWardrobe": false, "hasDesk": false, "hasSofa": false, "hasMinibar": false, "hasSafe": false}}]	["WiFi", "Parking", "Garden", "Pool", "Kitchen", "Air Conditioning", "Sauna", "Jacuzzi", "TV", "Washing Machine", "Coffee Machine", "Balcony", "Terrace", "Pet Friendly"]	0	RON	null	null	null	[{"season": "Prim\\u0103var\\u0103 / Pa\\u0219te \\ud83d\\udd4a\\ufe0f", "price": 1300, "startDate": "04-15", "endDate": "05-05", "minNights": 3, "description": "Tradi\\u021bii, natur\\u0103, picnicuri, relaxare", "isEditable": true, "isRecurring": true, "year": null, "weekendPricing": {"enabled": false, "weekendPrice": 0, "weekdayPrice": 0, "weekendMinNights": 2, "weekdayMinNights": 1}, "extraPersonPricing": {"enabled": false, "pricePerPerson": 25}, "advancePayment": {"enabled": false, "type": "fixed", "amount": 0}}, {"season": "1 Mai \\ud83c\\uddf7\\ud83c\\uddf4", "price": 1300, "startDate": "05-01", "endDate": "05-05", "minNights": 2, "description": "Mini-vacan\\u021b\\u0103, gr\\u0103tare, \\u00eenceput de var\\u0103", "isEditable": true, "isRecurring": true, "year": null, "weekendPricing": {"enabled": false, "weekendPrice": 0, "weekdayPrice": 0, "weekendMinNights": 2, "weekdayMinNights": 1}, "extraPersonPricing": {"enabled": false, "pricePerPerson": 25}, "advancePayment": {"enabled": false, "type": "fixed", "amount": 0}}, {"season": "Var\\u0103 \\u2600\\ufe0f", "price": 1300, "startDate": "06-01", "endDate": "09-10", "minNights": 2, "description": "Sezon turistic principal, activit\\u0103\\u021bi outdoor", "isEditable": true, "isRecurring": true, "year": null, "weekendPricing": {"enabled": false, "weekendPrice": 0, "weekdayPrice": 0, "weekendMinNights": 2, "weekdayMinNights": 1}, "extraPersonPricing": {"enabled": false, "pricePerPerson": 25}, "advancePayment": {"enabled": false, "type": "fixed", "amount": 0}}, {"season": "Toamn\\u0103 \\ud83c\\udf41", "price": 1300, "startDate": "09-15", "endDate": "11-30", "minNights": 2, "description": "Culori de munte, lini\\u0219te, relaxare", "isEditable": true, "isRecurring": true, "year": null, "weekendPricing": {"enabled": false, "weekendPrice": 0, "weekdayPrice": 0, "weekendMinNights": 2, "weekdayMinNights": 1}, "extraPersonPricing": {"enabled": false, "pricePerPerson": 25}, "advancePayment": {"enabled": false, "type": "fixed", "amount": 0}}, {"season": "Iarn\\u0103 \\u2744\\ufe0f", "price": 1300, "startDate": "12-01", "endDate": "12-20", "minNights": 2, "description": "Z\\u0103pad\\u0103, jacuzzi, atmosfer\\u0103 de caban\\u0103", "isEditable": true, "isRecurring": true, "year": null, "weekendPricing": {"enabled": false, "weekendPrice": 0, "weekdayPrice": 0, "weekendMinNights": 2, "weekdayMinNights": 1}, "extraPersonPricing": {"enabled": false, "pricePerPerson": 25}, "advancePayment": {"enabled": false, "type": "fixed", "amount": 0}}, {"season": "Cr\\u0103ciun \\ud83c\\udf84", "price": 1300, "startDate": "12-21", "endDate": "12-27", "minNights": 3, "description": "Pachet de s\\u0103rb\\u0103toare \\u00een familie", "isEditable": true, "isRecurring": true, "year": null, "weekendPricing": {"enabled": false, "weekendPrice": 0, "weekdayPrice": 0, "weekendMinNights": 2, "weekdayMinNights": 1}, "extraPersonPricing": {"enabled": false, "pricePerPerson": 25}, "advancePayment": {"enabled": false, "type": "fixed", "amount": 0}}, {"season": "Revelion \\ud83c\\udf86", "price": 1300, "startDate": "12-28", "endDate": "01-03", "minNights": 4, "description": "Petrecere de Anul Nou la munte", "isEditable": true, "isRecurring": true, "year": null, "weekendPricing": {"enabled": false, "weekendPrice": 0, "weekdayPrice": 0, "weekendMinNights": 2, "weekdayMinNights": 1}, "extraPersonPricing": {"enabled": false, "pricePerPerson": 25}, "advancePayment": {"enabled": false, "type": "fixed", "amount": 0}}]	null	null	t	2026-02-15 12:25:28.721047	2026-02-15 12:25:28.721047	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: roompilot
--

COPY public.users (id, name, email, password, role, tenant_id, is_active, email_verified, email_verification_token, email_verification_expires, reset_password_token, reset_password_expires, last_login_at, created_at, updated_at) FROM stdin;
931c38ab-d871-4b8a-ac69-7aa443089ba9	Super Admin	ovidiubistrian@gmail.com	$2b$12$XBbtmPAZF59/jG3.mboJSuJ3EgxE0kecjMFp4k/JJ1PzwhWizudK.	super_admin	\N	t	t	\N	\N	\N	\N	2026-02-17 16:39:37.070629	2026-02-14 18:52:32.274193	2026-02-17 16:39:36.776278
3ac217e9-e9bf-4863-b269-db9aea8320e6	Ovidiu Bistrian	contact@pinehill.ro	$2b$12$cNBabpx0GCs.Y5wGIWdTz.2.v1M2CGnYY02.yd2TYVUSt3/tiDR76	tenant_admin	b12b93c6-cfbf-4e1b-a248-c933f3ff11aa	t	t	CT98NoyCP_aTntgkM19dtJjvDyRtqUrLu7Dp4zLt4Dc	2026-02-15 18:52:00.188782	\N	\N	2026-02-19 09:04:26.870011	2026-02-14 18:51:59.981449	2026-02-19 09:04:26.610161
\.


--
-- Name: MediaAsset MediaAsset_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public."MediaAsset"
    ADD CONSTRAINT "MediaAsset_pkey" PRIMARY KEY (id);


--
-- Name: MediaAsset MediaAsset_storage_path_key; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public."MediaAsset"
    ADD CONSTRAINT "MediaAsset_storage_path_key" UNIQUE (storage_path);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: coupon_usages coupon_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.coupon_usages
    ADD CONSTRAINT coupon_usages_pkey PRIMARY KEY (id);


--
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: demo_requests demo_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.demo_requests
    ADD CONSTRAINT demo_requests_pkey PRIMARY KEY (id);


--
-- Name: domain_requests domain_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.domain_requests
    ADD CONSTRAINT domain_requests_pkey PRIMARY KEY (id);


--
-- Name: email_templates email_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.email_templates
    ADD CONSTRAINT email_templates_pkey PRIMARY KEY (id);


--
-- Name: event_tickets event_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.event_tickets
    ADD CONSTRAINT event_tickets_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: facilities facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.facilities
    ADD CONSTRAINT facilities_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: legal_entities legal_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.legal_entities
    ADD CONSTRAINT legal_entities_pkey PRIMARY KEY (id);


--
-- Name: package_inclusions package_inclusions_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.package_inclusions
    ADD CONSTRAINT package_inclusions_pkey PRIMARY KEY (id);


--
-- Name: package_windows package_windows_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.package_windows
    ADD CONSTRAINT package_windows_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: price_plans price_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.price_plans
    ADD CONSTRAINT price_plans_pkey PRIMARY KEY (id);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: restaurant_menu_categories restaurant_menu_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_menu_categories
    ADD CONSTRAINT restaurant_menu_categories_pkey PRIMARY KEY (id);


--
-- Name: restaurant_menu_items restaurant_menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_menu_items
    ADD CONSTRAINT restaurant_menu_items_pkey PRIMARY KEY (id);


--
-- Name: restaurant_reservations restaurant_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_reservations
    ADD CONSTRAINT restaurant_reservations_pkey PRIMARY KEY (id);


--
-- Name: restaurant_tables restaurant_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_pkey PRIMARY KEY (id);


--
-- Name: restaurants restaurants_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurants
    ADD CONSTRAINT restaurants_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: site_configs site_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.site_configs
    ADD CONSTRAINT site_configs_pkey PRIMARY KEY (id);


--
-- Name: sms_templates sms_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.sms_templates
    ADD CONSTRAINT sms_templates_pkey PRIMARY KEY (id);


--
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (id);


--
-- Name: super_admin_mailgun_config super_admin_mailgun_config_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.super_admin_mailgun_config
    ADD CONSTRAINT super_admin_mailgun_config_pkey PRIMARY KEY (id);


--
-- Name: super_admin_sms_configs super_admin_sms_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.super_admin_sms_configs
    ADD CONSTRAINT super_admin_sms_configs_pkey PRIMARY KEY (id);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: translations translations_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.translations
    ADD CONSTRAINT translations_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: translations uq_translation_key_language_tenant; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.translations
    ADD CONSTRAINT uq_translation_key_language_tenant UNIQUE (key, language_id, tenant_language_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_translation_key_language; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX idx_translation_key_language ON public.translations USING btree (key, language_id);


--
-- Name: ix_accounts_user_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_accounts_user_id ON public.accounts USING btree (user_id);


--
-- Name: ix_activities_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_activities_tenant_id ON public.activities USING btree (tenant_id);


--
-- Name: ix_bookings_customer_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_bookings_customer_id ON public.bookings USING btree (customer_id);


--
-- Name: ix_bookings_package_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_bookings_package_id ON public.bookings USING btree (package_id);


--
-- Name: ix_bookings_price_plan_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_bookings_price_plan_id ON public.bookings USING btree (price_plan_id);


--
-- Name: ix_bookings_property_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_bookings_property_id ON public.bookings USING btree (property_id);


--
-- Name: ix_bookings_room_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_bookings_room_id ON public.bookings USING btree (room_id);


--
-- Name: ix_bookings_short_booking_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_bookings_short_booking_id ON public.bookings USING btree (short_booking_id);


--
-- Name: ix_bookings_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_bookings_tenant_id ON public.bookings USING btree (tenant_id);


--
-- Name: ix_bookings_unit_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_bookings_unit_id ON public.bookings USING btree (unit_id);


--
-- Name: ix_campaigns_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_campaigns_tenant_id ON public.campaigns USING btree (tenant_id);


--
-- Name: ix_campaigns_tenant_status; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_campaigns_tenant_status ON public.campaigns USING btree (tenant_id, status);


--
-- Name: ix_campaigns_tenant_type; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_campaigns_tenant_type ON public.campaigns USING btree (tenant_id, type);


--
-- Name: ix_coupon_usages_booking_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_coupon_usages_booking_id ON public.coupon_usages USING btree (booking_id);


--
-- Name: ix_coupon_usages_coupon_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_coupon_usages_coupon_id ON public.coupon_usages USING btree (coupon_id);


--
-- Name: ix_coupon_usages_customer_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_coupon_usages_customer_id ON public.coupon_usages USING btree (customer_id);


--
-- Name: ix_coupons_code; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_coupons_code ON public.coupons USING btree (code);


--
-- Name: ix_coupons_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_coupons_tenant_id ON public.coupons USING btree (tenant_id);


--
-- Name: ix_customers_email; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_customers_email ON public.customers USING btree (email);


--
-- Name: ix_customers_phone; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_customers_phone ON public.customers USING btree (phone);


--
-- Name: ix_customers_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_customers_tenant_id ON public.customers USING btree (tenant_id);


--
-- Name: ix_demo_requests_email; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_demo_requests_email ON public.demo_requests USING btree (email);


--
-- Name: ix_demo_requests_status; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_demo_requests_status ON public.demo_requests USING btree (status);


--
-- Name: ix_domain_requests_domain; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_domain_requests_domain ON public.domain_requests USING btree (domain);


--
-- Name: ix_domain_requests_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_domain_requests_tenant_id ON public.domain_requests USING btree (tenant_id);


--
-- Name: ix_domain_requests_tenant_id_associated; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_domain_requests_tenant_id_associated ON public.domain_requests USING btree (tenant_id_associated);


--
-- Name: ix_email_templates_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_email_templates_tenant_id ON public.email_templates USING btree (tenant_id);


--
-- Name: ix_email_templates_tenant_type; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_email_templates_tenant_type ON public.email_templates USING btree (tenant_id, type);


--
-- Name: ix_event_tickets_event_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_event_tickets_event_id ON public.event_tickets USING btree (event_id);


--
-- Name: ix_event_tickets_guest_email; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_event_tickets_guest_email ON public.event_tickets USING btree (guest_email);


--
-- Name: ix_event_tickets_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_event_tickets_tenant_id ON public.event_tickets USING btree (tenant_id);


--
-- Name: ix_event_tickets_ticket_code; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_event_tickets_ticket_code ON public.event_tickets USING btree (ticket_code);


--
-- Name: ix_events_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_events_tenant_id ON public.events USING btree (tenant_id);


--
-- Name: ix_facilities_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_facilities_tenant_id ON public.facilities USING btree (tenant_id);


--
-- Name: ix_feedbacks_booking_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_feedbacks_booking_id ON public.feedbacks USING btree (booking_id);


--
-- Name: ix_feedbacks_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_feedbacks_tenant_id ON public.feedbacks USING btree (tenant_id);


--
-- Name: ix_invoices_booking_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_invoices_booking_id ON public.invoices USING btree (booking_id);


--
-- Name: ix_invoices_invoice_number; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_invoices_invoice_number ON public.invoices USING btree (invoice_number);


--
-- Name: ix_invoices_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_invoices_tenant_id ON public.invoices USING btree (tenant_id);


--
-- Name: ix_languages_code; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_languages_code ON public.languages USING btree (code);


--
-- Name: ix_legal_entities_cui; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_legal_entities_cui ON public.legal_entities USING btree (cui);


--
-- Name: ix_legal_entities_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_legal_entities_tenant_id ON public.legal_entities USING btree (tenant_id);


--
-- Name: ix_package_inclusions_package_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_package_inclusions_package_id ON public.package_inclusions USING btree (package_id);


--
-- Name: ix_package_windows_package_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_package_windows_package_id ON public.package_windows USING btree (package_id);


--
-- Name: ix_packages_slug; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_packages_slug ON public.packages USING btree (slug);


--
-- Name: ix_packages_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_packages_tenant_id ON public.packages USING btree (tenant_id);


--
-- Name: ix_price_plans_room_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_price_plans_room_id ON public.price_plans USING btree (room_id);


--
-- Name: ix_properties_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_properties_tenant_id ON public.properties USING btree (tenant_id);


--
-- Name: ix_public_MediaAsset_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX "ix_public_MediaAsset_tenant_id" ON public."MediaAsset" USING btree (tenant_id);


--
-- Name: ix_restaurant_menu_categories_restaurant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_restaurant_menu_categories_restaurant_id ON public.restaurant_menu_categories USING btree (restaurant_id);


--
-- Name: ix_restaurant_menu_categories_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_restaurant_menu_categories_tenant_id ON public.restaurant_menu_categories USING btree (tenant_id);


--
-- Name: ix_restaurant_menu_items_restaurant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_restaurant_menu_items_restaurant_id ON public.restaurant_menu_items USING btree (restaurant_id);


--
-- Name: ix_restaurant_reservations_restaurant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_restaurant_reservations_restaurant_id ON public.restaurant_reservations USING btree (restaurant_id);


--
-- Name: ix_restaurant_reservations_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_restaurant_reservations_tenant_id ON public.restaurant_reservations USING btree (tenant_id);


--
-- Name: ix_restaurant_tables_restaurant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_restaurant_tables_restaurant_id ON public.restaurant_tables USING btree (restaurant_id);


--
-- Name: ix_restaurant_tables_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_restaurant_tables_tenant_id ON public.restaurant_tables USING btree (tenant_id);


--
-- Name: ix_restaurants_slug; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_restaurants_slug ON public.restaurants USING btree (slug);


--
-- Name: ix_restaurants_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_restaurants_tenant_id ON public.restaurants USING btree (tenant_id);


--
-- Name: ix_rooms_property_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_rooms_property_id ON public.rooms USING btree (property_id);


--
-- Name: ix_sessions_session_token; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_sessions_session_token ON public.sessions USING btree (session_token);


--
-- Name: ix_sessions_user_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_sessions_user_id ON public.sessions USING btree (user_id);


--
-- Name: ix_site_configs_custom_domain; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_site_configs_custom_domain ON public.site_configs USING btree (custom_domain);


--
-- Name: ix_site_configs_site_slug; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_site_configs_site_slug ON public.site_configs USING btree (site_slug);


--
-- Name: ix_site_configs_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_site_configs_tenant_id ON public.site_configs USING btree (tenant_id);


--
-- Name: ix_sms_templates_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_sms_templates_tenant_id ON public.sms_templates USING btree (tenant_id);


--
-- Name: ix_sms_templates_tenant_type; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_sms_templates_tenant_type ON public.sms_templates USING btree (tenant_id, type);


--
-- Name: ix_subscription_plans_name; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_subscription_plans_name ON public.subscription_plans USING btree (name);


--
-- Name: ix_tenants_custom_domain; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_tenants_custom_domain ON public.tenants USING btree (custom_domain);


--
-- Name: ix_tenants_slug; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_tenants_slug ON public.tenants USING btree (slug);


--
-- Name: ix_tenants_subdomain; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_tenants_subdomain ON public.tenants USING btree (subdomain);


--
-- Name: ix_translations_key; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_translations_key ON public.translations USING btree (key);


--
-- Name: ix_translations_language_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_translations_language_id ON public.translations USING btree (language_id);


--
-- Name: ix_units_property_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_units_property_id ON public.units USING btree (property_id);


--
-- Name: ix_units_slug; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_units_slug ON public.units USING btree (slug);


--
-- Name: ix_units_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_units_tenant_id ON public.units USING btree (tenant_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_is_active; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_users_is_active ON public.users USING btree (is_active);


--
-- Name: ix_users_role; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_users_role ON public.users USING btree (role);


--
-- Name: ix_users_tenant_id; Type: INDEX; Schema: public; Owner: roompilot
--

CREATE INDEX ix_users_tenant_id ON public.users USING btree (tenant_id);


--
-- Name: MediaAsset MediaAsset_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public."MediaAsset"
    ADD CONSTRAINT "MediaAsset_tenant_id_fkey" FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: accounts accounts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: activities activities_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: bookings bookings_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: bookings bookings_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id) ON DELETE SET NULL;


--
-- Name: bookings bookings_price_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_price_plan_id_fkey FOREIGN KEY (price_plan_id) REFERENCES public.price_plans(id) ON DELETE SET NULL;


--
-- Name: bookings bookings_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- Name: bookings bookings_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE SET NULL;


--
-- Name: bookings bookings_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: bookings bookings_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE SET NULL;


--
-- Name: campaigns campaigns_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: coupon_usages coupon_usages_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.coupon_usages
    ADD CONSTRAINT coupon_usages_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE SET NULL;


--
-- Name: coupon_usages coupon_usages_coupon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.coupon_usages
    ADD CONSTRAINT coupon_usages_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id) ON DELETE CASCADE;


--
-- Name: coupon_usages coupon_usages_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.coupon_usages
    ADD CONSTRAINT coupon_usages_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: coupons coupons_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: customers customers_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: domain_requests domain_requests_tenant_id_associated_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.domain_requests
    ADD CONSTRAINT domain_requests_tenant_id_associated_fkey FOREIGN KEY (tenant_id_associated) REFERENCES public.tenants(id) ON DELETE SET NULL;


--
-- Name: domain_requests domain_requests_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.domain_requests
    ADD CONSTRAINT domain_requests_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: email_templates email_templates_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.email_templates
    ADD CONSTRAINT email_templates_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: event_tickets event_tickets_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.event_tickets
    ADD CONSTRAINT event_tickets_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_tickets event_tickets_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.event_tickets
    ADD CONSTRAINT event_tickets_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: events events_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: facilities facilities_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.facilities
    ADD CONSTRAINT facilities_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: feedbacks feedbacks_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE SET NULL;


--
-- Name: feedbacks feedbacks_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: restaurant_reservations fk_restaurant_reservations_table_id; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_reservations
    ADD CONSTRAINT fk_restaurant_reservations_table_id FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id) ON DELETE SET NULL;


--
-- Name: restaurant_reservations fk_restaurant_reservations_tenant_id; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_reservations
    ADD CONSTRAINT fk_restaurant_reservations_tenant_id FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: units fk_units_property_id; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT fk_units_property_id FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE SET NULL;


--
-- Name: invoices invoices_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE SET NULL;


--
-- Name: invoices invoices_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: legal_entities legal_entities_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.legal_entities
    ADD CONSTRAINT legal_entities_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: package_inclusions package_inclusions_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.package_inclusions
    ADD CONSTRAINT package_inclusions_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id) ON DELETE CASCADE;


--
-- Name: package_windows package_windows_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.package_windows
    ADD CONSTRAINT package_windows_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id) ON DELETE CASCADE;


--
-- Name: packages packages_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: price_plans price_plans_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.price_plans
    ADD CONSTRAINT price_plans_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: properties properties_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: restaurant_menu_categories restaurant_menu_categories_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_menu_categories
    ADD CONSTRAINT restaurant_menu_categories_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(id) ON DELETE CASCADE;


--
-- Name: restaurant_menu_categories restaurant_menu_categories_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_menu_categories
    ADD CONSTRAINT restaurant_menu_categories_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: restaurant_menu_items restaurant_menu_items_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_menu_items
    ADD CONSTRAINT restaurant_menu_items_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(id) ON DELETE CASCADE;


--
-- Name: restaurant_reservations restaurant_reservations_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_reservations
    ADD CONSTRAINT restaurant_reservations_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(id) ON DELETE CASCADE;


--
-- Name: restaurant_tables restaurant_tables_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(id) ON DELETE CASCADE;


--
-- Name: restaurant_tables restaurant_tables_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: restaurants restaurants_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.restaurants
    ADD CONSTRAINT restaurants_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: rooms rooms_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: site_configs site_configs_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.site_configs
    ADD CONSTRAINT site_configs_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: sms_templates sms_templates_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.sms_templates
    ADD CONSTRAINT sms_templates_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: translations translations_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.translations
    ADD CONSTRAINT translations_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- Name: units units_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: users users_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: roompilot
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict K7QeJ9yzsAbht4db7Fx36tL5POzSrelsCiC4KsXSTks3YmNa4SRfBCRxJoFm2ln

