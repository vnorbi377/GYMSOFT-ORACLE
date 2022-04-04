--------------------------------------------------------
--  File created - csütörtök-február-24-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package CLIENT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CLIENT_PKG" as

function delete_client(c_id number) return varchar2;

function get_clients return clob;

function get_clients_workouts return clob;

function insert_client_json(p_json clob) return varchar2;

function modify_client_json(p_json clob) return varchar2;

end client_pkg;

/
--------------------------------------------------------
--  DDL for Package CLIENT_WORK_PLAN_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CLIENT_WORK_PLAN_PKG" as

function add_client_to_workout(c_id number, w_id number) return varchar2;

function remove_client_from_workout(c_id number, w_id number) return varchar2;

function modify_client_paired_workout(c_id number, old_workout_id number, new_workout_id number) return varchar2;

function modify_client_workouts(c_id number, p_json clob) return varchar2;

end client_work_plan_pkg;

/
--------------------------------------------------------
--  DDL for Package EX_SERIES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "EX_SERIES_PKG" as

function get_ex_series return clob;

function delete_ex_series(exs_id number) return varchar2;

function insert_ex_series(p_json clob) return varchar2;

function modify_ex_series(p_json clob) return varchar2;

end ex_series_pkg;

/
--------------------------------------------------------
--  DDL for Package EXERCISE_EX_SERIES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "EXERCISE_EX_SERIES_PKG" as

function add_exerc_to_series(p_ex_id number, p_ex_series_id number) return varchar2;

function modify_exerc_paired_series(p_ex_series_id number, p_old_ex_id number, p_new_ex_id number) return varchar2;

function remove_ex_series_pair(p_ex_id number, p_ex_series_id number) return varchar2;

end exercise_ex_series_pkg;

/
--------------------------------------------------------
--  DDL for Package EXERCISE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "EXERCISE_PKG" as

function get_exercise(ex_id NUMBER) return clob;

function get_exercises return clob;

function insert_exercise_json(json_par varchar2) return varchar2;

function modify_exercise_json(json_par varchar2) return varchar2;

function delete_exercise(ex_id number) return varchar2;

end exercise_pkg;

/
--------------------------------------------------------
--  DDL for Package MESSAGE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "MESSAGE_PKG" as



end message_pkg;

/
--------------------------------------------------------
--  DDL for Package UTILS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "UTILS_PKG" as


function get_current_time return date;


end utils_pkg;

/
--------------------------------------------------------
--  DDL for Package WORK_DAILY_SPLIT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WORK_DAILY_SPLIT_PKG" as

function get_daily_workouts return clob;

function delete_work_daily_split(wds_id number) return varchar2;

function insert_daily_workout(p_json clob) return varchar2;

function modify_daily_workout(p_json clob) return varchar2;

end work_daily_split_pkg;

/
--------------------------------------------------------
--  DDL for Package WORKOUT_DAILYSPL_EXERC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WORKOUT_DAILYSPL_EXERC_PKG" as

function insert_ex_series_to_daily(dailyw_id number, exseries_id number, exseries_number number) return varchar2;

function modify_daily_ex_series(dailyw_id number, old_exs_id number, new_exs_id number, exseries_number number) return varchar2;

function remove_ex_series_from_daily(dailyw_id number, exseries_id number) return varchar2;

function modify_all_daily_ex_series(dw_id number, p_json clob) return varchar2;

end workout_dailyspl_exerc_pkg;

/
--------------------------------------------------------
--  DDL for Package WORKOUT_DSPLIT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WORKOUT_DSPLIT_PKG" as

function add_dailysp_to_workout(w_id number, d_id number, p_DAY_NUMBER number) return varchar2;

function modify_daily_workout_pair(w_id number, old_d_id number, new_d_id number, n_DAY_NUMBER number) return varchar2;

function remove_daily_from_workout(d_id number, w_id number) return varchar2;

function modify_workout_days(w_id number, p_json clob) return varchar2;

end workout_dsplit_pkg;

/
--------------------------------------------------------
--  DDL for Package WORKOUT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WORKOUT_PKG" as

function get_workouts return clob;

function delete_workout(w_id number) return varchar2;

function insert_workout(p_json clob) return varchar2;

function modify_workout(p_json clob) return varchar2;

end workout_pkg;

/
--------------------------------------------------------
--  DDL for Package Body CLIENT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CLIENT_PKG" as

function delete_client(c_id number) return varchar2 is

    v_succ varchar2(10) := '0';

begin

    begin

        update client set status = 'DELETED' where id = c_id;
        commit;

        if(SQL%NOTFOUND) then

            v_succ := '-1';

        end if;

        exception
        when others then
            v_succ := 'Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM;

    end;

return v_succ;

end delete_client;


function get_clients return clob is 

    v_json clob;

begin 

    begin

        SELECT JSON_ARRAYAGG(JSON_OBJECT( KEY 'id' VALUE id, KEY 'name' VALUE name, KEY 'status' value status, KEY 'email' value email, KEY 'profile_pic' value profile_pic, KEY 'join_date' value join_date, KEY 'details' value details ) 
    FORMAT JSON RETURNING CLOB) into v_json FROM client where status != 'DELETED' and cl_type = 'CLIENT';

    exception 
    when others then
        v_json := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

    end;

    return v_json;

end get_clients;


function get_clients_workouts return clob is

 v_json clob;

begin

    begin

        SELECT JSON_ARRAYAGG(JSON_OBJECT( KEY 'id' VALUE c.id, KEY 'name' VALUE c.name, KEY 'email' value c.email, KEY 'profile_pic' value c.profile_pic,
        KEY 'join_date' value c.join_date, KEY 'details' VALUE c.details, KEY 'add_date' value cwp.add_date, KEY 'w_id' value w.id, KEY 'w_name' value w.name, 
        KEY 'w_creator' value w.creator, KEY 'difficulty' value w.difficulty, KEY 'day_num' value w.day_num, KEY 'period' value w.period,
        KEY 'wds_id' value wds.id, KEY 'day_part' value wds.day_part ,KEY 'time' value wds.time, KEY 'wde_ex_number' value wde.ex_series_number,
        KEY 'exs_id' value exs.id, KEY 'rep_type' value exs.rep_type, KEY 'sets' value exs.sets, KEY 'reps' value exs.reps, KEY 'exs_name' value exs.name,
        KEY 'e_id' value e.id, KEY 'difficulty' value e.difficulty, KEY 'video' value e.video, KEY 'picture' value e.picture, KEY 'description' value e.description,
        KEY 'name' value e.name) 
        FORMAT JSON RETURNING CLOB) into v_json FROM client c 
        join client_work_plan cwp on cwp.client_id = c.id
        join workout w on w.id = cwp.workout_id
        join workout_dsplit wd on wd.workout_id = w.id
        join work_daily_splt wds on wds.id = wd.split_id
        join workout_dailyspl_exerc wde on wde.daily_workout_id = wds.id
        join ex_series exs on exs.id = wde.ex_series_id
        join exercise_ex_series exes on exes.ex_series_id = exs.id
        join exercise e on e.id = exes.ex_id
        where c.status != 'DELETED' and c.cl_type = 'CLIENT';

    if(SQL%NOTFOUND) then

        v_json := '-1';

    end if;

    exception 
    when others then
        v_json := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

    end;

    return v_json;

end get_clients_workouts;



function insert_client_json(p_json clob) return varchar2 is

   cursor v_json_cur is 
SELECT id,name,email,profile_pic,join_date,cl_type,details
      FROM JSON_TABLE (p_json,
                       '$'
                       COLUMNS 
                       id NUMBER PATH '$.id',
                       name VARCHAR2 PATH '$.name',
                       email VARCHAR2 PATH '$.email',
                       profile_pic VARCHAR2 PATH '$.profile_pic',
                       join_date VARCHAR2 PATH '$.join_date',
                       cl_type VARCHAR2 PATH '$.cl_type',
                       details VARCHAR2 PATH '$.details'
                       );

v_iter v_json_cur%ROWTYPE;

succ_val varchar2(10) := '0';

begin

    begin

    for v_iter in v_json_cur loop

        insert into client (id, name, email, profile_pic, join_date, cl_type, details) values (v_iter.id, v_iter.name, v_iter.email, v_iter.profile_pic, v_iter.join_date, v_iter.cl_type, v_iter.details);
        commit;

    end loop;

            exception
            when DUP_VAL_ON_INDEX then
                    succ_val := '-1';
            when others then
                    succ_val := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
end;



return succ_val;

end insert_client_json;



function modify_client_json(p_json clob) return varchar2 is

   cursor v_json_cur is 
SELECT id,name,email,profile_pic,join_date,cl_type,details
      FROM JSON_TABLE (p_json,
                       '$'
                       COLUMNS 
                       id NUMBER PATH '$.id',
                       name VARCHAR2 PATH '$.name',
                       email VARCHAR2 PATH '$.email',
                       profile_pic VARCHAR2 PATH '$.profile_pic',
                       join_date VARCHAR2 PATH '$.join_date',
                       cl_type VARCHAR2 PATH '$.cl_type',
                       details VARCHAR2 PATH '$.details'
                       );

    v_iter v_json_cur%ROWTYPE;

    v_succ varchar2(10) := '0';
    id_exist NUMBER := 0;

begin

    begin

    for v_iter in v_json_cur loop

        select count(1) into id_exist from exercise where id = v_iter.id;

        if id_exist = 1 then

            update client set 
            name = v_iter.name,
            email = v_iter.email,
            profile_pic = v_iter.profile_pic,
            join_date = v_iter.join_date,
            cl_type = v_iter.cl_type,
            details = v_iter.details
            where id = v_iter.id;
            commit;

        else

            v_succ := -1;

        end if;

    end loop;

            exception
            when DUP_VAL_ON_INDEX then
                    v_succ := '-1';
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
end;

return v_succ;    

end modify_client_json;


end client_pkg;

/
--------------------------------------------------------
--  DDL for Package Body CLIENT_WORK_PLAN_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CLIENT_WORK_PLAN_PKG" as

function add_client_to_workout(c_id number, w_id number) return varchar2 is


v_succ varchar2(10) := '0';

v_cwp_client number := 0;

v_cwp_status varchar2(10);


begin

    select count(*) into v_cwp_client from client_work_plan where client_id = c_id and workout_id = w_id;

    if v_cwp_client = 1 then

        select status into v_cwp_status from client_work_plan where client_id = c_id and workout_id = w_id;

        if v_cwp_status = 'DELETED' then

            update client_work_plan set status = 'ACTIVE' where client_id = c_id and workout_id = w_id;

        else

            v_succ := '-1';

        end if;

    else

        insert into client_work_plan (client_id, workout_id,add_date,status) values (c_id,w_id,utils_pkg.get_current_time,'ACTIVE');

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);


return v_succ;

end add_client_to_workout;




function modify_client_paired_workout(c_id number, old_workout_id number, new_workout_id number) return varchar2 is 


v_succ varchar2(10) := '0';

begin


    update client_work_plan set workout_id = new_workout_id where workout_id = old_workout_id and client_id = c_id;

    if(SQL%NOTFOUND) then

        v_succ := '-1';

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

return v_succ;

end modify_client_paired_workout;



function remove_client_from_workout(c_id number, w_id number) return varchar2 is


v_succ varchar2(10) := '0';

begin

    update client_work_plan set status = 'DELETED' where client_id = c_id and workout_id = w_id;

    if(SQL%NOTFOUND) then

        v_succ := '-1';

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);


return v_succ;

end remove_client_from_workout;




function modify_client_workouts(c_id number, p_json clob) return varchar2 is


 cursor v_json_cur is 
    SELECT id
      FROM JSON_TABLE (p_json,
                       '$.ids[*]'
                       COLUMNS 
                       id number PATH '$'
                       );

    v_iter v_json_cur%ROWTYPE; 

    v_succ varchar2(200) := '0';
    id_exist NUMBER := 0;


begin

    update client_work_plan set status = 'DELETED' where client_id = c_id;
    commit;

    begin
    
        for v_iter in v_json_cur loop
        
                begin
        
                    select v_iter.id into id_exist from dual where v_iter.id in (select workout_id from client_work_plan where client_id = c_id);
                    
                    exception
                      when NO_DATA_FOUND then
                        id_exist :=0;
                
                end;
                
                if id_exist != 0 then
            
                    update client_work_plan set status = 'ACTIVE' where client_id = c_id and workout_id = v_iter.id;
                    commit;
                    
                else
                
                    insert into client_work_plan (client_id, workout_id, add_date, status) values (c_id, v_iter.id, utils_pkg.get_current_time, 'ACTIVE');
                    commit;
                    
                end if;
                
            id_exist := 0;        
                
        end loop;
        
         exception
            when DUP_VAL_ON_INDEX then
                    v_succ := '-1';
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
        
    end; 
    
    return v_succ;

end modify_client_workouts;



end client_work_plan_pkg;

/
--------------------------------------------------------
--  DDL for Package Body EX_SERIES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "EX_SERIES_PKG" as

function get_ex_series return clob is 

 v_json clob;

begin

    begin

        SELECT JSON_ARRAYAGG(JSON_OBJECT(
        KEY 'exs_id' value exs.id, KEY 'rep_type' value exs.rep_type, KEY 'sets' value exs.sets, KEY 'reps' value exs.reps, KEY 'exs_name' value exs.name,
        KEY 'e_id' value e.id, KEY 'difficulty' value e.difficulty, KEY 'video' value e.video, KEY 'picture' value e.picture, KEY 'description' value e.description,
        KEY 'name' value e.name) 
        FORMAT JSON RETURNING CLOB) into v_json FROM ex_series exs
        join exercise_ex_series exes on exes.ex_series_id = exs.id
        join exercise e on e.id = exes.ex_id
        where exs.status != 'DELETED';

    if(SQL%NOTFOUND) then

        v_json := '-1';

    end if;

    exception 
    when others then
        v_json := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

    end;

    return v_json;


end get_ex_series;



function delete_ex_series(exs_id number) return varchar2 is

    v_succ varchar2(10) := '0';

begin

    begin

    update ex_series set status = 'DELETED' where id = exs_id;

    if(SQL%NOTFOUND) then

       v_succ := '-1';

    end if;

    exception 
    when others then
        v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

    end;

    return v_succ;

end delete_ex_series;



function insert_ex_series(p_json clob) return varchar2 is


   cursor v_json_cur is 
SELECT id,rep_type,sets,reps,name
      FROM JSON_TABLE (p_json,
                       '$'
                       COLUMNS 
                       id NUMBER PATH '$.id',
                       rep_type VARCHAR2 PATH '$.rep_type',
                       sets NUMBER PATH '$.sets',
                       reps NUMBER PATH '$.reps',
                       name VARCHAR2 PATH '$.name'
                       );

v_iter v_json_cur%ROWTYPE;

succ_val varchar2(10) := '0';

begin

    begin

    for v_iter in v_json_cur loop

        insert into ex_series (id, rep_type, sets, reps, name, status, last_modified_by, last_modified_date) values (v_iter.id, v_iter.rep_type, v_iter.sets, v_iter.reps, v_iter.name, 'ACTIVE', '-', '-');
        commit;

    end loop;

            exception
            when DUP_VAL_ON_INDEX then
                    succ_val := '-1';
            when others then
                    succ_val := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
end;



return succ_val;


end insert_ex_series;



function modify_ex_series(p_json clob) return varchar2 is

  cursor v_json_cur is 
SELECT id,rep_type,sets,reps,name
      FROM JSON_TABLE (p_json,
                       '$'
                       COLUMNS 
                       id NUMBER PATH '$.id',
                       rep_type VARCHAR2 PATH '$.rep_type',
                       sets NUMBER PATH '$.sets',
                       reps NUMBER PATH '$.reps',
                       name VARCHAR2 PATH '$.name'
                       );

    v_iter v_json_cur%ROWTYPE;

    v_succ varchar2(10) := '0';
    id_exist NUMBER := 0;

begin

    begin

    for v_iter in v_json_cur loop

        select count(1) into id_exist from ex_series where id = v_iter.id;

        if id_exist = 1 then

            update ex_series set 
            rep_type = v_iter.rep_type,
            sets = v_iter.sets,
            reps = v_iter.reps,
            name = v_iter.name
            where id = v_iter.id;
            commit;

        else

            v_succ := -1;

        end if;

    end loop;

            exception
            when DUP_VAL_ON_INDEX then
                    v_succ := '-1';
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
end;

return v_succ;    

end modify_ex_series;


end ex_series_pkg;

/
--------------------------------------------------------
--  DDL for Package Body EXERCISE_EX_SERIES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "EXERCISE_EX_SERIES_PKG" as

function add_exerc_to_series(p_ex_id number, p_ex_series_id number) return varchar2 is



v_succ varchar2(10) := '0';

v_exseries number := 0;

v_exs_status varchar2(10);


begin

    select count(*) into v_exseries from exercise_ex_series where ex_id = p_ex_id and ex_series_id = p_ex_series_id;

    if v_exseries = 1 then

        select status into v_exs_status from exercise_ex_series where ex_id = p_ex_id and ex_series_id = p_ex_series_id;

        if v_exs_status = 'DELETED' then

            update exercise_ex_series set status = 'ACTIVE' where ex_id = p_ex_id and ex_series_id = p_ex_series_id;

        else

            v_succ := '-1';

        end if;

    else

        insert into exercise_ex_series (ex_id, ex_series_id,status) values (p_ex_id,p_ex_series_id,'ACTIVE');

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);


return v_succ;


end add_exerc_to_series;


function modify_exerc_paired_series(p_ex_series_id number, p_old_ex_id number, p_new_ex_id number) return varchar2 is

v_succ varchar2(10) := '0';

begin


    update exercise_ex_series set ex_id = p_new_ex_id where ex_series_id = p_ex_series_id and ex_id = p_old_ex_id;

    if(SQL%NOTFOUND) then

        v_succ := '-1';

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

return v_succ;

end modify_exerc_paired_series;


function remove_ex_series_pair(p_ex_id number, p_ex_series_id number) return varchar2 is

v_succ varchar2(10) := '0';

begin

    update exercise_ex_series set status = 'DELETED' where ex_id = p_ex_id and ex_series_id = p_ex_series_id;

    if(SQL%NOTFOUND) then

        v_succ := '-1';

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);


return v_succ;

end remove_ex_series_pair;


end exercise_ex_series_pkg;

/
--------------------------------------------------------
--  DDL for Package Body EXERCISE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "EXERCISE_PKG" as



function get_exercise(ex_id NUMBER) return CLOB is 

v_json clob;
res_count NUMBER;

begin

select count(*) into res_count from exercise where id = ex_id and status != 'DELETED';

if res_count > 0 then

    SELECT JSON_ARRAYAGG(JSON_OBJECT( KEY 'id' VALUE id, KEY 'difficulty' VALUE difficulty, KEY 'video' value video, KEY 'picture' value picture, KEY 'description' value description, KEY 'name' value name ) FORMAT JSON RETURNING CLOB) into v_json 
                                FROM exercise
                                where id = ex_id;

else

    v_json := 'Nincs ilyen gyakorlat!';

end if;

return v_json;

end get_exercise;



function get_exercises return clob is 

v_json clob;

begin

    begin
    SELECT JSON_ARRAYAGG(JSON_OBJECT( KEY 'id' VALUE id, KEY 'difficulty' VALUE difficulty, KEY 'video' value video, KEY 'picture' value picture, KEY 'description' value description, KEY 'name' value name ) 
    FORMAT JSON RETURNING CLOB) into v_json FROM exercise where status != 'DELETED';

    exception 
    when others then
        v_json := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

    end;

return v_json;

end get_exercises;


function insert_exercise_json(json_par varchar2) return varchar2 is

cursor v_json_cur is 
SELECT id,difficulty,video,picture,description,name
      FROM JSON_TABLE (json_par,
                       '$'
                       COLUMNS 
                       id NUMBER PATH '$.id',
                       difficulty VARCHAR2 PATH '$.difficulty',
                       video VARCHAR2 PATH '$.video',
                       picture VARCHAR2 PATH '$.picture',
                       description VARCHAR2 PATH '$.description',
                       name VARCHAR2 PATH '$.name'
                       );

v_iter v_json_cur%ROWTYPE;

succ_val varchar2(10) := '0';

begin

    begin

    for v_iter in v_json_cur loop

        insert into exercise (id, difficulty, video, picture, description, name) values (v_iter.id, v_iter.difficulty, v_iter.video, v_iter.picture, v_iter.description, v_iter.name);
        commit;

    end loop;

            exception
            when DUP_VAL_ON_INDEX then
                    succ_val := '-1';
            when others then
                    succ_val := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
end;



return succ_val;


end insert_exercise_json;


function modify_exercise_json(json_par varchar2) return varchar2 is

cursor v_json_cur is 
SELECT id,difficulty,video,picture,description,name
      FROM JSON_TABLE (json_par,
                       '$'
                       COLUMNS 
                       id NUMBER PATH '$.id',
                       difficulty VARCHAR2 PATH '$.difficulty',
                       video VARCHAR2 PATH '$.video',
                       picture VARCHAR2 PATH '$.picture',
                       description VARCHAR2 PATH '$.description',
                       name VARCHAR2 PATH '$.name'
                       );

v_iter v_json_cur%ROWTYPE;

succ_val varchar2(10) := '0';
id_exist NUMBER := 0;

begin

    begin

    for v_iter in v_json_cur loop

        select count(1) into id_exist from exercise where id = v_iter.id;

        if id_exist = 1 then

            update exercise set 
            difficulty = v_iter.difficulty,
            video = v_iter.video,
            picture = v_iter.picture,
            description = v_iter.description,
            name = v_iter.name
            where id = v_iter.id;
            commit;

        else

            succ_val := -1;

        end if;

    end loop;

            exception
            when DUP_VAL_ON_INDEX then
                    succ_val := '-1';
            when others then
                    succ_val := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
end;


return succ_val;

end modify_exercise_json;


function delete_exercise(ex_id number) return varchar2 is


    v_return varchar2(10) := '0';


begin

    begin

        update exercise set status = 'DELETED' where id = ex_id;
        commit;

        exception
        when others then
            v_return := 'Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM;

    end;


if(SQL%NOTFOUND) then

    v_return := '-1';

end if;

return v_return;

end delete_exercise;


end exercise_pkg;

/
--------------------------------------------------------
--  DDL for Package Body MESSAGE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "MESSAGE_PKG" as



end message_pkg;

/
--------------------------------------------------------
--  DDL for Package Body UTILS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "UTILS_PKG" as



function get_current_time return date is

    --v_second varchar2(10);
    --v_minute varchar2(10);
    --v_hour varchar2(10);

begin

--SELECT EXTRACT(second FROM SYSTIMESTAMP) into v_second FROM DUAL;

--SELECT EXTRACT(minute FROM SYSTIMESTAMP) into v_minute FROM DUAL;

--SELECT EXTRACT(hour FROM SYSTIMESTAMP)+1 into v_hour from DUAL;

--return SYSDATE || ' ' || v_hour || ':' || v_minute || ':' || v_second; 
--EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = DD-MON-YYYY HH24:MI:SS';

return current_date;

end get_current_time;


end utils_pkg;

/
--------------------------------------------------------
--  DDL for Package Body WORK_DAILY_SPLIT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WORK_DAILY_SPLIT_PKG" as

function get_daily_workouts return clob is 

 v_json clob;

begin

    begin

        SELECT JSON_ARRAYAGG(JSON_OBJECT(KEY 'wds_id' value wds.id, KEY 'day_part' value wds.day_part ,KEY 'time' value wds.time, KEY 'wde_ex_number' value wde.ex_series_number,
        KEY 'exs_id' value exs.id, KEY 'rep_type' value exs.rep_type, KEY 'sets' value exs.sets, KEY 'reps' value exs.reps, KEY 'exs_name' value exs.name,
        KEY 'e_id' value e.id, KEY 'difficulty' value e.difficulty, KEY 'video' value e.video, KEY 'picture' value e.picture, KEY 'description' value e.description,
        KEY 'name' value e.name) 
        FORMAT JSON RETURNING CLOB) into v_json FROM work_daily_splt wds
        join workout_dailyspl_exerc wde on wde.daily_workout_id = wds.id
        join ex_series exs on exs.id = wde.ex_series_id
        join exercise_ex_series exes on exes.ex_series_id = exs.id
        join exercise e on e.id = exes.ex_id
        where wds.status != 'DELETED';

    if(SQL%NOTFOUND) then

        v_json := '-1';

    end if;

    exception 
    when others then
        v_json := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

    end;

    return v_json;


end get_daily_workouts;



function delete_work_daily_split(wds_id number) return varchar2 is

    v_succ varchar2(10) := '0';

begin

    begin

    update work_daily_splt set status = 'DELETED' where id = wds_id;

    if(SQL%NOTFOUND) then

       v_succ := '-1';

    end if;

    exception 
    when others then
        v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

    end;

    return v_succ;

end delete_work_daily_split;


function insert_daily_workout(p_json clob) return varchar2 is

cursor v_json_cur is 
SELECT id,day_part,time,name,day_num
      FROM JSON_TABLE (p_json,
                       '$'
                       COLUMNS 
                       id NUMBER PATH '$.id',
                       day_part VARCHAR2 PATH '$.day_part',
                       time NUMBER PATH '$.time',
                       name NUMBER PATH '$.name',
                       day_num VARCHAR2 PATH '$.day_num'
                       );

v_iter v_json_cur%ROWTYPE;

succ_val varchar2(10) := '0';

begin

    begin

    for v_iter in v_json_cur loop

        insert into work_daily_splt (id, day_part, time, name, day_num, status) values (v_iter.id, v_iter.day_part, v_iter.time ,v_iter.name, v_iter.day_num, 'ACTIVE');
        commit;

    end loop;

            exception
            when DUP_VAL_ON_INDEX then
                    succ_val := '-1';
            when others then
                    succ_val := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
end;



return succ_val;

end insert_daily_workout;



function modify_daily_workout(p_json clob) return varchar2 is 

cursor v_json_cur is 
SELECT id,day_part,time,name,day_num
      FROM JSON_TABLE (p_json,
                       '$'
                       COLUMNS 
                       id NUMBER PATH '$.id',
                       day_part VARCHAR2 PATH '$.day_part',
                       time NUMBER PATH '$.time',
                       name NUMBER PATH '$.name',
                       day_num VARCHAR2 PATH '$.day_num'
                       );


    v_iter v_json_cur%ROWTYPE;

    v_succ varchar2(10) := '0';
    id_exist NUMBER := 0;

begin

    begin

    for v_iter in v_json_cur loop

        select count(1) into id_exist from workout where id = v_iter.id;

        if id_exist = 1 then

            update work_daily_splt set 
            day_part = v_iter.day_part,
            time = v_iter.time,
            name = v_iter.name,
            day_num = v_iter.day_num
            where id = v_iter.id;
            commit;

        else

            v_succ := -1;

        end if;

    end loop;

            exception
            when DUP_VAL_ON_INDEX then
                    v_succ := '-1';
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
end;

return v_succ;    


end modify_daily_workout;

end work_daily_split_pkg;

/
--------------------------------------------------------
--  DDL for Package Body WORKOUT_DAILYSPL_EXERC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WORKOUT_DAILYSPL_EXERC_PKG" as


function insert_ex_series_to_daily(dailyw_id number, exseries_id number, exseries_number number) return varchar2 is


v_succ varchar2(10) := '0';

v_ds_exseries number := 0;

v_ds_status varchar2(10);


begin

    select count(*) into v_ds_exseries from workout_dailyspl_exerc where daily_workout_id = dailyw_id and ex_series_id = exseries_id;

    if v_ds_exseries = 1 then

        select status into v_ds_status from workout_dailyspl_exerc where daily_workout_id = dailyw_id and ex_series_id = exseries_id;

        if v_ds_status = 'DELETED' then

            update workout_dailyspl_exerc set status = 'ACTIVE' where daily_workout_id = dailyw_id and ex_series_id = exseries_id;

        else

            v_succ := '-1';

        end if;

    else

        insert into workout_dailyspl_exerc (daily_workout_id, ex_series_id,ex_series_number,status) values (dailyw_id,exseries_id,exseries_number,'ACTIVE');

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);


return v_succ;


end insert_ex_series_to_daily;


function modify_daily_ex_series(dailyw_id number, old_exs_id number, new_exs_id number, exseries_number number) return varchar2 is


v_succ varchar2(10) := '0';

begin


    update workout_dailyspl_exerc set ex_series_id = new_exs_id where daily_workout_id = dailyw_id and ex_series_id = old_exs_id;

    if(SQL%NOTFOUND) then

        v_succ := '-1';

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

return v_succ;


end modify_daily_ex_series;


function modify_all_daily_ex_series(dw_id number, p_json clob) return varchar2 is


 cursor v_json_cur is 
    SELECT id
      FROM JSON_TABLE (p_json,
                       '$.ids[*]'
                       COLUMNS 
                       id number PATH '$'
                       );

    v_iter v_json_cur%ROWTYPE; 

    v_succ varchar2(200) := '0';
    id_exist NUMBER := 0;
    elem_id number := 1;


begin

    update workout_dailyspl_exerc set status = 'DELETED' where daily_workout_id = dw_id;
    commit;

    begin
    
        for v_iter in v_json_cur loop
        
                begin
        
                    select v_iter.id into id_exist from dual where v_iter.id in (select ex_series_id from workout_dailyspl_exerc where daily_workout_id = dw_id);
                    
                    exception
                      when NO_DATA_FOUND then
                        id_exist :=0;
                
                end;
                
                if id_exist != 0 then
            
                    update workout_dailyspl_exerc set status = 'ACTIVE', ex_series_number = elem_id where daily_workout_id = dw_id and ex_series_id = v_iter.id;
                    commit;
                    
                else
                
                    insert into workout_dailyspl_exerc (daily_workout_id, ex_series_id, ex_series_number, status) values (dw_id, v_iter.id, elem_id, 'ACTIVE');
                    commit;
                    
                end if;
                
            id_exist := 0;
            elem_id := elem_id + 1;
                
        end loop;
        
         exception
            when DUP_VAL_ON_INDEX then
                    v_succ := '-1';
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
        
    end; 
    
    return v_succ;

end modify_all_daily_ex_series;




function remove_ex_series_from_daily(dailyw_id number, exseries_id number) return varchar2 is


v_succ varchar2(10) := '0';

begin

    update workout_dailyspl_exerc set status = 'DELETED' where daily_workout_id = dailyw_id and ex_series_id = exseries_id;

    if(SQL%NOTFOUND) then

        v_succ := '-1';

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);


return v_succ;


end remove_ex_series_from_daily;


end workout_dailyspl_exerc_pkg;

/
--------------------------------------------------------
--  DDL for Package Body WORKOUT_DSPLIT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WORKOUT_DSPLIT_PKG" as

function add_dailysp_to_workout(w_id number, d_id number, p_DAY_NUMBER number) return varchar2 is


v_succ varchar2(10) := '0';

v_workout number := 0;

v_workout_status varchar2(10);


begin

    select count(*) into v_workout from workout_dsplit where split_id = d_id and workout_id = w_id;

    if v_workout = 1 then

        select status into v_workout_status from workout_dsplit where split_id = d_id and workout_id = w_id;

        if v_workout_status = 'DELETED' then

            update workout_dsplit set status = 'ACTIVE' where split_id = d_id and workout_id = w_id;

        else

            v_succ := '-1';

        end if;

    else

        insert into workout_dsplit (split_id, workout_id,DAY_NUMBER,status) values (d_id,w_id,p_DAY_NUMBER,'ACTIVE');

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);


return v_succ;


end add_dailysp_to_workout;




function modify_daily_workout_pair(w_id number, old_d_id number, new_d_id number, n_DAY_NUMBER number) return varchar2 is


v_succ varchar2(10) := '0';

begin


    update workout_dsplit set split_id = new_d_id, DAY_NUMBER = n_DAY_NUMBER where split_id = old_d_id and w_id = workout_id;

    if(SQL%NOTFOUND) then

        v_succ := '-1';

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);

return v_succ;


end modify_daily_workout_pair;


function modify_workout_days(w_id number, p_json clob) return varchar2 is


 cursor v_json_cur is 
    SELECT id
      FROM JSON_TABLE (p_json,
                       '$.ids[*]'
                       COLUMNS 
                       id number PATH '$'
                       );

    v_iter v_json_cur%ROWTYPE; 

    v_succ varchar2(200) := '0';
    id_exist NUMBER := 0;
    elem_id number := 1;


begin

    update workout_dsplit set status = 'DELETED' where workout_id = w_id;
    commit;

    begin
    
        for v_iter in v_json_cur loop
        
                begin
        
                    select v_iter.id into id_exist from dual where v_iter.id in (select split_id from workout_dsplit where workout_id = w_id);
                    
                    exception
                      when NO_DATA_FOUND then
                        id_exist :=0;
                
                end;
                
                if id_exist != 0 then
            
                    update workout_dsplit set status = 'ACTIVE',day_number = elem_id where workout_id = w_id and workout_id = v_iter.id;
                    commit;
                    
                else
                
                    insert into workout_dsplit (split_id, workout_id, day_number, status) values (v_iter.id, w_id, elem_id, 'ACTIVE');
                    commit;
                    
                end if;
                
            id_exist := 0;
            elem_id := elem_id + 1;
                
        end loop;
        
         exception
            when DUP_VAL_ON_INDEX then
                    v_succ := '-1';
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);
        
    end; 
    
    return v_succ;

end modify_workout_days;



function remove_daily_from_workout(d_id number, w_id number) return varchar2 is


v_succ varchar2(10) := '0';

begin

    update workout_dsplit set status = 'DELETED' where split_id = d_id and workout_id = w_id;

    if(SQL%NOTFOUND) then

        v_succ := '-1';

    end if;

    exception
            when others then
                    v_succ := TO_CLOB('Nem várt hiba történt! - '||SQLCODE||' -ERROR- '||SQLERRM);


return v_succ;

end remove_daily_from_workout;


end workout_dsplit_pkg;

/
