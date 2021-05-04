--caso 1 (ARREGLAR!!!!!)
SELECT EXTRACT(YEAR FROM SYSDATE), id_emp, numrun_emp, dvrun_emp, pnombre_emp || ' ' || snombre_emp || ' ' || appaterno_emp 
        || ' ' || apmaterno_emp, nombre_comuna, sueldo_base, TRUNC(sueldo_base / 100000), ROUND(TRUNC(sueldo_base / 100000) / 100 * sueldo_base)
FROM empleado
INNER JOIN comuna
USING(id_comuna);



DECLARE

v_fecha NUMBER := 2021;
v_id NUMBER;
v_numrun NUMBER;
v_dvrun VARCHAR2(1);
v_nombre VARCHAR2(60);
v_comuna VARCHAR2(30);
v_sueldo_base NUMBER;
v_id_comuna NUMBER;
v_porc_movil NUMBER;
v_monto_movil NUMBER;
v_movil_extra NUMBER;
v_monto_total NUMBER;

v_min_id NUMBER := 100;

BEGIN

WHILE v_min_id <= 320 LOOP

    SELECT id_emp, numrun_emp, dvrun_emp, pnombre_emp || ' ' || snombre_emp || ' ' || appaterno_emp 
          || ' ' || apmaterno_emp, nombre_comuna, sueldo_base, id_comuna
    INTO v_id, v_numrun, v_dvrun, v_nombre, v_comuna, v_sueldo_base, v_id_comuna
    FROM empleado
    INNER JOIN comuna
    USING(id_comuna)
    WHERE id_emp = v_min_id;
    
    --monto movil extra según comuna
    IF v_comuna = 117 THEN
        v_movil_extra := 20000;
        
    ELSIF v_comuna = 118 THEN
        v_movil_extra := 25000;
        
     ELSIF v_comuna = 119 THEN
        v_movil_extra := 30000;
    
     ELSIF v_comuna = 120 THEN
        v_movil_extra := 35000;
    
     ELSIF v_comuna = 121 THEN
        v_movil_extra := 40000;
    
    ELSE 
        v_movil_extra := 0;
    END IF;
    
    --porcentaje de sueldo base
    v_porc_movil := TRUNC(v_sueldo_base / 100000);
    
    --monto movil normal
    v_monto_movil := ROUND(v_porc_movil / 100 * v_sueldo_base);
    
    --monto total, monto movil extra más monto movil normal
    v_monto_total := v_monto_movil + v_movil_extra;
    
    --insertar datos a la tabla PROY_MOVILIZACION
    
    
    
    INSERT INTO proy_movilizacion
    VALUES (v_fecha, v_id, v_numrun, v_dvrun, v_nombre, v_comuna, v_sueldo_base, v_porc_movil, v_monto_movil, v_movil_extra, 
            v_monto_total);
    COMMIT;
    
    --sumamos el id del empleado 
    v_min_id := v_min_id + 10;
    
    END LOOP;
END;