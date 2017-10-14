pkg_name=laddr
pkg_origin=codeforphilly
pkg_maintainer="Chris Alfano <chris@codeforphilly.org>"
pkg_upstream_url=https://github.com/CodeForPhilly/laddr
pkg_license=(MIT)

pkg_build_deps=(
  core/git
)


# implement git-based dynamic version strings
pkg_version() {
  if [ -n "${pkg_last_tag}" ]; then
    echo "${pkg_last_version}-git+${pkg_last_tag_distance}.${pkg_commit}"
  else
    echo "${pkg_last_version}-git+${pkg_commit}"
  fi
}


# implement build workflow
do_before() {
  do_default_before

  export GIT_DIR="${PLAN_CONTEXT}/../.git"

  pkg_commit="$(git rev-parse --short HEAD)"
  pkg_last_tag="$(git describe --tags --abbrev=0 ${pkg_commit} || true 2>/dev/null)"

  if [ -n "${pkg_last_tag}" ]; then
    pkg_last_version=${pkg_last_tag#v}
    pkg_last_tag_distance="$(git rev-list ${pkg_last_tag}..${pkg_commit} --count)"
  else
    pkg_last_version="0.0.0"
  fi

  update_pkg_version
}

do_unpack() {
  export GIT_WORK_TREE="${CACHE_PATH}"
  mkdir "${GIT_WORK_TREE}"
  git checkout -f "${pkg_commit}"
}

do_build() {
  pushd "${CACHE_PATH}" > /dev/null
  # attach
  popd > /dev/null

  return 0
}

do_install() {
  pushd "${pkg_prefix}" > /dev/null
  mkdir site
  cp -r "${CACHE_PATH}"/*/ site/
  popd > /dev/null

  return 0
}