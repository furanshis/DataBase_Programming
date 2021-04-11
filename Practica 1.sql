SET SERVEROUTPUT ON;
--Caso 1
VAR b_porcentaje_bono NUMBER;
VAR b_run_empleado NUMBER;
EXEC :b_run_empleado := 11846972;
EXEC :b_porcentaje_bono := 40;

DECLARE
    v_nombre_emp VARCHAR2(65);
    v_sueldo_emp empleado.sueldo_emp%TYPE;
    v_run_emp empleado.numrut_emp%TYPE;
    v_dvrun_emp empleado.dvrut_emp%TYPE;
    v_bonificacion NUMBER(6);
BEGIN
    SELECT nombre_emp || ' ' || apmaterno_emp || ' ' || appaterno_emp, numrut_emp, dvrut_emp ,sueldo_emp
    INTO v_nombre_emp, v_run_emp, v_dvrun_emp ,v_sueldo_emp
    FROM empleado
    WHERE numrut_emp = :b_run_empleado;
    v_bonificacion := v_sueldo_emp * (:b_porcentaje_bono / 100);
    
    DBMS_OUTPUT.PUT_LINE('DATOS CALCULADOS DE BONIFICACION EXTRA DEL ' || :b_porcentaje_bono || '% ' || 'DEL SUELDO');
    DBMS_OUTPUT.PUT_LINE('Nombre del empleado: ' || v_nombre_emp);
    DBMS_OUTPUT.PUT_LINE('Run del empleado: ' || v_run_emp || '-' || v_dvrun_emp);
    DBMS_OUTPUT.PUT_LINE('Sueldo: ' || TO_CHAR(v_sueldo_emp, '$999G999'));
    DBMS_OUTPUT.PUT_LINE('Bonificacón extra: ' || TO_CHAR(v_bonificacion, '$999G999'));
END;

--Caso 2

SELECT c.nombre_cli || ' ' || c.appaterno_cli || ' ' || c.apmaterno_cli, TO_CHAR(c.numrut_cli) || '-' || c.dvrut_cli, ec.desc_estcivil, c.renta_cli
FROM cliente c JOIN estado_civil ec USING(id_estcivil);

SELECT c.nombre_cli || ' ' || c.appaterno_cli || ' ' || c.apmaterno_cli, TO_CHAR(c.numrut_cli) || '-' || c.dvrut_cli, ec.desc_estcivil, c.renta_cli
FROM cliente c JOIN estado_civil ec USING(id_estcivil);


DECLARE
    v_nombre_cli VARCHAR2(55);
    v_run_cliente VARCHAR2(12);
    v_renta_cliente NUMBER(7, 0);
    v_estado_civil VARCHAR2(25);
BEGIN
    SELECT nombre_cli || ' ' || appaterno_cli || ' ' || apmaterno_cli, numrut_cli || '-' || dvrut_cli, desc_estcivil, renta_cli
    INTO v_nombre_cli, v_run_cliente, v_estado_civil, v_renta_cliente
    FROM cliente JOIN estado_civil USING(id_estcivil)
    WHERE numrut_cli = &run;

    DBMS_OUTPUT.PUT_LINE('DATOS DEL CLIENTE');
    DBMS_OUTPUT.PUT_LINE('----------------------');
    DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || v_nombre_cli);
    DBMS_OUTPUT.PUT_LINE('RUN: ' || v_run_cliente);
    DBMS_OUTPUT.PUT_LINE('ESTADO CIVIL: ' || v_estado_civil);
    DBMS_OUTPUT.PUT_LINE('RENTA: ' || TO_CHAR(v_renta_cliente, '$999G999'));
END;



--caso 3
--11636534
--11999100

SELECT nombre_emp || ' ' || appaterno_emp || ' ' || apmaterno_emp, numrut_emp || '-' || dvrut_emp, sueldo_emp
FROM empleado;

SELECT nombre_emp || ' ' || appaterno_emp || ' ' || apmaterno_emp, numrut_emp || '-' || dvrut_emp, sueldo_emp
FROM empleado
WHERE sueldo_emp >= 200000 AND sueldo_emp <= 400000 AND numrut_emp = 11999100;

DECLARE
    v_nombre_emp VARCHAR(55);
    v_run_emp VARCHAR(12);
    v_sueldo_actual NUMBER(7, 0);
    v_sueldo_nuevo NUMBER(7, 0);
    v_reajuste NUMBER(7, 0);
    
    v_sueldo_actual2 NUMBER(7, 0);
    v_sueldo_nuevo2 NUMBER(7, 0);
    v_reajuste2 NUMBER(7, 0);
BEGIN
    SELECT nombre_emp || ' ' || appaterno_emp || ' ' || apmaterno_emp, numrut_emp || '-' || dvrut_emp, sueldo_emp
    INTO v_nombre_emp, v_run_emp, v_sueldo_actual
    FROM empleado
    WHERE numrut_emp = 11999100;
    
    v_reajuste := (v_sueldo_actual * (&porsentaje / 100));
    v_sueldo_nuevo := v_sueldo_actual + v_reajuste;
    
    SELECT sueldo_emp
    INTO v_sueldo_actual2
    FROM empleado
    WHERE sueldo_emp >= 200000 AND sueldo_emp <= 400000 AND numrut_emp = 11999100;
    
    v_reajuste2 := (v_sueldo_actual2 * (&porsentaje2 / 100));
    v_sueldo_nuevo2 := v_sueldo_actual2 + v_reajuste2;  
    
    DBMS_OUTPUT.PUT_LINE('Nombre del empleado: ' || v_nombre_emp); 
    DBMS_OUTPUT.PUT_LINE('RUN: ' || v_run_emp);
    DBMS_OUTPUT.PUT_LINE('Simulación 1:  aumentará para todos los empleados en un 8,5%');
    DBMS_OUTPUT.PUT_LINE('sueldo actual: ' || TO_CHAR(v_sueldo_actual, '$999G999G999'));
    DBMS_OUTPUT.PUT_LINE('sueldo reajustado: ' || TO_CHAR(v_sueldo_nuevo, '$999G999G999')); 
 
    DBMS_OUTPUT.PUT_LINE('Simulación 2:  aumentará en un 20 para los empleados con sueldo mayor o igual a $200.000 y menor o
igual a $400.000');
    DBMS_OUTPUT.PUT_LINE('sueldo actual: ' || TO_CHAR(v_sueldo_actual2, '$999G999G999'));
    DBMS_OUTPUT.PUT_LINE('sueldo reajustado: ' || TO_CHAR(v_sueldo_nuevo2, '$999G999G999'));    
    
END;


--Caso 4
SELECT COUNT(p.nro_propiedad), SUM(p.valor_arriendo), tp.desc_tipo_propiedad
FROM propiedad p JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id_tipo_propiedad
WHERE tp.id_tipo_propiedad = '&id'
GROUP BY desc_tipo_propiedad;

DECLARE
    v_cant_propiedad NUMBER(2, 0);
    v_valor_total_arr number(7, 0);
    v_tipo_propiedad VARCHAR(30);
BEGIN
    SELECT COUNT(p.nro_propiedad), SUM(p.valor_arriendo), tp.desc_tipo_propiedad
    INTO v_cant_propiedad, v_valor_total_arr, v_tipo_propiedad
    FROM propiedad p JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id_tipo_propiedad
    WHERE tp.id_tipo_propiedad = '&id'
    GROUP BY desc_tipo_propiedad;
    
    DBMS_OUTPUT.PUT_LINE('RESUMEN DE: ' || v_tipo_propiedad);
    DBMS_OUTPUT.PUT_LINE('Cantidad de propiedad: ' || v_cant_propiedad);
    DBMS_OUTPUT.PUT_LINE('Valor total arriendo: ' || TO_CHAR(v_valor_total_arr, '$999G999G999'));
END;

