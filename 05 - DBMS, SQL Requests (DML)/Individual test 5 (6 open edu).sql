-- Определите количество остановок, которые попадают в область со следующими границами:
-- широта в интервале — [59.945, 59.99], долгота — [30.26, 30.32].

select count(id_stop)
from stops
where (latitude between 59.945 and 59.99)
and (longitude between 30.26 and 30.32)

-- Напишите запрос к базе Общественный транспорт и определите, по какому маршруту ездил АВТОБУС с бортовым номером 3788?

select t.route_number, t.carrier_board_num, v.id_vehicle, v.vehicle_name
from track t, vehicle v
where v.id_vehicle = t.id_vehicle
and t.carrier_board_num = 3788
and v.vehicle_name = 'АВТОБУС'

-- Напишите запрос к базе Общественный транспорт и определите, сколько единиц общественного транспорта
-- (с различными бортовыми номерами) работали на 14 маршруте (вид транспорта — АВТОБУС)?

select count(distinct t.carrier_board_num)
from track t, vehicle v
where t.id_vehicle = v.id_vehicle
and t.route_number = 14
and v.vehicle_name = 'АВТОБУС'

-- Напишите запрос к базе Общественный транспорт и определите,
-- какое максимальное расстояние между соседними остановками на маршруте ТРОЛЛЕЙБУСА номер 11?

select max(rbs.distance_back)
from route_by_stops rbs, vehicle v
where rbs.id_vehicle = v.id_vehicle
and v.vehicle_name = 'ТРОЛЛЕЙБУС'
and rbs.route_number = 11

-- Какое расстояние на автобусном маршруте 10 в прямом направлении связывает 7 и 13 остановку?

select sum(distance_back)
from (select rbs.stop_number, rbs.distance_back
	from route_by_stops rbs, vehicle v, direction d
	where rbs.id_vehicle = v.id_vehicle and rbs.id_direction = d.id_direction
	and rbs.route_number = 10 and v.vehicle_name = 'АВТОБУС' and d.direction_type = 'ПРЯМОЕ'
	order by stop_number
	) ROUTE10_BUS_DIRECT
where stop_number between 8 and 13

-- Напишите запрос к базе Общественный транспорт и
-- определите долготу и широту 12-й остановки на ОБРАТНОМ направлении маршрута АВТОБУСА номер 191.

select latitude, longitude
from stops
where id_stop =
	(select id_stop
	from route_by_stops
	where id_vehicle =
		(select id_vehicle
		from vehicle
		where vehicle_name = 'АВТОБУС')
	and id_direction =
		(select id_direction
		from direction
		where direction_type = 'ОБРАТНОЕ')
	and route_number = 191
	and stop_number = 12)

-- Напишите запрос к базе Общественный транспорт и
-- определите НОМЕРА АВТОБУСНЫХ маршрутов,
-- длина которых в ОБРАТНОМ направлении попадает в интервал [13550, 18900].

select *
from
	(select route_number, sum(distance_back) as distance
	from route_by_stops
	where id_vehicle =
		(select id_vehicle
		from vehicle
		where vehicle_name = 'АВТОБУС')
	and id_direction =
		(select id_direction
		from direction
		where direction_type = 'ОБРАТНОЕ')
	--and stop_number > 1
	group by route_number) as ROUTE_DISTANCE
where distance between 13500 and 18900
order by distance
