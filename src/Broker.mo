import Topic "Topic";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Ascii "Ascii";
import Subscribe "Subscribe";

//---------------- Tipos de mensaje ---------------------------------
let CONNECT : Nat8 = 1; //0011 Este mensaje es enviado por un cliente para establecer una conexión con el broker MQTT.
//Contiene información de identificación del cliene, como el identificador de cliente y las credenciales.
let CONNACK : Nat8 = 2; //0010 Este mensaje es enviado por el broker en respuesta al mensaje CONNECT. Indica si la conexión se ha
//establecido correctamente y puede contener información adicional, como el resultado de autenticación.
let PUBLISH : Nat8 = 3; //0011 Este mensaje es utilizado por un cliente para publicar un mensaje en un tópico. Contiene el tópico,
//el contenidodel mensaje y otros campos relacionados con la calidad de servicio y retención.
let PUBACK : Nat8 = 4; //0100 Este mensaje es enviado por el broker en respuesta a un mensaje PUBLISH con QoS 1. Indica
//que el mensaje ha sido recibido y procesado correctamente.
let PUBREC : Nat8 = 5; //0101 Este mensaje es enviado por el broker en respuesta a un mensaje PUBLISH con QoS 2.
//Indica que el mensaje ha sido recibido y se espera el siguiente paso en el proceso de entrega.
let PUBREL : Nat8 = 6; //0110 Este mensaje es utilizado en el proceso de entrega de mensajes con QoS 2. Se envía po
//el cliente como respuesta a un mensaje PUBREC y se espera un mensaje PUBCOMP del broker.
let PUBCOMP : Nat8 = 7; //0111 Este mensaje es enviado por el broker en respuesta a un mensaje PUBREL. Indica que
//el mensaje ha sido entregado correctamente en QoS 2.
let SUBSCRIBE : Nat8 = 8; //1000 Este mensaje es utilizado por un cliente para suscribirse a uno o varios tópicos. Contiene una lista de tópicos
//a los que el cliente desea suscribirse, junto con los niveles de calidad de servicio deseados para cada tópico.
let SUBACK : Nat8 = 9; //1001 Este mensaje es enviado por el broker en respuesta a un mensaje SUBSCRIBE. Indica el resultado
//de la suscripción y puede contener información adicional, como los niveles de QoS aceptados.
let UNSUBSCRIBE : Nat8 = 10; //1010
//--------------------- Caracteres ASCII desde el 32 ------------------------------
//let decodeToAscii: [Char] = [' ', '!', '\"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '¡', '¢', '£', '¤', '¥', '¦', '§', '¨', '©', 'ª', '«', '¬', ' ', ' ', ' ', '°', '±', '²', '³', '´', 'µ', '¶', '·', '¸', '¹', 'º', '»', '¼', '½', '¾', '¿', 'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', '×', 'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'Þ', 'ß', 'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷', 'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ'];
/*
Nota: Tanto la identidad de los suscriptores como la de los publicadores deberá estar determinada por sus
respectivos Principal ID, de manera tal que para poder suscribirse a un topic, el interesado deberá conocer el
principal ID de quien emitirá en dicho Topic y la ruta del Topic al que quiere suscribirse. Asimismo el Broker dará o no
permiso al interesado para escuchar en el Topic para el que solicitó suscripción.
El actor Suscriptor deberá contar con la implementacion de una funcion para poder recibir los mensajes del
broker. En principio, los mensajes que reciba el actor Publicador por parte del Broker se gestionaran en funcion de
la calidad QoS configurada para la emisión de mensajes, por tal motivo no sería necesria una funcion para esa tarea
específica sino que la propia emisión del mensaje desencadenará un mensaje de respuesta del Broker.
*/
actor MQTTBroker {
    type Topic = Topic.Topic;
    type msj = Blob;
    type Subscriptor = Principal;
    type Subs = Buffer.Buffer<Subscriptor>;

    var subsByTopic = HashMap.HashMap<Topic, Subs>(0, Topic.topicEqual, Topic.topicHash);
    
    func deliveryMsj(s : Subscriptor, m : msj) :  ?msj{
        let listener : ?Subscribe = await Actor.fromPrincipal<Subscribe>(s);
        switch listener{
            case(null) null;
            case(?l){
               let recibe: ?msj = await l.getMsj(m);
               
            } 
        }
    };

    func connect(m : msj) : async ?msj {
        //TODO
        return null;
    };

    func publish(m : msj) : async ?msj {
        let topic = await Topic.getTopic(m);
        let listeners : ?Subs = subsByTopic.get(topic);
        switch (listeners) {
            case (null) return null;
            case (?subs) {
                for (s in subs.vals()) deliveryMsj(s, m);
                return null;  //retornar el msj correspondiente al QoS
            };
        };
    };

    func pubrel(m : msj) : async ?msj {
        //TODO
        return null;
    };

    func suscribe(t : Topic, s : Subscriptor) : ?msj {
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
        return null;
    };

    func unsubscribe(m : msj) : ?msj {
        //TODO
        return null;
    };

    public func sendMsj(m : msj) : async ?msj {
        let arrayMsj = Blob.toArray(m);
        let msjType = arrayMsj[0];

        if (msjType == CONNECT) {await connect(m);} 
        else if (msjType == PUBLISH) {await publish(m);}
        else if (msjType == PUBREL) {await pubrel(m);} 
        else if (msjType == SUBSCRIBE) {null /*TODO*/;} 
        else if (msjType == UNSUBSCRIBE) { null /*TODO*/;} 
        else null;
    };
};
