# Atlas Production SLO

## Service Level Indicator (SLI)
- Successful HTTP 200 responses from /health

## Service Level Objective (SLO)
- 99.9% success rate over a rolling 30-day window

## Error Budget
- 0.1% allowable failures in 30 days

## Enforcement
- If error budget is exhausted:
  - Block production deployments
  - Require rollback or remediation
