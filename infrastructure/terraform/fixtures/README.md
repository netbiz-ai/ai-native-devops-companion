# Terraform plan fixture

The infrastructure lab offers two tracks. The sandbox track runs `terraform plan` against an
approved account you supply. The no-apply track reviews the fixture here
instead, and proves review skill rather than deployability, convergence, or
cleanup.

The infrastructure lab says not to use the fixture route until this repository states the
exact path, revision, sanitization review, and expected inventory. All four are
below.

## Exact path

`infrastructure/terraform/fixtures/ch07-dev-plan.txt`

It is the output of `terraform show -no-color tfplan` for
`infrastructure/terraform/environments/dev`. The chapter tells you not to
commit your own `tfplan` or `plan.txt`, and that still holds: this file is
committed because it was produced with no account and contains no resolved
identifier. Yours will not be.

## Revision

| | |
|---|---|
| Configuration | `infrastructure/terraform/environments/dev` as of this commit |
| Terraform | 1.9.8, linux_amd64 |
| AWS provider | `registry.terraform.io/hashicorp/aws` 5.100.0 |
| Generated | 2026-08-07 |

Record this revision in the SAFE Plan Review where the sandbox track records an
account alias and region. If the configuration or the provider version moves,
this fixture is stale and the inventory below should be reconfirmed before the
fixture is used again.

## Sanitization review

The fixture was generated with no AWS credentials, against no state, using
provider settings that skip credential validation, account-id lookup, and the
metadata endpoint. Those settings live in an override file that is deliberately
not committed, so the configuration you read is the configuration that was
planned.

That method is what makes the file safe rather than any redaction pass. Nothing
existed to describe: every account-specific attribute - `arn`, `id`,
`owner_id`, `availability_zone_id`, `ipv6_cidr_block_association_id`, and the
outputs - is `(known after apply)`. The file was then scanned for
twelve-digit account numbers, `arn:aws` strings, access-key patterns, and the
mock key material used during generation. None are present, and no value was
edited or removed.

The `REPLACE_ME` values in the `Owner` and `ExpiresAt` tags are the
configuration's own defaults, not redactions.

## Expected inventory

```
Plan: 3 to add, 0 to change, 0 to destroy.
```

- one virtual network, `module.network.aws_vpc.this`, CIDR `10.42.0.0/16`
- two private subnets, `module.network.aws_subnet.this["app_a"]` and
  `["app_b"]`, CIDRs `10.42.10.0/24` and `10.42.20.0/24`, in
  `us-east-1a` and `us-east-1b`
- both subnets have `map_public_ip_on_launch = false`
- three outputs: `vpc_id`, and `subnet_ids` for each subnet

No changes, no replacements, and no deletions. A review that finds an action
outside this list has found either a stale fixture or a modified configuration,
and either one is a stop condition.

## What this fixture does not prove

It does not prove the configuration applies, converges, or destroys cleanly. It
does not exercise provider validation that only runs against a real endpoint,
and it carries no evidence of cost. Those belong to the sandbox track.
