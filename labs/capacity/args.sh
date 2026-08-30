# Shared argument handling for the Chapter 13 lab scripts.
#
# The chapter's printed commands pass --candidate, --namespace, --output,
# --baseline, --cost-model, --state and --duration. The scripts read only
# CH13_* environment variables, so every one of those flags was discarded
# without a word: --namespace reference-optimization ran against
# reference-incident, and --output wrote to the default path. Silent rejection
# is the harmful part, so anything unrecognised is now an error.
#
# Sourced, not executed. It sets CH13_* so the scripts' existing defaults keep
# working when no flag is given.

ch13_usage() {
  cat <<'USAGE'
Flags (all optional; each sets the matching CH13_* variable):
  --namespace NS     namespace to act on            (CH13_NAMESPACE)
  --definition PATH  experiment definition          (CH13_DEFINITION)
  --output PATH      where to write the report      (CH13_OUTPUT)
  --requests N       requests per arm               (CH13_REQUESTS)
  --candidate NAME   candidate section to run       (CH13_CANDIDATE)
  --baseline PATH    baseline report to read        (CH13_BASELINE)
  --cost-model PATH  cost model to read or write    (CH13_COST_MODEL)
  --state NAME       state to assert                (CH13_STATE)
  --duration NAME    named traffic window           (CH13_DURATION)
USAGE
}

ch13_parse_args() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --namespace)   export CH13_NAMESPACE="${2:?--namespace needs a value}"; shift 2 ;;
      --definition)  export CH13_DEFINITION="${2:?--definition needs a value}"; shift 2 ;;
      --output)      export CH13_OUTPUT="${2:?--output needs a value}"; shift 2 ;;
      --requests)    export CH13_REQUESTS="${2:?--requests needs a value}"; shift 2 ;;
      --candidate)   export CH13_CANDIDATE="${2:?--candidate needs a value}"; shift 2 ;;
      --baseline)    export CH13_BASELINE="${2:?--baseline needs a value}"; shift 2 ;;
      --cost-model)  export CH13_COST_MODEL="${2:?--cost-model needs a value}"; shift 2 ;;
      --state)       export CH13_STATE="${2:?--state needs a value}"; shift 2 ;;
      --duration)    export CH13_DURATION="${2:?--duration needs a value}"; shift 2 ;;
      -h|--help)     ch13_usage; exit 0 ;;
      *)             printf 'unknown argument: %s\n' "$1" >&2; ch13_usage >&2; exit 2 ;;
    esac
  done
}
