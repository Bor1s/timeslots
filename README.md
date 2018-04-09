## Overview

API for managing users and their available time slots.

## Setting up project locally

1. Clone this repo.
2. Install rbenv via homebrew `brew install rbenv ruby-build`
3. Install ruby `rbenv install 2.5.1`
4. Go to project's folder on your machine.
5. Install bundler gem `gem install bundler`.
6. Make sure rbenv catches changes by `rbenv rehash`
7. Install project's dependencies by running `bundle`
8. Run all migrations by `rails db:create db:migrate`
9. Start Rails Puma server by `rails s`
10. Now you can make API calls as described later in this README.

## API Description

All examples are using [httpie](https://gist.github.com/BlakeGardner/5586954) library. 

### Employees:

1. GET /api/v1/employees - get the list of all existing employees 

    Example: `http :3000/api/v1/employees`
  
2. GET /api/v1/employee/#{id} - get info about particular Employee (along with available time slots). Params: id - employee ID.

   Example: `http :3000/api/v1/employees/8`

3. POST /api/v1/employees - create a new Employee. Params: email, name.

   Example: `http POST :3000/api/v1/employees employee\[email\]=frodo@gmail.com`

4. PUT /api/v1/employees/#{id} - update info about Employee. Params: email, name.

   Example: `http PUT :3000/api/v1/employees/2 employee\[email\]=gandalf@gmail.com`

5. DELETE /api/v1/employees/#{id} - remove Employee. 

Example: `http DELETE :3000/api/v1/employees/8`

### Candidates:

1. GET /api/v1/candidates - get the list of all existing candidates.

   Example: `http :3000/api/v1/candidates`

2. GET /api/v1/candidate/#{id} - get info about particular Candidate (along with available time slots). Params: id - candidate ID.

   Example: `Example: http :3000/api/v1/candidates/8`

3. POST /api/v1/candidates - create a new Candidate. Params: email, name.

   Example: `http POST :3000/api/v1/candidates candidate\[email\]=frodo@gmail.com`

4. PUT /api/v1/candidates/#{id} - update info about Candidate. Params: email, name.

   Example: `http PUT :3000/api/v1/candidates/2 candidate\[email\]=gandalf@gmail.com`

5. DELETE /api/v1/candidates/#{id} - remove Candidate.

   Example: `http DELETE :3000/api/v1/candidates/8`

### Time Slots:
1. GET /api/v1/time_slots?user_ids=[1,2,3] - get available overlapping time slots for users: Employees/Candidates. 

   Params: user_ids - one or many IDs of a Employee(s)/Candidate(s). Basically using this endpoint you can get overlapping time slots not only for employee(s) + candidate but all overlapping slots for any user: employee(s) + employee(s) or employee(s) + candidate(s) as well as candidate(s) + candidate(s).

   Example: `http :3000/api/v1/time_slots user_ids:='[4,5]'`

2. POST /api/v1/time_slots - create new time slot(s) for an Employee/Candidate. 
   
   Params: user_id - ID of a Employee/Candidate, time_slots - array of JSON objects for time slot, must contain following keys start, end with values in format ‘YYYY-DD-MM HH:MM’ or ISO8601 JSON date format. 

   Example: `'[ { "start": "2018-04-03 9:00", "end": "2018-04-03 11:30:00"} ]' or '[ { "start": "2018-04-03T09:00:00.000Z", "end": "2018-04-03T11:30:00.000Z"} ]’`

   **Note**: time zones support is not implemented for simplicity.

   Example: `http POST :3000/api/v1/time_slots Content-type:application/json Accept:application/json user_id=8 time_slots:='[ { "start": "2018-04-10 10:00:00", "end": "2018-04-10 11:00:00" } ]'`

3. DELETE /api/v1/time_slots/#{id} - remove particular time slot. Params: id - time slot id. 

   **Note**: no authentication is required right now to simplify things. In real world there must be authentication so malicious user won’t be able to remove time slots for someone else.

   Example: `http DELETE :3000/api/v1/time_slots/45`
