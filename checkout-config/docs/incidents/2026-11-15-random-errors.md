# Example: 2026-11-15: a checkout release with random errors aborted in prod

**What failed:** a release of checkout in prod (6.11.0 with `faults.randomError: true`) answered one request in three with an error (500, 400 or 409).

**How it was detected:** the `success-rate` analysis measured about 67% on the canary pods, below the 95% limit, twice. The Rollout aborted at the 25% step.

**Who responds:** team-checkout owns the release and the revert. The platform team owns the analysis template and was not needed.

**How it was corrected:** the abort sent all traffic back to the stable version within seconds. The values change was reverted in `checkout-config`; Argo CD showed `Healthy` again.

**How it is prevented:** dev runs the same analysis before promotion, so the fault is caught before prod.
