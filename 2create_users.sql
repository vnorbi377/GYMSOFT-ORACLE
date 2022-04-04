
create user GYMSOFT identified by "Gymsoft_2021";

create user test_user identified by "test_user";

create user bence identified by "bence";




create role clients identified by "Gymsoft_clients";


--create role trainers identified by "Gymsoft_trainers";


grant select, update, insert on MESSAGE to clients;




grant select on workout_dsplit  to clients; --- Minden táblára select engedély a klienskenek

 