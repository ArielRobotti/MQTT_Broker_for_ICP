import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

module {
    public type Topic = Text;
    public func getTopic(m : Blob) : async Text {
        let mToArrayNat8 = Blob.toArray(m);
        let msjType = mToArrayNat8[0];  //Tipo de mensaje MQTT byte 0
        let size = mToArrayNat8[1];     //Longitud del resto del mensaje byte 1
        var body : Text = "";

        for (j in Iter.range(2, m.size() -1)) {
            //TODO Decodificar a ANSII cada posicion de mToArrayNat8 y concatenar en body
            body :=  body # Nat8.toText(mToArrayNat8[j]);
            //TODO separar el Topic del Payload. El payload se encuentra desde la ultima / hasta el final
        };

        return body;
    };
    public func topicHash(t : Topic) : Nat32 { Text.hash(t) };
    public func topicEqual(a : Text, b : Text) : Bool { a == b };
};
