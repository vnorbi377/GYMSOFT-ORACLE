--------------------------------------------------------
--  File created - csütörtök-február-24-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger CLIENT_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "CLIENT_LOG_TR" 
after update or insert or delete on GYMSOFT.client

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'CLIENT','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'CLIENT','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'CLIENT','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "CLIENT_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EXERCISE_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "EXERCISE_MODIF_TR" 
before update of id,difficulty,video,picture,description,name,status on exercise
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('id') or updating('difficulty') or updating('video') or updating('picture') or updating('description') or updating('name') or updating('status') then

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

end if;

end;
/
ALTER TRIGGER "EXERCISE_MODIF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EXERCISE_EX_SERIES_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "EXERCISE_EX_SERIES_LOG_TR" 
after update or insert or delete on GYMSOFT.EXERCISE_EX_SERIES

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EXERCISE_EX_SERIES','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EXERCISE_EX_SERIES','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EXERCISE_EX_SERIES','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "EXERCISE_EX_SERIES_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CLIENT_WORK_PLAN_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "CLIENT_WORK_PLAN_LOG_TR" 
after update or insert or delete on GYMSOFT.CLIENT_WORK_PLAN

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'CLIENT_WORK_PLAN','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'CLIENT_WORK_PLAN','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'CLIENT_WORK_PLAN','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "CLIENT_WORK_PLAN_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CLIENT_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "CLIENT_MODIF_TR" 
before update of id,name,status,email,profile_pic,join_date,cl_type,details on client
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('name') or updating('id') or updating('status') or updating('email') or updating('profile_pic') or updating('join_date') or updating('cl_type') or updating('details') then

    /*if (:old.name != :new.name
        or :old.id != :new.id
        or :old.status != :new.status
        or :old.email != :new.email
        or :old.profile_pic != :new.profile_pic
        or :old.join_date != :new.join_date
        or :old.cl_type != :new.cl_type
        or :old.details != :new.details
    ) then*/

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

    --end if;
end if;

end;
/
ALTER TRIGGER "CLIENT_MODIF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger DDL_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "DDL_TR" 
after DDL on GYMSOFT.schema

declare

    v_user varchar2(50);
    v_obj_name varchar2(50);
    v_obj_type varchar2(50);
    v_operation varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;
select ora_sysevent into v_operation from dual;
select ora_dict_obj_name into v_obj_name from dual;
select ora_dict_obj_type into v_obj_type from dual;

insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,v_obj_name,v_obj_type,v_operation,utils_pkg.get_current_time);

end;
/
ALTER TRIGGER "DDL_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger DB_LOGON_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "DB_LOGON_TR" 
after logon on DATABASE

declare

    v_user VARCHAR2(50);

begin

EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = DD-MON-YYYY HH24:MI:SS';

select SYS_CONTEXT ('USERENV','SESSION_USERID') into v_user from dual;

insert into LOG (EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'-','-','USER_LOGON',utils_pkg.get_current_time);

end;




/
ALTER TRIGGER "DB_LOGON_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger WORK_DAILY_SPLT_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WORK_DAILY_SPLT_LOG_TR" 
after update or insert or delete on GYMSOFT.WORK_DAILY_SPLT

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORK_DAILY_SPLT','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORK_DAILY_SPLT','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORK_DAILY_SPLT','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "WORK_DAILY_SPLT_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EXERCISE_EX_SERIES_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "EXERCISE_EX_SERIES_MODIF_TR" 
before update of ex_id,ex_series_id on exercise_ex_series
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('ex_id') or updating('ex_series_id') then

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

end if;

end;
/
ALTER TRIGGER "EXERCISE_EX_SERIES_MODIF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EX_SERIES_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "EX_SERIES_LOG_TR" 
after update or insert or delete on GYMSOFT.EX_SERIES

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EX_SERIES','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EX_SERIES','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EX_SERIES','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "EX_SERIES_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EX_SERIES_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "EX_SERIES_MODIF_TR" 
before update of id,rep_type,sets,reps,name,status on ex_series
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('id') or updating('rep_type') or updating('sets') or updating('reps') or updating('name') or updating('status') then

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

end if;

end;
/
ALTER TRIGGER "EX_SERIES_MODIF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CLIENT_WORK_PLAN_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "CLIENT_WORK_PLAN_MODIF_TR" 
before update of client_id,workout_id,add_date on client_work_plan
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('client_id') or updating('workout_id') or updating('add_date') then

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

end if;

end;
/
ALTER TRIGGER "CLIENT_WORK_PLAN_MODIF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger WORK_DAILY_SPLT_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WORK_DAILY_SPLT_MODIF_TR" 
before update of id,day_part,time,name,status on work_daily_splt
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('id') or updating('day_part')  or updating('time') or updating('name') or updating('status') then

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

end if;

end;
/
ALTER TRIGGER "WORK_DAILY_SPLT_MODIF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EXERCISE_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "EXERCISE_LOG_TR" 
after update or insert or delete on GYMSOFT.exercise

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EXERCISE','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EXERCISE','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'EXERCISE','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "EXERCISE_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger DB_LOGOFF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "DB_LOGOFF_TR" 

before logoff or shutdown on database
declare

    v_user VARCHAR2(50);

begin

select SYS_CONTEXT ('USERENV','SESSION_USERID') into v_user from dual;

insert into LOG (EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'-','-','USER_LOGOFF',utils_pkg.get_current_time);

end;
/
ALTER TRIGGER "DB_LOGOFF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger WORKOUT_DAILYSPL_EXERC_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WORKOUT_DAILYSPL_EXERC_LOG_TR" 
after update or insert or delete on GYMSOFT.WORKOUT_DAILYSPL_EXERC

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT_DAILYSPL_EXERC','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT_DAILYSPL_EXERC','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT_DAILYSPL_EXERC','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "WORKOUT_DAILYSPL_EXERC_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger MESSAGE_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "MESSAGE_LOG_TR" 
after update or insert or delete on GYMSOFT.MESSAGE

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'MESSAGE','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'MESSAGE','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'MESSAGE','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "MESSAGE_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger WORKOUT_DAILYSPL_EXERC_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WORKOUT_DAILYSPL_EXERC_MODIF_TR" 
before update of daily_workout_id,ex_series_id,ex_series_number on workout_dailyspl_exerc
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('daily_workout_id') or updating('ex_series_id')  or updating('ex_series_number') then

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

end if;

end;
/
ALTER TRIGGER "WORKOUT_DAILYSPL_EXERC_MODIF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger WORKOUT_DSPLIT_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WORKOUT_DSPLIT_MODIF_TR" 
before update of split_id,workout_id,day_number on workout_dsplit
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('split_id') or updating('workout_id')  or updating('day_number') then

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

end if;

end;
/
ALTER TRIGGER "WORKOUT_DSPLIT_MODIF_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger WORKOUT_DSPLIT_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WORKOUT_DSPLIT_LOG_TR" 
after update or insert or delete on GYMSOFT.WORKOUT_DSPLIT

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT_DSPLIT','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT_DSPLIT','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT_DSPLIT','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "WORKOUT_DSPLIT_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger WORKOUT_LOG_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WORKOUT_LOG_TR" 
after update or insert or delete on GYMSOFT.WORKOUT

declare

    v_user varchar2(50);

begin


select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

case
    when inserting then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT','TABLE','INSTERT',utils_pkg.get_current_time);

    when updating then

        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT','TABLE','UPDATE',utils_pkg.get_current_time);

    when deleting then
        insert into LOG(EVENT_OWNER,OBJECT_NAME,OBJECT_TYPE,OPERATION,EVENT_DATE) values (v_user,'WORKOUT','TABLE','DELETE',utils_pkg.get_current_time);

    end case;

end;
/
ALTER TRIGGER "WORKOUT_LOG_TR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger WORKOUT_MODIF_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WORKOUT_MODIF_TR" 
before update of id,name,creator,difficulty,day_num,period,status on workout
for each row

declare
PRAGMA AUTONOMOUS_TRANSACTION;
    v_user varchar2(30);

begin

select SYS_CONTEXT ('USERENV','SESSION_USER') into v_user from dual;

if updating('id') or updating('name')  or updating('creator') or updating('difficulty') or updating('day_num') or updating('period') or updating('status') then

    :new.last_modified_by := v_user;
    commit;

    :new.last_modified_date := utils_pkg.get_current_time;
    commit;

end if;

end;
/
ALTER TRIGGER "WORKOUT_MODIF_TR" ENABLE;
