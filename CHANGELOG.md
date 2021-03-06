# Changelog

## [v0.6.1](https://github.com/scaleflex/cloudimage-rb/tree/v0.6.1) (2020-09-13)

[Full Changelog](https://github.com/scaleflex/cloudimage-rb/compare/v0.6.0...v0.6.1)

**Fixed bugs:**

- Handle frozen aliases hashes [\#29](https://github.com/scaleflex/cloudimage-rb/pull/29) ([janklimo](https://github.com/janklimo))

## [v0.6.0](https://github.com/scaleflex/cloudimage-rb/tree/v0.6.0) (2020-08-16)

[Full Changelog](https://github.com/scaleflex/cloudimage-rb/compare/v0.5.0...v0.6.0)

**Implemented enhancements:**

- Add srcset generation [\#27](https://github.com/scaleflex/cloudimage-rb/pull/27) ([janklimo](https://github.com/janklimo))
- Add default alias [\#26](https://github.com/scaleflex/cloudimage-rb/pull/26) ([janklimo](https://github.com/janklimo))
- Configurable API version URL component [\#25](https://github.com/scaleflex/cloudimage-rb/pull/25) ([janklimo](https://github.com/janklimo))

## [v0.5.0](https://github.com/scaleflex/cloudimage-rb/tree/v0.5.0) (2020-08-02)

[Full Changelog](https://github.com/scaleflex/cloudimage-rb/compare/v0.4.0...v0.5.0)

**Implemented enhancements:**

- Invalidation [\#24](https://github.com/scaleflex/cloudimage-rb/pull/24) ([janklimo](https://github.com/janklimo))
- Add support for custom CNAMEs [\#21](https://github.com/scaleflex/cloudimage-rb/pull/21) ([janklimo](https://github.com/janklimo))

## [v0.4.0](https://github.com/scaleflex/cloudimage-rb/tree/v0.4.0) (2020-07-19)

[Full Changelog](https://github.com/scaleflex/cloudimage-rb/compare/v0.3.0...v0.4.0)

**Implemented enhancements:**

- Add support for aliases [\#20](https://github.com/scaleflex/cloudimage-rb/pull/20) ([janklimo](https://github.com/janklimo))

## [v0.3.0](https://github.com/scaleflex/cloudimage-rb/tree/v0.3.0) (2020-07-09)

[Full Changelog](https://github.com/scaleflex/cloudimage-rb/compare/v0.2.1...v0.3.0)

**Implemented enhancements:**

- Introduce URL sealing [\#10](https://github.com/scaleflex/cloudimage-rb/pull/10) ([janklimo](https://github.com/janklimo))

**Merged pull requests:**

- Use changelog generation [\#16](https://github.com/scaleflex/cloudimage-rb/pull/16) ([janklimo](https://github.com/janklimo))
- Add test coverage with SimpleCov [\#9](https://github.com/scaleflex/cloudimage-rb/pull/9) ([janklimo](https://github.com/janklimo))

## 0.2.1 (2020-06-29)

- Include `force_download` param.

## 0.2.0 (2020-06-28)

- URL signatures.
  [#6](https://github.com/scaleflex/cloudimage-rb/pull/6) (@janklimo)
- Added the remaining API params so that they can be used as helpers.
  [#7](https://github.com/scaleflex/cloudimage-rb/pull/7) (@janklimo)
- We don't run `rubocop` on `truffleruby` anymore.
  It [is not officially supported](https://docs.rubocop.org/rubocop/compatibility.html)
  and leads to [unexpected issues](https://github.com/scaleflex/cloudimage-rb/runs/815208955?check_suite_focus=true).
  [#7](https://github.com/scaleflex/cloudimage-rb/pull/7) (@janklimo)

## 0.1.0 (2020-06-09)

- Introduce base models: `Cloudimage::Client`, and `Cloudimage::URI`. Generate
  URLs via `to_url` method. Add support for image resizing params.
  [#2](https://github.com/scaleflex/cloudimage-rb/pull/2) (@janklimo)

- Set up Github actions for CI.
  [#1](https://github.com/scaleflex/cloudimage-rb/pull/1) (@janklimo)


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
