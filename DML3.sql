--RELACION DML-3: Agrupación, Consultas Negativas, Subconsultas avanzadas

--Agrupacion 1

--1. Calcular el número de profesores de cada departamento. Muestre el nombre del departamento y el
--número de profesores
select D.nombre, COUNT (P.DEPARTAMENTO)"NÚMERO DE PROFESORES"
from DEPARTAMENTOS D, PROFESORES P
WHERE P.DEPARTAMENTO=D.CODIGO
GROUP BY D.NOMBRE
ORDER BY D.NOMBRE;

--GROUP BY COLUMNA1, COLUMNA 2 (SE UTILIZA PARA AGRUPAR RESULTADOS POR UNA DETERMINADA COLUMNA, ESPECIFICAMENTE CUANDO SE UTILIZAN FUNCIONES DE COLUMNA
--Y LOS RESULTADOS SE DESEAN OBTENE POR GRUPOS
--HAVING condición-selección-grupos Se utiliza con la cláusula “GROUP BY”, cuando se quiere poner condiciones al resultado de un grupo.

--2º Calcular el número de créditos asignados a cada departamento. Se consideran los créditos
--establecidos para cada asignatura del departamento, no si la imparten o no profesores del mismo, es
--decir, sume directamente los créditos de las asignaturas y reúna asignaturas y departamentos
--directamente, sin utilizar ninguna otra tabla

SELECT D.NOMBRE, SUM(A.CREDITOS) "Numero creditos"
from departamentos D, ASIGNATURAS A
WHERE D.CODIGO=A.DEPARTAMENTO
GROUP BY D.NOMBRE;
    --SUMA TODO LOS CRÉDITOS EN FUNCIÓN DE SI CASAN CODIGO DEPARTAMENTO, EN VEZ DE PONER EL CÓDIGO, PONEMOS EL NOMBRE

--3º Calcular el número de alumnos matriculados por curso (cada alumno debe contar una sola vez por
--curso aunque esté matriculado de varias asignaturas). Utilice COUNT (DISTINCT ...).

SELECT A.CURSO, COUNT(DISTINCT M.ALUMNO) "NUMERO DE ALUMNOS"
FROM ASIGNATURAS A, MATRICULAR M
WHERE A.CODIGO=M.ASIGNATURA AND A.CURSO IS NOT NULL
GROUP BY A.CURSO;

--4. Por cada número de despacho, indicar el total de créditos impartidos por profesores ubicados en ellos.

SELECT P.DESPACHO, SUM(I.CARGA_CREDITOS) "TOTAL CREDITOS"
FROM PROFESORES P, IMPARTIR I
WHERE P.ID=I.PROFESOR AND I.CARGA_CREDITOS IS NOT NULL
GROUP BY P.DESPACHO;


--5. Calcular, por cada asignatura, qué porcentaje de sus alumnos son mujeres. Mostrar el código de la
--asignatura y el porcentaje.

select M.asignatura, COUNT (NULLIF(A.genero,'MASC'))/COUNT(m.alumno)*100   "PORCENTAJE MUJERES"
from matricular M, alumnos A
where A.dni=M.alumno 
group by M.asignatura
ORDER BY M.ASIGNATURA;
 --Esta función compara expr1 con expr2. Si son iguales devuelve NULL. Los argumentos pueden ser de cualquier tipo
 --NULLIF(expr1, expr2))
 --Con la expresión count NULLIF(exp1,expr2) , cuento cuantos NO SON HOMBRES (lo que quiere decir que estoy contando mujeres) 
 --y lo divido entre el total
 
--6º Mostrar la población de cada provincia española: nombre de provincia y suma de hombres y mujeres
--de todos sus municipios
select PRO.NOMBRE, SUM(M.HOMBRES+M.MUJERES) "SUMA"
FROM PROVINCIA PRO, MUNICIPIO M
WHERE PRO.CODIGO=M.CPRO
group by PRO.NOMBRE
ORDER BY PRO.NOMBRE;

-- //////////////////  AGRUPACION /////////////

--7º Visualizar, por cada departamento, el nombre del profesor más cercano a la jubilación (de mayor edad).

select D.NOMBRE , P.NOMBRE ||' '|| P.APELLIDO1  "PROFESOR"
FROM DEPARTAMENTOS D JOIN PROFESORES P 
ON (D.CODIGO=P.DEPARTAMENTO)
WHERE P.FECHA_NACIMIENTO IN (SELECT MIN(P1.FECHA_NACIMIENTO) FROM PROFESORES P1 
WHERE P1.DEPARTAMENTO=D.CODIGO)
ORDER BY D.NOMBRE DESC;
--PERMITE OBTENER TODAS LAS FILAS QUE SEAN IGUALES A ALGUNO DE LOS VALORES DESCRITOS POR EXTENSIÓN
--MIN DETERMINA EL MAYOR VALOR DE UNA COLUMNA

--8. Visualizar la asignatura de mayor número de créditos en que se ha matriculado cada alumno.
select DISTINCT (A.NOMBRE ||' '|| A.APELLIDO1 ||' '|| A.APELLIDO2 ) "ALUMNO" , ASIG.NOMBRE "ASIGNATURA"
FROM ALUMNOS A , ASIGNATURAS ASIG, MATRICULAR M
WHERE M.ALUMNO=A.DNI and M.ASIGNATURA=ASIG.CODIGO
     and ASIG.CREDITOS=(SELECT MAX(ASIG1.CREDITOS) FROM ASIGNATURAS ASIG1, MATRICULAR M1
        WHERE M1.ASIGNATURA=ASIG1.CODIGO AND M1.ALUMNO=A.DNI);
        
--9. Visualizar el profesor más antiguo de cada departamento.
select D.NOMBRE , P.NOMBRE ||' '|| P.APELLIDO1  "PROFESOR"
FROM DEPARTAMENTOS D JOIN PROFESORES P 
ON (D.CODIGO=P.DEPARTAMENTO)
WHERE P.ANTIGUEDAD = (SELECT MIN(P1.ANTIGUEDAD) FROM PROFESORES P1 
WHERE P1.DEPARTAMENTO=D.CODIGO)
ORDER BY D.NOMBRE DESC;

--10.Visualizar para cada departamento, la asignatura con menos créditos.

select DISTINCT D.NOMBRE "DEPARTAMENTO" , ASIG.NOMBRE "ASIGNATURA"
FROM DEPARTAMENTOS D JOIN ASIGNATURAS ASIG ON (D.CODIGO=ASIG.DEPARTAMENTO)
WHERE ASIG.CREDITOS = (SELECT MIN (ASIG1.CREDITOS) FROM ASIGNATURAS ASIG1
WHERE ASIG1.DEPARTAMENTO=D.CODIGO)
ORDER BY D.NOMBRE ;

--11.Visualizar para cada asignatura, el alumno de menor edad matriculado en el curso 2014-2015.

SELECT ASIG.NOMBRE, A.NOMBRE ||' '|| A.APELLIDO1 ||' ' || A.APELLIDO2 "ALUMNO", A.FECHA_NACIMIENTO
FROM ALUMNOS A JOIN MATRICULAR M  ON (A.DNI=M.ALUMNO) 
JOIN ASIGNATURAS ASIG ON (M.ASIGNATURA=ASIG.CODIGO) AND M.CURSO='14/15'
WHERE A.FECHA_NACIMIENTO = (SELECT MAX(A1.FECHA_NACIMIENTO) FROM ALUMNOS A1, MATRICULAR M1
WHERE A1.DNI=M1.ALUMNO AND M1.ASIGNATURA=ASIG.CODIGO AND M1.CURSO='14/15') 
ORDER BY ASIG.NOMBRE;

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
WHERE ASIG.DEPARTAMENTO = (SELECT MIN(ASIG1.DEPARTAMENTO) FROM ASIGNATURAS ASIG1);

--14.Muestre el listado de los profesores que imparten menos de 10 créditos en total. Indique el código del
--profesor y el número de créditos que imparte.

select P.ID"PROFESOR", SUM(I.CARGA_CREDITOS) "CREDITOS"
FROM PROFESORES P JOIN IMPARTIR I ON (P.ID=I.PROFESOR)
GROUP BY P.ID
HAVING SUM(I.CARGA_CREDITOS)<10;

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


--21 Mostrar el listado de profesores que no comparten ninguna de sus asignaturas (dos profesores
--comparten asignatura si imparten la misma asignatura independientemente del turno).
select DISTINCT P.NOMBRE ||' '|| P.APELLIDO1 ||' '||  P.APELLIDO2 "PROFESOR 1",
P1.NOMBRE ||' '|| P1.APELLIDO1 ||' '||  P1.APELLIDO2 "PROFESOR 2"
FROM PROFESORES P, PROFESORES P1
WHERE P.ID < P1.ID AND NOT EXISTS (SELECT I.ASIGNATURA FROM IMPARTIR I 
WHERE P.ID=I.PROFESOR
INTERSECT 
SELECT I1.ASIGNATURA FROM IMPARTIR I1 WHERE P1.ID=I1.PROFESOR);
--EXISTS , DEVUELVE TRUE SI UNA SUBCONSUNLTA DEVUELVE AL MENOS UNA FILA

--22.Mostrar los nombres de asignaturas que no tienen dos alumnos matriculados del mismo municipio.
SELECT ASIG.NOMBRE
FROM ASIGNATURAS ASIG
WHERE ASIG.CODIGO NOT IN (SELECT M.ASIGNATURA FROM MATRICULAR M, MATRICULAR M1, ALUMNOS A1, ALUMNOS A2
WHERE M.ALUMNO=A1.DNI AND M1.ALUMNO=A2.DNI AND A1.DNI<A2.DNI AND M.ASIGNATURA=M1.ASIGNATURA AND A1.CMUN=A2.CMUN);