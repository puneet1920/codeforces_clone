-- ORGANIZATION TABLE
CREATE TABLE ORGANIZATION (
    ID NUMBER,
    NAME VARCHAR2(100) NOT NULL,

    CONSTRAINT ORG_PK PRIMARY KEY(ID),
    CONSTRAINT ORG_NAME_U UNIQUE(NAME)
);

-- COUNTRY TABLE
CREATE TABLE COUNTRY (
    ID NUMBER,
    NAME VARCHAR2(50) NOT NULL,

    CONSTRAINT CNTRY_PK PRIMARY KEY(ID),
    CONSTRAINT CNTRY_NAME_U UNIQUE(NAME)
);

-- CITY TABLE
CREATE TABLE CITY (
    ID NUMBER,
    COUNTRY_ID NUMBER NOT NULL,
    NAME VARCHAR2(50) NOT NULL,

    CONSTRAINT CITY_PK PRIMARY KEY(ID, COUNTRY_ID),
    CONSTRAINT CITY_CNTRY_FK FOREIGN KEY(COUNTRY_ID) REFERENCES COUNTRY(ID) ON DELETE CASCADE
);

-- PROGRAMMING LANGUAGE TABLE
CREATE TABLE LANGUAGE (
    ID NUMBER,
    NAME VARCHAR2(50) NOT NULL,
    COMMAND VARCHAR2(200) NOT NULL,

    CONSTRAINT LANG_PK PRIMARY KEY (ID),
    CONSTRAINT LANG_NAME_U UNIQUE(NAME)
);

-- PROBLEM/BLOG TAG TABLE
CREATE TABLE TAG (
    ID NUMBER,
    NAME VARCHAR2(50) NOT NULL,
    TYPE VARCHAR2(20) NOT NULL,

    CONSTRAINT TAG_PK PRIMARY KEY (ID),
    CONSTRAINT TAG_NAME_U UNIQUE(NAME, TYPE),
    CONSTRAINT TAG_TYPE_CHK CHECK(TYPE IN ('BLOG', 'PROBLEM'))
);

-- RANK TABLE
CREATE TABLE RANK (
    ID NUMBER,
    NAME VARCHAR2(50) NOT NULL,
    COLOR VARCHAR2(50) NOT NULL,
    MIN_RATING NUMBER,
    MAX_RATING NUMBER,

    CONSTRAINT RANK_PK PRIMARY KEY (ID),
    CONSTRAINT RANK_NAME_U UNIQUE(NAME),
    CONSTRAINT RANK_RATING_CHK CHECK((MIN_RATING IS NULL AND MAX_RATING IS NULL) OR (MIN_RATING <= MAX_RATING))
);

-- CONTESTANT TABLE - GENERALIZATION OF USER/TEAM
CREATE TABLE CONTESTANT (
    ID NUMBER,
    TYPE VARCHAR2(20) NOT NULL,
    HANDLE VARCHAR2(100) NOT NULL,
    CREATION_TIME DATE DEFAULT(SYSDATE) NOT NULL,

    CONSTRAINT CNTSTNT_PK PRIMARY KEY(ID),
    CONSTRAINT CNTSTNT_TYPE_CHK CHECK(TYPE IN ('TEAM', 'USER')),
    CONSTRAINT CNTSTNT_HANDLE_U UNIQUE(HANDLE)
);

-- TEAM TABLE
CREATE TABLE TEAM (
    ID NUMBER,
    DESCRIPTION VARCHAR2(500),

    CONSTRAINT TEAM_PK PRIMARY KEY(ID),
    CONSTRAINT TEAM_CNTSTNT_FK FOREIGN KEY(ID) REFERENCES CONTESTANT(ID)
);

-- USER TABLE
CREATE TABLE USER_ACCOUNT (
    ID NUMBER,
    FIRST_NAME VARCHAR2(50),
    LAST_NAME VARCHAR2(50),
    PASSWORD VARCHAR2(200) NOT NULL,
    EMAIL VARCHAR2(200) NOT NULL,
    RATING NUMBER DEFAULT(0),
    RANK_ID NUMBER NOT NULL,
    LOGIN_TIME DATE DEFAULT(SYSDATE) NOT NULL,
    PICTURE VARCHAR2(200),
    DATE_OF_BIRTH DATE NOT NULL,
    ORG_ID NUMBER,
    COUNTRY_ID NUMBER,
    CITY_ID NUMBER,
    LOGIN_TOKEN VARCHAR2(500),

    CONSTRAINT USER_PK PRIMARY KEY (ID),
    CONSTRAINT USER_EMAIL_U UNIQUE(EMAIL),
    CONSTRAINT USER_RATING_CHK CHECK(NVL(RATING, 0) >= 0),
    CONSTRAINT USER_RANK_FK FOREIGN KEY(RANK_ID) REFERENCES RANK(ID),
    CONSTRAINT USER_ORG_FK FOREIGN KEY(ORG_ID) REFERENCES ORGANIZATION(ID),
    CONSTRAINT USER_CNTRY_FK FOREIGN KEY(COUNTRY_ID) REFERENCES COUNTRY(ID) ON DELETE SET NULL,
    CONSTRAINT USER_CITY_FK FOREIGN KEY(CITY_ID, COUNTRY_ID) REFERENCES CITY(ID, COUNTRY_ID) ON DELETE SET NULL,
    CONSTRAINT USER_CITY_CHK CHECK(CITY_ID IS NULL OR COUNTRY_ID IS NOT NULL)
);

-- MESSAGE TABLE (USER TO USER)
CREATE TABLE MESSAGE (
    ID NUMBER,
    BODY VARCHAR2(500) NOT NULL,
    TIME_SENT DATE NOT NULL,
    TIME_READ DATE,
    FROM_USER_ID NUMBER NOT NULL,
    TO_USER_ID NUMBER NOT NULL,

    CONSTRAINT MSG_PK PRIMARY KEY (ID),
    CONSTRAINT MSG_FROM_FK FOREIGN KEY(FROM_USER_ID) REFERENCES USER_ACCOUNT(ID),
    CONSTRAINT MSG_TO_FK FOREIGN KEY(TO_USER_ID) REFERENCES USER_ACCOUNT(ID)
);

-- CONTEST TABLE
CREATE TABLE CONTEST (
    ID NUMBER,
    NAME VARCHAR2(50) NOT NULL,
    TIME_START DATE NOT NULL,
    DURATION NUMBER NOT NULL,
    MIN_RATED NUMBER,
    MAX_RATED NUMBER,

    CONSTRAINT CNTST_PK PRIMARY KEY(ID),
    CONSTRAINT CNTST_NAME_U UNIQUE(NAME),
    CONSTRAINT CNTST_RATED_CHK CHECK((MIN_RATED IS NULL AND MAX_RATED IS NULL) OR MIN_RATED <= MAX_RATED),
    CONSTRAINT CNTST_DURATION_CHK CHECK(DURATION > 0)
);

-- BLOGS TABLE (MADE BY USER)
CREATE TABLE BLOG_POST (
    ID NUMBER,
    TITLE VARCHAR2(50) NOT NULL,
    BODY VARCHAR2(4000) NOT NULL,
    CREATION_TIME DATE DEFAULT(SYSDATE) NOT NULL,
    CONTEST_ID NUMBER,
    AUTHOR_ID NUMBER NOT NULL,

    CONSTRAINT BLOG_PK PRIMARY KEY (ID),
    CONSTRAINT BLOG_CNTST_FK FOREIGN KEY(CONTEST_ID) REFERENCES CONTEST(ID),
    CONSTRAINT BLOG_USER_FK FOREIGN KEY(CONTEST_ID) REFERENCES USER_ACCOUNT(ID)
);

-- COMMENT TABLE (COMMENT ON BLOGS)
CREATE TABLE POST_COMMENT (
    ID NUMBER,
    BODY VARCHAR2(500) NOT NULL,
    CREATION_TIME DATE DEFAULT(SYSDATE) NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    BLOG_ID NUMBER NOT NULL,
    PARENT_ID NUMBER,

    CONSTRAINT CMMNT_PK PRIMARY KEY(ID),
    CONSTRAINT CMMNT_USER_FK FOREIGN KEY(AUTHOR_ID) REFERENCES USER_ACCOUNT(ID),
    CONSTRAINT CMMNT_BLOG_FK FOREIGN KEY(BLOG_ID) REFERENCES BLOG_POST(ID),
    CONSTRAINT CMMNT_CMMNT_FK FOREIGN KEY(PARENT_ID) REFERENCES POST_COMMENT(ID)
);

-- PROBLEM TABLE
CREATE TABLE PROBLEM (
    ID NUMBER,
    NAME VARCHAR2(100) NOT NULL,
    PROB_NUM NUMBER NOT NULL,
    CONTEST_ID NUMBER NOT NULL,
    BODY VARCHAR2(1000) NOT NULL,
    SOURCE_LIMIT NUMBER NOT NULL,
    TIME_LIMIT NUMBER NOT NULL,
    MEMORY_LIMIT NUMBER NOT NULL,
    RATING NUMBER NOT NULL,

    CONSTRAINT PRBLM_PK PRIMARY KEY(ID),
    CONSTRAINT PRBLM_CNTST_FK FOREIGN KEY(CONTEST_ID) REFERENCES CONTEST(ID),
    CONSTRAINT PRBLM_LIMIT_CHK CHECK(SOURCE_LIMIT >= 512 AND TIME_LIMIT >= 500 AND MEMORY_LIMIT <= 512),
    CONSTRAINT PRBLM_RTNG_CHK CHECK(RATING >= 0),
    CONSTRAINT PRBLM_NUM_CHK CHECK(PROB_NUM >= 0)
);

-- TESTS TABLE (PROBLEM HAS TESTS)
CREATE TABLE TEST_FILE (
    ID NUMBER,
    PROBLEM_ID NUMBER NOT NULL,
    TEST_NUMBER NUMBER NOT NULL,
    TYPE VARCHAR2(20) NOT NULL,
    INPUT_URL VARCHAR2(100) NOT NULL,
    OUTPUT_URL VARCHAR2(100) NOT NULL,

    CONSTRAINT TEST_PK PRIMARY KEY(ID),
    CONSTRAINT TEST_PRBLM FOREIGN KEY(PROBLEM_ID) REFERENCES PROBLEM(ID),
    CONSTRAINT TEST_NUM_CHK CHECK(TEST_NUMBER >= 0),
    CONSTRAINT TEST_TYPE_CHK CHECK(TYPE IN ('MAIN', 'SAMPLE'))
);

-- SUBMISSION TABLE (CONTESTANTS SUBMIT TO PROBLEMS)
CREATE TABLE SUBMISSION (
    ID NUMBER,
    PROBLEM_ID NUMBER NOT NULL,
    AUTHOR_ID NUMBER NOT NULL,
    SUBMISSION_TIME DATE DEFAULT(SYSDATE) NOT NULL,
    JUDGE_TIME DATE,
    LANG_ID NUMBER NOT NULL,
    CODE_SIZE NUMBER NOT NULL,
    RESULT VARCHAR2(20),
    TYPE VARCHAR2(20),
    URL VARCHAR2(200),

    CONSTRAINT SBMSSN_PK PRIMARY KEY (ID),
    CONSTRAINT SBMSSN_PRBLM_FK FOREIGN KEY(PROBLEM_ID) REFERENCES PROBLEM(ID),
    CONSTRAINT SBMSSN_USER_FK FOREIGN KEY(AUTHOR_ID) REFERENCES CONTESTANT(ID),
    CONSTRAINT SBMSSN_LANG_FK FOREIGN KEY(LANG_ID) REFERENCES LANGUAGE(ID),
    CONSTRAINT SBMSSN_SZ_CHK CHECK(CODE_SIZE > 0),
    CONSTRAINT SBMSSN_RSLT_CHK CHECK(JUDGE_TIME IS NULL OR RESULT IN ('AC', 'TLE', 'MLE', 'WA', 'RTE', 'CE', 'SLE', 'JE')),
    CONSTRAINT SBMSSN_TYPE_CHK CHECK(TYPE IN ('ADMIN', 'CONTEST', 'REGULAR'))
);

-- FOLLOW TABLE (USER FOLLOWS USER)
CREATE TABLE USER_USER_FOLLOW (
    FOLLOWER_ID NUMBER,
    FOLLOWED_ID NUMBER,

    CONSTRAINT FOLLOW_PK PRIMARY KEY(FOLLOWER_ID, FOLLOWED_ID),
    CONSTRAINT FOLLOWER_PK FOREIGN KEY(FOLLOWER_ID) REFERENCES USER_ACCOUNT(ID),
    CONSTRAINT FOLLOWED_PK FOREIGN KEY(FOLLOWED_ID) REFERENCES USER_ACCOUNT(ID),
    CONSTRAINT FOLLOW_CHK CHECK(FOLLOWER_ID <> FOLLOWED_ID)
);

-- TEAM MEMBER TABLE (USER IS IN TEAMS)
CREATE TABLE USER_TEAM_MEMBER (
    USER_ID NUMBER,
    TEAM_ID NUMBER,
    TYPE VARCHAR2(20) NOT NULL,

    CONSTRAINT MEMBER_PK PRIMARY KEY(USER_ID, TEAM_ID),
    CONSTRAINT MEMBER_USER_FK FOREIGN KEY(USER_ID) REFERENCES USER_ACCOUNT(ID),
    CONSTRAINT MEMBER_TEAM_FK FOREIGN KEY(TEAM_ID) REFERENCES TEAM(ID),
    CONSTRAINT MEMBER_TYPE_CHK CHECK(TYPE IN ('CREATOR', 'MEMBER'))
);

-- VOTE ON BLOGS TABLE
CREATE TABLE BLOG_USER_VOTE (
    USER_ID NUMBER,
    BLOG_ID NUMBER,
    TYPE VARCHAR2(20) NOT NULL,

    CONSTRAINT BLOGVOTE_PK PRIMARY KEY(USER_ID, BLOG_ID),
    CONSTRAINT BLOGVOTE_USER_FK FOREIGN KEY(USER_ID) REFERENCES USER_ACCOUNT(ID),
    CONSTRAINT BLOGVOTE_BLOG_FK FOREIGN KEY(BLOG_ID) REFERENCES BLOG_POST(ID) ON DELETE CASCADE,
    CONSTRAINT BLOGVOTE_TYPE_CHK CHECK(TYPE IN ('UP', 'DOWN'))
);

-- ADMINISTRATING CONTESTS TABLE
CREATE TABLE USER_CONTEST_ADMIN (
    USER_ID NUMBER,
    CONTEST_ID NUMBER,
    TYPE VARCHAR2(20) NOT NULL,

    CONSTRAINT ADMIN_PK PRIMARY KEY(USER_ID, CONTEST_ID),
    CONSTRAINT ADMIN_USER_FK FOREIGN KEY(USER_ID) REFERENCES USER_ACCOUNT(ID),
    CONSTRAINT ADMIN_CNTST_FK FOREIGN KEY(CONTEST_ID) REFERENCES CONTEST(ID) ON DELETE CASCADE,
    CONSTRAINT ADMIN_TYPE_CHK CHECK(TYPE IN ('MAIN', 'REGULAR'))
);

-- REGISTRATION TO CONTEST TABLE
CREATE TABLE CONTEST_REGISTRATION (
    CONTESTANT_ID NUMBER,
    CONTEST_ID NUMBER,
    STANDING NUMBER,
    RATING_CHANGE NUMBER,

    CONSTRAINT REG_PK PRIMARY KEY(CONTESTANT_ID, CONTEST_ID),
    CONSTRAINT REG_CNTSTNT_FK FOREIGN KEY(CONTESTANT_ID) REFERENCES CONTESTANT(ID),
    CONSTRAINT REG_CNTST_FK FOREIGN KEY(CONTEST_ID) REFERENCES CONTEST(ID) ON DELETE CASCADE,
    CONSTRAINT REG_RESULT_CHK CHECK(STANDING IS NULL OR STANDING > 0)
);

-- VOTE ON COMMENTS TABLE
CREATE TABLE COMMENT_USER_VOTE (
    USER_ID NUMBER,
    COMMENT_ID NUMBER,
    TYPE VARCHAR2(20) NOT NULL,

    CONSTRAINT CMNTVOTE_PK PRIMARY KEY(USER_ID, COMMENT_ID),
    CONSTRAINT CMNTVOTE_USER_FK FOREIGN KEY(USER_ID) REFERENCES USER_ACCOUNT(ID),
    CONSTRAINT CMNTVOTE_CMNT_FK FOREIGN KEY(COMMENT_ID) REFERENCES POST_COMMENT(ID),
    CONSTRAINT CMNTVOTE_TYPE_CHK CHECK(TYPE IN ('UP', 'DOWN'))
);

-- BLOG TAG TABLE
CREATE TABLE BLOG_TAG (
    BLOG_ID NUMBER,
    TAG_ID NUMBER,

    CONSTRAINT BLOGTAG_PK PRIMARY KEY(BLOG_ID, TAG_ID),
    CONSTRAINT BLOGTAG_BLOG_FK FOREIGN KEY(BLOG_ID) REFERENCES BLOG_POST(ID) ON DELETE CASCADE,
    CONSTRAINT BLOGTAG_TAG_FK FOREIGN KEY(TAG_ID) REFERENCES TAG(ID)
);

-- CONTEST ANNOUNCEMENT TABLE
CREATE TABLE CONTEST_ANNOUNCEMENTS (
    ID NUMBER,
    CONTEST_ID NUMBER,
    BODY VARCHAR2(500) NOT NULL,
    CREATION_TIME DATE DEFAULT(SYSDATE) NOT NULL,

    CONSTRAINT ANNCMNT_PK PRIMARY KEY(ID, CONTEST_ID),
    CONSTRAINT ANNCMNT_CNTST_FK FOREIGN KEY(CONTEST_ID) REFERENCES CONTEST(ID)
);

-- PROBLEM TAG TABLE
CREATE TABLE PROBLEM_TAG (
    PROBLEM_ID NUMBER,
    TAG_ID NUMBER,

    CONSTRAINT PRBLMTAG_PK PRIMARY KEY (PROBLEM_ID, TAG_ID),
    CONSTRAINT PRBLMTAG_PRBLM_ID FOREIGN KEY(PROBLEM_ID) REFERENCES PROBLEM(ID),
    CONSTRAINT PRBLMTAG_TAG_ID FOREIGN KEY(TAG_ID) REFERENCES TAG(ID)
);

-- SUBMISSION RUN ON TESTS TABLE (SUBMISSION RUNS ON EACH TEST OF PROBLEM)
CREATE TABLE SUBMISSION_TEST_RUN (
    SUBMISSION_ID NUMBER,
    TEST_ID NUMBER,
    RESULT VARCHAR2(20) NOT NULL,
    RUNTIME NUMBER NOT NULL, 
    MEMORY NUMBER NOT NULL,

    CONSTRAINT RUN_PK PRIMARY KEY(SUBMISSION_ID, TEST_ID),
    CONSTRAINT RUN_SBMSSN_FK FOREIGN KEY(SUBMISSION_ID) REFERENCES SUBMISSION(ID),
    CONSTRAINT RUN_TEST_FK FOREIGN KEY(TEST_ID) REFERENCES TEST_FILE(ID),
    CONSTRAINT RUN_RES_CHK CHECK(RESULT IN ('AC', 'TLE', 'MLE', 'WA', 'RTE', 'JE')),
    CONSTRAINT RUN_LIM_CHK CHECK(MEMORY > 0 AND RUNTIME > 0)
);

-- TODO add trigger