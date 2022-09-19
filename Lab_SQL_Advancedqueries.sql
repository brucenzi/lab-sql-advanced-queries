use sakila;

-- 1. List each pair of actors that have worked together.

select * from actor;
select * from film_actor;
  
select f2.film_id, f1.actor_id, f2.actor_id from film_actor f1
join film_actor f2
on f1.film_id = f2.film_id
group by f1.actor_id
having f1.actor_id != f2.actor_id
order by f2.film_id;


-- 2. For each film, list actor that has acted in more films.

select * from film_actor;

-- first query: number of films per actor
select actor_id, count(film_id) q_films
from film_actor 
group by actor_id;

-- final query: rank actors per number of films partition by film, join first query and filter final table where ranking is 1
   with cte1 as (
	select actor_id, count(film_id) q_films
	from film_actor 
	group by actor_id
    ),
    cte2 as (
    select f.film_id, f.actor_id, c.q_films, rank() over(partition by f.film_id order by c.q_films desc, f.actor_id) as ranking from film_actor f
    join cte1 c on c.actor_id = f.actor_id
    )
    select film_id, actor_id from cte2
    where ranking = 1;