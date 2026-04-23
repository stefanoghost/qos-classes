# Scenario Completed

Well done.

You successfully prepared a node for maintenance.

## What you did

- cordoned the node to stop new scheduling
- drained the node safely
- handled pods with special requirements (DaemonSets and local storage)

## Key concept

- `cordon` → stop scheduling
- `drain` → evict pods safely
- `--ignore-daemonsets` → required for DaemonSets
- `--delete-emptydir-data` → remove ephemeral data

This is a core CKA skill.
