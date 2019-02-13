-- //EXAMEN FEBRERO

--EJERCICIO 1: Mostrar nombre, primer apellido y nombre de municipio que viven en las provincias de Badajoz ó Córdoba

select A.nombre, A.apellido1, M.NOMBRE "NOMBRE MUNICIPIO", P.NOMBRE "PROVINCIA"
from alumnos A JOIN MUNICIPIO M ON (M.CMUN=A.CMUN) 
JOIN PROVINCIA P ON (M.CPRO=P.CODIGO) 
WHERE UPPER(P.NOMBRE)='BADAJOZ' OR UPPER (P.NOMBRE)='CÓRDOBA';

--Ejercicio 2: Para cada profesor (deben aparecer todos) mostrar id de profesor y número de tramos de investigación que tiene. En caso de no tener tramos
--debe aparecer 0.

SELECT P.NOMBRE, P.APELLIDO1, P.APELLIDO2 , P.ID,  NVL( I.TRAMOS, '0')
FROM PROFESORES P LEFT OUTER JOIN INVESTIGADORES I ON (P.ID=I.ID_PROFESOR);

--EJERCICIO 3: Pareja de profesores que comparten teléfono. Si no tienen teléfono, se considera que el teléfono es el mismo y deben emparejarse también. De 
--cada profesor sólo queremos el apellido 1. No muestre información duplicada

SELECT DISTINCT P1.APELLIDO1 "PRIMER PROFESOR" ,P2.APELLIDO1 "SEGUNDO PROFESOR"
FROM PROFESORES P1 JOIN PROFESORES P2  
ON ( P1.ID < P2.ID AND P1.TELEFONO=P2.TELEFONO) OR (P1.TELEFONO IS NULL AND P2.TELEFONO IS NULL 
AND P1.ID<P2.ID);

--EJERCICIO 4: LISTAR DNI Y FECHA NACIMIENTO DE LOS TRES ALUMNOS DE MAYOR EDAD, QUE ESTÁN REGISTRADOS EN EL SISTEMA Y NO ESTÁN MATRICULADOS EN NINGUNA
--ASIGNATURA. LOS ALUMNOS SIN FECHA DE NACIMIENTO NO SE TENDRÁ EN CUENTA

select * from( select al.dni, al.FECHA_NACIMIENTO 
from alumnos al 
where al.fecha_nacimiento is not null and al.dni not in
( select alu.dni from alumnos alu,matricular ma where alu.dni = ma.alumno) 
order by al.fecha_nacimiento) where rownum<4