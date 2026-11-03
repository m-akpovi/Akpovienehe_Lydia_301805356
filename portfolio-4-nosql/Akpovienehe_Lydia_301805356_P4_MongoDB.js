
// MIT 8103 Portfolio 4
// Hospital Management System - MongoDB
// Four fictional hospital activity documents

// Select the database.
const hospitalDb = db.getSiblingDB("hospital_management_nosql");

// Select the activity collection.
const events = hospitalDb.getCollection("hospital_events");

// Check that the collection is empty before inserting.
const existingCount = events.countDocuments({});

print("Existing document count: " + existingCount);

if (existingCount !== 0) {
    throw new Error(
        "Collection is not empty. Insertion stopped to prevent duplicates."
    );
}

// Insert four fictional hospital activity documents.
const insertResult = events.insertMany([
    {
        _id: "event-001",
        eventId: "EVT-001",
        type: "appointment",
        eventTime: ISODate("2026-11-02T08:00:00Z"),

        patient: {
            email: "amara.okafor@example.com",
            firstName: "Amara",
            lastName: "Okafor"
        },

        doctor: {
            email: "daniel.mensah@example.com",
            firstName: "Daniel",
            lastName: "Mensah"
        },

        details: {
            appointmentDate: ISODate("2026-11-02T00:00:00Z"),
            appointmentTime: "09:00",
            status: "scheduled"
        }
    },

    {
        _id: "event-002",
        eventId: "EVT-002",
        type: "appointment",
        eventTime: ISODate("2026-11-02T10:00:00Z"),

        patient: {
            email: "zainab.ibrahim@example.com",
            firstName: "Zainab",
            lastName: "Ibrahim"
        },

        doctor: {
            email: "daniel.mensah@example.com",
            firstName: "Daniel",
            lastName: "Mensah"
        },

        details: {
            appointmentDate: ISODate("2026-11-02T00:00:00Z"),
            appointmentTime: "11:00",
            status: "cancelled"
        }
    },

    {
        _id: "event-003",
        eventId: "EVT-003",
        type: "consultation",
        eventTime: ISODate("2026-11-02T11:00:00Z"),

        patient: {
            email: "tunde.bello@example.com",
            firstName: "Tunde",
            lastName: "Bello"
        },

        doctor: {
            email: "daniel.mensah@example.com",
            firstName: "Daniel",
            lastName: "Mensah"
        },

        details: {
            consultationDate: ISODate("2026-11-02T00:00:00Z"),
            diagnosis: "Seasonal allergy",
            treatmentNotes:
                "Advised fluids and prescribed routine treatment."
        }
    },

    {
        _id: "event-004",
        eventId: "EVT-004",
        type: "consultation",
        eventTime: ISODate("2026-11-03T08:30:00Z"),

        patient: {
            email: "amara.okafor@example.com",
            firstName: "Amara",
            lastName: "Okafor"
        },

        doctor: {
            email: "daniel.mensah@example.com",
            firstName: "Daniel",
            lastName: "Mensah"
        },

        details: {
            consultationDate: ISODate("2026-11-03T00:00:00Z"),
            diagnosis: "Mild dehydration",
            treatmentNotes:
                "Advised rest and increased fluid intake."
        }
    }
]);

print("\nInsertion result:");
printjson(insertResult);

// QUERY 1: Count all hospital activity documents.
print("\nQUERY 1: Total event count");

print(events.countDocuments({}));

// QUERY 2: Retrieve Amara's event history in date order.
print("\nQUERY 2: Amara's ordered event history");

events.find({
    "patient.email": "amara.okafor@example.com"
})
.sort({ eventTime: 1 })
.forEach(printjson);

// QUERY 3: Find consultation events with a nested diagnosis.
print("\nQUERY 3: Find seasonal allergy consultations");

events.find({
    "details.diagnosis": "Seasonal allergy"
})
.forEach(printjson);
