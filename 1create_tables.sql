CREATE TABLE CLIENT 
(
  ID NUMBER NOT NULL 
, NAME VARCHAR2(20) NOT NULL 
, STATUS VARCHAR2(20) NOT NULL 
, EMAIL VARCHAR2(20) NOT NULL 
, PROFILE_PIC VARCHAR2(20) NOT NULL 
, JOIN_DATE DATE NOT NULL 
, CL_TYPE VARCHAR2(20) NOT NULL 
, DETAILS VARCHAR2(200) 
, LAST_MODIFIED_BY VARCHAR2(30) 
, LAST_MODIFIED_DATE VARCHAR2(30) 
) ;


  CREATE TABLE "MESSAGE" 
   (	"ID" VARCHAR2(20), 
	"SC_ID" NUMBER, 
	"MSG_TYPE" VARCHAR2(20), 
	"MSG" VARCHAR2(200), 
	"STATUS" VARCHAR2(20), 
	"DATESENT" DATE, 
	"RC_ID" NUMBER
   ) ;


  CREATE TABLE "EXERCISE_EX_SERIES" 
   (	"EX_ID" VARCHAR2(20), 
	"EX_SERIES_ID" VARCHAR2(20), 
	"LAST_MODIFIED_BY" VARCHAR2(30), 
	"LAST_MODIFIED_DATE" VARCHAR2(30), 
	"STATUS" VARCHAR2(20)
   )  ;


  CREATE TABLE "CLIENT_WORK_PLAN" 
   (	"CLIENT_ID" NUMBER, 
	"WORKOUT_ID" NUMBER, 
	"ADD_DATE" DATE, 
	"LAST_MODIFIED_BY" VARCHAR2(30), 
	"LAST_MODIFIED_DATE" VARCHAR2(30), 
	"STATUS" VARCHAR2(20)
   );


  CREATE TABLE "EX_SERIES" 
   (	"ID" NUMBER, 
	"REP_TYPE" VARCHAR2(20), 
	"SETS" NUMBER, 
	"REPS" NUMBER, 
	"NAME" VARCHAR2(200), 
	"STATUS" VARCHAR2(20), 
	"LAST_MODIFIED_BY" VARCHAR2(30), 
	"LAST_MODIFIED_DATE" VARCHAR2(30)
   ) ;


  CREATE TABLE "WORKOUT" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(70), 
	"CREATOR" VARCHAR2(200), 
	"DIFFICULTY" VARCHAR2(200), 
	"DAY_NUM" NUMBER, 
	"PERIOD" VARCHAR2(20), 
	"STATUS" VARCHAR2(20), 
	"LAST_MODIFIED_BY" VARCHAR2(30), 
	"LAST_MODIFIED_DATE" VARCHAR2(30)
   ) ;


  CREATE TABLE "WORKOUT_DAILYSPL_EXERC" 
   (	"DAILY_WORKOUT_ID" NUMBER, 
	"EX_SERIES_ID" NUMBER, 
	"EX_SERIES_NUMBER" NUMBER, 
	"LAST_MODIFIED_BY" VARCHAR2(30), 
	"LAST_MODIFIED_DATE" VARCHAR2(30), 
	"STATUS" VARCHAR2(20)
   ) ;


  CREATE TABLE "EXERCISE" 
   (	"ID" NUMBER, 
	"DIFFICULTY" VARCHAR2(20), 
	"VIDEO" VARCHAR2(200), 
	"PICTURE" VARCHAR2(200), 
	"DESCRIPTION" VARCHAR2(200), 
	"NAME" VARCHAR2(200), 
	"STATUS" VARCHAR2(20), 
	"LAST_MODIFIED_BY" VARCHAR2(30), 
	"LAST_MODIFIED_DATE" VARCHAR2(30)
   ) ;


  CREATE TABLE "LOG" 
   (	"EVENT_OWNER" VARCHAR2(30), 
	"OBJECT_NAME" VARCHAR2(40), 
	"OBJECT_TYPE" VARCHAR2(30), 
	"OPERATION" VARCHAR2(30), 
	"EVENT_DATE" VARCHAR2(30)
   ) ;


  CREATE TABLE "WORK_DAILY_SPLT" 
   (	"ID" NUMBER, 
	"DAY_PART" VARCHAR2(20), 
	"TIME" VARCHAR2(20), 
	"NAME" VARCHAR2(200), 
	"STATUS" VARCHAR2(20), 
	"LAST_MODIFIED_BY" VARCHAR2(30), 
	"LAST_MODIFIED_DATE" VARCHAR2(30), 
	"DAY_NUM" NUMBER
   ) ;


  CREATE TABLE "WORKOUT_DSPLIT" 
   (	"SPLIT_ID" NUMBER, 
	"WORKOUT_ID" NUMBER, 
	"DAY_NUMBER" NUMBER, 
	"LAST_MODIFIED_BY" VARCHAR2(30), 
	"LAST_MODIFIED_DATE" VARCHAR2(30), 
	"STATUS" VARCHAR2(20)
   );