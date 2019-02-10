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