# checkout-config: the environment repository

Owned by **team-checkout**. It says *what runs where*: which release of the
chart, with which settings and which release strategy, in which environment.
It is private: Argo CD reads it with a read-only deploy key.

| Path | What |
| --- | --- |
| `helm/dev.yaml`, `helm/prod.yaml` | Values for chart `v2.0.0` from `checkout-app`, including the release strategy. |
| `helm/stages/` | Earlier states of the same files, module by module, for reference. |
| `secrets/dev`, `secrets/prod` | ExternalSecrets: references to team-checkout's store, safe to commit. |
| `docs/incidents/` | One note per failed release, with the five answers. |
