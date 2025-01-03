Sys.setenv("AWS_ACCESS_KEY_ID" = "foo")
Sys.setenv("AWS_SECRET_ACCESS_KEY" = "bar")
Sys.setenv("AWS_REGION" = "ap-southeast-2")

library(crew.aws.batch)

controller <- crew_controller_aws_batch(
  name = "my_workflow", # for informative job names
  workers = 2,
  tasks_max = 1, # to avoid reaching wall time limits (if any exist)
  seconds_launch = 600, # to allow a 10-minute startup window
  seconds_idle = 60, # to release resources when they are not needed
  processes = NULL, # See the "Asynchronous worker management" section below.
  options_aws_batch = crew_options_aws_batch(
    job_definition = "test_job",
    job_queue = "test_queue",
    cpus = 1,
    gpus = NULL,
    memory = c(1, 2, 4),
    memory_units = "gigabytes"
  )
)
controller$start()
controller$push(name = "task", command = sqrt(4))
controller$wait()
controller$pop()$result
controller$terminate()
