-- Table: instrument
CREATE TABLE instrument (
    instrument_id UUID PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    instrument_type VARCHAR(20) NOT NULL,
    max_amount_usd NUMERIC(19,4) NOT NULL,
    restricted BOOLEAN DEFAULT FALSE
);

-- Table: trade_type
CREATE TABLE trade_type (
    trade_type_id UUID PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE
);

-- Table: instrument_allowed_trade_type
CREATE TABLE instrument_allowed_trade_type (
    instrument_id UUID NOT NULL,
    trade_type_id UUID NOT NULL,
    PRIMARY KEY (instrument_id, trade_type_id),
    FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id),
    FOREIGN KEY (trade_type_id) REFERENCES trade_type (trade_type_id)
);

-- Table: trader
CREATE TABLE trader (
    trader_id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    authorization_level VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: role
CREATE TABLE role (
    role_id UUID PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- Table: trader_role
CREATE TABLE trader_role (
    trader_id UUID NOT NULL,
    role_id UUID NOT NULL,
    PRIMARY KEY (trader_id, role_id),
    FOREIGN KEY (trader_id) REFERENCES trader (trader_id),
    FOREIGN KEY (role_id) REFERENCES role (role_id)
);

-- Table: trade
CREATE TABLE trade (
    trade_id UUID PRIMARY KEY,
    trader_id UUID NOT NULL,
    instrument_id UUID NOT NULL,
    amount NUMERIC(19,4) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    trade_type VARCHAR(20) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    compliance_status VARCHAR(10) NOT NULL,
    compliance_remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trader_id) REFERENCES trader (trader_id),
    FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id)
);

-- Table: compliance_rule
CREATE TABLE compliance_rule (
    rule_id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    instrument_id UUID NULL,
    instrument_type VARCHAR(20) NULL,
    rule_type VARCHAR(50) NOT NULL,
    rule_parameters JSONB,
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id)
);

-- Table: trade_compliance_log
CREATE TABLE trade_compliance_log (
    log_id UUID PRIMARY KEY,
    trade_id UUID NOT NULL,
    rule_id UUID NOT NULL,
    check_result VARCHAR(10) NOT NULL,
    remarks TEXT,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trade_id) REFERENCES trade (trade_id),
    FOREIGN KEY (rule_id) REFERENCES compliance_rule (rule_id)
);
