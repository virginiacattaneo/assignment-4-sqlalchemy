*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***

# POSTs
Create assignment
    [Arguments]     ${name}     ${descr}  ${price}    ${status}
    ${data}=    Create dictionary   name=${name}    description=${descr}  price=${${price}}  status=${status}
    ${resp}=    POST On Session  assignment3    /assignments   json=${data}     expected_status=any
    [Return]    ${resp}


# PUTs
Update assignment
    [Arguments]     ${name}     ${new_name}
    ${data}=    Create dictionary   name=${new_name}
    ${resp}=    PUT On Session  assignment3    /assignments/${name}   json=${data}   expected_status=any
    [Return]    ${resp}


# GETs
Get all assignments
    ${resp}=    GET On Session  assignment3    /assignments
    [Return]    ${resp}


Get list of assignments
    ${resp}=    GET On Session  assignment3    /assignments
    ${list_assign}=     Get From Dictionary    ${resp.json()}    assignments
    [Return]    ${list_assign}


Get by name
    [Arguments]     ${name}
    ${resp}=    GET On Session  assignment3    /assignments/${name}       expected_status=any
    [Return]    ${resp}


# DELETEs
Delete assignment
    [Arguments]     ${name}
    ${resp}=    DELETE On Session  assignment3    /assignments/${name}    expected_status=any
    [Return]    ${resp}


Delete assignment if exists
    [Arguments]     ${name}
    ${resp}=    Get by name    ${name}
    IF    ${resp.status_code} == 200
        Delete assignment    ${name}
    END
    [Return]    ${resp}