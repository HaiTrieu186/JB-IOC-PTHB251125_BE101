CREATE SCHEMA if not exists  university;

set search_path to university;


CREATE TABLE if not exists Students(
  student_id serial,
  first_name varchar(50) not null,
  last_name varchar(50) not null,
  birth_date date,
  email text not null  unique,
  constraint pk_student primary key (student_id),
  constraint  checkDOB check(birth_date < now())
);


CREATE TABLE if not exists  Courses(
    course_id serial,
    course_name varchar(100) not null,
    credits int,
    constraint pk_course primary key (course_id),
    constraint checkCredits check (credits >0)
);

create  table  if not exists  Enrollments (
    enrollment_id serial,
    student_id int,
    course_id int,
    enroll_date date default  now(),
    constraint pk_enrollment primary key (enrollment_id),
    constraint fk1_enrollment foreign key(student_id) references Students(student_id),
    constraint fk2_enrollment foreign key(course_id) references  Courses(course_id)
);
