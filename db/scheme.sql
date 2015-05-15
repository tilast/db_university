CREATE TABLE users (
  id INT AUTO_INCREMENT, 
  login VARCHAR NOT NULL UNIQUE,
  password VARCHAR(32),
  PRIMARY KEY (id)
);

CREATE TABLE access_tokens (
  token VARCHAR(64),
  user_id INT,
  FOREIGN KEY user_id REFERENCES users
);