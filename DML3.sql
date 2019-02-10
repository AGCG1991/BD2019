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