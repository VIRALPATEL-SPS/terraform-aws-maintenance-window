# terraform-aws-maintenance-window

Create main.tf.json and use module as shown in below example

#### Example
```json
{
  "module": {
    "Maintenace_Window_Name": {
      "source": "VIRALPATEL-SPS/maintenance-window/aws",
      "version": "1.0.1",
      "Name": "Maintenace_Window_Name",
      "Schedule": "cron(30 23 ? * TUE#3 *)",
      "ScheduleTimezone": "America/Toronto",
      "Duration": 2,
      "Cutoff": 1,
      "Enabled": true,
      "Targets": [
        {
          "ResourceType": "RESOURCE_GROUP",
          "Target": {
            "resource-groups:Name": [
              "RESOURCE_GROUP_NAME"
            ]
          },
          "Name": "Target_Name"
        },
        {
            //add more targets
        }
      ],
      "Tasks": [
        {
          "Target_Id": [0], //Assign more than one targets [0,1,..] 
          "TaskArn": "AWS-RunPatchBaseline",
          "ServiceRoleArn": "Service_Role",
          "Comment": "Comments_Optional",
          "Parameters": {
            "AssociationId": [
              ""
            ],
            "BaselineOverride": [
              ""
            ],
            "InstallOverrideList": [
              ""
            ],
            "Operation": [
              "Scan"
            ],
            "RebootOption": [
              "NoReboot"
            ],
            "SnapshotId": [
              ""
            ]
          },
          "TimeoutSeconds": 3600,
          "Priority": 1,
          "Name": "Task_Name"
        },
        {
          //add more tasks
        }
      ]
    }
  }
}
```

#### Example for Targets with InstanceIds
```json
"Target": {
    "InstanceIds": [
      "i-ex@mple"
    ]
  }
```

#### Example for Targets wirh Resource Froup and ResourceType Filters
```json
"Target": {
    "resource-groups:Name": [
        "Resource_Group_Name"
    ],
    "resource-groups:ResourceTypeFilters": [
        "AWS::EC2::Instance"
    ]
}
```
#### Example for Run Command Document type AWS-RunShellScript
```json
"TaskArn": "AWS-RunShellScript",
"Parameters": {
"commands": [
    "Shell Script Command 1",
    "Shell Script Command 2"
  ]
}
```

#### Example for Run Command Document type AWS-RunPowerShellScript
```json
"TaskArn": "AWS-RunPowerShellScript",
"Parameters": {
    "commands": [
      "Power Shell Command 1",
      "Power Shell Command 2"
    ]
}
```
#### Example for Enabled sns notification (Default = Disabled)
```json
"NotificationEnabled": true,
"NotificationConfig": {
  "NotificationArn": "Notification_Arn",
  "NotificationEvents": [
    "All"
  ],
  "NotificationType": "Invocation"
}
"NotificationRoleArn": "Notification_Role_Arn"
```
#### Example for Enabled CloudWatch Logs (Default = Disabled)
```json
"CloudWatchOutputConfig": {
    "CloudWatchLogGroupName": "Cloud Watch Log Group Name",
    "CloudWatchOutputEnabled": true
  }
```
