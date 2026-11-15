# Progressive delivery: blue-green and canary with Argo Rollouts

**The reference implementation for the [Progressive delivery course](https://www.platformengr.com/learn/progressive-delivery/) by [PlatformEngr](https://www.platformengr.com/): the Argo CD setup from [Argo CD: from commit to cluster](https://www.platformengr.com/learn/argocd/), with releases that go out to a share of users first and roll themselves back when the metrics say so.**

Everything runs on your laptop with kind. It starts where the Argo CD course ends: the same cluster, the same three repos, the same two teams.

```text
 new version ──> Rollout ──> 5% of requests ──> analysis (Prometheus) ──┬─> 25% ──> 50% ──> 100%
                                 │                                      │
                      Istio or Gateway API split                        └─> abort: back to the stable version

   argocd-platform   (platform team)  Argo Rollouts, Prometheus, Istio, shared analysis templates, who may promote
   checkout-app      (team-checkout)  the chart: a Rollout and its strategy, released by tag (v2.0.0)
   checkout-config   (team-checkout)  the strategy and version per environment, incident write-ups
```

## What is in here

You never fork this repo. You keep the **three repos you built in the Argo CD course** and copy files from here into them, one module at a time.

| Folder | Your repo | Owner | Adds in this course |
| --- | --- | --- | --- |
| [platform/](platform/) | `argocd-platform` | Platform team | Applications for Argo Rollouts, Prometheus, the load generator, Istio, the Gateway API and the release log; the shared `ClusterAnalysisTemplate`s in `rollouts/`; Rollout actions in Argo CD's RBAC. |
| [checkout-app/](checkout-app/) | `checkout-app` | team-checkout | Chart `v2.0.0`: the Deployment is a Rollout, with blue-green or canary from values, a VirtualService and an HTTPRoute. |
| [checkout-config/](checkout-config/) | `checkout-config` | team-checkout | `helm/dev.yaml` and `helm/prod.yaml` with the release strategy, earlier stages in `helm/stages/`, incident notes in `docs/incidents/`. |
| [cluster/](cluster/) | (stays here) | You | The kind cluster definition (unchanged from the Argo CD course). |
| [docs/](docs/) | (read) | Platform team | Release strategies compared, the operating model. |

Every manifest says `YOUR_GITHUB_USER` where your GitHub user goes. The course replaces it when you copy.

## Versions

| Component | Version | Pinned in |
| --- | --- | --- |
| Argo Rollouts | v1.10.2 (chart `argo-rollouts` 2.43.12) | `platform/apps/argo-rollouts.yaml` |
| Gateway API plugin for Argo Rollouts | v0.17.0 | `platform/argo-rollouts/values.yaml` |
| Prometheus | v3.16.0 (chart `prometheus` 29.47.2) | `platform/apps/prometheus.yaml` |
| Istio | 1.30.8 (charts `base`, `istiod`, `gateway`) | `platform/apps/istio-*.yaml` |
| Gateway API CRDs | v1.5.1, standard channel | `platform/apps/gateway-api.yaml` |
| Argo CD, Traefik, External Secrets | as in the Argo CD course | `platform/apps/` |
| checkout image | podinfo 6.7.0 / 6.7.1 | `checkout-config/helm/*.yaml` |

Istio 1.30.8 is the newest release in Istio's Helm repository on 2026-11-15. To bump any of them, change `targetRevision` in a pull request and read the release notes first.

## What is simplified, and what production looks like

| Here | In production |
| --- | --- |
| A load generator makes the traffic analysis judges | Real users; for a quiet service, synthetic checks or a longer pause per step |
| Prometheus without storage, scraping pods by annotation | A managed or highly available Prometheus with retention: see the Observability course |
| Bad releases come from podinfo's fault flags | Bad releases come from code; the checks are the same |
| The Istio gateway is reached by port-forward | A LoadBalancer Service and DNS |
| The release log is a pod that prints | A chat channel or an incident tool |

