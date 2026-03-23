Feature: CAMARA Network Health Assessment API v0.1.0-rc.1 - Operation getHealthScores

    # Input to be provided by the implementation to the tester
    #
    #
    # Implementation indications:
    # * Min start and end dates allowed
    # * Max requested time period allowed
    # * Max size of the response(Combination of starttime, endtime requested) supported for a sync response
    # * Max size of the response(Combination of starttime, endtime requested) supported for an async response
    # * Limitations about max complexity of requested area allowed
    #
    # Testing assets:
    # * An Area within the supported area
    # * An Area outside the supported area
    # * A combination of request parameters including service area, start time, and end time, configuration information of network slicing
    #
    # References to OAS spec schemas refer to schemas specifies in network-health-assessment.yaml, version v0.1.0-rc.1

  Background: Common getHealthScores setup
    Given an environment at "apiRoot"
    And the resource "/network-health-assessment/v0.1rc1/health-scores"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the "networkId" parameter is set by default to a idexisting network id of the customer
    And the "netType" parameter specifies the network structure type. It must be a string value and must be one of the following: net, net_wireless, net_transnet, or net_core

# Success scenarios

  @network_health_assessment_getHealthScores_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    Given networkId, netType
    When the request "getHealthScores" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body definition refer to "/components/schemas/HealthInfo"

  @network_health_assessment_getHealthScores_02_invalid_argument_scenario
  Scenario: Error response for invalid argument in request body
    Given the request body property argument is invalid, such as illegal character and format error
    When the request "getHealthScores" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" is "Client specified an invalid argument, request body or query param."

  @network_health_assessment_getHealthScores_03_out_of_range_scenario
  Scenario: Error responses where the parameters in the request body are out of range
    Given the request body property argument are out of range, for example the end time before start time
    When the request "getHealthScores" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" is "Client specified an invalid range."

  @network_health_assessment_getHealthScores_04_missing_authorization_scenario
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    And the request body is set to a valid request body
    When the request "getHealthScores" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @network_health_assessment_getHealthScores_05_missing_access_token_scope_scenario
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope network-insights:traffic-analysis:read
    When the request "getHealthScores" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @network_health_assessment_getHealthScores_06_not_found_scenario
  Scenario: Not found
    Given parameters in the correct format, but the network id cannot be found
    When the request "getHealthScores" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
