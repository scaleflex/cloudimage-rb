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
