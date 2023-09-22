# Create the Maintenance Window
resource "aws_ssm_maintenance_window" "maintenance_window" {
  name                       = var.Name
  description                = var.Description
  schedule                   = var.Schedule
  start_date                 = var.StartDate
  end_date                   = var.EndDate
  schedule_timezone          = var.ScheduleTimezone
  duration                   = var.Duration
  cutoff                     = var.Cutoff
  allow_unassociated_targets = var.AllowUnassociatedTargets
  enabled                    = var.Enabled
}

# Create the Maintenance Window target
resource "aws_ssm_maintenance_window_target" "maintenance_window_target" {
  count = length(var.Targets)

  name              = var.Targets[count.index].Name
  description       = var.Targets[count.index].Description
  window_id         = aws_ssm_maintenance_window.maintenance_window.id
  resource_type     = var.Targets[count.index].ResourceType
  owner_information = var.Targets[count.index].OwnerInformation

  dynamic "targets" {
    for_each = var.Targets[count.index].Target
    content {
      key    = targets.key
      values = targets.value
    }
  }
}

# Create the Maintenance Window task
resource "aws_ssm_maintenance_window_task" "maintenance_window_task" {
  count = length(var.Tasks)

  name             = var.Tasks[count.index].Name
  description      = var.Tasks[count.index].Description
  max_concurrency  = var.Tasks[count.index].MaxConcurrency
  max_errors       = var.Tasks[count.index].MaxErrors
  priority         = var.Tasks[count.index].Priority
  task_arn         = var.Tasks[count.index].TaskArn
  task_type        = var.Tasks[count.index].TaskType
  window_id        = aws_ssm_maintenance_window.maintenance_window.id
  service_role_arn = var.Tasks[count.index].ServiceRoleArn
  cutoff_behavior  = var.Tasks[count.index].CutoffBehavior

  targets {
    key    = "WindowTargetIds"
    values = [for ids in var.Tasks[count.index].Target_Id : aws_ssm_maintenance_window_target.maintenance_window_target[ids].id]
  }

  task_invocation_parameters {
    run_command_parameters {
      service_role_arn = var.Tasks[count.index].NotificationRoleArn
      document_version = var.Tasks[count.index].DocumentVersion
      dynamic "parameter" {
        for_each = var.Tasks[count.index].Parameters
        content {
          name   = parameter.key
          values = parameter.value
        }
      }
      comment          = var.Tasks[count.index].Comment
      output_s3_bucket = var.Tasks[count.index].OutputS3BucketName
      timeout_seconds  = var.Tasks[count.index].TimeoutSeconds
      dynamic "notification_config" {
        for_each = var.Tasks[count.index].NotificationEnabled ? [1] : []
        content {
          notification_arn    = var.Tasks[count.index].NotificationConfig.NotificationArn
          notification_events = var.Tasks[count.index].NotificationConfig.NotificationEvents
          notification_type   = var.Tasks[count.index].NotificationConfig.NotificationType
        }
      }
    }
  }
}