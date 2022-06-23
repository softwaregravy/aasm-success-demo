# README

This project demonstrates reading state out of the db during a state transition for aasm

See issue [683](https://github.com/aasm/aasm/issues/683) for discussion

Where to look for interesting bits:
* There are 2 Job classes ([Job](https://github.com/softwaregravy/aasm-success-demo/blob/master/app/models/job.rb) and [Job2](https://github.com/softwaregravy/aasm-success-demo/blob/master/app/models/Job2.rb)
* There are 2 connection pools to the same DB created in [database.yml](https://github.com/softwaregravy/aasm-success-demo/blob/master/config/database.yml#L24), they are the normal `development` used by default for Rails running locally, and `development2`
* The `Job2` class uses the `develoment2` connection pool, but reads the same table as `Job`. Thus, Job2 can read fresh data.


Here is the output of the program just running on the commandline

```bash
Running via Spring preloader in process 64907
Loading development environment (Rails 5.2.4.3)
2.6.5 :001 > job = Job.create
   (0.1ms)  BEGIN
  Job Create (0.5ms)  INSERT INTO "jobs" ("aasm_state", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["aasm_state", "ready"], ["created_at", "2020-05-31 19:59:29.386924"], ["updated_at", "2020-05-31 19:59:29.386924"]]
   (5.1ms)  COMMIT
 => #<Job id: 6, aasm_state: "ready", created_at: "2020-05-31 19:59:29", updated_at: "2020-05-31 19:59:29">
2.6.5 :002 > job.do_job!
   (0.2ms)  BEGIN
  Job Update (0.7ms)  UPDATE "jobs" SET "aasm_state" = $1, "updated_at" = $2 WHERE "jobs"."id" = $3  [["aasm_state", "finished"], ["updated_at", "2020-05-31 19:59:40.667047"], ["id", 6]]
Transition was a success!
I must already be in state finished!
  Job Load (0.3ms)  SELECT  "jobs".* FROM "jobs" WHERE "jobs"."id" = $1 LIMIT $2  [["id", 6], ["LIMIT", 1]]
lets look: my state shows finished BUT ...
... lets use a separate connection pool to the database so that I can see what's really in there
   and not just what is visible on my own connection where I've made changes
   This other connection is in class Job2 which uses the connection pool development2 which connects to the same db
  Job2 Load (0.4ms)  SELECT  "jobs".* FROM "jobs" WHERE "jobs"."id" = $1 LIMIT $2  [["id", 6], ["LIMIT", 1]]
... the DB currently holds state: ready
   (0.3ms)  COMMIT
 => true
```
