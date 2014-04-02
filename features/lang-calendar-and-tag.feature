Feature: Filter Articles by Language on Calendar and Tags
    Calendar and Tags should show articles in the current language
  Scenario: Filters by Language at Index Page
    Given the Server is running at "lang-calendar-and-tag-app"
    When I go to "/index.html"
    Then I should see "Some text in English."
    Then I should not see "Некоторый текст на русском языке."
    When I go to "/ru/index.html"
    Then I should see "Некоторый текст на русском языке."
    Then I should not see "Some text in English."

  Scenario: Calendar pages also get built
    Given a successfully built app at "lang-calendar-and-tag-app"
    When I cd to "build"
    Then the following files should exist:
    | en/2014.html       |
    | en/2014/04.html    |
    | en/2014/04/01.html |
    | ru/2014.html       |
    | ru/2014/04.html    |
    | ru/2014/04/01.html |
    | en/tags/foo.html   |
    | ru/tags/foo.html   |

  Scenario: Calendar filters by current language
    Given the Server is running at "lang-calendar-and-tag-app"
    When I go to "/en/2014/04/01.html"
    Then I should see "/en/2014/04/01/english-article.html"
    Then I should not see "/ru/2014/04/01/russian-article.html"
    When I go to "/ru/2014/04/01.html"
    Then I should see "/ru/2014/04/01/russian-article.html"
    Then I should not see "/en/2014/04/01/english-article.html"

  Scenario: Tags are filtered by current language
    Given the Server is running at "lang-calendar-and-tag-app"
    When I go to "/en/tags/foo.html"
    Then I should see "/en/2014/04/01/english-article.html"
    Then I should not see "/ru/2014/04/01/russian-article.html"
    When I go to "/ru/tags/foo.html"
    Then I should see "/ru/2014/04/01/russian-article.html"
    Then I should not see "/en/2014/04/01/english-article.html"
