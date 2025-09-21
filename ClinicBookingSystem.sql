-- Create the database
CREATE DATABASE ClinicBookingSystem;
USE ClinicBookingSystem;

-- Table: Patients
CREATE TABLE Patients (
    PatientID CHAR(36) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table: Doctors
CREATE TABLE Doctors (
    DoctorID CHAR(36) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    LicenseNumber VARCHAR(50) UNIQUE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table: Appointments
CREATE TABLE Appointments (
    AppointmentID CHAR(36) PRIMARY KEY,
    PatientID CHAR(36) NOT NULL,
    DoctorID CHAR(36) NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Duration INT DEFAULT 30 COMMENT 'Duration in minutes',
    Reason TEXT,
    Status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show', 'Rescheduled') DEFAULT 'Scheduled',
    Notes TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Table: Treatments
CREATE TABLE Treatments (
    TreatmentID CHAR(36) PRIMARY KEY,
    AppointmentID CHAR(36) NOT NULL,
    TreatmentName VARCHAR(200) NOT NULL,
    Description TEXT NOT NULL,
    TreatmentDate DATE NOT NULL,
    Cost DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Table: Billing
CREATE TABLE Billing (
    BillID CHAR(36) PRIMARY KEY,
    PatientID CHAR(36) NOT NULL,
    TreatmentID CHAR(36) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentStatus ENUM('Paid', 'Unpaid', 'Pending', 'Partially-Paid') DEFAULT 'Pending',
    PaymentMethod ENUM('Cash', 'Card', 'Insurance', 'Mobile-Money') NULL,
    BillDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    PaidDate DATE NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (TreatmentID) REFERENCES Treatments(TreatmentID)
);

-- Table: Users (for authentication and role management)
CREATE TABLE Users (
    UserID CHAR(36) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('Admin', 'Doctor', 'Receptionist', 'Nurse', 'Patient') NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    LastLogin TIMESTAMP NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table: Medical Records
CREATE TABLE MedicalRecords (
    RecordID CHAR(36) PRIMARY KEY,
    PatientID CHAR(36) NOT NULL,
    DoctorID CHAR(36) NOT NULL,
    RecordDate DATE NOT NULL,
    Diagnosis TEXT,
    Prescription TEXT,
    Notes TEXT,
    FollowUpDate DATE NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Table: Appointment Slots (for scheduling)
CREATE TABLE AppointmentSlots (
    SlotID CHAR(36) PRIMARY KEY,
    DoctorID CHAR(36) NOT NULL,
    SlotDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    IsAvailable BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Table: Payment Transactions
CREATE TABLE PaymentTransactions (
    TransactionID CHAR(36) PRIMARY KEY,
    BillID CHAR(36) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('Cash', 'Card', 'Insurance', 'Mobile-Money') NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ReferenceNumber VARCHAR(100) NULL,
    Status ENUM('Success', 'Failed', 'Pending') DEFAULT 'Success',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BillID) REFERENCES Billing(BillID)
);

-- Insert Patients
INSERT INTO Patients (PatientID, FirstName, LastName, DOB, Gender, Phone, Email, Address)
VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'Alice', 'Mwangi', '1990-05-12', 'Female', '0712345678', 'alice.mwangi@gmail.com', 'Nairobi, Kenya'),
('550e8400-e29b-41d4-a716-446655440002', 'Brian', 'Otieno', '1985-11-23', 'Male', '0723456789', 'brian.otieno@gmail.com', 'Kisumu, Kenya'),
('550e8400-e29b-41d4-a716-446655440003', 'Cynthia', 'Kariuki', '1992-03-18', 'Female', '0711223344', 'cynthia.kariuki@gmail.com', 'Thika, Kenya'),
('550e8400-e29b-41d4-a716-446655440004', 'Daniel', 'Mworia', '1978-07-05', 'Male', '0733445566', 'daniel.mworia@gmail.com', 'Embu, Kenya'),
('550e8400-e29b-41d4-a716-446655440005', 'Esther', 'Njeri', '2000-12-01', 'Female', '0744556677', 'esther.njeri@gmail.com', 'Nyeri, Kenya');


-- Insert Doctors
INSERT INTO Doctors (DoctorID, FirstName, LastName, Specialty, Phone, Email, LicenseNumber)
VALUES 
('650e8400-e29b-41d4-a716-446655440001', 'Dr. Jane', 'Kamau', 'Dermatology', '0701122334', 'jane.kamau@clinic.com', 'KMPC-2023-001'),
('650e8400-e29b-41d4-a716-446655440002', 'Dr. David', 'Mutua', 'Cardiology', '0702233445', 'david.mutua@clinic.com', 'KMPC-2023-002'),
('650e8400-e29b-41d4-a716-446655440003', 'Dr. Mercy', 'Wambui', 'Pediatrics', '0703344556', 'mercy.wambui@clinic.com', 'KMPC-2023-003'),
('650e8400-e29b-41d4-a716-446655440004', 'Dr. John', 'Kiptoo', 'Orthopedics', '0704455667', 'john.kiptoo@clinic.com', 'KMPC-2023-004');


-- Insert Appointments
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, Reason, Status)
VALUES 
('750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '2025-09-22 10:00:00', 'Skin rash consultation', 'Scheduled'),
('750e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', '2025-09-23 14:30:00', 'Chest pain evaluation', 'Scheduled'),
('750e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', '2025-09-24 09:00:00', 'Child fever checkup', 'Scheduled'),
('750e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440004', '2025-09-25 11:15:00', 'Knee pain assessment', 'Scheduled'),
('750e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440001', '2025-09-26 13:00:00', 'Skin allergy follow-up', 'Scheduled');


-- Insert Treatments
INSERT INTO Treatments (TreatmentID, AppointmentID, TreatmentName, Description, TreatmentDate, Cost)
VALUES 
('850e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440001', 'Skin Treatment', 'Prescribed antihistamines and topical cream', '2025-09-22', 2500.00),
('850e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440002', 'Cardiac Assessment', 'ECG performed and medication prescribed', '2025-09-23', 4500.00),
('850e8400-e29b-41d4-a716-446655440003', '750e8400-e29b-41d4-a716-446655440003', 'Fever Management', 'Paracetamol prescribed and hydration advised', '2025-09-24', 1800.00),
('850e8400-e29b-41d4-a716-446655440004', '750e8400-e29b-41d4-a716-446655440004', 'Orthopedic Evaluation', 'X-ray taken and physiotherapy recommended', '2025-09-25', 3200.00),
('850e8400-e29b-41d4-a716-446655440005', '750e8400-e29b-41d4-a716-446655440005', 'Follow-up Treatment', 'Changed cream prescription and advised dietary changes', '2025-09-26', 2700.00);


-- Insert Billing
INSERT INTO Billing (BillID, PatientID, TreatmentID, Amount, PaymentStatus, BillDate, DueDate)
VALUES 
('950e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '850e8400-e29b-41d4-a716-446655440001', 2500.00, 'Pending', '2025-09-22', '2025-10-22'),
('950e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '850e8400-e29b-41d4-a716-446655440002', 4500.00, 'Paid', '2025-09-23', '2025-10-23'),
('950e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '850e8400-e29b-41d4-a716-446655440003', 1800.00, 'Paid', '2025-09-24', '2025-10-24'),
('950e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', '850e8400-e29b-41d4-a716-446655440004', 3200.00, 'Unpaid', '2025-09-25', '2025-10-25'),
('950e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440005', '850e8400-e29b-41d4-a716-446655440005', 2700.00, 'Pending', '2025-09-26', '2025-10-26');

-- Insert Users
INSERT INTO Users (UserID, Username, Email, PasswordHash, Role)
VALUES 
('150e8400-e29b-41d4-a716-446655440001', 'admin', 'admin@clinic.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin'),
('150e8400-e29b-41d4-a716-446655440002', 'jane.kamau', 'jane.kamau@clinic.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Doctor'),
('150e8400-e29b-41d4-a716-446655440003', 'reception', 'reception@clinic.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Receptionist');

-- Insert Medical Records
INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, RecordDate, Diagnosis, Prescription, Notes, FollowUpDate)
VALUES 
('350e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '2025-09-22', 'Contact Dermatitis', 'Hydrocortisone cream 1%, Antihistamines', 'Patient advised to avoid known allergens', '2025-10-22'),
('350e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', '2025-09-23', 'Hypertension', 'Amlodipine 5mg daily', 'Regular blood pressure monitoring required', '2025-10-23');

-- Insert Appointment Slots
INSERT INTO AppointmentSlots (SlotID, DoctorID, SlotDate, StartTime, EndTime)
VALUES 
('450e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '2025-09-27', '09:00:00', '09:30:00'),
('450e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440001', '2025-09-27', '09:30:00', '10:00:00'),
('450e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440002', '2025-09-27', '14:00:00', '14:30:00');

-- Insert Payment Transactions
INSERT INTO PaymentTransactions (TransactionID, BillID, Amount, PaymentMethod, ReferenceNumber)
VALUES 
('550e8400-e29b-41d4-a716-446655440101', '950e8400-e29b-41d4-a716-446655440002', 4500.00, 'Card', 'TXN-2025-001'),
('550e8400-e29b-41d4-a716-446655440102', '950e8400-e29b-41d4-a716-446655440003', 1800.00, 'Cash', 'CASH-2025-001');

-- Create Indexes for Performance Optimization
CREATE INDEX idx_patients_email ON Patients(Email);
CREATE INDEX idx_patients_phone ON Patients(Phone);
CREATE INDEX idx_appointments_date ON Appointments(AppointmentDate);
CREATE INDEX idx_appointments_doctor ON Appointments(DoctorID);
CREATE INDEX idx_appointments_patient ON Appointments(PatientID);
CREATE INDEX idx_appointments_status ON Appointments(Status);
CREATE INDEX idx_billing_status ON Billing(PaymentStatus);
CREATE INDEX idx_billing_due_date ON Billing(DueDate);
CREATE INDEX idx_medical_records_patient ON MedicalRecords(PatientID);
CREATE INDEX idx_medical_records_date ON MedicalRecords(RecordDate);
CREATE INDEX idx_users_role ON Users(Role);
CREATE INDEX idx_users_email ON Users(Email);

-- Create Views for Common Queries
CREATE VIEW vw_patient_appointments AS
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    p.Phone,
    p.Email,
    a.AppointmentID,
    a.AppointmentDate,
    a.Status,
    a.Reason,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    d.Specialty
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate DESC;

CREATE VIEW vw_doctor_schedule AS
SELECT 
    d.DoctorID,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    d.Specialty,
    a.AppointmentDate,
    a.Duration,
    a.Status,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    a.Reason
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Patients p ON a.PatientID = p.PatientID
WHERE a.Status IN ('Scheduled', 'Completed')
ORDER BY d.DoctorID, a.AppointmentDate;

CREATE VIEW vw_billing_summary AS
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    b.BillID,
    b.Amount,
    b.PaymentStatus,
    b.BillDate,
    b.DueDate,
    t.TreatmentName,
    CASE 
        WHEN b.DueDate < CURDATE() AND b.PaymentStatus != 'Paid' THEN 'Overdue'
        ELSE 'Current'
    END AS PaymentStatusExtended
FROM Patients p
JOIN Billing b ON p.PatientID = b.PatientID
JOIN Treatments t ON b.TreatmentID = t.TreatmentID
ORDER BY b.DueDate;

CREATE VIEW vw_revenue_report AS
SELECT 
    DATE(b.BillDate) AS ReportDate,
    COUNT(*) AS TotalBills,
    SUM(CASE WHEN b.PaymentStatus = 'Paid' THEN b.Amount ELSE 0 END) AS PaidAmount,
    SUM(CASE WHEN b.PaymentStatus = 'Unpaid' THEN b.Amount ELSE 0 END) AS UnpaidAmount,
    SUM(b.Amount) AS TotalAmount
FROM Billing b
GROUP BY DATE(b.BillDate)
ORDER BY ReportDate DESC;

-- Stored Procedures
DELIMITER //

-- Procedure to create a new appointment
CREATE PROCEDURE sp_CreateAppointment(
    IN p_PatientID CHAR(36),
    IN p_DoctorID CHAR(36),
    IN p_AppointmentDate DATETIME,
    IN p_Duration INT,
    IN p_Reason TEXT,
    OUT p_AppointmentID CHAR(36)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    SET p_AppointmentID = UUID();
    
    START TRANSACTION;
    
    INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, Duration, Reason)
    VALUES (p_AppointmentID, p_PatientID, p_DoctorID, p_AppointmentDate, p_Duration, p_Reason);
    
    COMMIT;
END //

-- Procedure to update payment status
CREATE PROCEDURE sp_UpdatePayment(
    IN p_BillID CHAR(36),
    IN p_PaymentMethod VARCHAR(50),
    IN p_Amount DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Update billing record
    UPDATE Billing 
    SET PaymentStatus = 'Paid', 
        PaymentMethod = p_PaymentMethod,
        PaidDate = CURDATE()
    WHERE BillID = p_BillID;
    
    -- Insert payment transaction
    INSERT INTO PaymentTransactions (TransactionID, BillID, Amount, PaymentMethod, ReferenceNumber)
    VALUES (UUID(), p_BillID, p_Amount, p_PaymentMethod, CONCAT('TXN-', UNIX_TIMESTAMP()));
    
    COMMIT;
END //

-- Procedure to get doctor availability
CREATE PROCEDURE sp_GetDoctorAvailability(
    IN p_DoctorID CHAR(36),
    IN p_Date DATE
)
BEGIN
    SELECT 
        s.SlotID,
        s.StartTime,
        s.EndTime,
        s.IsAvailable,
        CASE 
            WHEN a.AppointmentID IS NOT NULL THEN 'Booked'
            ELSE 'Available'
        END AS Status
    FROM AppointmentSlots s
    LEFT JOIN Appointments a ON s.DoctorID = a.DoctorID 
        AND DATE(a.AppointmentDate) = p_Date
        AND TIME(a.AppointmentDate) BETWEEN s.StartTime AND s.EndTime
        AND a.Status IN ('Scheduled', 'Completed')
    WHERE s.DoctorID = p_DoctorID 
        AND s.SlotDate = p_Date
    ORDER BY s.StartTime;
END //

DELIMITER ;

-- Add Constraints and Validation Rules
ALTER TABLE Appointments 
ADD CONSTRAINT chk_appointment_date 
CHECK (AppointmentDate >= CURDATE());

ALTER TABLE Billing 
ADD CONSTRAINT chk_billing_amount 
CHECK (Amount > 0);

ALTER TABLE Billing 
ADD CONSTRAINT chk_due_date 
CHECK (DueDate >= BillDate);

ALTER TABLE Patients 
ADD CONSTRAINT chk_patient_dob 
CHECK (DOB < CURDATE());

ALTER TABLE AppointmentSlots 
ADD CONSTRAINT chk_slot_times 
CHECK (EndTime > StartTime);

-- Additional Tables for Complete System

-- Table: Insurance
CREATE TABLE Insurance (
    InsuranceID CHAR(36) PRIMARY KEY,
    PatientID CHAR(36) NOT NULL,
    InsuranceProvider VARCHAR(100) NOT NULL,
    PolicyNumber VARCHAR(50) NOT NULL,
    CoverageType ENUM('Full', 'Partial', 'Emergency-Only') NOT NULL,
    CoveragePercentage DECIMAL(5,2) DEFAULT 0.00,
    ValidFrom DATE NOT NULL,
    ValidTo DATE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Table: Prescriptions
CREATE TABLE Prescriptions (
    PrescriptionID CHAR(36) PRIMARY KEY,
    MedicalRecordID CHAR(36) NOT NULL,
    MedicationName VARCHAR(200) NOT NULL,
    Dosage VARCHAR(100) NOT NULL,
    Frequency VARCHAR(100) NOT NULL,
    Duration VARCHAR(100) NOT NULL,
    Instructions TEXT,
    Quantity INT NOT NULL,
    Refills INT DEFAULT 0,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (MedicalRecordID) REFERENCES MedicalRecords(RecordID)
);

-- Table: Inventory
CREATE TABLE Inventory (
    ItemID CHAR(36) PRIMARY KEY,
    ItemName VARCHAR(200) NOT NULL,
    Category ENUM('Medication', 'Equipment', 'Supplies', 'Other') NOT NULL,
    Description TEXT,
    Quantity INT NOT NULL DEFAULT 0,
    UnitPrice DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Supplier VARCHAR(100),
    ExpiryDate DATE NULL,
    ReorderLevel INT DEFAULT 10,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table: Notifications
CREATE TABLE Notifications (
    NotificationID CHAR(36) PRIMARY KEY,
    UserID CHAR(36) NOT NULL,
    Title VARCHAR(200) NOT NULL,
    Message TEXT NOT NULL,
    Type ENUM('Appointment', 'Payment', 'System', 'Reminder', 'Alert') NOT NULL,
    Priority ENUM('Low', 'Medium', 'High', 'Urgent') DEFAULT 'Medium',
    IsRead BOOLEAN DEFAULT FALSE,
    ReadAt TIMESTAMP NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: AuditLog
CREATE TABLE AuditLog (
    LogID CHAR(36) PRIMARY KEY,
    TableName VARCHAR(50) NOT NULL,
    RecordID CHAR(36) NOT NULL,
    Action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    OldValues JSON NULL,
    NewValues JSON NULL,
    UserID CHAR(36) NOT NULL,
    IPAddress VARCHAR(45),
    UserAgent TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: Sessions
CREATE TABLE Sessions (
    SessionID CHAR(36) PRIMARY KEY,
    UserID CHAR(36) NOT NULL,
    Token VARCHAR(255) UNIQUE NOT NULL,
    IPAddress VARCHAR(45),
    UserAgent TEXT,
    ExpiresAt TIMESTAMP NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: ClinicSettings
CREATE TABLE ClinicSettings (
    SettingID CHAR(36) PRIMARY KEY,
    SettingKey VARCHAR(100) UNIQUE NOT NULL,
    SettingValue TEXT NOT NULL,
    Description TEXT,
    DataType ENUM('String', 'Number', 'Boolean', 'JSON') DEFAULT 'String',
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert Sample Data for New Tables

-- Insert Insurance
INSERT INTO Insurance (InsuranceID, PatientID, InsuranceProvider, PolicyNumber, CoverageType, CoveragePercentage, ValidFrom, ValidTo)
VALUES 
('750e8400-e29b-41d4-a716-446655440101', '550e8400-e29b-41d4-a716-446655440001', 'NHIF', 'NHIF-2023-001', 'Partial', 80.00, '2023-01-01', '2024-12-31'),
('750e8400-e29b-41d4-a716-446655440102', '550e8400-e29b-41d4-a716-446655440002', 'AAR Insurance', 'AAR-2023-002', 'Full', 100.00, '2023-01-01', '2024-12-31'),
('750e8400-e29b-41d4-a716-446655440103', '550e8400-e29b-41d4-a716-446655440003', 'Britam', 'BRIT-2023-003', 'Partial', 70.00, '2023-01-01', '2024-12-31');

-- Insert Prescriptions
INSERT INTO Prescriptions (PrescriptionID, MedicalRecordID, MedicationName, Dosage, Frequency, Duration, Instructions, Quantity, Refills)
VALUES 
('850e8400-e29b-41d4-a716-446655440101', '350e8400-e29b-41d4-a716-446655440001', 'Hydrocortisone Cream', '1%', 'Twice daily', '2 weeks', 'Apply to affected area after cleaning', 1, 1),
('850e8400-e29b-41d4-a716-446655440102', '350e8400-e29b-41d4-a716-446655440001', 'Cetirizine', '10mg', 'Once daily', '1 week', 'Take with food', 7, 0),
('850e8400-e29b-41d4-a716-446655440103', '350e8400-e29b-41d4-a716-446655440002', 'Amlodipine', '5mg', 'Once daily', '30 days', 'Take at the same time each day', 30, 2);

-- Insert Inventory
INSERT INTO Inventory (ItemID, ItemName, Category, Description, Quantity, UnitPrice, Supplier, ExpiryDate, ReorderLevel)
VALUES 
('950e8400-e29b-41d4-a716-446655440101', 'Hydrocortisone Cream 1%', 'Medication', 'Topical corticosteroid cream', 25, 450.00, 'Pharma Kenya Ltd', '2025-12-31', 5),
('950e8400-e29b-41d4-a716-446655440102', 'Blood Pressure Monitor', 'Equipment', 'Digital BP monitor', 3, 15000.00, 'Medical Equipment Co', '2026-06-30', 1),
('950e8400-e29b-41d4-a716-446655440103', 'Surgical Gloves', 'Supplies', 'Latex-free surgical gloves', 500, 2.50, 'MedSupply Kenya', '2025-08-31', 100),
('950e8400-e29b-41d4-a716-446655440104', 'Amlodipine 5mg', 'Medication', 'Calcium channel blocker', 100, 15.00, 'Pharma Kenya Ltd', '2025-10-31', 20);

-- Insert Notifications
INSERT INTO Notifications (NotificationID, UserID, Title, Message, Type, Priority)
VALUES 
('150e8400-e29b-41d4-a716-446655440101', '150e8400-e29b-41d4-a716-446655440001', 'New Appointment', 'New appointment scheduled for tomorrow', 'Appointment', 'Medium'),
('150e8400-e29b-41d4-a716-446655440102', '150e8400-e29b-41d4-a716-446655440002', 'Payment Overdue', 'Payment for treatment is overdue', 'Payment', 'High'),
('150e8400-e29b-41d4-a716-446655440103', '150e8400-e29b-41d4-a716-446655440003', 'System Maintenance', 'Scheduled maintenance tonight at 2 AM', 'System', 'Low');

-- Insert Clinic Settings
INSERT INTO ClinicSettings (SettingID, SettingKey, SettingValue, Description, DataType)
VALUES 
('250e8400-e29b-41d4-a716-446655440101', 'clinic_name', 'Nairobi Medical Center', 'Name of the clinic', 'String'),
('250e8400-e29b-41d4-a716-446655440102', 'clinic_address', 'Westlands, Nairobi, Kenya', 'Clinic address', 'String'),
('250e8400-e29b-41d4-a716-446655440103', 'clinic_phone', '+254 20 1234567', 'Clinic phone number', 'String'),
('250e8400-e29b-41d4-a716-446655440104', 'appointment_duration', '30', 'Default appointment duration in minutes', 'Number'),
('250e8400-e29b-41d4-a716-446655440105', 'working_hours', '{"start": "08:00", "end": "17:00"}', 'Clinic working hours', 'JSON'),
('250e8400-e29b-41d4-a716-446655440106', 'enable_notifications', 'true', 'Enable system notifications', 'Boolean');

-- Create Additional Indexes
CREATE INDEX idx_insurance_patient ON Insurance(PatientID);
CREATE INDEX idx_insurance_provider ON Insurance(InsuranceProvider);
CREATE INDEX idx_prescriptions_medical_record ON Prescriptions(MedicalRecordID);
CREATE INDEX idx_inventory_category ON Inventory(Category);
CREATE INDEX idx_inventory_expiry ON Inventory(ExpiryDate);
CREATE INDEX idx_notifications_user ON Notifications(UserID);
CREATE INDEX idx_notifications_type ON Notifications(Type);
CREATE INDEX idx_notifications_read ON Notifications(IsRead);
CREATE INDEX idx_audit_log_table ON AuditLog(TableName);
CREATE INDEX idx_audit_log_user ON AuditLog(UserID);
CREATE INDEX idx_audit_log_created ON AuditLog(CreatedAt);
CREATE INDEX idx_sessions_user ON Sessions(UserID);
CREATE INDEX idx_sessions_token ON Sessions(Token);
CREATE INDEX idx_sessions_expires ON Sessions(ExpiresAt);

-- Additional Views for Enhanced Reporting

CREATE VIEW vw_patient_insurance AS
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    i.InsuranceProvider,
    i.PolicyNumber,
    i.CoverageType,
    i.CoveragePercentage,
    i.ValidFrom,
    i.ValidTo,
    CASE 
        WHEN i.ValidTo < CURDATE() THEN 'Expired'
        WHEN i.ValidTo < DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'Expiring Soon'
        ELSE 'Active'
    END AS Status
FROM Patients p
LEFT JOIN Insurance i ON p.PatientID = i.PatientID
WHERE i.IsActive = TRUE OR i.IsActive IS NULL;

CREATE VIEW vw_inventory_status AS
SELECT 
    ItemID,
    ItemName,
    Category,
    Quantity,
    ReorderLevel,
    UnitPrice,
    Supplier,
    ExpiryDate,
    CASE 
        WHEN Quantity <= ReorderLevel THEN 'Reorder Required'
        WHEN ExpiryDate IS NOT NULL AND ExpiryDate < DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'Expiring Soon'
        WHEN Quantity = 0 THEN 'Out of Stock'
        ELSE 'In Stock'
    END AS Status,
    (Quantity * UnitPrice) AS TotalValue
FROM Inventory
WHERE IsActive = TRUE
ORDER BY Status, ItemName;

CREATE VIEW vw_prescription_summary AS
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    pr.PrescriptionID,
    pr.MedicationName,
    pr.Dosage,
    pr.Frequency,
    pr.Duration,
    pr.Quantity,
    pr.Refills,
    pr.IsActive,
    mr.RecordDate,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName
FROM Patients p
JOIN MedicalRecords mr ON p.PatientID = mr.PatientID
JOIN Prescriptions pr ON mr.RecordID = pr.MedicalRecordID
JOIN Doctors d ON mr.DoctorID = d.DoctorID
WHERE pr.IsActive = TRUE
ORDER BY mr.RecordDate DESC;

-- Additional Stored Procedures

DELIMITER //

-- Procedure to calculate insurance coverage
CREATE PROCEDURE sp_CalculateInsuranceCoverage(
    IN p_PatientID CHAR(36),
    IN p_TreatmentCost DECIMAL(10,2),
    OUT p_CoveredAmount DECIMAL(10,2),
    OUT p_PatientAmount DECIMAL(10,2)
)
BEGIN
    DECLARE v_CoveragePercentage DECIMAL(5,2) DEFAULT 0.00;
    
    SELECT CoveragePercentage INTO v_CoveragePercentage
    FROM Insurance 
    WHERE PatientID = p_PatientID 
        AND IsActive = TRUE 
        AND ValidFrom <= CURDATE() 
        AND ValidTo >= CURDATE()
    ORDER BY CoveragePercentage DESC
    LIMIT 1;
    
    SET p_CoveredAmount = (p_TreatmentCost * v_CoveragePercentage / 100);
    SET p_PatientAmount = p_TreatmentCost - p_CoveredAmount;
END //

-- Procedure to check inventory levels
CREATE PROCEDURE sp_CheckInventoryLevels()
BEGIN
    SELECT 
        ItemID,
        ItemName,
        Category,
        Quantity,
        ReorderLevel,
        CASE 
            WHEN Quantity <= ReorderLevel THEN 'Reorder Required'
            WHEN Quantity = 0 THEN 'Out of Stock'
            ELSE 'In Stock'
        END AS Status
    FROM Inventory
    WHERE IsActive = TRUE
        AND (Quantity <= ReorderLevel OR Quantity = 0)
    ORDER BY Category, ItemName;
END //

-- Procedure to get patient medical history
CREATE PROCEDURE sp_GetPatientHistory(
    IN p_PatientID CHAR(36)
)
BEGIN
    SELECT 
        mr.RecordDate,
        CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
        d.Specialty,
        mr.Diagnosis,
        mr.Prescription,
        mr.Notes,
        mr.FollowUpDate,
        a.AppointmentDate,
        a.Status AS AppointmentStatus
    FROM MedicalRecords mr
    JOIN Doctors d ON mr.DoctorID = d.DoctorID
    LEFT JOIN Appointments a ON mr.PatientID = a.PatientID 
        AND DATE(mr.RecordDate) = DATE(a.AppointmentDate)
    WHERE mr.PatientID = p_PatientID
    ORDER BY mr.RecordDate DESC;
END //

-- Procedure to send notification
CREATE PROCEDURE sp_SendNotification(
    IN p_UserID CHAR(36),
    IN p_Title VARCHAR(200),
    IN p_Message TEXT,
    IN p_Type VARCHAR(50),
    IN p_Priority VARCHAR(20)
)
BEGIN
    INSERT INTO Notifications (NotificationID, UserID, Title, Message, Type, Priority)
    VALUES (UUID(), p_UserID, p_Title, p_Message, p_Type, p_Priority);
END //

-- Procedure to clean expired sessions
CREATE PROCEDURE sp_CleanExpiredSessions()
BEGIN
    DELETE FROM Sessions 
    WHERE ExpiresAt < NOW() OR IsActive = FALSE;
    
    SELECT ROW_COUNT() AS DeletedSessions;
END //

-- Functions

-- Function to calculate age from date of birth
CREATE FUNCTION fn_CalculateAge(p_DOB DATE) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_Age INT;
    SET v_Age = YEAR(CURDATE()) - YEAR(p_DOB);
    
    IF MONTH(CURDATE()) < MONTH(p_DOB) OR 
       (MONTH(CURDATE()) = MONTH(p_DOB) AND DAY(CURDATE()) < DAY(p_DOB)) THEN
        SET v_Age = v_Age - 1;
    END IF;
    
    RETURN v_Age;
END //

-- Function to check if appointment time is available
CREATE FUNCTION fn_IsAppointmentAvailable(
    p_DoctorID CHAR(36),
    p_AppointmentDate DATETIME,
    p_Duration INT
) 
RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_Count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_Count
    FROM Appointments
    WHERE DoctorID = p_DoctorID
        AND Status IN ('Scheduled', 'Completed')
        AND (
            (AppointmentDate <= p_AppointmentDate AND 
             DATE_ADD(AppointmentDate, INTERVAL Duration MINUTE) > p_AppointmentDate) OR
            (AppointmentDate < DATE_ADD(p_AppointmentDate, INTERVAL p_Duration MINUTE) AND 
             DATE_ADD(AppointmentDate, INTERVAL Duration MINUTE) >= DATE_ADD(p_AppointmentDate, INTERVAL p_Duration MINUTE))
        );
    
    RETURN v_Count = 0;
END //

-- Function to get next available appointment slot
CREATE FUNCTION fn_GetNextAvailableSlot(
    p_DoctorID CHAR(36),
    p_Date DATE
) 
RETURNS TIME
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_NextTime TIME;
    
    SELECT MIN(s.StartTime) INTO v_NextTime
    FROM AppointmentSlots s
    LEFT JOIN Appointments a ON s.DoctorID = a.DoctorID 
        AND DATE(a.AppointmentDate) = p_Date
        AND TIME(a.AppointmentDate) BETWEEN s.StartTime AND s.EndTime
        AND a.Status IN ('Scheduled', 'Completed')
    WHERE s.DoctorID = p_DoctorID 
        AND s.SlotDate = p_Date
        AND s.IsAvailable = TRUE
        AND a.AppointmentID IS NULL;
    
    RETURN v_NextTime;
END //

DELIMITER ;

-- Triggers for Data Integrity and Audit Logging

-- Trigger to log patient updates
DELIMITER //
CREATE TRIGGER tr_patients_audit_update
    AFTER UPDATE ON Patients
    FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (LogID, TableName, RecordID, Action, OldValues, NewValues, UserID, IPAddress)
    VALUES (
        UUID(),
        'Patients',
        NEW.PatientID,
        'UPDATE',
        JSON_OBJECT(
            'FirstName', OLD.FirstName,
            'LastName', OLD.LastName,
            'Phone', OLD.Phone,
            'Email', OLD.Email,
            'Address', OLD.Address
        ),
        JSON_OBJECT(
            'FirstName', NEW.FirstName,
            'LastName', NEW.LastName,
            'Phone', NEW.Phone,
            'Email', NEW.Email,
            'Address', NEW.Address
        ),
        'system', -- In real implementation, get from session
        '127.0.0.1'
    );
END //

-- Trigger to log appointment status changes
CREATE TRIGGER tr_appointments_status_change
    AFTER UPDATE ON Appointments
    FOR EACH ROW
BEGIN
    IF OLD.Status != NEW.Status THEN
        INSERT INTO Notifications (NotificationID, UserID, Title, Message, Type, Priority)
        SELECT 
            UUID(),
            u.UserID,
            'Appointment Status Changed',
            CONCAT('Your appointment on ', DATE(NEW.AppointmentDate), ' at ', TIME(NEW.AppointmentDate), ' status changed to ', NEW.Status),
            'Appointment',
            'Medium'
        FROM Users u
        WHERE u.Email = (SELECT Email FROM Patients WHERE PatientID = NEW.PatientID)
        LIMIT 1;
    END IF;
END //

-- Trigger to update inventory when prescription is created
CREATE TRIGGER tr_prescription_inventory_update
    AFTER INSERT ON Prescriptions
    FOR EACH ROW
BEGIN
    UPDATE Inventory 
    SET Quantity = Quantity - NEW.Quantity,
        UpdatedAt = CURRENT_TIMESTAMP
    WHERE ItemName LIKE CONCAT('%', NEW.MedicationName, '%')
        AND Category = 'Medication'
        AND Quantity >= NEW.Quantity
    LIMIT 1;
END //

-- Trigger to create notification for overdue payments
CREATE TRIGGER tr_billing_overdue_notification
    AFTER INSERT ON Billing
    FOR EACH ROW
BEGIN
    IF NEW.DueDate < CURDATE() AND NEW.PaymentStatus != 'Paid' THEN
        INSERT INTO Notifications (NotificationID, UserID, Title, Message, Type, Priority)
        SELECT 
            UUID(),
            u.UserID,
            'Payment Overdue',
            CONCAT('Your payment of KES ', NEW.Amount, ' is overdue. Please make payment immediately.'),
            'Payment',
            'High'
        FROM Users u
        WHERE u.Email = (SELECT Email FROM Patients WHERE PatientID = NEW.PatientID)
        LIMIT 1;
    END IF;
END //

-- Trigger to clean up expired sessions
CREATE EVENT ev_cleanup_expired_sessions
ON SCHEDULE EVERY 1 HOUR
DO
    CALL sp_CleanExpiredSessions();

DELIMITER ;

-- Additional Constraints and Validation

-- Add constraints for new tables
ALTER TABLE Insurance 
ADD CONSTRAINT chk_insurance_dates 
CHECK (ValidTo > ValidFrom);

ALTER TABLE Insurance 
ADD CONSTRAINT chk_coverage_percentage 
CHECK (CoveragePercentage >= 0 AND CoveragePercentage <= 100);

ALTER TABLE Prescriptions 
ADD CONSTRAINT chk_prescription_quantity 
CHECK (Quantity > 0);

ALTER TABLE Prescriptions 
ADD CONSTRAINT chk_prescription_refills 
CHECK (Refills >= 0);

ALTER TABLE Inventory 
ADD CONSTRAINT chk_inventory_quantity 
CHECK (Quantity >= 0);

ALTER TABLE Inventory 
ADD CONSTRAINT chk_inventory_price 
CHECK (UnitPrice >= 0);

ALTER TABLE Inventory 
ADD CONSTRAINT chk_inventory_reorder 
CHECK (ReorderLevel >= 0);

-- Add more sample data for comprehensive testing

-- Insert more patients
INSERT INTO Patients (PatientID, FirstName, LastName, DOB, Gender, Phone, Email, Address)
VALUES 
('550e8400-e29b-41d4-a716-446655440006', 'Grace', 'Wanjiku', '1988-09-15', 'Female', '0755667788', 'grace.wanjiku@gmail.com', 'Nakuru, Kenya'),
('550e8400-e29b-41d4-a716-446655440007', 'Peter', 'Kipchoge', '1995-04-22', 'Male', '0766778899', 'peter.kipchoge@gmail.com', 'Eldoret, Kenya'),
('550e8400-e29b-41d4-a716-446655440008', 'Mary', 'Akinyi', '1982-11-08', 'Female', '0777889900', 'mary.akinyi@gmail.com', 'Mombasa, Kenya');

-- Insert more doctors
INSERT INTO Doctors (DoctorID, FirstName, LastName, Specialty, Phone, Email, LicenseNumber)
VALUES 
('650e8400-e29b-41d4-a716-446655440005', 'Dr. Sarah', 'Ochieng', 'Gynecology', '0705566778', 'sarah.ochieng@clinic.com', 'KMPC-2023-005'),
('650e8400-e29b-41d4-a716-446655440006', 'Dr. Michael', 'Kimani', 'Neurology', '0706677889', 'michael.kimani@clinic.com', 'KMPC-2023-006');

-- Insert more appointments
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, Reason, Status)
VALUES 
('750e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440005', '2025-09-28 10:30:00', 'Prenatal checkup', 'Scheduled'),
('750e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440006', '2025-09-29 14:00:00', 'Headache consultation', 'Scheduled'),
('750e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440001', '2025-09-30 09:15:00', 'Skin condition follow-up', 'Scheduled');

-- Insert more medical records
INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, RecordDate, Diagnosis, Prescription, Notes, FollowUpDate)
VALUES 
('350e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440005', '2025-09-28', 'Normal pregnancy', 'Prenatal vitamins, Folic acid', 'Patient in good health, next visit in 4 weeks', '2025-10-26'),
('350e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440006', '2025-09-29', 'Tension headache', 'Ibuprofen 400mg', 'Advise stress management and adequate sleep', '2025-10-29');

-- Insert more users
INSERT INTO Users (UserID, Username, Email, PasswordHash, Role)
VALUES 
('150e8400-e29b-41d4-a716-446655440004', 'sarah.ochieng', 'sarah.ochieng@clinic.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Doctor'),
('150e8400-e29b-41d4-a716-446655440005', 'michael.kimani', 'michael.kimani@clinic.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Doctor'),
('150e8400-e29b-41d4-a716-446655440006', 'nurse1', 'nurse1@clinic.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Nurse');

-- Final optimization queries
OPTIMIZE TABLE Patients, Doctors, Appointments, Treatments, Billing, Users, MedicalRecords, AppointmentSlots, PaymentTransactions, Insurance, Prescriptions, Inventory, Notifications, AuditLog, Sessions, ClinicSettings;