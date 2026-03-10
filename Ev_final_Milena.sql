-- Ej. Evaluacion Final --

-- 1- Selecciona todos los nombres de las películas sin que aparezcan duplicados

USE sakila;

SELECT DISTINCT title
	 FROM film;

-- 2 -  Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT *
	FROM film
	WHERE rating = "PG-13";

-- 3 - Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripcion.

SELECT title, description
	FROM film
	WHERE description LIKE "%amazing%";

-- 4 - Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT *  -- selecciono con * para que se vean todos los registros, aunque tambien podria poner unicamente "Title" para mostrar solo el resultado solicitado --
	FROM film
	WHERE length > 120;

-- 5 - Recupera los nombres de todos los actores.

SELECT first_name, last_name
	FROM actor;

-- 6 - Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
	FROM actor
	WHERE last_name = "Gibson";

-- 7 - Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name, last_name, actor_id
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20;

-- 8 -Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title, rating
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');

-- 9 - Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificacion junto con el recuento.

SELECT rating, COUNT(film_id) AS total_pelis
FROM film
GROUP BY rating;

-- 10  Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de peliculas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS Total_pelis_rent
	FROM customer AS c
    INNER JOIN rental AS r -- aqui hago inner join para unir las tablas customer con rental -- 
    ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name; -- agrupo por los criterios solicitados --
    
    
-- 11 - Encuentra la cantidad de peliculas alquiladas por categoria y muestra el nombre de la categoria junto con el recuento de alquileres.

SELECT c.name AS categoría_peli, 
	COUNT(r. rental_id) AS total_rent -- cuento los alquileres 
	FROM rental AS r
	INNER JOIN inventory AS i     -- join de la tabla rental con inventory (inventory_id) 
		ON r.inventory_id = i.inventory_id
	INNER JOIN film AS f 		-- join inventory con film (film_id)
		ON i.film_id = f.film_id
	INNER JOIN film_category AS fc   -- a su vez las conecto con la tabla category (film_id)
		ON f.film_id = fc.film_id
	INNER JOIN category AS c   -- hago un nuevo join para conectar film_category con category 
		ON fc.category_id = c.category_id
	GROUP BY c.name; -- agrupo por categoria
    
    
-- 12 - Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

 SELECT rating, AVG (length) AS duracion -- 12
		FROM film
        GROUP BY rating;
        
-- 13 - Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT a.first_name, a.last_name, f.title  -- defino Tablas actor como "a", "fa" y "f" para poder hacer los joins
			FROM actor AS a
			INNER JOIN film_actor AS fa -- conecto tabla actor con film_actor (actor_id)
				ON a.actor_id = fa.actor_id
			INNER JOIN film AS f  -- conecto film_actor con film (film_id) donde el titulo sea "Indian love"
				ON fa.film_id = f.film_id
			WHERE f.title = "Indian love";
            
-- 14 - Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title     -- en este ejercicio utilizo "%" delante y detras de la palabra solicitada para que la encuentre sin orden especifico dentro de la descripcion.
	FROM film
    WHERE description LIKE "%dog%" OR description LIKE "%cat%";
    
-- 15 - Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor

SELECT first_name, last_name  -- averiguo si el nombre y apellido del actor no esta relacionado con algun actor_id de la tabla film_actor
	FROM actor
	WHERE actor_id NOT IN (
SELECT actor_id 
	FROM film_actor);
    
-- 16 - Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title, release_year
	FROM film
	WHERE release_year BETWEEN "2005" AND "2010";
        
-- 17 - Encuentra el título de todas las películas que son de la misma categoría que "Family"

SELECT f.title			-- este es similar al ejercicio 13, donde debo hacer INNER JOIN desde la tabla film hasta la tabla category para encontrar "Name" con el WHERE
	FROM film AS f	
INNER JOIN film_category AS fc 
	ON f.film_id = fc.film_id
INNER JOIN category AS c 
	ON fc.category_id = c.category_id
	WHERE c.name = "Family";
    
    
-- 18 -  Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT a.first_name, a.last_name, 		-- conectamos nombre y apellido de la tabla actor (a) haciendo un inner join con el id de la tabla film_actor (fa)
	COUNT(fa.film_id) AS total_pelis
	FROM actor AS a
INNER JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id, a.first_name, a.last_name  -- agrupo por ID, nombre y apellido
	HAVING COUNT(fa.film_id) > 10;   -- cuento por film_id que sea mayor de 10
    
    
-- 19 - Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film. 

    SELECT title, length, rating  -- seleccionamos las columnas solicitadas y buscamos en rating las calificadas como R mayores de 120 minutos (2 hs)
		FROM film
        WHERE rating = "R" AND length > 120;
        
-- 20 -   Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.      
        

    SELECT c.name AS categoria_peli, AVG(f.length) AS promedio_duracion  -- aqui le pongo alias a las dos columnas y pido el promedio (AVG) de duracion de las peliculas
		FROM category AS c
	INNER JOIN film_category AS fc 
		ON c.category_id = fc.category_id  -- una vez conectadas las tablas category (c) con film category (fc) y film (f)
	INNER JOIN film AS f 
		ON fc.film_id = f.film_id
	GROUP BY c.name			-- las agrupo por nombre de categoria y saco el promedio de duracion como en el ejercicio anterior
	HAVING AVG(f.length) > 120;
    
    
-- 21 - Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
	
SELECT a.first_name, a.last_name,  -- este ejercicio es muy similar al anterior (20) solo que con actores y un count >5 en el having
	COUNT(fa.film_id) AS total_pelis
		FROM actor AS a
INNER JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
	HAVING COUNT(fa.film_id) >= 5;
    
-- 22 - Encuentra el título de todas las películas que fueron alquiladas por mas de 5 dias. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 dias
-- y luego selecciona las peliculas correspondientes

SELECT title
	FROM film
	WHERE film_id IN (         
			SELECT i.film_id
			FROM rental AS r
		INNER JOIN inventory AS i 
			ON r.inventory_id = i.inventory_id
			WHERE (r.return_date - r.rental_date) > '5 days'); 
-- en esta subconsulta podemos saber cuales fueron las peliculas que se alquilaron por mas de 5 dias utilizando el operador de comparacion (-) ya que solo tenemos la fecha de alquiler y devolucion



-- 23 - Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que 
-- han actuado categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT first_name, last_name
	FROM actor
WHERE actor_id NOT IN (
		SELECT fa.actor_id
			FROM film_actor AS fa
		INNER JOIN film_category AS fc 
			ON fa.film_id = fc.film_id
		INNER JOIN category AS c 
			ON fc.category_id = c.category_id
		WHERE c.name = 'Horror'); 
        
	-- en esta subconsulta primero averiguamos que actores trabajaron en la categoria 'Horror' haciendo INNER JOIN desde la tabla fa, hasta c para luego poder excluir el actor_id en el WHERE con un NOT IN
 -- es similar al ejercicio 22



-- 24 - Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

	SELECT f.title, f.length, c.name AS categoria_pelis
		FROM film AS f			-- selecciono titulo, duracion y nombre de categoria
	INNER JOIN film_category AS fc  
		ON f.film_id = fc.film_id		-- hago los joins para llegar de la tabla film (f) a film_category (fc) hasta category (c)
	INNER JOIN category AS c 
		ON fc.category_id = c.category_id
	WHERE c.name = 'Comedy' AND f.length > 180;  -- ya en la tabla category puedo encontrar la categoria por nombre y filtrar las mayores de 180 min.






    











