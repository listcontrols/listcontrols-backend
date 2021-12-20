CREATE SCHEMA listcontrols;
ALTER
    SCHEMA listcontrols OWNER TO admin;

-- time unit
CREATE TABLE listcontrols.time_unit
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

-- intervention_period_reference_point
CREATE TABLE listcontrols.intervention_period_reference_point
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE listcontrols.intervention_type
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE listcontrols.journal
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    link TEXT,
    rank TEXT
);

CREATE TABLE listcontrols.metabolic_enzyme
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE listcontrols.species
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE listcontrols.sex
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE listcontrols.nutrition
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE listcontrols.organisms_density
(
    id        INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    number    INTEGER NOT NULL,
    area      NUMERIC,
    area_unit TEXT,
    constancy boolean
);


CREATE TABLE listcontrols.dosage_unit
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE listcontrols.drug_target
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE listcontrols.experiment_site
(
    id          INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT
);

CREATE TABLE listcontrols.strain
(
    id         INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name       TEXT    NOT NULL,
    species_id INTEGER NOT NULL REFERENCES listcontrols.species (id) ON DELETE CASCADE
);

CREATE TABLE listcontrols.control_group
(
    id                        INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    description               TEXT,
    control_min_lifespan      NUMERIC,
    control_max_lifespan      NUMERIC,
    control_median_lifespan   NUMERIC,
    lifespan_unit_id          INTEGER REFERENCES listcontrols.time_unit (id) ON DELETE CASCADE,
    organisms_density_id      INTEGER REFERENCES listcontrols.organisms_density (id) ON DELETE CASCADE,
    survival_plot_source_link TEXT,
    survival_plot_coordinates jsonb,
    survival_raw_data         jsonb
);

CREATE TABLE listcontrols.publication
(
    id         INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "DOI"      TEXT,
    "PMID"     TEXT,
    date       date,
    journal_id INTEGER REFERENCES listcontrols.journal (id) ON DELETE CASCADE,
    authors    TEXT
);

CREATE TABLE listcontrols.experiment
(
    id                            INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name                          TEXT,
    publication_id                INTEGER NOT NULL REFERENCES listcontrols.publication (id) ON DELETE CASCADE,
    species_id                    INTEGER NOT NULL REFERENCES listcontrols.species (id) ON DELETE CASCADE,
    control_group_id              INTEGER REFERENCES listcontrols.control_group (id) ON DELETE CASCADE,
    strain_id                     INTEGER REFERENCES listcontrols.strain (id) ON DELETE CASCADE,
    experiment_site_id            INTEGER REFERENCES listcontrols.experiment_site (id) ON DELETE CASCADE,
    result_change_max_lifespan    NUMERIC,
    result_change_median_lifespan NUMERIC,
    sex_id                        INTEGER REFERENCES listcontrols.sex (id) ON DELETE CASCADE,
    -- temperature_conditions
    temp_cond_range               numrange,
    temp_cond_constance           boolean,
    -- light_conditions
    light_cond_light_hours        NUMERIC,
    light_cond_dark_hours         NUMERIC,
    -- diet_condition
    diet_cond_feed_id             INTEGER,
    diet_cond_feed                TEXT,
    diet_cond_times_per_day       NUMERIC
);


CREATE TABLE listcontrols.treatment_group
(
    id                   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    size                 INTEGER NOT NULL,
    survival_plot_data   jsonb,
    min_lifespan         NUMERIC,
    mean_lifespan        NUMERIC,
    median_lifespan      NUMERIC,
    max_lifespan         NUMERIC,
    lifespan_unit_id     INTEGER REFERENCES listcontrols.time_unit (id) ON DELETE CASCADE,
    organisms_density_id INTEGER REFERENCES listcontrols.organisms_density (id) ON DELETE CASCADE
);

CREATE TABLE listcontrols.intervention
(
    id                              INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    intervention_type_id            INTEGER NOT NULL REFERENCES listcontrols.intervention_type (id) ON DELETE CASCADE,
    experiment_id                   INTEGER NOT NULL REFERENCES listcontrols.experiment (id) ON DELETE CASCADE,
    active_substance_id             INTEGER,
    dosage                          NUMERIC,
    dosage_unit_id                  INTEGER,
    treatment_group_id              INTEGER REFERENCES listcontrols.treatment_group (id) ON DELETE CASCADE,
    start_time                      NUMERIC,
    start_time_reference_point_id   INTEGER REFERENCES listcontrols.intervention_period_reference_point (id) ON DELETE CASCADE,
    end_time_reference_point_id     INTEGER REFERENCES listcontrols.intervention_period_reference_point (id) ON DELETE CASCADE,
    end_time                        NUMERIC,
    substance_delivery_way_id       INTEGER,
    substance_delivery_frequency_id INTEGER,
    substance_delivery_method       TEXT
);
