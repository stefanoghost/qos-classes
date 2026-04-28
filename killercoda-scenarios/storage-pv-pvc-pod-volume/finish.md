# Scenario Completed

Great job.

You created:

- a PersistentVolume
- a PersistentVolumeClaim
- a Deployment using the PVC as a mounted volume

## Key concept

A Pod does not mount a PersistentVolume directly.

The flow is:

PV → PVC → Pod volume → container volumeMount
