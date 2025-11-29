Create database SchoolDB;

CREATE schema if not exists school;
set search_path to school;

Create table if not exists Students
(
    student_id serial,
    name       varchar(100) not null,
    dob        date,
    constraint pk_Students primary key (student_id)
);
Create table if not exists Courses
(
    course_id   serial,
    course_name varchar(100) not null,
    credits     int          not null,
    constraint pk_Courses primary key (course_id),
    constraint check_Credits check ( credits > 0 )
);
Create table if not exists Enrollments
(
    enrollment_id serial,
    course_id     int,
    student_id    int,
    grade         varchar(2),
    constraint pk_Enrollments primary key (enrollment_id),
    constraint fk1_Enrollments foreign key (course_id) references Courses (course_id),
    constraint fk2_Enrollments foreign key (student_id) references Students (student_id),
    constraint check_grade check ( grade in ('A', 'B', 'C', 'D', 'F') )
);