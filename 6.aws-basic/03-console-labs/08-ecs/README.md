# Lab 08 — ECS

## What This Module Teaches

Container deployment on AWS: ECR for images, ECS clusters, task definitions, services, and exposing an app via ALB.

## Learning Objectives

- Explain ECS, tasks, services, and Fargate vs EC2 launch types (intro level)
- Push a Docker image to Amazon ECR
- Create an ECS cluster and task definition
- Run a service behind an Application Load Balancer
- Understand basic container networking on AWS

## Lab Outcome

A containerized web application running on ECS, reachable through an ALB DNS name, with image stored in ECR.

## Estimated Time

4–5 hours

## Cost Warning

**ECS + ALB + Fargate/EC2 costs add up.** Prefer Fargate with smallest CPU/memory for lab or EC2-backed ECS with `t3.micro` if instructed. Delete service, cluster, ALB, ECR images, and VPC resources per [cleanup.md](cleanup.md). ECR storage is cheap but ALB and running tasks are not.

## Cleanup Reminder

Scale service to 0, delete service, task definition revisions, cluster, ALB, target groups, ECR repository, and supporting VPC/networking. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-ecs-theory.md](01-ecs-theory.md) | ECS theory |
| 2 | [02-ecr-theory.md](02-ecr-theory.md) | ECR theory |
| 3 | [03-create-ecr-repo.md](03-create-ecr-repo.md) | Create ECR repo |
| 4 | [04-create-ecs-cluster.md](04-create-ecs-cluster.md) | Create ECS cluster |
| 5 | [05-create-task-definition.md](05-create-task-definition.md) | Task definition |
| 6 | [06-create-service-with-alb.md](06-create-service-with-alb.md) | Service with ALB |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
