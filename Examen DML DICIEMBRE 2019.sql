--1º Proporcione el nombre y apellidos de los alumnos en los que alguno de sus apellidos contenga un espacio en blanco junto con el
--nombre de la asignatura en la que está matriculado. No muestre información duplicada

select distinct al.nombre, apellido1, apellido2, asig.nombre
from alumnos al join matricular on dni = alumno join asignaturas asig on asignatura = codigo
where apellido1 like '% %' or apellido2 like '% %' ;


--2º Liste para cada asignatura, curso y cada grupo en la que hay alumnos matriculados, el número de alumnos distintos
--matriculados y el numero de profesores distintos que la imparten

SELECT asignatura,curso,grupo , count(distinct alumno), count(distinct profesor)
FROM MATRICULAR m join impartir i using (asignatura, curso, grupo)
group by asignatura, curso, grupo ;

--3ºOBTENGA NOMBRE Y NÚMERO DE CREDITOS DE LAS ASIGNATURAS QUE NO SON IMPARTIDAS POR PROFESORES
--CON MAS DE 20 AÑOS DE EXPERIENCIA

select nombre, creditos
from asignaturas
where codigo not in
(select asignatura from profesores join impartir
on profesor = id
where months_between(sysdate,antiguedad)/12 >20);

--4º Obtener la nota media de todos los alumnos que no nacieron en lunes ni martes, redondeando a 2 decimales. Para calcular la
--nota media use DECODE y considere AP=1, NT=2, SB=3 y MH=4. No sume los suspensos ni los no presentados

select NOMBRE, APELLIDO1, APELLIDO2, ROUND (avg (decode (calificacion, 'AP',1,'NT',2,'SB',3,'MH',4)),2) NOTA
from matricular JOIN ALUMNOS ON ALUMNO=DNI
WHERE CALIFICACION IN ('AP','NT','SB','MH')
and to_char(fecha_nacimiento,'day') not like 'lunes%' and to_char(fecha_nacimiento,'day') not like 'martes%'
group by NOMBRE, APELLIDO1, APELLIDO2;

--5º Muestre el nombre y los 2 apellidos de los profesores cuyo primer apellido contenga una 'á', es decir, una a con tilde. Si el
--profesor imparte alguna asignatura, muestre también el nombre de la asignatura. Es decir, los profesores que contengan la 'á'
--deben aparecer en el listado aunque no impartan ninguna asignatura.
--No muestre información duplicada

select distinct al.nombre, apellido1, apellido2, asig.nombre from profesores al
left outer join impartir on profesor =id left outer join asignaturas asig on asignatura = codigo
where apellido1 like '%á%';

