--caso 1
SELECT sueldo_base, ROUND((TRUNC(sueldo_base / 100000) / 100) * sueldo_base), TRUNC(sueldo_base / 100000)
FROM empleado;

SELECT e.pnombre_emp, c.nombre_comuna, e.numrun_emp
FROM empleado e JOIN comuna c USING(id_comuna)
WHERE id_comuna = &id; --IN (117, 118, 119, 120, 121); 

--12868553 Patrcicia

VAR b_anno_proceso number;
VAR b_comuna NUMBER;
VAR b_comision NUMBER;
VAR b_run NUMBER;

EXEC :b_anno_proceso := 2021;
EXEC :b_comuna := 117;
EXEC :b_run := 12868553;
EXEC :b_comision := 20000;

DECLARE
    v_nombre_empleado VARCHAR(120);
    v_numrun_empleado NUMBER(10, 0);
    v_divrun_empleado VARCHAR(1);
    v_sueldo NUMBER(7, 0);
    v_valor_movil NUMBER(7, 0);
    v_porc_movil NUMBER(2, 0);
    v_valor_total_movil NUMBER(7, 0);
BEGIN
    SELECT pnombre_emp || ' ' || snombre_emp || ' ' || appaterno_emp || ' ' || apmaterno_emp, sueldo_base, numrun_emp, dvrun_emp
    INTO v_nombre_empleado, v_sueldo, v_numrun_empleado, v_divrun_empleado
    FROM empleado
    WHERE numrun_emp = :b_run;

    v_porc_movil := TRUNC(v_sueldo / 100000);
    v_valor_movil := ROUND((v_porc_movil / 100) * v_sueldo);
    v_valor_total_movil := v_valor_movil + :b_comision;
    
    INSERT INTO proy_movilizacion (anno_proceso, numrun_emp, dvrun_emp, nombre_empleado, sueldo_base, porc_movil_normal, valor_movil_normal, 
                                       valor_movil_extra, valor_total_movil )
    VALUES (:b_anno_proceso, v_numrun_empleado, v_divrun_emp, v_nombre_empleado, v_sueldo, v_porc_movil, v_valor_movil, :b_comision, v_valor_total_movil);
COMMIT;
END;

--CASO 2
DECLARE
    v_nombre_usuario VARCHAR2(25);
    v_clave_usuario VARCHAR(40);
    v_nombre_emp VARCHAR(120);
    v_mes_anno NUMBER(6, 0);
    v_numrun_emp NUMBER(9, 0);
    v_dvun_emp VARCHAR(1);
BEGIN
    SAVEPOINT A;
    INSERT INTO usuario_clave (nombre_usuario, clave_usuario, nombre_empleado, numrun_emp, dvrun_emp, mes_anno)
        VALUES(SELECT SUBSTR(pnombre_emp, 0, 3) || LENGTH(pnombre_emp) || '*' || SUBSTR(sueldo_base, -1) || dvrun_emp ||
            TO_NUMBER(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM fecha_contrato)) ||    
             CASE WHEN TO_NUMBER(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM fecha_contrato)) < 10 THEN 'x' END,
                    SUBSTR(numrun_emp, 3, 1) || TO_NUMBER(EXTRACT(YEAR FROM fecha_nac)) + 2 || SUBSTR(sueldo_base, -3) - 1 ||
                        CASE 
                            WHEN id_estado_civil = 20 OR id_estado_civil = 60 THEN SUBSTR(appaterno_emp, 1, 2)
                            WHEN id_estado_civil = 20 OR id_estado_civil = 30 THEN  SUBSTR(appaterno_emp, 1) || SUBSTR(appaterno_emp, -1)
                            WHEN id_estado_civil = 40 THEN SUBSTR(appaterno_emp, -3, 1) || SUBSTR(appaterno_emp, -2, 1)
                            WHEN id_estado_civil = 50 THEN SUBSTR(appaterno_emp, -2, 2)
                            END
                        || TO_NUMBER(EXTRACT(MONTH FROM SYSDATE)) || TO_NUMBER(EXTRACT(YEAR FROM SYSDATE)) || SUBSTR(comuna.nombre_comuna, 1, 1),
                            pnombre_emp || ' ' || snombre_emp || ' ' || appaterno_emp || ' ' || apmaterno_emp, numrun_emp, dvrun_emp,
                                EXTRACT(MONTH FROM SYSDATE) || EXTRACT(YEAR FROM SYSDATE)     
    FROM empleado
    JOIN comuna 
    USING(id_comuna)
    WHERE empleado.numrun_emp = &run);
    ROLLBACK TO A;
COMMIT;
END;