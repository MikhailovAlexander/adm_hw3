import pyodbc
import random
from mimesis.providers import Person, Address, Datetime

from constants import *


def main():
    connection = pyodbc.connect(CONN_STRING, autocommit=True)
    cursor = connection.cursor()
    try:
        __init_db(cursor)
        __insert_groups(cursor)
        __insert_employees(cursor)
        __fill_groups(cursor)
        __insert_workouts(cursor)
        __insert_workout_visits(cursor)
    except Exception as ex:
        print(ex)
    finally:
        cursor.close()
        connection.close()


def __init_db(cursor):
    with open(DB_INIT_SCRIPT_PATH, 'r') as init_file:
        init_script = init_file.read()
    cursor.execute(init_script)
    for view_path in VIEWS:
        with open(view_path, 'r') as view_file:
            view_script = view_file.read()
        cursor.execute(view_script)
    for proc_path in PROCEDURES:
        with open(proc_path, 'r') as proc_file:
            proc_script = proc_file.read()
        cursor.execute(proc_script)
    for func_path in FUNCTIONS:
        with open(func_path, 'r') as func_file:
            func_script = func_file.read()
        cursor.execute(func_script)


def __insert_groups(cursor):
    cursor.execute(SELECT_SPORTS_QUERY)
    sports = cursor.fetchall()
    postfixes = ['-2023-1', '-2023-2']
    groups = []
    for sport_row in sports:
        for postfix in postfixes:
            groups.append((sport_row[1] + postfix, START_DATE, sport_row[0]))
    cursor.executemany(INSERT_GROUPS_QUERY, groups)


def __insert_employees(cursor):
    cursor.execute(SELECT_PROFS_QUERY)
    for prof_row in cursor.fetchall():
        if prof_row[1] == 'Coach':
            cursor.execute(SELECT_SPORTS_QUERY)
            for sport_row in cursor.fetchall():
                sport_id = sport_row[0]
                data = __gen_person_data(is_adult=True)
                data.append(START_DATE)
                data.append(prof_row[0])
                cursor.execute(INSERT_EMPLOYEE_QUERY, data)
                employee_id = cursor.fetchone()[0]
                cursor.execute(SELECT_GROUPS_BY_SPORT_QUERY, sport_id)
                for group_row in cursor.fetchall():
                    group_id = group_row[0]
                    data = (START_DATE, employee_id, group_id)
                    cursor.execute(INSERT_COACH_QUERY, data)
        else:
            employee_cnt = 1 if prof_row[1] == 'Director' else 3
            for _ in range(employee_cnt):
                data = __gen_person_data(is_adult=True)
                data.append(START_DATE)
                data.append(prof_row[0])
                cursor.execute(INSERT_EMPLOYEE_QUERY, data)


def __fill_groups(cursor):
    contract_number = 1
    cursor.execute(SELECT_GROUPS_QUERY)
    for group_row in cursor.fetchall():
        group_id = group_row[0]
        for _ in range(random.randint(15, 20)):
            parent_child_link_id = __insert_child_with_person(cursor)
            data = (contract_number, START_DATE, PRICE, parent_child_link_id,
                    group_id)
            cursor.execute(INSERT_CONTRACT_QUERY, data)


def __insert_workouts(cursor):
    cursor.execute(SELECT_SPORTS_QUERY)
    workouts_data = []
    for num, sport_row in enumerate(cursor.fetchall()):
        sport_id = sport_row[0]
        start_dt = (datetime.datetime(year=START_DATE.year,
                                      month=START_DATE.month,
                                      day=START_DATE.day) +
                    datetime.timedelta(days=num) +
                    datetime.timedelta(hours=9))
        cursor.execute(SELECT_GROUPS_BY_SPORT_QUERY, sport_id)
        for gr_num, group_row in enumerate(cursor.fetchall()):
            group_id = group_row[0]
            workout_dt = start_dt + datetime.timedelta(hours=4*gr_num)
            while workout_dt < datetime.datetime.now():
                workouts_data.append((workout_dt, group_id))
                workout_dt += datetime.timedelta(days=7)
    cursor.executemany(INSERT_WORKOUT_QUERY, workouts_data)


def __insert_workout_visits(cursor):
    cursor.execute(SELECT_WORKOUTS_QUERY)
    visit_data = []
    for workout_row in cursor.fetchall():
        workout_id = workout_row[0]
        group_id = workout_row[1]
        cursor.execute(SELECT_CHILD_BY_GROUP_QUERY, group_id)
        for child_row in cursor.fetchall():
            if random.random() < WORKOUT_VISIT_PROBABILITY:
                child_id = child_row[0]
                visit_data.append((workout_id, child_id))
    cursor.executemany(INSERT_WORKOUT_CHILD_QUERY, visit_data)


def __gen_person_data(is_adult=False, with_school_number=False,
                      with_occupation=False):
    person = Person('en')
    address = Address()
    dt = Datetime()
    start_year = YEAR - (60 if is_adult else 18)
    end_year = YEAR - (18 if is_adult else 7)
    new_gender = random.choice([1, 2])
    new_person = [person.full_name(GENDER_DICT[new_gender]), address.address(),
                  new_gender, dt.date(start_year, end_year)]
    if with_school_number:
        new_person.append(random.randint(1, 100))
    if with_occupation:
        new_person.append(person.occupation())
    return new_person


def __insert_child_with_person(cursor):
    data = __gen_person_data(with_school_number=True)
    data += __gen_person_data(is_adult=True, with_occupation=True)
    cursor.execute(INSERT_CHILD_WITH_PARENT_QUERY, data)
    parent_child_link_id = cursor.fetchone()[0]
    return parent_child_link_id


if __name__ == "__main__":
    main()
