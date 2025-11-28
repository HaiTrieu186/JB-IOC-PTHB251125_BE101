CREATE  schema  if not exists elearning;

set search_path  to elearning;

create table if not exists Students(
    student_id serial,
    first_name varchar(50) not null ,
    last_name varchar(50) not null ,
    email text not null  unique,
    constraint pk_Students primary key (student_id)
);

create table if not exists Instructors(
    instructor_id serial,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(50) not null  unique,
    constraint pk_Instructors primary key (instructor_id)
);

create table if not exists Courses (
    course_id serial,
    course_name varchar(100) not null,
    instructor_id int,
    constraint pk_Courses primary key (course_id),
    constraint fk_Courses foreign key (instructor_id) references Instructors(instructor_id)
);

create table if not exists Enrollments (
    enrollment_id serial,
    enroll_date date not null  default now(),
    student_id int,
    course_id int,
    constraint pk_Enrollments primary key (enrollment_id),
    constraint fk1_Enrollments foreign key (student_id) references Students(student_id),
    constraint fk2_Enrollments foreign key (course_id) references Courses(course_id)
);

create table if not exists Assignments(
    assignment_id serial,
    title varchar(100) not null ,
    due_date date not null ,
    course_id int,
    constraint pk_Assignments primary key (assignment_id),
    constraint fk_Assignments foreign key (course_id) references Courses(course_id),
    constraint  check_due_date check ( due_date>= now() )
);

create table if not exists Submissions(
    submission_id serial,
    submission_date date not null default now(),
    grade float not null,
    student_id int,
    assignments_id int,
    constraint pk_Submissions primary key (submission_id),
    constraint fk1_Submissions foreign key (student_id) references Students(student_id),
    constraint fk2_Submissions foreign key (assignments_id) references Assignments(assignment_id),
    constraint check_grade check ( grade>=0 AND grade<=100 )
);