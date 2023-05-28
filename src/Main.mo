import Types "Types";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import CONST "CONST";

let CONNECT : Nat8 = 1; //0011 Este mensaje es enviado por un cliente para establecer una conexión con el broker MQTT.
                        //Contiene información de identificación del cliente, como el identificador de cliente y las credenciales.
let CONNACK : Nat8 = 2; //0010 Este mensaje es enviado por el broker en respuesta al mensaje CONNECT. Indica si la conexión se ha
                        //establecido correctamente y puede contener información adicional, como el resultado de autenticación.
let PUBLISH : Nat8 = 3; //0011 Este mensaje es utilizado por un cliente para publicar un mensaje en un tópico. Contiene el tópico,
                        //el contenidodel mensaje y otros campos relacionados con la calidad de servicio y retención.
let PUBACK : Nat8 = 4;  //0100 Este mensaje es enviado por el broker en respuesta a un mensaje PUBLISH con QoS 1. Indica
                        //que el mensaje ha sido recibido y procesado correctamente.
let PUBREC : Nat8 = 5;  //0101 Este mensaje es enviado por el broker en respuesta a un mensaje PUBLISH con QoS 2.
                        //Indica que el mensaje ha sido recibido y se espera el siguiente paso en el proceso de entrega.
let PUBREL : Nat8 = 6;  //0110 Este mensaje es utilizado en el proceso de entrega de mensajes con QoS 2. Se envía po
                        //el cliente como respuesta a un mensaje PUBREC y se espera un mensaje PUBCOMP del broker.
let PUBCOMP : Nat8 = 7; //0111 Este mensaje es enviado por el broker en respuesta a un mensaje PUBREL. Indica que
                        //el mensaje ha sido entregado correctamente en QoS 2.
let SUBSCRIBE: Nat8 = 8;//1000 Este mensaje es utilizado por un cliente para suscribirse a uno o varios tópicos. Contiene una lista de tópicos
                        //a los que el cliente desea suscribirse, junto con los niveles de calidad de servicio deseados para cada tópico.
let SUBACK : Nat8 = 9;  //1001 Este mensaje es enviado por el broker en respuesta a un mensaje SUBSCRIBE. Indica el resultado
                        //de la suscripción y puede contener información adicional, como los niveles de QoS aceptados.
let UNSUBSCRIBE: Nat8 = 10; //1010

actor MQTTBroker {
    type Topic = Types.Topic;
    type msj = Blob;
    type Subscriptor = Nat;
    type Subs = Buffer.Buffer<Subscriptor>;

    var subsByTopic = HashMap.HashMap<Topic, Subs>(0, Types.topicEqual, Types.topicHash);

    public func suscribeTo(t : Topic, s : Subscriptor) : async () {
        let value : ?Subs = subsByTopic.get(t);
        switch (value) {
            case (null) {
                var bufferSubs : Subs = Buffer.Buffer<Subscriptor>(1);
                bufferSubs.add(s);
                subsByTopic.put(t, bufferSubs);
            };
            case (?value) {
                value.add(s);
            };
        };
    };

    func deliveryMsj(s : Subscriptor, m : msj) : async () {

        let msjToText : ?Text = Text.decodeUtf8(m);
        let mensaje = switch (msjToText) {
            case (null) "Null";
            case (?msj) msj;
        };
        Debug.print("enviando: " # mensaje # " a " # Nat.toText(s));

    };

    public func publish(m : msj) : async () {
        let topic = await Types.getTopic(m);
        let listeners : ?Subs = subsByTopic.get(topic);
        switch (listeners) {
            case (null) {
                return ();
            };
            case (?subs) {
                for (s in subs.vals()) {
                    await deliveryMsj(s, m);
                };
                return ();
            };
        };

    };

};
