USE task_1;

DROP TABLE IF EXISTS MedicalRecord;
DROP TABLE IF EXISTS Adoption;
DROP TABLE IF EXISTS AdoptionRequest;
DROP TABLE IF EXISTS Pet;
DROP TABLE IF EXISTS Adopter;
DROP TABLE IF EXISTS Shelter;

CREATE TABLE Shelter (
  shelter_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  location VARCHAR(255),
  capacity INT
);

CREATE TABLE Pet (
  pet_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  species VARCHAR(50),
  breed VARCHAR(50),
  age INT,
  health_status VARCHAR(50),
  shelter_id INT,
  FOREIGN KEY (shelter_id) REFERENCES Shelter(shelter_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Adopter (
  adopter_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  contact VARCHAR(100),
  address VARCHAR(255)
);

CREATE TABLE AdoptionRequest (
  request_id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT,
  adopter_id INT,
  request_date DATE,
  status ENUM('Pending','Approved','Rejected'),
  remarks TEXT,
  FOREIGN KEY (pet_id) REFERENCES Pet(pet_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (adopter_id) REFERENCES Adopter(adopter_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Adoption (
  adoption_id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT,
  adopter_id INT,
  adoption_date DATE,
  documents TEXT,
  FOREIGN KEY (pet_id) REFERENCES Pet(pet_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (adopter_id) REFERENCES Adopter(adopter_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE MedicalRecord (
  record_id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT,
  veterinarian VARCHAR(100),
  diagnosis TEXT,
  treatment_date DATE,
  FOREIGN KEY (pet_id) REFERENCES Pet(pet_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 📦 Sample Data Inserts
INSERT INTO Shelter (name, location, capacity) VALUES
  ('Happy Paws Shelter', 'City Center', 50),
  ('Furry Friends Haven', 'Suburbia', 30);

INSERT INTO Pet (name, species, breed, age, health_status, shelter_id) VALUES
  ('Bingo', 'Dog', 'Beagle', 3, 'Vaccinated', 1),
  ('Whiskers', 'Cat', 'Siamese', 2, 'Healthy', 2);

INSERT INTO Adopter (name, contact, address) VALUES
  ('John Doe', 'john@example.com', '101 Main St'),
  ('Jane Smith', 'jane@example.com', '202 Oak Rd');

INSERT INTO AdoptionRequest (pet_id, adopter_id, request_date, status, remarks) VALUES
  (1, 2, '2025-06-20', 'Pending', 'Loves medium dogs'),
  (2, 1, '2025-06-21', 'Approved', 'Has cat experience');

INSERT INTO Adoption (pet_id, adopter_id, adoption_date, documents) VALUES
  (2, 1, '2025-06-23', 'Contract A123');

INSERT INTO MedicalRecord (pet_id, veterinarian, diagnosis, treatment_date) VALUES
  (1, 'Dr. Smith', 'Routine check-up', '2025-06-22');

SELECT p.name AS pet, p.species, s.name AS shelter
FROM Pet p
JOIN Shelter s ON p.shelter_id = s.shelter_id;

SELECT ar.request_id, a.name AS adopter, p.name AS pet, ar.status
FROM AdoptionRequest ar
JOIN Adopter a ON ar.adopter_id = a.adopter_id
JOIN Pet p ON ar.pet_id = p.pet_id
WHERE ar.status = 'Pending';

SELECT ad.adoption_id, p.name AS pet, a.name AS adopter, ad.documents
FROM Adoption ad
JOIN Pet p ON ad.pet_id = p.pet_id
JOIN Adopter a ON ad.adopter_id = a.adopter_id;

SELECT m.record_id, p.name AS pet, m.veterinarian, m.diagnosis, m.treatment_date
FROM MedicalRecord m
JOIN Pet p ON m.pet_id = p.pet_id;
