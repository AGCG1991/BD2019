--RELACION DML-2: Funciones, Reuniones y operaciones de conjuntos
	
-- ///////////////////////////// REUNIÓN DE TABLAS ///////////////////////////// 

	--SELECT ...FROM a,b ...where ...
	
--1. Nombre y apellidos de los profesores del departamento de Lenguajes.

select P.nombre, P.apellido1, P.apellido2
from profesores P , departamentos D
where P.departamento=D.codigo
and upper(D.nombre) like '%LENGUAJES%';
    --COMENTARIO: Si el número de departamento de la tabla PROFESORES coincide con el código de la tabla departamento
    --significa que esos profesores trabajan en ese mismo departamento, adicionalmente tiene que cumplir que el nombre del departamento
    --contenga la palabra LENGUAJES. Se hace un upper al atributo nombre para dejarlo en mayúscula y que sea comparable
    --el operador LIKE si se usa '% %' , indica que si contiene la palabra 

--2º Usando la función NVL extraiga un listado con el código y el nombre de las asignaturas de las que
--está matriculado 'Nicolas Bersabe Alba'. Proporcione además el número de créditos prácticos, pero
--caso de ser nulo, debe salir "No tiene" en el listado. Indicación: advierta que prácticos es NUMBER y
--el literal 'No tiene' es VARCHAR2.

select AG.nombre, AG.codigo, nvl(to_char(AG.practicos), ' No tiene ' ) "Créditos Practicos"
from alumnos AL, asignaturas AG 
where AL.Nombre ='Nicolas' and AL.apellido1='Bersabe' and AL.apellido2='Alba'
order by AG.Codigo asc;

    --COMENTARIO: El funcionamiento de la función NVL(expr1, expr2) que devuelve expr1 siempre que ésta no sea nula y expr2 en caso contrario
    --Verificamos que el nombre y los dos apellidos sean los dados en el enunciado, desde la tabla alumnos. Como tenemos que mirar el contenido
    --de codigo, alojado en la tabla asignatura, usamos AG.codigo.
    --Si la asignatura no tiene créditos prácticos, devolverá un "no tiene"
    
--3 Para cada profesor perteneciente al departamento “Ingenieria de Comunicaciones”, proporcione el
--número de semanas completas que lleva trabajando en el departamento y diga que día se cumple un
--ciclo de semana completa. Use las funciones TO_CHAR y NEXT_DAY. Tenga en cuenta que si el
--día de la semana donde cumple el ciclo es el día actual, NEXT_DAY le llevará a la siguiente semana,
--cuando debería indicarse que el ciclo se cumple hoy.

select P.nombre, P.apellido1, P.apellido2,
trunc(((sysdate-antiguedad)/7),0) "Antiguedad en semanas",
next_day( sysdate-1, to_char(antiguedad,'day'))
from profesores P , departamentos D
where P.departamento=D.codigo
and upper(D.nombre) like 'INGENIERIA DE COMUNICACIONES';
    --COMENTARIO A: La función to_char, convierte una fecha a una cadnea o un número con el formato especificado
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
        
-- 4. Alumnos que tengan aprobada la asignatura 'Bases de Datos'.


select AL.Nombre, AL.Apellido1, AL.Apellido2 
from alumnos AL, matricular M, asignaturas A
where (( AL.DNI=M.ALUMNO) and (M.asignatura=A.codigo) AND upper(A.nombre)='BASES DE DATOS') 
and M.CALIFICACION!='SP';
        --COMENTARIO B: En este caso, suponemos que no tenemos conocimiento del código de asignatura y debemos de hacer mas comprobaciones
        --como la de que el M.asignatura=A.codigo , además debemos de comprobar de que el nombre de la asignatura es BASES DE DATOS
        --adicionalmente, comprobamos que nos muestre todas las calificaciones excepto SP que se trata de los suspensos

--5º Obtenga un listado en el que aparezcan el identificador de los profesores, su nombre y apellidos así
--como el código de las asignaturas que imparte y su nombre.
        
select P.nombre, P.apellido1, P.apellido2, p.id "Identificador profesor", A.CODIGO "Identificador asignatura", A.nombre "Nombre asignatura"
from profesores P , Impartir I , asignaturas A
WHERE(P.ID=I.PROFESOR) and I.ASIGNATURA=A.CODIGO;

select p.id, p.nombre, p.apellido1, p.apellido2, i.asignatura codigo, asig.nombre asignatura
from profesores p JOIN impartir i ON i.profesor=p.id JOIN asignaturas asig ON asig.codigo=i.asignatura;
    --COMENTARIO B: Alternativa con JOIN
	--Se concatena los JOIN , 1º uno la tabla profesores y la tabla impartir bajo la condición de que el código de profesor debe coincidir
	--es decir, debe de haber una relación entre la asignatura impartida y el profesor.
	--2º el segundo join une lo anterior con la impartición de asginaturas con el nombre de la asignatura.

 -- ///////////////////////////// CONSULTAS REFLEXIVAS ///////////////////////////// 
 
		--SELECT ...FROM A,A ...WHERE ...
 
--6º Nombre y edad de parejas de alumnos que tengan el mismo primer apellido.

select a1.nombre "Alumno 1" , TRUNC(months_between(sysdate,a1.fecha_nacimiento)/12) "Edad 1", 
a2.nombre "Alumno 2" , TRUNC(months_between(sysdate,a2.fecha_nacimiento)/12) "Edad 2"
from alumnos a1,alumnos a2
where UPPER(a1.apellido1)=UPPER(a2.apellido1) AND a1.dni<a2.dni;
	--COMENTARIO A: Hacemos una doble consulta a la misma tabla, pero como son elementos diferenciados (distintas personas, las cuales coinciden en el 
	--primer apellido). En primer lugar, las diferenciamos con A1 y A2. Una vez consultados y expresada la edad en años
	--pasamos a la restricción el primer apellido del primer alumno debe de coincidir con el primer apellido del segundo alumno PERO hay que poner una
	--restricción, el DNI debe de ser diferente, pues podría darse el caso que se empareje a los alumnos consigo mismo
	--para ello usamos la expresión a1.dni<a2.dni


--7. Combinaciones de apellidos que se pueden obtener con los primeros apellidos de alumnos nacidos
--entre los años 1995 y 1996, ambos incluidos. Se recomienda utilizar el operador BETWEEN … AND
--para expresar el rango de valores.
select a1.apellido1 apellido1, a2.apellido1 apellido2
from alumnos a1,alumnos a2
where (EXTRACT(year from a1.fecha_nacimiento) BETWEEN 1995 AND 1996) AND
           (EXTRACT(year from a2.fecha_nacimiento) BETWEEN 1995 AND 1996) AND a1.dni<a2.dni;
		   
		   
--8º Nombre y apellidos de parejas de profesores cuya diferencia de antigüedad (en valor absoluto) sea
--inferior a dos años y pertenezcan al mismo departamento. Muestre la antigüedad de cada uno de ellos
--en años

Select P1.nombre, P1.APELLIDO1, P1.APELLIDO2 , P2.nombre, P2.APELLIDO1, P2.APELLIDO2 
FROM PROFESORES P1, PROFESORES P2 
WHERE ABS(TRUNC(MONTHS_BETWEEN(P1.ANTIGUEDAD,P2.ANTIGUEDAD)/12))<2  --Calcula la diferencia de fechas
AND P1.ID < P2.ID
AND(P1.DEPARTAMENTO=P2.DEPARTAMENTO);
		--COMENTARIO A: Usamos ABS para dejarlo como valor absoluto, tenemos que comprobar de que no son el mismo profesor con la restricción P1.ID < P2.ID	
		--Y COMPROBAR que pertenecen al mismo departamento

SELECT P1.nombre, P1.APELLIDO1, P1.APELLIDO2 , P2.nombre, P2.APELLIDO1, P2.APELLIDO2 
FROM PROFESORES P1 JOIN PROFESORES P2 ON ABS(TRUNC(MONTHS_BETWEEN(P1.ANTIGUEDAD,P2.ANTIGUEDAD)/12))<2 AND P1.ID < P2.ID
AND(P1.DEPARTAMENTO=P2.DEPARTAMENTO);
		--COMENTARIO B: CON JOIN
		
		--9º Construya un listado en el que se muestren todos los posibles emparejamientos heterosexuales que se
--pueden formar entre los alumnos matriculados en la asignatura de código 112 donde la nota de la
--mujer es mayor que la del hombre y ambos se matricularon en la misma semana. En el listado
--muestre primero el nombre de la mujer y a continuación el del hombre. Etiquete las columnas como
--"Ella" y "El" respectivamente. Para el cálculo de la semana use la función de conversión TO_CHAR.

select A1.NOMBRE || ''|| A1.APELLIDO1 || ''|| A1.APELLIDO2 "ELLA",
       A2.NOMBRE || ''|| A2.APELLIDO1 || ''|| A2.APELLIDO2 "EL"
from Alumnos A1 , Alumnos A2, MATRICULAR M1, MATRICULAR M2
    WHERE A1.DNI=M1.ALUMNO AND A2.DNI=M2.ALUMNO AND M1.ASIGNATURA=112 AND M2.ASIGNATURA=112
    AND A1.GENERO ='FEM' AND A1.GENERO!=A2.GENERO AND
    TO_CHAR(A1.FECHA_PRIM_MATRICULA, 'WW')=TO_CHAR(A2.FECHA_PRIM_MATRICULA,'WW')
    AND DECODE (M1.CALIFICACION, 'MH',10,'SB',9,'NT',8,'AP',5,'SP',3,0) > DECODE(M2.CALIFICACION, 'MH',10,'SB',9,'NT',8,'AP',5,'SP',3,0);
	
	--COMENTARIO A: 1º CONCATENAMOS LA SALIDA DEL SELECT CON || '' || , 2º COMPROBAMOS QUE EL DNI DE LOS ALUMNOS COINCIDE CON LOS MATRICULADOS Y A SU VEZ
	--QUE ESTOS MATRICULADOS PERTENECEN A LA ASIGNATURA CUYO CÓDIGO ES LA 112 . 3º COMPROBAMOS QUE EL GÉNERO ES FEMENINO Y QUE ES DISTINTO a la segunda pareja
	--de este modo, sabemos que nos saldrá un hombre. 4º EXTRAEMOS LA FECHA DE LA SEMANA EN QUE SE MATRICULARON (OJO USAMOS WW= Week of year ) 
	--5º COMO NOS PIDEN QUE MOSTREMOS LOS CASOS EN LOS QUE LA NOTA DE LA MUJER ES MAYOR QUE LA DEL HOMBRE, USAMOS EL DECODE.


--10 º Tríos de asignaturas pertenecientes a la misma materia. Debe presentarse el nombre de las 3
--asignaturas seguido del código de la materia a la que pertenecen.

select AS1.NOMBRE "ASIGNATURA 1" , AS2.NOMBRE "ASIGNATURA 2" , AS3.NOMBRE "ASIGNATURA 3" , AS1.COD_MATERIA 
from ASIGNATURAS AS1, ASIGNATURAS AS2, ASIGNATURAS AS3
WHERE AS1.COD_MATERIA=AS2.COD_MATERIA AND AS1.COD_MATERIA=AS3.COD_MATERIA AND AS2.COD_MATERIA=AS3.COD_MATERIA 
AND AS1.CODIGO <AS2.CODIGO AND AS1.CODIGO<AS3.CODIGO AND AS2.CODIGO<AS3.CODIGO;


-- ///////////////////////////// REUNION DE TABLAS + ORDEN /////////////////////////////
--11.Muestre el nombre, apellidos, nombre de la asignatura y las notas obtenidas por todos lo alumnos con
--más de 22 años. Utilice la función DECODE para mostrar la nota como (Matricula de Honor,
--Sobresaliente, Notable, Aprobado, Suspenso o No Presentado). Ordene por apellidos y nombre del
--alumno.
select A1.nombre, A1.apellido1, A1.apellido2, ASIG.Nombre "NOMBRE ASIGNATURA" , M.CALIFICACION "NOTAS"
FROM ALUMNOS A1 
JOIN MATRICULAR M ON (A1.DNI=M.ALUMNO) AND (TRUNC(MONTHS_BETWEEN(SYSDATE,FECHA_NACIMIENTO)/12,0) > 22)
JOIN ASIGNATURAS ASIG ON (M.ASIGNATURA=ASIG.CODIGO) 
ORDER BY A1.APELLIDO1, A1.APELLIDO2, A1.NOMBRE;
			--COMENTARIO A: SIN FUNCIÓN DECODE
				--CONCATENAMOS UNIONES BAJO UNA RESTRICCIÓN ALUMNOS A1 JOIN MATRICULAR M ON CONDICIONES

select A1.nombre, A1.apellido1, A1.apellido2, ASIG.Nombre "NOMBRE ASIGNATURA" , 
DECODE(m.calificacion, 
                             'MH', 'Matrícula de honor',
                             'SB', 'Sobresaliente', 
                             'NT', 'Notable',  
                             'AP', 'Aprobado',
                             'SP', 'Suspenso',
                             null, 'No presentado') "NOTAS"
FROM ALUMNOS A1 
JOIN MATRICULAR M ON (A1.DNI=M.ALUMNO) AND (TRUNC(MONTHS_BETWEEN(SYSDATE,FECHA_NACIMIENTO)/12,0) > 22)
JOIN ASIGNATURAS ASIG ON (M.ASIGNATURA=ASIG.CODIGO) 
ORDER BY A1.APELLIDO1 , A1.APELLIDO2, A1.NOMBRE;
		--COMENTARIO B: CON FUNCIÓN DECODE , LA IDEA ES QUE EN VEZ DE MOSTRAR SU ACORTAMIENTO, MUESTRE LA PALABRA COMPLETA 
		
		
--12.Nombre y apellidos de todos los alumnos a los que les de clase Enrique Soler. Tenga en cuenta que
--hay que utilizar los atributos ASINGNATURA, GRUPO y CURSO de las tablas IMPARTIR y
--MATRICULAR. Cada alumno debe aparecer una sola vez. Ordénelos por apellidos, nombre.


select DISTINCT al.nombre, al.apellido1, al.apellido2                     
from asignaturas a, matricular m, alumnos al, impartir i, profesores p
where a.codigo=m.asignatura AND al.dni=m.alumno 
AND i.asignatura=a.codigo AND i.curso=m.curso AND i.grupo=m.grupo AND i.profesor=p.id AND p.nombre='Enrique' AND p.apellido1= 'Soler'
order by al.apellido1, al.apellido2, al.nombre;

	--COMENTARIO A: Usamos el operador distinct porque no queremos que se repitan alumnos, 
	--"Recupera las filas de una tabla eliminando los valores de la columna duplicados"
	
		--SELECT DISTINCT columna1, columna2,....
		--FROM nombre-tabla1, nombre-tabla2
		--[GROUP BY columna1, columna2....]
		--[HAVING condición-selección-grupos]
		--[ORDER BY columna1 [DESC], columna2 [DESC]...
		
--13 Nombre y apellidos de los alumnos matriculados en asignaturas impartidas por profesores del
--departamento de 'Lenguajes y Ciencias de la Computación'. El listado debe estar ordenado
--alfabéticamente
select DISTINCT A.nombre, A.apellido1, A.apellido2 
from alumnos A 
JOIN Matricular M ON (A.DNI = M.ALUMNO)
JOIN IMPARTIR I ON (I.ASIGNATURA=M.ASIGNATURA) 
JOIN ASIGNATURAS ASIG ON (I.ASIGNATURA=ASIG.CODIGO) 
JOIN DEPARTAMENTOS D ON (ASIG.DEPARTAMENTO=D.CODIGO) AND  UPPER(D.NOMBRE)='LENGUAJES Y CIENCIAS DE LA COMPUTACION' 
ORDER BY A.APELLIDO1, A.APELLIDO2, A.NOMBRE;		

--14.Listado con el nombre de las asignaturas, nombre de la materia a la que pertenece y nombre, apellidos
--y carga de créditos de los profesores que la imparten. El listado debe estar ordenado por código de
--materia y por orden alfabético inverso del nombre de asignatura.

SELECT  ASIG.NOMBRE "Nombre Asignatura" , M.NOMBRE "Nombre Materia" ,P.NOMBRE ||'' || P.APELLIDO1 ||''|| P.APELLIDO2 "PROFESOR" ,I.CARGA_CREDITOS
FROM ASIGNATURAS ASIG 
JOIN IMPARTIR I ON (ASIG.CODIGO=I.ASIGNATURA) AND (I.CARGA_CREDITOS IS NOT NULL)
JOIN PROFESORES P ON (P.ID=I.PROFESOR) 
JOIN MATERIAS M ON (M.CODIGO=ASIG.COD_MATERIA)
ORDER BY M.CODIGO , ASIG.NOMBRE DESC; -- ¿PORQUÉ DA ERROR AL INTENTAR ORDENARLO POR EL CÓDIGO MATERIA? M.CODIGO ->EL fallo era que usaba un distinct


--15º Listado con el nombre de asignatura, nombre de departamento al que está asignada, total de créditos y
--porcentaje de créditos prácticos, ordenado decrecientemente por el porcentaje de créditos prácticos.
--Aquellas asignaturas cuyo número de créditos totales, prácticos o teóricos no está especificado no
--deben salir en el listado.

select ASIG.NOMBRE, D.NOMBRE, ASIG.CREDITOS , ROUND((ASIG.TEORICOS*100)/CREDITOS,0) "PORCENTAJE CREDITOS TEORICOS" , ROUND((ASIG.PRACTICOS*100)/CREDITOS,0) "PORCENTAJE CREDITOS TEORICOS"
FROM ASIGNATURAS ASIG 
JOIN DEPARTAMENTOS D ON (ASIG.DEPARTAMENTO=D.CODIGO) AND (CREDITOS IS NOT NULL) AND (PRACTICOS IS NOT NULL) AND (TEORICOS IS NOT NULL)
ORDER BY  ROUND((ASIG.PRACTICOS*100)/CREDITOS,0)  DESC;

--  ****************************** OPERACIONES DE CONJUNTOS *********************************************
-- ///////////////////////////// (SELECT …) UNION/MINUS/INTERSECT (SELECT …)/////////////////////////////

--16.Utilice las operaciones de conjuntos para extraer los códigos de las asignaturas que no son impartidas
--por ningún profesor

select a.codigo 
from asignaturas a 
MINUS (select a.codigo
			from asignaturas a, impartir i, profesores p
			where a.codigo=i.asignatura AND P.ID=I.PROFESOR);

--17.Muestre todos los emails almacenados en la base de datos (tablas de Profesores y Alumnos). Si un
--email aparece repetido en dos tablas distintas también deberá aparecer repetido en la consulta. Evite
--los NULL.

SELECT P.EMAIL FROM PROFESORES P 
WHERE P.EMAIL IS NOT NULL 
UNION ALL (SELECT A.EMAIL 
FROM ALUMNOS A 
WHERE A.EMAIL IS NOT NULL);


--18.Utilice las operaciones de conjuntos para buscar alumnos que puedan ser familia de algún profesor, es
--decir, su primer o segundo apellido es el mismo que el primer o segundo apellido de un profesor
--aunque no necesariamente en el mismo orden. Muestre simplemente los apellidos comunes.


(select p.apellido1
from profesores p
where p.apellido1 is not null
union
select p.apellido2
from profesores p
where p.apellido2 is not null)
intersect
(select a.apellido1
from alumnos a
where a.apellido1 is not null
union
select a.apellido2
from alumnos a
where a.apellido2 is not null);

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
WHERE UPPER(P.APELLIDO1) LIKE '%ll%')
UNION
(select P.Apellido2 
from PROFESORES P
WHERE UPPER(P.APELLIDO2) LIKE '%ll%');

---20º Idem que la anterior pero sustituya la 'll' por una 'y'. Utilice REPLACE.
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

			--COMENTARIO A: replace (atributo,'Frase que buscar','Frase reemplazo')
			--usamos el upper dentro de replace, pues hay apellidos que están en mayúsculas, así no discriminamos 
			--OJO. NO CONCUERDA CON "select * from sol_2_20" , en la solución hay casos en los que no se modifica la LL

-- *****************************              REUIONES EXTERNAS 							  ***************************		
	
-- ///////////////////////////// Select … from … a (LEFT/RIGHT) OUTER JOIN b … ON () where … /////////////////////////////

--21.Busque una incongruencia en la base de datos, es decir, asignaturas en las que el número de créditos
--teóricos + prácticos no sea igual al número de créditos totales. Muestre también los profesores que
--imparten esas asignaturas.

select A.nombre "Nombre Asignatura" , I.PROFESOR "PROFESOR"
FROM ASIGNATURAS A LEFT OUTER JOIN IMPARTIR I
ON (I.ASIGNATURA=A.CODIGO)
WHERE (NVL(A.TEORICOS,0) +NVL(A.PRACTICOS,0)) !=NVL(A.CREDITOS,0);

--LEFT OUTER, TRAE TODO LO DE LA TABLA IZQUIERDA (EN ESTE CASO ASIGNATURAS) Y TODO LOS DE LA DERECHA QUE CUMPLAN LA CONDICIÓN
--USO NVL, si el valor no es nulo, nos devuelve expr1 obteniendo los créditos, en caso contrario nos da 0, si la suma entre 
--los prácticos y los teóricos es diferente a los créditos (totales), entonces me los muestra

--22.Muestre en orden alfabético los nombres completos de todos los profesores y a su lado el de sus
--directores si es el caso (si no tenemos constancia de su director de tesis dejaremos este espacio en
--blanco, pero el profesor debe aparecer en el listado).

select P1.nombre ||' '|| P1.APELLIDO1 || ' ' || P1.APELLIDO2 "PROFESORES" , 
nvl(P2.NOMBRE, ' ') || ' ' || NVL(P2.APELLIDO1, ' ') ||' '|| NVL(P2.APELLIDO2, ' ') "DIRECTORES DE TESIS"
FROM PROFESORES P1 LEFT OUTER JOIN PROFESORES P2 ON P1.DIRECTOR_TESIS=P2.ID
ORDER BY P1.APELLIDO1, P1.APELLIDO2 ,P1.NOMBRE  ;

	--COMENTARIO A: En este caso, tenemos en cuenta que un profesor a su vez puede ser director de tesis de otro profesor
	--por ello, hacemos una consulta reflexiva sobre profesores, seleccionamos todos los nombre de profesores (tabla izquierda) 
	--y añadimos todos los profesores que cumplan la condición (QUE SU ID DE DIRECTOR DE TESIS COINCIDA CON EL ID DE PROFESOR) ,P1.DIRECTOR_TESIS=P2.ID
	
--23 º Muestre el nombre y apellidos de cada profesor junto con los de su director de tesis y el número de
--tramos de investigación del director. Recuerde que el director de tesis de un profesor viene dado por
--el atributo DIRECTOR_TESIS y el número de tramos se encuentra en la tabla INVESTIGADORES.
--Los nombres de cada profesor y su director deben aparecer con el siguiente formato: 'El Director de
--Angel Mora Bonilla es Manuel Enciso Garcia-Oliveros'.	


	select ('El director de' ||' '|| p.nombre ||' '|| p.apellido1 ||' '|| p.apellido2 ||' es '|| 
	NVL(d.nombre, ' ') ||' '|| NVL(d.apellido1, ' ') ||' '|| NVL(d.apellido2, ' ')) "TESIS", 
	NVL(i.tramos, '0') tramos       
	from profesores p, profesores d LEFT OUTER JOIN investigadores i ON i.id_profesor=d.id
	where p.director_tesis=d.id
	order by p.apellido1, p.apellido2;

--24.Liste el nombre de todos los alumnos ordenados alfabéticamente. Si dicho alumno tuviese otro
--alumno que se ha matriculado exactamente a la vez que él, muestre el nombre de este segundo
---alumno a su lado.

select ( A1.NOMBRE || ' '|| A1.APELLIDO1 ||' '|| A1.APELLIDO2 ) "ALUMNOS" ,( A2.NOMBRE || ' '|| A2.APELLIDO1 ||' '|| A2.APELLIDO2) "ALUMNOS 2" 
FROM ALUMNOS A1
LEFT OUTER JOIN  ALUMNOS A2 ON ( A1.FECHA_PRIM_MATRICULA=A2.FECHA_PRIM_MATRICULA) AND (A1.DNI != A2.DNI);

--25.Listado con el nombre de todas las asignaturas. En caso de que exista, para cada asignatura se
--muestra el curso, grupo y nombre y primer apellido del profesor que la imparte.

select ASIG.NOMBRE, NVL(I.CURSO,' ') "CURSO" , NVL(I.GRUPO,' ') "GRUPO" , NVL(P.NOMBRE, ' ') || ' '|| NVL(P.APELLIDO1,' ') || ' '|| NVL(P.APELLIDO2, ' ') "PROFESORES"
FROM ASIGNATURAS ASIG LEFT OUTER JOIN IMPARTIR I
ON (ASIG.CODIGO=I.ASIGNATURA) 
LEFT OUTER JOIN PROFESORES P ON (P.ID=I.PROFESOR);

--  ****************************** SUBCONSULTAS  *********************************************
-- ///////////////////////////// Select … from … where … (NOT) IN/EXISTS (select …) /////////////////////////////

--26.Nombres e identificador de los profesores que no imparten grupo actualmente
SELECT P.NOMBRE , P.ID
FROM PROFESORES P
WHERE P.ID NOT IN (SELECT P.ID FROM PROFESORES P JOIN IMPARTIR I ON P.ID=I.PROFESOR);

		--COMENTARIO A: EN PRIMER LUGAR, HAGO UNA CONSULTA DE NOMBRE E ID DE LOS PROFESORES DENTRO DE LA TABLA PROFESORES
		--Y LUEGO HAGO UNA SUBCONSULTA DONDE COMPRUEBO QUE EL ID DEL PROFESOR COINCIDE CON EL DE LOS PROFESORES QUE IMPARTE 
		--(NO ESTAR EN IMPARTIR, SIGNIFICA QUE NO IMPARTE CLASES ACTUALMENTE), PUES ESTA CONSULTA LA NIEGO, PIDIENDO JUSTO LO CONTRARIO
		
--27.Nombre y apellidos de 2 alumnas matriculadas de la asignatura de código 115 . Use ROWNUM para filtrar el número de tuplas que se desea (2 en este caso). 
--Las tuplas repetidas deben filtrarse también.
	SELECT A.NOMBRE , A.APELLIDO1, A.APELLIDO2
	FROM ALUMNOS A 
	WHERE EXISTS (SELECT * FROM MATRICULAR M
                WHERE A.DNI=M.ALUMNO AND A.GENERO='FEM' AND M.ASIGNATURA='115')
                AND ROWNUM < 3;
				
				
                --EXISTS conjunto_tuplas La expresión es cierta si el conjunto de tuplas no está vacío. Es decir, existe al menos una tupla en el conjunto.
--28 Muestre todos los datos de los profesores que no son directores de tesis
    
select *
from profesores p
where p.id NOT IN (select p2.id
                   	          from profesores p1 , profesores p2
                                 where p1.director_tesis=p2.id);
								 
--29.Liste el nombre y código de las asignaturas que tienen en su mismo curso otra con más créditos que
--ella

select a.nombre, a.codigo from asignaturas a
where (a.nombre in (select a.nombre 
                    from asignaturas b 
                    where NVL(b.creditos,0) > NVL(a.creditos,0) and NVL(a.curso,0)=NVL(b.curso,0)));
								 
--30.Use las operaciones de conjuntos y la consulta anterior para mostrar las asignaturas que tienen el
--máximo número de créditos de su curso.
select a.nombre,a.codigo
from asignaturas a

minus 

select a.nombre, a.codigo from asignaturas a
where (a.nombre in (select a.nombre 
                    from asignaturas b 
                    where NVL(b.creditos,0) > NVL(a.creditos,0) and NVL(a.curso,0)=NVL(b.curso,0)))








--****************OJO: SI QUIERO MIRAR LA SOLUCIÓN DE LA CONSULTA (LA VISTA) , USAMOS select * from sol_1_2 , DONDE EL PRIMER NÚMERO ES LA RELACIÓN Y EL SEGUNDO
--				       EL NÚMERO DEL EJERCICIO.
