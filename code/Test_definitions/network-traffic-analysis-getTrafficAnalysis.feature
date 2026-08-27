Feature: CAMARA Network Traffic Analysis API vwip - Operation getTrafficAnalysis

    # Get the results of network analysis

    # Input to be provided by the implementation to the tester

    # Implementation indications:
    # * apiRoot: API root of the server URL
    # * Min start and end dates allowed
    # * Max requested time period allowed

    # References to OAS spec schemas refer to schemas specifies in network-traffic-analysis.yaml, version vwip

  Background: Common getTrafficAnalysis setup
    Given an environment at "apiRoot"
    And the resource "/network-traffic-analysis/vwip/traffic-analysis"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the query parameter "networkId" is set by default to a valid network id
    And the query parameter "startDate" is set to a valid start date and time (RFC 3339 with timezone)
    And the query parameter "endDate" is set to a valid end date and time (RFC 3339 with timezone)
    And the query parameter "frequency" is set to a valid value: DAY or HOUR

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
    Given a query parameter argument is out of range, for example the end date before start date, or startDate/endDate not aligned to the required boundary for the specified frequency
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

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

  @network_traffic_analysis_getTrafficAnalysis_07_app_filter_scenario
  Scenario: Filter traffic data by application using app query parameter
    Given valid query parameters: networkId, startDate, endDate, frequency
    And the query parameter "app" is set to a valid application name (e.g., "whatsapp")
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrafficAnalysisResponse"
    And every record in the response property "$.records" has the property "app" equal to the requested application name

  @network_traffic_analysis_getTrafficAnalysis_08_pagination_scenario
  Scenario: Paginate traffic analysis results with page and perPage parameters
    Given valid query parameters: networkId, startDate, endDate, frequency
    And the query parameter "page" is set to a valid page number (e.g., 2)
    And the query parameter "perPage" is set to a valid page size (e.g., 5)
    And traffic data exists for the network with more than 5 records
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrafficAnalysisResponse"
    And the response property "$.pagination.page" equals the requested page number
    And the response property "$.pagination.perPage" equals the requested page size
    And the response property "$.records" has at most the requested page size items

  @network_traffic_analysis_getTrafficAnalysis_09_default_pagination_scenario
  Scenario: Use default pagination values when page and perPage are omitted
    Given valid query parameters: networkId, startDate, endDate, frequency
    And the query parameters "page" and "perPage" are not sent
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrafficAnalysisResponse"
    And the response property "$.pagination.page" equals 1
    And the response property "$.pagination.perPage" equals 20

  @network_traffic_analysis_getTrafficAnalysis_10_no_data_success_scenario
  Scenario: Return empty records array when no traffic data is available for the requested period
    Given the network exists but no traffic data is available for the requested time period
    And valid query parameters: networkId, startDate, endDate, frequency
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrafficAnalysisResponse"
    And the response property "$.records" is an empty array
    And the response property "$.pagination.totalCount" equals 0
    And the response property "$.pagination.totalPages" equals 0

  @network_traffic_analysis_getTrafficAnalysis_11_missing_x_correlator_scenario
  Scenario: Handle request without x-correlator header
    Given valid query parameters: networkId, startDate, endDate, frequency
    And the header "x-correlator" is not sent
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" is present

  @network_traffic_analysis_getTrafficAnalysis_12_date_misalignment_scenario
  Scenario: Error response when startDate is not aligned to the required boundary for the specified frequency
    Given the query parameters are set to valid values
    And the query parameter "frequency" is set to "DAY"
    And the query parameter "startDate" is set to a value not aligned to the start of the day (e.g., "2024-06-07T12:30:00Z")
    And the query parameter "endDate" is set to a valid end date
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains "startDate must be aligned"

  @network_traffic_analysis_getTrafficAnalysis_13_end_date_misalignment_scenario
  Scenario: Error response when endDate is not aligned to the required boundary for the specified frequency
    Given the query parameters are set to valid values
    And the query parameter "frequency" is set to "DAY"
    And the query parameter "startDate" is set to a valid start date aligned to day boundary
    And the query parameter "endDate" is set to a value not aligned to the start of the next day (e.g., "2024-06-08T12:30:00Z")
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains "endDate must be aligned"

  @network_traffic_analysis_getTrafficAnalysis_14_hour_frequency_misalignment_scenario
  Scenario: Error response when startDate is not aligned to hour boundary for HOUR frequency
    Given the query parameters are set to valid values
    And the query parameter "frequency" is set to "HOUR"
    And the query parameter "startDate" is set to a value not aligned to the start of the hour (e.g., "2024-06-07T12:30:00Z")
    And the query parameter "endDate" is set to a valid end date
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains "startDate must be aligned"
