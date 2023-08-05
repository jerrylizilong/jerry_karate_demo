Feature: sample karate test script
  for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support

  Background:
    * url 'http://127.0.0.1:5000'

  Scenario: get all users and then get the first user by id
    Given path 'users'
    When method get
    Then status 200

    * def first = response[0]

    Given path 'user', first.userid
    When method get
    Then status 200
    And match response == first

  Scenario: get all users and then update the first user by id
    Given path 'users'
    When method get
    Then status 200

    * def first = response[0]
    * def newuser = first
    * newuser.age = '35'

    Given path 'user', first.userid
    When request newuser
    And method put
    Then status 201
    And match response == newuser

    Given path 'user', first.userid
    When method get
    Then status 200
    And match response == newuser

  Scenario: create a user and then get it by id

    * def user =
      """
        {
          'username': 'Yao Ming',
          'age': '31',
          'team': 'Houston Rockets',
          'position': 'Center'
        }
      """

    Given path 'users'
    And request user
    When method post
    Then status 201


    * def id = response.userid
    * print 'created id is: ', id
    * def expected_user = user
    * expected_user.user_id = id

    Given path 'user', id
    When method get
    Then status 200
    And response.user = expected_user

  Scenario: get all users and then delete the last user by id
    Given path 'users'
    When method get
    Then status 200

    * def size = karate.sizeOf(response)
    * def last = response[size-1]

    Given path 'user', last.userid
    And method delete
    Then status 204

    Given path 'user', last.userid
    When method get
    Then status 404
    And match response.message == "user "+ last.userid +" doesn't exist"

