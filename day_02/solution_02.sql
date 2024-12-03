select distinct value, chr(value)
from  letters_a
where chr(value) ~* '^[A-Z]*$' or chr(value) like ' ' or chr(value) like ',' or chr(value) like '!'

union all 

with letter as 
(select id, value, chr(value) as ch
from letters_b
where chr(value) ~* '^[A-Z]*$' or chr(value) like ' ' or chr(value) like ',' or chr(value) like '!')
select string_agg(ch,'')
from letter