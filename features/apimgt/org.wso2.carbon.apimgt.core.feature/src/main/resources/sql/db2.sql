-- Start of IDENTITY Tables--
CREATE TABLE IDN_BASE_TABLE (
            PRODUCT_NAME VARCHAR(20) NOT NULL,
            PRIMARY KEY (PRODUCT_NAME)
)/

INSERT INTO IDN_BASE_TABLE values ('WSO2 Identity Server')/

CREATE TABLE IDN_OAUTH_CONSUMER_APPS (
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            CONSUMER_KEY VARCHAR(255) NOT NULL,
            CONSUMER_SECRET VARCHAR(512),
            USERNAME VARCHAR(255),
            TENANT_ID INTEGER DEFAULT 0,
            USER_DOMAIN VARCHAR(50),
            APP_NAME VARCHAR(255),
            OAUTH_VERSION VARCHAR(128),
            CALLBACK_URL VARCHAR(1024),
            GRANT_TYPES VARCHAR (1024),
            CONSTRAINT CONSUMER_KEY_CONSTRAINT UNIQUE (CONSUMER_KEY),
            PRIMARY KEY (ID)
)/

CREATE TABLE IDN_OAUTH1A_REQUEST_TOKEN (
            REQUEST_TOKEN VARCHAR(255) NOT NULL,
            REQUEST_TOKEN_SECRET VARCHAR(512),
            CONSUMER_KEY_ID INTEGER,
            CALLBACK_URL VARCHAR(1024),
            SCOPE VARCHAR(2048),
            AUTHORIZED VARCHAR(128),
            OAUTH_VERIFIER VARCHAR(512),
            AUTHZ_USER VARCHAR(512),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (REQUEST_TOKEN),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
)/

CREATE TABLE IDN_OAUTH1A_ACCESS_TOKEN (
            ACCESS_TOKEN VARCHAR(255) NOT NULL,
            ACCESS_TOKEN_SECRET VARCHAR(512),
            CONSUMER_KEY_ID INTEGER,
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR(512),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
)/

CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN (
            TOKEN_ID VARCHAR (255) NOT NULL,
            ACCESS_TOKEN VARCHAR(255) NOT NULL,
            REFRESH_TOKEN VARCHAR(255),
            CONSUMER_KEY_ID INTEGER NOT NULL,
            AUTHZ_USER VARCHAR(100) NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            USER_DOMAIN VARCHAR(50) NOT NULL,
            USER_TYPE VARCHAR (25) NOT NULL,
            GRANT_TYPE VARCHAR (50),
            TIME_CREATED TIMESTAMP DEFAULT CURRENT TIMESTAMP,
            REFRESH_TOKEN_TIME_CREATED TIMESTAMP DEFAULT CURRENT TIMESTAMP,
            VALIDITY_PERIOD BIGINT,
            REFRESH_TOKEN_VALIDITY_PERIOD BIGINT,
            TOKEN_SCOPE_HASH VARCHAR(32) NOT NULL,
            TOKEN_STATE VARCHAR(25) NOT NULL DEFAULT 'ACTIVE',
            TOKEN_STATE_ID VARCHAR (128) NOT NULL DEFAULT 'NONE',
            SUBJECT_IDENTIFIER VARCHAR(255),
            PRIMARY KEY (TOKEN_ID),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE,
            CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY_ID, AUTHZ_USER,TENANT_ID,USER_DOMAIN,USER_TYPE,TOKEN_SCOPE_HASH,
                                           TOKEN_STATE,TOKEN_STATE_ID)
)/

CREATE INDEX IDX_AT_CK_AU ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY_ID, AUTHZ_USER, TOKEN_STATE, USER_TYPE)/

CREATE INDEX IDX_TC ON IDN_OAUTH2_ACCESS_TOKEN(TIME_CREATED)/
CREATE TABLE IDN_OAUTH2_AUTHORIZATION_CODE (
            CODE_ID VARCHAR (255) NOT NULL,
            AUTHORIZATION_CODE VARCHAR(512),
            CONSUMER_KEY_ID INTEGER,
            CALLBACK_URL VARCHAR(1024),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR(100),
            TENANT_ID INTEGER,
            USER_DOMAIN VARCHAR(50),
            TIME_CREATED TIMESTAMP,
            VALIDITY_PERIOD BIGINT,
            STATE VARCHAR (25) DEFAULT 'ACTIVE',
            TOKEN_ID VARCHAR(255),
            SUBJECT_IDENTIFIER VARCHAR(255),
            PRIMARY KEY (CODE_ID),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
)/

CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN_SCOPE (
            TOKEN_ID VARCHAR (255) NOT NULL,
            TOKEN_SCOPE VARCHAR (60) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (TOKEN_ID, TOKEN_SCOPE),
            FOREIGN KEY (TOKEN_ID) REFERENCES IDN_OAUTH2_ACCESS_TOKEN(TOKEN_ID) ON DELETE CASCADE
)/

CREATE TABLE IDN_OAUTH2_SCOPE (
            SCOPE_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            SCOPE_KEY VARCHAR(100) NOT NULL,
            NAME VARCHAR(255) NULL,
            DESCRIPTION VARCHAR(512) NULL,
            TENANT_ID INTEGER NOT NULL DEFAULT 0,
            ROLES VARCHAR (500) NULL,
            PRIMARY KEY (SCOPE_ID)
)/

CREATE TABLE IDN_OAUTH2_RESOURCE_SCOPE (
            RESOURCE_PATH VARCHAR(255) NOT NULL,
            SCOPE_ID INTEGER NOT NULL,
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (RESOURCE_PATH),
            FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE
)/

CREATE TABLE IDN_SCIM_GROUP (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            ROLE_NAME VARCHAR(255) NOT NULL,
            ATTR_NAME VARCHAR(1024) NOT NULL,
            ATTR_VALUE VARCHAR(1024),
            PRIMARY KEY (ID)
)/

CREATE TABLE IDN_OPENID_REMEMBER_ME (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL DEFAULT 0,
            COOKIE_VALUE VARCHAR(1024),
            CREATED_TIME TIMESTAMP,
            PRIMARY KEY (USER_NAME, TENANT_ID)
)/

CREATE TABLE IDN_OPENID_USER_RPS (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL DEFAULT 0,
            RP_URL VARCHAR(255) NOT NULL,
            TRUSTED_ALWAYS VARCHAR(128) DEFAULT 'FALSE',
            LAST_VISIT DATE NOT NULL,
            VISIT_COUNT INTEGER DEFAULT 0,
            DEFAULT_PROFILE_NAME VARCHAR(255) DEFAULT 'DEFAULT',
            PRIMARY KEY (USER_NAME, TENANT_ID, RP_URL)
)/

CREATE TABLE IDN_OPENID_ASSOCIATIONS (
            HANDLE VARCHAR(255) NOT NULL,
            ASSOC_TYPE VARCHAR(255) NOT NULL,
            EXPIRE_IN TIMESTAMP NOT NULL,
            MAC_KEY VARCHAR(255) NOT NULL,
            ASSOC_STORE VARCHAR(128) DEFAULT 'SHARED',
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (HANDLE)
)/

CREATE TABLE IDN_STS_STORE (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TOKEN_ID VARCHAR(255) NOT NULL,
            TOKEN_CONTENT BLOB(1024) NOT NULL,
            CREATE_DATE TIMESTAMP NOT NULL,
            EXPIRE_DATE TIMESTAMP NOT NULL,
            STATE INTEGER DEFAULT 0,
            PRIMARY KEY (ID)
)/

CREATE TABLE IDN_IDENTITY_USER_DATA (
            TENANT_ID INTEGER NOT NULL DEFAULT -1234,
            USER_NAME VARCHAR(255) NOT NULL,
            DATA_KEY VARCHAR(255) NOT NULL,
            DATA_VALUE VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, DATA_KEY)
)/

CREATE TABLE IDN_IDENTITY_META_DATA (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL DEFAULT -1234,
            METADATA_TYPE VARCHAR(255) NOT NULL,
            METADATA VARCHAR(255) NOT NULL,
            VALID VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, METADATA_TYPE,METADATA)
)/

CREATE TABLE IDN_THRIFT_SESSION (
            SESSION_ID VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            CREATED_TIME VARCHAR(255) NOT NULL,
            LAST_MODIFIED_TIME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (SESSION_ID)
)/

CREATE TABLE IDN_AUTH_SESSION_STORE (
            SESSION_ID VARCHAR (100) NOT NULL,
            SESSION_TYPE VARCHAR(100) NOT NULL,
            OPERATION VARCHAR(10) NOT NULL,
            SESSION_OBJECT BLOB,
            TIME_CREATED BIGINT NOT NULL,
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (SESSION_ID, SESSION_TYPE, TIME_CREATED, OPERATION)
)/

CREATE TABLE SP_APP (
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            APP_NAME VARCHAR (255) NOT NULL ,
            USER_STORE VARCHAR (255) NOT NULL,
            USERNAME VARCHAR (255) NOT NULL ,
            DESCRIPTION VARCHAR (1024),
            ROLE_CLAIM VARCHAR (512),
            AUTH_TYPE VARCHAR (255) NOT NULL,
            PROVISIONING_USERSTORE_DOMAIN VARCHAR (512),
            IS_LOCAL_CLAIM_DIALECT CHAR(1) DEFAULT '1',
            IS_SEND_LOCAL_SUBJECT_ID CHAR(1) DEFAULT '0',
            IS_SEND_AUTH_LIST_OF_IDPS CHAR(1) DEFAULT '0',
            IS_USE_TENANT_DOMAIN_SUBJECT CHAR(1) DEFAULT '1',
            IS_USE_USER_DOMAIN_SUBJECT CHAR(1) DEFAULT '1',
            SUBJECT_CLAIM_URI VARCHAR (512),
            IS_SAAS_APP CHAR(1) DEFAULT '0',
            IS_DUMB_MODE CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID)
)/

ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_NAME_CONSTRAINT UNIQUE(APP_NAME, TENANT_ID)/

CREATE TABLE SP_METADATA (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            SP_ID INTEGER NOT NULL,
            NAME VARCHAR(255) NOT NULL,
            VALUE VARCHAR(255) NOT NULL,
            DISPLAY_NAME VARCHAR(255),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (ID),
            CONSTRAINT SP_METADATA_CONSTRAINT UNIQUE (SP_ID, NAME),
            FOREIGN KEY (SP_ID) REFERENCES SP_APP(ID) ON DELETE CASCADE
)/

CREATE TABLE SP_INBOUND_AUTH (
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            INBOUND_AUTH_KEY VARCHAR (255) NOT NULL,
            INBOUND_AUTH_TYPE VARCHAR (255) NOT NULL,
            PROP_NAME VARCHAR (255),
            PROP_VALUE VARCHAR (1024) ,
            APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)/

ALTER TABLE SP_INBOUND_AUTH ADD CONSTRAINT APPLICATION_ID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE/

CREATE TABLE SP_AUTH_STEP (
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            STEP_ORDER INTEGER DEFAULT 1,
            APP_ID INTEGER NOT NULL ,
            IS_SUBJECT_STEP CHAR(1) DEFAULT '0',
            IS_ATTRIBUTE_STEP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID)
)/

ALTER TABLE SP_AUTH_STEP ADD CONSTRAINT APPLICATION_ID_CONSTRAINT_STEP FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE/

CREATE TABLE SP_FEDERATED_IDP (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_ID INTEGER NOT NULL,
            PRIMARY KEY (ID, AUTHENTICATOR_ID)
)/

ALTER TABLE SP_FEDERATED_IDP ADD CONSTRAINT STEP_ID_CONSTRAINT FOREIGN KEY (ID) REFERENCES SP_AUTH_STEP (ID) ON DELETE CASCADE/

CREATE TABLE SP_CLAIM_MAPPING (
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            IDP_CLAIM VARCHAR (512) NOT NULL ,
            SP_CLAIM VARCHAR (512) NOT NULL ,
            APP_ID INTEGER NOT NULL,
            IS_REQUESTED VARCHAR(128) DEFAULT '0',
            DEFAULT_VALUE VARCHAR(255),
            PRIMARY KEY (ID)
)/

ALTER TABLE SP_CLAIM_MAPPING ADD CONSTRAINT CLAIMID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE/

CREATE TABLE SP_ROLE_MAPPING (
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            IDP_ROLE VARCHAR (255) NOT NULL ,
            SP_ROLE VARCHAR (255) NOT NULL ,
            APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)/

ALTER TABLE SP_ROLE_MAPPING ADD CONSTRAINT ROLEID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE/

CREATE TABLE SP_REQ_PATH_AUTHENTICATOR (
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_NAME VARCHAR (255) NOT NULL ,
            APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)/

ALTER TABLE SP_REQ_PATH_AUTHENTICATOR ADD CONSTRAINT REQ_AUTH_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE/

CREATE TABLE SP_PROVISIONING_CONNECTOR (
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            IDP_NAME VARCHAR (255) NOT NULL ,
            CONNECTOR_NAME VARCHAR (255) NOT NULL ,
            APP_ID INTEGER NOT NULL,
            IS_JIT_ENABLED CHAR(1) NOT NULL DEFAULT '0',
            BLOCKING CHAR(1) NOT NULL DEFAULT '0',
            PRIMARY KEY (ID)
)/

ALTER TABLE SP_PROVISIONING_CONNECTOR ADD CONSTRAINT PRO_CONNECTOR_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE/

CREATE TABLE IDP (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            NAME VARCHAR(254) NOT NULL,
            IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
            IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
            HOME_REALM_ID VARCHAR(254),
            IMAGE BLOB(16M),
            CERTIFICATE BLOB,
            ALIAS VARCHAR(254),
            INBOUND_PROV_ENABLED CHAR (1) NOT NULL DEFAULT '0',
            INBOUND_PROV_USER_STORE_ID VARCHAR(254),
            USER_CLAIM_URI VARCHAR(254),
            ROLE_CLAIM_URI VARCHAR(254),
            DESCRIPTION VARCHAR (1024),
            DEFAULT_AUTHENTICATOR_NAME VARCHAR(254),
            DEFAULT_PRO_CONNECTOR_NAME VARCHAR(254),
            PROVISIONING_ROLE VARCHAR(128),
            IS_FEDERATION_HUB CHAR(1) NOT NULL DEFAULT '0',
            IS_LOCAL_CLAIM_DIALECT CHAR(1) NOT NULL DEFAULT '0',
            DISPLAY_NAME VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, NAME)
)/

INSERT INTO IDP (TENANT_ID, NAME, HOME_REALM_ID) VALUES (-1234, 'LOCAL', 'localhost')/

CREATE TABLE IDP_ROLE (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            IDP_ID INTEGER NOT NULL,
            TENANT_ID INTEGER,
            ROLE VARCHAR(254) NOT NULL,
            PRIMARY KEY (ID),
            UNIQUE (IDP_ID, ROLE),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)/

CREATE TABLE IDP_ROLE_MAPPING (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            IDP_ROLE_ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            USER_STORE_ID VARCHAR (253) NOT NULL,
            LOCAL_ROLE VARCHAR(253) NOT NULL ,
            PRIMARY KEY (ID),
            UNIQUE (IDP_ROLE_ID, TENANT_ID, USER_STORE_ID, LOCAL_ROLE),
            FOREIGN KEY (IDP_ROLE_ID) REFERENCES IDP_ROLE(ID) ON DELETE CASCADE
)/

CREATE TABLE IDP_CLAIM (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            IDP_ID INTEGER NOT NULL,
            TENANT_ID INTEGER,
            CLAIM VARCHAR(254) NOT NULL,
            PRIMARY KEY (ID),
            UNIQUE (IDP_ID, CLAIM),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)/

CREATE TABLE IDP_CLAIM_MAPPING (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            IDP_CLAIM_ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            LOCAL_CLAIM VARCHAR(253) NOT NULL,
            DEFAULT_VALUE VARCHAR(255),
            IS_REQUESTED VARCHAR(128) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (IDP_CLAIM_ID, TENANT_ID, LOCAL_CLAIM),
            FOREIGN KEY (IDP_CLAIM_ID) REFERENCES IDP_CLAIM(ID) ON DELETE CASCADE
)/

CREATE TABLE IDP_AUTHENTICATOR (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            IDP_ID INTEGER NOT NULL,
            NAME VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '1',
            DISPLAY_NAME VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)/

INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'samlsso')/
INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'IDPProperties')/
INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'passivests')/

CREATE TABLE IDP_METADATA (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            IDP_ID INTEGER NOT NULL,
            NAME VARCHAR(255) NOT NULL,
            VALUE VARCHAR(255) NOT NULL,
            DISPLAY_NAME VARCHAR(255),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (ID),
            CONSTRAINT IDP_METADATA_CONSTRAINT UNIQUE (IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)/

INSERT INTO IDP_METADATA (IDP_ID, NAME, VALUE, DISPLAY_NAME) VALUES (1, 'SessionIdleTimeout', '20160', 'Session Idle Timeout')/
INSERT INTO IDP_METADATA (IDP_ID, NAME, VALUE, DISPLAY_NAME) VALUES (1, 'RememberMeTimeout', '15', 'RememberMe Timeout')/

CREATE TABLE IDP_AUTHENTICATOR_PROPERTY (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_ID INTEGER NOT NULL,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2047),
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY),
            FOREIGN KEY (AUTHENTICATOR_ID) REFERENCES IDP_AUTHENTICATOR(ID) ON DELETE CASCADE
)/

INSERT INTO  IDP_AUTHENTICATOR_PROPERTY (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY,PROPERTY_VALUE, IS_SECRET ) VALUES (-1234, 1 , 'IdPEntityId', 'localhost', '0')/
INSERT INTO  IDP_AUTHENTICATOR_PROPERTY (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY,PROPERTY_VALUE, IS_SECRET ) VALUES (-1234, 3 , 'IdPEntityId', 'localhost', '0')/


CREATE TABLE IDP_PROVISIONING_CONFIG (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            IDP_ID INTEGER NOT NULL,
            PROVISIONING_CONNECTOR_TYPE VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '0',
            IS_BLOCKING CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, PROVISIONING_CONNECTOR_TYPE),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)/

CREATE TABLE IDP_PROV_CONFIG_PROPERTY (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            PROVISIONING_CONFIG_ID INTEGER NOT NULL,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2048),
            PROPERTY_BLOB_VALUE BLOB,
            PROPERTY_TYPE CHAR(32) NOT NULL,
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, PROVISIONING_CONFIG_ID, PROPERTY_KEY),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE
)/

CREATE TABLE IDP_PROVISIONING_ENTITY (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            PROVISIONING_CONFIG_ID INTEGER NOT NULL,
            ENTITY_TYPE VARCHAR(255) NOT NULL,
            ENTITY_LOCAL_USERSTORE VARCHAR(255) NOT NULL,
            ENTITY_NAME VARCHAR(255) NOT NULL,
            ENTITY_VALUE VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            ENTITY_LOCAL_ID VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (ENTITY_TYPE, TENANT_ID, ENTITY_LOCAL_USERSTORE, ENTITY_NAME, PROVISIONING_CONFIG_ID),
            UNIQUE (PROVISIONING_CONFIG_ID, ENTITY_TYPE, ENTITY_VALUE),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE
)/

CREATE TABLE IDP_LOCAL_CLAIM (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TENANT_ID INTEGER NOT NULL,
            IDP_ID INTEGER NOT NULL,
            CLAIM_URI VARCHAR(255) NOT NULL,
            DEFAULT_VALUE VARCHAR(255),
            IS_REQUESTED VARCHAR(128) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, CLAIM_URI),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)/

CREATE TABLE IDN_ASSOCIATED_ID (
            ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            IDP_USER_ID VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL DEFAULT -1234,
            IDP_ID INTEGER NOT NULL,
            DOMAIN_NAME VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            PRIMARY KEY (ID),
            UNIQUE(IDP_USER_ID, TENANT_ID, IDP_ID),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)/

CREATE TABLE IDN_USER_ACCOUNT_ASSOCIATION (
            ASSOCIATION_KEY VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            DOMAIN_NAME VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME)
)/

CREATE TABLE FIDO_DEVICE_STORE (
            TENANT_ID INTEGER NOT NULL,
            DOMAIN_NAME VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(45) NOT NULL,
            TIME_REGISTERED TIMESTAMP,
            KEY_HANDLE VARCHAR(200) NOT NULL,
            DEVICE_DATA VARCHAR(2048) NOT NULL,
            PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME, KEY_HANDLE)
        )/

CREATE TABLE WF_REQUEST (
            UUID VARCHAR (45) NOT NULL,
            CREATED_BY VARCHAR (255),
            TENANT_ID INTEGER DEFAULT -1,
            OPERATION_TYPE VARCHAR (50),
            CREATED_AT TIMESTAMP,
            UPDATED_AT TIMESTAMP,
            STATUS VARCHAR (30),
            REQUEST BLOB,
            PRIMARY KEY (UUID)
)/

CREATE TABLE WF_BPS_PROFILE (
            PROFILE_NAME VARCHAR(45) NOT NULL,
            HOST_URL_MANAGER VARCHAR(45),
            HOST_URL_WORKER VARCHAR(45),
            USERNAME VARCHAR(45),
            PASSWORD VARCHAR(255),
            CALLBACK_HOST VARCHAR (45),
            CALLBACK_USERNAME VARCHAR (45),
            CALLBACK_PASSWORD VARCHAR (255),
            TENANT_ID INTEGER DEFAULT -1 NOT NULL,
            PRIMARY KEY (PROFILE_NAME, TENANT_ID)
)/

CREATE TABLE WF_WORKFLOW(
            ID VARCHAR (45) NOT NULL,
            WF_NAME VARCHAR (45),
            DESCRIPTION VARCHAR (255),
            TEMPLATE_ID VARCHAR (45),
            IMPL_ID VARCHAR (45),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (ID)
)/

CREATE TABLE WF_WORKFLOW_ASSOCIATION(
            ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            ASSOC_NAME VARCHAR (45),
            EVENT_ID VARCHAR(45),
            ASSOC_CONDITION VARCHAR (2000),
            WORKFLOW_ID VARCHAR (45),
            IS_ENABLED CHAR (1) DEFAULT '1',
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY(ID),
            FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE
)/

CREATE TABLE WF_WORKFLOW_CONFIG_PARAM(
            WORKFLOW_ID VARCHAR (45) NOT NULL,
            PARAM_NAME VARCHAR (45) NOT NULL,
            PARAM_VALUE VARCHAR (1000),
            PARAM_QNAME VARCHAR (45) NOT NULL,
            PARAM_HOLDER VARCHAR (45) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (WORKFLOW_ID, PARAM_NAME, PARAM_QNAME, PARAM_HOLDER),
            FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE
)/

CREATE TABLE WF_REQUEST_ENTITY_RELATIONSHIP(
            REQUEST_ID VARCHAR (45) NOT NULL,
            ENTITY_NAME VARCHAR (255) NOT NULL,
            ENTITY_TYPE VARCHAR (50) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1 NOT NULL,
            PRIMARY KEY(REQUEST_ID, ENTITY_NAME, ENTITY_TYPE, TENANT_ID),
            FOREIGN KEY (REQUEST_ID) REFERENCES WF_REQUEST(UUID)ON DELETE CASCADE
)/

CREATE TABLE WF_WORKFLOW_REQUEST_RELATION(
            RELATIONSHIP_ID VARCHAR (45) NOT NULL,
            WORKFLOW_ID VARCHAR (45),
            REQUEST_ID VARCHAR (45),
            UPDATED_AT TIMESTAMP,
            STATUS VARCHAR (30),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (RELATIONSHIP_ID),
            FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE,
            FOREIGN KEY (REQUEST_ID) REFERENCES WF_REQUEST(UUID)ON DELETE CASCADE
)/

-- End of IDENTITY Tables--


-- Start of API-MGT Tables --
CREATE TABLE AM_SUBSCRIBER (
            SUBSCRIBER_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            USER_ID VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            EMAIL_ADDRESS VARCHAR(256) NULL,
            DATE_SUBSCRIBED TIMESTAMP NOT NULL,
            PRIMARY KEY (SUBSCRIBER_ID),
            CREATED_BY VARCHAR(100),
            CREATED_TIME TIMESTAMP,
            UPDATED_BY VARCHAR(100),
            UPDATED_TIME TIMESTAMP,
            UNIQUE (TENANT_ID,USER_ID)
)/

CREATE TABLE AM_APPLICATION (
            APPLICATION_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            NAME VARCHAR(100) NOT NULL,
            SUBSCRIBER_ID INTEGER NOT NULL,
            APPLICATION_TIER VARCHAR(50) DEFAULT 'Unlimited',
            CALLBACK_URL VARCHAR(512),
            DESCRIPTION VARCHAR(512),
            APPLICATION_STATUS VARCHAR(50) DEFAULT 'APPROVED',
            GROUP_ID VARCHAR(100),
            CREATED_BY VARCHAR(100),
            CREATED_TIME TIMESTAMP,
            UPDATED_BY VARCHAR(100),
            UPDATED_TIME TIMESTAMP,
            UUID VARCHAR(256),
            FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON DELETE RESTRICT,
            PRIMARY KEY(APPLICATION_ID),
            UNIQUE (NAME,SUBSCRIBER_ID)
)/

CREATE TABLE AM_API (
            API_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            API_PROVIDER VARCHAR(200) NOT NULL,
            API_NAME VARCHAR(200) NOT NULL,
            API_VERSION VARCHAR(30) NOT NULL,
            CONTEXT VARCHAR(256),
            CONTEXT_TEMPLATE VARCHAR(256),
            CREATED_BY VARCHAR(100),
            CREATED_TIME TIMESTAMP,
            UPDATED_BY VARCHAR(100),
            UPDATED_TIME TIMESTAMP,
            PRIMARY KEY(API_ID),
            UNIQUE (API_PROVIDER,API_NAME,API_VERSION)
)/

CREATE TABLE AM_API_URL_MAPPING (
            URL_MAPPING_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            API_ID INTEGER NOT NULL,
            HTTP_METHOD VARCHAR(20) NULL,
            AUTH_SCHEME VARCHAR(50) NULL,
            URL_PATTERN VARCHAR(512) NULL,
            THROTTLING_TIER varchar(512) DEFAULT NULL,
            MEDIATION_SCRIPT BLOB,
            PRIMARY KEY (URL_MAPPING_ID)
)/

CREATE TABLE AM_SUBSCRIPTION (
            SUBSCRIPTION_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TIER_ID VARCHAR(50),
            API_ID INTEGER,
            LAST_ACCESSED TIMESTAMP NULL,
            APPLICATION_ID INTEGER,
            SUB_STATUS VARCHAR(50),
            SUBS_CREATE_STATE VARCHAR(50) DEFAULT 'SUBSCRIBE',
            CREATED_BY VARCHAR(100),
            CREATED_TIME TIMESTAMP,
            UPDATED_BY VARCHAR(100),
            UPDATED_TIME TIMESTAMP,
            UUID VARCHAR(256) NOT NULL,
            FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON DELETE RESTRICT,
            FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON DELETE RESTRICT,
            PRIMARY KEY (SUBSCRIPTION_ID),
            UNIQUE (UUID)
)/

CREATE TABLE AM_SUBSCRIPTION_KEY_MAPPING (
            SUBSCRIPTION_ID INTEGER NOT NULL,
            ACCESS_TOKEN VARCHAR(255) NOT NULL,
            KEY_TYPE VARCHAR(512) NOT NULL,
            FOREIGN KEY(SUBSCRIPTION_ID) REFERENCES AM_SUBSCRIPTION(SUBSCRIPTION_ID) ON DELETE RESTRICT,
            PRIMARY KEY(SUBSCRIPTION_ID,ACCESS_TOKEN)
)/

CREATE TABLE AM_APPLICATION_KEY_MAPPING (
            APPLICATION_ID INTEGER NOT NULL,
            CONSUMER_KEY VARCHAR(255),
            KEY_TYPE VARCHAR(512) NOT NULL,
            STATE VARCHAR(30) NOT NULL,
            CREATE_MODE VARCHAR(30) DEFAULT 'CREATED',
            FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON DELETE RESTRICT,
            PRIMARY KEY(APPLICATION_ID,KEY_TYPE)
)/

CREATE TABLE AM_API_LC_EVENT (
            EVENT_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            API_ID INTEGER NOT NULL,
            PREVIOUS_STATE VARCHAR(50),
            NEW_STATE VARCHAR(50) NOT NULL,
            USER_ID VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            EVENT_DATE TIMESTAMP NOT NULL,
            FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON DELETE RESTRICT,
            PRIMARY KEY (EVENT_ID)
)/

CREATE TABLE AM_APP_KEY_DOMAIN_MAPPING (
            CONSUMER_KEY VARCHAR(255) NOT NULL,
            AUTHZ_DOMAIN VARCHAR(255) NOT NULL DEFAULT 'ALL',
            PRIMARY KEY (CONSUMER_KEY,AUTHZ_DOMAIN)
)/

CREATE TABLE AM_API_COMMENTS (
            COMMENT_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            COMMENT_TEXT VARCHAR(512),
            COMMENTED_USER VARCHAR(255),
            DATE_COMMENTED TIMESTAMP NOT NULL,
            API_ID INTEGER NOT NULL,
            FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON DELETE RESTRICT,
            PRIMARY KEY (COMMENT_ID)
)/

CREATE TABLE AM_API_RATINGS (
            RATING_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            API_ID INTEGER,
            RATING INTEGER,
            SUBSCRIBER_ID INTEGER,
            FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON DELETE RESTRICT,
            FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON DELETE RESTRICT,
            PRIMARY KEY (RATING_ID)
)/

CREATE TABLE AM_TIER_PERMISSIONS (
            TIER_PERMISSIONS_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            TIER VARCHAR(50) NOT NULL,
            PERMISSIONS_TYPE VARCHAR(50) NOT NULL,
            ROLES VARCHAR(512) NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            PRIMARY KEY(TIER_PERMISSIONS_ID)
)/

CREATE TABLE AM_EXTERNAL_STORES (
            APISTORE_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            API_ID INTEGER,
            STORE_ID VARCHAR(255) NOT NULL,
            STORE_DISPLAY_NAME VARCHAR(255) NOT NULL,
            STORE_ENDPOINT VARCHAR(255) NOT NULL,
            STORE_TYPE VARCHAR(255) NOT NULL,
            FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON DELETE RESTRICT,
            PRIMARY KEY (APISTORE_ID)
)
/

CREATE TABLE AM_WORKFLOWS(
            WF_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            WF_REFERENCE VARCHAR(255) NOT NULL,
            WF_TYPE VARCHAR(255) NOT NULL,
            WF_STATUS VARCHAR(255) NOT NULL,
            WF_CREATED_TIME TIMESTAMP,
            WF_UPDATED_TIME TIMESTAMP NOT NULL GENERATED ALWAYS FOR EACH ROW ON UPDATE AS ROW CHANGE TIMESTAMP,
            WF_STATUS_DESC VARCHAR(1000),
            TENANT_ID INTEGER,
            TENANT_DOMAIN VARCHAR(255),
            WF_EXTERNAL_REFERENCE VARCHAR(255) NOT NULL,
            PRIMARY KEY (WF_ID),
            UNIQUE (WF_EXTERNAL_REFERENCE)
)/

CREATE TABLE AM_APPLICATION_REGISTRATION (
            REG_ID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            SUBSCRIBER_ID INT NOT NULL,
            WF_REF VARCHAR(255) NOT NULL,
            APP_ID INT NOT NULL,
            TOKEN_TYPE VARCHAR(30) NOT NULL,
            TOKEN_SCOPE VARCHAR(256) DEFAULT 'default',
            INPUTS VARCHAR(1000),
            ALLOWED_DOMAINS VARCHAR(256),
            VALIDITY_PERIOD BIGINT,
            UNIQUE (SUBSCRIBER_ID,APP_ID,TOKEN_TYPE),
            FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON DELETE RESTRICT,
            FOREIGN KEY(APP_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON DELETE RESTRICT,
            PRIMARY KEY (REG_ID)
)/

CREATE TABLE AM_API_SCOPES (
            API_ID  INTEGER NOT NULL,
            SCOPE_ID  INTEGER NOT NULL,
            FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE ,
            FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE
)/

CREATE TABLE AM_API_DEFAULT_VERSION (
            DEFAULT_VERSION_ID INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
            API_NAME VARCHAR(256) NOT NULL ,
            API_PROVIDER VARCHAR(256) NOT NULL ,
            DEFAULT_API_VERSION VARCHAR(30) ,
            PUBLISHED_DEFAULT_API_VERSION VARCHAR(30) ,
            PRIMARY KEY (DEFAULT_VERSION_ID)
)/

CREATE INDEX IDX_SUB_APP_ID ON AM_SUBSCRIPTION (APPLICATION_ID, SUBSCRIPTION_ID)/
