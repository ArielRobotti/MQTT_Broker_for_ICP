import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Nat8 "mo:base/Nat8";


module{
    public type Topic = Nat8;
    public func getTopic(m: Blob):async  Nat8{
        let bytes = Blob.toArray(m);
        let topic: Nat8 = bytes[2];
        return topic;
    };
    public func topicHash(t : Topic) : Nat32 {Hash.hash(Nat8.toNat(t));};
    public func topicEqual(a: Nat8, b: Nat8): Bool{ a == b;};

 }