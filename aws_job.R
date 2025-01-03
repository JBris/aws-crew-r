Sys.setenv("AWS_ACCESS_KEY_ID" = "foo")
Sys.setenv("AWS_SECRET_ACCESS_KEY" = "bar")
Sys.setenv("AWS_REGION" = "ap-southeast-2")

library(crew.aws.batch)

definition <- crew_definition_aws_batch(
  job_definition = "test_job",
  job_queue = "test_queue"
)

definition$register(
  image = "ghcr.io/jbris/stan-cmdstanr-gpu-docker:2.32.1",
  platform_capabilities = "EC2",
  memory_units = "gigabytes",
  memory = 1,
  cpus = 1
)

monitor <- crew_monitor_aws_batch(
  job_definition = "test_job",
  job_queue = "test_queue"
)

job1 <- definition$submit(name = "job1", command = c("echo", "hello\nworld"))
monitor$status(id = job1$id)

monitor$jobs()
monitor$succeeded()
monitor$inactive()
monitor$terminate(id = job1$id)
monitor$jobs()
