*** Settings ***
Resource    assignment4_high_level_keywords.robot

Suite Setup     Start server and create new session
Suite Teardown  Shutdown server

*** Test Cases ***
Scenario: Create a new assignment
    Given An assignment with name "NewName" does not exist in the system
    And The number of assignments in the system is "N"
    When We create an assignment with name "NewName", description "To do something", price 100 and status "todo"
    And The assignment receives id "X"
    Then Server response should have status code 200
    And An assignment with id "X", name "NewName", description "To do something", price 100 and status "todo" should exist
    And The number of assignments in the system should be "N+1"

Scenario: Try to create an existing assignment
    Given An assignment with id "X", name "AName", description "A description", price 1000 and status "A todo" exists in the system
    And The number of assignments in the system is "N"
    When We create an assignment with name "AName", description "To do something", price 2000 and status "Yet another todo"
    Then Server response should have status code 409
    And An assignment with id "X", name "AName", description "A description", price 1000 and status "A todo" should exist
    And The number of assignments in the system should be "N"

Scenario: Delete an existing assignment
    Given An assignment with id "X", name "DeleteTask", description "To be deleted", price 2000 and status "Delete todo" exists in the system
    And The number of assignments in the system is "N"
    When We delete the assignment with name "DeleteTask"
    Then Server response should have status code 200
    And The number of assignments in the system should be "N-1"

Scenario: Try to delete a non existing assignment
    Given An assignment with name "DoesNotExists" does not exist in the system
    And The number of assignments in the system is "N"
    When We delete the assignment with name "DoesNotExists"
    Then Server response should have status code 404
    And An assignment with name "DoesNotExists" should not exist in the system
    And The number of assignments in the system should be "N"

Scenario: Update an existing assignment
    Given An assignment with id "X", name "PreviousName", description "To be updated", price 20 and status "Update todo" exists in the system
    And The number of assignments in the system is "N"
    When We update the name of the assignment with name "PreviousName" to "UpdatedName"
    Then Server response should have status code 200
    And An assignment with id "X", name "UpdatedName", description "To be updated", price 20 and status "Update todo" should exist
    And The number of assignments in the system should be "N"

Scenario: Try to update a non existing assignment
    Given An assignment with name "DoesNotExists" does not exist in the system
    And The number of assignments in the system is "N"
    When We update the name of the assignment with name "DoesNotExists" to "UpdatedName"
    Then Server response should have status code 404
    And An assignment with name "DoesNotExists" should not exist in the system
    And The number of assignments in the system should be "N"
