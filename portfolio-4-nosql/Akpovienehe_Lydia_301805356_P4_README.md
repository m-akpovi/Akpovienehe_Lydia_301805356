# Portfolio 4 NoSQL and Advanced Data Models

## Document model

The Hospital Management System was modelled in MongoDB using the database `hospital_management_nosql` and one collection named `hospital_events`. The collection stores appointment and consultation activities as documents. Each document contains a unique `_id`, event ID, event type and event time. Patient and doctor information is stored in embedded documents, while the `details` field contains information specific to the event type.

Example appointment document:

```javascript
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
}
```

Four fictional documents were inserted: two appointment events and two consultation events. These MongoDB documents were created as separate examples using the records from the hospital case study; they were not automatically transferred from PostgreSQL.

## Implementation and results

The MongoDB implementation was completed using MongoDB 8.0.34 and Mongosh 2.14.1 in the local development environment. The database and collection were selected, and the collection was checked before insertion to prevent duplicate records. The initial count was zero, and four documents were inserted successfully.

Three queries were executed. The first returned a total of four documents. The second retrieved Amara Okafor's two events in chronological order: her appointment on 2 November 2026 and her consultation on 3 November 2026. The third used the nested field `details.diagnosis` to find the seasonal allergy consultation and returned one document belonging to Tunde Bello.

The script also prevented duplicate insertion when it was executed again because the collection already contained four documents.

## Why MongoDB fits

MongoDB is suitable for storing hospital activity records because appointment and consultation events have some common fields but also contain different details. Embedded documents keep related patient and doctor information together, while the flexible document structure allows each event type to store its own details. MongoDB also supports queries on nested fields, as demonstrated by the diagnosis query.

One limitation is that MongoDB does not automatically enforce all the relational rules in the PostgreSQL design. Rules such as ensuring that only doctors are assigned appointments and that consultations belong to completed appointments would require additional validation.

## Files

- [MongoDB implementation script](Akpovienehe_Lydia_301805356_P4_MongoDB.js)
- [Query results screenshot](screenshots/Akpovienehe_Lydia_301805356_P4_MongoDB_Results.png)

## References

- MongoDB Documentation. [MongoDB Manual](https://www.mongodb.com/docs/manual/).
- MongoDB Documentation. [mongosh](https://www.mongodb.com/docs/mongodb-shell/).