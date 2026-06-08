Feature: CAMARA Network Traffic Analysis API v0.2.0 - Operation getTrafficAnalysis

    # Get the results of network analysis

    # Input to be provided by the implementation to the tester

    # Implementation indications:
    # * apiRoot: API root of the server URL
    # * Min start and end dates allowed
    # * Max requested time period allowed

    # References to OAS spec schemas refer to schemas specifies in network-traffic-analysis.yaml, version v0.2.0

  Background: Common getTrafficAnalysis setup
    Given an environment at "apiRoot"
    And the resource "/network-traffic-analysis/v0.2.0/traffic-analysis"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the query parameter "networkId" is set by default to a valid network id
    And the query parameter "startDate" is set to a valid start date and time (RFC 3339 with timezone)
    And the query parameter "endDate" is set to a valid end date and time (RFC 3339 with timezone)
    And the query parameter "frequency" is set to a valid value: DAY or HOUR
    And the query parameter "page" is set by default to 1 (optional)
    And the query parameter "perPage" is set by default to 20 (optional)

# Success scenarios

  @network_traffic_analysis_getTrafficAnalysis_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    Given valid query parameters: networkId, startDate, endDate, frequency
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies to the OAS schema at "/components/schemas/TrafficAnalysisResponse"

  @network_traffic_analysis_getTrafficAnalysis_02_invalid_argument_scenario
  Scenario: Error response for invalid argument in query parameters
    Given a query parameter argument is invalid, such as illegal character or format error
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" is "Client specified an invalid argument, request body or query param."

  @network_traffic_analysis_getTrafficAnalysis_03_out_of_range_scenario
  Scenario: Error responses where the parameters are out of range
    Given a query parameter argument is out of range, for example the end date before start date
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" is "Client specified an invalid range."

  @network_traffic_analysis_getTrafficAnalysis_04_missing_authorization_scenario
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    And the query parameters are set to valid values
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @network_traffic_analysis_getTrafficAnalysis_05_missing_access_token_scope_scenario
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope network-traffic-analysis:traffic-analysis:read
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @network_traffic_analysis_getTrafficAnalysis_06_not_found_scenario
  Scenario: Not found
    Given query parameters in the correct format, but the network id cannot be found
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @network_traffic_analysis_getTrafficAnalysis_07_pagination_success_scenario
  Scenario: Pagination returns correct subset of records
    Given valid query parameters: networkId, startDate, endDate, frequency
    And the query parameter "page" is set to 1
    And the query parameter "perPage" is set to 10
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 200
    And the response body complies to the OAS schema at "/components/schemas/TrafficAnalysisResponse"
    And the response property "$.pagination.page" is 1
    And the response property "$.pagination.perPage" is 10
    And the length of the "$.records" array is less than or equal to 10

  @network_traffic_analysis_getTrafficAnalysis_08_pagination_invalid_perPage_scenario
  Scenario: Error response for invalid perPage value
    Given valid query parameters: networkId, startDate, endDate, frequency
    And the query parameter "perPage" is set to 200
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"

  @network_traffic_analysis_getTrafficAnalysis_09_pagination_page_out_of_range_scenario
  Scenario: Error response for page beyond available pages
    Given valid query parameters: networkId, startDate, endDate, frequency
    And the query parameter "page" is set to 9999
    And the query parameter "perPage" is set to 20
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
