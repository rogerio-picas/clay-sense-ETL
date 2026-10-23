-- public.kiln definition

-- Drop table

-- DROP TABLE public.kiln;

CREATE TABLE public.kiln (
	kiln_id varchar(20) NOT NULL,
	description varchar(100) NULL,
	max_operating_temp numeric(6, 2) DEFAULT 1300.0 NULL,
	height int4 NULL,
	width int4 NULL,
	"depth" int4 NULL,
	CONSTRAINT kilns_kiln_id_not_null NOT NULL kiln_id,
	CONSTRAINT kilns_pkey PRIMARY KEY (kiln_id)
);


-- public.log_rejections_audit definition

-- Drop table

-- DROP TABLE public.log_rejections_audit;

CREATE TABLE public.log_rejections_audit (
	id serial4 NOT NULL,
	source_record_id varchar(50) NULL,
	source_file varchar(50) NULL,
	raw_data text NULL,
	rejection_reason varchar(100) NULL,
	rejected_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT log_rejections_audit_id_not_null NOT NULL id,
	CONSTRAINT log_rejections_audit_pkey PRIMARY KEY (id)
);


-- public.production definition

-- Drop table

-- DROP TABLE public.production;

CREATE TABLE public.production (
	batch_id varchar(30) NOT NULL,
	production_date date NOT NULL,
	potter_name varchar(100) NULL,
	category varchar(100) NULL,
	total_qty int4 NOT NULL,
	broken_pieces int4 NOT NULL,
	approved_pieces int4 NOT NULL,
	defect_rate_pct numeric(5, 2) NULL,
	external_humidity_pct numeric(5, 2) NULL,
	processed_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT production_approved_pieces_not_null NOT NULL approved_pieces,
	CONSTRAINT production_batch_id_not_null NOT NULL batch_id,
	CONSTRAINT production_broken_pieces_not_null NOT NULL broken_pieces,
	CONSTRAINT production_pkey PRIMARY KEY (batch_id),
	CONSTRAINT production_production_date_not_null NOT NULL production_date,
	CONSTRAINT production_total_qty_not_null NOT NULL total_qty
);


-- public.batch_cost definition

-- Drop table

-- DROP TABLE public.batch_cost;

CREATE TABLE public.batch_cost (
	id int4 DEFAULT nextval('batch_costs_id_seq'::regclass) NOT NULL,
	batch_id varchar(30) NULL,
	market_kwh_price numeric(10, 4) NULL,
	total_energy_cost numeric(12, 2) NULL,
	energy_cost_per_piece numeric(10, 4) NULL,
	calculated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	total_kwh_consumed numeric(12, 2) NULL,
	gas_consumed_m3 numeric(12, 2) NULL,
	CONSTRAINT batch_costs_id_not_null NOT NULL id,
	CONSTRAINT batch_costs_pkey PRIMARY KEY (id),
	CONSTRAINT batch_cost_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.production(batch_id) ON DELETE CASCADE
);


-- public.kiln_firing definition

-- Drop table

-- DROP TABLE public.kiln_firing;

CREATE TABLE public.kiln_firing (
	firing_id int4 NOT NULL,
	kiln_id varchar(20) NOT NULL,
	firing_duration_hours numeric(5, 2) NULL,
	temp_increase_rate numeric(6, 2) NULL,
	temp_anomaly bool NULL,
	rate_anomaly bool NULL,
	firing_anomaly bool NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	max_temp_recorded numeric(6, 2) NULL,
	CONSTRAINT kiln_firing_firing_id_not_null NOT NULL firing_id,
	CONSTRAINT kiln_firing_kiln_id_not_null NOT NULL kiln_id,
	CONSTRAINT kiln_firing_pkey PRIMARY KEY (firing_id),
	CONSTRAINT kiln_firing_kiln_id_fkey FOREIGN KEY (kiln_id) REFERENCES public.kiln(kiln_id)
);


-- public.firing_batch definition

-- Drop table

-- DROP TABLE public.firing_batch;

CREATE TABLE public.firing_batch (
	firing_id int4 NOT NULL,
	batch_id varchar(30) NOT NULL,
	quantity_loaded int4 NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT firing_batch_batch_id_not_null NOT NULL batch_id,
	CONSTRAINT firing_batch_firing_id_not_null NOT NULL firing_id,
	CONSTRAINT firing_batch_pkey PRIMARY KEY (firing_id, batch_id),
	CONSTRAINT firing_batch_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.production(batch_id) ON DELETE CASCADE,
	CONSTRAINT firing_batch_firing_id_fkey FOREIGN KEY (firing_id) REFERENCES public.kiln_firing(firing_id) ON DELETE CASCADE
);