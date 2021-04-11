SET SERVEROUTPUT ON;

--Caso 1
SELECT nro_cliente, TO_CHAR(numrun, '999G999G999') || '-' || dvrun, pnombre || ' ' || snombre || ' ' || appaterno || ' ' || apmaterno,
            nombre_tipo_cliente, monto_solicitado
FROM credito_cliente
JOIN cliente
USING(nro_cliente)
JOIN tipo_cliente
USING(cod_tipo_cliente)
WHERE EXTRACT( YEAR FROM fecha_otorga_cred) = EXTRACT(YEAR FROM sysdate) - 1 AND numrun = &run;

SELECT monto_solicitado
FROM credito_cliente
JOIN cliente
USING(nro_cliente)
WHERE numrun = 18858542;

/* sujetos a prueba:
    run: 18858542

*/


VAR b_run NUMBER;
EXEC :b_run := 18858542; 

DECLARE
    v_monto_credito NUMBER(10, 0);
    v_todo_suma NUMBER(8, 0);
    v_nombre VARCHAR(50);
    v_run VARCHAR(15);
    v_nro NUMBER(5, 0);
    v_tipo_cli VARCHAR(30);
BEGIN
    SELECT monto_solicitado
    INTO v_monto_credito
    FROM credito_cliente
    JOIN cliente
    USING(nro_cliente)
    WHERE numrun = :b_run;
    DBMS_OUTPUT.PUT_LINE('monto: ' || v_monto_credito);
    
    IF v_monto_credito < 1000000 THEN
        v_todo_suma := (v_monto_credito / 100000) * 100;
         DBMS_OUTPUT.PUT_LINE('monto: ' || v_todo_suma);
         
    ELSIF v_monto_credito >= 1000000 AND v_monto_credito <= 3000000 THEN
        v_todo_suma := (v_monto_credito / 100000) * 300;
        DBMS_OUTPUT.PUT_LINE('monto: ' || v_todo_suma);
    ELSE
        v_todo_suma := (v_monto_credito / 100000) * 550;
        DBMS_OUTPUT.PUT_LINE('monto: ' || v_todo_suma);
    END IF;
    
    
    
    SELECT nro_cliente, TO_CHAR(numrun, '999G999G999') || '-' || dvrun, pnombre || ' ' || snombre || ' ' || appaterno || ' ' || apmaterno,
            nombre_tipo_cliente
            INTO  v_nro, v_run, v_nombre, v_tipo_cli
            FROM credito_cliente
            JOIN cliente
            USING(nro_cliente)
            JOIN tipo_cliente
            USING(cod_tipo_cliente)
            WHERE EXTRACT( YEAR FROM fecha_otorga_cred) = EXTRACT(YEAR FROM sysdate) - 1 AND numrun = :b_run;
            
    DELETE FROM cliente_todosuma WHERE nro_cliente = v_nro;
    
    INSERT INTO cliente_todosuma
    VALUES(v_nro, v_run, v_nombre, v_tipo_cli, v_monto_credito, v_todo_suma);
    COMMIT;
    
END;