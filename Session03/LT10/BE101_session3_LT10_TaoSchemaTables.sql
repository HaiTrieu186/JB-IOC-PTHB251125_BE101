CREATE database CompanyDB;

create schema if not exists company;
set search_path to company;

CREATE TYPE role_enum AS ENUM ('member', 'manager', 'viewer');

create table if not exists Employees
(
    emp_id        serial,
    name          varchar(50) not null,
    dob           date,
    department_id int,
    constraint pk_Employees primary key (emp_id),
    constraint fk_Employees foreign key (department_id) references Departments (department_id)
);
create table if not exists Departments
(
    department_id   serial,
    department_name varchar(50) not null,
    constraint pk_Departments primary key (department_id)
);
create table if not exists Projects
(
    project_id   serial,
    project_name varchar(100) not null,
    start_date   date         not null default now(),
    end_date     date         not null,
    manager_id   int,
    constraint pk_Projects primary key (project_id),
    constraint fk_Projects foreign key (manager_id) references Employees (emp_id),
    constraint check_date check ( end_date > start_date )
);
create table if not exists EmployeeProjects
(
    emp_id     int,
    project_id int,
    role       role_enum not null default 'member',
    constraint pk_EmployeeProjects primary key (emp_id, project_id),
    constraint fk1_EmployeeProjects foreign key (emp_id) references Employees (emp_id),
    constraint fk2_EmployeeProjects foreign key (project_id) references Projects (project_id)
);
