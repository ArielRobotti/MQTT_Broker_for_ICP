import Types "Types";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";

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

    func deliveryMsj(s : Subscriptor, m : msj): async () {

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
                for(s in subs.vals()){
                    await deliveryMsj(s, m);
                };
                return ();
            };
        };

    };

};
