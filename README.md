# Maas Api
Maas Api is the back-end for the Maas Vue front-end App, the main function of this app is to create organized schedules taking care of the available work hours from the employees and the asked from the clients.

## Installation
Inside the app we use:
- ruby 2.6.8
- rails 5.2.7
## Starting
_These instructions allow you to obtain a copy of the running project on your local machine for development and testing purposes._

Before you start you have to
```terminal
git clone git@github.com:alexalcazar/maas_api.git
```
Then you will need create the database
```terminal
rails db:create db:migrate db:seed
```

Then just run the next command to leave the app up
```terminal
rails s
```

## Usage
The (postman collection)[https://www.getpostman.com/collections/575e44aa2072e68a5591] gives you examples to start working with.

The availables end-points are:
- GET: (maas_api_url)/v1/clients/available_schedules
- GET: (maas_api_url)/v1/schedules
- POST: (maas_api_url)/v1/schedules
- PUT: (maas_api_url)/v1//v1/schedules

The algorithm works as follows:
Starts the loop of the object Schedule.week:
- The object that will keep the record of hours of all users is created _users_with_availables_hours_
- Read the value that contains the first hour _available_ids_to_select_
- The value is sent to the function that is responsible for selecting the user _employee_with_more_available_hours_
- The function that the valid user selects
  - If _available_ids_to_select_ is empty
    - The user with the most available hours is returned and 1 is subtracted from his available hours counter
  - Otherwise, if the _available_ids_to_select_ is present
    - The selected user or users are searched among the available users, and it is sent to the function _search_user_with_selected_flag_
- The _search_user_with_selected_flag_ function is responsible for searching for the user with the selected flag, and validates
  - If the user is found, the selected flag is maintained, and 1 is subtracted from his counter of available hours
  - Otherwise, the user with the most available hours is returned and their selected flag is marked
