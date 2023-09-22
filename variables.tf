variable "Name" {
  type        = string
  description = "(Required) The name of the maintenance window."
}

variable "Description" {
  type        = string
  default     = ""
  description = "(Optional) A description for the maintenance window."
}

variable "Schedule" {
  type        = string
  description = "(Required) The schedule of the Maintenance Window in the form of a cron or rate expression."
}

variable "StartDate" {
  type        = string
  default     = ""
  description = "(Optional) Timestamp in ISO-8601 extended format when to begin the maintenance window."
}

variable "EndDate" {
  type        = string
  default     = ""
  description = "(Optional) Timestamp in ISO-8601 extended format when to no longer run the maintenance window."
}

variable "ScheduleTimezone" {
  type        = string
  default     = ""
  description = "(Optional) Timezone for schedule in Internet Assigned Numbers Authority (IANA) Time Zone Database format. For example: America/Los_Angeles, etc/UTC, or Asia/Seoul"
}

variable "Duration" {
  type        = number
  default     = 2
  description = "(Required) The duration of the Maintenance Window in hours."
}

variable "Cutoff" {
  type        = number
  default     = 1
  description = "(Required) The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution."
}

variable "Enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether the maintenance window is enabled."
}

variable "AllowUnassociatedTargets" {
  type        = bool
  default     = true
  description = "(Optional) Whether targets must be registered with the Maintenance Window before tasks can be defined for those targets."
}

variable "Targets" {
  description = "List of maintenance window targets."
  type = list(object({
    Name             = optional(string)
    Description      = optional(string)
    ResourceType     = string
    OwnerInformation = optional(string)
    Target           = map(list(string))
  }))
  default = []
}

variable "Tasks" {
  description = "List of maintenance window tasks."
  type = list(object({
    Name                = optional(string)
    Description         = optional(string)
    MaxConcurrency      = optional(string, "100%")
    MaxErrors           = optional(string, "100%")
    Priority            = number
    TaskArn             = string
    TaskType            = optional(string, "RUN_COMMAND")
    ServiceRoleArn      = string
    CutoffBehavior      = optional(string)
    Target_Id           = list(number)
    DocumentVersion     = optional(string, "$DEFAULT")
    Parameters          = optional(map(list(string)))
    Comment             = optional(string)
    TimeoutSeconds      = optional(number)
    OutputS3BucketName  = optional(string)
    NotificationEnabled = optional(bool, false)
    NotificationRoleArn = optional(string)
    NotificationConfig = optional(object({
      NotificationArn    = optional(string)
      NotificationEvents = optional(list(string))
      NotificationType   = optional(string)
    }))
  }))
  default = []
}