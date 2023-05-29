import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";

module {
    public type Topic = Text;
    public func getTopic(m : Blob) : async Text {
        let mToArrayNat8 = Blob.toArray(m);
        var msjText : Text = "";
        for (char in mToArrayNat8.vals()) {
            msjText := Text.concat(msjText, Nat8.toText(char));
        };
        return msjText;
    };
    public func topicHash(t : Topic) : Nat32 { Text.hash(t);};
    public func topicEqual(a : Text, b : Text) : Bool { a == b };
};
