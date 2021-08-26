composite_app_pkg_name=site
pkg_name="${composite_app_pkg_name}-composite"
pkg_origin=codeforphilly
pkg_maintainer="Code for Philly <hello@codeforphilly.org>"
pkg_scaffolding=emergence/scaffolding-composite
composite_mysql_pkg=core/mysql

pkg_version() {
  scaffolding_detect_pkg_version
}
