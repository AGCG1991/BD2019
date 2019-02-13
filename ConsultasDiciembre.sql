select A.DNI , A.Fecha_nacimiento, A.fecha_prim_matricula , PR.Nombre, MUN.Nombre
from alumnos A, Provincia PR, Municipio MUN 
where (PR.codigo=A.CPRO) and (A.CMUN=MUN.CMUN) 
and (months_between(sysdate, fecha_prim_matricula)/12) >3
and (upper(to_char(fecha_nacimiento,'month')) like 'J%' OR
upper(to_char(fecha_nacimiento,'month')) like 'AGOSTO%');


--Queremos saber cuántas asignaturas pertenecen a cada materia. 
--Se desea obtener un listado con el nombre de la materia y el número de 
--asignaturas que la componen. Aquellas asignaturas que no tienen materia 
--asignada deben aparecer como pertenecientes a la materia ‘Sin materia asignada

DESC MATERIAS;

select nvl(MM.Nombre,'Sin materia asignada') ,LM."CANTIDAD" FROM 
(SELECT ASI.COD_MATERIA "CODIGO" , COUNT(*) "CANTIDAD"
FROM ASIGNATURAS ASI LEFT JOIN MATERIAS M ON (ASI.COD_MATERIA=M.CODIGO)
GROUP BY ASI.COD_MATERIA) LM
LEFT JOIN MATERIAS MM ON (LM."CODIGO"=MM.CODIGO);


--Obtenga el nombre y dos apellidos de los alumnos a los que no le da clase 
--ningún profesor cuyo nombre empieza por ‘M’

select nombre, apellido1, apellido2 from alumnos where dni not in 
(select a.dni from matricular m, impartir i, profesores p, alumnos a 
where m.asignatura = i.asignatura and m.curso = i.curso and 
m.grupo = i.grupo and m.alumno = a.dni and i.profesor = p.id and p.nombre like 'M%');

--Obtenga nombre y apellidos de parejas de alumnos que tengan apellidos parecidos, 
--pero no iguales. Decimos que dos apellidos son parecidos si solo varían en la última letra. 
--No muestre información duplicada. Use las funciones SUBSTR y LENGTH. 
--La semejanza puede ser entre los primeros apellidos, o entre los segundos. 
--Tenga cuidado con la prioridad de los operadores AND y OR

select A1.nombre , A1.apellido1,a1.APELLIDO2, A2.Nombre, A2.Apellido1, A2.APELLIDO2
from alumnos A1, Alumnos A2
where A1.DNI < A2.DNI 
AND A1.APELLIDO1 <>A2.APELLIDO1 
AND A1.APELLIDO2 <> A2.APELLIDO2
and (( SUBSTR(A1.APELLIDO1,1,LENGTH(A1.APELLIDO1)-1)=SUBSTR(A2.APELLIDO1,1,LENGTH(A2.APELLIDO1)-1))
OR  (SUBSTR(A1.APELLIDO2,1,LENGTH(A1.APELLIDO2)-1)=SUBSTR(A2.APELLIDO2,1,LENGTH(A2.APELLIDO2)-1)));

--Obtenga un listado con el dni y la nota de expediente de los 5 alumnos con mejor expediente. 
--Se calcula la nota de expediente haciendo la media de las calificaciones de las asignaturas que ha aprobado, 
--donde AP vale 1, NT vale 2, SB vale 3 y MH vale 4. Muestre también el expediente redondeado a 2 decimales. 
--Aquellos alumnos que han aprobado menos de 3 asignaturas no deben salir en el listado

select * from
(select alumno "dni", round(avg(decode(calificacion,'AP',1,'NT',2,'SB',3,'MH',4)),2) "nota de expediente" 
from matricular 
where calificacion != 'SP' 
group by alumno 
having count(*) > 2 --filtro que se aplica al group by. Menos de 3
order by 2 DESC ) 
where rownum <= 5;
