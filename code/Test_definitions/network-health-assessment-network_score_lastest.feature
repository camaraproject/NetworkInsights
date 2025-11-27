  @NetworkHealthAssessment
  Feature: CAMARA Network Health Assessment API v0.1.0-rc.1 - Operation network_score_lastest

    # Input to be provided by the implementation to the tester
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
    # References to OAS spec schemas refer to schemas specifies in network-health-assessment.yaml, version 0.1.0-rc.1

  Background: Common network_score_lastest setup
    Given an environment at "apiRoot"
    And the resource "/ecop-boss/ne-health/network_score_lastest"
    And the header "SignatureNonce" is set to a Universally Unique Identifier (UUID) for the specific item
    And the header "Version" is set to a date in yyyy-MM-dd format
    And the header "AccessKeyId" is set to a customer’s account name on the network management platform
	And the header "Timestamp" is set to a timestamp of the event in UTC
    And the header "Signature" is set to an encrypted result string generated from other request headers and a secret key, used for request validation
    And the "structCode" parameter specifies the network structure type. It must be a string value and must be one of the following: net, net_wireless, net_transnet, or net_core

# Success scenarios

  @network_health_assessment_network_score_lastest_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    Given structCode, the request parameter must be one of the following: net, net_wireless, net_transnet, or net_core
    When the request "network_score_lastest" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response body definition refer to "/paths/network_score_lastest/get/responses/200"

  @network_health_assessment_network_score_lastest_02_missing_query_parameter_scenario
  Scenario: Error response for missing required query parameter
    The parameter “structCode” is missing from the request URL.
    When the request "network_score_lastest" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.data" is null
    And the response property "$.message" is "Required string parameter 'structCode' is not present."

  @network_health_assessment_network_score_lastest_03_missing_header_parameter_scenario
  Scenario: Error response for missing required header parameter
    Any of the following parameters is missing from the request headers: SignatureNonce, Version, AccessKeyId, Timestamp, Signature.
    When the request "network_score_lastest" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.data" is null
    And the response property "$.message" is "Required header 'XXX' is not present."

  @network_health_assessment_network_score_lastest_04_authentication_failed_scenario
  Scenario: Error response for authentication failed
    The request headers either fail to comply with the signature algorithm logic, or the timestamp deviation exceeds 10 minutes
    When the request "network_score_lastest" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.data" is null
    And the response property "$.message" is "Authentication failed."
