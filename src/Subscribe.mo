import Blob "mo:base/Blob";
import Ascii "Ascii";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";

actor Subscribe {
    //type Payload = Text;
    //type Topic = Text;
    type Msj = Blob;
    type Subscribe = Principal;
    
    /*  - Bits 7-4 (Tipo de mensaje): 1111, que corresponde al tipo de mensaje PUBLISH.
        - Bit 3 (DUP): 0, indicando que no es un duplicado.
        - Bits 2-1 (QoS): 01, que representa el nivel de QoS 1.
        - Bit 0 (Retain): 0, indicando que el mensaje no se retiene.
    */
    public shared func getMsj(m : Msj) : async Nat32 {
        let fullMsj = Blob.toArray(m); 
        let lenMsj = fullMsj[1];
        let QoS = (fullMsj[0] >> 1) & 3; //leemos los bit 1 y 2 del Byte 0

        //En el body del mensaje vendrá el Principal Id del Publisher y una marca de tiempo
        let bodyMsj = Array.subArray<Nat8>(fullMsj, 2, Nat8.toNat(lenMsj)-2);

        /*Procesar el mensaje y enviar acuse de recibo en caso de que QoS sea Nivel 1 o 2
          A diferencia del protocolo MQTT original, en este caso el acuse de recibo será un hash del 
          mensaje recibido, para de esta manera tener un mejor control sobre la integridad del mismo
        */ 
        return switch(QoS) {                //Enviamos al Broker un acuse en función de QoS
            case(0) {0};                    //QoS 0 (At most once)
            case(1) {return Blob.hash(m)};  //QoS 1 (At least once)
            case(2) {return Blob.hash(m)};  //QoS 2 (Exactly once) TODO evitar mensajes duplicados
            case _ {0};
        };
    };
};
