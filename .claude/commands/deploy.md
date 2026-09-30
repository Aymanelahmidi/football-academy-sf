Deploy metadata to the FA DEMO org.

Usage:
- `/deploy` → deploy everything in force-app
- `/deploy FA_PlayerService` → deploy a specific Apex class
- `/deploy FA_Player__c` → deploy a specific object and all its fields
- `/deploy faPlayerList` → deploy a specific LWC component

Logic:
- If no argument: `sf project deploy start --source-dir force-app --target-org "FA DEMO"`
- If argument is an Apex class name (e.g. FA_PlayerService): `sf project deploy start --metadata ApexClass:$ARG --target-org "FA DEMO"`
- If argument is a custom object (ends with __c): `sf project deploy start --metadata CustomObject:$ARG --target-org "FA DEMO"`
- If argument is a LWC name (starts lowercase): `sf project deploy start --metadata LightningComponentBundle:$ARG --target-org "FA DEMO"`

After deploy, report: components deployed, errors, warnings.
