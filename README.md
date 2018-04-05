# README

POST /api/v1/time_slots

http -v --timeout 180 POST :3000/api/v1/time_slots Accept:application/json user_id=4 time_slots:='[ { "start": "2018-04-03 10:00:00", "end": "2018-04-03 11:00:00" }, { "start": "2018-05-03 12:00", "end": "2018-05-03" } ]'
