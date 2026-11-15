# Release strategies compared

Owned by the **platform team**. Product teams choose a strategy per environment in their config repo; the platform team provides what each one needs.

| Strategy | What users see during a release | What it needs | Rollback | Use it for |
| --- | --- | --- | --- | --- |
| Rolling update (a Deployment) | Old and new pods mixed, by pod count, nothing judged | nothing | a new rolling update | Internal tools, stateless jobs |
| Blue-green | The old version until the switch, then all of the new one | twice the pods for a while; a preview Service | switch back while the old pods are kept (`scaleDownDelaySeconds`) | Releases you want to test whole before anyone sees them |
| Canary by pod count | A share of requests, as fine as the replica count allows | nothing extra | abort: the stable pods scale back up | Few replicas, no mesh or gateway |
| Canary with Istio | An exact share of requests; testers by header | Istio sidecars in the namespace | abort: weights back to 100/0 at once | Services already in the mesh |
| Canary with the Gateway API | An exact share of requests at the gateway | a Gateway API implementation (Traefik here) and the Rollouts plugin | abort: weights back to 100/0 at once | Edge traffic, no mesh |

## Who decides what

| Decision | Who | Where |
| --- | --- | --- |
| Which strategies exist, the analysis templates, the limits in them | platform team | `argocd-platform/rollouts/` |
| Which strategy and steps a service uses | team-checkout | `checkout-config/helm/<env>.yaml` |
| Promote, abort, retry a release | team-checkout (Argo CD actions in project `checkout`) | the Argo CD UI or `kubectl argo rollouts` |
| Undo a release for good | team-checkout | a revert in `checkout-config` |
