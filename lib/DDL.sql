-- ===========================
-- 1. STAFF TABLE
-- ===========================
CREATE TABLE staff (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name       TEXT NOT NULL,
    username        TEXT UNIQUE NOT NULL,
    password_hash   TEXT NOT NULL,
    role            TEXT CHECK(role IN ('admin', 'nurse', 'doctor')) NOT NULL,
    phone           TEXT,
    email           TEXT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- 2. PATIENTS TABLE
-- ===========================
CREATE TABLE patients (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name       TEXT NOT NULL,
    date_of_birth   DATE,
    gender          TEXT CHECK(gender IN ('male', 'female', 'other')),
    phone           TEXT,
    email           TEXT,
    address         TEXT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- 3. ROOMS TABLE
-- ===========================
CREATE TABLE rooms (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    room_number     TEXT UNIQUE NOT NULL,
    description     TEXT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- 4. BEDS TABLE
-- ===========================
CREATE TABLE beds (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    room_id         INTEGER NOT NULL,
    bed_number      TEXT NOT NULL,
    status          TEXT CHECK(status IN ('available', 'occupied', 'maintenance')) DEFAULT 'available',
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
    UNIQUE (room_id, bed_number)
);

-- ===========================
-- 5. PATIENT ADMISSIONS TABLE
-- ===========================
CREATE TABLE patient_admissions (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id      INTEGER NOT NULL,
    bed_id          INTEGER NOT NULL,
    admitted_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    discharged_at   DATETIME,
    notes           TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (bed_id) REFERENCES beds(id) ON DELETE SET NULL
);

-- ===========================
-- 6. PRESCRIPTIONS TABLE
-- ===========================
CREATE TABLE prescriptions (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    doctor_id       INTEGER NOT NULL,
    patient_id      INTEGER NOT NULL,
    notes           TEXT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES staff(id) ON DELETE SET NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- ===========================
-- 7. MEDICATIONS TABLE
-- ===========================
CREATE TABLE medications (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL,
    dosage          TEXT NOT NULL, -- e.g. '500mg', '10ml', etc.
    stock_qty       INTEGER NOT NULL DEFAULT 0,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- 8. PRESCRIPTION_MEDICATIONS (JUNCTION)
-- ===========================
CREATE TABLE prescription_medications (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    prescription_id     INTEGER NOT NULL,
    medication_id       INTEGER NOT NULL,
    quantity            INTEGER NOT NULL DEFAULT 1,
    custom_dosage       TEXT, -- optional special instructions
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE,
    UNIQUE (prescription_id, medication_id)
);

-- ===========================
-- 9. APPOINTMENTS TABLE
-- ===========================
CREATE TABLE appointments (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    doctor_id       INTEGER NOT NULL,
    patient_id      INTEGER NOT NULL,
    appointment_date DATETIME NOT NULL,
    status          TEXT CHECK(status IN ('scheduled', 'completed', 'cancelled')) DEFAULT 'scheduled',
    notes           TEXT,
    prescription_id INTEGER, -- Nullable
    FOREIGN KEY (doctor_id) REFERENCES staff(id) ON DELETE SET NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE SET NULL
);
