pkg_name=laddr
pkg_origin=codeforphilly
pkg_maintainer="Chris Alfano <chris@codeforphilly.org>"
pkg_upstream_url=https://github.com/CodeForPhilly/laddr
pkg_license=(MIT)

pkg_build_deps=(
  core/git
)

emergence_parents=(
  skeleton-v2
  skeleton-v1
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

  # configure git repository
  export GIT_DIR="${PLAN_CONTEXT}/../.git"

  # load version information from git
  pkg_commit="$(git rev-parse --short HEAD)"
  pkg_last_tag="$(git describe --tags --abbrev=0 ${pkg_commit} || true 2>/dev/null)"

  if [ -n "${pkg_last_tag}" ]; then
    pkg_last_version=${pkg_last_tag#v}
    pkg_last_tag_distance="$(git rev-list ${pkg_last_tag}..${pkg_commit} --count)"
  else
    pkg_last_version="0.0.0"
  fi

  # initialize pkg_version
  update_pkg_version

  # setup emergence build
  SOURCES_CACHE_PATH="${HAB_CACHE_SRC_PATH}/sources"
}

do_clean() {
  rm -rf "${SOURCES_CACHE_PATH}"
  do_default_clean
  return $?
}

do_unpack() {
  mkdir "${CACHE_PATH}"
  attach
  git --work-tree="${CACHE_PATH}" checkout -f "${pkg_commit}"
  attach
}

do_build() {
  pushd "${CACHE_PATH}" > /dev/null

  attach

  mkdir "${SOURCES_CACHE_PATH}"

  for src_name in "${emergence_parents[@]}"; do
    source <(
      source "/src/.holobranches/site/${src_name}.sh";
      echo "src_url='${src_url[*]}'";
      echo "src_ref='${src_ref[*]}'";
      echo "src_merge='${src_merge[*]}'";
    )

    src_cache_path="${SOURCES_CACHE_PATH}/${src_name}"
    src_cache_ref="refs/sources/${src_name}"

    mkdir "${src_cache_path}"
    git fetch "${src_url}" "${src_ref}:${src_cache_ref}"
    git --work-tree="${src_cache_path}" checkout -f "${src_cache_ref}"

    attach
  done

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