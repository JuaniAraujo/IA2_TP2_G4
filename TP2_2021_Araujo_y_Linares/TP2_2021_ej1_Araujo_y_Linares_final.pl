%TP2 2021 ej 1


%A. Axiomas

verificar(todo) :-
    estado(todo,correcto),
    (
    writeln('.Respecto al funcionamiento correcto del piloto:'),
    verificar(piloto_ok),
    writeln('\n.Respecto a si hay una fuga evitable entre Sit y Orificio:'),
    verificar(fuga_evitable_entre_Sit_y_Orif),
    writeln('\n.Respecto a si el espesor de las tuberias es esta por debajo del umbral limite:'),
    verificar(espesor_menor_que_umbral),
    writeln('\n.Respecto a si hay una fuga de gas que puede arreglarse con la llave inglesa:'),
    verificar(se_arregla_fuga_con_llave)
    ).


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% RAMA IZQUIERDA

verificar(espesor_menor_que_umbral) :-
    estado(espesor_menor_que_umbral, correcto), writeln('El estado del equipo debe ser reportado inmediatamente a la Unidad de Inspecciones Tecnicas, dado que el espesor de las Tuberias es peligrosamente bajo.').
 

verificar(espesor_menor_que_umbral) :-
    estado(espesor_menor_que_umbral, incorrecto), writeln('La condicion del equipo es adecuada.').


    
verificar(espesor_menor_que_umbral) :-    
    estado(espesor_menor_que_umbral, desconocido),    
    (       
        (
            estado(valvdeSeg_tuberias_y_junt_sufriendo_consec_desgaste, correcto),
            writeln('Se requiere coordinar para renderizar y pintar el equipo')
        )
        ;
        (
            estado(valvdeSeg_tuberias_y_junt_sufriendo_consec_desgaste, incorrecto),
            writeln('Verificar si el espesor de las tuberias es menor que el umbral limite')
        )
        ; 
        verificar(valvdeSeg_tuberias_y_junt_sufriendo_consec_desgaste)   
    ).



verificar(valvdeSeg_tuberias_y_junt_sufriendo_consec_desgaste) :-
    estado(valvdeSeg_tuberias_y_junt_sufriendo_consec_desgaste, desconocido),
    writeln('Verificar si el cuerpo de la Valvula de Seguridad, las Tuberias y las Junturas han sufrido las consecuencias del desgaste y el oxido').


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% RAMA DERECHA

verificar(se_arregla_fuga_con_llave) :-
    estado(se_arregla_fuga_con_llave, correcto), writeln('La fuga no es reparable. Enviar reporte a la Unidad de Inspecciones Tecnicas').
 

verificar(se_arregla_fuga_con_llave) :-
    estado(se_arregla_fuga_con_llave, incorrecto), writeln('La fuga es reparable con llave. Enviar reporte al Departamento de Reparaciones para que arreglen la falla').


    
verificar(se_arregla_fuga_con_llave) :-    
    estado(se_arregla_fuga_con_llave, desconocido),    
    (       
        (
            estado(fuga_gas_en_junt_pruebaJabon, correcto),
            writeln('Verificar si la fuga se arregla usando la llave inglesa en las juntas')
        )
        ;
        (
            estado(fuga_gas_en_junt_pruebaJabon, incorrecto),
            writeln('La Juntura de la Valvula de Seguridad esta libre de fugas de gas')
        )
        ; 
        verificar(fuga_gas_en_junt_pruebaJabon)   
    ).



verificar(fuga_gas_en_junt_pruebaJabon) :-
    estado(fuga_gas_en_junt_pruebaJabon, desconocido),
    writeln('Verificar, mediante la Prueba del Jabon, si hay una fuga de gas en la Juntura').


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


%RAMA CENTRAL-IZQUIERDA

verificar(piloto_ok) :-
    estado(piloto_ok, correcto), writeln('Configurar la Valvula de Seguridad de acuerdo a las instrucciones. Todo OK').
    %si se cumple la condicion de "correcto" del piloto, la "," hace que pase a ejecutarse el siguiente predicado.

%"writeln" es un built-in predicate, incorporado ya en el motor de Prolog, y que lo que hace es imprimir por pantalla un msj
%Comenzamos por las preguntas de las hojas del arbol de decisiones:

verificar(piloto_ok) :-
    estado(piloto_ok, incorrecto), writeln('Hay un problema. Reinstalar el piloto').



verificar(piloto_ok) :-    %este es otro predicado que tmbn verifica el piloto (tiene la misma "cabeza")
    estado(piloto_ok, desconocido),    %predicado que se usa si el estado es "desconocido"; en este caso, para verificarlo, debo conocer el estado del subsistema anterior.
             %Es decir, que "prev..." debe no solo concoerse, sino tambien ser "correcto".
            %Para querer demostrar este pred, el estado del piloto debe ser desconocido Y se debe cumplir alguna de las 2 condiciones;
            %o el estado de prev... debe ser ok, o el estado de prev... es desconocido. Por como esta disenada la KB, se pide una verificacion en ese caso.
    %Dicho de otro modo, antes de verificar el estado del piloto desconocido, decide verificarlo, pero solo si vale la pena. Es decir, si el estado del estado anterior es conocido y correcto

    (       %aqui se declara que se busca demostrar el predicado solo si el estado del piloto es desconocido Y ademas se da alguna de las 2 siguientes condiciones
        (
            estado(prev_fuga_entre_Sit_y_Orif, correcto),
            writeln('Verificar si el piloto funciona correctamente (RAMA IZQ)')
        )
        ;
        (
            estado(prev_fuga_entre_Sit_y_Orif, incorrecto),
            writeln('Reemplazar Sit y Orificio, y colocar la Valvula de Seguridad en el circuito (RAMA IZQ)')
        )
        ; %si no es "correcto", se pide que verifique el siguiente estado, el de "prev_fuga..."
        verificar(prev_fuga_entre_Sit_y_Orif)   %si el estado no es "ok", se pide que verfique el proceso "prev..."
    ).
    %Prolog no me obliga a tener estados dicotomicos. Podrian ser ambos


    %para poder verificar el "prev_fuga_entre_Sit_y_Orif" tengo que conocer "rendim_resorte_valvdeSeg"
verificar(prev_fuga_entre_Sit_y_Orif) :-                %se esta buscando verificar el valor de este nodo, en este predicado
    estado(prev_fuga_entre_Sit_y_Orif, desconocido),
    (
        (   %"si el estado de prevencion es desconocido Y el estado de la valvula es bueno, entonces solicita verificar el estado prevencion"
            estado(rendim_resorte_valvdeSeg, correcto),
            writeln('Verificar correcta Prevencion de fuga entre Sit y Orificio')
        )
        ;
        (   
            estado(rendim_resorte_valvdeSeg, incorrecto),
            writeln('Poner Resorte y Valvula de seguridad en el "servicio" para su revision')
        )
        ;   %si no es "correcto" ni "incorrecto", debemos verificar...
        verificar(rendim_resorte_valvdeSeg)
    ).
    %De que manera verificamos el resorte de la valvula de seguridad?? Con el predicado a continuacion:


verificar(rendim_resorte_valvdeSeg) :-  %se demuestra cuando
    estado(rendim_resorte_valvdeSeg, desconocido),  %el estado es "desconocido" 
    (
        (
            estado(sensores_valvdeControl_bloq, incorrecto),    %y el estado de los sensores de la valvula de control debe ser "no" "bloqueados", escribir...
            writeln('Verificar el Rendimiento del Resorte de la Valvula de Seguridad')
        )
        ;
        (
            estado(sensores_valvdeControl_bloq, correcto),    
            writeln('Limpieza y Revision en las Tuberias de deteccion')
        )
        ;
        verificar(sensores_valvdeControl_bloq)   %si es desconocido el estado de los sensores, los voy a verificar.
    ).



verificar(sensores_valvdeControl_bloq) :-
    estado(sensores_valvdeControl_bloq, desconocido),   %si el estado de los sensores es "desconocido"
    (
        (                                         % Y
            estado(valv_cerrada, incorrecto),   %la valvula NO esta en posicion "Cerrada"
            writeln('Verificar que los sensores de la Valvula de Control esten bloqueados')
        )
        ;
        (                                         
            estado(valv_cerrada, correcto),   %la valvula SI esta en posicion "Cerrada"
            writeln('Poner la Valvula de Seguridad en posicion "Abierto"')
        )
        ;   %SINO....
        verificar(valv_cerrada) %debo verificar la valvula
        ).



verificar(valv_cerrada) :-  %solo se busca verificar esta situacion si...
    estado(valv_cerrada, desconocido),
    (
        (                   
            estado(valvdeAlivio_ok_con_incremento_presion, incorrecto),
            writeln('Verificar que la Valvula esta en la posicion "Cerrada"')
        )
        ;
        (                   
            estado(valvdeAlivio_ok_con_incremento_presion, correcto), %la valvula de alivio trabaja correctamente cuando le incrementamos un 10% la Presion
            writeln('La función de seguridad es apropiada')
        ) 
        ;
        verificar(valvdeAlivio_ok_con_incremento_presion)
    ).



verificar(valvdeAlivio_ok_con_incremento_presion) :-
    estado(valvdeAlivio_ok_con_incremento_presion, desconocido),
    (
        (
            estado(valvdeSeg_tiene_evac_cont, incorrecto),
            writeln('Verificar que la Valvula de Alivio esta bien con un incremento de la P de 10%')
        )
        ;
        (
            estado(valvdeSeg_tiene_evac_cont, correcto),
            writeln('Verificar si la Linea de gas tiene la Presion correcta')
        )
        ;
        verificar(valvdeSeg_tiene_evac_cont)
    ).


%----------------------


% RAMA CENTRAL-DERECHA

verificar(fuga_evitable_entre_Sit_y_Orif) :-
    estado(fuga_evitable_entre_Sit_y_Orif, correcto), writeln('Configurar la Valvula de Seguridad de acuerdo a las instrucciones (RAMA DER)').
 

verificar(fuga_evitable_entre_Sit_y_Orif) :-
    estado(fuga_evitable_entre_Sit_y_Orif, incorrecto), writeln('Reemplazar Sit y Orificio, y colocar la Valvula de Seguridad en el circuito (RAMA DER)').


    
verificar(fuga_evitable_entre_Sit_y_Orif) :-    
    estado(fuga_evitable_entre_Sit_y_Orif, desconocido),    
    (       
        (
            estado(resorte_seg_es_efect, correcto),
            writeln('Verificar si hay una fuga evitable entre Sit y Orificio')
        )
        ;
        (
            estado(resorte_seg_es_efect, incorrecto),
            writeln('Reemplazar el Resorte de Seguridad')
        )
        ; 
        verificar(resorte_seg_es_efect)   
    ).



verificar(resorte_seg_es_efect) :-                
    estado(resorte_seg_es_efect, desconocido),
    (
        (   
            estado(tuberias_sensor_bloq, correcto),
            writeln('Entonces limpiar y reparar las Tuberias de deteccion')
        )
        ;
        (   
            estado(tuberias_sensor_bloq, incorrecto),
            writeln('Verificar si el Resorte de Seguridad es aun efectivo')
        )
        ;   
        verificar(tuberias_sensor_bloq)
    ).



verificar(tuberias_sensor_bloq) :-                
    estado(tuberias_sensor_bloq, desconocido),
    (
        (   
            estado(presion_linea_apropiada, correcto),
            writeln('Verificar si las Tuberías del sensor de presion y control estan bloqueadas')
        )
        ;
        (   
            estado(presion_linea_apropiada, incorrecto),
            writeln('Ajustar el Regulador de acuerdo a las instrucciones')
        )
        ;   
        verificar(presion_linea_apropiada)
    ).



verificar(presion_linea_apropiada) :-
    estado(presion_linea_apropiada, desconocido),
    (
        (
            estado(valvdeSeg_tiene_evac_cont, incorrecto),
            writeln('Verificar que la Valvula de Alivio esta bien con un incremento de la P de 10%')
        )
        ;
        (
            estado(valvdeSeg_tiene_evac_cont, correcto),
            writeln('Verificar si la Linea de gas tiene la Presion correcta')
        )
        ;
        verificar(valvdeSeg_tiene_evac_cont)
    ).


%----------------------


% RAMA CENTRAL

verificar(valvdeSeg_tiene_evac_cont) :-
    estado(valvdeSeg_tiene_evac_cont, desconocido),
    writeln('Verificar que la Valvula de Seg tiene evacuacion continua').
%Todos estos de arriba son axiomas, invariantes, que representan el Conocimiento



%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------



%B. Ground Facts que definen el estado incial:

estado(piloto_ok, desconocido). %RCI    %Nodo Hoja

estado(prev_fuga_entre_Sit_y_Orif, incorrecto). %RCI

estado(rendim_resorte_valvdeSeg, desconocido). %RCI
estado(fuga_evitable_entre_Sit_y_Orif, desconocido).  %RCD  %Nodo Hoja

estado(sensores_valvdeControl_bloq, correcto).    %RCI
estado(resorte_seg_es_efect, desconocido).  %RCD

estado(valv_cerrada, desconocido).   %RCI
estado(tuberias_sensor_bloq, incorrecto).  %RCD

estado(espesor_menor_que_umbral, correcto).  %RI  %Nodo Hoja
estado(valvdeAlivio_ok_con_incremento_presion, desconocido). %RCI
estado(presion_linea_apropiada, incorrecto).   %RCD
estado(se_arregla_fuga_con_llave, correcto). %RD %Nodo Hoja

estado(valvdeSeg_tuberias_y_junt_sufriendo_consec_desgaste, desconocido).   %RI
estado(valvdeSeg_tiene_evac_cont, incorrecto).  %RC
estado(fuga_gas_en_junt_pruebaJabon, correcto).   %RD

estado(todo,correcto).
%Estos GF han determinado que el estado de TODOS los sistemas es "desconocido"
%Representan una situacion particular del sistema.


%END



%si quisieramos acceder a hardware, un lenguaje como C o C++ seria mas potente. Habria que implementar un "predicado en lenguaje C".
% Permitiria hacer una llamada electronica al sensor, por ej.