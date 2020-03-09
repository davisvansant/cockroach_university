### Cockroach University

###### Getting Started with Cockroach DB

###### Chapter 1

###### Lab : Installing CockroachDB

  ```
  > docker build -t cockroach_university .
  ....
  ....
  ....
  Successfully tagged cockroach_university:latest

  > docker run --rm cockroach_university ./cockroach version
  Build Tag:    v19.2.2
  Build Time:   2019/12/11 01:33:43
  Distribution: CCL
  Platform:     linux amd64 (x86_64-unknown-linux-gnu)
  Go Version:   go1.12.12
  C Compiler:   gcc 6.3.0
  Build SHA-1:  3cbd05602d4aeaebbccea18d66ad0fdf8db482a5
  Build Type:   release
  ```
  ###### Lab : Start an Insecure Single-Node Cluster

  ```
  > docker run -d --rm -p 8080:8080 cockroach_university ./cockroach start-single-node --insecure --listen-addr=localhost:26257 --http-addr=0.0.0.0:8080
  > docker logs $CONTAINER_ID
  ....
  ....
  CockroachDB node starting at 2020-02-04 21:30:12.161595535 +0000 UTC (took 0.4s)
  build:               CCL v19.2.2 @ 2019/12/11 01:33:43 (go1.12.12)
  webui:               http://0.0.0.0:8080
  sql:                 postgresql://root@localhost:26257?sslmode=disable
  RPC client flags:    ./cockroach <client cmd> --host=localhost:26257 --insecure
  logs:                /cockroach/cockroach-data/logs
  temp dir:            /cockroach/cockroach-data/cockroach-temp230897654
  external I/O path:   /cockroach/cockroach-data/extern
  store[0]:            path=/cockroach/cockroach-data
  status:              initialized new cluster
  clusterID:           3ed95974-e2f5-4449-9781-de736b795fc6
  nodeID:              1  
  ```

##### Connecting with the SQL Shell

  ```
  ./cockroach workload init movr
  I200204 21:42:22.358101 1 workload/workloadsql/dataload.go:135  imported users (0s, 50 rows)
  I200204 21:42:22.366110 1 workload/workloadsql/dataload.go:135  imported vehicles (0s, 15 rows)
  I200204 21:42:22.432053 1 workload/workloadsql/dataload.go:135  imported rides (0s, 500 rows)
  I200204 21:42:22.478648 1 workload/workloadsql/dataload.go:135  imported vehicle_location_histories (0s, 1000 rows)
  I200204 21:42:22.532313 1 workload/workloadsql/dataload.go:135  imported promo_codes (0s, 1000 rows)

  ./cockroach sql --insecure
  #
  # Welcome to the CockroachDB SQL shell.
  # All statements must be terminated by a semicolon.
  # To exit, type: \q.
  #
  # Server version: CockroachDB CCL v19.2.2 (x86_64-unknown-linux-gnu, built 2019/12/11 01:33:43, go1.12.12) (same version as client)
  # Cluster ID: 3ed95974-e2f5-4449-9781-de736b795fc6
  #
  # Enter \? for a brief introduction.
  #

  root@:26257/defaultdb> SHOW databases;
  database_name  
  +---------------+
    defaultdb      
    movr           
    postgres       
    system         
    (4 rows)

    Time: 1.095634ms

    root@:26257/defaultdb> SHOW TABLES FROM movr;
            table_name          
    +----------------------------+
      promo_codes                 
      rides                       
      user_promo_codes            
      users                       
      vehicle_location_histories  
      vehicles                    
    (6 rows)

    Time: 1.485949ms

    root@:26257/defaultdb> SELECT * FROM movr.users LIMIT 10;
                       id                  |   city    |        name         |            address            | credit_card  
    +--------------------------------------+-----------+---------------------+-------------------------------+-------------+
      ae147ae1-47ae-4800-8000-000000000022 | amsterdam | Tyler Dalton        | 88194 Angela Gardens Suite 94 | 4443538758   
      b3333333-3333-4000-8000-000000000023 | amsterdam | Dillon Martin       | 29590 Butler Plain Apt. 25    | 3750897994   
      b851eb85-1eb8-4000-8000-000000000024 | amsterdam | Deborah Carson      | 32768 Eric Divide Suite 88    | 8107478823   
      bd70a3d7-0a3d-4000-8000-000000000025 | amsterdam | David Stanton       | 80015 Mark Views Suite 96     | 3471210499   
      c28f5c28-f5c2-4000-8000-000000000026 | amsterdam | Maria Weber         | 14729 Karen Radial            | 5844236997   
      1eb851eb-851e-4800-8000-000000000006 | boston    | Brian Campbell      | 92025 Yang Village            | 9016427332   
      23d70a3d-70a3-4800-8000-000000000007 | boston    | Carl Mcguire        | 60124 Palmer Mews Apt. 49     | 4566257702   
      28f5c28f-5c28-4600-8000-000000000008 | boston    | Jennifer Sanders    | 19121 Padilla Brooks Apt. 12  | 1350968125   
      2e147ae1-47ae-4400-8000-000000000009 | boston    | Cindy Medina        | 31118 Allen Gateway Apt. 60   | 6464362441   
      33333333-3333-4400-8000-00000000000a | boston    | Daniel Hernandez MD | 51438 Janet Valleys           | 0904722368   
    (10 rows)

    Time: 2.214333ms
  ```

##### Lab : Create a Table

  ```
    root@:26257/defaultdb> CREATE TABLE products (id UUID PRIMARY KEY, name STRING, quantity INT, price DECIMAL);
    CREATE TABLE

    Time: 13.437294ms

    root@:26257/defaultdb> SHOW CREATE TABLE products;
      table_name |                 create_statement                  
    +------------+--------------------------------------------------+
      products   | CREATE TABLE products (                           
                 |     id UUID NOT NULL,                             
                 |     name STRING NULL,                             
                 |     quantity INT8 NULL,                           
                 |     price DECIMAL NULL,                           
                 |     CONSTRAINT "primary" PRIMARY KEY (id ASC),    
                 |     FAMILY "primary" (id, name, quantity, price)  
                 | )                                                 
    (1 row)

    Time: 5.458424ms

    root@:26257/defaultdb> SHOW COLUMNS FROM products;
    column_name | data_type | is_nullable | column_default | generation_expression |  indices  | is_hidden  
  +-------------+-----------+-------------+----------------+-----------------------+-----------+-----------+
    id          | UUID      |    false    | NULL           |                       | {primary} |   false    
    name        | STRING    |    true     | NULL           |                       | {}        |   false    
    quantity    | INT8      |    true     | NULL           |                       | {}        |   false    
    price       | DECIMAL   |    true     | NULL           |                       | {}        |   false    
  (4 rows)

  Time: 7.110761ms

  root@:26257/defaultdb> SHOW INDEX FROM products;
    table_name | index_name | non_unique | seq_in_index | column_name | direction | storing | implicit  
  +------------+------------+------------+--------------+-------------+-----------+---------+----------+
    products   | primary    |   false    |            1 | id          | ASC       |  false  |  false    
  (1 row)

  Time: 1.491834ms
```
