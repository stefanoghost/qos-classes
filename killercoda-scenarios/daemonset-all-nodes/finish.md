# Scenario Completed

Great job.

You created a DaemonSet that runs on all nodes, including the control-plane.

## Key concept

Control-plane nodes usually have a taint that prevents normal workloads from scheduling there.

To run a DaemonSet on control-plane nodes, the Pod template needs a matching toleration.
