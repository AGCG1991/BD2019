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


--6º Nombre y edad de parejas de alumnos que tengan el mismo primer apellido.

select a1.nombre "Alumno 1" , TRUNC(months_between(sysdate,a1.fecha_nacimiento)/12) "Edad 1", 
a2.nombre "Alumno 2" , TRUNC(months_between(sysdate,a2.fecha_nacimiento)/12) "Edad 2"
from alumnos a1,alumnos a2
where UPPER(a1.apellido1)=UPPER(a2.apellido1) AND a1.dni<a2.dni;
--7. Combinaciones de apellidos que se pueden obtener con los primeros apellidos de alumnos nacidos
--entre los años 1995 y 1996, ambos incluidos. Se recomienda utilizar el operador BETWEEN … AND
--para expresar el rango de valores.
select a1.apellido1 apellido1, a2.apellido1 apellido2
from alumnos a1,alumnos a2
where (EXTRACT(year from a1.fecha_nacimiento) BETWEEN 1995 AND 1996) AND
           (EXTRACT(year from a2.fecha_nacimiento) BETWEEN 1995 AND 1996) AND a1.dni<a2.dni;