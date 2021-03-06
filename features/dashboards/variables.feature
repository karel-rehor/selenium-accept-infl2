Feature: Dashboards - Dashboard - Variables
  As a user I want to Add Variables to cell Queries
  So that I can view specific Influxdbv2 data sets

  Scenario: Load Cell Edit View
    Given I reset the environment
    Given run setup over REST "DEFAULT"
    When open the signin page
    When clear browser storage
    When UI sign in user "DEFAULT"
    When hover over the "Dashboards" menu item
    When click nav sub menu "Dashboards"
    Then the Dashboards page is loaded
    When API sign in user "DEFAULT"
    When generate a line protocol testdata for user "DEFAULT" based on:
    """
    { "points": 2880, "measurement":"pulse", "start": "-48h", "algo": "log", "prec": "sec", "name": "beat"}
    """
    When generate a line protocol testdata for user "DEFAULT" based on:
    """
    { "points": 7200, "measurement":"signal", "start": "-30d", "algo": "sine", "prec": "sec", "name": "foo"}
    """
    When generate a line protocol testdata for user "DEFAULT" based on:
    """
    { "points": 2880, "measurement":"sema", "start": "-48h", "algo": "log", "prec": "sec", "name": "beat"}
    """
    When generate a line protocol testdata for user "DEFAULT" based on:
    """
    { "points": 2880, "measurement":"znacka", "start": "-48h", "algo": "log", "prec": "sec", "name": "beat"}
    """
    When generate a line protocol testdata for user "DEFAULT" based on:
    """
    { "points": 2880, "measurement":"mots", "start": "-48h", "algo": "dico", "data": ["pulse","sema","znacka","wombat"], "prec": "sec", "name": "slovo"}
    """
    When generate a line protocol testdata for user "DEFAULT" based on:
    """
    { "points": 2880, "measurement":"worten", "start": "-48h", "algo": "dico", "data": ["alpha","beta"], "prec": "sec", "name": "logo"}
    """
    When create the "csv" variable "APIVAR" with default "[ "pulse" ]" for user "DEFAULT" with values:
    """
    [ "pulse", "sema", "znacka", "hele" ]
    """
    When create the "query" variable "POKUS" with default "[ "pulse" ]" for user "DEFAULT" with values:
    """
    {"language":"flux","query":"from(bucket: \"qa\")\n  |> range(start: -1d, stop: now() )\n  |> filter(fn: (r) => r._measurement == \"slovo\")\n  |> filter(fn: (r) => r._field == \"mots\")\n  |> unique(column: \"_value\")"}
    """
    When create the "map" variable "KARTA" with default "[ "poppy" ]" for user "DEFAULT" with values:
    """
    { "poppy":"pulse","salvia":"sema","zinnia":"znacka","daisy":"duck" }
    """
    When click the empty Create dashboard dropdown button
    When click the create dashboard item "New Dashboard"
    Then the new dashboard page is loaded
    Then the empty dashboard contains a documentation link
    Then the empty dashboard contains Add a Cell button
    When name dashboard "Semiotic"

  Scenario: Create Basic Cell for Variables
    When click the empty create cell button
    Then the cell edit overlay is loaded as "Name this Cell"
    When name dashboard cell "Semantic"
    When click the time machine bucket selector item "qa"
    When click the tag "beat" in builder card "1"
    Then the time machine cell edit submit button is enabled
    When click the tag "pulse" in builder card "2"
    When click the time machine cell edit submit button
    Then the time machine cell edit preview graph is shown
    Then the time machine cell edit preview axes are shown
    When click dashboard cell save button
    Then the dashboard contains a cell named "Semantic"

  Scenario: Edit Query - Filter variables
    When toggle context menu of dashboard cell named "Semantic"
    When click cell content popover configure
    When click the cell edit Script Editor button
    Then the time machine script editor contains
  """
  from(bucket: "qa")
    |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
    |> filter(fn: (r) => r._measurement == "beat")
    |> filter(fn: (r) => r._field == "pulse")
  """
    When click the time machine script editor variables tab
    Then the time machine variables list contains
  """
  APIVAR,POKUS,KARTA
  """
    When enter the value "AR" in the time machine variables filter
    Then the time machine variables list contains
  """
  APIVAR,KARTA
  """
    Then the time machine variables list does not contain
  """
 POKUS
  """
    When clear the time machine variables filter
    Then the time machine variables list contains
  """
  APIVAR,POKUS,KARTA
  """
    When click dashboard cell edit cancel button
    Then the dashboard contains a cell named "Semantic"

    # time-machine--bottom
       # switch-to-script-editor
       # Queries
          # Script Editor
             # Variables

  Scenario:  Add CSV variable to script
    When toggle context menu of dashboard cell named "Semantic"
    When click cell content popover configure
    When click the cell edit Script Editor button
    # Move to end
    When send keys "CTRL+END" to the time machine flux editor
    # Send cursor to start of field value
    When send keys "ALFT,ALFT,ALFT,ALFT,ALFT,ALFT,ALFT,ALFT" to the time machine flux editor
    # Delete field value
    When send keys "DEL,DEL,DEL,DEL,DEL,DEL,DEL" to the time machine flux editor
    # Now check then add variable
    When click the time machine script editor variables tab
    Then the time machine variable popover is not visible
    When hover over the time machine variable "APIVAR"
    Then the time machine variable popover is visible
    # TODO - TO BE CONTINUED see issue 17101
        # No solution as yet to access popover contents - all action make popover disappear
    #When click time machine popover variable dropodown
    When click the time machine variable "APIVAR"
    When click the time machine cell edit submit button
    # Workaround - issue fetching variables
    When click the time machine cell edit submit button
    #When hover over the time machine variable "KARTA"
    When click dashboard cell save button
    Then the dashboard variables button is highlighted
    When get the current graph of the cell "Semantic"
    When click the value dropdown button for variable "APIVAR"
    Then the selected item of the dropdown for variable "APIVAR" is "pulse"
    Then the value dropdown for variable "APIVAR" contains
  """
  pulse,sema,znacka,hele
  """
    When click the item "sema" for variable "APIVAR"
    Then the graph of the cell "Semantic" has changed
    When get the current graph of the cell "Semantic"
    Then the selected item of the dropdown for variable "APIVAR" is "sema"
    When click the value dropdown button for variable "APIVAR"
    When click the item "hele" for variable "APIVAR"
    Then the cell named "Semantic" has no results
    When click the value dropdown button for variable "APIVAR"
    When click the item "znacka" for variable "APIVAR"
    Then the graph of the cell "Semantic" has changed
    #When click dashboard cell edit cancel button
    #Then the dashboard contains a cell named "Semantic"

  # Scenario: Verify Dashboard CSV variables

  #Script with Map variables
  Scenario:  Add Map variable to script
    Then the dashboard variables button is highlighted
    When toggle context menu of dashboard cell named "Semantic"
    When click cell content popover configure
    #When click the cell edit Script Editor button
    # Move to end
    When send keys "CTRL+END" to the time machine flux editor
    # Send cursor to start of field value
    When send keys "ALFT,ALFT,ALFT,ALFT,ALFT,ALFT,ALFT,ALFT,ALFT" to the time machine flux editor
    # Delete field value
    When send keys "DEL,DEL,DEL,DEL,DEL,DEL,DEL,DEL" to the time machine flux editor
    # Now check then add variable
    When click the time machine script editor variables tab
    Then the time machine variable popover is not visible
    When hover over the time machine variable "KARTA"
    Then the time machine variable popover is visible
    # No solution as yet to access popover contents - all action make popover disappear
    #When click time machine popover variable dropodown
    When click the time machine variable "KARTA"
    When click the time machine cell edit submit button
    # Workaround - issue fetching variables
    When click the time machine cell edit submit button
    #When hover over the time machine variable "KARTA"
    When click dashboard cell save button
    Then the dashboard variables button is highlighted
    When get the current graph of the cell "Semantic"
    When click the value dropdown button for variable "KARTA"
    Then the selected item of the dropdown for variable "KARTA" is "poppy"
    Then the value dropdown for variable "KARTA" contains
  """
  daisy,poppy,salvia,zinnia
  """
    When click the item "salvia" for variable "KARTA"
    Then the graph of the cell "Semantic" has changed
    When get the current graph of the cell "Semantic"
    Then the selected item of the dropdown for variable "KARTA" is "salvia"
    When click the value dropdown button for variable "KARTA"
    When click the item "daisy" for variable "KARTA"
    Then the cell named "Semantic" has no results
    When click the value dropdown button for variable "KARTA"
    When click the item "zinnia" for variable "KARTA"
    Then the graph of the cell "Semantic" has changed

  #Script with Query variables
  Scenario:  Add Query variable to script
    Then the dashboard variables button is highlighted
    When toggle context menu of dashboard cell named "Semantic"
    When click cell content popover configure
    #When click the cell edit Script Editor button
    # Move to end
    When send keys "CTRL+END" to the time machine flux editor
    # Send cursor to start of field value
    When send keys "ALFT,ALFT,ALFT,ALFT,ALFT,ALFT,ALFT,ALFT,ALFT" to the time machine flux editor
    # Delete field value
    When send keys "DEL,DEL,DEL,DEL,DEL,DEL,DEL,DEL" to the time machine flux editor
    # Now check then add variable
    When click the time machine script editor variables tab
    Then the time machine variable popover is not visible
    When hover over the time machine variable "POKUS"
    Then the time machine variable popover is visible
    # No solution as yet to access popover contents - all action make popover disappear
    #When click time machine popover variable dropodown
    When click the time machine variable "POKUS"
    When click the time machine cell edit submit button
    # Workaround - issue fetching variables
    When click the time machine cell edit submit button
    #When hover over the time machine variable "KARTA"
    When click dashboard cell save button
    Then the dashboard variables button is highlighted
    When get the current graph of the cell "Semantic"
    When click the value dropdown button for variable "POKUS"
    Then the selected item of the dropdown for variable "POKUS" is "pulse"
    Then the value dropdown for variable "POKUS" contains
  """
  pulse,sema,wombat,znacka
  """
    When click the item "sema" for variable "POKUS"
    Then the graph of the cell "Semantic" has changed
    When get the current graph of the cell "Semantic"
    Then the selected item of the dropdown for variable "POKUS" is "sema"
    When click the value dropdown button for variable "POKUS"
    When click the item "wombat" for variable "POKUS"
    Then the cell named "Semantic" has no results
    When click the value dropdown button for variable "POKUS"
    When click the item "znacka" for variable "POKUS"
    Then the graph of the cell "Semantic" has changed

  #Script with two variables

  #default variable

  #Change variables in Dashboard view.

  #Change variables in Dashboard view two cells same variable.

  #Dashboard view show/hide variables.

  # NEED TO CLEAN UP
  # Variables cached in localstore can influence other tests
  Scenario Outline: Delete Variable
    When hover over the "Settings" menu item
    When click nav sub menu "Variables"
    When hover over variable card named "<NAME>"
    When click delete menu of variable card named "<NAME>"
    When click delete confirm of variable card named "<NAME>"
    Then the success notification contains "Successfully deleted the variable"
    Then the variable card "<NAME>" is not present
    When close all notifications

    Examples:
      |NAME|
      |APIVAR|
      |KARTA|
      |POKUS|



# Useful variable query based on test data generated above.
#  from(bucket: "qa")
#  |> range(start: -1d, stop: now() )
#  |> filter(fn: (r) => r._measurement == "slovo")
#  |> filter(fn: (r) => r._field == "mots")
#  |> unique(column: "_value")

  #from(bucket: "qa")
  #|> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  #|> filter(fn: (r) => r._measurement == "slovo")
  #|> filter(fn: (r) => r._value == v.APIVAR)
  #|> aggregateWindow(every: 1h, fn: count)


