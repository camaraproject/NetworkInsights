# Changelog Network Insights

## Table of Contents
- [r3.4](#r3.4)


**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r3.4
## Release Notes
This release contains the definition and documentation of

- network-slice-booking v0.1.0

The API definition(s) are based on

- Commonalities v0.6.0
- Identity and Consent Management v0.4.0
## network-slice-booking v0.1.0

**network-slice-booking v0.1.0 is first public release version of the network-slice-booking API**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/NetworkSliceBooking/r1.2/code/API_definitions/network-slice-booking.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/NetworkSliceBooking/r1.2/code/API_definitions/network-slice-booking.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/NetworkSliceBooking/blob/r1.2/code/API_definitions/network-slice-booking.yaml)
### Changed
* Align the error name to Generic429 and change mandatory description for date-time string format in [#75](https://github.com/camaraproject/NetworkSliceBooking/issues/75)
### Added
* Add centralized linting workflows to ensure code quality and API specification compliance in [#69](https://github.com/camaraproject/NetworkSliceBooking/pull/69)
* Add text description for duration format fields in [#75](https://github.com/camaraproject/NetworkSliceBooking/issues/75)

**Full Changelog**: https://github.com/camaraproject/NetworkSliceBooking/commits/r1.2
