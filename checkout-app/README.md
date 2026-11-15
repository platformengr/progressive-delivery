# checkout-app: the application repository

Owned by **team-checkout**. In a real team this repo holds the service's source
code, its tests, the CI that builds the image, and the Helm chart that says how
to run and release it. Here the image is the public `podinfo`, so only the chart
is real.

| Path | What |
| --- | --- |
| `chart/` | The Helm chart, released by tag. `v2.0.0` runs checkout as an Argo Rollouts Rollout. |

`values.yaml` lists every release setting with its default: `strategy`
(`canary` or `blueGreen`), the canary `steps`, `analysis` against the platform's
templates, `trafficRouting` (`istio` or `gatewayapi`), and `faults` for a bad
release on demand.

Render it locally exactly like Argo CD does:

```bash
helm template checkout chart -n checkout-dev -f ../checkout-config/helm/dev.yaml
```
