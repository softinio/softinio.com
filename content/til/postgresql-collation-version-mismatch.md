+++
title =  "PostgreSQL: collation version mismatch"
date =  2024-07-28

[taxonomies]
tags = ["PostgreSQL", "Databases"]
categories = [ "TIL" ]

[extra]
toc = true
keywords = ["PostgreSQL", "Database", "Collation", "Mismatch"]
+++

I run my own instance of PeerTube which uses PostgreSQL as its database. When I tried to record my latest video, I got an error message that said:

```
[3397851] WARNING:  database "peertube" has a collation version mismatch
```

I had never seen this error before, so I did some research to figure out what was going on. It turns out that this error occurs when the collation version of the database does not match the collation version of the server. In my case, the collation version of the database was 2.38, while the collation version of the server was 2.39.

I run NixOS, so this probably occured after I updated the system.

To resolve this issue, I logged into my NixOS server and did the following:

- Logged into the PostgreSQL database using the `psql` command:

```bash
psql -h localhost -d postgres -U postgres
```

- connected to my `peertube` database:

```
\c peertube
```

- Ran the following command:

```sql
REINDEX DATABASE peertube; ALTER DATABASE peertube REFRESH COLLATION VERSION;
```

- Logged out of psql:

```
\q
```

- Restarted the peertube service:

```bash
systemctl restart peertube
```

Note: use `sudo` if you are not logged in as the `root` user.
