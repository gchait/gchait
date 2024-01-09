REVOKE ALL ON DATABASE :"existing_database" FROM PUBLIC;

CREATE DATABASE :"new_database";
REVOKE ALL ON DATABASE :"new_database" FROM PUBLIC;

CREATE ROLE :"new_username" LOGIN PASSWORD :'new_password';
ALTER ROLE :"new_username" WITH PASSWORD :'new_password';

GRANT CONNECT ON DATABASE :"new_database" TO :"new_username";
GRANT ALL PRIVILEGES ON DATABASE :"new_database" TO :"new_username";

\c :"new_database"
GRANT USAGE ON SCHEMA public TO :"new_username";
GRANT CREATE ON SCHEMA public TO :"new_username";

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO :"new_username";
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO :"new_username";
