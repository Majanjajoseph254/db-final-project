# Clinic Booking System Database

A comprehensive MySQL database system designed for managing clinic operations including patient management, appointment scheduling, medical records, billing, and inventory management.

## 📋 Table of Contents

- [Overview](#overview)
- [Database Schema](#database-schema)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Sample Data](#sample-data)
- [Performance Optimization](#performance-optimization)
- [Security Features](#security-features)
- [Maintenance](#maintenance)

## 🏥 Overview

The Clinic Booking System is a robust database solution that provides comprehensive management capabilities for healthcare facilities. It handles patient registration, doctor scheduling, appointment booking, medical record keeping, billing, and inventory management.

### Key Capabilities
- **Patient Management**: Complete patient profiles with contact information and medical history
- **Appointment Scheduling**: Flexible appointment booking with doctor availability tracking
- **Medical Records**: Digital medical records with diagnosis and prescription tracking
- **Billing System**: Comprehensive billing with multiple payment methods and insurance support
- **Inventory Management**: Medical supplies and medication inventory tracking
- **User Management**: Role-based access control for different staff members
- **Audit Logging**: Complete audit trail for all database operations
- **Notifications**: Automated notification system for appointments and payments

## 🗄️ Database Schema

### Core Tables

#### 1. **Patients**
Stores patient information and demographics.
```sql
- PatientID (CHAR(36), Primary Key)
- FirstName, LastName (VARCHAR(50))
- DOB (DATE)
- Gender (ENUM: 'Male', 'Female', 'Other')
- Phone, Email (VARCHAR, Unique)
- Address (TEXT)
- CreatedAt, UpdatedAt (TIMESTAMP)
```

#### 2. **Doctors**
Manages doctor profiles and specialties.
```sql
- DoctorID (CHAR(36), Primary Key)
- FirstName, LastName (VARCHAR(50))
- Specialty (VARCHAR(100))
- Phone, Email (VARCHAR, Unique)
- LicenseNumber (VARCHAR(50), Unique)
- IsActive (BOOLEAN)
- CreatedAt, UpdatedAt (TIMESTAMP)
```

#### 3. **Appointments**
Core appointment scheduling table.
```sql
- AppointmentID (CHAR(36), Primary Key)
- PatientID, DoctorID (CHAR(36), Foreign Keys)
- AppointmentDate (DATETIME)
- Duration (INT, minutes)
- Reason (TEXT)
- Status (ENUM: 'Scheduled', 'Completed', 'Cancelled', 'No-Show', 'Rescheduled')
- Notes (TEXT)
- CreatedAt, UpdatedAt (TIMESTAMP)
```

#### 4. **Medical Records**
Digital medical records and diagnoses.
```sql
- RecordID (CHAR(36), Primary Key)
- PatientID, DoctorID (CHAR(36), Foreign Keys)
- RecordDate (DATE)
- Diagnosis (TEXT)
- Prescription (TEXT)
- Notes (TEXT)
- FollowUpDate (DATE)
- CreatedAt, UpdatedAt (TIMESTAMP)
```

#### 5. **Billing**
Financial management and payment tracking.
```sql
- BillID (CHAR(36), Primary Key)
- PatientID, TreatmentID (CHAR(36), Foreign Keys)
- Amount (DECIMAL(10,2))
- PaymentStatus (ENUM: 'Paid', 'Unpaid', 'Pending', 'Partially-Paid')
- PaymentMethod (ENUM: 'Cash', 'Card', 'Insurance', 'Mobile-Money')
- BillDate, DueDate, PaidDate (DATE)
- CreatedAt, UpdatedAt (TIMESTAMP)
```

### Supporting Tables

- **Treatments**: Treatment details and costs
- **Users**: Authentication and role management
- **AppointmentSlots**: Doctor availability scheduling
- **PaymentTransactions**: Payment history and tracking
- **Insurance**: Patient insurance information
- **Prescriptions**: Detailed prescription management
- **Inventory**: Medical supplies and medication stock
- **Notifications**: System notifications and alerts
- **AuditLog**: Complete audit trail
- **Sessions**: User session management
- **ClinicSettings**: System configuration

## ✨ Features

### 🔐 Security & Access Control
- Role-based user authentication (Admin, Doctor, Receptionist, Nurse, Patient)
- Session management with token-based authentication
- Complete audit logging for all operations
- Data validation constraints and triggers

### 📅 Appointment Management
- Flexible appointment scheduling
- Doctor availability tracking
- Appointment status management
- Automated notifications for status changes

### 💊 Medical Records
- Digital medical record keeping
- Prescription management with refill tracking
- Diagnosis and treatment history
- Follow-up appointment scheduling

### 💰 Financial Management
- Comprehensive billing system
- Multiple payment methods support
- Insurance coverage calculation
- Payment transaction tracking
- Overdue payment notifications

### 📦 Inventory Management
- Medical supplies tracking
- Medication inventory management
- Expiry date monitoring
- Reorder level alerts
- Supplier information

### 🔔 Notification System
- Automated appointment reminders
- Payment due notifications
- System alerts and maintenance notices
- Priority-based notification management

## 🚀 Installation

### Prerequisites
- MySQL 8.0 or higher
- MySQL Workbench (recommended for GUI management)

### Setup Instructions

1. **Create Database**
   ```sql
   CREATE DATABASE ClinicBookingSystem;
   USE ClinicBookingSystem;
   ```

2. **Execute SQL Script**
   ```bash
   mysql -u username -p ClinicBookingSystem < ClinicBookingSystem.sql
   ```

3. **Verify Installation**
   ```sql
   SHOW TABLES;
   SELECT COUNT(*) FROM Patients;
   ```

### Configuration

Update the following settings in the `ClinicSettings` table:
- Clinic name and address
- Working hours
- Default appointment duration
- Notification preferences

## 📖 Usage

### Basic Operations

#### Creating a New Patient
```sql
INSERT INTO Patients (PatientID, FirstName, LastName, DOB, Gender, Phone, Email, Address)
VALUES (UUID(), 'John', 'Doe', '1990-01-01', 'Male', '0712345678', 'john.doe@email.com', 'Nairobi, Kenya');
```

#### Scheduling an Appointment
```sql
CALL sp_CreateAppointment(
    'patient-uuid',
    'doctor-uuid',
    '2025-01-15 10:00:00',
    30,
    'Regular checkup',
    @appointment_id
);
```

#### Processing Payment
```sql
CALL sp_UpdatePayment(
    'bill-uuid',
    'Card',
    2500.00
);
```

### Advanced Queries

#### View Patient Appointments
```sql
SELECT * FROM vw_patient_appointments 
WHERE PatientID = 'patient-uuid';
```

#### Check Doctor Availability
```sql
CALL sp_GetDoctorAvailability('doctor-uuid', '2025-01-15');
```

#### Generate Revenue Report
```sql
SELECT * FROM vw_revenue_report 
WHERE ReportDate >= '2025-01-01';
```

## 📊 Sample Data

The database includes comprehensive sample data:
- **5 Patients** with complete profiles
- **4 Doctors** across different specialties
- **8 Appointments** with various statuses
- **5 Treatments** with associated costs
- **5 Billing records** with different payment statuses
- **3 Insurance policies** with varying coverage
- **4 Prescriptions** with detailed medication information
- **4 Inventory items** including medications and equipment
- **3 Users** with different roles

## ⚡ Performance Optimization

### Indexes
The database includes strategic indexes for optimal performance:
- Patient email and phone lookups
- Appointment date and status queries
- Billing status and due date searches
- Medical record patient and date lookups
- User role and email searches

### Views
Pre-built views for common queries:
- `vw_patient_appointments`: Patient appointment summary
- `vw_doctor_schedule`: Doctor schedule overview
- `vw_billing_summary`: Billing status with overdue detection
- `vw_revenue_report`: Daily revenue reporting
- `vw_patient_insurance`: Insurance coverage status
- `vw_inventory_status`: Inventory levels and alerts
- `vw_prescription_summary`: Prescription tracking

### Stored Procedures
Optimized procedures for common operations:
- `sp_CreateAppointment`: Secure appointment creation
- `sp_UpdatePayment`: Payment processing with transaction logging
- `sp_GetDoctorAvailability`: Doctor schedule checking
- `sp_CalculateInsuranceCoverage`: Insurance benefit calculation
- `sp_CheckInventoryLevels`: Inventory monitoring
- `sp_GetPatientHistory`: Complete patient medical history

## 🔒 Security Features

### Data Protection
- UUID primary keys for enhanced security
- Password hashing for user authentication
- Input validation through constraints
- SQL injection prevention through prepared statements

### Audit Trail
- Complete audit logging for all data modifications
- User action tracking with IP addresses
- JSON-based old/new value storage
- Automated cleanup of expired sessions

### Access Control
- Role-based permissions system
- Session management with expiration
- Secure token-based authentication
- IP address and user agent tracking

## 🛠️ Maintenance

### Regular Maintenance Tasks

#### Clean Expired Sessions
```sql
CALL sp_CleanExpiredSessions();
```

#### Check Inventory Levels
```sql
CALL sp_CheckInventoryLevels();
```

#### Optimize Tables
```sql
OPTIMIZE TABLE Patients, Doctors, Appointments, Treatments, Billing;
```

### Monitoring Queries

#### Check System Health
```sql
-- Active sessions
SELECT COUNT(*) as ActiveSessions FROM Sessions WHERE IsActive = TRUE;

-- Overdue payments
SELECT COUNT(*) as OverduePayments FROM vw_billing_summary 
WHERE PaymentStatusExtended = 'Overdue';

-- Low inventory items
SELECT COUNT(*) as LowStockItems FROM vw_inventory_status 
WHERE Status = 'Reorder Required';
```

## 📈 Future Enhancements

- Integration with external payment gateways
- Mobile app API endpoints
- Advanced reporting and analytics
- Integration with laboratory systems
- Telemedicine appointment support
- Automated appointment reminders via SMS/Email

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

---

**Note**: This database is designed for educational and development purposes. For production use, ensure proper security measures, regular backups, and compliance with healthcare data regulations (HIPAA, GDPR, etc.).

