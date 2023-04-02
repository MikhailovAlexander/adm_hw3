import os
import datetime
from mimesis.enums import Gender

__host = os.environ['PGHOST']
__db = os.environ['POSTGRES_DB']
__user = os.environ['POSTGRES_USER']
__pwd = os.environ['POSTGRES_PASSWORD']
CONN_STRING = f'Driver={{PostgreSQL Unicode}};Server={__host};Port=5432;' \
              f'Database={__db};Uid={__user};Pwd={__pwd};'
DB_INIT_SCRIPT_PATH = 'db/init.sql'
VIEWS = ['db/views/v_child_with_parents.sql']
PROCEDURES = ['db/procedures/add_employee.sql',
              'db/procedures/add_child.sql',
              'db/procedures/add_parent.sql',
              'db/procedures/add_child_with_parent.sql']
FUNCTIONS = ['db/functions/get_child_by_group.sql',
             'db/functions/get_tables_row_count.sql']

SELECT_SPORTS_QUERY = 'SELECT sport_id, name FROM public.sport'
SELECT_PROFS_QUERY = 'SELECT profession_id, name FROM public.profession'
SELECT_GROUPS_QUERY = 'SELECT group_id FROM public.group'
SELECT_GROUPS_BY_SPORT_QUERY = 'SELECT group_id FROM public.group ' \
                               'WHERE sport_id = ?'
SELECT_WORKOUTS_QUERY = 'SELECT workout_id, group_id from public.workout'
SELECT_CHILD_BY_GROUP_QUERY = 'SELECT child_id ' \
                              'FROM public.get_child_by_group(?)'
INSERT_GROUPS_QUERY = 'INSERT INTO public.group(name, active_from, sport_id) ' \
                      'VALUES (?, ?, ?);'
INSERT_EMPLOYEE_QUERY = 'CALL public.add_employee(?, ?, ?, ?, ?, ?, NULL);'
INSERT_COACH_QUERY = 'INSERT INTO public.coach(active_from, employee_id, ' \
                     'group_id) VALUES (?, ?, ?);'
INSERT_CHILD_WITH_PARENT_QUERY = 'CALL public.add_child_with_parent(' \
                                 '?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NULL)'
INSERT_CONTRACT_QUERY = 'INSERT INTO public.contract("number", active_from, ' \
                        'price, parent_child_link_id, group_id) ' \
                        'VALUES (?, ?, ?, ?, ?);'
INSERT_WORKOUT_QUERY = 'INSERT INTO public.workout(datetime, group_id) ' \
                       'VALUES (?, ?);'
INSERT_WORKOUT_CHILD_QUERY = 'INSERT INTO public.workout_child_link(' \
                             'workout_id, child_id) VALUES (?, ?);'

GENDER_DICT = {1: Gender.MALE, 2: Gender.FEMALE}
YEAR = datetime.datetime.now().year
START_DATE = datetime.date(YEAR, 1, 1)
PRICE = 500
WORKOUT_VISIT_PROBABILITY = 0.9
