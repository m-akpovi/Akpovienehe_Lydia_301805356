# Portfolio 5 Distributed and Cloud Database Exercise

## Current setup

The hospital management system has been implemented using PostgreSQL 16.15 and MongoDB 8.0.34 in an Ubuntu 24.04 Codespace. PostgreSQL stores the main hospital records in five relational tables: `staffRole`, `Patient`, `Staff`, `Appointment` and `Consultation`. MongoDB uses the `hospital_management_nosql` database and the `hospital_events` collection to store four example appointment and consultation event documents.

The MongoDB server uses the local address `127.0.0.1`, with its data directory outside the repository at `/workspaces/mongodb-data`. The available setup notes do not verify a multi-host deployment, replica set, sharded cluster or cloud deployment. Therefore, the current MongoDB topology is treated as a single local development setup; no replication or failover tests are claimed.

## Proposed replication

A replica set is a MongoDB group that maintains copies of the same data. I propose three voting, data-holding members on separate hosts and failure zones. For example, an appointment event written to the primary would be copied to the secondary members. This is a proposal, not an implemented deployment. [MongoDB replication documentation](https://www.mongodb.com/docs/manual/replication/?utm_source=chatgpt.com).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.mongodb.com\&sz=32)

MongoDB Docs+1



| Member   | Starting role | Location                    |
| -------- | ------------- | --------------------------- |
| Member 1 | Primary       | Cloud host / failure zone A |
| Member 2 | Secondary     | Cloud host / failure zone B |
| Member 3 | Secondary     | Cloud host / failure zone C |

## Failure and consistency

If the primary fails, the two available members can hold an election. One eligible secondary can become the new primary. Writes may be briefly interrupted while the election takes place. MongoDB cannot accept writes if the replica set cannot reach a voting majority. [Replica set elections](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/?utm_source=chatgpt.com).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.mongodb.com\&sz=32)

MongoDB Docs+1



For stronger write confirmation, the application can request `w: "majority"`. In this three-member proposal, that means the write must be durably recorded by a majority of data-bearing voting members before success is acknowledged. Secondary members replicate asynchronously, so a secondary can briefly lag behind the primary. [MongoDB write concern](https://www.mongodb.com/docs/v8.0/reference/write-concern/?utm_source=chatgpt.com).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.mongodb.com\&sz=32)

MongoDB Docs+1



PostgreSQL should remain authoritative for the hospital's relational records and rules, such as preventing conflicting doctor appointments. MongoDB replication would copy MongoDB data only; it would not replicate PostgreSQL or automatically synchronise the two databases.

## Sharding and cloud deployment

Replication copies the dataset to multiple members for availability. Sharding divides a collection's records across multiple machines to support larger datasets and higher workloads. The four example documents in `hospital_events` do not justify sharding; one MongoDB instance is sufficient for this small demonstration. [MongoDB sharding documentation](https://www.mongodb.com/docs/manual/sharding/?utm_source=chatgpt.com).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.mongodb.com\&sz=32)

MongoDB Docs+1



For a future cloud deployment, MongoDB Atlas could host the database. It should use authenticated database users, encrypted connections, restricted network access and permissions limited to each user's duties. Backups should be scheduled, and restore procedures should be planned and checked. [Atlas security guidance](https://www.mongodb.com/docs/atlas/architecture/current/network-security/?utm_source=chatgpt.com) and [Atlas backup and restore](https://www.mongodb.com/docs/atlas/backup-restore-cluster/?utm_source=chatgpt.com).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.mongodb.com\&sz=32)

MongoDB Docs+2



Cloud hosting, multiple members, storage, backups and data transfer would add costs. A limitation is that replication improves availability but does not replace backups or prevent incorrect data from being copied to other members.
