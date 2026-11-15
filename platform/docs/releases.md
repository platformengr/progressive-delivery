# Runbook: releases

Owned by the **platform team**; the release steps are team-checkout's.

## A release is paused

1. `kubectl argo rollouts get rollout checkout -n checkout-<env>`: which step, which analysis is running.
2. If the step is a `pause: {}` it waits for a person. Check the canary (header route or preview host), then **resume** it (Argo CD: the Rollout's **Resume** action, or `kubectl argo rollouts promote`).

## A release was aborted

1. Read why: `kubectl argo rollouts get rollout checkout -n checkout-<env>` shows the failed AnalysisRun; `kubectl -n checkout-<env> get analysisrun` lists them.
2. Users are already on the stable version. Nothing is urgent any more.
3. **Revert the release in Git** (`checkout-config`). An aborted Rollout still wants the new version; Argo CD shows it `Degraded` until Git says the old one again.
4. Write the incident note in `checkout-config/docs/incidents/` with the five answers.

## Who may do what

| Action | team-checkout | platform team |
| --- | --- | --- |
| Resume (promote one step) | yes, in project `checkout` | yes |
| Abort | yes | yes |
| Retry an aborted release | yes | yes |
| Change an analysis template | propose a pull request | yes |
| Skip analysis | no | only during an incident, written down |
