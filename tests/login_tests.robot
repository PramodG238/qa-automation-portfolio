*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}           https://www.saucedemo.com
${VALID_USER}    standard_user
${VALID_PASS}    secret_sauce
${WRONG_PASS}    wrong_password
${BROWSER}       chrome
${OPTIONS}       add_argument("--headless=new"); add_argument("--no-sandbox"); add_argument("--disable-dev-shm-usage"); add_argument("--disable-gpu")

*** Keywords ***
Open Test Browser
    ${options}=    Evaluate
    ...    __import__('selenium.webdriver', fromlist=['ChromeOptions']).ChromeOptions()
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Open Browser    ${URL}    chrome    options=${options}

*** Test Cases ***

TC01 - Valid Login
    [Documentation]    Verify login with valid credentials succeeds
    [Tags]    allure.label.severity:critical    allure.label.feature:Login    smoke
    Open Test Browser
    Input Text      id=user-name    ${VALID_USER}
    Input Text      id=password     ${VALID_PASS}
    Click Button    id=login-button
    Title Should Be    Swag Labs
    [Teardown]    Close All Browsers

TC02 - Invalid Login Shows Error
    [Documentation]    Verify invalid credentials show error message
    [Tags]    allure.label.severity:normal    allure.label.feature:Login    regression
    Open Test Browser
    Input Text      id=user-name    ${VALID_USER}
    Input Text      id=password     ${WRONG_PASS}
    Click Button    id=login-button
    Element Should Be Visible    css=.error-message-container
    [Teardown]    Close All Browsers

TC03 - Empty Fields Show Error
    [Documentation]    Verify empty form submission shows error
    [Tags]    allure.label.severity:minor    allure.label.feature:Login    regression
    Open Test Browser
    Click Button    id=login-button
    Element Should Be Visible    css=.error-message-container
    [Teardown]    Close All Browsers
