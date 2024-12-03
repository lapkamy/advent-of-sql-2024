with 
--таблица с блюдами
dishes as 
(sELECT x.id, 1 as num, food_item_id
    FROM christmas_menus x,
            XMLTABLE('polar_celebration/event_administration/culinary_records/menu_analysis/item_performance'
              PASSING menu_data
              COLUMNS 
                food_item_id     		int4  PATH 'food_item_id')
union all          
sELECT x.id, 2 as num, food_item_id
    FROM christmas_menus x,
            XMLTABLE('christmas_feast/organizational_details/menu_registry/course_details/dish_entry'
              PASSING menu_data
              COLUMNS 
                food_item_id     		int4  PATH 'food_item_id')
union all
sELECT x.id, 3 as num, food_item_id
    FROM christmas_menus x,
            XMLTABLE('northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish'
              PASSING menu_data
              COLUMNS 
                food_item_id     		int4  PATH 'food_item_id'))
                
 --таблица с мероприятиями               
, events as 
(select 
case when (xpath('polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', menu_data))[1]::text is not null then 1 
	 when (xpath('christmas_feast/organizational_details/attendance_record/total_guests/text()', menu_data))[1]::text is not null then 2
	 when (xpath('northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data))[1]::text is not null then 3
	 end as num, 
coalesce(
(xpath('polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', menu_data))[1]::text,
(xpath('christmas_feast/organizational_details/attendance_record/total_guests/text()', menu_data))[1]::text,
(xpath('northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data))[1]::text
) as cnt_people
from christmas_menus)

select food_item_id, count(*)
from events e 
join dishes d on d.num = e.num and e.cnt_people::int8 > 78
group by food_item_id
order by count(*) desc
