--REPASO EXAMEN FEBRERO
--DML 1 : CONSULTAS SIMPLES

--3. Hallar el nombre y dos apellidos de los profesores cuyo correo está en el servidor "lcc.uma.es". En este caso
--hay que utilizar el operador LIKE. Recordad que nombre LIKE 'A%' será verdadero si nombre empieza por 'A'.

select nombre, apellido1, apellido2 
from profesores 
where email like '%lcc%';
--5. Liste el nombre de las asignaturas de tercero, informando del total de créditos, de la proporción de teoría y de
--prácticas en tanto por ciento.
select nombre, creditos "Creditos totales",
round((teoricos*100/creditos),0)  "Creditos Teóricos",
round((practicos*100/creditos),0) "Creditos Practicos"
from asignaturas 
where curso=3;

-- 7º Mostrar la población de cada municipio español: nombre de municipio y suma de hombres y mujeres de todos
--municipios.

select nombre , (hombres+mujeres) "Población total"
from municipio;

--9. Hallar el nombre y dos apellidos de los profesores que ingresaran antes de 1990. Es decir su fecha de ingreso es
--anterior a TO_DATE('01/01/1990', 'DD/MM/YYYY')
select nombre, apellido1, apellido2
from profesores
where antiguedad < to_date('01/01/1990','DD/MM/YYYY');

--COMENTARIO A: La función to_char, convierte una fecha a una cadena o un número con el formato especificado
    --Ejemplo to_char(sysdate, 'dd/mm/yyy') devuelve 20/01/2019
    --El sysdate-1 lo usamos por si el día actual coincide con el día que cumple la semana.
--select to_char(sysdate,'day') from dual; Devuelve Domingo (día actual)
--select to_char(sysdate,'Month') from dual; Devuelve Enero (mes actual)
--select to_char(sysdate,'Mon') from dual ; Devuelve la versión corta del mes Ene

    --COMENTARIO B:NEXT_DAY Devuelve la fecha más cercana posterior a D cuyo dia de la semana es WD. 
    --WD puede ser LUNES, MARTES, MIÉRCOLES, JUEVES, VIERNES, SÁBADO, DOMINGO.
    --NEXT_DAY(D,WD)
--EJEMPLO: SELECT NEXT_DAY(TO_DATE('20/01/2019','DD/MM/YYYY'),'sábado') FROM DUAL;
        --Devuelve la fecha del próximo sábado a la fecha dada en formato DD/MM/YYYY'

--11.Liste en mayúsculas el nombre y dos apellidos de los profesores que tienen más de 3 trienios. A un profesor se
--le concede un trienio cuando cumple tres años desde su ingreso. Pero si lleva 8 años y 11 meses solo tiene 2
--trienios hasta que no cumpla los 9 años exactos. Use la función TRUNC para un cálculo correcto de los trienios.
--Muestre el número de trienios acumulados también. Renombre la columna de los trienios utilizando el Alias de
--columna.

select upper(nombre), upper(apellido1), upper(apellido2),
trunc(months_between(sysdate,antiguedad)/36,0) "Trienios"
from profesores 
where (months_between(sysdate,antiguedad)/36) >3
ORDER BY APELLIDO1, APELLIDO2, NOMBRE;

--13 .Muestre el nombre y créditos de todas las asignaturas obligatorias y optativas. Las asignaturas que no tienen
--asignado el valor de créditos debe poner NO ASIGNADO. Utilice la función NVL(expr1, expr2) que devuelve
--expr1 siempre que ésta no sea nula y expr2 en caso contrario. Aproveche que obligatorias y optativas
--comienzan ambas por el mismo carácter para simplificar la consulta ( caracter LIKE 'O_' )..

SELECT NOMBRE, nvl(to_char(CREDITOS),'NO ASIGNADO') "Créditos"
FROM ASIGNATURAS
WHERE caracter like 'O_';
--to_char() realiza la conversión de un número o fecha a una cadena, el valor retornado será siempre un VARCHAR2 y opcionalmente también una máscara para 
--formatear la salida

--16.Informe de los alumnos que se matricularon en la universidad un lunes.

select Nombre, apellido1, apellido2, to_char(fecha_prim_matricula,'Day') "Día de la semana"
from alumnos
where (to_char(fecha_prim_matricula,'DAY')) LIKE 'L%';

--EJEMPLO: SELECT NEXT_DAY(TO_DATE('20/01/2019','DD/MM/YYYY'),'sábado') FROM DUAL;
        --Devuelve la fecha del próximo sábado a la fecha dada en formato DD/MM/YYYY'
        
--DML 2 : FUNCIONES, REUNIONES Y OPERACIONES DE CONJUNTOS

--2. Usando la función NVL extraiga un listado con el código y el nombre de las asignaturas de las que
--está matriculado 'Nicolas Bersabe Alba'. Proporcione además el número de créditos prácticos, pero
--caso de ser nulo, debe salir "No tiene" en el listado. Indicación: advierta que prácticos es NUMBER y
--el literal 'No tiene' es VARCHAR2.

select DISTINCT ASIG.codigo "ASIGNATURA" ,  ASIG.nombre "NOMBRE" ,nvl(to_char(ASIG.PRACTICOS),'No tiene') "Créditos Prácticos"
from asignaturas ASIG , ALUMNOS A, MATRICULAR M
where M.ALUMNO=A.DNI AND M.ASIGNATURA=ASIG.CODIGO AND
upper(A.nombre)='NICOLAS' AND UPPER(A.apellido1)='BERSABE' AND UPPER(A.APELLIDO2)='ALBA';

--4. Alumnos que tengan aprobada la asignatura 'Bases de Datos'.
select A.Dni,A.Nombre, A.apellido1, A.apellido2, A.genero, A.direccion, A.telefono, A.email, A.fecha_nacimiento, A.fecha_prim_matricula
from alumnos A, matricular M, asignaturas asig
where a.dni=m.alumno and asig.codigo=m.asignatura and upper(asig.nombre)='BASES DE DATOS'
AND M.CALIFICACION !='SP';

--7º Combinaciones de apellidos que se pueden obtener con los primeros apellidos de alumnos nacidos
--entre los años 1995 y 1996, ambos incluidos. Se recomienda utilizar el operador BETWEEN … AND
-- para expresar el rango de valores.

SELECT A1.APELLIDO1, A2.APELLIDO1
FROM ALUMNOS A1 , ALUMNOS A2
WHERE (EXTRACT(YEAR FROM A1.FECHA_NACIMIENTO) BETWEEN 1995 AND 1996) AND
        (EXTRACT(YEAR FROM A2.FECHA_NACIMIENTO) BETWEEN 1995 AND 1996)
        AND A1.DNI<A2.DNI;

--10.Tríos de asignaturas pertenecientes a la misma materia. Debe presentarse el nombre de las 3
--asignaturas seguido del código de la materia a la que pertenecen.

SELECT ASIG1.NOMBRE "ASIGNATURA 1" , ASIG2.NOMBRE "ASIGNATURA 2" , ASIG3.NOMBRE "ASIGNATURA 3", ASIG1.COD_MATERIA
FROM ASIGNATURAS ASIG1, ASIGNATURAS ASIG2, ASIGNATURAS ASIG3
WHERE ASIG1.COD_MATERIA=ASIG2.COD_MATERIA AND ASIG1.COD_MATERIA=ASIG3.COD_MATERIA
AND ASIG1.CODIGO<ASIG2.CODIGO AND ASIG1.CODIGO<ASIG3.CODIGO AND ASIG2.CODIGO<ASIG3.CODIGO;
--Hay que comprobar que los códigos de materia coinciden, pero que el código de asignatura es distinto.


--11. Muestre el nombre, apellidos, nombre de la asignatura y las notas obtenidas por todos lo alumnos con
--más de 22 años. Utilice la función DECODE para mostrar la nota como (Matricula de Honor,
--Sobresaliente, Notable, Aprobado, Suspenso o No Presentado). Ordene por apellidos y nombre del
--alumno.
select A.NOMBRE, A.APELLIDO1, A.APELLIDO2, ASIG.NOMBRE , 
NVL( DECODE(M.CALIFICACION,'MH','Matricula de Honor','SB','Sobresaliente','NT','Notable','AP','Aprobado','SP','Suspenso','NP','No Presentado'), 'No presentado')
FROM  ASIGNATURAS ASIG JOIN MATRICULAR M ON (ASIG.CODIGO=M.ASIGNATURA) 
JOIN ALUMNOS A ON M.ALUMNO=A.DNI 
AND (MONTHS_BETWEEN(SYSDATE,A.FECHA_NACIMIENTO)/12)>22;

--13.Nombre y apellidos de los alumnos matriculados en asignaturas impartidas por profesores del
--departamento de 'Lenguajes y Ciencias de la Computación'. El listado debe estar ordenado
--alfabéticamente
select DISTINCT A.nombre, A.apellido1, A.apellido2 
from alumnos A 
JOIN Matricular M ON (A.DNI = M.ALUMNO)
JOIN IMPARTIR I ON (I.ASIGNATURA=M.ASIGNATURA) 
JOIN ASIGNATURAS ASIG ON (I.ASIGNATURA=ASIG.CODIGO) 
JOIN DEPARTAMENTOS D ON (ASIG.DEPARTAMENTO=D.CODIGO) AND  UPPER(D.NOMBRE)='LENGUAJES Y CIENCIAS DE LA COMPUTACION' 
ORDER BY A.APELLIDO1, A.APELLIDO2, A.NOMBRE;	

--17.Muestre todos los emails almacenados en la base de datos (tablas de Profesores y Alumnos). Si un
--email aparece repetido en dos tablas distintas también deberá aparecer repetido en la consulta. Evite
--los NULL.
select email
from profesores 
where email is not null
union all
select email 
from alumnos 
where email is not null;

--19 .Apellidos que contienen la letra elle ( 'll' ) tanto de alumnos como de profesores.

select A.Apellido1 
from Alumnos A
WHERE upper(A.APELLIDO1) LIKE '%LL%'
UNION 
(select A.Apellido2 
from Alumnos A
WHERE UPPER(A.APELLIDO2) LIKE '%LL%')
UNION 
(select P.Apellido1
from Profesores P
WHERE UPPER(P.APELLIDO1) LIKE '%LL%')
UNION
(select P.Apellido2 
from PROFESORES P
WHERE UPPER(P.APELLIDO2) LIKE '%LL%');

--20.Idem que la anterior pero sustituya la 'll' por una 'y'. Utilice REPLACE.
select  replace(UPPER(A.APELLIDO1),'LL','Y')
from Alumnos A
WHERE upper(A.APELLIDO1) LIKE '%LL%'
UNION 
(select  replace(UPPER(A.APELLIDO2),'LL','Y')
from Alumnos A
WHERE UPPER(A.APELLIDO2) LIKE '%LL%')
UNION 
(select replace(UPPER(P.APELLIDO1),'%LL%','Y')
from Profesores P
WHERE UPPER(P.APELLIDO1) LIKE '%LL%')
UNION
(select  replace(UPPER(P.APELLIDO2),'%LL%','Y')
from PROFESORES P
WHERE UPPER(P.APELLIDO2) LIKE '%LL%');


--23.Muestre el nombre y apellidos de cada profesor junto con los de su director de tesis y el número de
--tramos de investigación del director. Recuerde que el director de tesis de un profesor viene dado por
--el atributo DIRECTOR_TESIS y el número de tramos se encuentra en la tabla INVESTIGADORES.
--Los nombres de cada profesor y su director deben aparecer con el siguiente formato: 'El Director de
--Angel Mora Bonilla es Manuel Enciso Garcia-Oliveros'.

select 'El Director de ' ||' '|| P1.NOMBRE ||' '|| P1.APELLIDO1 ||' '|| P1.APELLIDO2 ||' '|| 'es' ||' '|| 
P2.NOMBRE ||' '|| P2.APELLIDO1 ||' '|| P2.APELLIDO2 , NVL(I.TRAMOS,'0')
FROM PROFESORES P1 , PROFESORES P2 LEFT OUTER JOIN  INVESTIGADORES I ON (I.ID_PROFESOR=P2.ID)
WHERE P1.DIRECTOR_TESIS=P2.ID;

--24.Liste el nombre de todos los alumnos ordenados alfabéticamente. Si dicho alumno tuviese otro
--alumno que se ha matriculado exactamente a la vez que él, muestre el nombre de este segundo
---alumno a su lado.

select ( A1.NOMBRE || ' '|| A1.APELLIDO1 ||' '|| A1.APELLIDO2 ) "ALUMNOS" ,( A2.NOMBRE || ' '|| A2.APELLIDO1 ||' '|| A2.APELLIDO2) "ALUMNOS 2" 
from ALUMNOS A1
LEFT OUTER JOIN ALUMNOS A2 ON (A1.DNI < A2.DNI) AND (A1.FECHA_PRIM_MATRICULA=A2.FECHA_PRIM_MATRICULA);

--QUIERO QUE ME LISTE TODOS LOS ALUMNOS (LA PRIMERA TABLA SIEMPRE ESTARÁ LLENA) Y A LA DERECHA, ALUMNOS QUE SE MATRICULARON A LA VEZ
--EXCLUIMOS QUE SEAN ELLOS MISMOS. PARA ESO USAMOS LEFT OUTER JOIN . A LEFT OUTER JOIN B . AÑADIMOS TODO A, Y TODO B QUE CUMPLA LA CONDICIÓN


--26.Nombres e identificador de los profesores que no imparten grupo actualmente
select P. Nombre, P.ID 
FROM PROFESORES P
WHERE P.ID NOT IN (select P1.ID from profesores P1 join IMPARTIR I ON P1.ID=I.PROFESOR);

--27.Nombre y apellidos de 2 alumnas matriculadas de la asignatura de código 115 . Use ROWNUM para filtrar el número de tuplas que se desea (2 en este caso). 
--Las tuplas repetidas deben filtrarse también.

select A.NOMBRE, A.APELLIDO1, A.APELLIDO2
FROM ALUMNOS A
WHERE EXISTS (select * from matricular M
                where A.DNI=M.ALUMNO AND M.ASIGNATURA='115' AND A.GENERO='FEM')
                AND ROWNUM < 3 ; --OJO, EL ROWNUM debe estar fuera de la consulta
       --EXISTS conjunto_tuplas La expresión es cierta si el conjunto de tuplas no está vacío. Es decir, existe al menos una tupla en el conjunto.
       
--28 Muestre todos los datos de los profesores que no son directores de tesis

select * FROM PROFESORES P
WHERE P.ID NOT IN (SELECT ID FROM PROFESORES WHERE ID != DIRECTOR_TESIS);

--29.Liste el nombre y código de las asignaturas que tienen en su mismo curso otra con más créditos que
--ella 

SELECT ASIG.NOMBRE, ASIG.CODIGO
FROM ASIGNATURAS ASIG
WHERE ASIG.NOMBRE IN (SELECT ASIG.NOMBRE FROM ASIGNATURAS ASIG1
WHERE NVL(ASIG1.CREDITOS,0) > NVL(ASIG.CREDITOS,0) AND NVL(ASIG.CURSO,0)=NVL(ASIG1.CURSO,0));

--30.Use las operaciones de conjuntos y la consulta anterior para mostrar las asignaturas que tienen el
--máximo número de créditos de su curso.
select a.nombre,a.codigo
from asignaturas a
minus 
select a.nombre, a.codigo from asignaturas a
where (a.nombre in (select a.nombre 
                    from asignaturas b 
                    where NVL(b.creditos,0) > NVL(a.creditos,0) and NVL(a.curso,0)=NVL(b.curso,0)));

--2º Calcular el número de créditos asignados a cada departamento. Se consideran los créditos
--establecidos para cada asignatura del departamento, no si la imparten o no profesores del mismo, es
--decir, sume directamente los créditos de las asignaturas y reúna asignaturas y departamentos
--directamente, sin utilizar ninguna otra tabla

--Relación DML-3: Agrupación, Consultas Negativas, Subconsultas Avanzadas

--2º Calcular el número de créditos asignados a cada departamento. Se consideran los créditos
--establecidos para cada asignatura del departamento, no si la imparten o no profesores del mismo, es
--decir, sume directamente los créditos de las asignaturas y reúna asignaturas y departamentos
--directamente, sin utilizar ninguna otra tabla.

SELECT D.NOMBRE , SUM(ASIG.CREDITOS)
FROM DEPARTAMENTOS D JOIN ASIGNATURAS ASIG ON (D.CODIGO=ASIG.DEPARTAMENTO)
GROUP BY D.NOMBRE;

--3. Calcular el número de alumnos matriculados por curso (cada alumno debe contar una sola vez por
--curso aunque esté matriculado de varias asignaturas). Utilice COUNT (DISTINCT ...).

select M.CURSO , COUNT(DISTINCT M.ALUMNO) "Número de alumnos"
FROM MATRICULAR M, asignaturas ASIG
WHERE ASIG.CODIGO=M.ASIGNATURA AND ASIG.CURSO IS NOT NULL
GROUP BY M.CURSO;

--4. Por cada número de despacho, indicar el total de créditos impartidos por profesores ubicados en ellos.
SELECT P.DESPACHO , SUM(I.CARGA_CREDITOS) "TOTAL CREDITOS"
FROM PROFESORES P, IMPARTIR I
WHERE P.ID=I.PROFESOR AND I.CARGA_CREDITOS IS NOT NULL
GROUP BY P.DESPACHO ; --AGRUPO POR DESPACHO COMÚN; 

--7. Visualizar, por cada departamento, el nombre del profesor más cercano a la jubilación (de mayor edad)
select D.NOMBRE , P.NOMBRE ||' '|| P.APELLIDO1  "PROFESOR"
FROM DEPARTAMENTOS D JOIN PROFESORES P 
ON (D.CODIGO=P.DEPARTAMENTO)
WHERE P.FECHA_NACIMIENTO IN (SELECT MIN (P1.FECHA_NACIMIENTO) FROM PROFESORES P1 
WHERE P1.DEPARTAMENTO=D.CODIGO)
ORDER BY D.NOMBRE DESC;

select * from sol_3_7;
----MThe MIN() function returns the smallest value of the selected column. 
--COJO LA FECHA MAS PEQUEÑA (LAS MAS ANTIGUA), MIENTRAS MAS PEQUEÑAS, MAS AÑO TIENE LA PERSONA

--8. Visualizar la asignatura de mayor número de créditos en que se ha matriculado cada alumno.
select DISTINCT (A.NOMBRE ||' '|| A.APELLIDO1 ||' '|| A.APELLIDO2 ) "ALUMNO" , ASIG.NOMBRE "ASIGNATURA"
FROM ALUMNOS A , ASIGNATURAS ASIG, MATRICULAR M
WHERE M.ALUMNO=A.DNI and M.ASIGNATURA=ASIG.CODIGO
     and ASIG.CREDITOS=(SELECT MAX(ASIG1.CREDITOS) FROM ASIGNATURAS ASIG1, MATRICULAR M1
        WHERE M1.ASIGNATURA=ASIG1.CODIGO AND M1.ALUMNO=A.DNI);
        
        -- MAX Determina el mayor valor de una columna.


        
--9. Visualizar el profesor más antiguo de cada departamento.
select D.NOMBRE , P.NOMBRE ||' '|| P.APELLIDO1  "PROFESOR"
FROM DEPARTAMENTOS D JOIN PROFESORES P 
ON (D.CODIGO=P.DEPARTAMENTO)
WHERE P.FECHA_NACIMIENTO IN (SELECT MIN(P1.FECHA_NACIMIENTO) FROM PROFESORES P1 
WHERE P1.DEPARTAMENTO=D.CODIGO)
ORDER BY D.NOMBRE DESC;

--10.Visualizar para cada departamento, la asignatura con menos créditos.

SELECT DISTINCT D.NOMBRE "DEPARTAMENTO"  , ASIG.NOMBRE "ASIGNATURA"
FROM DEPARTAMENTOS D JOIN ASIGNATURAS ASIG ON 
ASIG.DEPARTAMENTO=D.CODIGO
WHERE ASIG.CREDITOS = ( SELECT MIN(ASIG1.CREDITOS) FROM ASIGNATURAS ASIG1 WHERE ASIG1.DEPARTAMENTO=D.CODIGO);

--11.Visualizar para cada asignatura, el alumno de menor edad matriculado en el curso 2014-2015.
select (ASIG.NOMBRE) , A.NOMBRE ||' '|| A.APELLIDO1 ||' '|| A.APELLIDO2, A.FECHA_NACIMIENTO
FROM ASIGNATURAS ASIG JOIN MATRICULAR M ON ASIG.CODIGO=M.ASIGNATURA AND M.CURSO='14/15'
JOIN ALUMNOS A ON M.ALUMNO=A.DNI 
WHERE A.FECHA_NACIMIENTO = (SELECT MAX(A1.FECHA_NACIMIENTO) FROM ALUMNOS A1 , MATRICULAR M1
WHERE A1.DNI=M1.ALUMNO AND M1.ASIGNATURA=ASIG.CODIGO AND M1.CURSO='14/15') ;

--12 Visualizar el profesor con mayor carga de créditos. Considere la carga de créditos como la suma de
--los créditos de las asignaturas que imparte dicho profesor. Nota: Tenga en cuenta que un profesor
--puede impartir sólo una parte de una asignatura, por lo que se debe utilizar los créditos de la tabla
--impartir.   
select P.NOMBRE ||' '|| P.APELLIDO1 "PROFESOR" , SUM(I.CARGA_CREDITOS) "CREDITOS"
from PROFESORES P JOIN IMPARTIR I ON (P.ID=I.PROFESOR)
GROUP BY P.NOMBRE ||' '|| APELLIDO1
HAVING SUM(I.CARGA_CREDITOS)=(SELECT MAX(SUM(I1.CARGA_CREDITOS)) FROM IMPARTIR I1
GROUP BY I1.PROFESOR ); 
--13.Visualizar el departamento con mayor número de asignaturas a su cargo.
select DISTINCT D.NOMBRE 
FROM DEPARTAMENTOS D JOIN ASIGNATURAS ASIG ON (D.CODIGO=ASIG.DEPARTAMENTO)
WHERE ASIG.DEPARTAMENTO = (SELECT min(ASIG1.DEPARTAMENTO) FROM ASIGNATURAS ASIG1);
                            --CON MIN, SACO EL DEPARTAMENTO CON MENOS ASIGNATURAS A SU CARGO
                            
--14.Muestre el listado de los profesores que imparten menos de 10 créditos en total. Indique el código del
--profesor y el número de créditos que imparte.

select P.ID, SUM(I.CARGA_CREDITOS)
FROM PROFESORES P JOIN IMPARTIR I ON (P.ID=I.PROFESOR)
GROUP BY P.ID
HAVING SUM(I.CARGA_CREDITOS)<10 ; --CONDICIÓN DE REUNIÓN

--15º Listar los profesores que tienen una carga de créditos superior a la media. Use clausula HAVING y
--anide funciones de agrupación.
select P.NOMBRE || ' '|| P.APELLIDO1 ||' '|| P.APELLIDO2 "PROFESOR" 
FROM PROFESORES P JOIN IMPARTIR I ON (P.ID=I.PROFESOR)
GROUP BY  P.NOMBRE || ' '|| P.APELLIDO1 ||' '|| P.APELLIDO2
HAVING SUM(I.CARGA_CREDITOS) > (SELECT AVG(SUM(I1.CARGA_CREDITOS)) FROM IMPARTIR I1
GROUP BY I1.PROFESOR );

--16º Visualizar aquellos profesores que imparten 2 o más asignaturas en el curso 15/16 con una carga de
--créditos inferior a 6.5 en cada una de ellas.

select P.ID
FROM PROFESORES P, IMPARTIR I
WHERE P.ID=I.PROFESOR AND I.CURSO='15/16' 
AND CARGA_CREDITOS <6.5
GROUP BY P.ID
HAVING COUNT (I.ASIGNATURA) >=2;

--18. .Listar el nombre de los departamentos que no tienen ninguna asignatura con más de 6 créditos.
SELECT DISTINCT D.NOMBRE 
FROM DEPARTAMENTOS D JOIN PROFESORES P ON D.CODIGO=P.DEPARTAMENTO JOIN IMPARTIR I ON (I.PROFESOR=P.ID)
WHERE D.NOMBRE NOT IN (SELECT D1.NOMBRE FROM DEPARTAMENTOS D1, PROFESORES P1, IMPARTIR I1
WHERE P1.DEPARTAMENTO=D1.CODIGO AND P1.ID=I1.PROFESOR AND I1.CARGA_CREDITOS > 6);
		--COMENTARIO: SE COME SOLUCIONES (una en concreto, de las 3 que debe de salir)
SELECT D.NOMBRE
FROM DEPARTAMENTOS D 
WHERE D.NOMBRE NOT IN (SELECT D1.NOMBRE FROM DEPARTAMENTOS D1, ASIGNATURAS ASIG
WHERE D1.CODIGO=ASIG.DEPARTAMENTO AND ASIG.CREDITOS > 6);
		--En este caso relaciono directamente departamento con asignaturas (me sale bien la solución)

--19.Listar alfabéticamente los profesores que están en la lista negra de los alumnos. Si un profesor está en
--la lista negra de los alumnos, da clase en alguna asignatura optativa y en ella los alumnos no se
--matriculan para evitarlo. Tenga en cuenta que si hay dos turnos de la optativa, los alumnos tienden a
--evitar al profesor de ese turno, pero no a los de los otros grupos

select P.NOMBRE ||' '|| P.APELLIDO1 ||' '||  P.APELLIDO2 "PROFESOR EN LA LISTA NEGRA"
FROM PROFESORES P, ASIGNATURAS ASIG, IMPARTIR I
WHERE P.ID=I.PROFESOR AND I.ASIGNATURA =ASIG.CODIGO AND ASIG.CARACTER='OP' AND ASIG.CODIGO 
NOT IN (SELECT M.ASIGNATURA FROM MATRICULAR M WHERE I.GRUPO=M.GRUPO);

	--1º CONTATENO NOMBRE Y APELLIDOS 2º COMPRUEBO QUE ESE PROFESOR IMPARTE ASIGNATURAS Y COMPRUEBO QUE ESAS ASIGNATURAS QUE IMPARTE ESTÉN LIGADAS CON LA TABLA ASIGNATURAS
	--SI ESTÁ LIGADO, COMPRUEBO CUALES DE ELLAS SON OPTATIVAS MEDIANTE "ASIG.CARACTER='OP'
	--3º HAGO UNA CONSULTA NEGATIVA BUSCANDO LAS ASIGNATURAS EN LAS QUE ESE MISMO PROFESOR COINCIDAN EN GRUPOS DE OPTATIVAS Y OBLIGATORIAS
	
--20.Mostrar las parejas de profesores que no tienen ningún alumno en común

select DISTINCT P.NOMBRE ||' '|| P.APELLIDO1 ||' '||  P.APELLIDO2 "PROFESOR 1",
P1.NOMBRE ||' '|| P1.APELLIDO1 ||' '||  P1.APELLIDO2 "PROFESOR 2"
FROM PROFESORES P, PROFESORES P1
WHERE P.ID < P1.ID AND NOT EXISTS (SELECT M.ALUMNO FROM MATRICULAR M NATURAL JOIN IMPARTIR I
WHERE P.ID=I.PROFESOR
INTERSECT
SELECT M.ALUMNO FROM MATRICULAR M  NATURAL JOIN IMPARTIR I 
WHERE P1.ID=I.PROFESOR);

--"NATURAL JOIN" se usa cuando los campos por los cuales se enlazan las tablas tienen el mismo nombre, podemos "omitir" la parte del "ON"
--que nos indica los nombres e los campos por el cual se enlazan las tablas, con "natural join" se unirán por el campo que tienen en común
--EN ESTE CASO, las tablas comunes son "ASIGNATURA","CURSO" Y "GRUPO"

--OTRA FORMA ES USAR EL ON CON PRECONDICIONES, EN ESTE CASO 3

select DISTINCT P.NOMBRE ||' '|| P.APELLIDO1 ||' '||  P.APELLIDO2 "PROFESOR 1",
P1.NOMBRE ||' '|| P1.APELLIDO1 ||' '||  P1.APELLIDO2 "PROFESOR 2"
FROM PROFESORES P, PROFESORES P1
WHERE P.ID < P1.ID AND NOT EXISTS (SELECT M.ALUMNO FROM MATRICULAR M  JOIN IMPARTIR I ON 
((M.ASIGNATURA=I.ASIGNATURA) AND (M.CURSO=I.CURSO) AND (I.GRUPO=M.GRUPO)) -- PRECONDICIONES EN EL ON PARA ENLAZAR TABLAS 
WHERE P.ID=I.PROFESOR
INTERSECT
SELECT M.ALUMNO FROM MATRICULAR M  NATURAL JOIN IMPARTIR I 
WHERE P1.ID=I.PROFESOR);

select * from sol_3_14;