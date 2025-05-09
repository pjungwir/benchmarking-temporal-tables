function use_impl() {
  impl="${1:-}"
  case "$impl" in
  range_agg|lag|exists)
    # okay
    ;;
  *)
    echo "ERROR: Invalid implementation: '$1'. Must be range_agg|lag|exists."
    return 1
    ;;
  esac

  root="$HOME/local/bench-$impl"
  datadir="$root/pgdata"
  log="${HOME}/local/var/log/postgresql-$impl.log"
  port=$(grep 'port =' "postgresql-${impl}.conf" | awk '{ print $3 }')

  export PATH="$root/bin:$PATH"
}
