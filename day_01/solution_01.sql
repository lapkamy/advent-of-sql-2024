with que as 
(select c.child_id, 
w.submitted_date,
c."name" as name,
w.wishes->>'first_choice' as primary_wish,
w.wishes->>'second_choice' as backup_wish,
w.wishes#>>'{colors,0}' as favorite_color,
json_array_length(w.wishes->'colors') as color_count,
case when t.difficulty_to_make = 1 then 'Simple Gift'
	when t.difficulty_to_make = 2 then 'Moderate Gift' 
	else 'Complex Gift' end as gift_complexity,
case when   t.category = 'outdoor' then 'Outside Workshop'
  	when t.category = 'educational' then 'Learning Workshop'
  	else 'General Workshop' end as workshop_assignment
from wish_lists w 
join children c on w.child_id = c.child_id 
join toy_catalogue t on t.toy_name = w.wishes->>'first_choice'
order by c."name" 
limit 5
)

select "name" ||','||
primary_wish  ||','||
backup_wish ||','||
favorite_color ||','||
color_count ||','||
gift_complexity ||','||
workshop_assignment
from que

