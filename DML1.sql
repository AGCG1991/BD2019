--1º Hallar el nombre y dos apellidos de los profesores del departamento de código 1. Recordad que la igualdad en
-- SQL se escribe con = y no con == como ocurre en C o C++.

select nombre, apellido1, apellido2 
from profesores
where departamento=1;

--2º . Hallar el nombre y dos apellidos de los profesores de todos los departamentos salvo el de código 3. Para el
--operador "distinto" se puede utilizar !=0

select nombre, apellido1, apellido2 
from profesores 
where departamento != 3;

--3ºHallar el nombre y dos apellidos de los profesores cuyo correo está en el servidor "lcc.uma.es". En este caso
--hay que utilizar el operador LIKE. Recordad que nombre LIKE 'A%' será verdadero si nombre empieza por 'A'.
select nombre, apellido1, apellido2
from profesores
where email like '%lcc.uma.es';

--4º  Mostrar el nombre de alumnos que no disponen de correo electrónico. Recordad el uso del operador IS NULL .
--Probad poniendo la expresión WHERE email = NULL . ¿Qué ocurre?

select nombre, apellido1, apellido2
from alumnos
where email is NULL;

--5º Liste el nombre de las asignaturas de tercero, informando del total de créditos, de la proporción de teoría y de
--prácticas en tanto por ciento.
SELECT NOMBRE,CREDITOS, TEORICOS, PRACTICOS,
        ROUND((TEORICOS*100)/CREDITOS,2) "RATIO TEORICOS",
        ROUND((PRACTICOS*100)/CREDITOS,2) "RATIO PRACTICOS"
    FROM ASIGNATURAS
    WHERE CURSO = 3;

--6º Muestre la lista de las notas de la asignatura 112 de la tabla MATRICULAR. Liste el código del alumno junto a
--su nota ordenado por el primero. Usad ORDER BY.
select alumno, calificacion 
from matricular
where asignatura=112
order by Calificacion;

--7º Mostrar la población de cada municipio español: nombre de municipio y suma de hombres y mujeres de todos
--municipios.
select Nombre, Hombres, Mujeres, (hombres+mujeres) "Población Total" 
from municipio;

--8º Haga la consulta 4 del bloque anterior pero muestre la lista como: El alumno ...... no dispone de Correo.
--Utilizad CONCAT o bien, el operador | |.

select ('El alumno '|| nombre ||' no dispone de correo') "No tienen correo"
from alumnos
where email is NULL;

--9º Hallar el nombre y dos apellidos de los profesores que ingresaran antes de 1990. Es decir su fecha de ingreso es
--anterior a TO_DATE('01/01/1990', 'DD/MM/YYYY')
select nombre, apellido1, apellido2 
from profesores 
where antiguedad < '01/01/1990';
        --COMENTARIO A: Aquí el formado de la fecha es un varchar, para mostrarlo como una fecha debemos de hacer la conversión
select nombre, apellido1, apellido2 
from profesores 
where antiguedad < TO_DATE('01/01/1990', 'DD/MM/YYYY');
    
        --COMENTARIO B: Podríamos sacar el número de días que han pasado desde que ingresó hasta el día de hoy, expresado en años
select nombre, apellido1, apellido2,
trunc((sysdate-antiguedad)/365) " Años de Antiguedad"
from profesores 
where antiguedad < TO_DATE('01/01/1990', 'DD/MM/YYYY');
    
    --COMENTARIO C: Podríamos sacar el número de días que ha pasado, expresado en meses
select nombre, apellido1, apellido2,
trunc((sysdate-antiguedad)/12,0) " meses de Antiguedad"
from profesores 
where antiguedad < TO_DATE('01/01/1990', 'DD/MM/YYYY');

    --COMENTARIO D: Podríamos conocer el tiempo transcurrido desde la fecha A a la B con months_between
    --              Como el dato está expresado en meses, dividimos entre 12, para expresarlo en años.
select nombre, apellido1, apellido2,
trunc(months_between(sysdate,antiguedad)/12,0) " Años de Antiguedad"
from profesores 
where antiguedad < TO_DATE('01/01/1990', 'DD/MM/YYYY');

--10 .Hallar el nombre y dos apellidos de los profesores que tengan mas de 30 años (use la fecha del sistema y la
--función MONTHS_BETWEEN).
select nombre, apellido1, apellido2,fecha_nacimiento
from profesores
where months_between(sysdate,to_char(fecha_nacimiento))/12 > 30;

--11. .Liste en mayúsculas el nombre y dos apellidos de los profesores que tienen más de 3 trienios. A un profesor se
--le concede un trienio cuando cumple tres años desde su ingreso. Pero si lleva 8 años y 11 meses solo tiene 2
--trienios hasta que no cumpla los 9 años exactos. Use la función TRUNC para un cálculo correcto de los trienios.
--Muestre el número de trienios acumulados también. Renombre la columna de los trienios utilizando el Alias de
--columna.
select nombre, apellido1, apellido2 ,
trunc(months_between(sysdate,antiguedad)/36,0) "Trienios"
from profesores 
where (months_between(sysdate,antiguedad)/36) >3;
    --COMENTARIO A: Para calcular los trienios, debemos calcular con months_between, la cantidad de meses pasados desde su ingreso a la actual
    --una vez calculado, dividimos entre 12, para conseguir el número de años, a su vez, dividimos entre 3, pues 1 trienio consta de 3 años, por
    --lo cual dividimos todo entre 36.
    
    --12º Liste el nombre de todas las asignaturas que contienen en su nombre las palabras 'Bases de Datos'. Renombre
--dicha cadena en el listado como 'Almacenes de Datos'. Use la función REPLACE y el operador LIKE

select (Nombre),
replace (Nombre ,'Bases de Datos','Almacenes de datos')
from asignaturas
where UPPER(nombre) like 'BASES DE DATOS';
--replace (atributo,'Frase que buscar','Frase reemplazo')

--13º Muestre el nombre y créditos de todas las asignaturas obligatorias y optativas. Las asignaturas que no tienen
--asignado el valor de créditos debe poner NO ASIGNADO. Utilice la función NVL(expr1, expr2) que devuelve
--expr1 siempre que ésta no sea nula y expr2 en caso contrario. Aproveche que obligatorias y optativas
--comienzan ambas por el mismo carácter para simplificar la consulta ( caracter LIKE 'O_' )..

select Nombre, nvl(to_char(creditos), 'No asignado') 
from asignaturas
where caracter like 'O_';


--14.Informe de los alumnos que se han matriculado hace menos de dos meses

select * from alumnos;

select Nombre, Apellido1 , Apellido2 from Alumnos
where (months_between (sysdate, fecha_prim_matricula)/12) <=2 ;

--15º Informe de los alumnos que entraron en la Universidad con menos de 18 años.
select Nombre, Apellido1, Apellido2 from Alumnos
where (months_between(fecha_prim_matricula, fecha_nacimiento)/12) <18
order by fecha_nacimiento;
--Diferencia entre la fecha de matriculacion y de nacimiento sea MENOR que 18.

--16. Informe de los alumnos que se matricularon en la universidad un lunes.

select Nombre, Apellido1, Apellido2 , to_char(fecha_prim_matricula,'Day') "Día de la semana"
from alumnos
where (to_char(fecha_prim_matricula,'DAY')) like 'L%';
    
    

    
    





