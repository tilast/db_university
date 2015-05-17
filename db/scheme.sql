CREATE TABLE users (
  id SERIAL, 
  login VARCHAR NOT NULL UNIQUE,
  password VARCHAR(32),
  PRIMARY KEY (id)
);

CREATE TABLE access_tokens (
  token VARCHAR(64),
  user_id INT REFERENCES users(id),
  expires_at TIMESTAMP,
  PRIMARY KEY(token)
);