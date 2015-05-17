CREATE TABLE users (
  id SERIAL, 
  login VARCHAR NOT NULL UNIQUE,
  password VARCHAR(32),
  PRIMARY KEY (id)
);

CREATE TABLE accesstokens (
  id SERIAL,
  token VARCHAR(64),
  user_id INT REFERENCES users(id),
  expires_at TIMESTAMP,
  PRIMARY KEY(id)
);